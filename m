Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4376645F597
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 21:00:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237890AbhKZUDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 15:03:54 -0500
Received: from mail-mw2nam12on2134.outbound.protection.outlook.com ([40.107.244.134]:28593
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233715AbhKZUBx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Nov 2021 15:01:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nKVmpMfQlW6CccuweBynkiR8wg/jy9m69tA8/8hoOOs2V/m8pGIzgIXl9yctljYDSosSsWNEoVbnAo+B0bS8E01kiPnTRbYSj+xLnWC/5h7/ij7biLLsH17aciVIsVsQmIVl1+ozR+7yUI2D9M2tUgJ9lzS9qwrYCdn+TrpaiS8g63gx2ioTxweTAO2jKnGRq0xcGh3GUWkA3tD7jQosxoA1UsbHCLUosD15vFaqApid+YSOoQ7E0JJUaKIp5E+XZywcUr9P139rBkCxx1U+YCdBq4WBYct0RiQAJQu6N6ldxva0CAy2+FWCHJO8n9KfKLobZk+Gzqx1L9YDxaSWtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I/NBCgEANHGCdr1kHr3d73UZRlFRVDOSTfPKXlp3dsg=;
 b=WGC6MTK5lhBNKkKsjfVNux6XIUrmrS+ONVp0WRtpFkHrYkTQADjcq9gOg15GYt7Kzxt89C5B6kY9S+h+VzWgs2xt2bQUaBhgi5jEA1xGVt14iorjHxhlTJ5WvdeOX/Ahl8Os6xZXs3DP3VE/WQq3WgwrJfNDXavzOOwCCQwo2+oRcxlt93oGRhxZ+8XI5ZvcsYjj/xJin80pL1441sFgSG1CZVhc/kkbptZ877HvIHEoeSkZsm+L5rSqoWkAkVc24FOLEPvuJNWn7J8u252YirgnWT3egVE3YxPzOuJqMT9E3B1iKiWs44G8Rv7CG+cuYl7tu+ELjAUiITcWTLwzow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I/NBCgEANHGCdr1kHr3d73UZRlFRVDOSTfPKXlp3dsg=;
 b=GcCK1zwSW59NQiXHb+6qWdjboFNFWa4QIPjDluqV8quEnfOrpjvYKSrS8RfvRhhHKcm1+n+PO441FNBQ2OCTASAN2Wrj9W+U16YE2PISq6ctQ3yOY4lsLlQKdytgDFNgje5ryZ0cXaAaIOIiHPbsY5J+ZSjVddQqfEpebxnJyfs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO1PR10MB4562.namprd10.prod.outlook.com
 (2603:10b6:303:93::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22; Fri, 26 Nov
 2021 19:58:38 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4734.023; Fri, 26 Nov 2021
 19:58:37 +0000
Date:   Fri, 26 Nov 2021 11:58:32 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH v2 net-next 3/3] net: dsa: ocelot: felix: utilize shared
 mscc-miim driver for indirect MDIO access
Message-ID: <20211126195832.GA3778508@euler>
References: <20211125201301.3748513-1-colin.foster@in-advantage.com>
 <20211125201301.3748513-4-colin.foster@in-advantage.com>
 <20211126005824.cu4oz64hlxgogr4q@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211126005824.cu4oz64hlxgogr4q@skbuf>
X-ClientProxiedBy: MWHPR1601CA0003.namprd16.prod.outlook.com
 (2603:10b6:300:da::13) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from euler (67.185.175.147) by MWHPR1601CA0003.namprd16.prod.outlook.com (2603:10b6:300:da::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23 via Frontend Transport; Fri, 26 Nov 2021 19:58:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b093e56-53ff-4e29-5808-08d9b117229d
X-MS-TrafficTypeDiagnostic: CO1PR10MB4562:
X-Microsoft-Antispam-PRVS: <CO1PR10MB456281C8E0945D0FB8C99CD5A4639@CO1PR10MB4562.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CDTiQhTt0yCgv1iYE+2aOnZkiZVO0hy+IAEoYsfEbShVO6n8UQIuhSfFWjfrx4PsYsk0k2X8jkiywiMQ+2V4Ia65Hs6+yOn11tfu6v/IS1lLy+bKWfMqEEMdf45jANviNpeVprLGyqReEe6cLWUbTfw3Wvm7XmoOn44Gn7E7Fu76w8pYJvVGaV1GUocqKF/jrxtMu3nh7mi4nb34MSarz59d2xhYhxGhlHfix1GeSdjZai0LOuxaqks6CjhmKsZiDF6XFyS3H6GJv8XYIknFpqtr/g53OAVnGnoVVhr3P7Y9zXUz/FKy10HdqAHfUG6oGOaazjqZhIke5uU2Q8EPiQ+N3bIa6qjn4JVO/Uc+BAx5MbkvabPplAJJ8q4CHCNMQ3wanJSQM5eT385kW0SFiN1gFx9PkY29Hqo90c13NPJF+BezyAt3oYZGaWCW71laZOt4e0WTu4j+CTK8WiLmLQl2Rk98Zl88ZsFsR4OEzAIo1BtmRHL7eDtIl0tW0PtWythb+4Ma6BvTjed+XgfLpghdbLfuE7iYNNd0+9gkE6aHXElVpTwnxJ6LAgujSyk2q7ZvcgMBVLRsQWmSjx/zk8A7VgdzbuXbbOwgCCqk3R9R0pfNyN64Y+S3LV8yWY7A4VUoEv1bnwGbYkzZk5+bQLhP9itqmtTOJG0CESq67nsetDM57A+bFtVMJ1VPgcbo/nVg6KgZryAhQqdDQ9rF2g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(396003)(366004)(376002)(39830400003)(6916009)(66556008)(54906003)(316002)(1076003)(186003)(9686003)(6496006)(66946007)(6666004)(66476007)(55016003)(38350700002)(44832011)(83380400001)(38100700002)(26005)(8936002)(33656002)(956004)(508600001)(86362001)(5660300002)(33716001)(7416002)(8676002)(4326008)(2906002)(9576002)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TgJhnkS0MR8M/Z/9z0pBCIs/p5gjvWBXshCgBNjrNBr2imi5INxWGsBgKnb7?=
 =?us-ascii?Q?RQ+H881PCGEjduZQQjo3KeXBjn8Ln0alFXEHtH8iEv7WaSAtbITc9TGFEoyo?=
 =?us-ascii?Q?e7Z4KpfdMykpD2kju7FM30V1YuIBYh6EdZ3Qm2NOdhLq5KvlTo3KYfrLhjGE?=
 =?us-ascii?Q?dTxSs+GtiHuKu13PTe9/LOv9S+GNxkZmEMlzKxKSL8dCV2WWeOD0pEII+wBl?=
 =?us-ascii?Q?bXsLP1vT8ywR6akgrdp8X1f+f3MvHbBrsSiGxj6pb9I308y8DspOZUdZz53n?=
 =?us-ascii?Q?aUnTYGBNbYQqJKNfPX1ly0uNXQhffPTaHbodFmqAuLwaA46lCIHtKbmI+Lq8?=
 =?us-ascii?Q?50hs9T1T6mXsxy+NQJ81Bet9lHOKE/9Sv8PpiHyX5aw07Xc4rud5zjRpABht?=
 =?us-ascii?Q?KzZZxW5+gRCni6kAU4UKXOEl0wokze+aSialh7LfE6YYwHu009u1LyfVbSFi?=
 =?us-ascii?Q?fR2db4O2tI0rYOA/cr2SS1mv+tKmkOPYUohcXwlgYVdDkBkfVN7Wb352KI8/?=
 =?us-ascii?Q?E/YHtjX4z898GArjNfFd8u2wfSuUoFZCdp3ycgQyXZSvEOW5nnJLe0M1a8m5?=
 =?us-ascii?Q?TqWVSNSYdcyeXDvIlg0GA1a67OYPf0uj1tLqQviqpNwfBtKQdr3gNuph4DVY?=
 =?us-ascii?Q?d2avULGqyJ4pLyXtPBJw6sKLVNigIZZPR/ESiFMON3PWc95f+CYOs+Zy93MQ?=
 =?us-ascii?Q?G5e3hdvWR8taF/purOs+8CEI9lxAOlRpAuABoUbt8KB+/5zEqSBDqDrHo5mf?=
 =?us-ascii?Q?Yj/Czx6UH+BxBxxh4t3RelyFB9R3sln1D9u+i5oXZcjtC3HwZ12rvGX3VRCH?=
 =?us-ascii?Q?zuYCY4NR4wVkVdWl+Psq3zNSgIr1TwJqJeXsThuBnSlalsr4qEGi7wpwpV+b?=
 =?us-ascii?Q?MQ3LhRULLvG2WVH4lG1EhzBAfmddaA8PikWBQzrwdGfJiYj1Jip43DniiQDB?=
 =?us-ascii?Q?f5fYmDHMGnidpxYSZrvNqTkyk4vjg4DdHhmhtUZ1WlyOHvogAGqL+DQWABfw?=
 =?us-ascii?Q?QSMdhp0YoftgSY1PD/VjqJ7deKJkyixIG1D7g60Rz4QlQlvf8M5XLwn4Jq3r?=
 =?us-ascii?Q?9Co1S6OFG7SczgA5/Pc4/+Auwf3mMBO9mPsRXfngqqCKtOYmXj41WumVc0m0?=
 =?us-ascii?Q?yDlQjfluGybxOukzaAwJkv+OX4kSOXgmFbCOiIUGgrzFthFIcs2Hic1aLPDY?=
 =?us-ascii?Q?PnChvEAWKbyqOFlUuAm3LTpM78YN/7DlldxFTOHCJGO805toh7LyvTP9czxI?=
 =?us-ascii?Q?xkAS0FVpcKFso32bRiNeZNiOcJQf1SoG9R3VYLx54LjOHkmqgCaqn9HvHvTK?=
 =?us-ascii?Q?rIDDQPwjweWpyINxHh9o1yTM7Wa0zfDW2Yv0IRMU0paUu+L3kiL+hDG3skwy?=
 =?us-ascii?Q?P7eT7fUiSKthKDw07EhE9ZkR3OahrciGl02h3uLqJJSA7HmiTyz8+0jdslKP?=
 =?us-ascii?Q?tXXte/6QB+RSPEgtHEv5Nt84zYUXJ74ZifTvRxzqorAoWI5EgGuZaUW2qzZR?=
 =?us-ascii?Q?K0ZLHZBqemVv4GavVXbdYrXUOoDi54RIB4s74XchEUu1SGo4W/8nOKk5UgdT?=
 =?us-ascii?Q?it5P0XyObpUOsSoACsx4vxJSGLZFZJJ9r9GmEo2s80LXS56lD74aI2y4/QR+?=
 =?us-ascii?Q?BoQUHNnyvRXCF694H0nkLYEZQWNxqeRc10/fCnlhNu3aGXAxSBkSEExr2wCN?=
 =?us-ascii?Q?w5s6xQ=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b093e56-53ff-4e29-5808-08d9b117229d
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2021 19:58:37.6944
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KLAezfPbNAZxkiCzblRm3C32A25jK1vpPvtdWVyIF8xZcO56JseqbbvZ56erJmx3cII8fcstgNXhJyBClXtiRsPHS3sKBQj8MpzBt1jbdbU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4562
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Fri, Nov 26, 2021 at 12:58:25AM +0000, Vladimir Oltean wrote:
> On Thu, Nov 25, 2021 at 12:13:01PM -0800, Colin Foster wrote:
> > Switch to a shared MDIO access implementation by way of the mdio-mscc-miim
> > driver.
> > 
> > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > ---
> 
> I'm sorry, I still wasn't able to boot the T1040RDB to test these, it
> looks like it's bricked or something. I'll try to do more debugging
> tomorrow.

No rush - I clearly have a couple things yet to work out. I appreciate
your time!

> >  
> > -	ret = regmap_read(miim->regs, MSCC_MIIM_REG_DATA, &val);
> > -
> > +	ret = regmap_read(miim->regs,
> > +			  MSCC_MIIM_REG_DATA + miim->mii_status_offset, &val);
> 
> I'd be tempted to create one separate regmap for DEVCPU_MIIM which
> starts precisely at 0x8700AC, and therefore does not need adjustment
> with an offset here. What do you think?

I've gone back and forth on this. 

My current decision is to bring around those offset variables. I
understand it is clunky - and ends up bleeding into several drivers
(pinctrl, miim, possibly some others I haven't gotten to yet...) I'll be
the first to say I don't like this architecture.

The benefit of this is we don't have several "micro-regmaps" running
around, overlapping. 

On the other hand, maybe smaller regmaps wouldn't be the worst thing. It
might make debugging pinctrl easier if I have
sys/kernel/debug/regmap/spi0.0-ocelot_spi-devcpu-gcb-gpio insetead of
just sys/kernel/debug/regmap/spi0.0-ocelot_spi-devcpu-gcb.


So while my initial thought was "don't make extra regmaps when they
aren't needed" I'm now thinking "make extra regmaps for drivers when
they make sense." It would also make behavior consistent with how the
full VSC7514 driver acts.


The last option I haven't put much consideration toward would be to
move some of the decision making to the device tree. The main ocelot
driver appears to leave a lot of these addresses out. For instance
Documentation/devicetree/bindings/pinctrl/mscc,ocelot-pinctrl.txt. 
That added DT complexity could remove needs for lines like this:
> > +			     ocelot->map[GCB][GCB_MIIM_MII_STATUS & REG_MASK],
But that would probably impose DT changes on Seville and Felix, which is
the last thing I want to do.



So at the end of the day, I'm now leaning toward creating a new, smaller
regmap space. It will be a proper subset of the GCB regmap. This would be 
applied here to mdio-mscc-miim, but also the pinctrl-ocelot (GCB:GPIO) and 
pinctrl-microchip-sgpio (GCB:SIO_CTRL) drivers as well for the 7512_spi
driver. I don't know of a better way to get the base address than the
code I referenced above. But I think that is probably the design I
dislike the least.


> 
> >  	if (ret < 0) {
> >  		WARN_ONCE(1, "mscc miim read data reg error %d\n", ret);
> >  		goto out;
> > @@ -134,7 +140,9 @@ static int mscc_miim_write(struct mii_bus *bus, int mii_id,
> >  	if (ret < 0)
> >  		goto out;
> >  
> > -	ret = regmap_write(miim->regs, MSCC_MIIM_REG_CMD, MSCC_MIIM_CMD_VLD |
> > +	ret = regmap_write(miim->regs,
> > +			   MSCC_MIIM_REG_CMD + miim->mii_status_offset,
> > +			   MSCC_MIIM_CMD_VLD |
> >  			   (mii_id << MSCC_MIIM_CMD_PHYAD_SHIFT) |
> >  			   (regnum << MSCC_MIIM_CMD_REGAD_SHIFT) |
> >  			   (value << MSCC_MIIM_CMD_WRDATA_SHIFT) |
> > @@ -149,16 +157,19 @@ static int mscc_miim_write(struct mii_bus *bus, int mii_id,
> >  static int mscc_miim_reset(struct mii_bus *bus)
> >  {
> >  	struct mscc_miim_dev *miim = bus->priv;
> > +	int offset = miim->phy_reset_offset;
> >  	int ret;
> >  
> >  	if (miim->phy_regs) {
> > -		ret = regmap_write(miim->phy_regs, MSCC_PHY_REG_PHY_CFG, 0);
> > +		ret = regmap_write(miim->phy_regs,
> > +				   MSCC_PHY_REG_PHY_CFG + offset, 0);
> >  		if (ret < 0) {
> >  			WARN_ONCE(1, "mscc reset set error %d\n", ret);
> >  			return ret;
> >  		}
> >  
> > -		ret = regmap_write(miim->phy_regs, MSCC_PHY_REG_PHY_CFG, 0x1ff);
> > +		ret = regmap_write(miim->phy_regs,
> > +				   MSCC_PHY_REG_PHY_CFG + offset, 0x1ff);
> >  		if (ret < 0) {
> >  			WARN_ONCE(1, "mscc reset clear error %d\n", ret);
> >  			return ret;
> > @@ -176,8 +187,9 @@ static const struct regmap_config mscc_miim_regmap_config = {
> >  	.reg_stride	= 4,
> >  };
> >  
> > -static int mscc_miim_setup(struct device *dev, struct mii_bus **pbus,
> > -			   struct regmap *mii_regmap, struct regmap *phy_regmap)
> > +int mscc_miim_setup(struct device *dev, struct mii_bus **pbus, const char *name,
> > +		    struct regmap *mii_regmap, int status_offset,
> > +		    struct regmap *phy_regmap, int reset_offset)
> >  {
> >  	struct mscc_miim_dev *miim;
> >  	struct mii_bus *bus;
> > @@ -186,7 +198,7 @@ static int mscc_miim_setup(struct device *dev, struct mii_bus **pbus,
> >  	if (!bus)
> >  		return -ENOMEM;
> >  
> > -	bus->name = "mscc_miim";
> > +	bus->name = name;
> >  	bus->read = mscc_miim_read;
> >  	bus->write = mscc_miim_write;
> >  	bus->reset = mscc_miim_reset;
> > @@ -198,10 +210,15 @@ static int mscc_miim_setup(struct device *dev, struct mii_bus **pbus,
> >  	*pbus = bus;
> >  
> >  	miim->regs = mii_regmap;
> > +	miim->mii_status_offset = status_offset;
> >  	miim->phy_regs = phy_regmap;
> > +	miim->phy_reset_offset = reset_offset;
> 
> The reset_offset is unused. Will vsc7514_spi need it?

Yes, the SPI driver currently uses the phy_regs regmap to reset the phys
when registering the bus. I suppose it isn't necessary to expose that
for Seville right now, since Seville didn't do resetting of the phys at
this point.

> > +	GCB_PHY_PHY_CFG,
> 
> This appears extraneous, you are still using MSCC_PHY_REG_PHY_CFG.

This is related to the comment above. They're both artifacts of the
vsc7512_spi driver and aren't currently used in Seville. For the 7512
this would get defined as 0x00f0 inside vsc7512_gcb_regmap. As suggested
way above, it sounds like the direction (for vsc7512_spi) is to create
two additional regmaps. 
One that would be GCB:MIIM. Then mdio-mscc-miim.c could refer to
GCB:MIIM:MII_CMD by way of the internal MSCC_MIIM_REG_CMD macro, as an
example. 

The same would go for MSCC_PHY_REG_PHY_CFG. If the driver is to reset
the phys during initialization, a regmap at GCB:PHY could be passed in.
Then the offsets MSCC_PHY_REG_PHY_CFG and MSCC_PHY_REG_PHY_STATUS could
be referenced.


So to summarize these changes for v3:
* Create new regmaps instead of offset variables
* Don't expose phy_regmap in mscc_miim_setup yet?
* Don't create GCB_PHY_PHY_CFG yet?


