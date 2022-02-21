Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F16574BEE46
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 00:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236741AbiBUXYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 18:24:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231261AbiBUXYT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 18:24:19 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2995424BF4;
        Mon, 21 Feb 2022 15:23:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645485834; x=1677021834;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FLRLk/njUTBXC58dZn0LVYPpEz6cutMb0YzBJUEZfvI=;
  b=hYGjFS2Z+fjIsJgyEVYkhsFubc+CpR8m6o15lDHz2Bid3UagHT3mnBF6
   mD6rybnMKMY9KyRbptCtgkbxcy8X82wQ8hxztwHjVbWruB6wKTYzLvwDJ
   PV9GHtSoUQDLonxQpSeLg5+ZDlDk2kXrCzvHUPBpqA+154AdIKiuvBKtv
   n2kqEBTSkp8xcqHvakYWyx2W9GCIXFAUnA6oNEjWX+/SWfKT4LgKPJdan
   R4XKjV20AUDsJr81zu/GaJZP1SagQFf/jGaBAA2WNl5uMvd0hX645LxQm
   ylV94tD6OXZ4X4B78+NhXO3tgTv8PHwjIHJqNA561038aFId+Kn4XQh/6
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10265"; a="276174536"
X-IronPort-AV: E=Sophos;i="5.88,386,1635231600"; 
   d="scan'208";a="276174536"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2022 15:23:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,386,1635231600"; 
   d="scan'208";a="683319571"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by fmsmga001.fm.intel.com with ESMTP; 21 Feb 2022 15:23:53 -0800
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 21 Feb 2022 15:23:53 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 21 Feb 2022 15:23:53 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 21 Feb 2022 15:23:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e3kucujRPDgYygmi5r2/XawhwSZxvASadDBCUotem1bEUJsDj/xDrSqS+XzSVavUQLbVimWMbpSB+UvFN235e94bTJmaUBozd45byLCa44ShCPIdrRLr3ziU7fb9FdnpC6DRW0t2MPgRQiGdip43ESOliRIdC2FKITpfaYVhsmbcSfcLpjnTyZbfBk4txrC+HwNR/Sr3aPnzu+B7I6WxmZk/bkkw2AzcFEFrCain/xVRC1ICkvog/tGvQDcyN2qXQQFID8Lj/weBjQhA5bBF7P7Vdkf7E0hwPQljZHIWNZ0+aVavNhQwW18rO8cIW0It/HsmcGXV/WKVl6ghZnHRMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nN5+SfYdn1dH6TsVUuqP0dEztzKoJi7h7A2DxL3pBrk=;
 b=SGYO2hS94n9iYmEWpl+ex8gP4lUEKGveVRJNaxV+Y67wFfqqHcyi1s0OmUSW/3xEhYj2w2keCFEYm8sAB1xXzmEXGlEZ37zLR3ArZ9LR3IoRe/PD8XRijCap6O03Y+RDZqybnH1SGmHck49BpoAJwW/hz3DFIsGEUeg4cJ9fqPNTCb7qY8CFkx/wFxlCUZmJONPvTsG8ofSzYoWXoB14cn8HUHpz5mk9uolG3jxRK2yN02E42Eib77/ZaGnri75mHEokRdzstAynPUrtDCk+nI4GZ/NlHbgrvNZnmYFDhUs0LKBqVCEJ/pfSuxlaoDGzyYn6gYhubx97Y8pNiUFM1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3180.namprd11.prod.outlook.com (2603:10b6:5:9::13) by
 DM5PR11MB1593.namprd11.prod.outlook.com (2603:10b6:4:6::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4995.19; Mon, 21 Feb 2022 23:23:48 +0000
Received: from DM6PR11MB3180.namprd11.prod.outlook.com
 ([fe80::11f6:76fa:fc62:6511]) by DM6PR11MB3180.namprd11.prod.outlook.com
 ([fe80::11f6:76fa:fc62:6511%6]) with mapi id 15.20.4995.027; Mon, 21 Feb 2022
 23:23:47 +0000
Message-ID: <07c740c3-434a-c88f-2ae4-268351bc3005@intel.com>
Date:   Tue, 22 Feb 2022 00:23:40 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.6.1
Subject: Re: [PATCH v2 00/11] drm/i915: use ref_tracker library for tracking
 wakerefs
Content-Language: en-US
To:     <linux-kernel@vger.kernel.org>, <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>, netdev <netdev@vger.kernel.org>
CC:     Jani Nikula <jani.nikula@linux.intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        Chris Wilson <chris.p.wilson@intel.com>,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <20220221231705.1481059-1-andrzej.hajda@intel.com>
From:   Andrzej Hajda <andrzej.hajda@intel.com>
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298
 Gdansk - KRS 101882 - NIP 957-07-52-316
In-Reply-To: <20220221231705.1481059-1-andrzej.hajda@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DU2PR04CA0050.eurprd04.prod.outlook.com
 (2603:10a6:10:234::25) To DM6PR11MB3180.namprd11.prod.outlook.com
 (2603:10b6:5:9::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 077247ad-8cd1-43ee-372f-08d9f5913606
X-MS-TrafficTypeDiagnostic: DM5PR11MB1593:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <DM5PR11MB1593012DD651A938E9A89D11EB3A9@DM5PR11MB1593.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YrX81CrCjE9DtejvzQtC2fLhsMuvnEVyKque3A4mf4EMPchDF5XMxuRBJaRscNMk8IB2Cye1sWRRvThR1kHmJkN4M42zPe3pvGP23Ou2FNd/7NICkivAt/Vn+yuwX0itVxQfvWk9x2CJFqaH/MMfMen4d6NPKZNuqyk9YKeuOb2e8uDbI43mJPFr6Ky9Ixn7fgqYeyxTgyFIv5Gf0q7wXnr1nY/I2lBZiHJxpYFsGnf4ZxR8KtEPlVE3d5eVtKpCc/2phAH6fSuvjA4PzFdxwH5iy6b10STn42lLB4hvIR9nMSUN4GUqX1LkOZ7NaiMgwzuSedIy48RDVH5G62X1u286QknRZExErTOweN7yKxjIpSj2Z9ogb81GFUx7eq6RW+dUxpTmLt6a0Xz3VjP16DMW5k0h8HsYsc4SWIj0KZ+tfbrswceEb1F2uvHp6LDop3EGN2pYyel+xyFxZnvzZrCLkEYeTI5I0oNXGod5lraEbJfQUqVMH0Fb0GfPkbI0dN/bOdJx2Am1EPcdvBsV59GtM9dHUp4U+kv+7JqAR+yesc9FrmRx4ytYHDwGNgXQMfhSDr2mPSp/A15YHTTMaIiMMzBTxeRpy+ZP3/OLd2DmozjUFzYfmstrggfUn0gLX39DQk+DQyRe+8ARuIqVuXFNPcsxd+lizAScQVAhs63gFlsAFYu3Vv4SivrBTJM/F86nA+5Cpsyc0vVcGfVMH4PiPxWkxsi32AhE904RqwU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3180.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(53546011)(36916002)(186003)(66946007)(66556008)(6512007)(6916009)(2616005)(6506007)(26005)(6486002)(31696002)(54906003)(508600001)(316002)(66476007)(6666004)(86362001)(8676002)(82960400001)(4326008)(38100700002)(5660300002)(8936002)(31686004)(2906002)(36756003)(44832011)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c2NpandPWCtjYWJwQUlDelhwbGZJbExyK1l3TFFvTVR3YU11MU9pUU03NEhP?=
 =?utf-8?B?ejkyZHBXS3ZCb0Rzb3VKakRoYkdZL0FOTjQ3a2gxbGtQbDRCT0VIM1ZlbFBn?=
 =?utf-8?B?c2VZR0xrUzByc3FVSVg4Qmk2T21qamNlMHdoNHRGWklKdEpwQ2hyL2VqZ0Vw?=
 =?utf-8?B?RW45VFVzcU1RTExyY3FlejJrWkNVZXlqMkljbE9LY1p5cXZSRmFkQ2ZPSnhU?=
 =?utf-8?B?LzdNLzNndllrSkFSQnNReVdmZEFvR2hLamdMa1JqYXBxTVRaOFZVR2hTTWY1?=
 =?utf-8?B?WkpMbnp0M05DL2J1c091YkFDYWR4dFBSbE1RS1JrM3ozZ3RyRTVCNWFVUk14?=
 =?utf-8?B?ZkdQYThNemhIc0hsci9nc296SDI3U3ordlFJNTYyUFRrSzZHNlpQN2IrbXV2?=
 =?utf-8?B?Wlp0dVFqRHE3MXNXVmExMXdoZWN4aTk3SDdOVUs4anNnZ1hhdlR1d2xOZnpZ?=
 =?utf-8?B?Z3p6OEhFVlVDdk45cDhDekJ1ZStUQ3hYSFpuSFF4UXE5RlpxUmdwR2ZjQUxV?=
 =?utf-8?B?SkdSK051c1UwYklUTDI4OWxibXRGbEdncUxFYk0vZ0VHSjI4SkdTOTFoZkVH?=
 =?utf-8?B?S2luTnFqS1VzUkNDMjVCc2N5dHN1dEdSS3lycERDWEZmSlBtM2JTYkhkeG9C?=
 =?utf-8?B?MWluTWNuQ2tEcDh5bHd1VHRnbVlrazQyTm1ScDJFQnp6dy8xdnBEZ2l1OWNv?=
 =?utf-8?B?WHlCcGpJRFd2QmVJWjFOODYyYnNRZ0txcnFyOHN2YXFFZzY4RzcrNnQzNm9Q?=
 =?utf-8?B?NEljeUZQMENTY0Rvb2NKMkRGRjYwZUNIOEhKM2FNOTl4dnp6L2xtdGJpSElF?=
 =?utf-8?B?WTRqK01KQ3J3cktVcklIL3cwb2NQQUxwaTQxbWlZeTMrVGhEdXJuS2xlbHR2?=
 =?utf-8?B?RVdwM25JTWFMalVodG53UjI3RXRYcC9sbXFqV2lkZmVGLzdRK2ovZFByK21J?=
 =?utf-8?B?TzMzM2UwV0lsYWNOVkZhdllaWXZWZk9CZ2Z0aWNJNURBV3NPc0RqaVlJTk9H?=
 =?utf-8?B?RDN1YU1mYmVWSzh3dFVqUmczK2cvdzQvUExuNUpWOUloWEFoS3o5c2YraGZW?=
 =?utf-8?B?Z0xZU0RzZ3dKUVNWdjhNdkJYcXBZMWh1RnArK243ZmxxMklnWEZERldxTGRD?=
 =?utf-8?B?OVVPdWU4WmtHZGlFQkE5T3E3enpla0ozNkJEQ1FsK3crNnhTdmY5K3NZTWwz?=
 =?utf-8?B?NWVxZ2ZRMkVCOTNmQnVUMzB2T2hpUmwvczN2TW8vY0ZFYjlya25MeFIvRnZU?=
 =?utf-8?B?a0MyK3M4V1ArUEFGTXJDYWNyNzFxYUVpTFo3Y0UxZUFmWmlscG5DV0V1eENT?=
 =?utf-8?B?VzFYSjNSWFpxYm84Q3NNK3FRYUE2SEhyVzEwclArMnhDM3FTWDNreGhvUEg2?=
 =?utf-8?B?Y3ZNTUhYY0kvandZY01yclhqV3ZzK3g4Ry8zV0pUaVkvWTEzOFdNQitqM3JK?=
 =?utf-8?B?aEIyR1hYUU5LTkFmM2Z3enpvTHNtbUlhY3RSQUhBRmlCZkFsS0pkSUR3Y0gw?=
 =?utf-8?B?ZTRZR3E0WHl4aU5KUkFhSDhwc1I2SWFOWHlyVy9TRExzaVlnbGhaSTlZVTNw?=
 =?utf-8?B?TFFxRkZOVlJKV1cyU1hOMHRGVnVldXhPZC9Tb1FGOStoSzdTWk10NDRUWkhM?=
 =?utf-8?B?azBWQmNNaCszcDhVUHpzUVBkdk5JT2dRWTNxY1g0b2dPVjBaODR5Vld1R2ls?=
 =?utf-8?B?U09DUXBGZUljYk56YzZRa3dJN2UrZ04yRmQ1Ynd4QkNvK3JlMDQ5aU1TdWVL?=
 =?utf-8?B?b3N3bHRSMDZSV0l1QmxPUXp1M0tKVm5wSVpOYlNFdjJDUmVvZFZnWkR0VUFH?=
 =?utf-8?B?cmlqWTNwdGJNbWZLOWswNmt5MGlFYkV0Y2h4WDVZZUlnTVhlc3lub0U2ZUo3?=
 =?utf-8?B?YVBwdEV1dUFMQUV0ejQ3L01UQWx2YjhEVVYvM0VuRGY3eTBBMTJtblpxK1Z0?=
 =?utf-8?B?alkydXloZzNsTU5EN3E0MXlzRHRDTHRQMHFmbXd5L0RJOEx2TFpCQlVtYWlz?=
 =?utf-8?B?SEYvQnBlcGNPbktwRzA5WE5kSUZaLzJSZnV3TlhqakJnaGEyaEhmajMzMXBR?=
 =?utf-8?B?QzA4djZGS3E4L2pXNG50Qmt5Zm1NL3FUQ1gwV0hCVGJzY2I0YkFubEx4V25O?=
 =?utf-8?B?VXM2ODhJUE1QakoxWFB2Tmlkck9lb1hRR3hTcTdvV2lYNy9pODJ2WHpaQStU?=
 =?utf-8?Q?aGUMuOv9h/j5Xeg9BY7k0GU=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 077247ad-8cd1-43ee-372f-08d9f5913606
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3180.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 23:23:47.7731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MgFfDmbSTYZotsnYp1vkZOXY7LD9fkNFUrXVNvd+5KBdIyE8KpdS6TH7MPBraLOQw7vOZ5a0ySoDlLSo0YWmSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1593
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 22.02.2022 00:16, Andrzej Hajda wrote:
> Hi,
>
> Appearance of ref_tracker library allows to drop custom solution for wakeref
> tracking used in i915 and reuse the library.
> For this few adjustements has been made to ref_tracker, details in patches.
> I hope changes are OK for original author.
>
> The patchset has been rebased on top of drm-tip to allow test changes by CI.
> Patches marked "[DO NOT MERGE]" are cherry-picked from linux-next (they are
> not yet in drm-tip), to allow build and run CI on the patchset (it works only
> on drm-tip tree).
>
> Added CC to netdev as the only user of the library atm.
>
> v2:
>    - replaced list_sort with ref_tracker_dir_stats, to avoid potentially
>      extensive sorting, if number of reports is expected to be big enough (???)
>      we can replace linear search in ref_tracker_dir_stats.stacks with binary
>      heap (min_heap),
>    - refactored gfp flags,
>    - fixed i915 handling of no-tracking flag.
>
> Regards
> Andrzej

Sorry for the mess, sth wrong happened to my scripts and I've messed 
patches, I will resend it properly.

Regards
Andrzej

