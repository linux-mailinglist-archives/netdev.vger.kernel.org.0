Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F102672AE2
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 22:51:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231290AbjARVvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 16:51:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbjARVvk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 16:51:40 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4602064DB7
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 13:51:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674078696; x=1705614696;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tQsxs8kS2wtBDNFVRqDK8ZWFehbJCuJNmLlWo0UYmTM=;
  b=FX87SiVu7cDA0iQfxbLeeuJqpsa6VW5RhcU2W8UIcpb3Kz165vHfm+8I
   NsZDg04lMJu2Y0vS/D2fLJ2LsB6A6wN6kvSkAuQ47wO9lrlqeTQJElFv+
   Z350fQnhooM3ULr7DE0bpzrsrSqh9SdKNvxOD9C71DgzySDnRD2cKO80l
   N4JubOZ55kS6mKvflw+UwXYoIdDKvd8qXE+6jmoMvEYN6zJFRWDLJOls5
   kH2rBqLAX3el1lpGlANNp03cX7ScZgSfP7bxw9h/oBtahhVBCDQ+jE6e2
   iBkDwbuSlPaTQ+q1QDU1VMk4NlbmMAQq9VbCetEma2bHxY4RHExhFiR1t
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="327184348"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="327184348"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 13:51:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="905281391"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="905281391"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga006.fm.intel.com with ESMTP; 18 Jan 2023 13:51:35 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 13:51:34 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 13:51:34 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 18 Jan 2023 13:51:34 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 18 Jan 2023 13:51:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z7PiA7BKk8gVUqGxx1uCTfsj4SYywrqW/2Fx85fQHm8Eg6xFWwYHVhWIJHSR3Ty+wj/4p3l9v1xLzE/IuqhjzvV/auPprfoJ3aWlG7EjGyZOST5N2ypKZGbaTRNZV1Yvk2exJEF3i6VE15oLPFJbbXg+pwqrssR+y5f4owj/TxsZN8JGpUM2Rkd0YADqlDAbB+JdrKmb1GO/SwnnRz4zCimVhYV8AkeOfBMeDvfcrbgRDvWY90OZIQ8TaTRMwGqrwZBsxnHerT4f8bU7KZSq6fDoETN2E0cTnsNzPVX3/HzJ9sF5RQdYHIMBBkLDjvcuCkvqSGyD/oCOdtNcy3Hg1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=knB71Snj8/VcgfIkf6t8Yk/vsnONEyVv+QLRf2lzGyY=;
 b=WIWe8xtdFSj93ly742OQA6M69OkBi/d2p+RJnYnXTIrZv4ou2GO3CdMLZ0a9hRXp+WSDALK6CMYqKcWE+ag7q1DZ/LvWPKfWk+KuizQSEB+Vf30h+WTLxlcgGwhuxK+Or0KrlCfXBIFhbdEzgeRXPA0h7IevwIzLKF7nz1tXdObpAmuwCXgiMEBo3xBKpyT2/ZKgziTJ/8JYOKHTIm5zYCdUfIjj7OmoZo0R1h7pyzjF/dgGrU0gyQCKXGuVs4Lkoadoq6wUPIN0jL47SbcjoSNpuRsfrMeAOamwViQP56j0D0BWHWorCjHUCND5satFTywGe1AGPCjxU6CJ4r4Njw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by CY5PR11MB6284.namprd11.prod.outlook.com (2603:10b6:930:20::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Wed, 18 Jan
 2023 21:51:32 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.6002.024; Wed, 18 Jan 2023
 21:51:32 +0000
Message-ID: <1b93df01-e8a7-5446-7aac-a1192f49d5bb@intel.com>
Date:   Wed, 18 Jan 2023 13:51:29 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [net-next 15/15] net/mlx5e: Use read lock for eswitch get
 callbacks
Content-Language: en-US
To:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
CC:     Saeed Mahameed <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
References: <20230118183602.124323-1-saeed@kernel.org>
 <20230118183602.124323-16-saeed@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230118183602.124323-16-saeed@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0028.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::33) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|CY5PR11MB6284:EE_
