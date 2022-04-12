Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEFAC4FE7FD
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 20:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355149AbiDLScP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 14:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231543AbiDLScO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 14:32:14 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEABB4DF6F;
        Tue, 12 Apr 2022 11:29:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649788195; x=1681324195;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JR0bB66+6gwy0JiROUlOL1M15qFOJdkIaDZiJjES6K8=;
  b=SEFNGCeGbriznr/6q5+w1dOrwt4tzyxKYIJtsCcepHZkENbCyW97WPOf
   hQpr/4IG5vys3nctROJlw/B9I1hGQJA2oGz88WgXne33raEQYfkaW/Eyl
   1tOvkJdi4D3mRKqz+DmOlIhMTD+H7a9nTqt0JunlKEt8ZwyO8OYc7EKdn
   pYty4Gu7BB6YVty/Gclb+Q62MaS28s+Os85EDYueGkATKShtwCFoM9CiG
   gay4ptTC98fJWqk2ivpZybvuFaFoowhFK9viuFOMnPM/3cuJod3uzOIXd
   XSCIg6enjmMI7LtSXD8EW/zO0lm6ESDtcaBrCuw48YHdFwfC0fku4MHLH
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10315"; a="287492900"
X-IronPort-AV: E=Sophos;i="5.90,254,1643702400"; 
   d="scan'208";a="287492900"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2022 11:29:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,254,1643702400"; 
   d="scan'208";a="724580615"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga005.jf.intel.com with ESMTP; 12 Apr 2022 11:29:54 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 12 Apr 2022 11:29:54 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 12 Apr 2022 11:29:53 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 12 Apr 2022 11:29:53 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 12 Apr 2022 11:29:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eehLmVMdv9gyI1xpeiyNCApB/JRsjpfFdel8lAZeA4JQmsmjbZlEZmAfTQ16u/xJT+TsySTdLVum+C/dZc7ezqalNdO5O8cgml4mxYTb7jPedg3GLD4AazLDUovn9ckA4NZYMAsfO9bPGrMBSnKgxmRNcKHgVVJmjsLTSf8Oi6SEyPyySR0dZVZRKeA/2lgnyfW/45+oLP8+IiaqkmqYNOTzFpp+V4q7Y3W8coz7JUp/jGHRDNTaQrLDGEnKfd2LFw2SCtPd/Il5jFIRu2DDYfL41MRGPNt0clqWXS6TvtEEIfbNkEmehbncoTP9b2HlH5OHT2OMdLnbNgRp0czd+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XvYoG/V7UhPV0xPgZnQmyz1baSAyD+tbIjJ8f+CFHPQ=;
 b=PUDXM8anfeXR5RoTvrp9vkSx1AXNvV0o6LhV8Zc6PaYyzSJQoJ9Q/CXCFNVVDjRyio9K9GxpSUBBOmkb8BS2N1X54rHt4LXU58yp62rNVzBJrxraa0CRO1ElkRuFoMiJgqyK+22cp7AkpRdBzWA9YqD46yuxNJ8uTM3QKnxa6q+5oxqchecrkjfRc0A28ry5flOJrB04nbCjsAS+tMg46d0OsEO50jGJhLz3ncFykWnkgECBm4nkD5hGDC5A4bkye8fB+Fgep6N4O17F83HWEtZaExV5kZ8MY+OabJeAaNErSh71I/a/04lks98uhU3KJcezBkCMf6JLepYt9yHGFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by DM6PR11MB3850.namprd11.prod.outlook.com (2603:10b6:5:13c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 18:29:51 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::2c4c:6d7:1a3d:7620]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::2c4c:6d7:1a3d:7620%9]) with mapi id 15.20.5164.018; Tue, 12 Apr 2022
 18:29:51 +0000
Message-ID: <d1d4b35e-2fcd-fa30-4985-5ae58ea6d53f@intel.com>
Date:   Tue, 12 Apr 2022 11:29:48 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [Intel-wired-lan] [PATCH] ice: wait for EMP reset after firmware
 flash
Content-Language: en-US
To:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Petr Oros <poros@redhat.com>
CC:     <ivecera@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <intel-wired-lan@lists.osuosl.org>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <davem@davemloft.net>
References: <20220412102753.670867-1-poros@redhat.com>
 <20220412160856.1027597-1-alexandr.lobakin@intel.com>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <20220412160856.1027597-1-alexandr.lobakin@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0348.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::23) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cc1749f1-d7b6-4138-d0ab-08da1cb26e62
