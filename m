Return-Path: <netdev+bounces-7475-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F37A720688
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 17:51:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DC6D2281A07
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 15:51:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D0A41B918;
	Fri,  2 Jun 2023 15:51:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 299EA1B8FE
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 15:51:42 +0000 (UTC)
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01hn2232.outbound.protection.outlook.com [52.100.5.232])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E966E18C
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 08:51:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nLGQWTw7XikQShKlz+Zvxo1CmFTio5He0LsZp3kZPDI=;
 b=w/K2ZCdqc/NE1vpuygX1SqPfsSjPsNEk6jgi9DGOWSF+5WwQeSe5bFSVl/xzwowi3+unu3PwBBBXYpPksp/RumT/B/Cn+FTqEUCvJ1PXNokXbO6dD1OF+00SjfPmlKC6F6KUmloq/UX0WS/6RkoqzO92V9XRmdlJgjC56Dq/AsVW6S7IEOBzfVoQlZnn2eOGgYVU3RiijaiLldFXXBO1DiuOQBmkVhiYwVB9pWo7QQF+L8Z5kMH3j2lZy45Gdv1c3odYSkHguUBpAP9NC7m6Pn78zwbFmS8acHNvQFFEb5HUVOngor/PeQ3UpcM6uzGq74wFbRxII/K9tfLfiTDNKQ==
Received: from DB7PR02CA0020.eurprd02.prod.outlook.com (2603:10a6:10:52::33)
 by AS8PR03MB7538.eurprd03.prod.outlook.com (2603:10a6:20b:346::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.24; Fri, 2 Jun
 2023 15:51:36 +0000
Received: from DB8EUR05FT018.eop-eur05.prod.protection.outlook.com
 (2603:10a6:10:52:cafe::d0) by DB7PR02CA0020.outlook.office365.com
 (2603:10a6:10:52::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.25 via Frontend
 Transport; Fri, 2 Jun 2023 15:51:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 20.160.56.82)
 smtp.mailfrom=seco.com; dkim=pass (signature was verified)
 header.d=seco.com;dmarc=pass action=none header.from=seco.com;
Received-SPF: Pass (protection.outlook.com: domain of seco.com designates
 20.160.56.82 as permitted sender) receiver=protection.outlook.com;
 client-ip=20.160.56.82; helo=inpost-eu.tmcas.trendmicro.com; pr=C
Received: from inpost-eu.tmcas.trendmicro.com (20.160.56.82) by
 DB8EUR05FT018.mail.protection.outlook.com (10.233.238.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.24 via Frontend Transport; Fri, 2 Jun 2023 15:51:36 +0000
Received: from outmta (unknown [192.168.82.132])
	by inpost-eu.tmcas.trendmicro.com (Trend Micro CAS) with ESMTP id BB0A920081128;
	Fri,  2 Jun 2023 15:51:35 +0000 (UTC)
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (unknown [104.47.13.56])
	by repre.tmcas.trendmicro.com (Trend Micro CAS) with ESMTPS id 4D3BB20080073;
	Fri,  2 Jun 2023 15:52:28 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O9AFEDYNuL717+CmaQVVKwP9vGq1/UdyLo6BfIOwhoRwMoTFp1gAD0ZHCRvIbUhllOuLfClD2G/IAmUj+zd/py6sFHIiCtJ+jSSJ5JPtHcDEqgcup2E/VkDdJUQc8qkuZXS7mecFgOfEOi1FEdNMSXkyx7BKrTCJUzh42QRd0jiHczNetNXu8HMYgK2q63eXv/aq82ltGsa9C8RTMkRHewtGKg9yfWDXRdw1d/Tu+P83m+MdI0NBgOhfDoRHL+XsNygmbRBQ4mHmbUnmD2fi116Y3kaSo029J1Np5NmWXrURjuiBGkva6NraZfRfM29/6KtOz8hxGO6cdM2JoPH7bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nLGQWTw7XikQShKlz+Zvxo1CmFTio5He0LsZp3kZPDI=;
 b=X/5Uki82nsPkve00iW4GP8sKwu68K8QRa88Zk5mbSh1xgV/stw0jt0bMxMMSbHtH8PsLlcCar4HpTk/5evPrNV85dgKb1riui/K6G1qZ0cG+tK4rrXdktTmuWdQ3K2/viX8A/e51Th/hgS1AdNkBLz0CLIc+Cn3Ysfa575ytVpbhJCn5d99BAGRTnB2cLxJO4FKC/lJzB6tXNseC/Zh1/eQwDSIrldWw8Cn9PiGGl/qUvg2Ufjk6pMOvSPt2n6JfKTutwAPK3sgCslKgwHaoLEB+sA6cQj3lJIBBEFSwBjHShnkz6HGLqUK9tZB/8VSd78uD4AlNYFzrwq+LZG0DGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nLGQWTw7XikQShKlz+Zvxo1CmFTio5He0LsZp3kZPDI=;
 b=w/K2ZCdqc/NE1vpuygX1SqPfsSjPsNEk6jgi9DGOWSF+5WwQeSe5bFSVl/xzwowi3+unu3PwBBBXYpPksp/RumT/B/Cn+FTqEUCvJ1PXNokXbO6dD1OF+00SjfPmlKC6F6KUmloq/UX0WS/6RkoqzO92V9XRmdlJgjC56Dq/AsVW6S7IEOBzfVoQlZnn2eOGgYVU3RiijaiLldFXXBO1DiuOQBmkVhiYwVB9pWo7QQF+L8Z5kMH3j2lZy45Gdv1c3odYSkHguUBpAP9NC7m6Pn78zwbFmS8acHNvQFFEb5HUVOngor/PeQ3UpcM6uzGq74wFbRxII/K9tfLfiTDNKQ==
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by PA4PR03MB7486.eurprd03.prod.outlook.com (2603:10a6:102:10e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.24; Fri, 2 Jun
 2023 15:51:30 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::d632:8122:75f7:7b0e]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::d632:8122:75f7:7b0e%3]) with mapi id 15.20.6433.025; Fri, 2 Jun 2023
 15:51:30 +0000
