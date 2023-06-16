Return-Path: <netdev+bounces-11485-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 658DE73352A
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 17:51:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2BE7D1C20A97
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 15:51:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF02E19535;
	Fri, 16 Jun 2023 15:51:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E13DD50C
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 15:51:23 +0000 (UTC)
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2131.outbound.protection.outlook.com [40.107.96.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 676DA2D43
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 08:51:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lz6k2FtHLSnomQXmd8QqkccLrYL48W/s7EVjTjN2DEvHlQF0B1VwyUI39Rkzb6gPsbiTG8CNdLHMH8+CSd/OKQrjeZDrrY72XEpZts7RbHTttGWTcRRFvJCS9FqzlHqcigX2TVzDEMnzSxwj4JDooeiA4W3Sr1BJ2PePrQZPV7PgTZrxFyGeIT376kD5jwZDsx3yRPkmBbcdgCAx4bUMksizNbERUCuMSul9fRpaR4aZlv+YqmRkKAdg5fLd6yzvWdDTeHMaZanrHc52KvlBfvnwRZbSsGmhF0KSdHiLi04LHbDvhu0USQeD8K6x/g7+D/c/RU/V+0zjABfi+obNwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qUhUwscofU5iSnKQHtKQpf4NHKa/TRwrog8yYG9rBG8=;
 b=ZDFiOvtQJ9jXDJkQ2utk7cRkdHb9GR2S63JiO09hzOza/wny3UA/aICnMV0oy5XMAPlvCj6jZ1PLh6wIen8jvxuqeOZmRumqspaLZKJ6F8XushSbDV+2z9k8UxJoUxkedWnjMfzXRjdHAjwTHoQINeR3cgZdsMJHlckCKSMdsrUgBmPKeqwA8PuzdOd1+CSTSx++FVbbNLyENOaJJ50XJDK/14hnafpjuRnwRhqhf08hUhRe/kLSiHZk3lAnXjOrXvG+LvMKLeSw7gH0MQL+5CjupaO14E92tn/v8zEWusWYK5PXQfJtfgHbO6ct5K3QdopHYtb9EQ0+O9p1ASiOVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qUhUwscofU5iSnKQHtKQpf4NHKa/TRwrog8yYG9rBG8=;
 b=NU5+KwMMiIfTKVRtsB6QFor+ZWPdnwB4OkMPJq4Aj0x9tjd1YQAKDZxiFiATDHjroTMy2Xr0c2vzgPkA/b+jMtocNF7lLyDzxxd5Y/GEm/65P6mye3bRDGAQhQ3v9HzRJ9o6q4TPMDekgRB40YNUQ4rQkzHJwOPErK41WmVJu+4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DS7PR13MB4669.namprd13.prod.outlook.com (2603:10b6:5:3a3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.25; Fri, 16 Jun
 2023 15:51:18 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%5]) with mapi id 15.20.6500.025; Fri, 16 Jun 2023
 15:51:17 +0000
Date: Fri, 16 Jun 2023 17:51:06 +0200
From: Simon Horman <simon.horman@corigine.com>
To: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
	Alexander Couzens <lynxis@fe80.eu>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Cc@web.codeaurora.org: 
	Claudiu Beznea <claudiu.beznea@microchip.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Daniel Machon <daniel.machon@microchip.com>,
	"David S. Miller" <davem@davemloft.net>,
	DENG Qingfang <dqfext@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Jose Abreu <Jose.Abreu@synopsys.com>,
	Landen Chao <Landen.Chao@mediatek.com>,
	Lars Povlsen <lars.povlsen@microchip.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	Madalin Bucur <madalin.bucur@nxp.com>,
	Marcin Wojtas <mw@semihalf.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Michal Simek <michal.simek@amd.com>, netdev@vger.kernel.org,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
	Sean Anderson <sean.anderson@seco.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Steen Hegelund <Steen.Hegelund@microchip.com>,
	Taras Chornyi <taras.chornyi@plvision.eu>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	UNGLinuxDriver@microchip.com, Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next 01/15] net: phylink: add PCS negotiation mode
Message-ID: <ZIyE6m3f4ToAf9xg@corigine.com>
References: <ZIxQIBfO9dH5xFlg@shell.armlinux.org.uk>
 <E1qA8De-00EaFA-Ht@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1qA8De-00EaFA-Ht@rmk-PC.armlinux.org.uk>
