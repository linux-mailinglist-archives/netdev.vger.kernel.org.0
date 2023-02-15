Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64CAD698191
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 18:04:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbjBORE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 12:04:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbjBOREw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 12:04:52 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C568955B9;
        Wed, 15 Feb 2023 09:04:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676480691; x=1708016691;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qcOSfB6o2vcTRDtcmtPCDP+67wz64y/W/hi6DJcbeH0=;
  b=XlB9cEE3xDAw5U/Wv33FhC/qrxp4UNQdzjbP4wOfXEgmvBFGuTpJk61Z
   95ASgc/HyUQ30tyqqrfbA9u5JcQgeZbcBSfXUWFQOFZH7tp3DjTSvYJWd
   VDbXaCmqbV6ffUJCkXv6A1IcNXSDvM2uVOOIBMppxL98lbY2MyOpK62hI
   qnykNWIBGe4INan0GWYWCda7vijvbUHuoeBhLJtTRe+sj1fCuHTHreap3
   wijV+/cPDbkvmPcTenmpv9FdVSJ6ItlPNW4CZHslkRkkP9bYK2ed+K+6/
   sc+sXfU3DnBkxYhZAipQovROTEDnl+y+1zWx+7vwzB17/a3fNt+VqfMpx
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="396104955"
X-IronPort-AV: E=Sophos;i="5.97,300,1669104000"; 
   d="scan'208";a="396104955"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2023 09:03:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="915268202"
X-IronPort-AV: E=Sophos;i="5.97,300,1669104000"; 
   d="scan'208";a="915268202"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga006.fm.intel.com with ESMTP; 15 Feb 2023 09:03:19 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 15 Feb 2023 09:03:18 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 15 Feb 2023 09:03:18 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 15 Feb 2023 09:03:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NT09utloqRjj7ZCOj72VwFPh0/VYyCfMTj99J8Xe5hNAdCWOYUTaRwJnMaQDH3Uv+bJDbGnI6akizWTHi6tuY26mVuTnYBm2iZDZ23wrKWcxhICqGzu5aeYqRXBdftDzn4QLIQYbu2TUi6JQ8gy3bQpjviBPAjjAsaWBmV2bQqo60dTBCsfEW1AwMdCxX3OKrEUfaCiLh7qoKDrnawPzlBEM8xNNrcgiy3mfW0nW/IgG+8uBDf6IKiov4fREjlMgGJ3Mja5uLdubRmC54W80CF4Nf1Mgz6dEj+8uFtB9D5YQcQJLYkIQ69dUNxlTTW7sKyh9RC9PDTnnKvMo+P06XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K+12hOqyS+Apcjh+oAkjblYYasJ3xDwoH0nVsAhvyDM=;
 b=FG6nm5TLJ5Fa5RsIRQ5yIRkUo730TiFRRcax1zGZKFjkAnWkgIM7rofVGIDFCeaY4u/567W+VbHTNz/lip1kJgKy0FBznYsZMGaecxa+1FLZCb4BwsazOoxSVAYG9NNtMGQ1ZxilYg2gKc0dHCaUyrME6AKFpGHl7WbSmmk64CjhRYmwLPUtCl1R63GuXc2vt775zg2Z1nDTXw7+72oyvZA1zAIHWs2cWnBe11PlbkOVgolUErGoj218rfouAHchkG+cbQaUvvukA7JsgzCi7EpdaHLMmep1n5Gx8CAlMofQbrGyRzNl/AlxxoA9IWs1qadtXNGnJy3iEVXIgaQ+hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by DM8PR11MB5656.namprd11.prod.outlook.com (2603:10b6:8:38::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.26; Wed, 15 Feb 2023 17:03:16 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6086.026; Wed, 15 Feb 2023
 17:03:16 +0000
Message-ID: <dcc5578e-89d1-589f-3175-eb8bcd58f7ec@intel.com>
Date:   Wed, 15 Feb 2023 18:01:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next v1 3/3] net/mlx5e: TC, Add support for VxLAN GBP
 encap/decap flows offload
