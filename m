Return-Path: <netdev+bounces-7395-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 84D6872005D
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 13:28:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 250BB2816BB
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 11:28:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 124E317AD8;
	Fri,  2 Jun 2023 11:28:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F371B107B1
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 11:28:13 +0000 (UTC)
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2054.outbound.protection.outlook.com [40.107.247.54])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 479F3194;
	Fri,  2 Jun 2023 04:28:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dY9rXoa0Qe3EcoOUQ9Tm0mnTqFTJBVCEhYm1FSs57+KmdASQ5Q4bdAMbN4FKmXlwpvFAZpieIS6wn/XMTyQYtOvZMbz4NToeGwIOJp+29M1AYm22cxVa5JjIWyny3hWpaITfUvYlOu4H7l2Xg2eCC9jrIJfK1phNFbCMQRZnzBVKxsgZmUxapfTPdSMP5miZvd9dMW2MlaHYE0j54mJrP40IJmk5vewlsCrx3OFwGYdPOMkeWxm/nOEpJASCUce8nj6cCXB634FzQy17NwapgWw4fBYRaumRKTSz6cZV+idPIYGTpbnrFfq4fx6ULv+U4N5m1i7tj9eBkeaLsm4WWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wR2xKqX4M2cxLHany/0HSQD5BnZq9jmX9kC6pB8PBHo=;
 b=fOeX95CjHz+HSrRuCRMn7fjQlgyGXp8Bvr1IpSuljh4DLiH6ExZqhTyVKpeUCqm/rSvsXKcWEyIHmaGKyTQphOH9v5MnE0R+AHB9JJZsMZ7xtd6LNG4G430pigYjuZkOylYPVGxhTTmPHRuftO4Y+2d3LnNft4GE0/aeuDQQ9wjeMjJib/SE2qzcvyyZ7yWfY5ayBmkSbdKvZeFZBKWSsDSbKLT1OtqNc12b47qqgsz0SB5DYk5Ozk3ZGLA3qY72VO0n54WdNRZC440TRJGlCKl4OJ2BviZDRxdbKJ0GRL3XqXCaU5M02PoAgIxrkDqIAgRYX69CJAVSFIQCTVdd9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wR2xKqX4M2cxLHany/0HSQD5BnZq9jmX9kC6pB8PBHo=;
 b=JKNH7y6//1KzRammOKOcwcpdS1hErkNX5AQpFNyzR9P7Lc1zTQ9BvAme4rh9T9kpVaAkXWrfYwczBG7sArfCxMwvF/2623X+lEnd73EO1Dxycm2XmDiU30CBQYX5wm4LzdfiHQFXEqN29GIt9ApetjsAwAA4q3n+p5T50dsVVpU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9070.eurprd04.prod.outlook.com (2603:10a6:150:21::14)
 by AM9PR04MB7524.eurprd04.prod.outlook.com (2603:10a6:20b:286::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.24; Fri, 2 Jun
 2023 11:28:08 +0000
Received: from GV1PR04MB9070.eurprd04.prod.outlook.com
 ([fe80::bba5:4ebb:2614:a91]) by GV1PR04MB9070.eurprd04.prod.outlook.com
 ([fe80::bba5:4ebb:2614:a91%7]) with mapi id 15.20.6433.025; Fri, 2 Jun 2023
 11:28:08 +0000
Date: Fri, 2 Jun 2023 14:28:04 +0300
From: Ioana Ciornei <ioana.ciornei@nxp.com>
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: msmulski2@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com,
	olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, simon.horman@corigine.com,
	kabel@kernel.org, Michal Smulski <michal.smulski@ooma.com>
Subject: Re: [PATCH net-next v6 1/1] net: dsa: mv88e6xxx: implement USXGMII
 mode for mv88e6393x
Message-ID: <20230602112804.32ffi7mpk5xfzvq4@LXL00007.wbi.nxp.com>
References: <20230602001705.2747-1-msmulski2@gmail.com>
 <20230602001705.2747-2-msmulski2@gmail.com>
 <ZHnEzPadBBbfwj18@shell.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZHnEzPadBBbfwj18@shell.armlinux.org.uk>
X-ClientProxiedBy: BE1P281CA0067.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:26::7) To GV1PR04MB9070.eurprd04.prod.outlook.com
 (2603:10a6:150:21::14)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV1PR04MB9070:EE_|AM9PR04MB7524:EE_
