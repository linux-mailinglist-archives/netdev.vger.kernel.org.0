Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE51A6338D7
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 10:42:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233370AbiKVJmX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 04:42:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233429AbiKVJmD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 04:42:03 -0500
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2052.outbound.protection.outlook.com [40.107.104.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 328FF532E5
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 01:41:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oJwwe3LBAQURqEegGoUimYj9CVfIKfS8Y1bxxauiSDZKAgPDHYLGefeAxO+Uw4MY8VKxAmtQCctsAntjqsSq3GHoPIHYiIh8lp9btiOmQwSVSwXTNfrd0XJdaW2Ur2Wspy/oiPhpGHS7w9KYQusS9cWH3lqp78u/yLuKDx9StnPp+jOxAB9rLAmG2oxX1xJe63IhVddfmzq1r2Z6d5nQdJoZJVwpl4Lr67j6+28y99YCITHePyK5t7JainOESZsP/QPKae10TG14FHfvieOdSUB7yfuIt1hxMbVWSnFR11nGn02luHVU4HHt6X659bot2BB2cmVWP4RkpIPmNlr53Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KzMjY+t1dumUqNUA3Xc8iJAVdurR6w6cbtP3Jzofg5c=;
 b=YKMc08U2biBmnxBYd+i/NBrLAnTOC4h8j2TCMxTOcZSHWD+0oftQ/l1HXVj2GtMTlQjHibCS8nP89f+qWnAylTOWEG3ZRdClCveZE3e5cvYB1Fbr6MrkG8tYqCAVMeGQnmK0XXmnbkdQGmrNsRhJUuFE64dHKUk4qJsCcws/4h6BLFPvyXHthJ+Nn3ERWqlTnuO9WLzrpCFXICq9yILRXWTIim7T7bJCwmOkeEai9wG5WyIE0LkXiKey1mr6PY/GnULkEw33275HZhqDtoeko6qDrQFdifbRXHXB3zyeBeeVT2r3zQ8Mqb2NciIgjlhy9EgIl4V2s/OD+hWM3FCm8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KzMjY+t1dumUqNUA3Xc8iJAVdurR6w6cbtP3Jzofg5c=;
 b=FHH9XX/o1YIUU1P/6tJ1J+Il952gWQXSjsd4H+8InlDn6VlGNESUJ3wmC4eNfCQ52JtpHdzqtGcEX+HCwYDf6mooBBepfrIhXiK8RDvejR5gwhraCPoqcTfnkLfowavgQPubMNDqtcvpMtZpImpogV5A+WRuqOmP9ED1J+6q9VA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB9078.eurprd04.prod.outlook.com (2603:10a6:20b:445::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.9; Tue, 22 Nov
 2022 09:41:35 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 09:41:34 +0000
Date:   Tue, 22 Nov 2022 11:41:31 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        UNGLinuxDriver@microchip.com,
        bcm-kernel-feedback-list@broadcom.com,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Sean Anderson <sean.anderson@seco.com>,
        Antoine Tenart <atenart@kernel.org>,
        Michael Walle <michael@walle.cc>,
        Raag Jadav <raagjadav@gmail.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Marek Behun <marek.behun@nic.cz>
Subject: Re: [PATCH v4 net-next 2/8] net: phylink: introduce generic method
 to query PHY in-band autoneg capability
Message-ID: <20221122094131.jkgy5thhrlio4425@skbuf>
References: <20221118000124.2754581-1-vladimir.oltean@nxp.com>
 <20221118000124.2754581-3-vladimir.oltean@nxp.com>
 <Y3yUoNwyJRQViyOY@shell.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3yUoNwyJRQViyOY@shell.armlinux.org.uk>
X-ClientProxiedBy: BE0P281CA0021.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:14::8) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB9078:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d7d52f1-d401-444d-286b-08dacc6dbe80
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X2lvu30jMWo7v2zOFMjpVilbkGTFFCaloZI07wRdHIlpSjHr0U4fs7bk13lEJSSKUvfPeuZhN3cpZ1SZU2OprfCKOMouZtjlT4saCtisvr0kpXNtOg7hZepB9RHJsm5PVV8IHcPbmGWkebIj/eeQvdeYGX3Lq0Y/uDdDHVdLn/IjFEXQYxNqNQ+AD/S0f6RKOQFV35+AcIdx8CiBLfjKxwjIxR9DnM6D48DwQob/ONMebNyMFsaLD16My8MfNVUPA1/WSAU/5PYjfM1FOZMMVk8fUF81WvKUcBVrPm8pTaF29tGu58ptwI4nWR4zo9cisyEAb0IVwaZVnMNV4f9FWwusy46+noSk05BluaAeyIKUKMxM1J70DjOOttgYrFVZISPUt1SHZxThIqsQpqYiog7TXwH84bkWzJE9RUXcOaIOKUeycSrLltGayx7awtOzZ9CROHnpzHeK/SP5BAa0uhkh/PvDILuBIJuwYJqvKbS4qmN3gD/5Ulas+bSV0wpfMoSkpUCCN9mpxXc0UZXYxmoBrDNktiHtR/fi1kTCnBt4ZffB3HF3R77Fs9717F3DXuYQ4ttLXK6f3ZIhZxOVDy1ub5XR+J+bFQlwPNWS+MfRyhKtyytAk57XjdUrZZRvxHISWuk3I+R2WICeUdg+k3PgS+2S4mSvEqM2V6cyzFlxVgDw+3rlItR4gkpC372s
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(366004)(396003)(376002)(39860400002)(136003)(346002)(451199015)(6666004)(478600001)(6486002)(6512007)(41300700001)(9686003)(4326008)(8676002)(66476007)(8936002)(186003)(33716001)(1076003)(26005)(66556008)(66946007)(7416002)(5660300002)(6506007)(316002)(54906003)(6916009)(44832011)(2906002)(86362001)(38100700002)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9l1wS4ecapkh05CBqQJiK08OQ8UCHbkuHS9KoaGM26S9og4IApYt9LFpXsKR?=
 =?us-ascii?Q?Qgl1shdbXDt0ztokM4/H8P1/amUIFINpoLPHT9fnyhHtPMGpjD5Zlan8XSqN?=
 =?us-ascii?Q?PbkrwqbWrfMCzqcXXgsdg48XHgkI3Cj/m70kj43iEczhaZXxKHj62LD4mHP0?=
 =?us-ascii?Q?94lGL5+lZ7U9ct3DhscajUZSAl2Kr/zleq6fpIbZyaINCSzIF8CodiPPDkbE?=
 =?us-ascii?Q?VrkIUVhP8jcOai7Q4TPnPodzzKFILYZGyMB0UKcNPu8+PB/TmH8Q6r9u8/UL?=
 =?us-ascii?Q?YUsXXc0EaSYX9ZyXq20SPJHsmgMwtnvrJnQzQYRHWGRQ2IJJues7vMiC3/kV?=
 =?us-ascii?Q?4HlyMClO3g28rSF4OqZYs2bPFvxLSGHwNIzAn6/kcRoV1qhzbuldiOOnPkVU?=
 =?us-ascii?Q?OYaTSvStWLm07mmqc9kzewyrirl/zMnA7yNRdvcjr5o//G/r2R3DlQrjS/Oo?=
 =?us-ascii?Q?CTT7/2RKAFkoAggVV7PFa8wIeSmGrdHX2+foy+noNG4LBlqVmnQd10CaKD7h?=
 =?us-ascii?Q?oUHsd8XEXC48c/Gce5FDp8aK8HX2t9jZUDvEyWL/DeSnp3QNaYAnPPm1lgkf?=
 =?us-ascii?Q?i7jM1OeqpK6nFzyXRzinbn1N+O05JnmE7QtarKQsfpogkrgPzu6zjvjDvqKU?=
 =?us-ascii?Q?PpAo2F1FZ8+JSi5z7wfygsZjk/HvCSjlgTE1yuFJXYGgWflJauyTNnDMx4yF?=
 =?us-ascii?Q?nlqeaiPMAL1lzHq1L70BJ1brLml1pxwr9Y3MqZ5IpEDxCv/4TYIIG2UR4lV4?=
 =?us-ascii?Q?A2eM/zl3DM9iM6KDdc6wgg5uQwaC4cxOUgBYEcGt9zkowJp5bkuxNDHmyz2u?=
 =?us-ascii?Q?sSwb1kgcP+3Zk6jGY3aodoMWWvhwefhGvncFK4jLYZBzDki+xzBln9vCpGYn?=
 =?us-ascii?Q?+MzcCJcxrUihR0TK3ULUZ+w3TZc+DQq0/n0fbcq72N5mYhugN3+4Fckd+tWL?=
 =?us-ascii?Q?plNvhTpXg2ogkKdvamoFWn0smF97V0eIqFM0gcIA12ok9SvlMfz8kAn2woj1?=
 =?us-ascii?Q?m+ZaIOrWOzRgq8vFPUn/3GQ35zTfPX/tK7JXgtY9uHmBUPs/n1arEpr5PnC5?=
 =?us-ascii?Q?3B9CgAja17BIKx3E9czESpvtaf4KGM1Y6J+U4C3MVb2a5oL6V8GRw6cuQrLP?=
 =?us-ascii?Q?73WfZkQm/3pJN6Bh0aYRst0RoV7ep2UqmR+NU1PWd7Q2bJBpijcagLE73Qpj?=
 =?us-ascii?Q?Wa+RApsL5YgAWRwDGxLPHZyVAphrtsIlHmlMNVggx5tKQJ0lYOLDKAxshTJY?=
 =?us-ascii?Q?6gQaHfit5yeVyuX1PJAH4U7S5vuHCWwNUOecd8I4ItdwQOnv4bWtHjpBj36X?=
 =?us-ascii?Q?lbeA7Pr3qv8lwLyuWsJWLYDam9f3eVGJv92p6wI9Udx0SWfpi+4UuQut6HrE?=
 =?us-ascii?Q?4at0yGOnY1p7saF/TN0ApHdHn/57y8wsYaAGAKRURxdjh/xSLnbLWL8YL0mI?=
 =?us-ascii?Q?GIj1H2vnu8C3Jq69UF8U3x5Pt26UoWYf6HZZkxTZKmW8a249ydnCK+X0rSNS?=
 =?us-ascii?Q?VWNFCb4peM+z4GfNNJuXD3delMA5pxZBYz2UDzE38CLyOxATVRcCnD8D9AQt?=
 =?us-ascii?Q?ZF2U7OWyK+ty/kMC5XsHdcDdc/lXETFv6FmTu/z82R1rfAgOgqa5+vXIeaEc?=
 =?us-ascii?Q?Mg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d7d52f1-d401-444d-286b-08dacc6dbe80
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 09:41:34.7167
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BKfBJcwjzP6NOJO+SOqeGHjN3muwaMcng3PZWzrRDzr2yy7TWwhBvWPO05zUF8pbAPf0LyIr0vkBFenWJa2BWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB9078
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 09:21:36AM +0000, Russell King (Oracle) wrote:
> > +enum phy_an_inband {
> > +	PHY_AN_INBAND_UNKNOWN		= BIT(0),
> > +	PHY_AN_INBAND_OFF		= BIT(1),
> > +	PHY_AN_INBAND_ON		= BIT(2),
> > +};
> 
> There is another option here:
> 
> - unknown (basically, PHY driver doesn't implement the function or
>   can't report)
> - off (PHY driver knows for certain that in-band isn't used)
> - on (PHY driver knows that in-band is required and must be
>   acknowledged)
> - on-but-not-required (PHY driver knows that in-band can be used, but
>   the PHY has hardware support for timing out waiting for the in-band
>   acknowledgement - Marvell PHYs support this.)
> 
> Maybe the fourth state can be indicated by setting both _OFF and _ON ?
> 
> Given that there's four states, does it make sense for this to be a
> bitfield?

Setting both _OFF and _ON in the capability report would already have
the meaning that it's configurable via a subsequent call to
phy_config_an_inband(). It's really configurable in VSC8514. I suppose
introducing PHY_AN_INBAND_ON_TIMEOUT = BIT(3) could make sense as
another option for the capability, orthogonal to the other 2.

Maybe it would be useful in itself if the MAC cannot support MLO_AN_INBAND,
like the Lynx PCS in 2500base-x, and the PHY only reports PHY_AN_INBAND_ON |
PHY_AN_INBAND_ON_TIMEOUT (hypothetical example). Phylink would pick
PHY_AN_INBAND_ON_TIMEOUT.

Given that I don't have a use case for this, should I add PHY_AN_INBAND_ON_TIMEOUT
to this patch set or should that be done by someone for whom it makes a difference?

The relevant implication for this patch set is the function prototype of
phy_config_an_enabled(struct phy_device *phydev, bool enabled). It
shouldn't take a bool enabled, but an enum phy_an_inband for future
extensibility (and reject/ignore PHY_AN_INBAND_UNKNOWN).