Content-Language: en-US
To:     Gavin Li <gavinl@nvidia.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <roopa@nvidia.com>,
        <eng.alaamohamedsoliman.am@gmail.com>, <bigeasy@linutronix.de>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roi Dayan <roid@nvidia.com>, Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
References: <20230214134137.225999-1-gavinl@nvidia.com>
 <20230214134137.225999-4-gavinl@nvidia.com>
 <711630a2-b810-f8b0-2dcf-1eb7056ecf1d@intel.com>
 <231a227d-dda6-fe15-e39a-68aee72a1d59@nvidia.com>
 <92d83584-2238-f8e8-3ed6-f292223e4061@nvidia.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <92d83584-2238-f8e8-3ed6-f292223e4061@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FRYP281CA0001.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::11)
 To DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|DM8PR11MB5656:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c81e44a-126d-4607-c1da-08db0f7687da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WuweehkxEqOmvycvFMR/tMbhxY3cVQ08B+KM2bPixr/dVnkOFD30R9Lt6BzHuLr/0xqoOy/bffXzs9e/r8V+lAYlClz5vA9LjPnv7nSUc5JXr33Uv0KSrgUivTpJSZ79m5xj4VWXv4ZBmfTrCS1m+AsJm0JUPHfpT/Zka4SUaSNptEUJW80Ouwh+QMXTr1HJvuTsyH/x8OOAGGPh6TQbVkkmiF9cej0xwcGBDrenUOnXMklT3Pq+ZCTVOKIp9SQo/bFlfTsIz4sckbledCdm27+cC8xMVwgPJhQkYDrmllqOwUeivOwTNvwIpBTMPYQ01bkICSqTWmclS7Et3sa43sOgOPgkhYlny7Nz90+6BiJEZxKcx1CTceajcHbu8sgf4/prbJVGt7W02GfFzkXANqefrQas2gAlyggo2D3B9icbqqN1yCD7PLtIi4rW1ijMU2aDKSGRQpul/9n9wTlUiLmU47s8iu+WDBkz1B3rUH72zTIlZkQQ+7z0nGx/c3hFzMRdrACJTjnAq4sBEez7UpTa8kNwdcNehuoLWftKh8yYClTjuNAKJVtUUgDz2GAesJxAyN/X25r1Uqjm305GapS1gJCYIiFDIId69dVgNJuT3lvTyI6hKiDiQC8zsm9n7iK60t670K4PHcgxoWicIN/ZEXiRv8IB17s9SDKIIfBiq6JBNkDPWQNSJnatXIRV1JR64f1SLt/xeZce7BVEbPrd358fadZCwIrTgUA5dX8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(39860400002)(136003)(346002)(376002)(366004)(451199018)(31686004)(36756003)(82960400001)(38100700002)(86362001)(6486002)(83380400001)(2616005)(53546011)(6512007)(31696002)(6506007)(6666004)(186003)(478600001)(26005)(66476007)(66556008)(66946007)(8676002)(4326008)(7416002)(316002)(54906003)(5660300002)(2906002)(6916009)(8936002)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UFp5N2d5OStwWTJjZ0VBS3dMTzhEdHM0SnZjRGY1Q1RBbC83bnF3YmI4VkVE?=
 =?utf-8?B?RTVxU1A0QkdCNjVGR3JrT0RRcVl1S0dPTzNpUENjOGdaWXkzc3FmNTArVEE4?=
 =?utf-8?B?ZDB2VjhsV2duRWZuV0VVcjF6UEo5NUp1RmFScGlKSEdLQnNlREo5Q2grS0RS?=
 =?utf-8?B?Ym44bUJXT0ppbFlHSDhMUHk2dHd1UUlPU0E0MlFwUkh6Vml2WmY5UnpXdngr?=
 =?utf-8?B?eWRITStpNmNQUndZNG85NGZCYnRXcG1CQzEyeFAyUXhrTDUrb0xCYnZMd3Vm?=
 =?utf-8?B?Uk1Ca2I1UkdRenllT3g4MlgyZG5uQnk5VXNDY1BESnNVcHhtRitiOTlHM1o2?=
 =?utf-8?B?aUwvZndOVzhzTGc5ZEx2cUxzdVlaY2tUd2FTbjR3N1Buc2NiVDVEekIzRkxx?=
 =?utf-8?B?aHZWRkFYdDEwTGpVWnBKUFdIUXM2TWgzQ2ZqTzY3SEU3SHRwMUh3dWk0cWFZ?=
 =?utf-8?B?bTkwWHFvZ0l5dmpSeTViN0ZUQnl3a3FvWXk4N2hXOTJJRExhZVluYUs3cFNj?=
 =?utf-8?B?K2QzaER3MXMyaVFuTnhWdXExcGVSMUhXWTlvY0FIbTZWVS96WGRsSXhkNUNw?=
 =?utf-8?B?bVN3RjVPNDBSZkZNdGVMdk9uKzlUNEc3VlFlOHBVWXUvSEVMQ3luSmxQQkZI?=
 =?utf-8?B?R0RZYXQ4eVRxdzgzTC9oU3VxWkFDY3FQK1BlRU9XZVBiV0FpOGlpbCtuTy9B?=
 =?utf-8?B?VUh5QTBkVVlTR0oyV044anZQY2ZFRXpwRDZMMDJvSUtndm91aDVtV3A0bWIv?=
 =?utf-8?B?U2VLYUZ1UTlYN0V6TmpZa0hHNkxXcFZycVhEMENsL3ZqdWhMV0VGaURCZWZr?=
 =?utf-8?B?YnBDa0JQaW5qT010dEM3Tlp4aEs4TjgvaEM2L0xsYUM3d1pjRGwya3N1M3h4?=
 =?utf-8?B?ZHd2bWVvV09GakZ0UWJrMVcyN0cvRU5MSXFzVWxoQ0MyRXpPcDF4NHhpcE1Z?=
 =?utf-8?B?THdIZkFYcEQ4ZVNJaGRMQ1dBSUs4SDIyUS93NHhPU25EOGdWTnp5SXV2MDRK?=
 =?utf-8?B?bGt1QjJYbXlhNG5SWmJmbXNTbUxCTDNuWDEzc3B4WHZVcFFFaG92WmQrN3FM?=
 =?utf-8?B?L2o4aFJ6RTVyUmp4WmI1ajQydzlJbFlrL0VCUmN5bndtR0hjVDMyamNMQmk4?=
 =?utf-8?B?VmR6VFBlT3NWU3ZNQXAwYlBDUHFUU291dFk1S3R1TU9mYmJEcDBKZ0tnYzkz?=
 =?utf-8?B?QzA5N1RscmRIbkdndjRYeVU0SkN1QW8yRUdKaUlwSmZobE9HM1VlbFhxeEUv?=
 =?utf-8?B?anJYMUZGWVJKWTNFS1M2MG9vUFdpNk9EeUhWelJjc3FCcXlxc3JNak9TL1Bo?=
 =?utf-8?B?ZWxkTG1kSjloZnlDS0RFSHBOcVR1ZkNDblBNVG1MTHpsM0RYTnRqN0EyWGd4?=
 =?utf-8?B?VktoYUhvV1MzdTY3OTRlNmJDK2VQems5enFVOW4yWHZjT1VJdlhpTGtLWXYx?=
 =?utf-8?B?WTVENEE5OFk2RXFGYkhpVDB1Vk5BUXhjeVVlUEwzckh6TkQ2L2tHZUM2ZGNr?=
 =?utf-8?B?UWk0S1ZBQ1ZncC9aVlRuNHE2ZzMrUVhyMUV5bU5yN2pwdEl6K2VYUVNLUDFR?=
 =?utf-8?B?anZUSm50cFpuNkZJQXhaSXZ0ZDFtT0JNOGtnSmlzWk5COGtLbzBmZFdxWTBL?=
 =?utf-8?B?QzRCNjc2Y0lhallBMi9PQWp5a2dRaTBZN1c5dkZxNEZlUFZYNmowVGRiZkx2?=
 =?utf-8?B?NStqVnlXdzl1MDY4dWdNZFBXeG50LzR5RVB2Q01ickdYTnB6Z1dHd3hSQnJK?=
 =?utf-8?B?QTgxN1FBVUxGYTFZZ1hnOTJKRmRpUXNWNS91OTl5TXMzeUhwdFB2RTNjSitI?=
 =?utf-8?B?Z2N0SFlKMmJqRXBwRTBWSHRRZ29VWkJoaWlpZlY4SXF6dWJYYXg5bDBnTm5r?=
 =?utf-8?B?d1MwSFZkMGpTZ1Z3M0UyOHVPYXpVR1VyNmFhVkd4ZTJKTGpXTFJKUGRIWHkv?=
 =?utf-8?B?TG5vbVE1RTFsc29acDdjdGdlSEo0MFBuZjVQY3gxMjRZSHh3eEtCemxnTHFE?=
 =?utf-8?B?NDZuUVNVNXpkYUpjL0hadjR5eHp0UHRVNHNjZVJVcmQ2T1JKditmcWxnTTQ0?=
 =?utf-8?B?dnp1M0NkMzZUMTJ6bW8zeGtsQlV1Z0hFbmxSSkYxVjhHWWYrVDlSSFdLNlli?=
 =?utf-8?B?dkxuaFlpc201bStoT1h5QzNxNUdOR2ttWlNBZm9NSHd6aExGbU8rdXhEcXpH?=
 =?utf-8?Q?oUPjLOdadf61sxnAM+3CvBE=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c81e44a-126d-4607-c1da-08db0f7687da
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 17:03:16.6000
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KfhPFItG4fgkCKFUAjkSKF3O+F1wEyHVTNDkNa7Gt2ykvaCLzw/EUD7gRYe+bo/QlyVsiTHqN6wfbhhc9Mcgnx5ZLnMewjkmxCUmDpwxv+s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR11MB5656
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gavin Li <gavinl@nvidia.com>
Date: Wed, 15 Feb 2023 16:30:04 +0800

