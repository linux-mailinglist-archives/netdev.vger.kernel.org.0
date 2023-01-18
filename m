Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED9ED672A0A
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 22:12:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbjARVMG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 16:12:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230406AbjARVLh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 16:11:37 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13DF8613CB
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 13:10:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674076242; x=1705612242;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=phEX/qeYHfWtZgvZL/W65pFKrU/PkmlwEziZNkyGp1M=;
  b=mmQSvCrVtYwY6cZ4dH0aGv3jPnAbVEsUAFWmuh/oa1zQvm3KD4X9IxMH
   26JwZzXl1wO69Riv6eizma/fuzOuexXf2tMc0Cud4xACJpgwa6GgKWwWo
   qRZ5UjAQkeSuWZIAEPV/GCvaSPRMefE30yViU1GMuc3esLxCdVmLtT8p5
   a/xFMXz/sB17LXjCryLJXCUc0U7rPVGCkqtvxhvTHchKDw4mSG5E1ESnB
   HfhEig4QyOeNyARyazuRaeE2t1Ubv/yNeIUnDdiqyqbx2XoOLIv109+PB
   XwFutaqszhdhUUOHDMd3NujjHesbY/YzI7WUxNVRBXcPgMiTQzf5pOL4W
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="327175767"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="327175767"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 13:10:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="767919029"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="767919029"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 18 Jan 2023 13:10:40 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 13:10:40 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 18 Jan 2023 13:10:40 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 18 Jan 2023 13:10:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T+F/Ls9dZqJ4fV1l6pxbL2CA26Y7sMqML3mZNh+LVEL8lh8BI8Pxx9sWVDjqEduSGU1FnjkRa/2TUR9/mBtktrUh/4/b0T8zDYWhCVb1XwyZFY/dDJPxpRowhdiTRq7kTL9Wf98bEQFiKchkPGE9rGEKFwPDCYemwB30PtgN1CxnkYuAcNu0bw0nOwmCl94kpG91zb1nCy7CR7dU5JRx8ngtYhLGM50+ZI12StEGgsoa10HfVEXha5Us5x65O78/2u21rkPObedEvCXSIBE7eM2Q3l61zfK4LBiR9nPhvj3uc+4vIrlj5NOazyqzFW3llsPZ6mz51HhLHYURmjgQ1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L7m6bZzjdJD1Zl4+B/RheCnhfMZhLhXU8A/s6xe9+LM=;
 b=QwIfn964c2N6ZAAKY82rGtT1aNgEHEAL5Fm/OvSvL8qPEA9DkRped5ihSZ5/QYk7yS2x0DDF5Dqcq/zcCQ/MgJzwLe8fVvganwd9m4H6Sy8TZNLdpOUEG/oXZ+cO0c0mTVW3v/1ykVTyYKjEo/iYfNiFNN2ZNv062Lzq/GIAIfXtZ/UxONavpa4vjBA12QJkGiSsXhdGXV1h7qhHV785p+t9zMynsVcQT17qCkGxllir7zKvTM3O2pT0w8bgdhXZ24O4vbQeFWUT/vCxpUNPp03EtgMQ8uTZqzA7Y2dynsARHJyI8UBdBGHy1/xvOU6GzQGn/bGOWPkfdUpgn2Q17g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by PH8PR11MB6564.namprd11.prod.outlook.com (2603:10b6:510:1c3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Wed, 18 Jan
 2023 21:10:38 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.6002.024; Wed, 18 Jan 2023
 21:10:38 +0000
Message-ID: <61754ffd-c233-8659-2a45-9dca79048c8f@intel.com>
Date:   Wed, 18 Jan 2023 13:10:33 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [patch net-next v5 01/12] devlink: remove linecards lock
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <michael.chan@broadcom.com>,
        <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        <tariqt@nvidia.com>, <saeedm@nvidia.com>, <leon@kernel.org>,
        <idosch@nvidia.com>, <petrm@nvidia.com>,
        <mailhol.vincent@wanadoo.fr>, <gal@nvidia.com>
References: <20230118152115.1113149-1-jiri@resnulli.us>
 <20230118152115.1113149-2-jiri@resnulli.us>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230118152115.1113149-2-jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0034.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::47) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|PH8PR11MB6564:EE_
