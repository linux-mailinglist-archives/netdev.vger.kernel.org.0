Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2986B0CFB
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 16:38:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232235AbjCHPiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 10:38:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231994AbjCHPhw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 10:37:52 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5D695FA56;
        Wed,  8 Mar 2023 07:37:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678289850; x=1709825850;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TVor/S2hgZcwPMgHxo2L9p/QI3yiEiOfe4gFSwTwePM=;
  b=WqFUtOn9qRYT+WxdC0lGtoaPJYT+JnwJH9zMTEfnUOMbB97Yo4mswx23
   xztoNCOXODtiAntepm0P5Cb0aBfh2s1To9yKjE5qKpKddeb2O7ToXLPjc
   DYmS18Q3cPL7s8iEdgDieCCDDGyghiguKehev3LhLzsisxtCxcGkdp41+
   yS+UJ7cSHGk0qOg6gBDhEeVM2LiICPDBn5HlvmlRBkb9Xj/uFkOO5oe+4
   80uI7wsdcfKpamxr/gLFLk1+fovmMps/rWdQBEPjNibw3hncwPPgox7lO
   6BlUg79EMeS16Nh1ujQUYf9pOxbnc/BUk4iqp1RAzBivTtLag3JikrM5a
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="422455492"
X-IronPort-AV: E=Sophos;i="5.98,244,1673942400"; 
   d="scan'208";a="422455492"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2023 07:34:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="677026274"
X-IronPort-AV: E=Sophos;i="5.98,244,1673942400"; 
   d="scan'208";a="677026274"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga002.jf.intel.com with ESMTP; 08 Mar 2023 07:34:47 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 8 Mar 2023 07:34:46 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 8 Mar 2023 07:34:46 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 8 Mar 2023 07:34:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Suibe+NbH4Uhzk7tZhz08iNa5JS7gEpmil8KAjOG33X1FUSDWr//1H/YDI4NqSaiXp61IIEiwaa5bGF3eXyTpl6325D8VdXR0tlRgdlp4KEntHxQoHSvEN4FM7ODdApILJquaM43oVJwk898khAqNnFTSYjgIwY5s9K4MSpzRjWfh9iwLjGiHq5PGJWzCpzJeJPwa2EUl0NachMOktUDSFQjk6/oi2OkPYIr4ZJmIbr6XTu7eJi1Dt7IGNt+Vewmnf6kyNnl3OH7r9OrJq+E2YlvKZk81fku/JEvr0qQHIXxFXabimaDgfjFXsxFKX7oGTezRiXMdF2gPJswdLSp0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KLbBOi8D4UFQkd2DABz2yxJsPN7sWi/ckJSa0wIE5O8=;
 b=O5AXGAklw5jirZmdwEq+yTKKyTt8kQr1i5EmEgUzG+zSLuyL0TXfoEwsxOugPzLgQbU2r1rFe90r0SEFq2OOleLMEYUm8ZsK7toDqXsDf8H2Mmp8unS4S1I0Dv3K7/R4d5JWrwFYgccKfL5dqFiV7AgdKz+hw5PasXr+dFrk72vUXavzWeT+lb0kwNwzVlvHtiUq45B40m+Brjo+J9ID2+wGCDz0YBmaJy/dzjOYWSyF8i1pJN8LOUOIobvV+1k3irhxXb873+wtUYpLrMsOwMHNbbwBrFemqxf6W4HKIeAI0whgZKzuM5FJTv00zzwkLtDJNxNaftqNlOKmRcRBxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by SJ0PR11MB5197.namprd11.prod.outlook.com (2603:10b6:a03:2d1::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17; Wed, 8 Mar
 2023 15:34:44 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224%5]) with mapi id 15.20.6178.017; Wed, 8 Mar 2023
 15:34:44 +0000
Message-ID: <4ddd3fe4-ed3c-495e-077c-1ac737488084@intel.com>
Date:   Wed, 8 Mar 2023 16:33:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] xsk: Add missing overflow check in xdp_umem_reg
Content-Language: en-US
To:     Kal Conley <kal.conley@dectris.com>
CC:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Jesper Dangaard Brouer" <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20230307172306.786657-1-kal.conley@dectris.com>
 <20230308105130.1113833-1-kal.conley@dectris.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230308105130.1113833-1-kal.conley@dectris.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0098.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a1::14) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|SJ0PR11MB5197:EE_
