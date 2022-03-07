Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 518764CF0C5
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 05:58:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235222AbiCGE7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 23:59:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235198AbiCGE7D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 23:59:03 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74A041D0DE;
        Sun,  6 Mar 2022 20:58:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1646629089; x=1678165089;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TE/aq1wdmjDo3npDswQetfNwxWwHoSZvc36nIWNyobo=;
  b=L9Tx2vZeT+AuSmKuaDNSTCXZnm4KTunU7KPEpBoZ05Z4JEkgtCPUPkgr
   ZFwmmY3iyU5pIkGC3ybygttW6z8w+lImEe7EaXXdLNjDyCBvFnMqXK2gL
   c5P7SNeeSHgCoPIXCFLqRo1YTEgaaMaEeyJUG1AdpOMbRf3oXxgTjdrzR
   R+nzBW5K5fWiWN7FsHpLnmXE2/M9uMLTP2DrCD68tzaDrZ9LBLMYrYTrC
   dsDyldvyc2a4L/K5G76xiopHWuyj2wbwUiXIx1fPXH/XeW8EaDTk80amn
   jYTPw9GT5vKXWP8+3ho71ulkLjUFmameB3s+8FdbJ31gQXwTvWNAv6cH0
   w==;
X-IronPort-AV: E=Sophos;i="5.90,160,1643698800"; 
   d="scan'208";a="164725594"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Mar 2022 21:58:08 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Sun, 6 Mar 2022 21:58:08 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17 via Frontend Transport; Sun, 6 Mar 2022 21:58:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R0tL3pkytZ7a/C6CYoDu8h03ywNenklbu6yvxor5FEeFtxXnEELYDytrm/2g7DeKJiACtg0VpP9vbpsZp7BDgLMfSOFL8+C5ytFNLJYqty6lW0ObYo/QDcmfFt3tHVn3AeOQtaRLY6NdofLy6nzAQL6xe2s+nUOFmJOWKWNXQ93glLfJ1ISP75K+aRaBwYnXlggGKQ9i4zl30bbEni/XU8YOMgOZk2FNhc/w94jvhABfAe1EEr+JeZBsgEbIlrzLi1pgyf3C9m4P/es5VD/HxOVIj0u4VlUE3Y4EmvyV+8exIgxkecgVCyWRJPoxtlrJtfP/LbiTNfL9kVAR4DdVBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QTvtOIFhvYka8VTZRIPF0+4WARqSDGg57V14USShgOI=;
 b=gZituhcE4VjaQE5AE1RYHYvw6da2N2/yRD+mP7eYGHmOrDcqWY+wugFsg63V7K08ZBhbdauastqB6WWcr5nYTVbBDT5bvdDo2bh90qOwkgOmLb6ZLnTlWosR4RAOvwbLC9po8NkAseLlzyNxhiuy+9X+/fZvcuMG72NSJtRV3+KZVVsz0a1UP7edc5BP3FmHRkbU2nDJ3Miv8ir9MtRq3FRg1KUW7flqzwHQ/UsnAmqcNwTvwHNGH04RWt0O+e+T6JimJ3e/htXf1AXjGN6imX5h9DcMAqaNT9QOz1WAj1ZUNbGnB9bSXRU6hy0FqiWnC/d/jvrohto3p676P8scmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QTvtOIFhvYka8VTZRIPF0+4WARqSDGg57V14USShgOI=;
 b=Vc5uUDn/oIpJUBLN8fVua9nDlus1UhCOF5JHHapwemGXDqrNdhszp0KOlPqFz+VsTqoXCrdB32/yVt49upgPEcosKCRKZua/9Sunf56jY7qVZXwa/LB3/+8VZvXhYuRwEtLULDxrH/wE6CuNCvJFl/sMxpnyEtaLo4wqAB6RNT4=
Received: from CO1PR11MB4771.namprd11.prod.outlook.com (2603:10b6:303:9f::9)
 by BN7PR11MB2548.namprd11.prod.outlook.com (2603:10b6:406:b3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Mon, 7 Mar
 2022 04:58:02 +0000
Received: from CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::7861:c716:b171:360]) by CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::7861:c716:b171:360%3]) with mapi id 15.20.5038.026; Mon, 7 Mar 2022
 04:58:02 +0000
From:   <Divya.Koppera@microchip.com>
To:     <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, <hkallweit1@gmail.com>,
        <linux@armlinux.org.uk>, <davem@davemloft.net>, <kuba@kernel.org>,
        <robh+dt@kernel.org>, <devicetree@vger.kernel.org>,
        <richardcochran@gmail.com>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <Madhuri.Sripada@microchip.com>,
        <Manohar.Puri@microchip.com>
Subject: RE: [PATCH net-next 3/3] net: phy: micrel: 1588 support for LAN8814
 phy
