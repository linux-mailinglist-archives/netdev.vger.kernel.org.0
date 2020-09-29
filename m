Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F24C27BC5E
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 07:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727408AbgI2FSK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 01:18:10 -0400
Received: from mail-eopbgr10061.outbound.protection.outlook.com ([40.107.1.61]:9634
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725536AbgI2FSJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 01:18:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c3MPXo/Xzc17bDXoRxAMUkOpZn2PqXCVFoDrJkQNJcQE20N9KV5dAMD4xOUpMPoGI37o0k6aaI7YyogZNW//7tWNaFzEjTBbBvg30yNGGS/MFISpjenIcUBeRf3XNTqviLCp9KrVP4RA+Bum0m2uyT8T3052LPVD67LP8BxEqkO2bCBO30b4L8wRYSyd4TX3gd2JbjUsadNMVIBzbdXiLGpWcamILSJbQQWpR0E2qZE/1f5Ks+tqsU/q8Wy0sFbCeN/VVL0d40IXmQYHaPQ4aUyk9Hj3Wl26xHkAT8jg2uWqrKzK4LZGSo5o0rXsTA+skbO7EOJrfIC5em3KQ3DE0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y06WuTxQ0jO16EvgdJfsLWOfkoP7YlTour+Pg46I2/Y=;
 b=YRrmqc1rp2aLraJma5xuOySwUepP2iGKF5FUOLrkDwCo/jeWfrPQOw71ojGx6FB8B+aFaskRPqNFAisLuEC1foaetW4I0XslEfa8ndNm+wgmlcjiUgk9SDCr1y+tOhhzhFw7HMj+lMe3r/ghgTOu+AJpc3GOO794Llh9eqmQdhVp6X8L2duiFcCK21T3jpoo8yZ5pPJhSKFXUE2J+ocQ5PWDWN14j1c7GjTbyXI+CpnxqLLOe+wA9tmEU9LKPzgDe9oL0JSy+Kz0DxCPbSEtqMliCcl+ZJj1gMQJbJXZpTB5kh+bXVWl4ooG/oTLR//6LjvOAazMx6z+IE6XGLIaKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y06WuTxQ0jO16EvgdJfsLWOfkoP7YlTour+Pg46I2/Y=;
 b=k2eHRBGoTeZqwvs4uDzI1u0ZeKRBrylt2vHYjs8pjyN+ydsCk27+bDG2i4NKhOSA8e64AGnjz5mNIgyoB2i7GbDjgeCqFY+ed99POTvzXRiJGPU9pmKnznkhW3RhPDYkxwmB2r87afxa9ATFt7uIvGZD72cSk420X0N8t7605A0=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB5476.eurprd04.prod.outlook.com (2603:10a6:208:11d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Tue, 29 Sep
 2020 05:17:22 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a997:35ae:220c:14ef]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a997:35ae:220c:14ef%7]) with mapi id 15.20.3412.029; Tue, 29 Sep 2020
 05:17:22 +0000
Date:   Tue, 29 Sep 2020 10:47:03 +0530
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Grant Likely <grant.likely@arm.com>
Cc:     "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev@vger.kernel.org, linux.cj@gmail.com,
        linux-acpi@vger.kernel.org, nd <nd@arm.com>
Subject: Re: [net-next PATCH v7 1/6] Documentation: ACPI: DSD: Document MDIO
 PHY
