Return-Path: <netdev+bounces-1703-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BCA166FEED7
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 11:30:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 68730281658
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 09:30:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6ACF827700;
	Thu, 11 May 2023 09:30:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58BED1B8FA
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 09:30:29 +0000 (UTC)
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2088.outbound.protection.outlook.com [40.107.20.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB14F40C1
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 02:30:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RwF/fz5yjFs4ugfxydj+W5mWDUH4dQh6aZqtvVgNgCRLkTEgVdqfOFqqoU1sz7JDIlf9nsHhBRLH54PYuL0Bg14TFqbldrvKN55H71KI6piERgHMlrkj34OPi31hjw4ydoWAs6+iWn1fqCQ0eWnTDsFNAZqfwUjOdBrURAya0etcAbCQSuLsVikPZG9qY37W5rIw1ZA1+59UtpMK3fvilOFIApLkHeB1QTT/9TlBr5P+0LcaJUEV3xNicDwaa50Het9qs0dXU2Qmdlx/AZwPSa/JkgGDZ8GYgn4OfgcunlWStzdFUyt4RwN6O3JIZfNlYKR7oIaMMk49Fv4L346FPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=49aCWhtwertupJX3JPIdS0HyHrFEiY2cmLeYg+6AlFU=;
 b=lZeLtQM+QceTnnnJoSF3KjN1QUyJGQjduaBQP0UygRNxrQVJNP/KQHhE5yvKHHstWV5e/hazM3bqZf/J85MiEAQ9vSqJ9LWraFZ/9cQZPQSOhqAUU8RYdoS73KHclLyIkLSk5/I51M5laC8BWxd9coYKPuBVM2xZGTYf+KXPWqMFufzb3foAkedSs41hJiVA1SU1OcQeQzb+zK73mXjtd0vOM7KmA1QjdL9r3IR9LhCOfxenPeE5VlciYrW/jU6NFGcPbL4u+D4OKIBfDG/2SHz67hzLxJSz9JBGXllGfPU8jajygOSfjnWMDd8+dKsCzqX/r7eXc4UBFqdsktHpLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=49aCWhtwertupJX3JPIdS0HyHrFEiY2cmLeYg+6AlFU=;
 b=m0bgw4tRUgLXW3MhGj/PZCIcLCF8MW8MLYpRCZ3I+5B5YXKTQ0Eem8TV6PjvLEq7MZVcKAzhTXxhXs5yx94FI7oAq01ipl1+Tff8U1qDvTxarNJlqjD50OIvI3XZTbe849nW7r3+0tbBx3/W4pVG+EQhPeJ+Q7jzczvccLMUnTA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by VI1PR04MB6926.eurprd04.prod.outlook.com (2603:10a6:803:133::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Thu, 11 May
 2023 09:30:22 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c%3]) with mapi id 15.20.6363.033; Thu, 11 May 2023
 09:30:21 +0000
Date: Thu, 11 May 2023 12:30:18 +0300
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: Maxim Georgiev <glipus@gmail.com>
Cc: kory.maincent@bootlin.com, kuba@kernel.org, netdev@vger.kernel.org,
	maxime.chevallier@bootlin.com, vadim.fedorenko@linux.dev,
	richardcochran@gmail.com, gerhard@engleder-embedded.com,
	liuhangbin@gmail.com
Subject: Re: [RFC PATCH net-next v6 2/5] net: Add ifreq pointer field to
 kernel_hwtstamp_config structure
Message-ID: <20230511093018.xjeo2rep2pp5st3b@skbuf>
References: <20230502043150.17097-1-glipus@gmail.com>
 <20230502043150.17097-1-glipus@gmail.com>
 <20230502043150.17097-3-glipus@gmail.com>
 <20230502043150.17097-3-glipus@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230502043150.17097-3-glipus@gmail.com>
 <20230502043150.17097-3-glipus@gmail.com>