X-MS-Office365-Filtering-Correlation-Id: 98e5e42b-58e4-46dc-b16a-08db1feaa469
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6X1mcOjCAWzxB1ccY9wlFa9dRpr5M1bZSP0DmJg7qTgvpXLtTzWuGMPYER0bqEN+wes1vxbtqwSy01hgNeYR2KtmtVDyyKQ03rgyNODinyQcuFqvBgKfIUtmZkWdq0vTR8GbXsBYwy1XtEzsHhmxCk7Z/m1PG3xTXM6NGRkaPHkuCUxpRkLJo0svbX5F9uo1YGdd2uwxdAWU0JdTeFqGEXT+Rb1JVclJgjMZpnDZ2NZtAw9j/7Bf4ZSJwbYmXm+nOUlj8xMzRPJzeHb1EANtHK6PMakdYUydY4p04SeKVJYFGX19YD8llizdXTtcq9aQqPbOosIcqja18dnv7yCR+U1mlkrvFYOq/oBd6ONV0j9xkbV1G4jAuTRlGgGJL9FndP7SKkm4Yqyem94rC8Sa7UHHxash5qS43YEMv0NJKV4ZCRqppAV94GgBqr1pzUqOVWpZ0Lg+Eilt6RBus7dzgh4jx1ferJ6rdhzmA5f0VfvXS5uOVznFiBgYMRNSmDXSRMDNqdIXJjxaPYtlmBEnnS4KZyXrSMDQz5BA0HSdsdLUVb9BOzlnqIa5oKm6x7lSt/Egv8gegRCEn6cFT2jqtLkNGDRlrnHg/XgVCzMMlJvcBXsyH0pfbLh6VPVNrUNBopgq2fhcmASuQqsLOBai/EL5LhOY+7i61uEgNXvWRwqr2A0Hr/Ac+ikaNXACl22yD2vcIDFMM3vQnZvZXEmBODu1AKXB7gYY7zF1DJaERDs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(346002)(366004)(376002)(136003)(396003)(451199018)(4326008)(83380400001)(8676002)(6916009)(31686004)(66946007)(66476007)(66556008)(41300700001)(316002)(82960400001)(36756003)(54906003)(478600001)(5660300002)(38100700002)(8936002)(2616005)(2906002)(26005)(186003)(7416002)(86362001)(6486002)(31696002)(6512007)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a2VkS2ZRZjZRcHFoVnJLSk9FY2VrOHNndnNiVkxCdkJtV200OVVzNnpNMmhX?=
 =?utf-8?B?alVESHQwbG8xd0NaZ2FzazlDSEg4L0VaNmNNV3AxMzA0eVRSU1hEQWJvM0lK?=
 =?utf-8?B?ZXVpdmk1TTdEVTY1SWNwNkpjNVhnUnZaQVpHVEFKckFISXNjL1VIMVk5QmhT?=
 =?utf-8?B?Nk43RitmLy9WSnVDNFJoL1pYbkxJckJBVWtTTVJTaFcvMWpuZm5qaHc5eUtP?=
 =?utf-8?B?SzJsTVpPSEVIQWZsMUpsbHplTUlVRmloWU5sWkt2VDRFa1lwZDBJZXpRRWQ4?=
 =?utf-8?B?Rk5nTmk2d040TG00amZBTEVGeElWWExwdUxxa2xEOUdUUWtBTjVtQnhWUXIy?=
 =?utf-8?B?eW9uWXBFT1ZjR3VQZVIvcTNpVmExTzBnaCtCWkdmVjBhZ1RmSnBTNTMzdDJJ?=
 =?utf-8?B?MTNteWtoTkYxT1hJT2lnOHFMY1ZlYlRVb05TWnZvVjY5NzBxUFJWb1E2ZVR3?=
 =?utf-8?B?L3gwUWdGb1VvbFJWL3dieWFINk1mbU5QZlh1RXZPVWhWeHdZTklITWRUSTFQ?=
 =?utf-8?B?aWt5WS9DU2p6a2FNVmdpY3F5TmVkRFNoQiswOVhSS1k2NEYxMzI5RStOQ0tq?=
 =?utf-8?B?NEVZVmVrQ0hZbmhaT0wvSEx5ZWN4V1NNdHBkRGhMK0s4OFN6Z0hWZXFRN0dO?=
 =?utf-8?B?NjdibjBaOTJ6SVZBaHRSa0s3eXNNOU9RMU1RL0hMUlBxQ2RtK3V6KzBHT2Fp?=
 =?utf-8?B?d2JWWjZhOHhSNzNYN2pWUWtkN3VyN0puT2c2QTJpSE1tdVpiR0RRS0RpOUwx?=
 =?utf-8?B?SlNhT0d2SDlBVExEQlU4VnNtVlk0ODVuaVY3LzgyUy8zN1I2aHZYZzA0aTNI?=
 =?utf-8?B?SG1kNmFqL3llaWU2ZmJKSEVkK2tPc0xBbi9FZEdDMHFtRGRQR3M1VStNZzBV?=
 =?utf-8?B?R1RBTFpubFd0NTRUY1lKUkc5UkZWb3J3dy95Z2FjdDkzRDdISUFxNDgxQ3hJ?=
 =?utf-8?B?dVFMN1lRRHFDUUo5UjJYUndVMWNYdS9waFRRMWNaaDBPam5ld1ZCTTV3blI3?=
 =?utf-8?B?Zk02VUdHQ2ZnTFkxSDZua2dPZXdZWE56c0ZTN05ydCtEZE1JeWJMQTNKOEpn?=
 =?utf-8?B?TGxVNGw3WWkvWlhqalpGdjl1VWM2MDlIMHZtNkNid1ZCQ3JwbkZDdVNhcVFQ?=
 =?utf-8?B?NmtXbzZxTFcyTE9DR3RiTnlIMXRHR25HMldiRTg5SHY5TUJyWnBTZEdlektk?=
 =?utf-8?B?WDlTYVZueTBNRkdteW9aM3AvV2RlMDRKT1oyMHdSbkgvT0RNQmR3emsyUExJ?=
 =?utf-8?B?emsvWEtDbzJpSTVkWGMzY0RCb0NtZUZmcFJyZW5HVGNUVjl5cGlEdkdySG5y?=
 =?utf-8?B?QXA3dWVLcDdzSGR6QjIvQ0ZkTldveFdDS21YUXo5cW9aeEpuTjNSck03cTVn?=
 =?utf-8?B?T3QycjAvcEN3SUhHMUNCTmU3dk9PczlMdE1Wd3JETDRvWkIxRks4M3RCQjlD?=
 =?utf-8?B?eXdWempPMUpxVytXdUwvalAvMXk5QzdJVEMybVJvc2RXNWF3QTdnTFgyL0FB?=
 =?utf-8?B?YU9sWDIrR243QjUxbmpYZngrREVtMGYxVit4N211bTIvbUpFeWdQaHREaDcx?=
 =?utf-8?B?Zit0cUZVMmNvb0RyNFVWUVl3L0ZnUmF2eVZxeVJwV0hzQjg1b2xSdCtrNHlS?=
 =?utf-8?B?SzdmUzFXMkxxbmd1QWtvcit4N3NkdE55MEpRcGhVbFRMYkgxcWhoTHVEU3BY?=
 =?utf-8?B?Y2FmQ1NINUo4K1JMU3BkQ0ZiZjVheENhYlFrQkwycDlnU09NRXVoT3dnd2Vu?=
 =?utf-8?B?SXE4TkFZYUpWQVJqcDFmZUNmLzYrRGhVcU10RGE3eXY1UVpnTGs4Ry9FeDBk?=
 =?utf-8?B?Y1VZTVpCOHVwUFlwNVVyd1NzWllZNjhjNk1oSHJsTVRoZmVUc0p2VmQ0Uk9W?=
 =?utf-8?B?blZsM1pNZjRhenNYVFQzck5SVlFHcHNKcFY2VzFTc3hFRnRZM0ZIeDdRcDJv?=
 =?utf-8?B?MDljT3JFWkUxRWRDTlNxTmorZUZqWFRybFp2RFdQaUhSa1pYaENJUElvdDhO?=
 =?utf-8?B?bUdEdVZrTTNVSER4aFFIMzYyNmpESHZUMENucVViTFZNRXVoYUF5d0E1YjZu?=
 =?utf-8?B?SlRnQkdWa0trQ2xjSXBSdGQzQVNuZ0dPY0FCZFlqeW5PTFNnN25hdEtNUmNW?=
 =?utf-8?B?a2ZBL3Vyb0ZST1JPMlp1ZkloSzFOaVR2K1BzWGZyUHlKTmFvZzRRNml0bkhm?=
 =?utf-8?Q?a3D93ruAoeD3QzkCBn8QRoI=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 98e5e42b-58e4-46dc-b16a-08db1feaa469
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 15:34:44.6599
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ldGXCVl/0TrpMPOgaiDr211UuW8OnESjAKdx0dQ46iW0pdO782Vtt4QmxQ2hZEf1lbc3gDPCK9V9Jv2v1k9b0tleX+M/qD7lxplKf/VqiNM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5197
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

