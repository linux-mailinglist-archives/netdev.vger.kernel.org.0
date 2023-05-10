Return-Path: <netdev+bounces-1421-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EA82C6FDB84
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 12:22:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1C6681C20BF8
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 10:22:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDF5F7471;
	Wed, 10 May 2023 10:22:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C942F569C
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 10:22:22 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2099.outbound.protection.outlook.com [40.107.223.99])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55B3B2D7F;
	Wed, 10 May 2023 03:22:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W7160LIunxIAnYozDpkeBgiUX8YMsMO25Ic42gSHc1OQfSS1g4Cj4zEIin8uZfM3J1Ice9DjTRqT2+8kI+AnaGb+21hDe9M5uqfX+uw7EYWte4mfavyzId+ziW4RCiCn895Qy0k9AQ4CqvFZ1okVAQWyRE3UzB5HDRd4Lq4meIJWZNl74tGTM14DLXZp6eQo615wyA2c/qmSm+YASFoWxviJk9WS+6/Oo8lQPir34zba5CH11qm35ps0AgiEhTgy6Tp0GVYwZ4vW/e9zssNITTzOQzNMQEZLyiiqEgrphqgWnjes/DAMV3rkBv0FeWeCNJ6mextxxPWeEVwnDcmfOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g8KkAXlsXpCiuuX2tZH/quvnq0c6xiG3XVhyoWJ+fd0=;
 b=D34A2ICrQ/L1YovgH9mvA4IoCGtFDUTwvH2Ac8YqGWEpA1KXB/wD46w/4uYJoRgDXp4Jxl35f8EryHKxdZHiR4ZB4datOtrXgHxdmkU6tplHWFMytG7eNCa1jBLFlm5+clQ4kmUroKfLcc3diYoUvcxPYJKVp/F94Vv9Fn3gmDWvcfNKvFOFzTYLiL3uoFeYBX4jkdBI5RU7KXhOI7bGxbgZ0hrQiKHllMj6lvVG31eTzcyqkPwH64o9yd4rkwp+KRpHYpIogrhKPD27QNe+Vcb3DbSobEbepqGvt9riQ3Zz1Lfg6ON2DD8iKMIK+3and7gZ22nBAUM3py6M7r+r4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g8KkAXlsXpCiuuX2tZH/quvnq0c6xiG3XVhyoWJ+fd0=;
 b=ZVIsezHOMZ9bBt+PYEKiHx843bc2+jDI2UIBmWAEY3B7lgawLzvVl5T58+JepldGaw9+NXVa49+qLQRWcWk+3KL9ORGDDf/5hI/3MzqOznCcmmuTdGddyjfsA3QSd95IuPei17bdBk8oRt3LB5JGcqqI/ff8mdYhPyuPNSj39ew=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW5PR13MB5629.namprd13.prod.outlook.com (2603:10b6:303:195::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.20; Wed, 10 May
 2023 10:22:18 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.020; Wed, 10 May 2023
 10:22:18 +0000
Date: Wed, 10 May 2023 12:22:11 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Yan Wang <rk.code@outlook.com>
Cc: andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux@armlinux.org.uk
Subject: Re: [PATCH v3] net: mdiobus: Add a function to deassert reset
Message-ID: <ZFtwU1svXhZ/xrnJ@corigine.com>
References: <KL1PR01MB5448A33A549CDAD7D68945B9E6779@KL1PR01MB5448.apcprd01.prod.exchangelabs.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <KL1PR01MB5448A33A549CDAD7D68945B9E6779@KL1PR01MB5448.apcprd01.prod.exchangelabs.com>
X-ClientProxiedBy: AS4P195CA0045.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:65a::18) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW5PR13MB5629:EE_
X-MS-Office365-Filtering-Correlation-Id: 095af2d9-b877-48f2-0901-08db51406e83
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	i297iyZcJ6sJXd46mvPGG9J+DXYtkgqL2yP3MLpOV04AdJDoi9Q7xS0jQJVVO+pXxSN66/lREISX2LA0czQSschwq381cIYTmX2v8+AdpTsdayW13siGVqurglq/DdQd60UiDzhxCK6BhpaLZwBWnKNeACdF1fwNlftP81Wf+U5mQUHPvPgHxHNfxl3B17wbIPxmqbf+rif2/ghhKrDPsx0maMObAZH6bk/unK1gDkJaJfACwbvzGJiHpgMWdlhULrHGG0VBC4A1MGAqyOmkjBycMSgiAHkxeFJVJ4kOUtyLemHCQo2Z/Ke22l6PRAtKnPTZsBhIeug67ah8t2pkSl0G5WyCX9bpRN6PjYORkCwmxX0nq5itO8LsV5GBzrr6kdDkBWtQslI6KJm4vsh1g3uKMZ4S5RPpiqdZPLf9/grixa5rqCQvBgPsVZ7XY14oRRo9h6I0a4WpJK7cWOSI9a+HJzOkx8WKpbDB3Ph/XFvKw7npjoHJ0a5CiKX7xoP/SnIM55ZRroEWbfoUa4MR3DUZyLnp0wLyyt/jvpd7pu8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(39840400004)(396003)(376002)(346002)(366004)(451199021)(478600001)(6506007)(6512007)(44832011)(7416002)(316002)(41300700001)(66946007)(4326008)(6916009)(66476007)(66556008)(83380400001)(966005)(38100700002)(6486002)(2616005)(86362001)(8676002)(6666004)(8936002)(45080400002)(2906002)(36756003)(186003)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4tuqAH0T5gM6LK09fgbqsOShmobuq7TdvC3WwhiWnB+aeqHMODd0xWTg2r7v?=
 =?us-ascii?Q?7fWqnZTNjcGwFR1VHZwfe0u/MQOvS/08RXyyML4OzH1v6vgvGk/SutFC5H7u?=
 =?us-ascii?Q?sXuWcoDet9nerZ5vByh8hq3fOT51onMrpBA0VbC2xJXmnQp0BvjINcrzzWQs?=
 =?us-ascii?Q?s6yU2ovDA5yl6fEB7FJIIVqpU96B/pyEvmetcUzZsTmsImsu2rWjFiquGcAj?=
 =?us-ascii?Q?Olhtsw9yEgkBraGFVhoBBzeb4Iy5G3rKWD6cBaL7qAD1tyEyNumxUYFLDVp2?=
 =?us-ascii?Q?8JwMrUv+XesPfylgSakkmzmS1EeAQ/GA2ZQMRTtKXq/4cXNPAFwACQIx66ty?=
 =?us-ascii?Q?s5xGyYE5Jce2iQAELVbbBbXZfmVCCwNg9o9GNoCJB8jrR5Ka6AXvHK6pgYUS?=
 =?us-ascii?Q?E06Fi/LnHe7j6SX/RgqXDRCUTZ+FZPoWDZEgzAA6ToLk/NkgaLFAyQ0k+aP/?=
 =?us-ascii?Q?/hhVLz7ErGkugNjg2OzjVY4u9PafAO1DOR7N1GqKAWO/WKNK5S7hoJj8hnDd?=
 =?us-ascii?Q?QAzEk0kojPYEkx/BQIj8CC7+Jbi58qnmEq50BBd4egE86daCDIzioCZOEnux?=
 =?us-ascii?Q?0KSkniJWR+vBd1ZhaefC59gipSUIY+c92HZvbasSI2LpKFOO5jqhar+Cik8E?=
 =?us-ascii?Q?0Hcfv42EVdTUNj+4H7AJ0Jm4BCHdoMw+4PruPpY6sF6APGZRIzujrjiT211v?=
 =?us-ascii?Q?pLG/q7/S/TeQco6EdJe27r1guCdF7DYzD0PpwIW9qpxPZJx8suLsFeuD7699?=
 =?us-ascii?Q?RbvdYmvzsOP1tZphiZpTIxT0bwgB991ndZfJk2RcS+CzOR/10xrOyXknKKvk?=
 =?us-ascii?Q?CVRTTAGL7l+4vfD//buMFqbhKZ6Jphj8854G7w6rfzonmL5LsgmDeqwztobd?=
 =?us-ascii?Q?4xT9vBy2lQFBhC32s44bHWlmapWtFf8ibRqu8n3Wak9Oi7SUOCnm8aW29zrN?=
 =?us-ascii?Q?jo/0H+fJ7/8i36J04gEEq3FWgLx0tgkRwHKQZduXXThPzswaWdPkoOTpd/GE?=
 =?us-ascii?Q?1EJ09KESW3Q0Dxt0gPn9+5i/gdcdMViP14F0xvYOljSeBUCXrNW2jE3OWWBU?=
 =?us-ascii?Q?TZSizNIK8GlE6RvPi4zvqSP1znCfj2DYZjY5UOBXXGtYDyr1QSyoad4jTujn?=
 =?us-ascii?Q?JzIb+OlWe3XppPVZp6d85Y0N8xnsPrmUx8DesSQ9C70vuCxheZxxJGVD+3lI?=
 =?us-ascii?Q?mNsG9Uz+fwGwyMW16iQcSOQhSUNuqhfdrmAdGWX3teKK0QhRH+7IZu/MnLTG?=
 =?us-ascii?Q?1wIkKSV3IwIAg4t+gIqpZt98H5SO5gWvrwkKlAaZk0LitRz+d47rQg9Fso4h?=
 =?us-ascii?Q?Q3e50qVR+tME2dLP+joRMWp9oT67xLt0mZiBujiaDm7uLkSNLs1n5lMoc0qB?=
 =?us-ascii?Q?RcfLcuPAIkeffxU99DiLxx8Zd0vxUw6f2Sz7oUBeA0s8IenG/sD2gqbRgJ+q?=
 =?us-ascii?Q?drlxuAWC573nwfCNJQgo/BEOBloulNOcn3GdQuHom8Ir6Y8jtzXol1IxRdcW?=
 =?us-ascii?Q?w7GGyk6SaYDY0jOtQJJ3ig0ytOdU5O59/eMYlTrtmWAu35Gs0jiyg+LzKPGr?=
 =?us-ascii?Q?DACF/wa6S8gmFqldexrlJHl7VEpWeOj2e0aX3zd5KvkumHsAt97vlJ9DmKIL?=
 =?us-ascii?Q?afvKeiX2BXZ2XVPg6rlK5TPUgF8SUfuYBslV7xvQGsj8YeEuk0XYuUD6Q2un?=
 =?us-ascii?Q?Zk2WuA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 095af2d9-b877-48f2-0901-08db51406e83
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 10:22:17.8556
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: chM+Okh51OpzWy8goEwzsmRKzHP3DobXociyzwBExV+Nj7xWwE4/Pb1pP7QAtAYJPkvOlUPAEpZlDgsu9wvC8IJ9VUjI/bDHN2ifmBymM1I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR13MB5629
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 10, 2023 at 04:15:22PM +0800, Yan Wang wrote:
> It is possible to mount multiple sub-devices on the mido bus.
> The hardware power-on does not necessarily reset these devices.
> The device may be in an uncertain state, causing the device's ID
> to not be scanned.
> 
> So, before adding a reset to the scan, make sure the device is in
> normal working mode.
> 
> I found that the subsequent drive registers the reset pin into the
> structure of the sub-device to prevent conflicts, so release the
> reset pin.
> 
> Signed-off-by: Yan Wang <rk.code@outlook.com>
> ---
> v3:
>   - fixed commit message
> v2: https://lore.kernel.org/all/KL1PR01MB54482416A8BE0D80EA27223CE6779@KL1PR01MB5448.apcprd01.prod.exchangelabs.com/
>   - fixed commit message
>   - Using gpiod_ replace gpio_
> v1: https://lore.kernel.org/all/KL1PR01MB5448631F2D6F71021602117FE6769@KL1PR01MB5448.apcprd01.prod.exchangelabs.com/
>   - Incorrect description of commit message.
>   - The gpio-api too old
> ---
>  drivers/net/mdio/fwnode_mdio.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
> index 1183ef5e203e..6695848b8ef2 100644
> --- a/drivers/net/mdio/fwnode_mdio.c
> +++ b/drivers/net/mdio/fwnode_mdio.c
> @@ -57,6 +57,20 @@ fwnode_find_mii_timestamper(struct fwnode_handle *fwnode)
>  	return register_mii_timestamper(arg.np, arg.args[0]);
>  }
>  
> +static void fwnode_mdiobus_pre_enable_phy(struct fwnode_handle *fwnode)
> +{
> +	struct gpio_desc *reset;
> +
> +	reset = fwnode_gpiod_get_index(fwnode, "reset", 0, GPIOD_OUT_HIGH, NULL);

Hi Yan,

As this calls fwnode_gpiod_get_index()
do you need to include linux/gpio/consumer.h ?

> +	if (IS_ERR(reset) && PTR_ERR(reset) != -EPROBE_DEFER)
> +		return;
> +
> +	usleep_range(100, 200);
> +	gpiod_set_value_cansleep(reset, 0);
> +	/*Release the reset pin,it needs to be registered with the PHY.*/
> +	gpiod_put(reset);
> +}
> +

...