X-MS-Office365-Filtering-Correlation-Id: 20b88f74-2542-45ff-56ee-08daf99872b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c0aZUjvmMdIaEnryh8mlJnQo4q9gGIvfjw/A0ylLYDUSgUihrBOSBbZNVqTTT1Cho+apY2Dk9+UHHyRj1s2nUTgmsgfu4+p8qU4bX2IUvoCp7DwPynnP29KYd8ubIWoYs8gqPhlc/qQ6TrvKsBW1WNCEm+SD9IC0CzLM0NEvsx1bZomkEbSfxG29KzdjJk6dpjEaoisHPoaCgtEteyVhVIaZ0s6rTFKmtGKb97Q8YBdEHvZKNTeU4b5svcbSBahfKhRaPqvhrQGAeTexthKLsCVo1/TAUuMu469wjN8fUyRLJLCNqBi1VIP2cOirYGwo6E873OqqlBBebrgLsWnMe73GCGu5ZvpgHDh9b6koQ2vbC/pXOeKTy9ecA+vp/wh/r3gcdQ1eXQPCXYEL9Zg2ZEspQBp7E5Xf3OxVDjWFsyyX/MWdH4yl8fXmAZwV08YGyOcmDQhEs1sIVFP2CsuBXqypb+PlMtU0HePK0Tx8KgDeDiW5frHu6MXZYbWeWQpyBXskoM1ZgXT4eHHWWNA2ko9tQdePDSBX/gZqRWjhfJZG0GlQv/E+bBxeiQo49kmCaNGGpHGQGHQSTOZIvcyQlNKtU4GSEPB3RPC4qXYSW1BHfWUklDTS43Z/9XmFtf47qS2lYMC+OMj4mDmO7RrL2HjFZrWMUrloZUpeFVvBWCXgNAq1tx3YETcZlUoe3BpqmvCD7WJIQhkP+0mMFdxxRQVcKlK81/QgGGlvMBr2Y6M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(366004)(346002)(396003)(376002)(451199015)(86362001)(82960400001)(2906002)(31696002)(38100700002)(31686004)(8676002)(2616005)(316002)(4326008)(36756003)(66946007)(4744005)(6486002)(5660300002)(66476007)(66556008)(53546011)(7416002)(41300700001)(83380400001)(6666004)(6506007)(26005)(478600001)(186003)(8936002)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MTc5MTI3Uk1OMXZLdG1Eblk4akljYm1uSUNnYkNndnQrb1NUaVg4Wm1NNUFx?=
 =?utf-8?B?WE9tRS9IbWR6cmxQTXlIakl3OTNqczcybUwxTVdMczRndjVubW43eHlKZkZX?=
 =?utf-8?B?R0NuSzJLVlAwcTBLTnVsN1ByYVJHdWp0NkV3VjBkRnJRc05SVnpsamVRV1dN?=
 =?utf-8?B?WVJQZUF4S0l6T2ppU3JxMEN6T2FJYXJ1UU1XYzBHNGZiOUZtNXUxU0p1V0VF?=
 =?utf-8?B?TG00U0dMNVExYWk0MEZVQ0dWYUV0VXk4UVlyZ1RoVGRjYzdLS0l0QXFYTU5l?=
 =?utf-8?B?SEhiNnI3Y3JIaTdtNUgwYk9KUFEzd1doWkRwNWh5U3gvSDdLUk5RZTNVa001?=
 =?utf-8?B?NEZEZ3h0ZkQ1eWhKYkZVaGJmbzdJaVE1R200QitTQVZUQllVRjlIcmdGMVVa?=
 =?utf-8?B?QUduYThtb3lTeDdrSnU3S1VpOE9LVlk1VG1yL3ZYMVN4Tms1eUJUYzhhUVg1?=
 =?utf-8?B?dkIyQmRaV2syWlBRdlVyRjBOYlNOSnhIQzBiRW90b0FBMkkybTJSbHlWaTdj?=
 =?utf-8?B?N0pKYUJVemRiMnhyVjhCS0llaEVjK2lLRW0rSXFxTDBVRXpObldLR3BDUGNs?=
 =?utf-8?B?NVVoWjRDYVpTcVpkMk85U083YTA1czdTNnpZaDF1MDRrRUU4RElKeEM2bWpW?=
 =?utf-8?B?UTA4NzA2Lzc2NkdSd0Z4L2JLZUNpQ0FNcEZNR2hjeVFPTTJNM1RPQlJxelVB?=
 =?utf-8?B?M2FCRE1UMlJRck85aEVrczJ3N3czSitZTnBFaTh5RUtiZkNoV0w3VEpMOEMz?=
 =?utf-8?B?eFZxQkNPVzhiODJLdDdQbjZqUTN0d2lhYVNHSVI2Y3Jha2VHQjJNZy9NdzN2?=
 =?utf-8?B?VTNxTEk4NmlPdlJiTytDMGMyNUNKTnFWUW5jT1FVMVdEQ0Q0c3FWREFpRVMy?=
 =?utf-8?B?eDF2RFVublNEV0Y2bGpCMVU1UndVR0NhcnhMSmtPZng2NEM1Q0h0UExsL25O?=
 =?utf-8?B?S01CVHpSTEhieTVUL2lJS25Ham42Rkt1Z3ZTNzdhUm4xUlA1S1RvbkliYlMr?=
 =?utf-8?B?SEgycFZzc2dCVHo4c0pOdE9ybURPdmdZaDZWRjdSUGZtdnhLTkl5UmtXQXho?=
 =?utf-8?B?Si9VNnlFL3ZjS2ZWSS9KSXJWKzFvRUpWTGJ2RFZRVjR6ZnlVeTMyNzhSek5x?=
 =?utf-8?B?L1VUbGxlMzJuK3FzZHB5U1preGVhM3p3NDFFRTQxVVFVR2RVY0dEeHpHUFBZ?=
 =?utf-8?B?MGdua09DRXIzM1lrckhXbjZzdjRuVnpXWEM3dkMrdWdCNTVIRUIxRWhCTEgw?=
 =?utf-8?B?a3kzVjdyQ0ExR2JsdGVVZ29WVklYVjdNZzV5cXQxM0ZQbFNaM3JsK0ZsOVF5?=
 =?utf-8?B?dmZ3ZitrdWhuOWpYbVFwT3huM1IyUWszb3oyWFdjU1l2dmFncnNuREQ4MGJP?=
 =?utf-8?B?cjZudFp6cXpGRkt5V0lXL1VCOVhwS0pJL3VmS0tOelYxcllyaXZkcXluZkNJ?=
 =?utf-8?B?WVhmSVpjNzExN0JEVERqZGRnUHdSMkE2RnBaNnIyVjFjWFFGNG8xUEMvSjEy?=
 =?utf-8?B?VzNLU2l3WmpYamU0b1pWa3ZjYWFTK1FNRE9nVmhRZzRpUkI3WUM4ZVgrT2RT?=
 =?utf-8?B?NUZ5TktwamdZSW9FQmNEQ2NWZmJXTHI2SWZHSFB0bzNIcUNNMjZqTFJVNktS?=
 =?utf-8?B?Um04OUlrNEtaL3hZMGxxMW5kaVd4MEdoTVM1R1pyY1JRWlFqL3dFeEtyYS9S?=
 =?utf-8?B?dit6enZTRnRoWmJtNXE1WWNRZkVIWGZkelViY2FKK2kxYVJOTlBnYUdpOCtW?=
 =?utf-8?B?ZTRKcFdDQ0tPRFlFOWplb2tKTXhDOVpqdWcyWUtMUEN4Ui8xZ3k1MnovTVZo?=
 =?utf-8?B?NCtLL1RCMEM2QTk4ckdaR2xDWDJUNXV1VzhRbURyTGhkSnN6M3pieUUvUmR3?=
 =?utf-8?B?NHcwZ3oxcjEvcVF1SW1HZXk4UUh4WE9PalBMYmwwS29tNDRXWmJ2UTdBZEtN?=
 =?utf-8?B?eEgrbWx2WGFkZTVPcmR4a2JxdUJsdTFiYXJmRVpQOEFldU40V3ViRmo3Rkha?=
 =?utf-8?B?NmJ5RjlHdTlGZVM1UER1UnY1bHI0RlAvL2NHODhFajUxaEtKbGF4dS9pM2E1?=
 =?utf-8?B?NzZ5VmFNWmx5N1VqeGI4c0JxZVpGUDN4dHhDV0Zmakprek92ZVJ3RWJuNElF?=
 =?utf-8?B?TEI2L0hURFJzaUtvK3Jia3FkMFlkQjBTQ2JZeXNkdzdoLzVGYkdiZXl0b2Zy?=
 =?utf-8?B?b2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 20b88f74-2542-45ff-56ee-08daf99872b9
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 21:10:38.3315
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q0UouW8/NISVz7eT51g8tuBEFGNkPOoGyXGEh/hX95C0YqJ06Ov1Yw6Y16FImv/IBuc3pxQeHGLKqBMFw4CNvIHf7aGlw+JYqCZw+LyiIYw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6564
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



On 1/18/2023 7:21 AM, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Similar to other devlink objects, convert the linecards list to be
> protected by devlink instance lock. Alongside with that rename the
> create/destroy() functions to devl_* to indicate the devlink instance
> lock needs to be held while calling them.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
