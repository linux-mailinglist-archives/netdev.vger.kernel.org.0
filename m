Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCFC235E065
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 15:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344835AbhDMNor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 09:44:47 -0400
Received: from mail-eopbgr130058.outbound.protection.outlook.com ([40.107.13.58]:46739
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1344593AbhDMNoo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 09:44:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZAVtodzE6W2gR6QPdJJoQbF9gH9VJL+WaUAp/SxdjyKHSQEycklHFGEnkF+6Px3VQYpig7mUmK+NHHJ9zkwkkdUs2v1EUydj5qyMQUa/PqU9ZgUfFWD2JxdHcjkihLIwrUIUmGJMXFgyzYjROtn4VaFbsEXP5vhoIYQ7xt/KunAvTCcchYLBQFwDq3zOujUHhjvtSDndEauquBPpgrhTUz3qZ/2epDKwljxE2kHCmLuYTuNNFJabXsS/lEXaPw5Jpfyg12cAg45AhFDCjQaullP3hxtaBdW8HWl7+PYLLbNb8zj8cHxX9ESVMe4G2U+0dvvczIRQSQCj2S31JC6NaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K3No3HnCfBNbMKqDICGhmk9m6DY+g6oS19GsotISd1I=;
 b=KZrPRmCvc2Yp7slme+A3D4cXMaCuO5N6tB6/ANnfRQhVMS/E9Wk7HrC4D2pFGaGqoKK1aYmP6Eloc1lAHErL7R5jTAaqGuCT5P1WHnwfkXrNtTaACMP9tS2VYsG5CcNlNdQzcHkmxU4Ck7H+Ro/9Y+dhTBL8GdAhhhara4Hrv+MhZxtrhTj3+uf8fE5ONzySgZS7RHDCv4g2cO7FQN5RmufX62mUg0kd39rJtbLOKGD0KJ+9+jua+MSVZ96tDMk98T+GBSWb+Ws1Am4HRkJp7GI9+K5O1pxqpWI6g/HxHcFBgpNVblSc18GgJhL5kf5cBcrYpzxVSo6L1vuG6h8Epw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K3No3HnCfBNbMKqDICGhmk9m6DY+g6oS19GsotISd1I=;
 b=Vs1ZZPBOikiBwr0zxNkkalJcoDJ6CtTOY/uYeZoA6dFBULTl73OkvDTAdjC8onRbXHPDL9luW0LE3Ar7hnyPbPoaSnDZg/CpYNG7Q5+/nfOfzwL8gLx2w47mTFNZXXHiPCDeu9qCS7QwPnACp15TVqPNbs+scnKy0Eg6q9Kn+l4=
Authentication-Results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=oss.nxp.com;
Received: from VI1PR04MB5101.eurprd04.prod.outlook.com (2603:10a6:803:5f::31)
 by VI1PR0402MB3742.eurprd04.prod.outlook.com (2603:10a6:803:1f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Tue, 13 Apr
 2021 13:44:20 +0000
Received: from VI1PR04MB5101.eurprd04.prod.outlook.com
 ([fe80::1d18:6e9:995c:1945]) by VI1PR04MB5101.eurprd04.prod.outlook.com
 ([fe80::1d18:6e9:995c:1945%6]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 13:44:20 +0000
Message-ID: <427ccaf425fe68190e22fb23e2918bd300679323.camel@oss.nxp.com>
Subject: Re: [PATCH] phy: nxp-c45: add driver for tja1103
From:   "Radu Nicolae Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 13 Apr 2021 16:44:15 +0300
In-Reply-To: <20210412095012.GJ1463@shell.armlinux.org.uk>
References: <20210409184106.264463-1-radu-nicolae.pirea@oss.nxp.com>
         <20210412095012.GJ1463@shell.armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 
Content-Transfer-Encoding: 8bit
X-Originating-IP: [89.45.21.213]
X-ClientProxiedBy: VI1PR07CA0241.eurprd07.prod.outlook.com
 (2603:10a6:802:58::44) To VI1PR04MB5101.eurprd04.prod.outlook.com
 (2603:10a6:803:5f::31)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.141] (89.45.21.213) by VI1PR07CA0241.eurprd07.prod.outlook.com (2603:10a6:802:58::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.6 via Frontend Transport; Tue, 13 Apr 2021 13:44:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e78c3820-f894-4393-867a-08d8fe823d88
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3742:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3742BE37012E7FF712BE1FB59F4F9@VI1PR0402MB3742.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0NKb42uj2j+CfVMIPe8JbGbsWihbwQhwDrelB2eWZDXhSTNneZT3e1hZZQ79XwKebAhXf/O/UFk8VjXAQOdb4bssK9y1Cv0yzET7HYrOIYkppglMUDz6ogT1lBuS0EsmIiTQWlu7uKTUjej/PTkR/br+/Wl1i2tjkM2fiuDYU9oln3KfG4BOSVaDTJXp9Rrjk4fEAUeBM6pfDZov8q0pGYTxX1LiZO46EgCW/vuIrvbt0LaNlNTZ51n5dYZlxzFj1hYhiYt48eSzzfjTIDoC0CNud2eAYKTIGvR+itctOqPwKd8GX6kBcdM7+VJVZM43No3DAYxc506FGLhbqb7QoKuHzsrb/E6TiEGqtdOhQdQBLIMqfT4Ku/Ui2b66HAQRxYU02yXweoXRZBF63N2Ub6pyaIwnIIWqJ5bxR7p/p50AOEVMz9pdRtZ4TOFy4s64FmGZJuYwBIIsNWMki56VPigr4L7SDpxNf16NzJAi2inEpB2Vy+GUBAUrE7FbJzjTSQdZGmz1C6ZzicKn6zgOmlLc0r8t16OHYVWirk8Em6gCr8JCMkFL2LdTLNEgexF+3S7Rn2Sw/7M31oXo4mHeSs9j8buIEtTdNTTy8LwOmY01RDYENL5nDuH68QvBF6ceAGe4VaeDPiARssk+zfAPUjUXsoO6vCRMxb47w1O/S0w/2PA7l7BBETsrA0O/lngs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5101.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(4326008)(86362001)(16576012)(2906002)(66556008)(6916009)(956004)(26005)(6486002)(38100700002)(83380400001)(52116002)(6666004)(66476007)(2616005)(38350700002)(186003)(66946007)(498600001)(5660300002)(8676002)(16526019)(41350200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?QzAweEtSODJLNWIyNU1ZeTZYUVNIdWhlbXl2eWZ1UlpYT21JTDI1bEVpS1Ur?=
 =?utf-8?B?bkg3V1VKWGtOT1diTzFXVHhhZ3p1d1pTVGJPRzVncmRwczNYeDlIS0pDN3My?=
 =?utf-8?B?U3ZSUGVNZjI1RzYyNWZmL1hpYmF1VmhxY2wvWHlrT25JQm1GQlc0RFpoWEc2?=
 =?utf-8?B?aUREdjlCc1Z4OGtYRlVIemdnTnNrMU9TeisydFZOVXp1Wi9HbDJHQXkrN1Z3?=
 =?utf-8?B?a1RwRjl4SUhBcFpWMitOMDNJeFpUb21CM0RlaXhnYlVyTnN3OFRlZzRrbGx5?=
 =?utf-8?B?QXFWYkQ2MS8wRWlpc3BvMm5qSmJwR0dsSDhzQXYxQk96bnV1WThUWlJLK2lP?=
 =?utf-8?B?Tm1YUU9pcURxY242VExFSFlHYVc5cDBrZzI2WStaa2lmTi9OZG9QWEZXU2pE?=
 =?utf-8?B?aWFjbGxudHhiZnd6TGpUelNQZFl5NjZLM1lsVFBpTmE5SGdIaW0rNU9tWWpx?=
 =?utf-8?B?RXV1YURaZzYrVUN1b1Vzdm1wRWo0cDAvTkJZdytHUGhNbVZ5YVBoTG1CeExy?=
 =?utf-8?B?TGhBdEF0YVZ4RVF2alg4eWZCWVlma3J1a0huSHVhWVFRRzFHZm8va0M0M1hR?=
 =?utf-8?B?bCszT3FXcmlMS29hNlcyS3RzVUdFNEtCQllBRzg4amNreFJSamZHWWV6SVVl?=
 =?utf-8?B?ek5pSm0yZnVKNUZOa0VZMDIxNWMvbk5IMlZscXhmMUpQZGp2WlJub3J4eVVZ?=
 =?utf-8?B?Q0hwSGNHTEdwRUgxUmJxN1kvcmxNSU9GTXNBdjJlOWt4S0E1ZDBmRjk0aVV6?=
 =?utf-8?B?eE9LWmdxWUs2N1ErdVV0bnV2eHBmckQyc1h0WDh6RXlMSTJ6Z2hPYSsvMVBp?=
 =?utf-8?B?bzhNcnlyVFRRUDBrQmJpdE1CZUVTSzZHdWt5b3dlemJ4MnNlRmxiS3BmbzRX?=
 =?utf-8?B?K2pVbWVaclBMbkdhcnF6amhINW5Bc3ZwS0pSTWN6WFpjemh3bm50Q0YwS0FJ?=
 =?utf-8?B?UHJ1eG9nNkFTS2JCU1ppOUxDSzZIdEhuRjdRVloyQVEvMmJaU1puRWRBT1Ey?=
 =?utf-8?B?VDlZT2IwT25kcXBCcGZmSitPekQ5RWZrT0dMWjdyRVE0Q0UyU2ZxMjRsY0R5?=
 =?utf-8?B?Y1ZvV3k0THRuelQ2a09aeGJrai9FVVhzZ29kZ0hhYXBPaWNxUytCbkh4Rjdn?=
 =?utf-8?B?bmkxOHlCUW43MjNNc0c1WU1Zc1hPMXN0dEJleVJya2plZzdvUXF3WEVSbEQ1?=
 =?utf-8?B?VmVyNFdnK045V3RkREN1bjVtb28xMEJsY1FNY3VlZHMwYmNjdmRmckhZUjZu?=
 =?utf-8?B?cFQ1c245T1lSSUUrbzRFQlYwbDJPa25PQmNzMndYUVNmeFNsT1lBNFlNcWEy?=
 =?utf-8?B?eCtLTVpkVFhLUkFFUDNaNU43Y0c0UG1RREZ0d1FxRXh4NEY3b3I1R3VNSzVX?=
 =?utf-8?B?dk9CV2RMQjNDMnlvWC83ajhwZGt1K3liOWpXSGc0NmsycU52b0hhQ1c0ejhR?=
 =?utf-8?B?c2taY04xUG1Vdk05c1JWZDVRYUFKZ0dvcVo4bThGbWN2cFQ0clRwM0VpWm5V?=
 =?utf-8?B?NDBnRGk0cjF3ZkMwZzRXUXBEcEpjcVQ1ejlmMzBvNVhzWm1mTmVBVlBjNkR2?=
 =?utf-8?B?bHlPQ1BnS3FqUFRES3hTbW1lcGRpWGQ1cnc1dis3R0w4T3p0NEp4QlFXdUk2?=
 =?utf-8?B?MGg5OVlVTkc3UFFXVERNQk9OTjZIc2ZHRUZsdGVtdGdhM3ZiZXFEY1lpUEdz?=
 =?utf-8?B?bXcwTEZBc3pjemtLbCtNeFVoZExDT25zdC9MNEZCNmowOGxoM3pYdTJOdkFR?=
 =?utf-8?Q?sm0P8P8UCX4FMY+757UbuMnkIfBsgQRoqVSDUhR?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e78c3820-f894-4393-867a-08d8fe823d88
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5101.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2021 13:44:20.7674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GsG309BhFA26Fr7th9dSuonnPz8Vm43H64K5A3Kk+mIMXV930rp0l9SFGf0sKhuWTOfmMGy26t62PINDPiD36xw1wd7oM7qZ/wu5vgA/4qk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3742
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-04-12 at 10:50 +0100, Russell King - ARM Linux admin
wrote:
> On Fri, Apr 09, 2021 at 09:41:06PM +0300, Radu Pirea (NXP OSS) wrote:
> > +#define B100T1_PMAPMD_CTL              0x0834
> > +#define B100T1_PMAPMD_CONFIG_EN                BIT(15)
> > +#define B100T1_PMAPMD_MASTER           BIT(14)
> > +#define MASTER_MODE                    (B100T1_PMAPMD_CONFIG_EN |
> > B100T1_PMAPMD_MASTER)
> > +#define SLAVE_MODE                     (B100T1_PMAPMD_CONFIG_EN)
> > +
> > +#define DEVICE_CONTROL                 0x0040
> > +#define DEVICE_CONTROL_RESET           BIT(15)
> > +#define DEVICE_CONTROL_CONFIG_GLOBAL_EN        BIT(14)
> > +#define DEVICE_CONTROL_CONFIG_ALL_EN   BIT(13)
> > +#define RESET_POLL_NS                  (250 * NSEC_PER_MSEC)
> > +
> > +#define PHY_CONTROL                    0x8100
> > +#define PHY_CONFIG_EN                  BIT(14)
> > +#define PHY_START_OP                   BIT(0)
> > +
> > +#define PHY_CONFIG                     0x8108
> > +#define PHY_CONFIG_AUTO                        BIT(0)
> > +
> > +#define SIGNAL_QUALITY                 0x8320
> > +#define SQI_VALID                      BIT(14)
> > +#define SQI_MASK                       GENMASK(2, 0)
> > +#define MAX_SQI                                SQI_MASK
> > +
> > +#define CABLE_TEST                     0x8330
> > +#define CABLE_TEST_ENABLE              BIT(15)
> > +#define CABLE_TEST_START               BIT(14)
> > +#define CABLE_TEST_VALID               BIT(13)
> > +#define CABLE_TEST_OK                  0x00
> > +#define CABLE_TEST_SHORTED             0x01
> > +#define CABLE_TEST_OPEN                        0x02
> > +#define CABLE_TEST_UNKNOWN             0x07
> > +
> > +#define PORT_CONTROL                   0x8040
> > +#define PORT_CONTROL_EN                        BIT(14)
> > +
> > +#define PORT_INFRA_CONTROL             0xAC00
> > +#define PORT_INFRA_CONTROL_EN          BIT(14)
> > +
> > +#define VND1_RXID                      0xAFCC
> > +#define VND1_TXID                      0xAFCD
> > +#define ID_ENABLE                      BIT(15)
> > +
> > +#define ABILITIES                      0xAFC4
> > +#define RGMII_ID_ABILITY               BIT(15)
> > +#define RGMII_ABILITY                  BIT(14)
> > +#define RMII_ABILITY                   BIT(10)
> > +#define REVMII_ABILITY                 BIT(9)
> > +#define MII_ABILITY                    BIT(8)
> > +#define SGMII_ABILITY                  BIT(0)
> > +
> > +#define MII_BASIC_CONFIG               0xAFC6
> > +#define MII_BASIC_CONFIG_REV           BIT(8)
> > +#define MII_BASIC_CONFIG_SGMII         0x9
> > +#define MII_BASIC_CONFIG_RGMII         0x7
> > +#define MII_BASIC_CONFIG_RMII          0x5
> > +#define MII_BASIC_CONFIG_MII           0x4
> > +
> > +#define SYMBOL_ERROR_COUNTER           0x8350
> > +#define LINK_DROP_COUNTER              0x8352
> > +#define LINK_LOSSES_AND_FAILURES       0x8353
> > +#define R_GOOD_FRAME_CNT               0xA950
> > +#define R_BAD_FRAME_CNT                        0xA952
> > +#define R_RXER_FRAME_CNT               0xA954
> > +#define RX_PREAMBLE_COUNT              0xAFCE
> > +#define TX_PREAMBLE_COUNT              0xAFCF
> > +#define RX_IPG_LENGTH                  0xAFD0
> > +#define TX_IPG_LENGTH                  0xAFD1
> > +#define COUNTERS_EN                    BIT(15)
> > +
> > +#define CLK_25MHZ_PS_PERIOD            40000UL
> > +#define PS_PER_DEGREE                  (CLK_25MHZ_PS_PERIOD / 360)
> > +#define MIN_ID_PS                      8222U
> > +#define MAX_ID_PS                      11300U
> 
> Maybe include some prefix as to which MMD each of these registers is
> located?
I will add the MMD as prefix. Thank you.
> 
> > +static bool nxp_c45_can_sleep(struct phy_device *phydev)
> > +{
> > +       int reg;
> > +
> > +       reg = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_STAT1);
> > +       if (reg < 0)
> > +               return false;
> > +
> > +       return !!(reg & MDIO_STAT1_LPOWERABLE);
> > +}
> 
> This looks like it could be useful as a generic helper function -
> nothing in this function is specific to this PHY.
> 
> > +static int nxp_c45_resume(struct phy_device *phydev)
> > +{
> > +       int reg;
> > +
> > +       if (!nxp_c45_can_sleep(phydev))
> > +               return -EOPNOTSUPP;
> > +
> > +       reg = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_CTRL1);
> > +       reg &= ~MDIO_CTRL1_LPOWER;
> > +       phy_write_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_CTRL1, reg);
> > +
> > +       return 0;
> > +}
> > +
> > +static int nxp_c45_suspend(struct phy_device *phydev)
> > +{
> > +       int reg;
> > +
> > +       if (!nxp_c45_can_sleep(phydev))
> > +               return -EOPNOTSUPP;
> > +
> > +       reg = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_CTRL1);
> > +       reg |= MDIO_CTRL1_LPOWER;
> > +       phy_write_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_CTRL1, reg);
> > +
> > +       return 0;
> > +}
> 
> These too look like potential generic helper functions.
That's true.
Should I implement them as genphy_c45_pma_suspend/resume? Given that we
can also have PCS suspend/resume too.

However, in my case, PMA low power bit will enable low power for PCS as
well.

