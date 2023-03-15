Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C40E6BAFF8
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 13:12:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231676AbjCOMMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 08:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbjCOMMJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 08:12:09 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AD5C8091A;
        Wed, 15 Mar 2023 05:12:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678882327; x=1710418327;
  h=message-id:date:subject:to:references:cc:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=t6HGP2db1Y3g/OHN9Aca63G73noWDeR2SGfJfJ7tgzg=;
  b=gjU0Oq9kuMF2V08Wd4bcUcszN/AQ3jsqZgNkCZB16q02tGmgvJOvt0/1
   +NiVMYhpn2DLYjf2T5OCXhR3AQNTCy1gpTurRluZj0TIRJ4aSwqz/YP51
   mY+DC0Lg9tRTxNo7nuTU9rrPeo0mA9g0OvRAdk+FrutGCjsm8TlHVP79r
   ldwBOFbSy15fwMzK8irR/NZ/gcarBgnxZwbroTjAmN+GkgFUyZiO3YJgW
   l+Vc11u69UHk7ESiGoBnRBlUNWKNlWLW/h3YmarOOa8CGk9gbX6RmVpz9
   Iis1ho6PuEc3eF5Va2vNEH5pcDgHLjNVlHEXjedwZl2j4W29mfx3NHHfI
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="335170127"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="335170127"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 05:12:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="803264592"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="803264592"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga004.jf.intel.com with ESMTP; 15 Mar 2023 05:12:06 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 05:12:06 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 05:12:05 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 15 Mar 2023 05:12:05 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 15 Mar 2023 05:12:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kJVJli5cgkhZRma8a6JPamtDKEYPWAkVEKdI6Gy5rQfc3zWETAEKH315CVr08wnB1PTcpIiJ0z+qPGlfrvme9bgNkfa277S0kym/1OqCD7MawjNbS29ujBsl8Emd+hytK5H0ZimkyWoxwl3N0fqK0oLdp2re7M789SYwG/Ig2B8L4b9FiMNXwr1tGW0mbFYHSywjgg3XXKKS0SwjAyib6BoiLKeub3V5Ng9uiZ7qmwybMAmF4BbCSBAnVdcVWZlaEGJui5pRASzbVar+YmzKl9zKJ0uJEkgvmKJfg6ATn+DmOFDC6482AcIvpoWPGDQvd61xkvHdtNKlu6D2+LW47g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ip6O84se6SVS20oFxQMzjqVoQMrR7EcuU70j9WCFjOk=;
 b=lusmPsV9hIvPHJHRdqZuurYrnzjxTXnkTB4ix7xDD4Oz9ioIUD/WkP/iK9AfCOrkv1yr87aHNjN+jWkLMKnBKc2QulOpyjpDnBAlWVc1T0i4/2/w93zJ06eNk6BHOXmXTYZL8EsMelvVqZaR0wRrGs2Zh9kJsnRJVwKI33M4oeZwIK0trs4jRZhINxPyeYekR1XDmRiDOrJWe/MQlmB/eCUYr3UYpKAdYNG0OeXM+uL9CNZIrQ3scooJRirKzNn+CKB+umLXcIBbYNNogspQbxmCQrzpTybOo3NBPlLBq5WjM7zOmka9bYGnLXPyJBiTbhzds5BjXyicw0DZa4AYcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by BN9PR11MB5481.namprd11.prod.outlook.com (2603:10b6:408:102::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Wed, 15 Mar
 2023 12:11:59 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224%5]) with mapi id 15.20.6178.029; Wed, 15 Mar 2023
 12:11:58 +0000
Message-ID: <6b48673b-33a2-877d-dadd-b43a1364b330@intel.com>
Date:   Wed, 15 Mar 2023 13:10:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [syzbot] [bpf?] [net?] BUG: unable to handle kernel NULL pointer
 dereference in __build_skb_around