> 
> On 2/15/2023 11:36 AM, Gavin Li wrote:
>> External email: Use caution opening links or attachments
>>
>>
>> On 2/14/2023 11:26 PM, Alexander Lobakin wrote:
>>> External email: Use caution opening links or attachments
>>>
>>>
>>> From: Gavin Li <gavinl@nvidia.com>
>>> Date: Tue, 14 Feb 2023 15:41:37 +0200

[...]

>>>> @@ -96,6 +99,70 @@ static int mlx5e_gen_ip_tunnel_header_vxlan(char
>>>> buf[],
>>>>        udp->dest = tun_key->tp_dst;
>>>>        vxh->vx_flags = VXLAN_HF_VNI;
>>>>        vxh->vx_vni = vxlan_vni_field(tun_id);
>>>> +     if (tun_key->tun_flags & TUNNEL_VXLAN_OPT) {
>>>> +             md = ip_tunnel_info_opts((struct ip_tunnel_info
>>>> *)e->tun_info);
>>>> +             vxlan_build_gbp_hdr(vxh, tun_key->tun_flags,
>>>> +                                 (struct vxlan_metadata *)md);
>>> Maybe constify both ip_tunnel_info_opts() and vxlan_build_gbp_hdr()
>>> arguments instead of working around by casting away?
>> ACK. Sorry for the confusion---I misunderstood the comment.
> This ip_tunnel_info_opts is tricky to use const to annotate the arg
> because it will have to cast from const to non-const again upon returning.

It's okay to cast away for the `void *` returned.
Alternatively, use can convert it to a macro and use
__builtin_choose_expr() or _Generic to return const or non-const
depending on whether the argument is constant. That's what was recently
done for container_of() IIRC.

>>>
>>>> +     }
>>>> +
>>>> +     return 0;
>>>> +}
[...]

Thanks,
Olek