Thread-Topic: [PATCH net-next 3/3] net: phy: micrel: 1588 support for LAN8814
 phy
Thread-Index: AQHYL6tH4CkpBXdSakW2N5WXNu2KiKyvMeSAgAQqbjA=
Date:   Mon, 7 Mar 2022 04:58:02 +0000
Message-ID: <CO1PR11MB4771EC01014BE84EF96AE536E2089@CO1PR11MB4771.namprd11.prod.outlook.com>
References: <20220304093418.31645-1-Divya.Koppera@microchip.com>
 <20220304093418.31645-4-Divya.Koppera@microchip.com>
 <YiIOwZih+I6gsNlM@lunn.ch>
In-Reply-To: <YiIOwZih+I6gsNlM@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 90d975a5-4d64-4e12-ca53-08d9fff70efc
x-ms-traffictypediagnostic: BN7PR11MB2548:EE_
x-microsoft-antispam-prvs: <BN7PR11MB2548C53337B084AD148DE369E2089@BN7PR11MB2548.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FSuJRqFvKF1twp8iKXkm1tRwCSPtZ/zan2wEvqvx0uvwOGqwioBAhDQi08AwKBpDyKi4dx7P4vqY/9lZp4ETNKg9i5rnAZ5oCnl9DBvWaJZkb4bL0SMIZpxevqu8KWi9GDK6uty3HiGjlKwLSvMM8mvk9RhwRcAJRWY86VJfl9OWadzzPsj+HZ/RxMVY+4p4quNtCztT7e9RIJN9LrjdvpMa/6aMbOpheZH+IlKVAnfpU5jFDDwD4X7NdyuoRLrsWOiq41duEDHjgSjgbt51CE334wERtAYwIVYM3nhxfEKf4SxS9a9mk/5Krxd0Xjt5Clve5N7u7R/ZJ5J46eX7zd2CcyGvpSJgkFYuG+MtFGeSS+7YXk+YJyaJWTaUAIbXuW12yAo3KvURauu9D1VV/pRmsukg5T9micwpm7w4vI0wBxp3L+WCtYwU4Ol5tL7SA23/e9L+QECFaaU8fImkrFNC7DqfCUxwDVHFwgFesa6WCBzsKzJW30MJ3ZVwU3I6NDl42du8xkUEn5/5RF14C+B3ZVU/ucbW/wcUmKF0oeIR+wtcs1w2BZpMcTR+L6VMbwrUsuvxqeS6d0tuDXnUJH+P8tIK96SdZFp4HsbeEXmHbpqIhmlnns9aIgBpTp6Zh95N7y6YGkTgPWHkQNrxQwtlXoa3YMbIUIGw3MC3R9n8g6bTiffa6zPGlU/Q7r3SBnL4XkLD4gTOye1M9zz19A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4771.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(86362001)(508600001)(38100700002)(52536014)(71200400001)(54906003)(55016003)(107886003)(6916009)(122000001)(38070700005)(7696005)(6506007)(76116006)(66556008)(66946007)(4326008)(316002)(66476007)(66446008)(8676002)(64756008)(9686003)(26005)(33656002)(186003)(83380400001)(53546011)(8936002)(7416002)(5660300002)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QhEn0NFSqCojIcdW3c5CnqfIT0Ep23V0xzxci45lDguU32Wq2mEEpy+veQ+d?=
 =?us-ascii?Q?Qn66ZeCNoXcL/aCZ80NZ+ORKvYUWC4qUPpWXVq/VYC971Rftp7JisMe0nufG?=
 =?us-ascii?Q?eir7l/ZREDSk3d4QUaMoC1VottMfHMkJ+LqG0ujySWeQXUohwsP5TUvNhfSO?=
 =?us-ascii?Q?8gyoh1k4LefwdYoq8ZB45EFYkeqfAzqn5t/Hl7Iq2oa5bdrkotrMPI3du4uj?=
 =?us-ascii?Q?kpIChoBPM+iGeTgzarEhEakjGv/PcT0XU4QKJw+BxSdZ7BA3PypPWWlg7L5c?=
 =?us-ascii?Q?dO9iqEJoSn97qpgH7yEJ6nIY8AMQGsLgkwvpUOYcLfSfUM45SdBL4hDNdTis?=
 =?us-ascii?Q?ZVGBchCv15cMWNa3VEnLz74B1ZI1oljbNiVqubmFr/gbRioc6JmQ5hwi5FQ9?=
 =?us-ascii?Q?JZIjK/ibdeGdRcAZohT4EzGdu3nPLL/28kMlGkAlVIxpODMc4CMyDrLB+jvp?=
 =?us-ascii?Q?SIcdoRnrGQbqHUwS6xKWLRMcYZDcNaNYtOhvV3pifsy4tPPdqPPnDa+zqQG2?=
 =?us-ascii?Q?kDVMpVZ73ZiCYr9h+a3Xjuv/JZ8jj59R6AjgSUWi90hbz5kSPtpxC6P66tt1?=
 =?us-ascii?Q?utYrX08Tadg0p/XfLm5zswdQosw/RMqq3S3wXNFPeA7zoPwcrbZxZC99xjr+?=
 =?us-ascii?Q?goJk5MZZW6g1BnlV4f2TBh8cjlJOcKOJKOLYZtVLeFU5MAc7E3OgrIDoiqfs?=
 =?us-ascii?Q?xrwV4Xu+yrNReYKiQW8bb/r8+cMFeMvV25LjP9Jc9PSWj2tDBQhZLpu+uUir?=
 =?us-ascii?Q?hck+L0RkF5IFfcKQOCuan3BwJZ92vpTXuTiPEJ66aq4/w7vEg6Ijrlh0WTF6?=
 =?us-ascii?Q?vT2CosTuBhx+8VwO+mxA8YOcfGCT+ercFVC6yiZd9gZ9FPkyYMHxo3GqncJr?=
 =?us-ascii?Q?uhr+8RbLkYOHeRrUJhkeD1/H3jlMLA1MR94rHl1W6S0t2bJaRx3nAOhQaqa+?=
 =?us-ascii?Q?TWZ/oFEwhVQtSCLfS1ZFGYXEPZg4AaepVIe97qkbjzW+yfMO5a1maEEDz69y?=
 =?us-ascii?Q?2+OgY95ljsI4VWTjMpnAxUULiKiL6JY1pIIV/qnoV1A8qYYPEv1KevFg2UED?=
 =?us-ascii?Q?+xJtzV0cEJvFSJYj8B01IEnRZVf1WWOzjtcnfed8IWHUfPVd8i2ItHdTk4Yd?=
 =?us-ascii?Q?8O/6V7YmV8lNzwyA8UoRihQ0KPDNhJcY7kXyjQsv7c/jD4bbEvM7x3XFRcHu?=
 =?us-ascii?Q?UbMg2sZ7gXrPqcP6V+9ILcNbwterJasQladRDi+s8aeni8nr3jSeCn/Zpbwj?=
 =?us-ascii?Q?22T6OA6PkaC3GKCp6f/zXJUzGY5kkEaTvFmkNu3uHsqTUo3G/3R/BqvYsLrh?=
 =?us-ascii?Q?iLpUYT7IbQxNNraVSYfiXK1g+fneAoVB2PDlkeRvLsIgeYqrwQDMhNgmwMsh?=
 =?us-ascii?Q?bNE6iNP7kAdIZzo1V7sLhVlLdjwss58fbeDk+bvtES0nv3lGpkqreNnJqMxn?=
 =?us-ascii?Q?GbJ2HqKTECWqIeNZ08JlSiuVVXMNiNTz/1ZHG+W7cOONDgdTtSiRQcUa7Hzx?=
 =?us-ascii?Q?MtHSBvzHYO6NLiGn6IN5TjwgEsHbnIoAXukCl1Kcf+iSwkdxLvuobM0nLIGm?=
 =?us-ascii?Q?fu9/cVxaDJaQB7JbbgCA2OpBqV+B56ucBHH1ycpVo01khz+CFsD7MWcQ8dzk?=
 =?us-ascii?Q?nLCM5SR6touJfBnysjUEQSjXETHi7U6AJ89nsKfVzlfcLx5mv6rgkTvfCChf?=
 =?us-ascii?Q?Qw+Orw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4771.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90d975a5-4d64-4e12-ca53-08d9fff70efc
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Mar 2022 04:58:02.2151
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Q6Lh+qCldBlkSKk9IWNdKU0sllZeRKSu/V1m9GNgnUWS61exKdWvKbBEGrygLrjXuNIBGkoVy/Ebi1FH4cuRuGBJ1j0h/Z7HST5wYhWRO68=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR11MB2548
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Friday, March 4, 2022 6:36 PM
> To: Divya Koppera - I30481 <Divya.Koppera@microchip.com>
> Cc: netdev@vger.kernel.org; hkallweit1@gmail.com; linux@armlinux.org.uk;
> davem@davemloft.net; kuba@kernel.org; robh+dt@kernel.org;
> devicetree@vger.kernel.org; richardcochran@gmail.com; linux-
> kernel@vger.kernel.org; UNGLinuxDriver <UNGLinuxDriver@microchip.com>;
> Madhuri Sripada - I34878 <Madhuri.Sripada@microchip.com>; Manohar Puri -
> I30488 <Manohar.Puri@microchip.com>
> Subject: Re: [PATCH net-next 3/3] net: phy: micrel: 1588 support for LAN8=
814
> phy
>=20
> EXTERNAL EMAIL: Do not click links or open attachments unless you know th=
e
> content is safe
>=20
> > +static struct kszphy_latencies lan8814_latencies =3D {
> > +     .rx_10          =3D 0x22AA,
> > +     .tx_10          =3D 0x2E4A,
> > +     .rx_100         =3D 0x092A,
> > +     .tx_100         =3D 0x02C1,
> > +     .rx_1000        =3D 0x01AD,
> > +     .tx_1000        =3D 0x00C9,
> > +};
>=20
> Seems odd to use hex here. Are these the defaults? At minimum, you need t=
o
> add these to the binding document, making it clear what defaults are used=
.
> Also, what are the unit here?

