Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18C0F6BBBBF
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 19:12:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232017AbjCOSMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 14:12:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232292AbjCOSMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 14:12:33 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EADD56A9EE;
        Wed, 15 Mar 2023 11:12:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678903948; x=1710439948;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=SVfMHUwmEKO+Fr050Pn8QFsGsLpr2+wEss4RkCURRyA=;
  b=Vg4jQP1zbSWFz+UkgXDwjq8Bg1S3RWtLlcAgVZJozuBu3K6C8qwQG3Bs
   Q1gqjHPhFnhpS6NL34hgrvatSWBPSqJ2UhK2FYmwAZHh7mDnGTag510hk
   049io2RX95/L8+6lXYm3/pZ2VTC9VZmAu29vjm9exAedVIRSJ5/z561Mh
   TQ6r/9N4KRiMazBveXoAYRbibvNwecZs3WE3k0/1NYQYCIhqPWpelPsgO
   wuZTo/FQ1q1AkNS6pFbYYbz5ilsOHi3Tf0nNkoVQ1nPk/gF64Qy9fTOjq
   R8XVkTF+Yj2hLObLLlzr6EUJD+vgi87Md26J4W5cyHheYtDpGX9onj45s
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="317438921"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="317438921"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 11:12:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="822898317"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="822898317"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 15 Mar 2023 11:12:17 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 11:12:16 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 11:12:16 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 15 Mar 2023 11:12:16 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 15 Mar 2023 11:12:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gDHjmf8WHmwPSEaSUeSLHHKlJpHTjAR/X72S4P2vlVxbriAeQT2bTrOo9QUBfvhj1zbTfWKyKV4eABBYePhT7c8o9GESQGas3/UggY65Nsf7LKi9AgJuD+UUT5M7EsuLAr1cyQEjBBBRD5zGyH0nitDkpVzx2YidT9cfniKCUJKn3+cQk2Dlm+49Ls2wQS83Vi3fid2HbLcl4EMiYGob2i8LOoywwMcuQB76kkyFSG6+CkLk5T6VUsziXurThBQd6lpZsjl0Dh6GlmYC5GD5GYLdarA2rq4VaCzWb4UhMGT5Xkx2DLz41LLKa88CwlfsPdAODMMejMm2uqn1Em1COA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3h8L1x6wl796DVMRDBYatDKbBrXHPxF2XjXsDdGk/M0=;
 b=EtE0zQuN6z7H6HuN8ZoKofWQ01sr86d8bOIlHDlLoXwUchWh/S24M6u4N1xW1AWIWwfkyr2IhMTLUZ/SWNO+3eWzf4gaTfVANiCNTNKiNX5i0yfB02C21Mvi4NsGLDsuv4hLa0d6P58DjQBVLtEKP4eNyFMl1qoqWSe4df9KVSCe3JpSnFB5wrOPJx2aob2cv2jZDCBo9ZcJVHEIts40Rd8ZG9v7HdTLIUB4DlbtxYOAc+JhgOb2I6KrVg+kdb313s1ORMibBrb/Mr5BbYKjD2LQ6SNI1cbUytCGnv6v9Dh98baL33JLusPBmpzumOuhmqdHTubMN0ffbRxh54gaEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB2937.namprd11.prod.outlook.com (2603:10b6:5:62::13) by
 SA2PR11MB5210.namprd11.prod.outlook.com (2603:10b6:806:fa::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.26; Wed, 15 Mar 2023 18:12:14 +0000
Received: from DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::cece:5e80:b74f:9448]) by DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::cece:5e80:b74f:9448%7]) with mapi id 15.20.6178.026; Wed, 15 Mar 2023
 18:12:14 +0000
