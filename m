Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1607681549
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 16:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236282AbjA3PlV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 10:41:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236276AbjA3PlU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 10:41:20 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1192E3EC5D;
        Mon, 30 Jan 2023 07:41:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675093276; x=1706629276;
  h=message-id:date:subject:to:references:cc:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=O9PKUl+yC4O9lwfc7Kfx0BnRzzwSQ2TRI7CeOb71HWU=;
  b=Vjk8dUJZg0ioQ8GqZhPE9DPiKKyjYZ1gBH9lXCDAHA6ZPVkSZru+u1S3
   ErZHeS/KzU1sKgYDiKh0wqIreFi/S/gCml4WeNatagjCwIo4+nC/82Ur4
   wyIPIRlUXK/K2G5SizeH2jwDSYvNFviiv9MAxes/Fo0paVHtfCUuLVcx8
   kfej3yyhXgnxFesFscxR2DVGezFV0niGpHs1u/+gH7cxefKa5Ojr9u1GW
   v6xwUvSeREcMJ5wT4UOcF+VFx5owS8D221R+LvUQdyx8jrSAx7NuvcY3N
   EN6IQIWTblefmwmWMmohT7F0IEUIA8vfJb2fXMMoLg9IOo2IAqUswrUoy
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10606"; a="354905540"
X-IronPort-AV: E=Sophos;i="5.97,258,1669104000"; 
   d="scan'208";a="354905540"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2023 07:41:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10606"; a="657497058"
X-IronPort-AV: E=Sophos;i="5.97,258,1669104000"; 
   d="scan'208";a="657497058"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga007.jf.intel.com with ESMTP; 30 Jan 2023 07:41:00 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 30 Jan 2023 07:40:59 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 30 Jan 2023 07:40:59 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 30 Jan 2023 07:40:59 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.102)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 30 Jan 2023 07:40:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=og+OyiWsgF6tdhFxCku88vdOL8lDsFrRhx1LRHqKy6Ovhc2J2JHejomZ067kVI4d29+MVPQ+yuzN39ThQGbhOXMdwpJZwsExvaLGEfEemV98vfl9wipknhJefNYPL2M0FI9LvsdPJ+uORE2Jpi42kT2h98SBEw55R45E8FfJ9FKqmNA7Jh3lp5LldONLH8ayuP3rUGe4S/ASH6IWpCNeRzay3ERpLy0VBWnSLsr1KHXyNfA31PPpwQ/2nIB9AGFNuSecx6oc4FOlOcyMFGh7KhioEIb71ZbSndNEIpUBWk4E2Tn2/qhPGLygZ9S/Jp5h3GuFo12PsqOisMmWK4/1bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q+6sa9jrwX1RoQVZKpMz8y6vxlcZRyh75+pnSul5zK4=;
 b=JzGO1/1l4w14Fmg65zmgE4TTS+jnIuFuV7FOkC4LDbO1inM8EFmD5edUjiLITahFIwxsSRlKEXjz+Ufovd8owdpl2DbhNGmpRAxYg1Urz01GFtLfqldeeN/l5xcPYTVw3h5cWNWnbU3ipnALAeJruXvGfWA1cFz+XCgPND8r/sXRnXr+c5LTonS7PBpKTznMOWwCcuOIHjGGrrw6w5EcGZ/mY9jy/6bYpTKNN8ONcX4cSA7ZzfSqZv5LzUdxkuKH26na1EfvdvC3dE5vAKUspViaBFtEBUSZuVlwt+Kex9ew1veUt2WehMWO03ndo+knDkz0Xd4qayLLgtX5wF1dJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by SA1PR11MB6613.namprd11.prod.outlook.com (2603:10b6:806:254::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Mon, 30 Jan
 2023 15:40:56 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%3]) with mapi id 15.20.6043.033; Mon, 30 Jan 2023
 15:40:56 +0000
Message-ID: <836bc0f5-004b-3b7d-d0d7-b70b030977c6@intel.com>
Date:   Mon, 30 Jan 2023 16:40:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 2/2] gro: optimise redundant parsing of packets
Content-Language: en-US
To:     Richard Gobert <richardbgobert@gmail.com>
References: <20230130130047.GA7913@debian> <20230130130752.GA8015@debian>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>, <steffen.klassert@secunet.com>,
        <lixiaoyan@google.com>, <alexanderduyck@fb.com>, <leon@kernel.org>,
        <ye.xingchen@zte.com.cn>, <iwienand@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