Content-Language: en-US
To:     <ast@kernel.org>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
References: <000000000000f1985705f6ef2243@google.com>
CC:     syzbot <syzbot+e1d1b65f7c32f2a86a9f@syzkaller.appspotmail.com>,
        <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <edumazet@google.com>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>, <syzkaller-bugs@googlegroups.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <000000000000f1985705f6ef2243@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YT3PR01CA0074.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:84::32) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|BN9PR11MB5481:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f1d537f-5021-4ab8-702a-08db254e79e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6Mx5z8fdZdj5L2/F6SsOAjqNUHYCYj/WVC72WleT1kzDX0GTlt+Xy20oKT1yuYd6hruk/x1/xLNsROvzlPDmWeKTcXZ22rM8qSMi2VKHNgtJ56yKlw/TlpLLDXM5myoAmwKeRex2Vdu+5MnAGjPLhiHfTGxt+Dz4gIB2sVigZlpXvGtL7g0s/+/w0lzv0rEso6EvFXfQ/E0EgJl9fAN797qS0Ja8+oL1TG4XzbdTGlLbD1h+knOKL41sSZpa9Ea9zImt5AsoT9gvxK1oshSR5RLo4bme7ElwRC1rA5n/nRZ7y0Ex9B6S87SR3EEcz3FMmDbo/fphQmF7fLLDx3eHOA4opLJo6aJYIcG6/6IR4UHoYdlmeS0AeTNW7n2zkx++h17GlLFI8SjK0l4Cy0yqgxfL6TYn1VNAkbulC1HmjQPgPZprBTfVL916o7ivec+96OdfUcszVU1EyyAg8an999AH8nFPF4RPBphTMspCHogt5ZxFO6KnjrMgqkfplNoqHbdGDVT9Ll3Sj2KxWxswiXtfrDYfiXKlC26+t1OkCFigVpBz2fWMPw9RowVK1juVtKsmv/M0vXmWDgIWDu+LPLapBzgPDkHh3gum3Y3aadBT8oFjVVJKa5/wY/c65RFahQ5B1AsBAZGCZhZfrytlnIpKlrGwUAh4scGtDL/bYeGwCeKWzudwVzpY8ki4xUO+lXvfD/xwetwSTsBYypuuaMCnv51HXvHcaqW6H1ludzzJCUra8nLvTLPoP2Eh02j+vmCvbjmh38FqRGL1LyO5pxLD5MD84UNyRZOc6SD3UVE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(396003)(346002)(136003)(39860400002)(366004)(451199018)(36756003)(7416002)(5660300002)(83380400001)(45080400002)(186003)(478600001)(6512007)(2616005)(6666004)(966005)(26005)(6506007)(6486002)(66946007)(66556008)(6916009)(8676002)(41300700001)(66476007)(8936002)(31696002)(4326008)(86362001)(316002)(38100700002)(82960400001)(2906002)(31686004)(99710200001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VEJFeUpUOXBIWEc0dUJjVE1QeTd0UmNLTmQ2UDFDa1hBWGM5QWV4bXdmRlgw?=
 =?utf-8?B?eVMwWnNxaXBDNDUzSFJ4cE5oZXpyaHVTTTVockhycEpaRyt0MEx5azBqMUt3?=
 =?utf-8?B?L2JKb0l2b2drSUVEQzlBd1RVTzB0M1dUZzREVCtrUFZFM0VpV0tranRWc1Zp?=
 =?utf-8?B?R2ZLZ3dqMnlEaGtKUG1DQUZFd293bnhXTnhBQTk5NjMzcFlTQ3pzM2UycGlj?=
 =?utf-8?B?MTYxU2JSS0FDNFFjTWNJY2Rpc25WRWtIZGd0TWpDOG55R1c0cUpWRE15UkpC?=
 =?utf-8?B?cjZsV0NHN3oxS1NRNGRyMDdaamVrcm1CVklub25lbTJQZnJxa2R2ZkVVZGFN?=
 =?utf-8?B?elEyMEZsOHB3a2xjazVnWGlrc0tMdTNDeUNZK2w2Q0ZmSk9yQ2x1ZkJLNjNi?=
 =?utf-8?B?Unp2SHVxV1lqVklIMUlaSXhqRjZhZ1hEdUZ6S2NjTEFjaFFVSkxKK1RNNnU1?=
 =?utf-8?B?b2g5b3pudDJhc3JTaWJJbHJtR2VQekNxbFd1bXA4VEtHTHA0ZytNajhkL0NX?=
 =?utf-8?B?U3BKRzhuTUdUejhuNXBrZHh0M2hnbHpRWDM4SnZIWFVHaUw4bFRBYVByUitU?=
 =?utf-8?B?MXQwWmIxNlJESm01VXRiRkRuak9pTFZwZU1RQ0ZHZVlOZXdoUFJKT2lrZ05n?=
 =?utf-8?B?V3plUWdpdkZnZXd5d2pCTkhNQ1N1Y3p0MHl4ZEF3Zys2WmtIUi91S1l0MWpw?=
 =?utf-8?B?SlRPSzUvOFNIb3dGK3o1ai9DMkJCTVFtVGlRaG5SM24rU29FVlBxMUMyRXhi?=
 =?utf-8?B?YVRVeG1wcjdjM1RMcURvTnZpSEFmZTNOd1A1RTBkVzM4NDlvMko2R0w2MkxJ?=
 =?utf-8?B?NWY1cHc1bmg0UHFZY2NqYVoxcTl4T3Q3aHcwSk9RV3czeVFiWVcyc1BYZEh6?=
 =?utf-8?B?OVgrZHlnV0NkVXJWalp3a3NVeE5wU0MwOXZwWDlOM3Y1QjlzQUVZTDNJcVFV?=
 =?utf-8?B?VE4reXgrd0txRmJOR284ajZ4KzF4MVZtMEQyNHZBa1g3dWJyNFJ4dXpqZjdS?=
 =?utf-8?B?ckx1Sy9uTHpKRStYZC9USUx3TDl1U0hsWi9XamFmc2dJZkNjbTRrOWh0VHlx?=
 =?utf-8?B?aGRHaWxwcGQ5OGczSUlueFFJZk5zT3kzWmI2ci90MU1yVkdvOTFYU3NLSm96?=
 =?utf-8?B?RVp5U29IRnRROWswbitQaEpMc1VkOFZIbnJYOTVWSmE1UTNxTGl3NXdSSVRk?=
 =?utf-8?B?Zyt5YURWNGdOLzBNOFNmRllXVFJ5ZGRsSTAzamNxOUtrbWg3ck01N1VsZmJW?=
 =?utf-8?B?aUNKNHJhbWNuMVNkc1BmOWlsZEVwK041dExMVk5Tc2N0KzN1cVBlTGlKUDBG?=
 =?utf-8?B?WVpSOFFzdW9sWEZIV2FnTDJFNzhOUnRabVpOeVU0OE5TMUp4dVFKMjI4aWl3?=
 =?utf-8?B?Yi8yMlUxZU5nZ1FnTVdZTEdYN2hwb0hLVGxkd05tYU1adjlRUHNqUUFJckVE?=
 =?utf-8?B?ZXBVYlRHWXhUS2Z6Y24zNXVqdTZXOTlLKys1YkhDdXdNRVlCbmFIQTBhVG9D?=
 =?utf-8?B?V2VLZjZhY3ZZM1kvaFE2ZStPRVB0eGkwSU10bmsyWlRqTlhFSW96d1ZFeW4y?=
 =?utf-8?B?ZGJFRlRsaHVlbk8zb0JPazZEd01za2hIQ2ZERmNmc0c2R1ZtRkkwS1A5a3p4?=
 =?utf-8?B?alFCdkZ1ckFEbGI3amFIaC93eUFBR3VWNTJtMlRGOTRReWlrcS9LT3lKcXdp?=
 =?utf-8?B?T01NZ0ppWHJJS2E5aHd5Vys0aXp4WUxxUnQxRXR4STVPdWtYZkt1RVlRSnEy?=
 =?utf-8?B?Y3FkQkdsWld1dHBmclB5RkFRNTBpVE9hL3ZvamdxcjE1ZXVoT0xOdjBuTm5H?=
 =?utf-8?B?MlZtQW9MR3FvWHdEWFNENTJPN3lHQnlVdXd6UUlPOTYySnNHRzREVlVTZGt4?=
 =?utf-8?B?bnV5Wjh2dHpESy9pYjhWdXJtL0ZhanhCRk9VNW56WjFuZm04LzgzOVcyL08w?=
 =?utf-8?B?MFRkVzFHdGtHOVJYOS9iRlVjRUFaZkxwRDVJMGRHNUJLMCsvQjJSeHU3ZGFC?=
 =?utf-8?B?dkxtczk1TDRDbWZQd041cEtWNE1hK3ZHa1lqVjVsVHZMbHJpaGpqTGQrR2xl?=
 =?utf-8?B?eFBtRXBTMjhZcGkvZkhGTjdTSGZOUXE5RjRVd1U3a1UreGsrZnJxQlBmRlht?=
 =?utf-8?B?bzlZZEtaMDVCdHM1M3Nlc3daU01NZkpjR25BWnkyeTIxRDRxN3dybkxxRWNX?=
 =?utf-8?Q?a8nD5MTLXLt8atdGRj3tB1M=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f1d537f-5021-4ab8-702a-08db254e79e9
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 12:11:58.7481
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3O52fRsMh3/dAs/+cDY6FtsWUuy9iNnF7Hwt7MIqYRx9bT8Nqh8/uklR0Sx0Q7FvRNWjbwoIiGvem5nbYquMljr11fIqK1r1zOOobKI3li0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5481
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Syzbot <syzbot+e1d1b65f7c32f2a86a9f@syzkaller.appspotmail.com>
Date: Wed, 15 Mar 2023 05:03:47 -0700

> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    3c2611bac08a selftests/bpf: Fix trace_virtqueue_add_sgs te..
> git tree:       bpf-next
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=1026d472c80000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=cab35c936731a347
> dashboard link: https://syzkaller.appspot.com/bug?extid=e1d1b65f7c32f2a86a9f
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15826bc6c80000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15cd12e2c80000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/36a32f4d222a/disk-3c2611ba.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/f5c0da04f143/vmlinux-3c2611ba.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/ae2ca9bce51a/bzImage-3c2611ba.xz
> 
> The issue was bisected to:
> 
> commit 9c94bbf9a87b264294f42e6cc0f76d87854733ec
> Author: Alexander Lobakin <aleksander.lobakin@intel.com>
> Date:   Mon Mar 13 21:55:52 2023 +0000
> 
>     xdp: recycle Page Pool backed skbs built from XDP frames
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11deec2ac80000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=13deec2ac80000
> console output: https://syzkaller.appspot.com/x/log.txt?x=15deec2ac80000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+e1d1b65f7c32f2a86a9f@syzkaller.appspotmail.com
> Fixes: 9c94bbf9a87b ("xdp: recycle Page Pool backed skbs built from XDP frames")
> 
> BUG: kernel NULL pointer dereference, address: 0000000000000d28
> #PF: supervisor write access in kernel mode
> #PF: error_code(0x0002) - not-present page
> PGD 7b741067 P4D 7b741067 PUD 7c1ca067 PMD 0 
> Oops: 0002 [#1] PREEMPT SMP KASAN
> CPU: 1 PID: 5080 Comm: syz-executor371 Not tainted 6.2.0-syzkaller-13030-g3c2611bac08a #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/02/2023
> RIP: 0010:memset_erms+0xd/0x20 arch/x86/lib/memset_64.S:66
> Code: 01 48 0f af c6 f3 48 ab 89 d1 f3 aa 4c 89 c8 c3 66 66 2e 0f 1f 84 00 00 00 00 00 66 90 66 0f 1f 00 49 89 f9 40 88 f0 48 89 d1 <f3> aa 4c 89 c8 c3 66 66 2e 0f 1f 84 00 00 00 00 00 66 90 66 0f 1f
> RSP: 0018:ffffc90003baf730 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffff888028b94000 RCX: 0000000000000020
> RDX: 0000000000000020 RSI: 0000000000000000 RDI: 0000000000000d28
> RBP: 0000000000000001 R08: 0000000000000001 R09: 0000000000000d28
> R10: ffffed100517281c R11: 0000000000094001 R12: 0000000000000d48
> R13: 0000000000000d28 R14: 0000000000000f68 R15: 0000000000000100
> FS:  0000555555979300(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000d28 CR3: 0000000028e2d000 CR4: 00000000003506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  __finalize_skb_around net/core/skbuff.c:321 [inline]
>  __build_skb_around+0x232/0x3a0 net/core/skbuff.c:379
>  build_skb_around+0x32/0x290 net/core/skbuff.c:444
>  __xdp_build_skb_from_frame+0x121/0x760 net/core/xdp.c:622
>  xdp_recv_frames net/bpf/test_run.c:248 [inline]
>  xdp_test_run_batch net/bpf/test_run.c:334 [inline]
>  bpf_test_run_xdp_live+0x1289/0x1930 net/bpf/test_run.c:362
>  bpf_prog_test_run_xdp+0xa05/0x14e0 net/bpf/test_run.c:1418
>  bpf_prog_test_run kernel/bpf/syscall.c:3675 [inline]
>  __sys_bpf+0x1598/0x5100 kernel/bpf/syscall.c:5028
>  __do_sys_bpf kernel/bpf/syscall.c:5114 [inline]
>  __se_sys_bpf kernel/bpf/syscall.c:5112 [inline]
>  __x64_sys_bpf+0x79/0xc0 kernel/bpf/syscall.c:5112
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x7f320b4efca9
> Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffd2c9924d8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f320b4efca9
> RDX: 0000000000000048 RSI: 0000000020000080 RDI: 000000000000000a
> RBP: 00007f320b4b3e50 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007f320b4b3ee0
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
>  </TASK>
> Modules linked in:
> CR2: 0000000000000d28
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:memset_erms+0xd/0x20 arch/x86/lib/memset_64.S:66
> Code: 01 48 0f af c6 f3 48 ab 89 d1 f3 aa 4c 89 c8 c3 66 66 2e 0f 1f 84 00 00 00 00 00 66 90 66 0f 1f 00 49 89 f9 40 88 f0 48 89 d1 <f3> aa 4c 89 c8 c3 66 66 2e 0f 1f 84 00 00 00 00 00 66 90 66 0f 1f
> RSP: 0018:ffffc90003baf730 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffff888028b94000 RCX: 0000000000000020
> RDX: 0000000000000020 RSI: 0000000000000000 RDI: 0000000000000d28
> RBP: 0000000000000001 R08: 0000000000000001 R09: 0000000000000d28
> R10: ffffed100517281c R11: 0000000000094001 R12: 0000000000000d48
> R13: 0000000000000d28 R14: 0000000000000f68 R15: 0000000000000100
> FS:  0000555555979300(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000d28 CR3: 0000000028e2d000 CR4: 00000000003506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> ----------------
> Code disassembly (best guess), 1 bytes skipped:
>    0:	48 0f af c6          	imul   %rsi,%rax
>    4:	f3 48 ab             	rep stos %rax,%es:(%rdi)
>    7:	89 d1                	mov    %edx,%ecx
>    9:	f3 aa                	rep stos %al,%es:(%rdi)
>    b:	4c 89 c8             	mov    %r9,%rax
>    e:	c3                   	retq
>    f:	66 66 2e 0f 1f 84 00 	data16 nopw %cs:0x0(%rax,%rax,1)
>   16:	00 00 00 00
>   1a:	66 90                	xchg   %ax,%ax
>   1c:	66 0f 1f 00          	nopw   (%rax)
>   20:	49 89 f9             	mov    %rdi,%r9
>   23:	40 88 f0             	mov    %sil,%al
>   26:	48 89 d1             	mov    %rdx,%rcx
> * 29:	f3 aa                	rep stos %al,%es:(%rdi) <-- trapping instruction

Looks like skb_shinfo() returns %NULL inside __finalize_skb_around(). My
code didn't touch this at all, but I'm digging this already anyway :s

+ Toke, test_run author :p

>   2b:	4c 89 c8             	mov    %r9,%rax
>   2e:	c3                   	retq
>   2f:	66 66 2e 0f 1f 84 00 	data16 nopw %cs:0x0(%rax,%rax,1)
>   36:	00 00 00 00
>   3a:	66 90                	xchg   %ax,%ax
>   3c:	66                   	data16
>   3d:	0f                   	.byte 0xf
>   3e:	1f                   	(bad)
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches

Thanks,
Olek