X-ClientProxiedBy: AS4P192CA0039.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:658::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DS7PR13MB4669:EE_
X-MS-Office365-Filtering-Correlation-Id: f74b06cf-8a6c-407c-b01d-08db6e818500
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	1uz5H1Zp3TELHYv/9MYvD+zGrbzkjJSTGAM0pxTAU4wv+8sX0TzT5JOmM0ob+LDBHg1S1gX9vvTBgeZCYJik8aP9OEVgLaKcKXqnGr4Atyja00aL7Vw9dA8ZRWPUC9CET5/03yHwpgHKcw1CfzIA+O8DVR0+DogQanMcWC/6g0fL4Xp+3HheF10lSXzrZij/uqlK+5j8/RamI7roSaqCow/Ww7ttf5lrbDsMZPPurKFB2hWKbPV3lGlhCVQj0CWuuzioyYWnQt9haADE9F+evYs7Ky1Qxcfweav2c4UprkQa3Jm2SHW4cYPaDzWga92qMz1WM+5NrKNMTYSJhrRXXqXAR8tut4B5CJvvftaTSyGb3dIKUWbWF+mPfiN2jobFyVtB7qh/VFLWVM+1hNhYhHSYJQ4auC2o+PnHYhKWDZMNqHvlsXva6xzCSgMz7w/ohbh80Co10+E5fNwgBdYD/aytZw0jxwjoqVX9av+txOABYAslqbIhXFHGF1Woxf7CHy3aZ6TscM3EObqpIpUKOXu3j77YiWUT50js1/W+YnBoZPvNwpXW8YbYHPKDawPkah+2IjvMcrVw9pYCoJpARGOly3x9r2Y9088vk9DbxiQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(366004)(376002)(136003)(39840400004)(451199021)(54906003)(41300700001)(86362001)(66556008)(66946007)(6486002)(8936002)(8676002)(6666004)(66476007)(316002)(36756003)(4326008)(478600001)(7416002)(6512007)(44832011)(7406005)(5660300002)(83380400001)(6506007)(186003)(2906002)(38100700002)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MCu4OkwqTDKIPTHlrd1DYWRwwORkfuH/Lk/uPdH4gM9Tn+JsM48WxjM8GrI6?=
 =?us-ascii?Q?D6Cf6R4L4xjzoE4qQ51oJ7Mb2nxteGnRPjORd8MjO27c+Apggqo+JahgTxff?=
 =?us-ascii?Q?15fwlg1ah/L+EEK0U1SONeYIjUR3UAxXGn0q2q3arEfY8dSh/+4M2Q2HDT2s?=
 =?us-ascii?Q?V8NW2l3ChwiaFG8TjmA52HySJXjhKuAVwgBwEeLEWuw5ro/Txl8OAhtOiEBv?=
 =?us-ascii?Q?Wf0oukgseqYrbPvBnKEje3ujJc/W2Ijqzi99K4Fo9Z0CtlLnI/Qmtn2vzyXQ?=
 =?us-ascii?Q?X5/oEbau7sW8Wn/Y66+Qzef8pX6pUS0MRsyAgpexzUOg+Ryd5g1cd6VUgkBG?=
 =?us-ascii?Q?yu1ApeKYwObnjz0BdMz6/XHQW9Do0CeGpH1wMOFkAyOArElEVDxfh3k5hH6r?=
 =?us-ascii?Q?qyJsCJjmRaDWq4DaT+Wzu6JlHh8iGmjaFPCZb7MfZXWwAjjVC2NSfoDp11+2?=
 =?us-ascii?Q?upzK0oobkvBmPVJgbeBTiJoR1u0m0GMROe8LHD2x3zFihh3XlFmut4lUyHBX?=
 =?us-ascii?Q?VvnsiVHMZCBig0CNmZKg9F9r82J0zceawZpYp5snQ2hKro0+fzPGYGjYC7lx?=
 =?us-ascii?Q?9x1h08iAFZuH7u0UXkHYc+7/fdQh/QWCqEFzjKAT1FEmy44xslP/3JtQkZnl?=
 =?us-ascii?Q?v4/CwfUf9dUVXcOIk3ze3qNADcPCZiUENZa8k1JvP8wYhVO3HH1lHIkWgMg5?=
 =?us-ascii?Q?QzaE3EnYMtHkDSzLYdyZoEJZnLyJFxM6fr7z9cp1vO0GZRtf+gMWEfxjxESb?=
 =?us-ascii?Q?rcjIEj9SSH5MetoTQcyZbNGTmwmuTGdXsN16fNhLKt4CLGa0rrztEQvSpB/U?=
 =?us-ascii?Q?wlHxYDxI/NiVuyVD5ppbzFoLKT0AF3ZfrqMQTIDnwuRh5kfLvN/ll61Tsxgh?=
 =?us-ascii?Q?0J93KHVhJroP62bY6JHWJ5DHJw7VPXTYqdN4gh6aMkoDVdjcEhYdsESlGTRZ?=
 =?us-ascii?Q?zozXKHN1EOxjy82/UFWuPCwMfrR74+LsUyrPUQcZBBx4pxGFrc9B+YLoO8l1?=
 =?us-ascii?Q?+72cdl6r6+GogF0QYHfq65G/Tl0kezEzTDTwydNEqqHi9YQMn2ARKQ1Js5G9?=
 =?us-ascii?Q?NqpAub99wzgUmNsueN4mLVKDdjMlQHoWn6yVePrSAwaiAB2JHdSpjIlQwc/0?=
 =?us-ascii?Q?dqlCQ0WiBSHdxx8h9DxpkzkAdqvNUwxbdA9A8JMOcgxkXbkaA9Z7KyMCYBZz?=
 =?us-ascii?Q?oby7nETRNt8nOwl0xlu7mc9q5kzVKMSazTezA0qi4D+tWPQauSbYEKheDSNT?=
 =?us-ascii?Q?JpQM0aAKbAwiCvubqqDNDJVDykAlF9rftnnZa6HRzvjB1yXGUIMj+HIEMfyG?=
 =?us-ascii?Q?HIXKtH7j79QqTNodMvpPKjdlkak4IUa/GPjTJosR1Smguf8O4aMPRImWDfmH?=
 =?us-ascii?Q?wiEWMY+3xcLs4AS54rBf6ZwpjyLXZ5JZ6ccwL7eR5V3YeayMcnc5auwZRFYg?=
 =?us-ascii?Q?FhdY0UN13pAuxYdB5FKZvJFCjfP9iyblnZK3Pc1s8jJq7uxrxk88SXeJ7X/U?=
 =?us-ascii?Q?QIj87GPwK0Ab62PnMrFY02MfajLB8ct0J0y2gJQRztYH4y1Neoy2mClVuK2o?=
 =?us-ascii?Q?qQFkzgA5CozlHH8pj6V9YPNv2xWdCkIIGeJACNgZKwuLxaG/ebUyaJt+VHgL?=
 =?us-ascii?Q?O+AFW+vo7YlAaiX1qzyST9lI2oAbdykLbas8J7QjxTK5NnZcUkZBljJNznMJ?=
 =?us-ascii?Q?SWYv0w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f74b06cf-8a6c-407c-b01d-08db6e818500
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2023 15:51:17.1390
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dfyue3LsQfqNRMpNPXikhQeDKUGBvld6hxu5UVBJTIMIhEi4PpEGUEV0KR7o7FJXbhrAEFYmvhsATYUAOtsaxCzIQeWbFkjyIPVKVbcdmMk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR13MB4669
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 16, 2023 at 01:06:22PM +0100, Russell King (Oracle) wrote:

Hi Russell,

some minor feedback from my side.

> @@ -1149,12 +1159,20 @@ static int phylink_change_inband_advert(struct phylink *pl)
>  		    __ETHTOOL_LINK_MODE_MASK_NBITS, pl->link_config.advertising,
>  		    pl->link_config.pause);
>  
> +	/* Recompute the PCS neg mode */
> +	pl->pcs_neg_mode = phylink_pcs_neg_mode(pl->cur_link_an_mode,
> +					pl->link_config.interface,
> +					pl->link_config.advertising);

nit: the indentation of the above two lines seems off.

> +
> +	neg_mode = pl->cur_link_an_mode;
> +	if (pl->pcs->neg_mode)
> +		neg_mode = pl->pcs_neg_mode;
> +

Smatch is unhappy that previously it was thought that
pl->pcs could be NULL.

I assume it is taking into account the following, which appears slightly
above this hunk:

	if (!pl->pcs && pl->config->legacy_pre_march2020) {
		...
		return 0;
	}

Could it be the case that pl->pcs is NULL and
pl->config->legacy_pre_march2020 is false?



>  	/* Modern PCS-based method; update the advert at the PCS, and
>  	 * restart negotiation if the pcs_config() helper indicates that
>  	 * the programmed advertisement has changed.
>  	 */
> -	ret = phylink_pcs_config(pl->pcs, pl->cur_link_an_mode,
> -				 &pl->link_config,
> +	ret = phylink_pcs_config(pl->pcs, neg_mode, &pl->link_config,
>  				 !!(pl->link_config.pause & MLO_PAUSE_AN));
>  	if (ret < 0)
>  		return ret;

...