Yes Andrew, these are default values. Richard too mentioned about this as b=
elow
"However, DTS is probably the wrong place.  The linuxptp user space stack h=
as configuration variables for this purpose:"
I will check regarding this and will come with fix in next patch if its app=
licable.

>=20
> > +     /* Make sure the PHY is not broken. Read idle error count,
> > +      * and reset the PHY if it is maxed out.
> > +      */
> > +     regval =3D phy_read(phydev, MII_STAT1000);
> > +     if ((regval & 0xFF) =3D=3D 0xFF) {
> > +             phy_init_hw(phydev);
> > +             phydev->link =3D 0;
> > +             if (phydev->drv->config_intr && phy_interrupt_is_valid(ph=
ydev))
> > +                     phydev->drv->config_intr(phydev);
> > +             return genphy_config_aneg(phydev);
> > +     }
>=20
> Is this related to PTP? Or is the PHY broken in general? This looks like =
it should
> be something submitted to stable.
>

Previously lan8814 phy used kszphy_read_status, we have reused the same fun=
ction and added new
 Changes related to latency with new function lan8814_read_status.
=20
> > +static int lan8814_config_init(struct phy_device *phydev) {
> > +     int val;
> > +
> > +     /* Reset the PHY */
> > +     val =3D lanphy_read_page_reg(phydev, 4, LAN8814_QSGMII_SOFT_RESET=
);
> > +     val |=3D LAN8814_QSGMII_SOFT_RESET_BIT;
> > +     lanphy_write_page_reg(phydev, 4, LAN8814_QSGMII_SOFT_RESET,
> > + val);
> > +
> > +     /* Disable ANEG with QSGMII PCS Host side */
> > +     val =3D lanphy_read_page_reg(phydev, 5,
> LAN8814_QSGMII_PCS1G_ANEG_CONFIG);
> > +     val &=3D ~LAN8814_QSGMII_PCS1G_ANEG_CONFIG_ANEG_ENA;
> > +     lanphy_write_page_reg(phydev, 5,
> > + LAN8814_QSGMII_PCS1G_ANEG_CONFIG, val);
> > +
> > +     /* MDI-X setting for swap A,B transmit */
> > +     val =3D lanphy_read_page_reg(phydev, 2, LAN8814_ALIGN_SWAP);
> > +     val &=3D ~LAN8814_ALIGN_TX_A_B_SWAP_MASK;
> > +     val |=3D LAN8814_ALIGN_TX_A_B_SWAP;
> > +     lanphy_write_page_reg(phydev, 2, LAN8814_ALIGN_SWAP, val);
>=20
> This does not look related to PTP. If David has not ready merged this, i =
would
> of said you should of submitted this as a separate patch.
>=20

This code already present in lan8814 phy code. I think due to movement of f=
unction from up to down.
This change reflected here.

> > +static void lan8814_parse_latency(struct phy_device *phydev) {
> > +     const struct device_node *np =3D phydev->mdio.dev.of_node;
> > +     struct kszphy_priv *priv =3D phydev->priv;
> > +     struct kszphy_latencies *latency =3D &priv->latencies;
> > +     u32 val;
> > +
> > +     if (!of_property_read_u32(np, "lan8814,latency_rx_10", &val))
> > +             latency->rx_10 =3D val;
> > +     if (!of_property_read_u32(np, "lan8814,latency_tx_10", &val))
> > +             latency->tx_10 =3D val;
> > +     if (!of_property_read_u32(np, "lan8814,latency_rx_100", &val))
> > +             latency->rx_100 =3D val;
> > +     if (!of_property_read_u32(np, "lan8814,latency_tx_100", &val))
> > +             latency->tx_100 =3D val;
> > +     if (!of_property_read_u32(np, "lan8814,latency_rx_1000", &val))
> > +             latency->rx_1000 =3D val;
> > +     if (!of_property_read_u32(np, "lan8814,latency_tx_1000", &val))
> > +             latency->tx_1000 =3D val;
>=20
> Are range checks need here? You are reading a u32, but PHY registers are
> generally 16 bit.
>=20

Yes this is mistake. May we will need to give fix for this in next patch.

>     Andrew