In-Reply-To: <20230130130752.GA8015@debian>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0392.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:f::20) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|SA1PR11MB6613:EE_
X-MS-Office365-Filtering-Correlation-Id: 8095acf4-245e-4aec-3cb9-08db02d8605f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZlY9w1Hb8lcv12Xw4wuExEZNGED+9ypUaqm1GOZ5V+Hz6XCjS+JoF0bkoyiuWzvdvDtMNIosREhqzuL9l24WJzzDU90qzXCtes/A7iYgUzcClpRRS5R4FolQ4sXWBBdsIhcbHEbCZ4KqHYC7y6c2q2hbQh1H1i93OCdrbQRNKz7adUv7vOAeQHs1pi1dS9KOegvUyuwKrYNJ7dG3tvt6gUAW7o8mmAoH5IFT6pZnAIAhMjGyxXKOy6kVShl4GYUhgwG21VHL2hadQATeHaRz2kzmrtEVN/uY9Dq73NtXN34xShZhESTHx5hvHq2BS5RPjAGLqvy55XEuco5LXfp8lH6uwkHpC4Lx6rZsrsBsWbxWIGVDenGpshEpII7VyzHtJ3NHHlyGMqAtcaYZtr4SVY573I1ZJ6rJtlswj0NK1fy3n9yIEsVCu0JjrfQuMYhYm3lUSkydDqQjNKTrkvisnGB0j8UiMiJTmi94Hul2D0/fD7XdrC3cOf23RexCyW9MqbWBeY7wpkD9HcryzVSkMTuhTVz6RbFlitweth5tKNLIgdQ3rZacvLNcToGQs749ePkcmDbQ6Blz5n5H77zSDrYh/tAH1h4uBJokI3d2wJiDFA/lG7RQyj5U5rO31NXmCp3piAlqjjgCWoAWSc3V+Dj13TseeqCRfBY0uY/L1cojWA9oEuqY7/VV01O/p9DP7DkCx0I4UJ/lCsBObK4kBDhIgMyU0A4jAQE4QQnZR0g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(376002)(39860400002)(366004)(346002)(136003)(451199018)(31686004)(2906002)(83380400001)(66556008)(5660300002)(41300700001)(8936002)(7416002)(6512007)(26005)(6506007)(6666004)(2616005)(186003)(82960400001)(31696002)(86362001)(38100700002)(4326008)(66476007)(316002)(478600001)(66946007)(8676002)(36756003)(6486002)(6916009)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c0lvVzd1ZFV1WGdEVG1TTjhYUFFPT2VSTndrbGdmVDJOeFJXUGsyNWVqckk3?=
 =?utf-8?B?Y003QzNqRWM3dmsxZVFxQ1ZmY2lJcW95dmNuQ1hiZnRjb1diTGJIclBXd29W?=
 =?utf-8?B?NittNllJOCtLaWlkVHpPUDNXQUtIQ25tcDhZUGdGNFFwRVRpbXFOZVhKanUw?=
 =?utf-8?B?cGIzN0x0bVNoczhXdGpuOGViM0dlYnJ0TzhYei85ekZUNFR2TmRVWlZuNkZT?=
 =?utf-8?B?ZzNNWEk1T0xpVEVyd3l4eXlCa1dSOWhnK3c1NUpXTk16OWpoWEwyeE5UOEI4?=
 =?utf-8?B?Y05DcFNoZlNhcTFqaFNOUkpYV251SUZHT2dNRzFUY0tIamMxV3l6eE1iak1T?=
 =?utf-8?B?LzM0R0paRzU1OEhWeTJoS280czJXc0NyK2tnRDNVODJ1blpXdHZMMi8zN3g5?=
 =?utf-8?B?UFhaajhuQzM0d2ZPbHcyT2I2NEEzb3BlaXJSTjFLejV3VWRBMHpPb3lGRVFN?=
 =?utf-8?B?R3g1aEJOV0txVDVBRVh0elJUM3pVemFUWXc3MVFyMVhVNklud1dqR3NqTUZO?=
 =?utf-8?B?VFRaSG8zK2NXejZKSVlva1k0VkpsSzVQRUh4S0FUTjVDMytNNmg5b2Z5b3Fm?=
 =?utf-8?B?Mlh0T042SExMNzdIaFNVenNWWlRVWnMrS3dIYjNQSVJ3YUNIQzE3bjhCcWdu?=
 =?utf-8?B?akFYeHdzV2xoanl5aVl4a05UMmJheGxvRHgvYUlKTEJsdzBJMkNHMGN6aHdW?=
 =?utf-8?B?V2lXS1BHUi9JMDNIVERzTkdsUzNjVVR5Zy9OZ2E3eWphTWtwT21udHJ2ZHd6?=
 =?utf-8?B?cy8yUmZ3RE9uaGZHUUtRSzBlcjVFOXY5QXBncUtqTjJwbTJXTmxFSGxwYkNM?=
 =?utf-8?B?VVNZWmd4akRwT1EyREZDaTJqbXoxSzFuS21nS1dHSSsyeDVYSDBHVzhqMng0?=
 =?utf-8?B?WlMxaE9Vak1lcnRmNHVCMzBzV0VkZWJvUWplc1dMSWtwbjJ1N0U1eW9RZXpH?=
 =?utf-8?B?R3kvSFlnWGRPcml5bHk4Q1N4THhDRm41YmFXbmNtcWhCanVNMFBhWldtalVq?=
 =?utf-8?B?SHdGbEtqNVhPcFFFZDdJTHd3alVwYkc5QTMvSTFmZU5mdytBdWxuTjcxeUsr?=
 =?utf-8?B?RDRwdlJIODlUOWRpaTI5d0kweWV3RHZUMnNIakJYQUNGNTkvSEtrQWZRTkpj?=
 =?utf-8?B?YUpHYVpFSERyWkluWFBSU3oybUV1eDVyZkRZaTd0OXd1azh3SWpLck1sTDY0?=
 =?utf-8?B?bmxTeVQ3aExTQjh2N2JPRThSem5Id05rdUF4UUE1aGNiZ3FPMXFONkVhbVZz?=
 =?utf-8?B?d0ZIdStvdmU4eUM5NnlRZDhEanRzVnhMcVJxaFFpbkk1Ti9jSlZtdEdnQ25Q?=
 =?utf-8?B?M3oyRytZR29vZVRhY2FFcEZITDdtcVFhZ2RXWXZKS0NNNkxGOWUvRzBsRlkr?=
 =?utf-8?B?ZU9wclhlY29nV3d2SzBDSkhiVFN0Unp2bUxLclE0c1NwMzRJQmJrcndaRWJ5?=
 =?utf-8?B?UURBV2lrV0pjVThUNFFPdEdPbHBOUGdaeklnajl4QWxtWFpvYXcvOS9OQzJr?=
 =?utf-8?B?clNYb2R4bXNRTUFhYWhxUXk1MDVyNUxudHVvQkRjY0llcUxUeDc0TzByU05N?=
 =?utf-8?B?NG9vQmVlZExFQzcvaTVtTkt3YjRBbEppZ2JucDFycm9vZEg2TnVscG5sdFVm?=
 =?utf-8?B?cUR1Sit5NVBQM3kzelhPOU5zK3RJM3NCdmtPRGN3Zi9WSjRPc1BPY1ZyQlNz?=
 =?utf-8?B?YXFGZWp5MDJHT0xFcmUzOVVPUzJkeFh1d2U4eEEzY2tLd1laNERBNDBqdDQw?=
 =?utf-8?B?TWZISWFPUWVNZVRPN0RpWHpaaS9rckp4K1MvSXFPWFJPbmJUMTZOZVJGRlh0?=
 =?utf-8?B?SDdlQ1k0MElHdlc5aGtLd0hZdGp2cXBReEw3ang2ckJCdk42aUwrUE02aVZM?=
 =?utf-8?B?K3F1TW00UEEwSlFNQmFqUnhzMUdOWVdKZkJ0UFJNbWdvT2V4dGVkWmF2ZzFr?=
 =?utf-8?B?NVBYcjhnaXdtbGxoYndTb01sRTNTaFpmVzg3eGs5bUlBT2QrajB2U09vc1FE?=
 =?utf-8?B?eWR1VU9ZVkx0WU1SS1NEc216N1RFbVBaQmYvZjQxdXd6YzFwS2lyZjloUlpG?=
 =?utf-8?B?SHljTnp1Rzdlb1plTlRjOGkwY1A2a3FZRktydGlFZEtISjNLVWFxSXJqdCs1?=
 =?utf-8?B?TWJGMXB6VzQzUVA4U3pldjVkcjRrT2xEZmV2dXd4dlIzU0pYZTNLcnB5VFNn?=
 =?utf-8?B?Smc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8095acf4-245e-4aec-3cb9-08db02d8605f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2023 15:40:55.9383
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +3Irjfs/oZxm9xQWbrlkFlUQu8Tp6TdFSNKuJuUL3m08Oqlzm7XmH8LxMzVXtmO47vfE/SUkErzSD52k/mxN4ABRiXaKI7vztOiB5Lqq4Pk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6613
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Richard Gobert <richardbgobert@gmail.com>
Date: Mon, 30 Jan 2023 14:07:55 +0100

