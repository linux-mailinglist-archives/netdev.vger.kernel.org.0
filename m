Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0CA638B7E
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 14:46:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbiKYNq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 08:46:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbiKYNq2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 08:46:28 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C955829353;
        Fri, 25 Nov 2022 05:46:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669383987; x=1700919987;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=tWvxhlNhwroqvmwcmjSaNR/RQPcM+kkPTKaFHDPMtQI=;
  b=an9NFAFE7vfNnpIa/YDTaijalb8riFEhBJM74i3Q/UD5WWnyYl1wGkP6
   3/JGx+zJ6aNk55yXqN3SwMndqpLsSvidRD0tSDSEur4ziWJETj4lG5nBd
   vFsBoy1EuS3hQ+CuFIY2IQbnTkrZ2uTC/+ZoY0Ca80NMieIi353zzBxKW
   cveUNZCQgs7yythIA5qUij5DCtVTyXIBIfIG5VJ2uiXArZQXQ3zAVU0pi
   rs9qe8CANyytgQbKVHQCmRQJ4Q8MXfgzgdgq0wZKe5QPxG5xCi+zPJ3hN
   +/lossSNPAcVMsc0znZCEb3RvXBshxzk0mNqMOfBbB2zyiWaURt0RUoCH
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="341388519"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="341388519"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2022 05:46:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="731447190"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="731447190"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by FMSMGA003.fm.intel.com with ESMTP; 25 Nov 2022 05:46:27 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 25 Nov 2022 05:46:27 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 25 Nov 2022 05:46:27 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 25 Nov 2022 05:46:27 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 25 Nov 2022 05:46:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X+UGB8wJw8hn0CdlYYgNMwedcaqoI/V2FQ+Uki02b1XM0E7FYikfRjiSMRFMNzRDwbPXFocu+GgdHwkRRKWierl52HZI4b+H0WkweTmB6Q2mf+DyWI+SgPKKbXHoCVC0cJIJWEfgArN9aKpFgfgjThybaPLMDx5r0jkv2LHjOCRM8ZsZctDF/lijEkPnaNoJNPo/FjbZNgE1T7UdgVEe0PMjhJ53CgWXrhjCM2a9CJI0B7nQbZfUszLBa7mrrM/72MliyhaeYZeTGTE2v5BAVVZpeXZn9kHgnHrUY7ROlTIXly2mwVuCv8/czWDsiuyf70jwq5CP/IXNeIE340L76g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TG6ENHXCuEu1SZ6bHkrXTjjwK0w2uzke5AxAHC2UCXo=;
 b=YyS/2RBw+S1vf/IdNJ5eF4M/lE50+XqkEwrqi3+F1wQixff1Dt8aVG6vC3ovHil7XUwMUoiuWiMZbVcAtJnYBCje1fOFAxyqmUADVc5vhC2jOc6B8rV8mfuD88y19taBUQnehnCn/www1gkHQvd++Y5ead99GDfNj7lZGmiI86xkInOjRDHt5Odn92o0Z7R0oyWJoom/Md6Zml9Fe8wzzUgbhN4KXslAuLNh+w/QBXuD9LEE56k7yjEyYPtB6YF0k9QVt0VoD4TSGPt1hkVLgpJpysxV1qKkLj6Aspoq5CUv1f+W7/fq5tQM7b8h8IBWUhdsJwNiOBdfqyLt0q6kzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 BL3PR11MB6316.namprd11.prod.outlook.com (2603:10b6:208:3b3::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.19; Fri, 25 Nov 2022 13:46:19 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6%6]) with mapi id 15.20.5834.009; Fri, 25 Nov 2022
 13:46:19 +0000
Date:   Fri, 25 Nov 2022 14:46:05 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
CC:     <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <naveenm@marvell.com>,
        <rsaladi2@marvell.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net 1/2] octeontx2-pf: Fix possible memory leak in
 otx2_probe()
Message-ID: <Y4DHHUUbGl5wWGQ+@boxer>
References: <cover.1669253985.git.william.xuanziyang@huawei.com>
 <e024450cf08f469fb1e0153b78a04a54829dfddb.1669253985.git.william.xuanziyang@huawei.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <e024450cf08f469fb1e0153b78a04a54829dfddb.1669253985.git.william.xuanziyang@huawei.com>
