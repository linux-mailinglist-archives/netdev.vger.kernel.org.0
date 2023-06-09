Return-Path: <netdev+bounces-9560-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8241B729C22
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 16:03:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0CDA7280EF7
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 14:03:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2533017AB0;
	Fri,  9 Jun 2023 14:03:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 191AF1773F
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 14:03:52 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2126.outbound.protection.outlook.com [40.107.237.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9F9430E8
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 07:03:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gVSbamNy3Iy77VeskfDpEcxI8L8MZnpACdchpKIm4Mm2w0WFAM1Zi2zfWgUZnMw8c5T44suT0MIVNFmaPKwLPlf0R46ptKWjBSKUCXMyLqWA1N+Y/4M9931HXtxgQNCH39hrjnUT5omOir5dGDly+KVdLWXwVfZRikyPihRZGtJexgjZbN15RLsbpu9qX2/vHSqffq5wsWU1hGT5ZWttus6Cbv21q6fNbsJ8cwDhRdPF8QIyKIIxOTmRXqLKkYpUiPY4i3RzyqOhZo3sHqJUp3JJXz+Tgqq+67tgDPa/dJjynlFOdxQVZby9geTd12oCLCu/+yYUkbRgO9TkU6vmYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ynGzOJGeDt2aXjcTwamoGL4o+zK9UJiZViao//Z4pb0=;
 b=Eeou4lAc4Tfnh/Uf2SCjYlSN9Yo5UOGJEQVsiTaumJkXni40yLdUFxj0gjua/vQw1sJ28+HIBjBnK4kQWVUs1M6b6/I1KhXn2Lp+jnZw31PQQTPl4YeTgHrB8oR1824MsOO3/9HBu2yW5/7GQyi41mKlf9enVJcTS/vIo8tvWY50NGBp8vt4U6K9Z+kaqJC329yZhxM3rW+DGSMKaoflfS2Inh/MVCxqtvPK9m/a6DIwdu7qyY19Yc9P9vB2agJ8AueOvt2N/dWh7ojgbOdADn6ncYd7H5WlRr6zQg4KawN244TGCEGvhDicryH7U7dY1GE9RXlA0LoxbscniL6NZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ynGzOJGeDt2aXjcTwamoGL4o+zK9UJiZViao//Z4pb0=;
 b=rQu1ksi9+ZM6B2vPbMFa6iutxhyF1B0XmR6S/4hX52Q0U4MnIg+mB4JgG8NiuTNuXorNXccfSo+AAFGUB6bKCf3uEFsox8DYHc5erxjEvKZElNUM+6vCKQO101WlRpwTqB8nTjHMyy4+MO9ganfUrNPfUf/YZ0DSlr3hsTkvXvA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO1PR13MB5062.namprd13.prod.outlook.com (2603:10b6:303:d5::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Fri, 9 Jun
 2023 14:03:48 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Fri, 9 Jun 2023
 14:03:47 +0000
Date: Fri, 9 Jun 2023 16:03:41 +0200
From: Simon Horman <simon.horman@corigine.com>
To: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Marcin Wojtas <mw@semihalf.com>,
	netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH RFC net-next 4/4] net: mvpp2: add EEE implementation
Message-ID: <ZIMxPROkFLI+EO9U@corigine.com>
References: <ZILsqV0gkSMMdinU@shell.armlinux.org.uk>
 <E1q7Y9b-00DI8s-NW@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1q7Y9b-00DI8s-NW@rmk-PC.armlinux.org.uk>
X-ClientProxiedBy: AS4PR10CA0028.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d8::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO1PR13MB5062:EE_
X-MS-Office365-Filtering-Correlation-Id: 65270dc3-3971-4c5e-8eca-08db68f25857
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	epM4btsQ4jno/1RfSv/WdGntPpHZULYt/DU1b2J1Xb7PIi/hAxWHnfKYHC/rQ0DO7D9QkB29SWQnneJODUgYNNM9SFV7q2D9Kgc8EiDUPWFKJjYLm3DtRtK/oMA+h4dTRwiq/eL0Gg8HdYAzoIicaymULMOqM4LdFY+wx/7GAhp8OrK9cBqSSESvsNvHaiKvOhPBAvIPLpnrLe3KbVEg1jf6kp9TzNu+kaDp8mh0gD8Q+db2/FazPb01rJrjaAs1iH0FvZ9rxB2tR89FBLMkaHN5b9f5HJvmgYNIsH8R5AofxWaXkWLuW/5XjaKbfuYgxX5GQHPvxEC+YNwRjaL7mm/BB9Fpi/fwfxy1yri0oNLCdgMdlsKhjiHVRWwXbYBFaB3MEuAWi4VQ7pMx+7eiyP+FLC1FhdtNQOl25EKruA9vVcWcAVwNygtmG5gmml4pbrfDHDHRr8JLNgkJhOX42WviCGkMLFaQY3sw2wp0FXliKOsjaPIZO0SrByIXpvDCRfndHChUecQ8+MI2YUDO66y1qw/uno2zbQ4zfvGrt7tfkergpgi5kqL0sKhJPRum8lndYRmTK/BTPdxPLRraN+cbbCxYowmUQRvnDu3CFiEtXtLfoWPJ0NtaNbfiaDsAUhCwTrAcLCXT+6t0gVv6mC8V9gzEz9GnDDuhClwukFs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(39840400004)(376002)(396003)(366004)(346002)(451199021)(66946007)(86362001)(36756003)(7416002)(44832011)(5660300002)(2906002)(6666004)(6486002)(186003)(6512007)(6506007)(478600001)(54906003)(41300700001)(316002)(66556008)(2616005)(38100700002)(66476007)(4326008)(8936002)(8676002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OimwEd6JQfEbAFsIS49dxopOEX2pA59u+/VrfZMOjBTpsCWbLWs8lNDZPTio?=
 =?us-ascii?Q?JcnsYQrp6EpoWYxJxQL89MLClBI8aoV7Ei0DlYaarK8gqUkYb0bIzpS/Qtlh?=
 =?us-ascii?Q?mvDqnwwn0EQfksFcreLbEEMoVdxLXQdjqYnlKOiLMe+sNKxZT2YwaPxaXk3Z?=
 =?us-ascii?Q?g9iFClb4uc/CKoOwaafyab5QRd3i4Ts0ywkS8mURB/+EbpKSh6X+f48czpiJ?=
 =?us-ascii?Q?nRqu0AADeRgkta/A5GltTAyNhw9Iji3PpmtHfatoP3pqMysNQoRMa+bBTBOu?=
 =?us-ascii?Q?DcUEttelst2Jh+bYOcMlegL4kFAIX3DAiVHy0hVdWxS8K2mwY+T3FpLcQ7oG?=
 =?us-ascii?Q?zCGfuukYAuoXRAugxkXZJUa7kkZ2Yzztu85jAlaoRqE/jCAgGYbjHIkVkYvE?=
 =?us-ascii?Q?W/uOlPM4c3i+ACqgeIngBld45aVB9Bppo66CKmvhgdFPTiA4nbVZUr/2YeDc?=
 =?us-ascii?Q?9/hXfNy8dVE2G+Jy7pimcfDPbBozNdpFBJ2iqsNpu42av78Wx1b3T1Wquclg?=
 =?us-ascii?Q?yXBs01+6Hq58J9wLe9JOsEd8x6igQ48AVqaT0sSgEoV0E5qugsdMzyBJSxSS?=
 =?us-ascii?Q?bo7OiL8xdPFdS9swM0nl+AG9z5tnxch7yuvwoBkHf1XjiXZQxohVW4I3jrz/?=
 =?us-ascii?Q?fORCbO5PaXK3uAWvZaD74gAqtmqcYyn1yFP25+Ke4Yp43sr76HMpNMO779Q2?=
 =?us-ascii?Q?n58WD2ivGl2qdmwoXYzsQNRn0dCmNwVcyyzGdBY1UIP3CeOE2dJkgwi9MzuC?=
 =?us-ascii?Q?Z4d0XJ5tG+epx7P6WFG03N86CnZWUTpBZqelK84sp4Gw/5jz4+xzR5GdGIUH?=
 =?us-ascii?Q?x5EaczrICz2h0NUzeclIuDzFyTH0ZgYfaTMlUbr2sg3enINtJRaWfPBsA9f7?=
 =?us-ascii?Q?wiGKJgEwFmdyv3JquuXH70OG3KsLDGipOIu+vb0ZtbFeHdOo60CMy8jtEHRJ?=
 =?us-ascii?Q?w0Z/LDncraPj1B/FNrVMHl/7Bs5zpjPptJuVdPA22JMgRL8OxSEcNuVLR1/j?=
 =?us-ascii?Q?+vUvjA+8nQobzvub8x5/YXUMVex7CSubfY2vspJi5aVDQtlcp5GYx3dtdrQE?=
 =?us-ascii?Q?z7/ifhgPu9Fw2gpekRCKGuu7mFVgDQXU6vjrzC72UTPWDwpbjRlq/oedoDH4?=
 =?us-ascii?Q?ylI+uu/BgsY7qqoa2MX9zNH7Fj5e+ZECfF0jcdMJXe64Vvyg0IO2RSI68nzw?=
 =?us-ascii?Q?drfi97ZmrvceJLM4egZ+XfStSOIURs9L7imVIn/TBxtfELWbZK3w2vQqeLWV?=
 =?us-ascii?Q?epM7EucGH7PxgWf8/02nHZZmdciQJ6T0vClCwZ9CgJgyAhRa041zzQ5A2Ik9?=
 =?us-ascii?Q?h4kUrDJ84BsRZ64b5mJZf2Z678mILDwrbfAG3QwTj907MPb9c1prnHrTI7gC?=
 =?us-ascii?Q?waoTRVS77Pi+AvILaMMf0Zw4fc2zMA55UA9Q0jj3p0oWsMcMsMrC02TeJEYa?=
 =?us-ascii?Q?Agwf0M1gaa2ePnOv2TepEIHDd9LmXBpw79JhYF61+eagk+TFsemmXvcaPe9F?=
 =?us-ascii?Q?DNwy4Fb6ECD8Z7Le85VmYZS1qbFip0zfW8rmJV6dUdpNOYLqcxb3AGKZ1lHb?=
 =?us-ascii?Q?04JsihkerYI4WpPpNwE1NuPWpGhTTYm2xuL3mKp0XVFitRc0bAeJR/yv/2K5?=
 =?us-ascii?Q?fclggJITm7q4kjndwC+EkfuO9we2C+9fNEkoSKLI326a/FIuv6v3cINl+WVl?=
 =?us-ascii?Q?oIG6Cw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65270dc3-3971-4c5e-8eca-08db68f25857
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 14:03:47.8089
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FUsKch7/fgocn0dAoZFe8grOqJ0CmCbjS9k+ZotG69OAap91c35Fn2jWniT5VGsvHmtaA0J97pLg8MTMdfBymmhPqqOYL7IuveD6DB5/d1I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR13MB5062
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 09, 2023 at 10:11:31AM +0100, Russell King (Oracle) wrote:
> Add EEE support for mvpp2, using phylink's EEE implementation, which
> means we just need to implement the two methods for LPI control, and
> with the initial configuration. Only the GMAC is supported, so only
> 100M, 1G and 2.5G speeds.
> 
> Disabling LPI requires clearing a single bit. Enabling LPI needs a full
> configuration of several values, as the timer values are dependent on
> the MAC operating speed.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

...

> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> index adc953611913..a06c455b7180 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -5716,6 +5716,31 @@ static int mvpp2_ethtool_set_rxfh_context(struct net_device *dev,
>  
>  	return mvpp22_port_rss_ctx_indir_set(port, *rss_context, indir);
>  }
> +
> +static int mvpp2_ethtool_get_eee(struct net_device *dev,
> +				 struct ethtool_eee *eee)
> +{
> +	struct mvpp2_port *port = netdev_priv(dev);
> +
> +	if (!port->phylink)
> +		return -ENOTSUPP;

Hi Russell,

perhaps EOPNOTSUPP is more appropriate here.

> +
> +	return phylink_ethtool_get_eee(port->phylink, eee);
> +}
> +
> +static int mvpp2_ethtool_set_eee(struct net_device *dev,
> +				 struct ethtool_eee *eee)
> +{
> +	struct mvpp2_port *port = netdev_priv(dev);
> +
> +	if (!port->phylink)
> +		return -ENOTSUPP;

And here.

> +
> +	if (eee->tx_lpi_timer > 255)
> +		eee->tx_lpi_timer = 255;
> +
> +	return phylink_ethtool_set_eee(port->phylink, eee);
> +}
>  /* Device ops */
>  
>  static const struct net_device_ops mvpp2_netdev_ops = {

...