X-MS-Office365-Filtering-Correlation-Id: fea372ab-d24d-456c-c85b-08db635c7067
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 OFi2tRJoE+5tEOD4fwpfcDha2J7nNdPmYbEVkh+wJ7hi8YQhe9MkqV+P3hSekS78vNapDdeaBAlh48jzaFDjkuEG/8Smo+SmrL80gmnvVT6azMaUzZS6ex+5V6YeulD+pFQwN4l1qFReFcVg6vh4lnhB7NODJqIE16Q5gs1CxqNd6vupKmJJ0ybeMYKz7xa4di7+HA828F492o6E+V6CmfBezbAYLTr5to4CQB0tVxiuPTXpcIg7wg86JTpH+/rpOC2ighOmt7I4BJLG/acd72ugdszS4TnGjBguOEeiwnpa5nqP37tgyHYtPpB9g0Q0aS+TOY0AxTvWNeYc6undurKa65tvU+2UlSpFuSAF9ylqIZWai9ukF1P+7m5K+KNzUL+A0ulIaSo+R7C7v9Kq91KZlqHQanp42fzX8cqy88/h3aIz/iPPD8pTPDz4TgFleaxc5YP/4gR7zwBngeWiSfzkbokmJ6wrF8SRawjHt5dI9bH6BM5P/80LDTvwWsJBSBNZFjbhJGKrcgU9azzwg0OZh79R623KdJxsWiZGTFW+bymbzYn4Nu4n0hDOQqDzgKYbONR4X0qaTWkUKHbR1Vy3m7h6BMrZIKyR8qJjnbC8Bt+oV/WWTaUP8aPDt3xi
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9070.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(396003)(39860400002)(376002)(366004)(451199021)(5660300002)(41300700001)(8936002)(316002)(66556008)(86362001)(6916009)(4326008)(66476007)(2906002)(66946007)(8676002)(478600001)(38100700002)(44832011)(7416002)(6666004)(6486002)(186003)(26005)(1076003)(6512007)(6506007)(138113003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?OMylnWqkAvOd9s9sLCDy3wFaTNLXS8tDHLAXPIVWtwBcEZTUdTO9FKFCwZ/3?=
 =?us-ascii?Q?4BEAfU8P7CZ7Uq27r48ZVutQbVDoybfpq8oyy/RcdJNFQaIWMW0T8qMnGnCX?=
 =?us-ascii?Q?haGWpXRToJkIfT2Hg4TC2jeC0Zd2MoaE/aw+wGw5ztzevilv3OQ5RosTeBXx?=
 =?us-ascii?Q?TBkNDSGWnbshKnLmtOyKmNWNFiyVf/D5jud01lyf8BzXfWBXzYDjdH659OEY?=
 =?us-ascii?Q?BdiA1wYW3P0HsYRzXlnkQcKNpDyM3paJ53wbe7/MlVbkqIMlAfVaN2eJV5FC?=
 =?us-ascii?Q?wWUOfLCXrltF0lKv3cikO8cZspxnmt3DBcOxdgqjtXwqZQfl8QL2YOeQTeEK?=
 =?us-ascii?Q?lT17eNFHJAahOHfUMQW1ZvCLBb9aW835qyKmKGZGAjMALsepCIr3mJKkFxWY?=
 =?us-ascii?Q?3PQQ3jrC9PHekrlpXHJar5vmz+0SQV5LFcbUqF3a31gKSrHzYNhJC2xX+Ixe?=
 =?us-ascii?Q?bgUpeCwFlzMPfoX2LWn0WJs4uN6jL4zAvtGqTme9mrbzY/mG0DnCtFCvyVWc?=
 =?us-ascii?Q?OleTbA1v7vGlV4Jq90/5IpRRcbdnsY0/YZXINyAsVsoFUISmwwWEg3jO3BEB?=
 =?us-ascii?Q?0PnHhIEs0pMr11FMutVwx/XXAo38jHMNXYJCd1wRRgN6edlGjsxCRdtZK4U7?=
 =?us-ascii?Q?VEVR/MMLHXx4HsdskRd8xWTjtRXLa59WjD+87P1vwcUE/XAH3WxFxqMd4sIa?=
 =?us-ascii?Q?cbLv6PUWB87O4qhOvrgi/kH60xCjvbKf0RbPLq7yDwrdSkUOgiJv2a7PMb2A?=
 =?us-ascii?Q?XinLeFqNldnRe5GKwnmu+lNRfi8jRKBAxoECddNCk1u1KW/gtmk4CZZ9KO8Y?=
 =?us-ascii?Q?6LLDKgcAlkPuP7AHPg40hSI5MCsDaffdOudbnZWuIWB+XFSFkvG9zc2axDME?=
 =?us-ascii?Q?Oji60BShlItjnChDMiRC486BQXc6kM4lwQmk2ym0oqWSW+ylUW9uzdUH1uOb?=
 =?us-ascii?Q?PNdtvxsj5xT7SOE/e9lJ30HUh6Iksk4I1YY5M+8auttSNnohodsZAWkmfuBT?=
 =?us-ascii?Q?sgO4433Roz8OCJAPOQ5X+pERdoN6dVDqY+rSuhjQVUmBVIkfo216Eqe4h01O?=
 =?us-ascii?Q?/8vb1Yc2j9UdeBsa/bg7ZRNURMGDvU/5FWqusXtCSw08eiyTR7clhl1mdHE1?=
 =?us-ascii?Q?hGm24120oZW4EWwS3iGfr4bnMjINJdEd1OtoYooXd4k2nf4eVvz8p7QKK3xL?=
 =?us-ascii?Q?Ih5etUOhfaUVxOrY6xX8N6+/Sz9CU+sYe9Mx529gnCOIdh4r7qZ6tztipnJS?=
 =?us-ascii?Q?81zQRvXGAuE2qxXVmhWZlNoL5qMcw6Qv29gezmxbUdG8Bj5cD+U8TgEIsyuM?=
 =?us-ascii?Q?kHpeSycJu4fa8WTgiomQAWGRy2M/RlZME63yQVKtF3UdJiSBz4UfuMS16I1d?=
 =?us-ascii?Q?o9Hy7auHyct5bTXvT90G3A1dYekbz09YZ9+GHN0j6ulk9vcrGIw6lCpEQ9nd?=
 =?us-ascii?Q?LmUlCURJlVYXCY4JoaOLTL/rX+gukI2kIh3kpf/eeRItoMzsz/L935jNV8gP?=
 =?us-ascii?Q?/bwNrEmQXKhC19pnVy88Gf50NM1DnZzy6XaQ9F9X0crD0/INhCMDiRJC8X8m?=
 =?us-ascii?Q?TE+kbBugcjS0NLkbke/NddNpBD8dw5bZg7OwY8Yo?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fea372ab-d24d-456c-c85b-08db635c7067
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9070.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2023 11:28:07.9425
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lfVn5M4ezk8JF/K0dscze6dbixskb3EJ5mX2Tz6Gvl18U8jXUS6qmg2TAVgAXE3UZEZMTX7lLk1g3JL+zxttow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB7524
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 02, 2023 at 11:30:36AM +0100, Russell King (Oracle) wrote:
> On Thu, Jun 01, 2023 at 05:17:04PM -0700, msmulski2@gmail.com wrote:
> > +/* USXGMII registers for Marvell switch 88e639x are undocumented and this function is based
> > + * on some educated guesses. It appears that there are no status bits related to
> > + * autonegotiation complete or flow control.
> > + */
> > +static int mv88e639x_serdes_pcs_get_state_usxgmii(struct mv88e6xxx_chip *chip,
> > +						  int port, int lane,
> > +						  struct phylink_link_state *state)
> > +{
> > +	u16 status, lp_status;
> > +	int err;
> > +
> > +	err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
> > +				    MV88E6390_USXGMII_PHY_STATUS, &status);
> > +	if (err) {
> > +		dev_err(chip->dev, "can't read Serdes USXGMII PHY status: %d\n", err);
> > +		return err;
> > +	}
> > +	dev_dbg(chip->dev, "USXGMII PHY status: 0x%x\n", status);
> > +
> > +	state->link = !!(status & MDIO_USXGMII_LINK);
> > +
> > +	if (state->link) {
> > +		err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
> > +					    MV88E6390_USXGMII_LP_STATUS, &lp_status);
> 
> What's the difference between these two registers? Specifically, what
> I'm asking is why the USXGMII partner status seems to be split between
> two separate registers.
> 
> Note that I think phylink_decode_usxgmii_word() is probably missing a
> check for MDIO_USXGMII_LINK, based on how Cisco SGMII works (and
> USXGMII is pretty similar.)
> 
> MDIO_USXGMII_LINK indicates whether the attached PHY has link on the
> media side or not. It's entirely possible for the USXGMII link to be
> up (thus allowing us to receive the "LPA" from the PHY) but for the
> PHY to be reporting to us that it has no media side link.
> 
> So, I think phylink_decode_usxgmii_word() at least needs at the
> beginning this added:
> 
> 	if (!(lpa & MDIO_USXGMII_LINK)) {
> 		state->link = false;
> 		return;
> 	}
> 
> The only user of this has been the Lynx PCS, so I'll add Ioana to this
> email as well to see whether there's any objection from Lynx PCS users
> to adding it.
>

I just tested this snippet on a LX2160ARDB that has USXGMII on two of
its lanes which go to Aquantia AQR113C PHYs.

The lpa read is 0x5601 and, with the patch, the interface does not link
up. I am not sure what is happening, if it's this PHY in particular that
does not properly set MDIO_USXGMII_LINK.

Ioana