From: Kal Conley <kal.conley@dectris.com>
Date: Wed,  8 Mar 2023 11:51:30 +0100

> [PATCH] xsk: Add missing overflow check in xdp_umem_reg

You need to mark it properly. It must've been

[PATCH bpf v2] xsk: Add missing overflow check in xdp_umem_reg

instead.

> The number of chunks can overflow u32. Make sure to return -EINVAL on
> overflow.

I'd mention here that cast removal, so that reviewers wouldn't ask why
you did this.

> 
> Fixes: bbff2f321a86 ("xsk: new descriptor addressing scheme")
> Signed-off-by: Kal Conley <kal.conley@dectris.com>
> ---
>  net/xdp/xdp_umem.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
> index 4681e8e8ad94..02207e852d79 100644
> --- a/net/xdp/xdp_umem.c
> +++ b/net/xdp/xdp_umem.c
> @@ -150,10 +150,11 @@ static int xdp_umem_account_pages(struct xdp_umem *umem)
>  
>  static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
>  {
> -	u32 npgs_rem, chunk_size = mr->chunk_size, headroom = mr->headroom;
>  	bool unaligned_chunks = mr->flags & XDP_UMEM_UNALIGNED_CHUNK_FLAG;
> -	u64 npgs, addr = mr->addr, size = mr->len;
> -	unsigned int chunks, chunks_rem;
> +	u32 chunk_size = mr->chunk_size, headroom = mr->headroom;
> +	u64 addr = mr->addr, size = mr->len;
> +	u32 chunks_rem, npgs_rem;
> +	u64 chunks, npgs;
>  	int err;
>  
>  	if (chunk_size < XDP_UMEM_MIN_CHUNK_SIZE || chunk_size > PAGE_SIZE) {
> @@ -188,8 +189,8 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
>  	if (npgs > U32_MAX)
>  		return -EINVAL;
>  
> -	chunks = (unsigned int)div_u64_rem(size, chunk_size, &chunks_rem);
> -	if (chunks == 0)
> +	chunks = div_u64_rem(size, chunk_size, &chunks_rem);
> +	if (!chunks || chunks > U32_MAX)
>  		return -EINVAL;
>  
>  	if (!unaligned_chunks && chunks_rem)
> @@ -202,7 +203,7 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
>  	umem->headroom = headroom;
>  	umem->chunk_size = chunk_size;
>  	umem->chunks = chunks;
> -	umem->npgs = (u32)npgs;
> +	umem->npgs = npgs;
>  	umem->pgs = NULL;
>  	umem->user = NULL;
>  	umem->flags = mr->flags;

The code is fine to me.
Please resubmit with the fixed subject and expanded commit message.
I'd also prefer that you sent v3 as a separate mail, *not* as a reply to
this thread.

Thanks,
Olek
