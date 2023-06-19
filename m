Return-Path: <netdev+bounces-11933-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 09E8F735588
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 13:14:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A4EB02810EF
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 11:14:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09AAFC2DC;
	Mon, 19 Jun 2023 11:14:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E948179C6
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 11:14:14 +0000 (UTC)
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2086.outbound.protection.outlook.com [40.107.95.86])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 655D891;
	Mon, 19 Jun 2023 04:14:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dl+n1TDiSRHgkXjC1AVhPNYZChm6VizCYOkcAbRTEBj/FwvnBcjkT0Kr9LMeM3kEp02GXL39dmTWm/EGIgzmmAerSxlYrAId83vb5JHhr+EfQGBVNdbLojkUkZA9vWqLfiCknR2vENTPqjZbH3ftO2vM7Jg4SsKUkrXGbYu8fyED3RNAiEBOfvQiDLjNjm7nBI9RyadTHPvrMtwly7WQjxaU1QU3YDkw43FQt8dXKHinlzM0GA6GUaY7yCC3ZRONeOHflj0YCCeBAA4zE3C1sVeeS3TerFYbx3IrnFuO+CAzu6weeUV5+BTS+a1jKqdLHfzJw0dZZwKlzlV5Brymhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EhAhghbDWiD+52jDrthUSHIu2loILfH5SHy5xK5VSOU=;
 b=gNOOI7gg3JffsjzbtZtiIhRa+1RjJedrW1w5/xESeNtOPycEKEdvTDRoQg4/qUjhqtrpHaKw+RZSBeLdPT3/H/hqbRTpRN/p7gu6pLBiDtuYb8zQbrZ+9wHXrfg/VkIE+kskTAFIWOXrE/v/s4zAm2BBOMRXRGqwwkXQMCWfzynq+QR/KDWl6xnYDc4yl6BgTGhQlrrH9FlS6rSYGC/lpE0nOzxpITUCAkFK1emeqx4qsFA6ywfQei3AvRfRS7xiCePWtCclsJOjceze9rlVl2qlnTSBIMf2OFT1/0CiiJFDONcSHugHc+h0KBlFZcYfxwA+oqW6jl2DI21NfE6gMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EhAhghbDWiD+52jDrthUSHIu2loILfH5SHy5xK5VSOU=;
 b=FmrfBBGY3z7G4tGaqaBePAPXiQnPlagWja439NXGmUIKHCVjDJpNv3dtQCRWI9OteHgp7Fe7rGZtPjUEt3YmqGD5p9j132mLVnHi/ILnz6Yeti7qYHDTjKgorqzoeFAdVaBARZD29a7lSMSA5qk5ZuGLuxe64Anbx5Z29QyitPapJyC0x4qk0F9j7XwYrXbaxg6QvXx7lwdrgVEtspf9XwUXRpUJEoNdf6CW+k4dj3L1pZZdhTgYbfXIPtxiqcETTR1cCFlzjtuvYuMfFmSDMyqMbWoBZ0iZeX8qYhzkfwmnZtb/zYUaWD0pYhJsyWktavKlJE9zQDogeMq52Wmg4Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DS7PR12MB6045.namprd12.prod.outlook.com (2603:10b6:8:86::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.36; Mon, 19 Jun
 2023 11:14:09 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::66d8:40d2:14ed:7697]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::66d8:40d2:14ed:7697%5]) with mapi id 15.20.6500.036; Mon, 19 Jun 2023
 11:14:09 +0000
Date: Mon, 19 Jun 2023 14:14:04 +0300
From: Ido Schimmel <idosch@nvidia.com>
To: r-gunasekaran@ti.com
Cc: kuba@kernel.org, Nikolay Aleksandrov <razor@blackwall.org>,
	Vladimir Oltean <olteanv@gmail.com>,
	Ravi Gunasekaran <r-gunasekaran@ti.com>, davem@davemloft.net,
	edumazet@google.com, pabeni@redhat.com, bigeasy@linutronix.de,
	simon.horman@corigine.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, rogerq@kernel.org
