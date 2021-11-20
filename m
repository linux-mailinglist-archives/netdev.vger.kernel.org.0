Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 122C2458071
	for <lists+netdev@lfdr.de>; Sat, 20 Nov 2021 22:25:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236210AbhKTV2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Nov 2021 16:28:22 -0500
Received: from mail-bn7nam10on2098.outbound.protection.outlook.com ([40.107.92.98]:8897
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235830AbhKTV2W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 20 Nov 2021 16:28:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZN2vNJXIfMF+vh2itjoZHrb6JN3AMy94Yws6CRb9fFu9pacAU24tka2kVfNgEigmPvzTWMJibixqkbXNSJ41x0nmage2sFbQ8pn+eaAc9bQbEwId5IKpHB98YhZ1Otku/6b3v3eQ7DVCBc0ii/xZZnfrjUITnD73phE9Y+/CK4SU7gIM/z1PCXWC6HI2WUU6L9vgsLaLFShIJS6s5X0AGUA/KYqYRIZHzxafpX/hGU2HC6kzP93pi6Fn/1k5ZmuSghhmZ+QPMX3rDbgWZK/B6lxY4Yi1+dGkkP556KF5WCOvvAMVRg49lCLDebzW1A+uQ+2buAryPEfOEjcnKCUZAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OO/z2m1EzP0/8QPhhfH4G/Lx6ZmJ2BsMS+iApd0u+hU=;
 b=m6idxlSQnIeJ2zkvuQ2BgdYO5asPW7swT1xlcQYqmA1tp56oBa7aJ8kG2z2Y1ztVsLgUpMbuPq0KV0PAZmGRlX2/psdQmthT23i/IoSQ2G8GQCr27h/WmP+V3BLzrqQj2h4cdoLsWAEkfIlrggszHIafHPy+j018NskcWDT0OU+ucoET/iOCtQpnEj9mTnLO0q1y23TjaBpTLSe2y6I1l92cIpoh4Pd51Ejyb5ojdbmZ4bgFUAzlJv5T+HWrCfC4syU3ktld3u1WiRw2/97a5qkYLolPbpu+gqwsjHZlqvr3almNRUNyx4PoscXP4PGcc/ZH3/FXiRBkSRGbHmEILA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OO/z2m1EzP0/8QPhhfH4G/Lx6ZmJ2BsMS+iApd0u+hU=;
 b=yVUBJoQpYA0phwUzFTnJpaT6p+bDzzdHWHpVAHVddDUvN4bwq21ik0yWeckCYRkAJ4vvAmhRODfi8hEkobGycDko4pMPFRTBxJWnamI4LUUDT2AC7fLbhyVjNS+frrbLkZsOBq5XyJd1deYMkaN/UaYiluh9ZnsXGslC4eTBeow=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO6PR10MB5540.namprd10.prod.outlook.com
 (2603:10b6:303:137::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Sat, 20 Nov
 2021 21:25:16 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4713.019; Sat, 20 Nov 2021
 21:25:16 +0000
Date:   Sat, 20 Nov 2021 13:25:13 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH v1 net-next 1/3] net: mdio: mscc-miim: convert to a
 regmap implementation
Message-ID: <20211120212513.GB2497840@euler>
References: <20211119213918.2707530-1-colin.foster@in-advantage.com>
 <20211119213918.2707530-2-colin.foster@in-advantage.com>
 <YZkPnida0Kd0sG8x@lunn.ch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZkPnida0Kd0sG8x@lunn.ch>
X-ClientProxiedBy: MW3PR05CA0005.namprd05.prod.outlook.com
 (2603:10b6:303:2b::10) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from euler (67.185.175.147) by MW3PR05CA0005.namprd05.prod.outlook.com (2603:10b6:303:2b::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.13 via Frontend Transport; Sat, 20 Nov 2021 21:25:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 94f99f74-db2d-4692-0b7a-08d9ac6c3f0a
X-MS-TrafficTypeDiagnostic: CO6PR10MB5540:
X-Microsoft-Antispam-PRVS: <CO6PR10MB554016EDB743410B2838D5AFA49D9@CO6PR10MB5540.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MQyfesU/r0WSR55OAF0OMZ4l8N/pHWqBkNWILp0brQ7Xqh01KYdhsxIb4Jt3J6Mf0bEXtHkjsWStFT6Yl3WeYBNtGYfIyBiEhQX3F3zUgZFvz+P2p6juNXQBr1CzkvubwwY9gEIhav7ntnIQLL8HTQIQC441hh8jN6hxsJUBfGY18Jo2tCYmw6FT99MP99Bbspb28UVjGpACWHFdJ9/DWN4MU1jTi7z9qWdLe5omqfiX/QparP5x3edzNrIwmpVjLv8PSftds0bqWr/Tc0GuaWdteNr1Wxb4ckjGuMg/2hc3eFN+4lABI0WFzWlEkIWR9Xmgd5YTnPiiB3gJxcMVPMSKozO1ZGJK2ZeBklTLd5YXtKFPQ4AlbrODqYUwQFjVxmK+Vm2Oo4JVvhh24SXwf0395ZyFW01BF/l+op0Rr3sHNCTLO1o7gIJ4sAPe9re9uoory35c4HCblADgq8oeHS+1xWlVUCvfLC8U5qsvwJ4JSGigQR61dbpoJev1C/VNIzNkUE6skglMikG3cc/7IJStfjUy70cWu6xi3+elHiu3EJQBsriWlnWoiPuvJMMjQ++9BL2ISewkPNHHHqfW9N2XC4JW/DSmel5cx7C6qY1w5ggY9t8H9UafWsrLLLMuUJV15tne1Ds3aEGbbZaX6WjN6X1x0gR+LLM95zz9q5s4QKCjlcFaSFTZN2PmoRsrFjePz0+U/OMalDYZQAEqYA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39830400003)(366004)(396003)(346002)(376002)(136003)(4326008)(6496006)(8936002)(54906003)(2906002)(33656002)(956004)(52116002)(6916009)(55016002)(6666004)(9576002)(9686003)(1076003)(26005)(316002)(186003)(86362001)(508600001)(38350700002)(44832011)(7416002)(66946007)(38100700002)(5660300002)(33716001)(66476007)(8676002)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dGmCi7DobuwDcKVLFSsYA4REG8XfQf/cp2mzYh0wuWFXXW67Y1NM4Fo+WzNO?=
 =?us-ascii?Q?HXICoswyvO34uQYxErkJ8uVOnNYNkB4LzTzMJZlToXdmcJ8jMgUh8KuLwBur?=
 =?us-ascii?Q?kGJ67uODjIwjrcahg9vbG1e+S7rLWxfNEUOJIOJwerLFR4MMjO+rEcUnePUT?=
 =?us-ascii?Q?gNY0ShRKfBQ51rC1qhnA9HY77V7JRFSYQ/QWoFuOhwp+raGo0qZMIAt6m1CW?=
 =?us-ascii?Q?r99Sc2Rhk7MoKxCbxPPVL1uCfcoU3fgaXqXDbCX1JDeOS1EmU9P6xSOkHFWt?=
 =?us-ascii?Q?uX44l6VmUnxt3i6E4zOBwNheAPR8ElEWAwgYzDgXziwbiVZf6vgqsPCpo2Bp?=
 =?us-ascii?Q?RvF7l0BKRRaSxcOrzU+TdJj1/zZ64b3LekL7Drl+FXfuJTMrJeP7KIhZDkeu?=
 =?us-ascii?Q?dVNynFpaU6vM3KkLCJMf04OSZV0bAwT7X61I/x3870SbiPBxY95oS5ExWH6c?=
 =?us-ascii?Q?Txqs+y8xrEHwG3ISdgp870YNudAqjvElMBpmIp+SE3lOYAwJgPuHUxdsMZ+r?=
 =?us-ascii?Q?GVtBIOXo28Pt3AbKI0k+ATRobRZFGawDLV/vzznGsTBYZL/00CvYPnMSACA7?=
 =?us-ascii?Q?bTqWAybsLSGibwroxIoW5nsZqA0J/Z5btEmdHZS6ChDMA3MzbFbq9NDlfltv?=
 =?us-ascii?Q?C2igGa0+SRmbyToF6u+esunBOZl/PdODfaSxl/kpdZ77hGBGxyP32wz7Ye7w?=
 =?us-ascii?Q?35A3fCWaYtqXZiF2NIHnCnWBif1VJo6WVduUk8kb75WeoOBXe46XAj8DgSo+?=
 =?us-ascii?Q?0KG0isgrozOYHsa8QBe1Y6XSdcqeYyGKm1Tzn4FbxRf1XA45zIxcmIoJaWK/?=
 =?us-ascii?Q?OYcWnNp7oQljdEsCu0h2X9b4mI/cu2izzoTj68WUPAPXuzSqFow6sENAUi1n?=
 =?us-ascii?Q?fPt8xGR9rVCvjmrGv5jHklReLR3qFsTaB09Tjw9EDR4yXUPUgX7QWiwfZyz+?=
 =?us-ascii?Q?c6YWcWzRjtJc5L64SoDfDdY8Uw88BmvhUzz1l21g7XeIFw54LPy6x7jpzQDh?=
 =?us-ascii?Q?RKvFqH8qT/anGK2pHIkR9ucEfuV//EeaC8407LbRyCEDvE8x5ERtVoldHM6J?=
 =?us-ascii?Q?ugYegjcElmnvM+Gj3OoMktRerQtWzlIoAH2woGRJ3dm8Wj+2OsxqU+eRyxEM?=
 =?us-ascii?Q?u8FvKy10vyE/ZFoKu9KAgV7f3F+9ICqaASm+yCSrBNBqD28tH7ZSFBzzECu3?=
 =?us-ascii?Q?ct1kGSsHMi1gKyZnU4lQ30NKqW0M/Jr3+09vJ+BWNCAe4SIqEzSGKgaLjDq1?=
 =?us-ascii?Q?p2dKKXOqbSA3Rwv+Cz79VCvA88hI7ANeup3aeTTD7tLz3H4CNjXbxndvZlSM?=
 =?us-ascii?Q?wFAstOvZo++y90DSbvl9pgTmERboINCdJUEUe9y8h78s/Zky1wiYow8SvEdR?=
 =?us-ascii?Q?h+h6UkMtbCfdcgSON38eW4D59VPTBz2TQMSqZQaHrlDgS+JgDq2ykxoAngc1?=
 =?us-ascii?Q?i7wd7R7k5cNTnUsj6LrbA8XxkeYvk2lkWuXLawowH0fIytan4GIP3Nr/TYo0?=
 =?us-ascii?Q?qbn79zdbXsL/pHxjsVwJhZLSvs2AMwkj24usqQonoB1dWp4hX+4ZtCmx6egZ?=
 =?us-ascii?Q?1mRidhpgh7vXDTIoAHBgw7Z80CNenjv1x8vUMjTLXc9MH87xXgr402tqaSrC?=
 =?us-ascii?Q?lj8wJmF2cbrLb6qBXhH+dEyzUS/hjZ86zIrClVxIPv+D7C8062rU4ftJraYg?=
 =?us-ascii?Q?psrQtGLHAbklRGWqnYkM/nEKNWY=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94f99f74-db2d-4692-0b7a-08d9ac6c3f0a
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2021 21:25:16.5043
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /fH/ew6c5SFHHdcl0daJPCA2DxMRmP07P8yQTX209AOmyOjeXp72AAtDJOuFSkMbVr+fS9E+VB26tXGK9J5Y1qQCefpgDaOwlU+nujsC8eQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5540
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

Thank you for your feedback! I'll do a sweep for these return cases
before I submit v2.

On Sat, Nov 20, 2021 at 04:09:18PM +0100, Andrew Lunn wrote:
> > @@ -73,22 +84,30 @@ static int mscc_miim_wait_pending(struct mii_bus *bus)
> >  static int mscc_miim_read(struct mii_bus *bus, int mii_id, int regnum)
> >  {
> >  	struct mscc_miim_dev *miim = bus->priv;
> > +	int ret, err;
> >  	u32 val;
> > -	int ret;
> >  
> >  	ret = mscc_miim_wait_pending(bus);
> >  	if (ret)
> >  		goto out;
> >  
> > -	writel(MSCC_MIIM_CMD_VLD | (mii_id << MSCC_MIIM_CMD_PHYAD_SHIFT) |
> > -	       (regnum << MSCC_MIIM_CMD_REGAD_SHIFT) | MSCC_MIIM_CMD_OPR_READ,
> > -	       miim->regs + MSCC_MIIM_REG_CMD);
> > +	err = regmap_write(miim->regs, MSCC_MIIM_REG_CMD, MSCC_MIIM_CMD_VLD |
> > +			   (mii_id << MSCC_MIIM_CMD_PHYAD_SHIFT) |
> > +			   (regnum << MSCC_MIIM_CMD_REGAD_SHIFT) |
> > +			   MSCC_MIIM_CMD_OPR_READ);
> > +
> > +	if (err < 0)
> > +		WARN_ONCE(1, "mscc miim write cmd reg error %d\n", err);
> 
> You should probably return ret here. If the setup fails, i doubt you
> will get anything useful from the hardware.
> 
> >  
> >  	ret = mscc_miim_wait_ready(bus);
> >  	if (ret)
> >  		goto out;
> >  
> > -	val = readl(miim->regs + MSCC_MIIM_REG_DATA);
> > +	err = regmap_read(miim->regs, MSCC_MIIM_REG_DATA, &val);
> > +
> > +	if (err < 0)
> > +		WARN_ONCE(1, "mscc miim read data reg error %d\n", err);
> 
> Same here.
> 
> > +
> >  	if (val & MSCC_MIIM_DATA_ERROR) {
> >  		ret = -EIO;
> >  		goto out;
> > @@ -103,18 +122,20 @@ static int mscc_miim_write(struct mii_bus *bus, int mii_id,
> >  			   int regnum, u16 value)
> >  {
> >  	struct mscc_miim_dev *miim = bus->priv;
> > -	int ret;
> > +	int err, ret;
> >  
> >  	ret = mscc_miim_wait_pending(bus);
> >  	if (ret < 0)
> >  		goto out;
> >  
> > -	writel(MSCC_MIIM_CMD_VLD | (mii_id << MSCC_MIIM_CMD_PHYAD_SHIFT) |
> > -	       (regnum << MSCC_MIIM_CMD_REGAD_SHIFT) |
> > -	       (value << MSCC_MIIM_CMD_WRDATA_SHIFT) |
> > -	       MSCC_MIIM_CMD_OPR_WRITE,
> > -	       miim->regs + MSCC_MIIM_REG_CMD);
> > +	err = regmap_write(miim->regs, MSCC_MIIM_REG_CMD, MSCC_MIIM_CMD_VLD |
> > +			   (mii_id << MSCC_MIIM_CMD_PHYAD_SHIFT) |
> > +			   (regnum << MSCC_MIIM_CMD_REGAD_SHIFT) |
> > +			   (value << MSCC_MIIM_CMD_WRDATA_SHIFT) |
> > +			   MSCC_MIIM_CMD_OPR_WRITE);
> >  
> > +	if (err < 0)
> > +		WARN_ONCE(1, "mscc miim write error %d\n", err);
> 
> And here, etc.
> 
>     Andrew
