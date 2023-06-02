Return-Path: <netdev+bounces-7440-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AB3A720485
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 16:31:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0728C1C20FBF
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 14:31:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98E18101F8;
	Fri,  2 Jun 2023 14:31:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85BA11E503
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 14:31:47 +0000 (UTC)
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2055.outbound.protection.outlook.com [40.107.20.55])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0D4419B;
	Fri,  2 Jun 2023 07:31:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JCEFnWZ/uDYQbfvzhlYbD4MZSo8xdJVNXFDSayy/3Ecf3BwUCbkfdpNDgL3qDTN6w/j/cT60Xg2s/3oGFVO1ai+StDLtYOSz6XYPlfgOIe7XBp7syLZulmTd7AMVO8K/kVmZKPCb+5jrHlGaFiYdMo7aMjp5XG3kHZKfYCmysogqtn0WPbpssC6sMAfFU73Znyq4sXiraNcq39ZPbLKlfLTM0AE9LRBBHk6PQLeaMIsFTVycjWqCi5F9hSN0zwgoTSvrlB9GjRxudP/V0UYNxONyN+wnpYtLBE/upLUO+mf6aAhGLZjbwAgGOS4XtX2Sa+opR+Ic7FlGYi1sa5cDQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W2204HHKfHkbHh2LIxaj6+oxlCJzFcyhroNYvoz0d3g=;
 b=lrjtrZq+TF7gtTnJLAXCfiCsUNL8OgmeCudcnoBWcuMaFE0LwJHW0gXU/1TAY14zxtKCdtuQvaibcRf1oO61mSJnVEr56vsVel+R7pDr1mmt+RTP0xSd4bANZnEZUE6shms/f4d3Bplcl1gDhEL4iKMcAKtZJtpNh3Vn7RCMIJtX+7jsoZeorHCNmvOdDgmk09RRooknFh5vHfxH5G78l9NfhDM2ewwoYPgCZCEwem4X/nzzQprvoMn94q2FkzSIddE5K4iET03zQGbsSsps/uDbsFri9YOPCpbS2sHcIC9LWTkMMufB7TN86zRwTzJ0L/FuJwCCyl267HgaNH+v6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W2204HHKfHkbHh2LIxaj6+oxlCJzFcyhroNYvoz0d3g=;
 b=G11uN2b3XxE8NB+ZaMe0d5Exk4+jcVJkzZY/Vn72HLgrACNXupwAF/bp/DLJl7YQoRmiwJPgKEc5TM8nhwlyqEDJTnCs2VU9l7nEGzM/6YngThQa1peiHTm4gzZg4WIJ4M/+aJSjeE3ueQCCjtZ54nQqhoo05MdleP9zwZgAaYc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9070.eurprd04.prod.outlook.com (2603:10a6:150:21::14)
 by DBBPR04MB7804.eurprd04.prod.outlook.com (2603:10a6:10:1e0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.23; Fri, 2 Jun
 2023 14:31:43 +0000
Received: from GV1PR04MB9070.eurprd04.prod.outlook.com
 ([fe80::bba5:4ebb:2614:a91]) by GV1PR04MB9070.eurprd04.prod.outlook.com
 ([fe80::bba5:4ebb:2614:a91%7]) with mapi id 15.20.6433.025; Fri, 2 Jun 2023
 14:31:42 +0000
Date: Fri, 2 Jun 2023 17:31:38 +0300
From: Ioana Ciornei <ioana.ciornei@nxp.com>
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: msmulski2@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com,
	olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, simon.horman@corigine.com,
	kabel@kernel.org, Michal Smulski <michal.smulski@ooma.com>
Subject: Re: [PATCH net-next v6 1/1] net: dsa: mv88e6xxx: implement USXGMII
 mode for mv88e6393x
Message-ID: <20230602143138.aaq22cmwinrrhtrv@LXL00007.wbi.nxp.com>
References: <20230602001705.2747-1-msmulski2@gmail.com>
 <20230602001705.2747-2-msmulski2@gmail.com>
 <ZHnEzPadBBbfwj18@shell.armlinux.org.uk>
 <20230602112804.32ffi7mpk5xfzvq4@LXL00007.wbi.nxp.com>
 <ZHnqcvP8hv19RBr8@shell.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZHnqcvP8hv19RBr8@shell.armlinux.org.uk>
X-ClientProxiedBy: VI1PR0102CA0068.eurprd01.prod.exchangelabs.com
 (2603:10a6:803::45) To GV1PR04MB9070.eurprd04.prod.outlook.com
 (2603:10a6:150:21::14)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV1PR04MB9070:EE_|DBBPR04MB7804:EE_
X-MS-Office365-Filtering-Correlation-Id: bba3ed3d-2305-4495-dc77-08db637615bc
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 uW30QIKBV/cT/FvR0BcolKERcsIYFFu/uORJt8cWXzbujVGAVjN5OGTDZLx9Vp0KJ0PBxBQ0mnISiGgmdvA1pUYoKkAMoUIpV8wHDmOFZJq7AW/LH6YRrOAVt8fmxqVIdXgRj6pup3UoP5e3QhhFhIew6P5lIuSE1BFKdBirSoHIQuh4TJlq6FPWi44TxTnnKifTaOChVOJAeqfouIHIboc7ccR6o8P4IyiMsnz5A1Mji4xzhEYFpTfwt18iUZfbPKbViNw+QH6+c2L7ZDMEOeS+vX8ZlFsnOWf/+/Sn+T3ypUhdSg2/blqA6gOZp48ILg491wH97YnBroTSeRgQRTZnGNwPV+qoODnIQNHwElWTeO9ny4nbwGMsAuTmTnFaidGZWFrq6D0x+A8ZDXgZfoFBs9yP1u6DiYQ0D13n8Fp9CCTXQrWNQ4kQfC4BB058eAcTh7IaxGEdO8vseKkMm/NAfr2PLBvZjfM/heb2CSwBohyldVQMZdHylO4KKFRFtKzCgUBlyqNZMfJIMtYiNk54bQCZrLlq4oBcCIgvik3AvUiMYMivtCx4/E98MUS9adJGfJd7/UJDceuMqUTotPYBnEA4bZQEoTllkvugsicYKuEgFU+c2gUclSTB+q+F
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9070.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(366004)(376002)(136003)(396003)(451199021)(38100700002)(86362001)(8676002)(7416002)(5660300002)(6506007)(6512007)(44832011)(1076003)(26005)(41300700001)(66556008)(2906002)(186003)(83380400001)(316002)(19627235002)(66946007)(6666004)(8936002)(66476007)(478600001)(6486002)(6916009)(4326008)(138113003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?hKoagwSrrCzN2aychWKUjkRtcZiVaPdddJApHVu9tphv9Ib1O+f2A/3qM4M7?=
 =?us-ascii?Q?mx2dbQ0Foh9HrizeVEOPRMsumstbPNko6jPYRt+I1gMZrV5UzN1tzJcf6bO6?=
 =?us-ascii?Q?dCksUYbTzbozS0FvLEkx5DYb2yps/yNj+iBtoj4BmMtpBrDNUWuvisiLJoZd?=
 =?us-ascii?Q?Ptk0UYg+Zl86kNXf29WOORD2MNUMvMPzeEDI9ONDBgFeD2i09A0XMWoX7dRl?=
 =?us-ascii?Q?nLBYVqSIozhsGVMqkFOsfX2Jc8JIijP4f6qu2B50g/Nu0iuCR121KJnDA4M6?=
 =?us-ascii?Q?1Kn53Yr/aWJC0qktMrsAYkAggUqSlp5u/4nK0xZ589QWqpXx0PGi9w1FO5aH?=
 =?us-ascii?Q?lr7nH8/OS3YX6/Rbeg2PMXSjq+Wnu3keVZqeFroaIaChaiuPhX5hQrhO9Fsr?=
 =?us-ascii?Q?/3TBb6uWnoa7ZJflA6c1vtUoiR/76jCWzASavck6EpomVKq9VllWDD/9iu5D?=
 =?us-ascii?Q?Uf0XmcR+/69/B/ThNuxD4rJ0LT/g5Lr98RAHHU5v4gfOkRBaJpn2C+d62ZeH?=
 =?us-ascii?Q?gO4thS8xlSRFqRxv6nSxwfVlrNp4L9aRXib1Nz2XgrC1oLr7JmIkFYW2rFe/?=
 =?us-ascii?Q?P1cCs6aDFyHak2VEpguDoHvorZwQOl2nL3Hy0CUIOrUz87wKbgfp/bG0g1gP?=
 =?us-ascii?Q?GfSxsIc1PcFa5qC6z28JXYFCTTNY33UAgWQ9rqzCS0y+bJaf0Wv/bla+B4tO?=
 =?us-ascii?Q?zpsCoACHfazc1W44/NhxMiuGL2MtQMCmt40TzBlgkOjYuCY8YZdl7Lt1nQwf?=
 =?us-ascii?Q?R2WsqhzYldRdfv51pjFJxlhPEEFACuerVcd3mdTGzMNva5FoekeNDy/McOrf?=
 =?us-ascii?Q?w8CRkjLxHs2YagjgBNoZHp76D83byH1UJAxGESpZkLXEym1NMymQovDWI+Vc?=
 =?us-ascii?Q?0CRqxaCuVm5S9ECagl42haJ0gL6cHYE7k1VesXaagW+VB2hCzXCDdZakMsJs?=
 =?us-ascii?Q?tpEvLBtlOMfvFWH+cYQuFRkmmP8Z006wXG2JAsMmqwQ6bh2SQmOgG+EvDO+M?=
 =?us-ascii?Q?t2/Z43H4nDx5TE70vkqCVeYECl7JAvfJ4Ge2lft3NnAlExhbq3GQgBOIUoij?=
 =?us-ascii?Q?PTV4u+IdoiPyJTFgdZOYnapXUqIC0U6NKbSAZbIe0G+1W8UXwUDl3lULp0/Z?=
 =?us-ascii?Q?P4RAUDMdPnoJqOeNbS71q+QN+x6jkZulFeQ3WlBzlhNVuIPr7POiol+pDDAk?=
 =?us-ascii?Q?RIOgV3ikVyHGdbUJ4D1OWQqjHYL19biWqmEVRzMy5F0+Vh9BKI2JJ83yS0xM?=
 =?us-ascii?Q?ZRBr/ELjPrs0vPNxJasgL5ySTB/1jQqavHDT7n9NElf+1lE8lRba4N5fZ0ba?=
 =?us-ascii?Q?Jyp1F8olCVL1SF5/VPvZqMVdinDEXZAyZj8heds99JmSQWvynnH9hctzzLAA?=
 =?us-ascii?Q?qFCz4ZqspTKRVWdv3wHhTaCThuVsYpdViHbVPU5T5LHt9nC7g6w+OBBwDYXc?=
 =?us-ascii?Q?wK/0I+wcR7uSNZpn9l7OGPAWlJws2hH33QTRLVgFrmhXGfg9VQpapvLbqkFA?=
 =?us-ascii?Q?hg0MfS3oEDdXZSS+D7oaEleDpL5w1wRg09cUFFmqrZqg+8Bd10ia6pJUinkp?=
 =?us-ascii?Q?3BBeKKxTQvFFbJPi+dgOBgN62Pkr1D+rXYmb7Sh9?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bba3ed3d-2305-4495-dc77-08db637615bc
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9070.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2023 14:31:42.7942
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ujYJmOLPd4qE87oUxtS5DYNdFURipr3omZpjfq8H7M9PsNyj1gqt3l3zk6yQQjFDr21cWQ8Udd1K88vVZKhT1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7804
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 02, 2023 at 02:11:14PM +0100, Russell King (Oracle) wrote:
> On Fri, Jun 02, 2023 at 02:28:04PM +0300, Ioana Ciornei wrote:
> > On Fri, Jun 02, 2023 at 11:30:36AM +0100, Russell King (Oracle) wrote:
> > > On Thu, Jun 01, 2023 at 05:17:04PM -0700, msmulski2@gmail.com wrote:
> > > > +/* USXGMII registers for Marvell switch 88e639x are undocumented and this function is based
> > > > + * on some educated guesses. It appears that there are no status bits related to
> > > > + * autonegotiation complete or flow control.
> > > > + */
> > > > +static int mv88e639x_serdes_pcs_get_state_usxgmii(struct mv88e6xxx_chip *chip,
> > > > +						  int port, int lane,
> > > > +						  struct phylink_link_state *state)
> > > > +{
> > > > +	u16 status, lp_status;
> > > > +	int err;
> > > > +
> > > > +	err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
> > > > +				    MV88E6390_USXGMII_PHY_STATUS, &status);
> > > > +	if (err) {
> > > > +		dev_err(chip->dev, "can't read Serdes USXGMII PHY status: %d\n", err);
> > > > +		return err;
> > > > +	}
> > > > +	dev_dbg(chip->dev, "USXGMII PHY status: 0x%x\n", status);
> > > > +
> > > > +	state->link = !!(status & MDIO_USXGMII_LINK);
> > > > +
> > > > +	if (state->link) {
> > > > +		err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
> > > > +					    MV88E6390_USXGMII_LP_STATUS, &lp_status);
> > > 
> > > What's the difference between these two registers? Specifically, what
> > > I'm asking is why the USXGMII partner status seems to be split between
> > > two separate registers.
> > > 
> > > Note that I think phylink_decode_usxgmii_word() is probably missing a
> > > check for MDIO_USXGMII_LINK, based on how Cisco SGMII works (and
> > > USXGMII is pretty similar.)
> > > 
> > > MDIO_USXGMII_LINK indicates whether the attached PHY has link on the
> > > media side or not. It's entirely possible for the USXGMII link to be
> > > up (thus allowing us to receive the "LPA" from the PHY) but for the
> > > PHY to be reporting to us that it has no media side link.
> > > 
> > > So, I think phylink_decode_usxgmii_word() at least needs at the
> > > beginning this added:
> > > 
> > > 	if (!(lpa & MDIO_USXGMII_LINK)) {
> > > 		state->link = false;
> > > 		return;
> > > 	}
> > > 
> > > The only user of this has been the Lynx PCS, so I'll add Ioana to this
> > > email as well to see whether there's any objection from Lynx PCS users
> > > to adding it.
> > >
> > 
> > I just tested this snippet on a LX2160ARDB that has USXGMII on two of
> > its lanes which go to Aquantia AQR113C PHYs.
> > 
> > The lpa read is 0x5601 and, with the patch, the interface does not link
> > up. I am not sure what is happening, if it's this PHY in particular that
> > does not properly set MDIO_USXGMII_LINK.
> 
> Thanks for testing. I wonder if the USXGMII control word that the PHY
> transmits can be read from one of its registers?
> 

I had a look into the AQR gen4 datasheet and the only thing that I could
find is the "PCS USX0 Auto-Neg Control Register" which has the following
field:

	USX0 Auto-Negotiation Message code [7:0]
	Configure the message opcode for USXGMII Auto-Negotiation.

It sounded promising but it's not making any sense to me because it's
just 8 bits long.

> If the PHY is correctly setting the link bit, but it's not appearing
> in the Lynx PCS registers as set, that would be weird, and suggest the
> PCS is handling that itself. Does the Lynx link status bit change
> according to the media link status, while the AN complete bit stays
> set?
>

No, the Lynx link status bit is 1 even though the media side is no
longer connected, for example. Here I just removed the cable, the link
on the PHY is down but the PCS link is up.

[  133.011696] fsl_dpaa2_eth dpni.2 endpmac3: Link is Down
[  133.555343] phylink_decode_usxgmii_word 3331: lpa 0x5601
[  133.560672] mdio_bus 0x0000000008c0f000:00: mode=usxgmii/10Gbps/Full link=1 an_complete=1
[  134.579348] phylink_decode_usxgmii_word 3331: lpa 0x5601


Ioana