Message-ID: <20200929051703.GA10849@lsv03152.swis.in-blr01.nxp.com>
References: <20200715090400.4733-1-calvin.johnson@oss.nxp.com>
 <20200715090400.4733-2-calvin.johnson@oss.nxp.com>
 <f7d2de9c-a679-1ad2-d6ba-ca7e2f823343@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7d2de9c-a679-1ad2-d6ba-ca7e2f823343@arm.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: SG2PR03CA0150.apcprd03.prod.outlook.com
 (2603:1096:4:c8::23) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR03CA0150.apcprd03.prod.outlook.com (2603:1096:4:c8::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.19 via Frontend Transport; Tue, 29 Sep 2020 05:17:18 +0000
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 98ce40c4-7915-4d4e-7e7f-08d86436f1b8
X-MS-TrafficTypeDiagnostic: AM0PR04MB5476:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB547611614802F2F4253E6A8CD2320@AM0PR04MB5476.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7DL+R4tBtW+5TDYsvsY38JN9tWDw98q8sIB0j8uk+YokZG54b3CTzG64HwrGvI0QamU88wSidlV458uq7EQowUMtrzp8sJZ+mDeIdhxry0jb9XCjIn0MmAmtH4y8JMR+JgiueLZF90Crc85ACkBcQ5bHu7qwxLYqerUjHT5WD/Ieb7Kc2rUpi2s0+IbEsJGNKrExtfz7I+/uQkTGfFnE2cB+gilTKj9DMQSLnbHHZpAYeFe1MoDCo1WNjBaaPfrUKCpLgSfbLTxAjWxXDU9XPe6BP6Bgue9L0nQVWnbmMhY0Myvq2KL9hgIkVSHLytpcVhTPnsONtqzEHmpyldY6gcwyp+usoN8+RrplnhnAeAVXdptnQtuonPdYV8XU2MouhxpbJjEu6EgbM39vA4lsH+wo+PCBV04fECermnm/TrTiSXKanEBooEsbjbJw+CQdJJfUxWf9MSnh2ZJjmzTGneztEXwdMupFjfp+CaVEj8vAUFSDsKlRZCVTMZNWzXQk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(39860400002)(366004)(376002)(346002)(1006002)(6666004)(66946007)(5660300002)(86362001)(1076003)(8936002)(66476007)(66556008)(33656002)(8676002)(2906002)(966005)(83380400001)(16526019)(55236004)(186003)(54906003)(44832011)(26005)(7696005)(52116002)(956004)(316002)(6916009)(478600001)(55016002)(9686003)(4326008)(7416002)(6506007)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: mSVASB6mpCVZWLxMjupDQjCm9x6J4yTJ7vp0BOeYM0P93mHmuzF0TeIqCAoxwTTW8/p3qkr7TpHKLr+ZRGif2QeTwAX0sFyFCVcRVKB6p2XZy8kRsqlSU0oIFUPpD2lI6H8Z9g7nrNU4U0zXA5mHWFCLnSReaOWe/IODW15se9kDw+89UTcrqFxIBm+yQNAVFjnQuGvAHLq2oAos0wUjPgFhj0aXgmh96mM0z04Cxrb5ZflUqLzts9SFHPbWs3x5MCPJwkFX6jtknSawReb26IsSwHP7RIqvdCT8XuKkLfmxxjq3NQRjnkP1AcEsLzD6ReGhT/ybwPdq+XBoArGcsdl/NdbvJrAk8yRKvFAq0ZSZoAf4pOQujK2A6uDnC0Zdc0uk6ARXZYqr5nal3Y6kdUEtQoBj9fWqRsV4kwqJpXWETOjrTU/wOWkK+G3eZ4EIJaBdyivDJGx/NUIZsdP628W/fT8NhVuMykczmctIsVFbrwyICkLWrQxX/uBXcENfEP+Gy31+VcRcwYyZQYAs/9whkma6f5CgqKsCabbgRghK3PdirmtKMwyHSkhYVVKkUx11Za0aZrj1Lc1rw0rWKyxB6b26KEpr2R9rN197ZnQOKb6+VFt0vXis8OqlKZ6z/UKLBYNhTR+lXg5095ttHQ==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98ce40c4-7915-4d4e-7e7f-08d86436f1b8
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2020 05:17:22.4154
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: al0T3yhT0qR3ZqZMv3EALnqy41l+NzhBMXH14at+9SmIiRLv3Lq6Nf+uEb06eFgZK70fe2Z6H70CumrMI+ydNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5476
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Grant,

On Fri, Sep 25, 2020 at 02:34:21PM +0100, Grant Likely wrote:
> > +DSDT entry for MDIO node
> > +------------------------
> > +a) Silicon Component
> > +--------------------
> > +	Scope(_SB)
> > +	{
> > +	  Device(MDI0) {
> > +	    Name(_HID, "NXP0006")
> > +	    Name(_CCA, 1)
> > +	    Name(_UID, 0)
> > +	    Name(_CRS, ResourceTemplate() {
> > +	      Memory32Fixed(ReadWrite, MDI0_BASE, MDI_LEN)
> > +	      Interrupt(ResourceConsumer, Level, ActiveHigh, Shared)
> > +	       {
> > +		 MDI0_IT
> > +	       }
> > +	    }) // end of _CRS for MDI0
> > +	    Name (_DSD, Package () {
> > +	      ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> > +	      Package () {
> > +		 Package () {"little-endian", 1},
> > +	      }
> 
> Adopting the 'little-endian' property here makes little sense. This looks
> like legacy from old PowerPC DT platforms that doesn't belong here. I would
> drop this bit.

I'm unable to drop this as the xgmac_mdio driver relies on this variable to
change the io access to little-endian. Default is big-endian.
Please see:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/ethernet/freescale/xgmac_mdio.c?h=v5.9-rc7#n55

Thanks
Calvin