> Currently, the IPv6 extension headers are parsed twice: first in
> ipv6_gro_receive, and then again in ipv6_gro_complete.
> 
> The field NAPI_GRO_CB(skb)->proto is used by GRO to hold the layer 4
> protocol type that comes after the IPv6 layer. I noticed that it is set
> in ipv6_gro_receive, but isn't used anywhere. By using this field, and
> also storing the size of the network header, we can avoid parsing
> extension headers a second time in ipv6_gro_complete.
> 
> The implementation had to handle both inner and outer layers in case of
> encapsulation (as they can't use the same field).
> 
> I've applied this optimisation to all base protocols (IPv6, IPv4,
> Ethernet). Then, I benchmarked this patch on my machine, using ftrace to
> measure ipv6_gro_complete's performance, and there was an improvement.

Would be nice to see some perf numbers. "there was an improvement"
doesn't say a lot TBH...

> 
> Signed-off-by: Richard Gobert <richardbgobert@gmail.com>
> ---
>  include/net/gro.h      |  8 ++++++--
>  net/ethernet/eth.c     | 11 +++++++++--
>  net/ipv4/af_inet.c     |  8 +++++++-
>  net/ipv6/ip6_offload.c | 15 ++++++++++++---
>  4 files changed, 34 insertions(+), 8 deletions(-)

