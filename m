Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2BA66CE2A
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 18:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233461AbjAPR7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 12:59:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235200AbjAPR6t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 12:58:49 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2083.outbound.protection.outlook.com [40.107.21.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C36E355B8;
        Mon, 16 Jan 2023 09:42:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=enKk6v9O5s1IWh3HTYMmYtF2RfdBTp0fKs5HWKeXcb2W5bYLTwLsDkTxsKdyGdeonDsZwEQpLPHA0yEeEBd0l4liUe9k2fIlrGqJeDHFZ2Vo/rsC4faHCyqXv7W8ba1K3PqTDNSb6mWEIORB74nDXbpmMOtsZ35WuPwL2DmKQgCZB9duTDZEbkppB9zEGF/6Shp7nuOY/iZfAXvffY92H4sCdmgmXZdVCAul8tU4k7dtxCNmU56YfZIK8HJ5OZzCSLfZqlfkpCnp2xDnTAtnNh+79PBXOc7Ofr/aKdILaPWv+DdvgU7b0cJWI9YWCbOseRlY6JRAWFwuCN1T6zGoPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a9NfvHtt94HvuchxsBBYwc9bxTgfNsb+ydFWhknQTTY=;
 b=X8BVUu1A1wQjYqj4RiIfAfDgHxVC786CALyZbH3tEGsSiGJzOSyzC1XswMKKeiSsh3TvFh2rR52sQC4gISn905ojWvQor+1TqbvMVi2SYsN1cQLgoW6+wURFjSvt1XFXteT3Gw7pt95uQJpQaZl3wwZDKwH8i6YDFUzABzE+rKGsGMsovIvobYzHP5nuGvwVPkaq4Q1h2Yiv6A48K4XUJ+A5IdZV1KHps+x/iwJgMmWrwZ+1+/Yt1cp1LDRhNQqdZQLTSxxC6Bsjrdk8oUkM4hpVsZ5UD44mtBCZBPlrlFmerwEKbmc+st+YcntjJF5fh8lRLvXPptPc/xJ+1j/aww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a9NfvHtt94HvuchxsBBYwc9bxTgfNsb+ydFWhknQTTY=;
 b=b05lAYVCc5pJQ6Qqu2mEBmo8vZXcDtPMFBVOwgfM+cZ/XRtlJxaI5ZwTPs0WuTqIhgx9wuoJCGnCBOZ2SbK9pczBlYgFnHsV2wRezvO1wgb1WEv7RjCL0YJMMZ0XftGWqj/4LIJILxIzop/u+0N5LUH2Z2OuTaHJLkONCw/O7qE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PR3PR04MB7353.eurprd04.prod.outlook.com (2603:10a6:102:82::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Mon, 16 Jan
 2023 17:42:39 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.5986.023; Mon, 16 Jan 2023
 17:42:39 +0000
Date:   Mon, 16 Jan 2023 19:42:34 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH v2 net-next 04/12] net: ethtool: netlink: retrieve stats
 from multiple sources (eMAC, pMAC)
Message-ID: <20230116174234.yzq6cnczs6fxww6q@skbuf>
References: <20230111161706.1465242-1-vladimir.oltean@nxp.com>
 <20230111161706.1465242-5-vladimir.oltean@nxp.com>
 <20230113204336.401a2062@kernel.org>
 <20230114232214.tj6bsfhmhfg3zjxw@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230114232214.tj6bsfhmhfg3zjxw@skbuf>
X-ClientProxiedBy: AM4PR0202CA0023.eurprd02.prod.outlook.com
 (2603:10a6:200:89::33) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PR3PR04MB7353:EE_
X-MS-Office365-Filtering-Correlation-Id: b3c80069-75b3-4723-30fb-08daf7e90fb4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mh1DUq2k/ay+cWN4uL1uRrYOASL6FXwGiPMkS4USZ2+7CSJI/ML/usoLZ/UiNm03Ou6DQWfUki9stqBY7M+ZZ94Ak99o9/AYCMGN2EEyxaLDq0K8G+wmK46TTN+VqeYXLG8hX42eeluo1++55vUAT1mWezSB3kb+uEFdtUN/TCfc8f0lqSTM/7bIxun6FS4xgGoXoJXU+8lrNHaNqBqeBYT22Sg1W559sGiGVtEqzGbhf/j4nZhpJRZg/YYQNYLEyB8jdLJZCfbKIuDEzD/cEOSay1nMs1L45ULijZY0DjE/T3EMrP4fLzfH12dZXRbGHksA+tHZV1yt9z1bv3XTZERa7AsdNA9ZuGON3RWdrxu7oRcl2xqrpJOKJrIqKtyy4+H6gUnQue8UYquZuy4EhsbRRTlRViWNx1pj6OO/dqnh1FeNxNpb6RpKlZbOxEC5NHKarMgaPgmJSKSoCbcKFP0f1iWvmfvqu+OC678BY3DJWs/O7r4CVDLODul/H/ilrQ6v/PsIJWKu1oSB3SBKvQuIqEii2fSrbnEQrjSe+2FCCTAhO026npeNpzU2UsdDZ7Oz1wQ7mtELgA9UT4PJoEGVuJaB6HyvQldFk4lqMLtSm1iJpOUzvLzRdvnEvG86M6ZhagZeQowpDdEKjvpgdg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(346002)(366004)(376002)(39860400002)(136003)(396003)(451199015)(38100700002)(33716001)(86362001)(6486002)(66556008)(9686003)(66946007)(4326008)(6916009)(66476007)(8676002)(186003)(6512007)(26005)(478600001)(54906003)(1076003)(316002)(8936002)(41300700001)(6506007)(83380400001)(44832011)(2906002)(7416002)(5660300002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YvqULhosC9BZZq7unvjYMfUy3iU1Vai7657q7M1Wa68E/F8rJfrHe38QxF7y?=
 =?us-ascii?Q?P54U1nCpXLql8Ix+ofAumory9V3HAXIXV+95co4Ht9OhbZV7SE/ybQB1Y6s3?=
 =?us-ascii?Q?euveEtg+v8l35v03r7OYBEchHxNffBa/4R+R4+Y2OVdGZxwBsiY5yane8k3B?=
 =?us-ascii?Q?v/a1ftq//WGaxaqzAkuNIUGPLcEEL7NGXYaZspn+Hcc1iKm7QPRwcpw3j5Zd?=
 =?us-ascii?Q?qJ/QAAYH3gYJw6M6iHNcIz1weyo7SLRL4nswIc7IZMHwb4oWeIXN8eB5qfbh?=
 =?us-ascii?Q?86LU08M07x0tGTCndb9OQmOF87ah+m0Z5NEwhH+hkOxVwI07xPhBCc6ke6iz?=
 =?us-ascii?Q?qgRuuu+c3MDmv8qli731FDtBF1twLiTrfvo5awS8vX7lz7r4VO6eiiHo4aM8?=
 =?us-ascii?Q?zaklZFrS2SSY1DsQFfnHF993aQ+v2uFXWBGQNQZKKNU4PhX+ihR4kbZnjCTU?=
 =?us-ascii?Q?XbYNO/MIvXp7iffxCLwT6S3DvPHJqSkUf4vDtwk/q23RRzsJ6jZzkVG0zHYO?=
 =?us-ascii?Q?gT0HdYAHtnmwArW5Soh/1V7vO36sKasJJghld3pCo3WPvy1xHnDwwOtuvMo8?=
 =?us-ascii?Q?YpRMUSlFJgA13lcbwH1uzYe+mgqvhYIyLwUg0mbZ5e3W1p7ydzOm8pdJCFkc?=
 =?us-ascii?Q?eyHbMqjy+flpSXJO09rx9MnVbjNxT/yJPAdfMsolBBJznGvrMbIZQZykrdTu?=
 =?us-ascii?Q?QCpIii+AGsZj29HANiIFZV4eB/j11HBx8PKAfBMlrC5694a4bRSoYjEeTVXj?=
 =?us-ascii?Q?oGgP1SCjDij4avg6Bg8z4tPr36xLrtJal5ZlXpl6LNhlpfmveV0duZvbexmw?=
 =?us-ascii?Q?w3zCEhE/gYlFO0Tw86fYpDkjenIu1/yEz8VWheqh7hvxbOe2MAaJJifm3CNp?=
 =?us-ascii?Q?jvGUZ1gpZq6M1dBpo49I+QgjPjiUntjSJ81Pz4LCwEZpg7dkvxdOcVOpG6qM?=
 =?us-ascii?Q?7x9OBspRusO4mOJpKyd6ouWelQSRi0r2FP+ayXIQCMdXnZwLoRj9ThQhlTyk?=
 =?us-ascii?Q?OYVrU6XjJTp2NLH8RwWV9RrTL/FPvF+W7rkC8jPIPvjgdMFp7a+ppnGBdx0h?=
 =?us-ascii?Q?jM51uowKhqTlJnZrs6NbjNVVTuUG4i7MdjXWCFjd1AUafleBb3UCyTYGvLOT?=
 =?us-ascii?Q?74HwC63EjRwLPO0rTgj+9/wg4ATokqb6dApEq+z7EZTc8MN5LRyWXlOLAhWr?=
 =?us-ascii?Q?OX9nLBMq+n8N4iuKIVETaKurny4r0W/yvgHspYJI5840lUwJGyBbE3K0LN5x?=
 =?us-ascii?Q?s42mOGXwLu4apEqM2uj9tjr8jUy3qB4Anonx/iXApVb5uZr9FGsmquTZZOg/?=
 =?us-ascii?Q?D69754t+2+XpqDVzFoj05KX52B/Ha70k8haU728yY4upWkBXGtfaFneyoydF?=
 =?us-ascii?Q?d41cLLR0x5ArTxhJqIolmEAArRR5f1N6ZkxoxKwcxPsjVpE5Q83ESevDw+0G?=
 =?us-ascii?Q?3PCcfcT5rKclT9BxhaIOKE6/x2BT7JxqgWzGz0s7HI/+H/B1ywvI2g7gHBzs?=
 =?us-ascii?Q?/UH38Q7+cuBOMNYdk+cV9AlV9r8lizf45M2ofjvryJjhwNLDpeuw2ZaVVDUl?=
 =?us-ascii?Q?0aD9Ud5WI9K2CNyshz/WwD1xhpfGpbJoEnzr6TiMDU7WhYr9hogqocMg0w5R?=
 =?us-ascii?Q?QA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3c80069-75b3-4723-30fb-08daf7e90fb4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2023 17:42:39.1129
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LwwpHqRMNuECm3e8DtEOnZeTipwdw81icbYQnW9q5PCwpbdAwTtoqh/o/Io+0oC+6OWZFBUBFEu41V1iX4+ZLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR04MB7353
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 15, 2023 at 01:22:14AM +0200, Vladimir Oltean wrote:
> On Fri, Jan 13, 2023 at 08:43:36PM -0800, Jakub Kicinski wrote:
> > On Wed, 11 Jan 2023 18:16:58 +0200 Vladimir Oltean wrote:
> > > +/**
> > > + * enum ethtool_stats_src - source of ethtool statistics
> > > + * @ETHTOOL_STATS_SRC_AGGREGATE:
> > > + *	if device supports a MAC merge layer, this retrieves the aggregate
> > > + *	statistics of the eMAC and pMAC. Otherwise, it retrieves just the
> > > + *	statistics of the single (express) MAC.
> > > + * @ETHTOOL_STATS_SRC_EMAC:
> > > + *	if device supports a MM layer, this retrieves the eMAC statistics.
> > > + *	Otherwise, it retrieves the statistics of the single (express) MAC.
> > > + * @ETHTOOL_STATS_SRC_PMAC:
> > > + *	if device supports a MM layer, this retrieves the pMAC statistics.
> > > + */
> > > +enum ethtool_stats_src {
> > > +	ETHTOOL_STATS_SRC_AGGREGATE,
> > > +	ETHTOOL_STATS_SRC_EMAC,
> > > +	ETHTOOL_STATS_SRC_PMAC,
> > > +};
> > 
> > Should we somehow call it "MAC stats"?
> > 
> > Right now its named like a generic attribute, but it's not part of 
> > the header nest (ETHTOOL_A_HEADER_*).
> > 
> > I'm not sure myself which way is better, but feels like either it
> > should be generic, in the header nest, and parsed by the common code;
> > or named more specifically and stay in the per-cmd attrs.
> 
> Considering that I currently have separate netlink attributes for
> ETHTOOL_MSG_STATS_GET (ETHTOOL_A_STATS_SRC) and for
> ETHTOOL_MSG_PAUSE_GET (ETHTOOL_A_PAUSE_STATS_SRC), I'm going to add just
> a single attribute right under ETHTOOL_A_HEADER_FLAGS for v3 and go from
> there. Is it ok if I keep naming it ETHTOOL_A_STATS_SRC, or would you
> prefer something else?

I'm already lost while trying to implement this change request.

ETHTOOL_A_STATS_HEADER uses NLA_POLICY_NESTED(ethnl_header_policy),
while ETHTOOL_A_PAUSE_HEADER uses NLA_POLICY_NESTED(ethnl_header_policy_stats).

The two header nest policies look like this:

const struct nla_policy ethnl_header_policy[] = {
	[ETHTOOL_A_HEADER_DEV_INDEX]	= { .type = NLA_U32 },
	[ETHTOOL_A_HEADER_DEV_NAME]	= { .type = NLA_NUL_STRING,
					    .len = ALTIFNAMSIZ - 1 },
	[ETHTOOL_A_HEADER_FLAGS]	= NLA_POLICY_MASK(NLA_U32,
							  ETHTOOL_FLAGS_BASIC),
};

const struct nla_policy ethnl_header_policy_stats[] = {
	[ETHTOOL_A_HEADER_DEV_INDEX]	= { .type = NLA_U32 },
	[ETHTOOL_A_HEADER_DEV_NAME]	= { .type = NLA_NUL_STRING,
					    .len = ALTIFNAMSIZ - 1 },
	[ETHTOOL_A_HEADER_FLAGS]	= NLA_POLICY_MASK(NLA_U32,
							  ETHTOOL_FLAGS_STATS),
};

The request seems to be for ETHTOOL_A_PAUSE_HEADER to use a policy like this:

 const struct nla_policy ethnl_header_policy_mac_stats[] = {
 	[ETHTOOL_A_HEADER_DEV_INDEX]	= { .type = NLA_U32 },
 	[ETHTOOL_A_HEADER_DEV_NAME]	= { .type = NLA_NUL_STRING,
 					    .len = ALTIFNAMSIZ - 1 },
 	[ETHTOOL_A_HEADER_FLAGS]	= NLA_POLICY_MASK(NLA_U32,
 							  ETHTOOL_FLAGS_STATS),
+	[ETHTOOL_A_HEADER_MAC_STATS_SRC] = NLA_POLICY_MASK(NLA_U32,
+							   ETHTOOL_MAC_STATS_SRC_PMAC),
 };

and for ETHTOOL_A_STATS_HEADER to use a policy like this:

const struct nla_policy ethnl_header_policy_mac_stats_src_basic[] = {
	[ETHTOOL_A_HEADER_DEV_INDEX]	= { .type = NLA_U32 },
	[ETHTOOL_A_HEADER_DEV_NAME]	= { .type = NLA_NUL_STRING,
					    .len = ALTIFNAMSIZ - 1 },
	[ETHTOOL_A_HEADER_FLAGS]	= NLA_POLICY_MASK(NLA_U32,
							  ETHTOOL_FLAGS_BASIC),
+	[ETHTOOL_A_HEADER_MAC_STATS_SRC] = NLA_POLICY_MASK(NLA_U32,
+							   ETHTOOL_MAC_STATS_SRC_PMAC),
};

Did I get this right?