Date:   Wed, 15 Mar 2023 19:12:03 +0100
From:   Michal Kubiak <michal.kubiak@intel.com>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] i825xx: sni_82596: use eth_hw_addr_set()
Message-ID: <ZBIKcx6/77aePZUE@localhost.localdomain>
References: <20230315134117.79511-1-tsbogend@alpha.franken.de>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230315134117.79511-1-tsbogend@alpha.franken.de>
X-ClientProxiedBy: FR0P281CA0146.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::20) To DM6PR11MB2937.namprd11.prod.outlook.com
 (2603:10b6:5:62::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB2937:EE_|SA2PR11MB5210:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ec74a07-3e7c-4f5f-45bf-08db2580cdda
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /HVACcnld004XKM7ICgVx9cmqU3zF7vlDxRi7AhBqTpN1VetxxXDXfzXUNQH+x8nq8NBbEU1FLpdrwh3F3bqUfUcL/ZxoPIOeuYKfxVerjDqrhaGuKMUJCRfUwxUpqTK0eVannO212EyaPOpCpcYK0lxUOFnwwXSlolkriYpHUkso1AdhvonsHU00Qy8M+3OejXXiY8ZChDc//NLKq3mMzRQLbLBTQPDLmGNwlHewMOqV1BBx/QlH1ia6HnJOLlVYduyvP5bmiFb5Cq5FdBW8SkzSI4Zk6/y6clt874kUL4xk52vAVpH1TsEJxmIWBZw2lSn5Kxt0My1j3Rhk4S5EfwjpUQt+7D7tHKZdQhPe6F2DJUIUKDxlpFfZkL3JzdhfEVzNhxU1nsO1JoZGvvb82zkefdHXSnW7BdA0VxAq7GuZ+DP0DT+bARpBFwf2JgS8WrSuEVha17GNVCHoWNWTo035OqCA1Tn2utwkrxEKJ34kS46hzkWYz+ZZeYdG1PGJv/Kxp5KYlWzoEUL4BZ8yjrnCKJbkx1YGiaiwqh3hgg9/lCTjqDzFYT+O2zfOskkcAf9f6jkgK3BGWTK8Yq/UpIYm4wnd/24LojlDM+JTcHlzsG50Wzw3PNHmo2ApoOpggUEzIcHFTN9QpscLXayyg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2937.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(39860400002)(376002)(136003)(366004)(346002)(451199018)(86362001)(4326008)(8676002)(66476007)(6916009)(66946007)(44832011)(66556008)(5660300002)(2906002)(41300700001)(8936002)(82960400001)(6506007)(6666004)(26005)(186003)(478600001)(9686003)(83380400001)(54906003)(316002)(6512007)(6486002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YWMfNekLiTvwCsjAQyL0BR8x+T8gWgwLoFLM65lqrr25jpzHFePIa6PoHz5Q?=
 =?us-ascii?Q?eDvW/BdNBxsvIB98dl9KyKEoRoocDld6YxeFXvARtxvztgmdh4u18F5tnHl7?=
 =?us-ascii?Q?Yyv6qLoIDt+42Ve+cPTGXXkeWC5S9r8fQ+kNuue0iBJHl+58EppWdrsC9GBm?=
 =?us-ascii?Q?NZonL+i5s9I2+F25DSyVEUUg2VwFrqBfKUx0IqrrP+ms4Pn1abVhrlajwa60?=
 =?us-ascii?Q?OD9ZHBYxUf9UYPmlOePAyX43tRtYtt6PvA9OdKyWYfYtVaFdpzzdwVSXOjh8?=
 =?us-ascii?Q?BCWy+GQO/6kqDv4E7SbsVeaU3ACMohmVlAzmOCiYYs5UJQsY6GAfBCrxAqqT?=
 =?us-ascii?Q?QEX8BWq+6mxyezOIDg0QR5IlqAwrMkwfcT5iMhKOnLhpVdAOMLHwXI4vWD2f?=
 =?us-ascii?Q?7UPvuBX1ac1wOnrwvH9FAuxjZW62y8F1ktjJywHWfFxSmZLGRwwkEmJiOK6p?=
 =?us-ascii?Q?gwY9DBWQ8Q0kDnGc5wct1D7yYE+rNH0Y2oucExVwXJDSqyd6d9/vrGbD7a6U?=
 =?us-ascii?Q?btYqqEHW2qEV7G1Y1AutfkYx45kJlN9bQCi5/WTBhbWLO/nLAwnCVv4B47gc?=
 =?us-ascii?Q?DcywI0pAsSjhI3E+M+cr/uODnAYgRm+Uu1KzA4KLcMo6VZDbYtFyK5dG3Y+A?=
 =?us-ascii?Q?6oX6Djf8CXiFEUDAJiyPkUtBBDqoIlK5FEKp1QHTPTvdPqh8Y31YmbcM12ne?=
 =?us-ascii?Q?M4jF9hCz/kuhTf4lTxwpETNpqYaTiecRvUnd0761De+pQbSnMHFWjgXez8Nw?=
 =?us-ascii?Q?ekSanF1DJPndurEiPvq2W30Zcp3arQV9O3UuIqAgsAMgWuQS5ELeADSYSBRg?=
 =?us-ascii?Q?hFHANIqYHUQ1HLec0EeR1zMz4fest5S6UaLBM89UEd9Mlr4F1HnYvliTN++N?=
 =?us-ascii?Q?xYLVb5L7wgM4eBK7t6ojylQBAWEYaDa0i4rakpnniEDNHCn+Raq0KFemDq/P?=
 =?us-ascii?Q?HlDWvLUF2SBBTFaLEJ1/xixU7bT94cgWj4agsYdPx9ha4Z50ee7Sp8UghNd2?=
 =?us-ascii?Q?syrZrfEJm2Fc/yR0/utrucp+udIPvioA3Nfkr5VK0AWFgCpOGJhCkCCMbSnS?=
 =?us-ascii?Q?W54pcYUSFH4h4pxYrf8HYUdSTGh6xy0hI7+Q2zu8aV38rk+PhTlsQfp80T6v?=
 =?us-ascii?Q?wwq0uTJeGCYKFhneN4ZbhrFLLl4x/vJRmPUpoUjyRmIvbMKWasAI+HbPd/fj?=
 =?us-ascii?Q?+uutmqTuovo0FVqgULzjMZ/Yd78+Pagob4GGy+4LpGVQiSTzBisI7LkRCXtz?=
 =?us-ascii?Q?Vxkn+F/xFpue4AD6SeefR/6pMKYcEqnhpoEODAQhoNF+W6an62Ov2Lp3WrIp?=
 =?us-ascii?Q?dCZCJHhMT3LAqY9UfmltISb5C+majCJUNA05zJUOdwlRJ7wOXrqhwvdbLtVy?=
 =?us-ascii?Q?FNkxbVW04EF+M1LwqAS/uQjQYIwbZwtzxhBy3b4igQwEh/mZgKZmIvKa8Ftf?=
 =?us-ascii?Q?Fm5gGBO+3jycFURfx/NA7zOvfsV6JMAkq6yKmZAklYX071i5zc+bnkRmJqni?=
 =?us-ascii?Q?qOiHzMjKxhlpbqXV2qw/LgmXoj9wiuqFIFQ/k45u9NLfyPwjMZtmKdL5U7j5?=
 =?us-ascii?Q?hZfX95SvSjKr36ubjG38jyUyicw0ETElcZoJsEhTltxinKD/RTf2V9yWUHes?=
 =?us-ascii?Q?vg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ec74a07-3e7c-4f5f-45bf-08db2580cdda
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2937.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 18:12:14.4451
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xvHZYcXl9Y663bftw4+BkPcr0HqPmFzDoAt8Sq2cJlmcFnReTC1JpgusYjuHBmFj0T2yVBVdea1/l0DvIeTscg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5210
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 02:41:17PM +0100, Thomas Bogendoerfer wrote:
> Copy scrambled mac address octects into an array then eth_hw_addr_set().
> 
> Fixes: adeef3e32146 ("net: constify netdev->dev_addr")
> Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> ---
>  drivers/net/ethernet/i825xx/sni_82596.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/i825xx/sni_82596.c b/drivers/net/ethernet/i825xx/sni_82596.c
> index daec9ce04531..54bb4d9a0d1e 100644
> --- a/drivers/net/ethernet/i825xx/sni_82596.c
> +++ b/drivers/net/ethernet/i825xx/sni_82596.c
> @@ -78,6 +78,7 @@ static int sni_82596_probe(struct platform_device *dev)
>  	void __iomem *mpu_addr;
>  	void __iomem *ca_addr;
>  	u8 __iomem *eth_addr;
> +	u8 mac[ETH_ALEN];
>  
>  	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
>  	ca = platform_get_resource(dev, IORESOURCE_MEM, 1);
> @@ -109,12 +110,13 @@ static int sni_82596_probe(struct platform_device *dev)
>  		goto probe_failed;
>  
>  	/* someone seems to like messed up stuff */
> -	netdevice->dev_addr[0] = readb(eth_addr + 0x0b);
> -	netdevice->dev_addr[1] = readb(eth_addr + 0x0a);
> -	netdevice->dev_addr[2] = readb(eth_addr + 0x09);
> -	netdevice->dev_addr[3] = readb(eth_addr + 0x08);
> -	netdevice->dev_addr[4] = readb(eth_addr + 0x07);
> -	netdevice->dev_addr[5] = readb(eth_addr + 0x06);
> +	mac[0] = readb(eth_addr + 0x0b);
> +	mac[1] = readb(eth_addr + 0x0a);
> +	mac[2] = readb(eth_addr + 0x09);
> +	mac[3] = readb(eth_addr + 0x08);
> +	mac[4] = readb(eth_addr + 0x07);
> +	mac[5] = readb(eth_addr + 0x06);
> +	eth_hw_addr_set(netdevice, mac);
>  	iounmap(eth_addr);
>  
>  	if (netdevice->irq < 0) {
> -- 
> 2.35.3
> 

The fix looks fine. Good catch!
I would only suggest to add more description why it needed to be
changed.
(The current version of the commit message only contains information what
was done, but it is quite obvious by looking at the code).

Thanks,
Michal

Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>