[...]

> @@ -456,12 +459,16 @@ EXPORT_SYMBOL(eth_gro_receive);
>  int eth_gro_complete(struct sk_buff *skb, int nhoff)
>  {
>  	struct ethhdr *eh = (struct ethhdr *)(skb->data + nhoff);
> -	__be16 type = eh->h_proto;
> +	__be16 type;

Please don't break RCT style when shortening/expanding variable
declaration lines.

>  	struct packet_offload *ptype;
>  	int err = -ENOSYS;
>  
> -	if (skb->encapsulation)
> +	if (skb->encapsulation) {
>  		skb_set_inner_mac_header(skb, nhoff);
> +		type = eh->h_proto;
> +	} else {
> +		type = NAPI_GRO_CB(skb)->network_proto;
> +	}
>  
>  	ptype = gro_find_complete_by_type(type);
>  	if (ptype != NULL)
> diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
> index 6c0ec2789943..4401af7b3a15 100644
> --- a/net/ipv4/af_inet.c
> +++ b/net/ipv4/af_inet.c
> @@ -1551,6 +1551,9 @@ struct sk_buff *inet_gro_receive(struct list_head *head, struct sk_buff *skb)
>  	 * immediately following this IP hdr.
>  	 */
>  
> +	if (!NAPI_GRO_CB(skb)->encap_mark)
> +		NAPI_GRO_CB(skb)->transport_proto = proto;
> +
>  	/* Note : No need to call skb_gro_postpull_rcsum() here,
>  	 * as we already checked checksum over ipv4 header was 0
>  	 */
> @@ -1621,12 +1624,15 @@ int inet_gro_complete(struct sk_buff *skb, int nhoff)
>  	__be16 newlen = htons(skb->len - nhoff);
>  	struct iphdr *iph = (struct iphdr *)(skb->data + nhoff);
>  	const struct net_offload *ops;
> -	int proto = iph->protocol;
> +	int proto;

(same)

>  	int err = -ENOSYS;
>  
>  	if (skb->encapsulation) {
>  		skb_set_inner_protocol(skb, cpu_to_be16(ETH_P_IP));
>  		skb_set_inner_network_header(skb, nhoff);
> +		proto = iph->protocol;
> +	} else {
> +		proto = NAPI_GRO_CB(skb)->transport_proto;
>  	}
>  
>  	csum_replace2(&iph->check, iph->tot_len, newlen);

[...]

> @@ -358,7 +361,13 @@ INDIRECT_CALLABLE_SCOPE int ipv6_gro_complete(struct sk_buff *skb, int nhoff)
>  		iph->payload_len = htons(payload_len);
>  	}
>  
> -	nhoff += sizeof(*iph) + ipv6_exthdrs_len(iph, &ops);
> +	if (!skb->encapsulation) {
> +		ops = rcu_dereference(inet6_offloads[NAPI_GRO_CB(skb)->transport_proto]);
> +		nhoff += NAPI_GRO_CB(skb)->network_len;

Why not use the same skb_network_header_len() here? Both
skb->network_header and skb->transport_header must be set and correct at
this point (if not, you can always fix that).

> +	} else {
> +		nhoff += sizeof(*iph) + ipv6_exthdrs_len(iph, &ops);
> +	}
> +
>  	if (WARN_ON(!ops || !ops->callbacks.gro_complete))
>  		goto out;
> 

Thanks,
Olek