X-MS-TrafficTypeDiagnostic: DM6PR11MB3850:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <DM6PR11MB385037942C731AA2A99151F297ED9@DM6PR11MB3850.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0jlpWAXYCLAUd30iA7AxKGL4PdS60AU2NF9NlYLf7t4fA3lRViCjmsUhbSO2/IeImBy/oa6XDss5UNkRyMbQE5FdCw7wjScDFeibom51vzWkJSsLhetv0R6iMx4b3DPGEBhp+Yf+29SxH1S+g6r83ehH3KfgSZXwbKX3CJuU2R/PQEtNqjJTN2B9Lz+6tgdPI/rpF7nJkg5yKVysmiyiCSLPRTSMfYFnp4ac2+ksqo6HgDUnndWVZjUMrod/yrgxDugUkO+FmTeblkx45P0iH/JN9tPRNYySukRkUK4qxrR86p/slqN8quS1P0O88zGN6kfJJ05vj0KyL1yhvD/5alZPp1W34L52fabIz4sfosSVjLNEeoVgfR6hL0miAspzeI09EGt5pc5YHv/rIxNPnTXPkBstOfDFalqvsMZntmchLmlr8uoqwjQatf9Zi8AFiDbPw31y/vhTInJMiJmA58GnV5+jaTMnec+qSXW/kTskVoyG/UnCHkBXmrzSFa44lUF4F38ot32pmoCE3PYssy3lFHBRNPhKmu4A3SSoz3OuO7MFVocgjNLfjFoUeCbSndZtrPQ4e0teSJwBd8V7vHPRE1c5l2DhgQ95372t8SjXRn4yqf40Kn6vft+LHOhU9zvGJWbD7eqUbvXkbNyvZASL4/5nNaw2bL2+aUtr1uDyod/g0PG6P+7nZboyl4m4uETuYjEa0ZtgoAacdnqw6R/G0E6LQWWFV3fUrP3yQAs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(4326008)(110136005)(8676002)(6666004)(186003)(2906002)(316002)(5660300002)(83380400001)(6486002)(8936002)(2616005)(26005)(86362001)(82960400001)(36756003)(53546011)(6506007)(31696002)(31686004)(66476007)(66556008)(44832011)(38100700002)(4744005)(6512007)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TkdGVjVNOSt5RE1EcGpIOUovMzJjS0ppbjgxMjRtT2NwT2FOK0NNblJTZUZ1?=
 =?utf-8?B?MVB6T0pKSks5TUF4NCt0KzZWK1Azc1UrY1R3cHN1cGFwTmZTTzdoVkRYSytn?=
 =?utf-8?B?K01NcXdhbEFjeUdEMmd1bkNXeXNVNFl4NTh6UVRveklLU1M1RERGd25QV3Y2?=
 =?utf-8?B?RkVoeEdiOFpvMVNXMVUxSmx0ckFhVGFMMnJCaVJaN01nQ1hxaHRvdG1HejJV?=
 =?utf-8?B?bWp1a0pPLzM1WEVheTZXa0tYTkRVdkJyMndmZjVNRUdmM2REOFJjM3JtV2g5?=
 =?utf-8?B?YURKbE0vTmE3c09hME03aTdZU28yNVVyUnlDTjc3MEdqbDM0VFpVa3lNcnk5?=
 =?utf-8?B?S3I1cmZSSDJ4dHc0ZElodWlJaTJOaUR6MHFtOUVWUG01dmtVMUo5REpMQ3Qv?=
 =?utf-8?B?NGpEenlscXV4WWJzbW5CVlZtdEpSRllVMFMzWUJudGM3SDZrZ2FHTG1qS1Y3?=
 =?utf-8?B?MVRqSVJwam1mMzRldUtxM2RQUjhUcWowSUdESlM3RTU3dXp6cjBIc0Rxd3d6?=
 =?utf-8?B?OFFuYWhZZXdJeWY5RVlHV1k2VlllRXJiMW5iclRCZnJTbm45N0ZrWjhVZDZD?=
 =?utf-8?B?RlNXT0tDcXJQZnVBakw2QlUzaDV1Wlk3WEgzWE9XMXFuRWJ4ZzhtK0RQdzdW?=
 =?utf-8?B?SU5HT1FWMGRMQ291ODRDWUE4NFgxa0srcjJMUDIvMkx0SE5rOGR0K1J4amdU?=
 =?utf-8?B?d0xETWJmTyt6bzQ0MDg3VkYyQ3ZGa3VsV21ERXREaG1kc2xtNzRYaDJkelZj?=
 =?utf-8?B?d3pOeUtBRGpLUWdVQWlxZDcwVVhDL1hpT1FqRldtenh1WkRkYmJuZFQwVkc0?=
 =?utf-8?B?a2tWUloyeE56VkZYSURibVZHMFpjZ1YwVW9vTVVoOVdLYUNzZjZjSGVOc3M1?=
 =?utf-8?B?VVhKS3gzNndTMCtRSWhpVElRTThzMlRqWXRHYU9SdkJBRzJIV3JKY2w0T2Rm?=
 =?utf-8?B?a0lNdzlKYVZvLzNMdXJZQ3Z1TTlad1NEYVZzSHp5dVllNnpBZGJiV04vdXZx?=
 =?utf-8?B?dXVmZ0llNDRXMzBCbFE5cmd2eXBxYmJ1dmZsdTRaOVFSc1dGOGVkRWRORmMz?=
 =?utf-8?B?U01NSzZ3cGJCRUpsUUh0Mk1nNmlIM0gvYW1VUkRVRjNkaEVWQkwzUmwvZVpx?=
 =?utf-8?B?ODEzdVBGKzBWNXhCeCtSVHZrT1JSazdMMk9YdGlnRkoxR2pvUy9CRy91ZWF3?=
 =?utf-8?B?RFQzUHJGUCsrNExDNlpuTk9WYlJGSzhYS2RjNm0yT25ubDYvTnQ3SlpkUmU0?=
 =?utf-8?B?MWJia1NZY1RvcjdNdlA4RFJ6aS9CWmdqOFllN3p3MmQ2elQ3RVgwTnE3VEc1?=
 =?utf-8?B?TnpQNG1NbTJTTHBrNmtSd2h3K1NRSGpiUEFhM3k0dm5XMjJZYVh0T3FxMTdy?=
 =?utf-8?B?OTZqeUFHcEg5NlFIZDVDeFE1S0ZQYUF3NUZPL3E5SHN3RlV0Tjg3bjJPMEI2?=
 =?utf-8?B?YWYxdXByWFAxYlJVek1yUTdaOGRIRVMyM3BaYmN1UmVkS3hWS1VsaWFIZ1J5?=
 =?utf-8?B?dVdUN2VJM3lqdzdBem80Zk5ZZURkWFJ4eFRURVk1dGVUYmJCRklFRjlDM2hY?=
 =?utf-8?B?cG5rZGFGRy9mVXZOdVpFdnovL3VTcnJmVWFtWnpZVHBaVzE1RFd2VXpGMDAx?=
 =?utf-8?B?YnNMWXJaTStFZmhwU25FdEEraWdQRnRzRTcrdXNIOExKcnQ3ZVFsU3lPejBP?=
 =?utf-8?B?MWdiRW12ZUdVdk1YWnU1K3ZncDVzNE12YlJnNExmUVR0WlBpUWZJVGEzaVJ1?=
 =?utf-8?B?d2ZOQnBKUllSN2ZLUFAwTE9HY3VUUllFZVZIc2t4L1lCdzJMZ2diejcxTjg0?=
 =?utf-8?B?ZU5qS0NaQ3MzOUM4L3FJbnFiU3VsYkhpVUVGNVV2OEVtT081WW1OSXpaaTZZ?=
 =?utf-8?B?eDVZdjhYSWV0SDZFWVN6WCtoQ3ZnTmQxdUluU2dIemJiU2ZqRC96UWFhbEwz?=
 =?utf-8?B?Z3JyMlpnNUJ4cVlPRkRiS1k5RnZONlQ2VVI4U1oyb3dLRjVYUDJLQzU1U3E0?=
 =?utf-8?B?SzQ2ck5BL2J6d3FkRkM5RnErT1MvNWk1d1lsdUZ5QzRLTDBTWUtTQkl2Zml5?=
 =?utf-8?B?ZmtCRUd3OGZYNHFidjJ1N1pmaE1KclpFS0I1TDNxR011WjJuVHpuQkMvSEVm?=
 =?utf-8?B?WjhLMXp6eWE1YTQ0ZWNxeVIvTUVVSUEyTk13K0lYL3czTWwzZFhLYUVITld6?=
 =?utf-8?B?NmZjNUJSckxKWDFnS0JJRVRvNjdudHV2QitySng3VTJoYmplbDIzanJJS3NZ?=
 =?utf-8?B?U09pc0UzWUNGaGVPRm1BMnRaRWVCQWJtdGlzbWhQVmRvbU1QSHdZaGlCa0F3?=
 =?utf-8?B?VURFejQ5K2xSajFRUTJSZ2VBanU1b0lTRDN0RUtCdmhqa3UwdC9jajlWUW5H?=
 =?utf-8?Q?ZfdAxRYJ472Oi5Fw=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cc1749f1-d7b6-4138-d0ab-08da1cb26e62
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 18:29:50.9478
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ca1wGY9Ia1CLS5jxi4ele/smBptBxgMLFrMrpD6MbnXuOrCmmzpusF+Mi4H5G+dXr+0PZXUzLavAA2/E+64VbaNtvGyW10JmPU3PrOv9xpA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3850
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/12/2022 9:08 AM, Alexander Lobakin wrote:

>> +#define ICE_EMP_RESET_SLEEP 5000
> 
> Ooof, 5 sec is a lot! Is there any way to poll the device readiness?
> Does it really need the whole 5 sec?

The problem with resets is usually you don't want to disturb the 
hardware with PCIe pokes while it's resetting. In this case, this code 
only runs if it was indicated by the update status that the firmware 
could internally reset itself to pick up new updates, avoiding a reboot.

Yes the five seconds is less than ideal, but it was the value we found 
that offered the most stability / likelihood of reset completing. In 
this case the 5 seconds is a tradeoff vs a reboot.

Thank you Ivan for chasing down this bug!