X-ClientProxiedBy: FR2P281CA0164.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:99::14) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|BL3PR11MB6316:EE_
X-MS-Office365-Filtering-Correlation-Id: cc0e8c3f-9e8c-4624-2b95-08daceeb6e32
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iqE24ayZUtHncx19w3jVUVN+apULLCNc4KrlKlr9pPzx0p9VEyIkPKSEeeonCNUoro/lt+sZqwfPfdlWa4vmm1uyj2qlFhazJf7sd2YRD37nVhroGrDEuf58wEtnIDqxJev62B0yHScxZlePKLNT2Sqcra3lYEd9wLjQgIceASwhrXdmKvKSvmcdeYbNmBpxSrq/H0aecRvkgPqtAt+ttgNBRrjJZkbQMDCl4IwZTV3yrQWMu/RzFohE1HwCxg6BXX+Y8f/8HrH15cXCdiVg0SXmkJsrLsSSBMJgDAeSqqw0wn2F3H83I2K8Sx8EX5ntjOxEAHps18xTGLS9IyFMfoUsGoj1/ehLTvK3wTE04YUof2hJyEkAoy81Uei9jhBtZzz1uRKNxVTnFiUNRPulA6z8713vHgTYamH49ZLEyWdZT+WfX2fuZ3DX+l4ypURHSB3L3X4EyB8bsRBKGG7y/iyGaVKFrK720qBPAUYU0tNSaY+IEefm12XO41XciIyIsVXwvlYLiHHXI2rH/7IIZNj9Zvy2NkH8NhSjIdE/J2Q46ZPBWfOPZ2er9ApUZLzRfnhEeVuL1soUs8hThFk9lbIZlcRsydB+J271Zd9q9I9JJMe1JJYntdXlKblEMpAzlMzpV6Tqtw67mx9I26RkhA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(39860400002)(346002)(396003)(376002)(136003)(366004)(451199015)(86362001)(44832011)(5660300002)(82960400001)(38100700002)(8936002)(83380400001)(6512007)(6506007)(9686003)(6666004)(41300700001)(26005)(478600001)(6916009)(6486002)(66556008)(66476007)(66946007)(4326008)(8676002)(7416002)(186003)(33716001)(316002)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2022B6jzl5hXjbWRDb8a8EGDVkrkIb7rveDrRrJttTc9bqkXn2Dc5Zlbs3ft?=
 =?us-ascii?Q?T6LtX/5WaXtoDr6QGrn6D8oNoMtFf9Tg/Gk75yegqgOSVt7AD4rqkUYK0en0?=
 =?us-ascii?Q?pU+i1BWtPxFVfxl8ck+fCRB3glJ2OiQeXii1KgaQj6mKyFjDc9uW9gW4eAJX?=
 =?us-ascii?Q?2VCt4KCnRLzQ3zmY0Z27vzgqFIPBIGtWTZ/ezyQAOEOnfcRuYPapofKsGNNl?=
 =?us-ascii?Q?WVoDgzFXCVEb9udlsekyUbchPuooWP87vrteKT1GIpmjR0l6MqVum90x89W+?=
 =?us-ascii?Q?n6He9+o2hP6Pxp8rJbE4ytBgxE9uEmqzTjngf0TyPWH80z0F9Tiz1/zZZ7gd?=
 =?us-ascii?Q?g9rk9E8XHBAmI57VBKZx0gTl3yqkIQs+TxGS6psFUNo/dTD0tGXNwmW6JrEi?=
 =?us-ascii?Q?UYMv85CinuJfzsgJs0Xkn5IzI9TPRoEAGY1vGXqQPWKPm5ram9gfq/W+GiN/?=
 =?us-ascii?Q?5OEflBB6EYeSi7s+/wvcFD94dpMCaYCjYQY09qKxq6ghTz2Qz4p8gVKprcMW?=
 =?us-ascii?Q?mUVrACQCyV8mZ1gJ2MdlXkY3rralugDN2rUQkrCBRQU58U4D5Fz6MH8CyZY2?=
 =?us-ascii?Q?Bjyt8e639SZHS35wPeoyCfQr2c2v0pUw7v6bi8tQ9MHIhQFptQdV8SA8+b/L?=
 =?us-ascii?Q?4QMPT1XNFvkhkgiKGoYequzemrYSa8i/vvOiIO5wZRRTdwkgIRNztEo9uU3/?=
 =?us-ascii?Q?i7DPUEiCopzACw1KKssPn3CSBG/H5QZpMcuzUXPiO4w4saU6NMygB7Hrk09Y?=
 =?us-ascii?Q?5s+e0QvWaXsCwu9wZVfPz6bqkQ+gbQmJXO+8DBp2/HrkpeoYxOguOn3BqhnM?=
 =?us-ascii?Q?xZFjH6vPCseiR1vrWpqD2+BXJ4RmUWp8LAhVpvKcc1RjOYVD2Upk9l1+zJVE?=
 =?us-ascii?Q?SvMnmMiznDxLslwzpgLnqBrmdM9QFUlt+60TRkcAY73UZ35gxBuNrPtosHpl?=
 =?us-ascii?Q?sjBNjz8GaWja7xoUxR7hSe7pUwvaR7R3b45kGTCZjW4PBkWu3u3U+Tc6r3jW?=
 =?us-ascii?Q?wupJ26I1zwt1RsQrPP2MXzfI/Ryjizuw0hJiVnFDAweO6TuCf7PE3xDPxmH0?=
 =?us-ascii?Q?+UVY1PotmsNdMkk1GyMSOIQSUg89Ry6v+8fFiFZcm2oE+sBrMkEoOS6WEIkA?=
 =?us-ascii?Q?59DXi+qY1yb1sbS+FTDCFHjjf+/yIwVMSBwmE+pGOhHQv5gmyMrWO3e2TjkR?=
 =?us-ascii?Q?aMcBJms6/nJS4OT3pv9egdPuwRsE64cXcvrNHSA6nf+gaLbEUFJMhLsZwF6f?=
 =?us-ascii?Q?N754UkzwojzxSll63svb3wGcNNHakhTtUYUIHf05pJC1H9uX63xmRDJoZvd4?=
 =?us-ascii?Q?GqqNlVdv6BUnZMxyf816i2DoJYwdeyMNGSks7reHcDnaGWSZqHrTevnq95Df?=
 =?us-ascii?Q?xdSE8g/uo/9SAXwXhsjQFc2Fu0ZEaJpMscm01wASP4SrHyyeY1+ssQjnKEEu?=
 =?us-ascii?Q?udxo3qwZJLqN1z9/vN/uZnhzqRisj75upqL56ACuk7MKpzdvdbo07jRzJtuk?=
 =?us-ascii?Q?2FOstR1CHXtMfeVlIt5EtlQJX50gy1MJLULM3hSa1JdXASgxv+p4phX8QQin?=
 =?us-ascii?Q?zUAkHbqHIaVVojYTwNgjXmK9tqL6eDnqH9nfMgSKF/z2dN1fi5JpdKaAlQw6?=
 =?us-ascii?Q?Hw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cc0e8c3f-9e8c-4624-2b95-08daceeb6e32
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2022 13:46:19.1982
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CIvAen1WOxXh3q325WNN4IplNCuBJHlEnM1Ed4IRgCniD63Ox99bfPUm3RtXQRkf+0k1MQnyWfD7zaxwpl8WQCqZcSE5swyk9jO2vdtXD4M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6316
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 24, 2022 at 09:56:43AM +0800, Ziyang Xuan wrote:
> In otx2_probe(), there are several possible memory leak bugs
> in exception paths as follows:
> 1. Do not release pf->otx2_wq when excute otx2_init_tc() failed.
> 2. Do not shutdown tc when excute otx2_register_dl() failed.
> 3. Do not unregister devlink when initialize SR-IOV failed.
> 
> Fixes: 1d4d9e42c240 ("octeontx2-pf: Add tc flower hardware offload on ingress traffic")
> Fixes: 2da489432747 ("octeontx2-pf: devlink params support to set mcam entry count")
> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
> ---
>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
> index 303930499a4c..8d7f2c3b0cfd 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
> @@ -2900,7 +2900,7 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  
>  	err = otx2_register_dl(pf);
>  	if (err)
> -		goto err_mcam_flow_del;
> +		goto err_register_dl;
>  
>  	/* Initialize SR-IOV resources */
>  	err = otx2_sriov_vfcfg_init(pf);
> @@ -2919,8 +2919,11 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	return 0;

If otx2_dcbnl_set_ops() fails at the end then shouldn't we also call
otx2_sriov_vfcfg_cleanup() ?

>  
>  err_pf_sriov_init:
> +	otx2_unregister_dl(pf);
> +err_register_dl:
>  	otx2_shutdown_tc(pf);
>  err_mcam_flow_del:
> +	destroy_workqueue(pf->otx2_wq);
>  	otx2_mcam_flow_del(pf);
>  err_unreg_netdev:
>  	unregister_netdev(netdev);
> -- 
> 2.25.1
> 