X-ClientProxiedBy: FR0P281CA0112.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a8::11) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|VI1PR04MB6926:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a232729-887a-4731-e43c-08db52025796
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	tDFG0xC89bIMKMyotEn9vfuqbmunidkUBoJn+Jvhq/u4g90Myi6FN1kIAcaEQfGVmnxPvtgEFk4JbKa80D614uareop5pGWsLpRkjac26IsA5QfRQnDwSKEcwvYsB6CpYNg7ZrnfGjL0furBtocplLKSQ6qMwoSVQacHirY+PmP5C2+Y7OoSZpTbBXRxEPn99H9dxWHft6RxHCFVU/M9AsPWi/swMeBQe4+WxIyouLZDXiwSfZJidWO+bhQLYw2Q0SANv67Nn8OpNk4W5lswna9XegVuJAsFP9WSma6P6b62hF3k8h5SF+zp8r9SZ6IT1kcpJOtWKhXDU2u62Pa57djkd0eN/RcS+Z3XlBQZb1dxyBK8y+b9GY/l//Hsb7/+k/ydif6+a8a0Lu0LtOlqAgw9jzzyTOSOwTMG//6lOOawA1VH9RMB56mzDR68r4uZA3vjt230E0PYNaVNoy3DHn7dFB5Em2+/+qnbWj6YHCQFEe/21KEM7E8WjeZJRFcOMWVRhgbQ2O5P+XSnbgCyf5c4s+/LVkyyxPGTOJR7wCmc86hig0AmWxduJ5VqHpu4
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(39860400002)(396003)(366004)(346002)(376002)(136003)(451199021)(6512007)(9686003)(26005)(6506007)(1076003)(6486002)(86362001)(38100700002)(33716001)(186003)(83380400001)(41300700001)(2906002)(4326008)(8676002)(5660300002)(66556008)(66476007)(6916009)(316002)(478600001)(8936002)(44832011)(66946007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?T0x6cJiDtpgeWZ1ZjHafZK0RjpDbGJLVTrO3A96nWR2JLeLDkokBjnp4e99G?=
 =?us-ascii?Q?RedWJx/WJvRH79LBq3J/fvSw9sp4VwPViyPdKAA5BUygEMOzKGe6Dnmji1e6?=
 =?us-ascii?Q?p0MAe/s2Zy8SxS2eotlXOdTv2P/dJ1uleYESKTFXceZz/PoO9iXxpO3Nm0oZ?=
 =?us-ascii?Q?1CJNvrqEpDU5J0ZXv3ekctMjyMz2BjZHOUdnik1qjEZjY06Twcsq+E/fqpI5?=
 =?us-ascii?Q?qeE8SYN/E+ueq+bM1JedPjFazPqSbzXCUIEMA45UOs3ocMX3XCNlvZLpYDz/?=
 =?us-ascii?Q?RwXh/eBH3Ugg/ILvCUxQPFmK2mJilPwYIxuXjvHZGxP6MAfZsqze6cbn8uwx?=
 =?us-ascii?Q?p3+c7uElSETwALix2yeqeeZf65Pr8fKv5/rhkcosWJV8tEhbsNg4zLGMEwMS?=
 =?us-ascii?Q?P1GNYCqO3+o4iP7THaDg5rFQXaKR055Fd8KqvCRFymJ1VBRRCm8X4VphPIv+?=
 =?us-ascii?Q?PhG/LuLcVLDq9CdHE2ApNIGZfQyyF8zYhiF5dQPKqy1C1GWgKoVGnx+IIIQN?=
 =?us-ascii?Q?RcAG2J0mA2VD1zyXo7S85a6h3aJnQMkRgkBUUfWnM8UBXVV1Uap70ikC8DB5?=
 =?us-ascii?Q?CaBN4xEbLxizADzLwFCv12GmoDa+DxHDSii0Z03IjdjdHZHbqTlBQe1cFWrW?=
 =?us-ascii?Q?BONfVo1E1PVnTosWk7c7qdjTIC46aXx8XyUeafWRoR2kx5tr/t+LFBSe6dU4?=
 =?us-ascii?Q?h2rA4hNIDD6ugXjkqcWBixVzstoNpX+jtg7I1hVnFopexuPjFzGn2a2PsMb2?=
 =?us-ascii?Q?QSoNosHrT1eoz7ctvFU6As0QzKB0MhOJIpkS1S/HE9dIGjGKK8rZs6P0B6Bb?=
 =?us-ascii?Q?TO5nIWfF0wpiHO3zLlFYLfzEOGrPzNVQciYEhdplit79eI7R8lkedpsorgpS?=
 =?us-ascii?Q?gqsc4kbbZZdfUIR1z6f/oq6Bw3eclQoy3LnUGiGhjS6otR9hrt5UQ5FktEom?=
 =?us-ascii?Q?g/Xs0DvPDvHgf00hQk7iPZ+/K8ZBo05MUOGBIcrvNNoe0k2r7kKdYh+wnIRX?=
 =?us-ascii?Q?3UY5ib11Pxnk6RNvAs/81rt4J8c0lzrJfS3vTilGulJiBiL+FQPxPXyi2XCb?=
 =?us-ascii?Q?FwM898OvzQ5qZBBpKLj8Xz9ODXaPQlh0a/Qv9n6mstXMyOGgSrmBNKxZo8vU?=
 =?us-ascii?Q?sSUcSCTPu90Zgn10Hdsl0BkiReKuhqQ87hvuor2Zsrp4nZYbCdKTmXeDrVnc?=
 =?us-ascii?Q?S+gMmBCUXpR1ciRH3RxwQUB81JswQ51UnxbjhlWpOjxpLBRRK1Jf/7cc4rX8?=
 =?us-ascii?Q?KjodQjQJMuhUjUFJyBMcsEIFwFU/gDBYXTfHnqTjKds10yFejZrH8mPq/XOX?=
 =?us-ascii?Q?q4mfZ3DFZPzr5U+CoxKHNPFh/O7oidzLp55OdeF83N6q8DpadUu0oRQEc4kZ?=
 =?us-ascii?Q?FbWGYsqFWa2WxWFGPej9TQX9fLCoFlF6TqTP48kGsqWDPSg9xZVjJbmi8tWk?=
 =?us-ascii?Q?0R3UdWG8HnmqMyZ+yPxjL3EVk8Wg1GaBpJvOsDrzjA6wU09WOPtaKRfTBV8R?=
 =?us-ascii?Q?ylwFDfpcBliMrrig4wNO7jjSd5sdLMvXPNnfkmmW5KtMnLcGfEAieeA7d/bN?=
 =?us-ascii?Q?hpjj7+Cx4dqj7l5n4KJ1mohlqMg15YM0TOG2EtZOj9AQTs2ZKtHFu77rRdx6?=
 =?us-ascii?Q?GA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a232729-887a-4731-e43c-08db52025796
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 09:30:21.8676
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3AZmVpw68mhoC2JO6qlcvaQfIpamtznZVYbc4ePqYj0wD3Z0BcI17K/czukm0h8O733EkWvJjZzy7KV5p9q8hg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6926
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 01, 2023 at 10:31:47PM -0600, Maxim Georgiev wrote:
> Considering the stackable nature of drivers there will be situations
> where a driver implementing ndo_hwtstamp_get/set functions will have
> to translate requests back to SIOCGHWTSTAMP/SIOCSHWTSTAMP IOCTLs
> to pass them to lower level drivers that do not provide
> ndo_hwtstamp_get/set callbacks. To simplify request translation in
> such scenarios let's include a pointer to the original struct ifreq
> to kernel_hwtstamp_config structure.
> 
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Maxim Georgiev <glipus@gmail.com>
> 
> Notes:
>   Changes in v6:
>   - Patch title was updated. No code changes.
>   Changes in v5:
>   - kernel_hwtstamp_config kdoc is updated with the new field
>     descriptions.
>   Changes in V4:
>   - Introducing KERNEL_HWTSTAMP_FLAG_IFR_RESULT flag indicating that
>     the operation results are returned in the ifr referred by
>     struct kernel_hwtstamp_config instead of kernel_hwtstamp_config
>     glags/tx_type/rx_filter fields.
>   - Implementing generic_hwtstamp_set/set_lower() functions
>     which will be used by vlan, maxvlan, bond and potentially
>     other drivers translating ndo_hwtstamp_set/set calls to
>     lower level drivers.

Usually the notes go below the "---" line so that they are stripped once
the patch gets applied, but are otherwise visible to reviewers. It's
good having them nonetheless.

> ---
>  include/linux/net_tstamp.h |  9 +++++
>  include/linux/netdevice.h  |  6 +++
>  net/core/dev_ioctl.c       | 80 +++++++++++++++++++++++++++++++++++---
>  3 files changed, 89 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/net_tstamp.h b/include/linux/net_tstamp.h
> index 7c59824f43f5..91d2738bf0a0 100644
> --- a/include/linux/net_tstamp.h
> +++ b/include/linux/net_tstamp.h
> @@ -11,6 +11,8 @@
>   * @flags: see struct hwtstamp_config
>   * @tx_type: see struct hwtstamp_config
>   * @rx_filter: see struct hwtstamp_config
> + * @ifr: pointer to ifreq structure from the original IOCTL request
> + * @kernel_flags: possible flags defined by kernel_hwtstamp_flags below
>   *
>   * Prefer using this structure for in-kernel processing of hardware
>   * timestamping configuration, over the inextensible struct hwtstamp_config
> @@ -20,6 +22,13 @@ struct kernel_hwtstamp_config {
>  	int flags;
>  	int tx_type;
>  	int rx_filter;
> +	struct ifreq *ifr;
> +	int kernel_flags;
> +};
> +
> +/* possible values for kernel_hwtstamp_config->kernel_flags */
> +enum kernel_hwtstamp_flags {
> +	KERNEL_HWTSTAMP_FLAG_IFR_RESULT = BIT(0),
>  };

I think "kernel_flags" and KERNEL_HWTSTAMP_FLAG_IFR_RESULT are slightly
overengineered and poorly named (I couldn't understand yesterday what
they do, tried again today, finally did).

I believe that a single "bool copied_to_user" would do the trick just
fine and also be more self-explanatory?

>  
>  static inline void hwtstamp_config_to_kernel(struct kernel_hwtstamp_config *kernel_cfg,
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 7160135ca540..42e96b12fd21 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -3942,6 +3942,12 @@ int put_user_ifreq(struct ifreq *ifr, void __user *arg);
>  int dev_ioctl(struct net *net, unsigned int cmd, struct ifreq *ifr,
>  		void __user *data, bool *need_copyout);
>  int dev_ifconf(struct net *net, struct ifconf __user *ifc);
> +int generic_hwtstamp_set_lower(struct net_device *dev,
> +			       struct kernel_hwtstamp_config *kernel_cfg,
> +			       struct netlink_ext_ack *extack);
> +int generic_hwtstamp_get_lower(struct net_device *dev,
> +			       struct kernel_hwtstamp_config *kernel_cfg,
> +			       struct netlink_ext_ack *extack);
>  int dev_ethtool(struct net *net, struct ifreq *ifr, void __user *userdata);
>  unsigned int dev_get_flags(const struct net_device *);
>  int __dev_change_flags(struct net_device *dev, unsigned int flags,
> diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
> index a157b9ab5237..da1d2391822f 100644
> --- a/net/core/dev_ioctl.c
> +++ b/net/core/dev_ioctl.c
> @@ -265,14 +265,17 @@ static int dev_get_hwtstamp(struct net_device *dev, struct ifreq *ifr)
>  	if (!netif_device_present(dev))
>  		return -ENODEV;
>  
> +	kernel_cfg.ifr = ifr;
>  	err = ops->ndo_hwtstamp_get(dev, &kernel_cfg, NULL);
>  	if (err)
>  		return err;
>  
> -	hwtstamp_config_from_kernel(&config, &kernel_cfg);
> +	if (!(kernel_cfg.kernel_flags & KERNEL_HWTSTAMP_FLAG_IFR_RESULT)) {
> +		hwtstamp_config_from_kernel(&config, &kernel_cfg);
>  
> -	if (copy_to_user(ifr->ifr_data, &config, sizeof(config)))
> -		return -EFAULT;
> +		if (copy_to_user(ifr->ifr_data, &config, sizeof(config)))
> +			return -EFAULT;
> +	}
>  
>  	return 0;
>  }
> @@ -289,6 +292,7 @@ static int dev_set_hwtstamp(struct net_device *dev, struct ifreq *ifr)
>  		return -EFAULT;
>  
>  	hwtstamp_config_to_kernel(&kernel_cfg, &cfg);
> +	kernel_cfg.ifr = ifr;
>  
>  	err = net_hwtstamp_validate(&kernel_cfg);
>  	if (err)
> @@ -311,14 +315,78 @@ static int dev_set_hwtstamp(struct net_device *dev, struct ifreq *ifr)
>  	if (err)
>  		return err;
>  
> -	hwtstamp_config_from_kernel(&cfg, &kernel_cfg);
> +	if (!(kernel_cfg.kernel_flags & KERNEL_HWTSTAMP_FLAG_IFR_RESULT)) {
> +		hwtstamp_config_from_kernel(&cfg, &kernel_cfg);
>  
> -	if (copy_to_user(ifr->ifr_data, &cfg, sizeof(cfg)))
> -		return -EFAULT;
> +		if (copy_to_user(ifr->ifr_data, &cfg, sizeof(cfg)))
> +			return -EFAULT;
> +	}
>  
>  	return 0;
>  }
>  
> +int generic_hwtstamp_set_lower(struct net_device *dev,
> +			       struct kernel_hwtstamp_config *kernel_cfg,
> +			       struct netlink_ext_ack *extack)
> +{
> +	const struct net_device_ops *ops = dev->netdev_ops;
> +	struct ifreq ifrr;
> +	int err;
> +
> +	if (!netif_device_present(dev))
> +		return -ENODEV;
> +
> +	if (ops->ndo_hwtstamp_set) {
> +		kernel_cfg->kernel_flags &= ~KERNEL_HWTSTAMP_FLAG_IFR_RESULT;

I don't think you ever need to unset this flag, just set it? The structure
is initialized in dev_get_hwtstamp() and dev_set_hwtstamp() as:

	struct kernel_hwtstamp_config kernel_cfg = {};

which zero-fills it.

> +		err = ops->ndo_hwtstamp_set(dev, kernel_cfg, extack);
> +		return err;

		return ops->ndo_hwtstamp_set(...)

i.e. skip the "err" assignment

> +	}
> +
> +	if (!kernel_cfg->ifr)
> +		return -EOPNOTSUPP;
> +
> +	strscpy_pad(ifrr.ifr_name, dev->name, IFNAMSIZ);
> +	ifrr.ifr_ifru = kernel_cfg->ifr->ifr_ifru;
> +	err = dev_eth_ioctl(dev, &ifrr, SIOCSHWTSTAMP);
> +	if (!err) {
> +		kernel_cfg->ifr->ifr_ifru = ifrr.ifr_ifru;
> +		kernel_cfg->kernel_flags |= KERNEL_HWTSTAMP_FLAG_IFR_RESULT;
> +	}
> +	return err;
> +}
> +EXPORT_SYMBOL(generic_hwtstamp_set_lower);

EXPORT_SYMBOL_GPL()? We expect this to be used by core network stack
(vlan, macvlan, bonding), not by vendor drivers.

Same comments for "set".