Subject: Re: [PATCH v2 net-next] net: hsr: Disable promiscuous mode in
 offload mode
Message-ID: <ZJA4fIH6vm9cO2VG@shredder>
References: <20230614114710.31400-1-r-gunasekaran@ti.com>
 <20230615223736.0577fb11@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230615223736.0577fb11@kernel.org>
X-ClientProxiedBy: FR2P281CA0045.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:92::17) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|DS7PR12MB6045:EE_
X-MS-Office365-Filtering-Correlation-Id: 388235cc-5765-40c6-e334-08db70b64d9a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ZS+MGxCSjpsUer6LJ0KtP88xJA/YihKLNOmffOGQeIgqfDM9Rcns2OjkX+FNwiEjz1w2Gzii0OkVSXLnFGa32h8YTOphKtF1bypRTiwwMxFZsp5fxqwCOSr0xY55y7bqAOBl/GCUXBclzifjuAKwe7h1hrW1md068w+NcJOny4YYTwdxZKqB0aU/Zt6TLOZ8ZApvGTTXCzSOXXf0Az33XMHw689xO7jeZswyd6D/pFAsxCynM8nqvAwo0sKaZl5nN5PkWBFfKroYV9548bTRWDkJvhwS/wUVeMyftEXoWc/MogPv1xl9mPuCg0XGY7tIFoAFZDKZ/PE4fy3STYH4+yVTGdzLsvKH7N/V8MqblAV7pzXDc6l6z2/IvzPSGhPuaHZWvODtpNuSTIBeVBUUFQSLflu1XuLfxoRL0Qch3F+P74vpxKHq8vSJbQ6b6nfKp4Cg11yZBzW4eveJhKMT9E9eUSy6LVWUZbqGuIRkjXRO8HKEyUPTY8XadV5j+4k7LR1BOdDoRIRN7kPfoY8pex3p0SdgapBiqIyPPQDER/qtnhlvScbxgaTGmspE2XQNo4drNevW3GtBHtAQNs8Mizbyetgt11YXWOQbNnHx0YQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(346002)(396003)(136003)(39860400002)(366004)(376002)(451199021)(2906002)(41300700001)(7416002)(5660300002)(8676002)(8936002)(33716001)(86362001)(9686003)(478600001)(26005)(6506007)(6512007)(186003)(54906003)(6486002)(6666004)(966005)(66946007)(66476007)(66556008)(6916009)(4326008)(316002)(38100700002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?K1vGKVNArNBxHxNAgz47j/J/isY+YO90Ps6zL/qxBbYI4ErBtH7KMVmq6bMw?=
 =?us-ascii?Q?MLe63+c99rmVo4gd32w82nanpWkoa5+TaI5ZXyBFV/figgOjASlOvWfUjgi5?=
 =?us-ascii?Q?FZjgukgl+ex+hJ/24dcI2JW1ed3ZpfmqWfVRaKxaFlbTYLQoxazhN/QTF6PM?=
 =?us-ascii?Q?Wr37PVsbLNeiEkQhpgF8Al/syHZ96abxqcLu5AYtl/foDxsf+jvF0BDUYHnp?=
 =?us-ascii?Q?nzheamdjpPurRCCbt9IuzHEGoYrYCBf+KLao2S3KLiP0QyHlWE+yDDyFtLZ4?=
 =?us-ascii?Q?W4GY7spAGqMzFqfY+gNOeRr5nDZMZ1QfziMtTOqQvOPQjcpqd6GbY9+QluM4?=
 =?us-ascii?Q?AwPGc/sfotNlwSNESE3jcK+BHQIyj3flxkBePyOeByJWBs+XMu14ymEgKTsZ?=
 =?us-ascii?Q?eVGgmmL2ORXFzzm36EE76t+VvxFkyKNHZ4iXuYp3ZX2e+po7DHVOwrVhJLUO?=
 =?us-ascii?Q?8ireoss+lBIOfa+iZ1NXO0WTrY7s3Y3BBbf+y1ao7O1nHbcFlxNaumapgdCk?=
 =?us-ascii?Q?qj6lHlxv1lI+S+vp5ztKXiQ/9VqdJW+ChEFB+fL7gbpw0Evw/mtYrDMk5RXa?=
 =?us-ascii?Q?+5vdGrcRq+knyJT/14QwWkWucGvyH6Lqjm27kmXFUEIu3OqOmg9nePoVPmmO?=
 =?us-ascii?Q?VcJy/Zp2BbOG474Z7rQg9nZ3b9F2GigxiH8O/PbmJZmEoT68in9ehFaBx/E8?=
 =?us-ascii?Q?pSoAF37IG+6XYf8OWRxu+mqir9kQ4gU5J2LQOvZEDV8CTs7Ydx7pIlRHe3Td?=
 =?us-ascii?Q?pV2FgFLWOcbk341TTv9NC6YPG4LJlXhuWwg5SuLDsLTJASbOTv5gcczrBTl+?=
 =?us-ascii?Q?8ElDz1u2SRRa+iQSZDay21HXQIxPxt5Tt5oTm6i7JgkfqRKXxSbvknaxNULC?=
 =?us-ascii?Q?h+V3Vn29QdZ6+57zIi+Lm8WMQjP3ZaEAm90hHBx0GbPjSxyfgugIyHr2wXjd?=
 =?us-ascii?Q?YnZJs3VC6Fq0nqACp161JI2v/q53H1zv2P5akzUQHh58VLuPbc0VKm9arm39?=
 =?us-ascii?Q?DX0myrnYJVwvV6iOLNpcm8ayfJ0DDlpkPlnJwMIrW0zPvp06cjfcWnJA9Icg?=
 =?us-ascii?Q?zj2/0BNyuQKzBndLVTVetEQJ9ntH++nns+xwO0chQ7XkIqTcXDMwqqX7tYTu?=
 =?us-ascii?Q?0Rs+QttP9pYS3a5Y9dQ+iQS+SBV6VJZgRpvC8o7V9SPg1Q16q99uJqrfX40H?=
 =?us-ascii?Q?VrPPO9glEV+BG901Mg49jBhg0CzOtJCghBKqzYZkEIsZuQpyG8sImH80+ilI?=
 =?us-ascii?Q?jMsBxxo8nvn91MzBqeSltlvlodjscnUIhjuMNnvRi31/bKfPkKqfz3PhxUJs?=
 =?us-ascii?Q?FL0vE5VgyLSRQpvo/t90cksHeOFVu1gCLRE9ll8DslXtHiXmvbxM0cXLK/5D?=
 =?us-ascii?Q?CAjdt3ly3L+XN5MHHa4AmRXCP2qrwLrD0d38aQyZakKL3wTi6gebyGYuKtiT?=
 =?us-ascii?Q?xnIhzS0+QVIsCyXpwLQFmYXj1EPwo2wCa4se1E2BXbeAp0Qe213KL1eii1aH?=
 =?us-ascii?Q?87wPN6jVp1i+hMrCVVnH+JTx9HLncneFJQ3BMHvH2ycFKRP8W01SHNrv/c8y?=
 =?us-ascii?Q?s8WY+vVJ6yI7X7SVfPB1TTIiJ+vRbkosUVMuikR+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 388235cc-5765-40c6-e334-08db70b64d9a
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2023 11:14:09.3714
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mcI7G9Raj8Vqc+FBSuQqPYr4W9mgsAfHGpNu8bBI7c2mSNpvcttPaXNkEc2v7moYzBIR24V5G5zzvOzJWojyoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6045
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 15, 2023 at 10:37:36PM -0700, Jakub Kicinski wrote:
> On Wed, 14 Jun 2023 17:17:10 +0530 Ravi Gunasekaran wrote:
> > When port-to-port forwarding for interfaces in HSR node is enabled,
> > disable promiscuous mode since L2 frame forward happens at the
> > offloaded hardware.

It's not clear to me why you want to disable promiscuous mode. I'm not
familiar with HSR, but I assume you want the hardware to forward all the
packets between the two ports and not only specific DMACs.

How does the underlying device implement "promiscuous mode" that you
benefit from disabling it?

Thanks

> > 
> > Signed-off-by: Ravi Gunasekaran <r-gunasekaran@ti.com>
> > Reviewed-by: Simon Horman <simon.horman@corigine.com>
> 
> Bridge folks any thoughts on this? Is this the behavior bridge has 
> and if not should we try to align the two?
> 
> > Changes from v1:
> > ===============
> > * Changed the data type of "fwd_offloaded" from "unsigned int" to "bool"
> >   and moved it below "net_id" struct member as per Paolo's comment.
> > * Collected Reviewed-by tag from v1 patch.
> > 
> > v1: https://lore.kernel.org/all/20230612093933.13267-1-r-gunasekaran@ti.com/
> > 
> >  net/hsr/hsr_device.c |  5 +++++
> >  net/hsr/hsr_main.h   |  1 +
> >  net/hsr/hsr_slave.c  | 15 +++++++++++----
> >  3 files changed, 17 insertions(+), 4 deletions(-)
> > 
> > diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
> > index 5a236aae2366..306f942c3b28 100644
> > --- a/net/hsr/hsr_device.c
> > +++ b/net/hsr/hsr_device.c
> > @@ -531,6 +531,11 @@ int hsr_dev_finalize(struct net_device *hsr_dev, struct net_device *slave[2],
> >  	if (res)
> >  		goto err_add_master;
> >  
> > +	/* HSR forwarding offload supported in lower device? */
> > +	if ((slave[0]->features & NETIF_F_HW_HSR_FWD) &&
> > +	    (slave[1]->features & NETIF_F_HW_HSR_FWD))
> > +		hsr->fwd_offloaded = true;
> > +
> >  	res = register_netdevice(hsr_dev);
> >  	if (res)
> >  		goto err_unregister;
> > diff --git a/net/hsr/hsr_main.h b/net/hsr/hsr_main.h
> > index 5584c80a5c79..6851e33df7d1 100644
> > --- a/net/hsr/hsr_main.h
> > +++ b/net/hsr/hsr_main.h
> > @@ -208,6 +208,7 @@ struct hsr_priv {
> >  	u8 net_id;		/* for PRP, it occupies most significant 3 bits
> >  				 * of lan_id
> >  				 */
> > +	bool fwd_offloaded;	/* Forwarding offloaded to HW */
> >  	unsigned char		sup_multicast_addr[ETH_ALEN] __aligned(sizeof(u16));
> >  				/* Align to u16 boundary to avoid unaligned access
> >  				 * in ether_addr_equal
> > diff --git a/net/hsr/hsr_slave.c b/net/hsr/hsr_slave.c
> > index b70e6bbf6021..e5742f2a2d52 100644
> > --- a/net/hsr/hsr_slave.c
> > +++ b/net/hsr/hsr_slave.c
> > @@ -131,9 +131,14 @@ static int hsr_portdev_setup(struct hsr_priv *hsr, struct net_device *dev,
> >  	struct hsr_port *master;
> >  	int res;
> >  
> > -	res = dev_set_promiscuity(dev, 1);
> > -	if (res)
> > -		return res;
> > +	/* Don't use promiscuous mode for offload since L2 frame forward
> > +	 * happens at the offloaded hardware.
> > +	 */
> > +	if (!port->hsr->fwd_offloaded) {
> > +		res = dev_set_promiscuity(dev, 1);
> > +		if (res)
> > +			return res;
> > +	}
> >  
> >  	master = hsr_port_get_hsr(hsr, HSR_PT_MASTER);
> >  	hsr_dev = master->dev;
> > @@ -152,7 +157,9 @@ static int hsr_portdev_setup(struct hsr_priv *hsr, struct net_device *dev,
> >  fail_rx_handler:
> >  	netdev_upper_dev_unlink(dev, hsr_dev);
> >  fail_upper_dev_link:
> > -	dev_set_promiscuity(dev, -1);
> > +	if (!port->hsr->fwd_offloaded)
> > +		dev_set_promiscuity(dev, -1);
> > +
> >  	return res;
> >  }
> >  
> 