Message-ID: <64b55156-81e2-44cf-224d-d362e10955e3@seco.com>
Date: Fri, 2 Jun 2023 11:51:23 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH net-next 4/8] net: pcs: lynx: add lynx_pcs_create_fwnode()
Content-Language: en-US
To: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
 Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Ioana Ciornei <ioana.ciornei@nxp.com>,
 Jakub Kicinski <kuba@kernel.org>, Madalin Bucur <madalin.bucur@nxp.com>,
 netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>
References: <ZHoOe9K/dZuW2pOe@shell.armlinux.org.uk>
 <E1q56y1-00Bsum-Hx@rmk-PC.armlinux.org.uk>
From: Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <E1q56y1-00Bsum-Hx@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR10CA0021.namprd10.prod.outlook.com
 (2603:10b6:208:120::34) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DB9PR03MB8847:EE_|PA4PR03MB7486:EE_|DB8EUR05FT018:EE_|AS8PR03MB7538:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a551ff4-9841-4f5a-31ba-08db63813f0a
X-TrendMicro-CAS-OUT-LOOP-IDENTIFIER: 656f966764b7fb185830381c646b41a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original:
 ipvfoEQDL9wP6VsuxmI0tMscsirjw/YabqC6VPEXtdukwLgDBFSkaizbQ3Hr+tiLbFrk5ZCcAL1TcOJVl+88KgR2D5pcZckdcHC4Yhqkk03VGbSkVHeOheFf5C9+VQFYuYJ3iCRe0PEMwJrO57SKL5QHDWONTPu04tQ6G9/qg9G9u9o8zof2V7C3vSoRhBtPNmwYY7SavaU0ioHWG9UHq4xns2E5IgM7z9hUioxBoynW18gD0U3WGYLnEB1PKrEeSFSgrt69nRtgHSXDHJsLZ688I+Ks5K5Pa0XJwB7lctyQoYlaxq+4bPRmQPgEHTW5W2Gt2/XqFGJDbfy0+EdNGQKtW4+YamLReB+S1zNw2VQCOmXln1XqFQjpHNuw+/ozdVICimHfVr/HplUrfOm9IlobgPSYMaEr5Am4FfsJM/ExYCBtg6+HMehjiYsD9InS7EjQeon7I01jaHiwkxkQ2a1AHslbpXjbJ/Ph0xM3Pu9AIqDqNh2TNy9TLfU7tHMorTmRL3SGOCYuyGuiHnn7MECJslwKf/SNrWf155aUn+vS7RyWBCVSRahyTMVO9t7b+g/nO3MRo8kAz4mLCX15q6UFVT2lQC8Nb01WHcCf6mCLzBHJ/tbfI5OCQ2GtXUwB+7Ppx+H9Y647PZWanxXzUd8RilJIi34mhrc9ie/cgIJxHxcq4pKedBjuJ7LYeACr
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39850400004)(136003)(376002)(346002)(396003)(451199021)(4326008)(26005)(6506007)(6512007)(53546011)(186003)(6666004)(6486002)(52116002)(5660300002)(44832011)(41300700001)(83380400001)(316002)(7416002)(2906002)(2616005)(8936002)(8676002)(478600001)(66556008)(66476007)(66946007)(110136005)(54906003)(86362001)(36756003)(31696002)(38100700002)(38350700002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR03MB7486
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB8EUR05FT018.eop-eur05.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	b624419b-da71-406b-77a1-08db63813b34
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	eu8kY6x3wfAHCiw7d6yQTDVsYXC9Y74uIuq4va+XwIxsWCxTYqxSUBJuKm/v+MVcp8a5ggDPVXHQnF+kltJ43qMmcwlk8J6Tn/pJV/cyRKoZAji5He8PhlK3aL4SmuGQe1jYWraTHBtrSRjLiAh5W8laa49MOnEpixuEZ2YWWZ1t/RxNMrutDTE/nwMLIBxKH/Zm3EoOCsiUSWGDj+yKy2Vrx6em1Ya33xueuw0lIRghtHEeiHwWPfp4qz93G2UB9z3LK0iqlhbKpS7MvrNVGgQxPvdvuQMwySUkVdvF7rUUOX6I1RmKQhw4WWCLWla3CoAwQQHlRe2IcS+mh5oniMe1MeYfNYvwFvbBebvm28Nmt4XDqgoN2oA4Qls4XSeliAzzdEWtciREwwKXtqAUdRNOhMoOQwdXflsUCcQN2f8d7Kv3KSGBuMTMw5zs4KgPWiLuT3fTid9fCQrzjKGa6VVma6uPX2kc2kJI07LbbfWsgi5UFw4o7wQJArjrJHac9XiuKos1yHaHLqRNouNKbTe+gBFlugfOv7KeeU40t0o/LmasWpZKBs9JuZfqh5ci6N+UXi1QRh20RbVytJLredO2uWCDOeiKiXHz6pWx3rM567ckcOTSQ/c85ryBALnx4wdy0cP/pBq69ETYdQ1+6h9pOdb4tBbn7uDbM2uEyQCEvd67NwbsIAt1GooSs/DkSFSIeu9UQkQ5doqohZWFMBOcHzkJuQjBwR+5X4XGk16LM+IvPGUy59tFQhiE/Szzg/bjXfaMtlaXwKMs2pOu8OtzSryXM6oQjy/LZxUBFbISMFrMroIH/UpIPryyr+9vBWsOnJp9aLKaIM0hb2IkKQ==
X-Forefront-Antispam-Report:
	CIP:20.160.56.82;CTRY:NL;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:inpost-eu.tmcas.trendmicro.com;PTR:inpost-eu.tmcas.trendmicro.com;CAT:NONE;SFS:(13230028)(396003)(376002)(39850400004)(136003)(346002)(5400799015)(451199021)(46966006)(36840700001)(40470700004)(2616005)(83380400001)(36860700001)(36756003)(47076005)(6486002)(336012)(6666004)(6506007)(53546011)(6512007)(40480700001)(186003)(26005)(40460700003)(34070700002)(82310400005)(44832011)(2906002)(54906003)(316002)(110136005)(41300700001)(31696002)(5660300002)(31686004)(86362001)(70206006)(7416002)(70586007)(4326008)(82740400003)(356005)(7596003)(7636003)(8936002)(478600001)(8676002)(43740500002)(12100799033);DIR:OUT;SFP:1501;
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2023 15:51:36.1995
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a551ff4-9841-4f5a-31ba-08db63813f0a
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bebe97c3-6438-442e-ade3-ff17aa50e733;Ip=[20.160.56.82];Helo=[inpost-eu.tmcas.trendmicro.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB8EUR05FT018.eop-eur05.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB7538
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/2/23 11:45, Russell King (Oracle) wrote:
> Add a helper to create a lynx PCS from a fwnode handle.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/pcs/pcs-lynx.c | 29 +++++++++++++++++++++++++++++
>  include/linux/pcs-lynx.h   |  1 +
>  2 files changed, 30 insertions(+)
> 
> diff --git a/drivers/net/pcs/pcs-lynx.c b/drivers/net/pcs/pcs-lynx.c
> index a90f74172f49..b0907c67d469 100644
> --- a/drivers/net/pcs/pcs-lynx.c
> +++ b/drivers/net/pcs/pcs-lynx.c
> @@ -353,6 +353,35 @@ struct phylink_pcs *lynx_pcs_create_mdiodev(struct mii_bus *bus, int addr)
>  }
>  EXPORT_SYMBOL(lynx_pcs_create_mdiodev);
>  
> +struct phylink_pcs *lynx_pcs_create_fwnode(struct fwnode_handle *node)
> +{
> +	struct mdio_device *mdio;
> +	struct phylink_pcs *pcs;

I think you should put the available check here as well.

> +	mdio = fwnode_mdio_find_device(node);
> +	if (!mdio)
> +		return ERR_PTR(-EPROBE_DEFER);
> +
> +	pcs = lynx_pcs_create(mdio);
> +
> +	/* Convert failure to create the PCS to an error pointer, so this
> +	 * function has a consistent return value strategy.
> +	 */
> +	if (!pcs)
> +		pcs = ERR_PTR(-ENOMEM);
> +
> +	/* lynx_create() has taken a refcount on the mdiodev if it was
> +	 * successful. If lynx_create() fails, this will free the mdio
> +	 * device here. In any case, we don't need to hold our reference
> +	 * anymore, and putting it here will allow mdio_device_put() in
> +	 * lynx_destroy() to automatically free the mdio device.
> +	 */
> +	mdio_device_put(mdio);
> +
> +	return pcs;
> +}
> +EXPORT_SYMBOL_GPL(lynx_pcs_create_fwnode);
> +
>  void lynx_pcs_destroy(struct phylink_pcs *pcs)
>  {
>  	struct lynx_pcs *lynx = phylink_pcs_to_lynx(pcs);
> diff --git a/include/linux/pcs-lynx.h b/include/linux/pcs-lynx.h
> index 25f68a096bfe..123e813df771 100644
> --- a/include/linux/pcs-lynx.h
> +++ b/include/linux/pcs-lynx.h
> @@ -11,6 +11,7 @@
>  
>  struct phylink_pcs *lynx_pcs_create(struct mdio_device *mdio);
>  struct phylink_pcs *lynx_pcs_create_mdiodev(struct mii_bus *bus, int addr);
> +struct phylink_pcs *lynx_pcs_create_fwnode(struct fwnode_handle *node);
>  
>  void lynx_pcs_destroy(struct phylink_pcs *pcs);
>  

Anyway, the rest of this series looks good to me.

--Sean

