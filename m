Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0D348375C
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 20:06:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235981AbiACTG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 14:06:29 -0500
Received: from mail-bn8nam08on2130.outbound.protection.outlook.com ([40.107.100.130]:39877
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235886AbiACTG2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jan 2022 14:06:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FsOBCiQS4liGJ/Bgzd66if36Yyu/dU4R8W6We/M/qpjBFWy4jBfX9VLj2AfANl9LjEJHc0ttEAi2v0OL9fvRB9vfErtfpyj3LWpwDO7atiw3JllnqkV3uq97eAzZkBwdR31QDYLVKbGlh8cESfnhqQFcCAGqwq8icoXri+xbYiDpWBKdSjPMfYPmaTchAhj+OOylawASDz7abF7k8EZ3iBAYBWryOI+K8XBU3spTTgP2v76iAyyd1WtDQ6/UbPUqBwcw7199Hhezv1i4ryMXuJxce+MkQP5x5Z8gr5JrnBe9QS04WJE/qr+bz4evGGvTzVjANYGBPebYzr2wOMsYNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W82td1gs/IfzolkK8LRb+auUNkZjJMnkoMDTF+gSoEY=;
 b=WnoFevauJpt5BDfHaf6xV3Ptf+qacyvYpBHR4th5nzwXNNXkvUiiqlV5enlP9nI7EMuwNNIksPUX49zztOzDVPdJRfmEvgEXWwEtoUt5R8aZS5k50lz8vKI7aYad18LMpW/sP21Bd8wSB3ULgB9PIhLWcxyEyu8LOqHgdG/dYQsHMzCrM8O7/EONhushpj5hZ2oK7sXASBC6TmB/CZW5fCZzoqAUuXs/k7IVPkhdD5asHRJWKieLWEglhzHNhuwmJdmgazBX4WSEd9ZJ/mZXimiS9Gz4sgb/0bwDBaJ+YTI1ZveVmwdln9WN8Ha2JlmNWClbSYdx0km8reHOheP2rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W82td1gs/IfzolkK8LRb+auUNkZjJMnkoMDTF+gSoEY=;
 b=J/z3P2tZeJvDlqYEUyWqlGnHIl/13j94PoAS8S3tKbRr27dYKvdoceBFpL97MXXoBRwPT4sFx4E53xE/ZeDvbLXLkM06a1ZfMGgeUUkASIIHcldsxjvmc9qu1ABCpiLDKwSLEvwD4PPvaSSbNRkLT4L1WQZmKNiQs6obvX4O/qc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO1PR10MB4401.namprd10.prod.outlook.com
 (2603:10b6:303:6d::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.13; Mon, 3 Jan
 2022 19:06:18 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4844.016; Mon, 3 Jan 2022
 19:06:18 +0000
Date:   Mon, 3 Jan 2022 11:06:12 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-gpio@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        katie.morris@in-advantage.com
Subject: Re: [RFC v1] mfd: pinctrl: RFC only: add and utilze mfd option in
 pinctrl-ocelot
Message-ID: <20220103190612.GA2813119@euler>
References: <20211203211611.946658-1-colin.foster@in-advantage.com>
 <Ya3P/Z3jbMpV1Fso@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Ya3P/Z3jbMpV1Fso@google.com>
X-ClientProxiedBy: MW2PR2101CA0017.namprd21.prod.outlook.com
 (2603:10b6:302:1::30) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3ae5b332-79b7-426f-949c-08d9ceec1eef
X-MS-TrafficTypeDiagnostic: CO1PR10MB4401:EE_
X-Microsoft-Antispam-PRVS: <CO1PR10MB440181DBC34DE361C24AA6E8A4499@CO1PR10MB4401.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FETyVmNfdCWYSNZL0hfqJSTOlNtL1ExCAFZfG6UX5ZrWzsDz7ic0OeheB2s4WvPG8YoIl3ln4EMVW47GiXI3w6z+J4kvFbiIiAZ9z+yR9NxZtdmg/33rk/AtuyBxKOwQS3b8gf0i/S5O2vF3wq38cwVwNjLHyLeo8WKQ6Rv4Q3+tfLc27ZE2v9DEJ5uREky6Bk+Vx9wDqVOhCqmD7wV+/yOaPn+w7UVE1feN31feJkvM75b1zsNweMT7GWTDC0FownORtREaGvXrQ1dtXzRFGj2hHhM5CiVyXKp67p1JeYcmm3xUe6AED/0tJSfYf0HQ3TgspSKypk/VS40h1E033Mw7bEU4gefnovhL87ko0zgpqvokR/mYEMLVtv4dx6IWADndFkbVNRI8xPalsrD3aahFOBQ49MeTvAkS7uzsEje+rXh9lYmeyJbvJ5U5eH4HW49FmwDEG69wHbtgjL1UGAL2YnTlV8wQsJXx42+MzV2nD5Qz/et7Baoj2a7l+Z9jXTLggu+wqrQZOkOiUaR1udvBHg0sfeZIGlmzmL/eKUyzMddYhROPEj7WUt6wEMfq7zez3eF1LA1vYOTXq9SDZIYEEa3tMo78nmbWgz2KXCEX5goCEJl3sCGXHRRZ2YeysPj4lcT2SXgwLkJLJnBZs0Zbm7xvQCPC9O+lIDQDPeGqyo5DwqwwoS9mPPbaf3Hs14aUsrpnDPne4H0M/lHBSQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(396003)(136003)(376002)(42606007)(39830400003)(346002)(366004)(6486002)(6506007)(66946007)(26005)(5660300002)(52116002)(66476007)(38100700002)(186003)(107886003)(6666004)(508600001)(33716001)(8936002)(6512007)(66556008)(9686003)(316002)(54906003)(8676002)(6916009)(38350700002)(86362001)(44832011)(1076003)(2906002)(4326008)(33656002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TUpqbFBxdmNDWEZxTVYwR3UweGlHMWZuQ2JQTks2T1lCdEx1Qmt4ZnUyOG80?=
 =?utf-8?B?azVWRGNKZzlXWFRuaVV3UGxIZVB6YjBrQkt4a1dFbXlCRkMwZXNEWCttN2RD?=
 =?utf-8?B?Y1E0VEVPdFlxMWpWYjFzSU5yWVdmOW10czlxalVQMHF0WlFNdzZZRC94dzFM?=
 =?utf-8?B?bTI5anZkUFhrNlJCbjE0bHVYekpQRktIY0doQUdxcWkvNCtUZnZUbkxCVkZH?=
 =?utf-8?B?dXBXMlUzbmNUeHJaMkIzMTYrZVV2M1hCUlEvZ21tWUhaamdLMm4yUXhpVy9y?=
 =?utf-8?B?U3RubTdWeHVpeDYzd0c2T2hNQ3VLd2E4TWtzdUZyQTZ2ZXl5cFZXSUdhelNI?=
 =?utf-8?B?WWJsb3R6eHM5MVpGVW04ZEpGaXdDZ2RiSEdWa0NPWFRNQmo4WTE3eGRhQlhT?=
 =?utf-8?B?bzIzTThFaU0xRmZzdXRNUU43elhiQm9VWDRBRG16UFRJeWRjTkZWck0yRDRq?=
 =?utf-8?B?ckRYSk5MdldWVHk2cDFXalZhMnhLYjhIWitGdHZnSW9DNXRMNldhUENZT0pR?=
 =?utf-8?B?aUR5S0RPUFZwdzNrekZhWW1SbkJkeVdLWVN0K2U1dlI5T1dDanNZcVMxdUVp?=
 =?utf-8?B?ZHdWSzFGSXdiKzJUb2N4MU9BZVJDeDRjQnBvYVJKRUpMNHltdVZFYlRRWmRz?=
 =?utf-8?B?M0JQMVJLOWNEVGhieTIyU3B0RE8vNlpNL0RLbXozT1ljRm9HQUJwSjZDcEow?=
 =?utf-8?B?dnU3YkdndXJiQmhrZ2JLaDBndWIvMkVOYnZGL2ErN1BZdExzK0U4WmFGbERr?=
 =?utf-8?B?aXJ3RFRLOTVrczZVUXBuSHVGSGlMcVlPNFBSWUxyOStWdm9hc2NFS0Rua3Zm?=
 =?utf-8?B?cGhCaFVEYUh0ZVRER2tRR0VET1pvUTE3UXNqZjJwakFTUkRad0Vtd1dIS1FZ?=
 =?utf-8?B?Z09LdXNKTnZBYlllYUROdy8yMmJ4YmJCWHduQU05K0xqL2FOUkFtMFNEL2xM?=
 =?utf-8?B?WnM0Uit5WkI3cDIwcWJyTERDckxINktTNmZ0UzVFcUZPOVNiMUlBWmxBOUVF?=
 =?utf-8?B?SGVhLys5dkVFM1pnMHJZdGJvekU0Ky82MUwxNEI5VnNubW9ieTdjeUUyWGNo?=
 =?utf-8?B?WEFtczFSRmhmbVZvc2ZoZGxUYSs3b1JjaGx3ckhraldPeHp2OU5kbHowMHhT?=
 =?utf-8?B?bXdoekpmRFBWYnFpS3IwcTVXWjhsWFFGaVR4dGRxRys4bnpNYUlsWFI3OEph?=
 =?utf-8?B?N3pqUWZCakNQMGkvd2FIeENIM3MvSkJiYzgrT3Irand5WW03b3gwMWFpSGlJ?=
 =?utf-8?B?SjlEaUV3UXNjMlQ1WUdxdGpwRU5pbnd6MUtscDlJdUZYaE5WWkxmQTFDM05U?=
 =?utf-8?B?RXpiQ0kzNlRsUFhXNkRNOWlyREE1bkpTajQrQXdYNnNzWHFYM3g2YUtYSVpm?=
 =?utf-8?B?ZVNvMXFLYjYrdEVHYWx4U3lrUFJRcDZvVURIWG9ZU2lyUmpocXpGbCtXbmN6?=
 =?utf-8?B?bjVDTUo5RXlyYWpUdmJOLzFSaWpjZDRjTS9VTkFDcEU4OXpjU2hYc0NIWFJq?=
 =?utf-8?B?SVZvNFh5V0xTd3lldGRHZEcwZFV3NU5SeUcrSlNBdlAvbkJ2VU5XNnMyQldu?=
 =?utf-8?B?MlJyZXBQckRFQmxUbnMvT2UyRnJTcXFsOGp4a2lyYkg0UmtuaTg4dEpJVlFE?=
 =?utf-8?B?SldCd25sUWVRbEJ5V1NzaHVEVlBRM3YyS0tEdXZlR3JJLzNOUGxkbFp6Tlhi?=
 =?utf-8?B?UHE3NkpzVnM4V2hiZVR2R0tDMHIzbkZEUVhILzNHc3ZwUjk1QXp4MGd0aFMv?=
 =?utf-8?B?L3U0SktDRHJiaXlkVEFLSWFyM0ZXR2hnQ2FxZDJrTFBtQkczaHRMS2lueitT?=
 =?utf-8?B?cDNkZHFvRDVrNFJUeGU1cDhRaWxqcGlWc0lnMisyTjRsem9OUHlYN2Z1Y2U2?=
 =?utf-8?B?QVIrRG5ZNGVnT3NzMmZvVDhEYTh3SWtjak13dGh4aFBVdVloK1Z4eTZ0bnYz?=
 =?utf-8?B?cE1rbXFEd1RabW0yaWxrQXVNdFhPYnh0akdoV01vQVRqZTJoZHpGL0Zkb25n?=
 =?utf-8?B?bTUyN1ZHSTRqV285RzVlRnBoNWZUR3owKzIzRDg3c1BmQzJYeXRpNlFLV3VM?=
 =?utf-8?B?QUxhSmFQY0Y5VHJNd1ZSaWtLa3Q1VlZ2WXBab0N0bk5QNzJVb2xGOVVlcUxj?=
 =?utf-8?B?dk1XZjZHTWE0R0hKeUNZVlI5YmdZdHBRZnZUV2ZzTWx0dlN3YWQxRGJkY2ti?=
 =?utf-8?B?a3BzTVVGbVZ2VDM3cmxadEEzamdyWCtNNEtESCtaL3FoMkNneS9KNzhSZVdE?=
 =?utf-8?B?eUZiUDJNZmErQXZFNlhFVTRpODBBPT0=?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ae5b332-79b7-426f-949c-08d9ceec1eef
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2022 19:06:18.1100
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0jpZOTQMtLCVCN2+L5dM2j96hOmW+E/Q0unS0rqfZ5sENIbdpzYLlYJj3IsjwQljxi+kw7DZ3OGwEQv5HkRTxDbMOOtsYa2byXYU0kP/MJk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4401
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 06, 2021 at 08:55:25AM +0000, Lee Jones wrote:
> On Fri, 03 Dec 2021, Colin Foster wrote:
> 
> > This is a psuedo-commit, but one that tells the complete story of what I'm
> > looking at. During an actual submission this'll be broken up into two
> > commits, but I'd like to get some feedback on whether this is the correct
> > path for me to be going down.
> > 
> > Background:
> > 
> > Microchip has a family of chips - the VSC7511, 7512, 7513, and 7514. The
> > last two have an internal MIPS processor, which are supported by
> > drivers/net/ethernet/mscc/ocelot_*. The former two lack this processor.
> > 
> > All four chips can be configured externally via a number of interfaces:
> > SPI, I2C, PCIe... This is currently not supported and is my end goal.
> > 
> > The networking portion of these chips have been reused in other products as
> > well. These utilize the common code by way of mscc_ocelot_switch_lib and
> > net/dsa/ocelot/*. Specifically the "Felix" driver.
> > 
> > Current status:
> > 
> > I've put out a few RFCs on the "ocelot_spi" driver. It utilizes Felix and
> > invokes much of the network portion of the hardware (VSC7512). It works
> > great! Thanks community :)
> > 
> > There's more hardware that needs to get configured, however. Currently that
> > includes general pin configuration, and an optional serial GPIO expander.
> > The former is supported by drivers/pinctrl/pinctrl-ocelot.c and the latter
> > by drivers/pinctrl/pinctrl-microchip-sgpio.c.
> > 
> > These drivers have been updated to use regmap instead of iomem, but that
> > isn't the complete story. There are two options I know about, and maybe
> > others I don't.
> > 
> > Option 1 - directly hook into the driver:
> > 
> > This was the path that was done in
> > commit b99658452355 ("net: dsa: ocelot: felix: utilize shared mscc-miim
> > driver for indirect MDIO access").
> > This is in the net-next tree. In this case the Seville driver passes in its
> > regmap to the mscc_miim_setup function, which bypasses mscc_miim_probe but
> > allows the same driver to be used.
> > 
> > This was my initial implementation to hook into pinctrl-ocelot and
> > pinctrl-microchip-sgpio. The good thing about this implementation is I have
> > direct control over the order of things happening. For instance, pinctrl
> > might need to be configured before the MDIO bus gets probed.
> > 
> > The bad thing about this implementation is... it doesn't work yet. My
> > memory is fuzzy on this, but I recall noticing that the application of a
> > devicetree pinctrl function happens in the driver probe. I ventured down
> > this path of walking the devicetree, applying pincfg, etc. That was a path
> > to darkness that I have abandoned.
> > 
> > What is functioning is I have debugfs / sysfs control, so I do have the
> > ability to do some runtime testing and verification.
> > 
> > Option 2 - MFD (this "patch")
> > 
> > It really seems like anything in drivers/net/dsa/ should avoid
> > drivers/pinctl, and that MFD is the answer. This adds some complexity to
> > pinctrl-ocelot, and I'm not sure whether that breaks the concept of MFD. So
> > it seems like I'm either doing something unique, or I'm doing something
> > wrong.
> > 
> > I err on the assumption that I'm doing something wrong.
> > 
> > pinctrl-ocelot gets its resources the device tree by way of
> > platform_get_and_ioremap_resource. This driver has been updated to support
> > regmap in the pinctrl tree:
> > commit 076d9e71bcf8 ("pinctrl: ocelot: convert pinctrl to regmap")
> > 
> > The problem comes about when this driver is probed by way of
> > "mfd_add_devices". In an ideal world it seems like this would be handled by
> > resources. MFD adds resources to the device before it gets probed. The
> > probe happens and the driver is happy because platform_get_resource
> > succeeds.
> > 
> > In this scenario the device gets probed, but needs to know how to get its
> > regmap... not its resource. In the "I'm running from an internal chip"
> > scenario, the existing process of "devm_regmap_init_mmio" will suffice. But
> > in the "I'm running from an externally controlled setup via {SPI,I2C,PCIe}"
> > the process needs to be "get me this regmap from my parent". It seems like
> > dev_get_regmap is a perfect candidate for this.
> > 
> > Perhaps there is something I'm missing in the concept of resources /
> > regmaps. But it seems like pinctrl-ocelot needs to know whether it is in an
> > MFD scenario, and that concept didn't exist. Hence the addition of
> > device_is_mfd as part of this patch. Since "device_is_mfd" didn't exist, it
> > feels like I might be breaking the concept of MFD.
> > 
> > I think this would lend itself to a pretty elegant architecture for the
> > VSC751X externally controlled chips. In a manner similar to
> > drivers/mfd/madera* there would be small drivers handling the prococol
> > layers for SPI, I2C... A core driver would handle the register mappings,
> > and could be gotten by dev_get_regmap. Every sub-device (DSA, pinctrl,
> > other pinctrl, other things I haven't considered yet) could either rely on
> > dev->parent directly, or in this case adjust. I can't imagine a scenario
> > where someone would want pinctrl for the VSC7512 without the DSA side of
> > things... but that would be possible in this architecture that would
> > otherwise not.
> > 
> > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > ---
> >  drivers/mfd/mfd-core.c           | 6 ++++++
> >  drivers/pinctrl/pinctrl-ocelot.c | 7 ++++++-
> >  include/linux/mfd/core.h         | 2 ++
> >  3 files changed, 14 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
> > index 684a011a6396..2ba6a692499b 100644
> > --- a/drivers/mfd/mfd-core.c
> > +++ b/drivers/mfd/mfd-core.c
> > @@ -33,6 +33,12 @@ static struct device_type mfd_dev_type = {
> >  	.name	= "mfd_device",
> >  };
> >  
> > +int device_is_mfd(struct platform_device *pdev)
> > +{
> > +	return (!strcmp(pdev->dev.type->name, mfd_dev_type.name));
> > +}
> > +EXPORT_SYMBOL(device_is_mfd);
> > +
> >  int mfd_cell_enable(struct platform_device *pdev)
> >  {
> >  	const struct mfd_cell *cell = mfd_get_cell(pdev);
> > diff --git a/drivers/pinctrl/pinctrl-ocelot.c b/drivers/pinctrl/pinctrl-ocelot.c
> > index 0a36ec8775a3..758fbc225244 100644
> > --- a/drivers/pinctrl/pinctrl-ocelot.c
> > +++ b/drivers/pinctrl/pinctrl-ocelot.c
> > @@ -10,6 +10,7 @@
> >  #include <linux/gpio/driver.h>
> >  #include <linux/interrupt.h>
> >  #include <linux/io.h>
> > +#include <linux/mfd/core.h>
> >  #include <linux/of_device.h>
> >  #include <linux/of_irq.h>
> >  #include <linux/of_platform.h>
> > @@ -1368,7 +1369,11 @@ static int ocelot_pinctrl_probe(struct platform_device *pdev)
> >  
> >  	regmap_config.max_register = OCELOT_GPIO_SD_MAP * info->stride + 15 * 4;
> >  
> > -	info->map = devm_regmap_init_mmio(dev, base, &regmap_config);
> > +	if (device_is_mfd(pdev))
> > +		info->map = dev_get_regmap(dev->parent, "GCB");
> > +	else
> > +		info->map = devm_regmap_init_mmio(dev, base, &regmap_config);
> 
> What happens if you were to call the wrong API in either scenario?
> 
> If the answer is 'the call would fail', then why not call one and if
> it fails, call the other?  With provided commits describing the
> reason for the stacked calls of course.

Hi Lee, 

As I said in the other thread, sorry for missing this response. My email
blocked it.

That's a good idea. I'll keep this in mind when the final
"get_mfd_regamp" implementation shakes out.

Thanks for the feedback!

> 
> -- 
> Lee Jones [李琼斯]
> Senior Technical Lead - Developer Services
> Linaro.org │ Open source software for Arm SoCs
> Follow Linaro: Facebook | Twitter | Blog