X-MS-Office365-Filtering-Correlation-Id: a6013886-f3a5-462c-e076-08daf99e2975
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AjQDvRXMeCpCAXjVsuS4fO9kKLP37qzAFwYbc1LCvQl5jgam9hPD2ICvtwMf22FWnKot0Q/tsQ0C3NpafA5cneev/O9i1MWW2mQK/gqdkW8CslHY/8IZki33nZLKR4Thg4PcXoOTNuAxGnmS9g133g8zH9OQcozeCm0LMPUFM+xJQRzr66cBLqAq5OzO3lQXo3K/1teatELHTupvyAnDbUXUT4uTilhuUz8L8plo67P7SlqPE2/B5Oi3JendX1hTfhXWIkOxrvb1TJrE+awCsilrjTwN33ZB9wKbTUJ4/40I773dFsNc1tv3jberzARutotITxN95FYPXUTKrpPlM7LwbnDrvjHvalJ0s4Kh8vJjkzEm78JJhohlSyLDZxBxcJlEu86XwdEQjuVPB/+qaCBzWfsbe4NASUshopMxMwkn6LWxe5TvM8lsH6bLuKj56Dgmr/0BJmemhlxmzTbWxZU2rIK0tDwgWt9HvgxIha4cmsdMfmrYbI+X7B64WVduMcH4FT0pbYppf7KC1DvlriBZiH0TrerO0QSIx9mlM2mEld6JZINOPeP3BOO5HHZaO7Zwo00WlVY9PLXCiK5hIb2pGWf8DWt8Ufone3Z7W33q3enZoZe12Q+3O3l9ZUhN00sXZWw7WwJb1LmNuOD+JSsoftal4imYvII+fil3YlDt1UjcEKYIeab0n3X3LnJOzgyz5c8W8gcoKhTjz0NOc16GQ9l+CHfSsPSN2lOLExI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(39860400002)(136003)(376002)(346002)(451199015)(31686004)(86362001)(4326008)(2616005)(66476007)(41300700001)(66556008)(26005)(66946007)(8676002)(186003)(6512007)(31696002)(53546011)(36756003)(83380400001)(5660300002)(82960400001)(478600001)(8936002)(6506007)(110136005)(316002)(54906003)(4744005)(38100700002)(2906002)(6486002)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bW5veUUxSmF2MmRnejIyUzY4TUJKMGkvU0IyQUxkclo2cTMxMnlWTTJVT0U3?=
 =?utf-8?B?TUxWNnUrRzZxeFhvdGswUldrQkh1YmozWEs3cmRQdFBQNEZMQnFKSmwwZTZj?=
 =?utf-8?B?ZGx6ZXV3OEhQSVBvOFFkRUJIZmhSNzVtUzJRSzJZMHRHREp2WkpITTU5cjVv?=
 =?utf-8?B?cHdtc29VUi9IdWQzQnM5ZjhaMDZYcFdXNlVpL3VhRUpsWjI5S2dQNDdnQ2FT?=
 =?utf-8?B?QmM0RDBOQXhYM0Q0bzF2TW51emZoNkcxc0ZJbUlDYnQ2U3Y0WWg4ZnVZQU5t?=
 =?utf-8?B?dk14ZmRDR09RdElES3dVczRRTlR3U1ZIMktQdGZOL012Yk5LVW54NjJ3OGhD?=
 =?utf-8?B?cFRYMDBmVjFNeU9XTjZQL01uM0c4bUlTR1N6WCtTbGVXalVQSVZqYmZuakFo?=
 =?utf-8?B?K2RKMnlkdUJTYldlTkU2MnhiSUIyYkpraE9SYmZpUVQyRkh5ZG55UWJ6WGdi?=
 =?utf-8?B?REJLQjYzWXhabkExZHlGeXBLUFlybUVIUEtIM1o4aFMxUXZJNUNqaXNMTzlL?=
 =?utf-8?B?dUg3SXdDeGtKckE4bjRZK0xxNXJHZkxpWStjY2laV2pLNTVTSm9MWmZDdGdK?=
 =?utf-8?B?VTJ0YXFMRHlubVo0Y2ZTb0k4cHBMWGNhcHBEK3JsZnZ2Z1VpQThjSU5IYys0?=
 =?utf-8?B?ZjZhYnNzYXl3eFVncnhWQmxpczZWSkx1OEpnbGdiUHFVV2JiTFZIdGFqemtr?=
 =?utf-8?B?L2l3SkV6NG95VmlPek5vT21oOTkySk5UdU5kdzhEWmxKaDhmdDVYOXJ4OHVy?=
 =?utf-8?B?WmsxbEd4SGxkdjBEQTFSMEx6Rmo1a1lwNnN1WDZJK2gwTVlOeUFvcGxUUVVM?=
 =?utf-8?B?SWFZSHBKN09EdjBlWDZCa1lEQWRLS2NxYlFCQ0IrcWdvS2llYVl6ekh6VEZz?=
 =?utf-8?B?Nm1DRDBoWWdiZkJVWEdNYVVNVmVVY21NaVlUN1ZiclBlR0ZyQjhrK1VORVlX?=
 =?utf-8?B?NVN2eDZ3czJPVXVjUmVKZFpaSmE4MjJkcVZta2tzY0U0Q2JRSG5ZQXpQaU5x?=
 =?utf-8?B?cXhaR2EzUXZiSjc0SFR2anFLV3R5QWFzWnhwTFpFSWJIbDlkUVJKNUVCaG9z?=
 =?utf-8?B?OWNTRGJOMVEzQ2FJY0NYUEp6RG5xcUxFNUYreFN2QUFFVVVsRzVFWXI0Vk90?=
 =?utf-8?B?ejdzajRXV3BGVzZmaFVMRU5iU1NNNk9EWVhPU2dtZDJBV09zcTQweUFNYity?=
 =?utf-8?B?ZldrV3JacU5ncVN1by8rbk5UcWROdGpxOUxRWVZWM1hVYjhId29TdXpselhF?=
 =?utf-8?B?YmZSaUxocVRZWjRZYWxUS1dBMlFNWTQxQWlwWVhKMDdPRmRCclo0aFdKNnNw?=
 =?utf-8?B?akNTUExHUHkrMm5XYi9wSU5yaGVzcXVVcEdTOHZXY1lEYlhFMTRPVGZscTBZ?=
 =?utf-8?B?OXJ3N2xLeHdtczl1VzBQdFVMZ3lwNlZJNGt3QVMwcGxxVmpwRGhqUjNaRGdF?=
 =?utf-8?B?cHN5Nlg3MXVHTXdiVHVEQjhMSHRaSFc3MVg2RTdMRlJiWExWbURyUy8yemNn?=
 =?utf-8?B?NjBZcjVJT3ExODFxOXVKTitldmRmY2VXZ0tzZkJoanhra0ZQSXJuKzhPYWgz?=
 =?utf-8?B?RjR0K0tTc3Foa2xCNDBnVXZNWFpGRlpWd04vUkd2K0ZPTm9UcXFEYkl2eWU0?=
 =?utf-8?B?eUtpN2VVc2JyVlhUaVUzR3VtM3dvSkdSMGpmU1pVbmNwQjZYTWNkRG1wWHhP?=
 =?utf-8?B?cGk0L0FkdmxFWTFaM3kvSDU2YnVFVGpEb1BVZjdZcG96MFluRlJVZmlKcTJh?=
 =?utf-8?B?TWdmMVVEMFBsVndsd0huQkRFckQydGhFOWNwNkFIVFovQnZwdkZ2UWt6REhy?=
 =?utf-8?B?VnNqMmZITGJPZVF1L2hsL3RONDAra0xZTWJBc0dkTElsNEQwTlowdWhTOElT?=
 =?utf-8?B?ZGJSMjhxL3c2TGszWG44S2lEOGE1dWcxYktpZXhjMGw4dXpsT2ZSTFNBd2ll?=
 =?utf-8?B?SXFvQjg2VnVvMTIyTDg3QjdFZ0o4dTVoQW5DdE8yYkxpSzhNaWticDh5TG1n?=
 =?utf-8?B?VnUrRFMrVlFzeEltKzRCTldmQm85RVNrU215TEI5TmpicXBUOTJSVkUrRmd1?=
 =?utf-8?B?ZlJxZng5OFJaQ3prLzR3RnhBeVNyQklFNVYwM2czWTVDdnk3U0JseXFURFFK?=
 =?utf-8?B?dTdPemU2NmIwOXgrd3djMFhZUW4wSmtwTHBlQ05LeE51eXhNUEYyVDF3aVZT?=
 =?utf-8?B?S0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a6013886-f3a5-462c-e076-08daf99e2975
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 21:51:32.4586
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WoqJV5h2tMpd2e8QgVmTWHX/7KN6MkP2NbRsU8I0fmCroudXjOmtf2HaqnlVjp9IS3Kjw9jRaGrX0PMBWEDjCos5MnTb/nFo2hwFRoLrexQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6284
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/18/2023 10:36 AM, Saeed Mahameed wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> In commit 367dfa121205 ("net/mlx5: Remove devl_unlock from
> mlx5_eswtich_mode_callback_enter") all functions were converted
> to use write lock without relation to their actual purpose.
> 
> Change the devlink eswitch getters to use read and not write locks.
> 
Makes sense.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
