Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B454B4D6474
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 16:22:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348868AbiCKPXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 10:23:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348849AbiCKPXJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 10:23:09 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE441C6654;
        Fri, 11 Mar 2022 07:22:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1647012124; x=1678548124;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZF6xSQ0Ne11LUHG74GsvqkUs+YD/1xsUdfc52UUOosU=;
  b=xvLmJNTLeojsoN6y6gwwbIyCzMR10uXtcQZew27XTTJsUxISfsWkNTbB
   uYS/EyEQf9A5WhCVGSl2WDY49GwwTcjr5kGp2skLzDLmq8IGzjU7wb+a1
   bYzkPMXEumC85AbJIJ+XTMswqa4ZvnWU+uzaTrY7rPFNgFwtQd4hY7U1H
   sUPURw+Cb+MvgdQF4DwZl+Hfj87s7O9LSZ5CUeCks83xkrbBayd28SIFP
   HSjYuqxaYo5HgdipzMCcLDrrYmfyLAIz+UUVJuDwLWgVB4On2+YssNpbu
   o6T1dLvFDvs4Ide9nLuBoe+87S9iQw7PK8nmBUxQeQE/Eg13CAqlF6qB2
   g==;
X-IronPort-AV: E=Sophos;i="5.90,174,1643698800"; 
   d="scan'208";a="156130114"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Mar 2022 08:22:03 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 11 Mar 2022 08:22:02 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Fri, 11 Mar 2022 08:22:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a25TNUgaHmNEXuk5ySGKe57WWJugW+wTBNbU8Pns+2TvdGqj+9p6GVYW/L/LC+Zq7MqX5Wz8RL+oc6g4DKfVf+3yFFwLCHDDRRM7SPD12oi2C/FHXLrHbxmDT86Iq11tr3GrdOO/HD7DKIoxslYpqumm27ipFHqPWxKyKJ67E0+Rv0i6+uQzlPJvsy9MoEPFdqxbLEaS01+h7whpL95vgWsWt9qnT0FsXU4OYgnRagCVe1t9DgqtnKhdZMw7NmkFGiR2OjcYdu1GVmnpCegc5EsAjbe7jjXrKuQWEGI4pPsC8aKTv3tAKmLtgjB03fQMWYv5DXGggKwsrpXzThShJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OS4MVks8RdFVeI+S0OvhYNgJiBilbRQE2C8/trc4a4g=;
 b=duSN8vNp7Wb6M1gCy7XUXnxUdtHSv1/c1ijuCQ65WyXEQpo9/OZKWnhWSxTJ7vkcJhvdy1SFUAUEShsz6BzoDfmbEyhJorD2gh6N6pGIOsLRzAS1mI4JZ5xVinVeKMOePTua8t9SOb021iUjypkDF17MG4FkiEfjjXKYF3gP6+bOwUVj3hbWV7VUskieSU10kDO+1gc7vhpLnx1h6qngL+/Cv1kuW2y1wU+GKcpBi9QJMRvLhu0OMYWMjtLHVidVzp1/U39a4N16m1CjsV5TXBzfjZDEBhSdWpBnd9aPhzQBdk1+vn6nFW5UhjQ6heMnZ00FVAtSWD9XBnHccHrNzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OS4MVks8RdFVeI+S0OvhYNgJiBilbRQE2C8/trc4a4g=;
 b=EqOv5a8I91JbLMvLFRPpBYYU7sSnUOh71GIs28C7BKnNsAwvW6WwAPYW3EeNavIwPFjn3fSpbFs4beELgRsbVNyDU1BpSIPb/KyTkgd82F01HZSjE16UZNg+Y4BGWcZtvHN/K6nA+q3r5GrC0YmtmfCp+0ra6ckyHyUALxgBZGA=
Received: from BL0PR11MB2913.namprd11.prod.outlook.com (2603:10b6:208:79::29)
 by DM4PR11MB5970.namprd11.prod.outlook.com (2603:10b6:8:5d::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5061.22; Fri, 11 Mar 2022 15:21:58 +0000
Received: from BL0PR11MB2913.namprd11.prod.outlook.com
 ([fe80::a5f2:c2d5:c0e4:2ba9]) by BL0PR11MB2913.namprd11.prod.outlook.com
 ([fe80::a5f2:c2d5:c0e4:2ba9%3]) with mapi id 15.20.5061.022; Fri, 11 Mar 2022
 15:21:58 +0000
From:   <Woojung.Huh@microchip.com>
To:     <richardcochran@gmail.com>, <linux@armlinux.org.uk>
CC:     <Horatiu.Vultur@microchip.com>, <andrew@lunn.ch>,
        <Divya.Koppera@microchip.com>, <netdev@vger.kernel.org>,
        <hkallweit1@gmail.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <robh+dt@kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <Madhuri.Sripada@microchip.com>, <Manohar.Puri@microchip.com>
Subject: RE: [PATCH net-next 2/3] dt-bindings: net: micrel: Configure latency
 values and timestamping check for LAN8814 phy
Thread-Topic: [PATCH net-next 2/3] dt-bindings: net: micrel: Configure latency
 values and timestamping check for LAN8814 phy
Thread-Index: AQHYL6td/B/51zd2r06SOlPtjL8tgKyvLZmAgAQuDgCAAI3yAIABXwsAgABAHoCAAB5+gIAAKOoAgABEIwCAABclAIAA50qAgAAZdICAAFL/AIAC09Vw
Date:   Fri, 11 Mar 2022 15:21:58 +0000
Message-ID: <BL0PR11MB291347C0E4699E3B202B96DDE70C9@BL0PR11MB2913.namprd11.prod.outlook.com>
References: <CO1PR11MB4771237FE3F53EBE43B614F6E2089@CO1PR11MB4771.namprd11.prod.outlook.com>
 <YiYD2kAFq5EZhU+q@lunn.ch>
 <CO1PR11MB4771F7C1819E033EC613E262E2099@CO1PR11MB4771.namprd11.prod.outlook.com>
 <YidgHT8CLWrmhbTW@lunn.ch>
 <20220308154345.l4mk2oab4u5ydn5r@soft-dev3-1.localhost>
 <YiecBKGhVui1Gtb/@lunn.ch>
 <20220308221404.bwhujvsdp253t4g3@soft-dev3-1.localhost>
 <YifoltDp4/Fs+9op@lunn.ch>
 <20220309132443.axyzcsc5kyb26su4@soft-dev3-1.localhost>
 <Yii/9RH67BEjNtLM@shell.armlinux.org.uk>
 <20220309195252.GB9663@hoboy.vegasvil.org>
In-Reply-To: <20220309195252.GB9663@hoboy.vegasvil.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bec42bcd-ab6c-4177-f608-08da0372e239
x-ms-traffictypediagnostic: DM4PR11MB5970:EE_
x-microsoft-antispam-prvs: <DM4PR11MB59703E6EF244F0BBC9BCCF68E70C9@DM4PR11MB5970.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Hvnc13VzwU/rqsrO+yOgOtOIENZoi2/u6vZislIqm1zzgip8rEDUx7FCkZBhNUK4vnmVivC3x5QBtrqU2OZKi2QWvis28/wlfZLHyOkZ1Sxs0/MzaNWS0mbVUm03V9nTmGWxyOXiL65+ZEFXzZzfevV9uXxMAVxbK8JouL0NR4E9QFBK+vDdODCfLRo/GZSvZMJyqPbVTYQYZZeew8jPDylma/j2HCt+GDj+y9lFOU5g2h2SN5VbLoo68QTnmF8uQilaM5vmXZICdyF+xlAdjy/UJg5b34DYpoJa1dQ3iWTk/eRVjy4+p4oKmbJyVMscjv/NZTUS8DLvGBOLQK/MH0lyB6yhMMDtnX9xYIZe1uPi4hvwiAyd2qvgEIhHdlQy9StNkSv+b4HeAmYkUIlKzWNsDTczyHf3cyHuLOp2AKKYb1sL6Tcs/UxaAKmwIWIPFTtmbUNUytyMDMkhzc+CWTe20mU8dzOoqxe/+q3R4u7Ycb+NJXirDyKgbn8Q+ANWOszItxAbHLW87eZm2PYqe9B2sTxRSrAK7KRJ81c7/srdAR9InjIG9fCDxrmy5Wh1Tm8OYpMnEBjTaKbM36lF50ytnckYB5VrvY/B2LThZcHXgxr20FRxEQ4Sa3JxladDzbBmmy2QVycNBi4dqxpI2Bxq+bI+X8Yb5f+6Q2pr58SmGwEfOK7IZ9y3NFuiw6Ptsr4CANL+F9Aw2KyJ+Ppv0+50I3dZdR4lakbPEhkv0I20e39pzQFaxKGXNf/IuGYt54vLyLdWgP38kRPZyHwQA7jQqMqANrTHGcxO0VhcTyQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB2913.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(86362001)(33656002)(38100700002)(38070700005)(122000001)(316002)(5660300002)(966005)(110136005)(54906003)(2906002)(8936002)(7416002)(4326008)(66946007)(66476007)(66556008)(66446008)(76116006)(64756008)(8676002)(52536014)(83380400001)(55016003)(107886003)(9686003)(508600001)(6506007)(7696005)(71200400001)(186003)(26005)(53546011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?uv0BsD4kXssgeyAIVYY1tQgN24XpS/GLRcCO9HZymUoo2iwKxFOnTXkC7Xm2?=
 =?us-ascii?Q?RTIfvsu8E53ILl38lskxFIfZ6AXHyF7kZbut7YQ4A4F68mFikVFfQTQTRwAX?=
 =?us-ascii?Q?rLRfb1C7tbj8eIYsbm3VgsL5W+gvfmhoHMjx67Z/E9eSNuVKbAxRisVb6SxK?=
 =?us-ascii?Q?LAKS8wzFPIowqbGdcIpFFyTQbCGFRwxogThIFPvUf/qLfn+oIznObnqKUT3M?=
 =?us-ascii?Q?HQv1VNZiP/zyLXtMYehgkGHJ7fDUgnnHp+pG32iMxh0PRRaaTJpak/VnVoYU?=
 =?us-ascii?Q?iNtphuW29Srl6s0vIeb9rDA3AixfHH5g6Tk8fY0J/C5NMRlZ1iZdQMdc4YNg?=
 =?us-ascii?Q?J0M+BT/subV5GlCbQs+36uQY61l4aWAsPJxu3IZJqvSDXHSWuGp9TgJpG+aA?=
 =?us-ascii?Q?4wx5zWFlkTjQvyz8uXVHMG0XcI2bJugSf64/T6uUpjzteKXu5wC6TUFyiapC?=
 =?us-ascii?Q?Be/tJ9wwzPja6DDd7CoRvhx/wupK6Y989ZFmrL/wN9mIArDBwgIsoh12PX/W?=
 =?us-ascii?Q?evXsWAY0iAN3eY0IJNYk+0rsZFR1cs46I5SX9rU7lE6oDtjiEC0i0vZH3jO7?=
 =?us-ascii?Q?Mt5kkmHcY65PzoTWsnUX9vgD3wE0cIHSx9+IiFrkvnQwfxRSk0SL+hydAcUE?=
 =?us-ascii?Q?9HXCoj/Cmt0pBWqkqJsLmveWObABDaRpTtwRV6HRMAXCDeMB3bbCespr0y2v?=
 =?us-ascii?Q?GB37plbQRwuwvxE/IxK9J/2Y2mrfQ76ewbA5VtmSjCIr9rNCAZBqoXzQ/f8B?=
 =?us-ascii?Q?gvlGA5oOpJgC6vz5K2vV3PSplLUxqndOnaCLBbz2cuxkzGRLX0GY0GfSSwSF?=
 =?us-ascii?Q?AqxqxH0MqWGKdjFSfSR72DQDAeb7ihrv7PeAafzYbC+8SwUaS8F6hvWZDkA7?=
 =?us-ascii?Q?yahkVVX6ydUP6fKmvX8tcyUQdeT6UQgyl472xK0GE9MsGIOb556sPOTBpSUU?=
 =?us-ascii?Q?R0Vyl8Fw+imwq/PbQAE1SrVLqv/rNPr3mC6QoEneSSySV2DocXKPdCTlg4GP?=
 =?us-ascii?Q?kZg8xKfeeV7BlsHtUHhNh8mk/JB9cjJsJqfOX29+2eo0sHnIyo+mfaZbiSvl?=
 =?us-ascii?Q?VBq5eGsVSUjaUSpAiO5XaqcbmkgyHioYaWEGX8V68V4xd31R6vr1tLvZFkvQ?=
 =?us-ascii?Q?QTUgn9PxTHnspj/J5B3mRvChUt1qA9RntKVXQMXdEi4DAH3rSCkcI84eEuWJ?=
 =?us-ascii?Q?ZaKbAHVenvd+OozS+oHRH2o/xNSX8Fp0jatV9AKxym2xxCSF5u9hzxKQNbHn?=
 =?us-ascii?Q?5hzQzBudBzTLOwv9m5GZDwTwVZCUJu7W5+3FiBuut1Bs7xj+PfBwZWPvc65J?=
 =?us-ascii?Q?GpWMSkKyw2yX4altpkkLDwCfZ8N5fSo4MSeaG5/PwHsp6ehHI9Ir7VlXLDjE?=
 =?us-ascii?Q?vkHYtrWdm4PeNEpgwr2V8IjlTmEu6OPs3fELxl1dJbfSqtKJXpLlHJg+69gO?=
 =?us-ascii?Q?HrWsveaHZl5N62HRIucr9dFBHgMXgUZ6usO7DuO8kXhhvHrj5Wx5SQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB2913.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bec42bcd-ab6c-4177-f608-08da0372e239
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2022 15:21:58.2325
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +ugtCJUQyqhDe4PshY6qoCtTPGUfdPdmJ5crGoV1CdimIQ2JDvQZpH1SL9DsbuWTh3G+i+WIWUkFReUSgzjUkmP2mVY4Xy3gNKHSKpqvPLY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5970
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Richard,

Not sure that it is good idea to reply on not-the-latest thread.

> -----Original Message-----
> From: Richard Cochran <richardcochran@gmail.com>
> Sent: Wednesday, March 9, 2022 2:53 PM
> To: Russell King (Oracle) <linux@armlinux.org.uk>
> Cc: Horatiu Vultur - M31836 <Horatiu.Vultur@microchip.com>; Andrew Lunn
> <andrew@lunn.ch>; Divya Koppera - I30481
> <Divya.Koppera@microchip.com>; netdev@vger.kernel.org;
> hkallweit1@gmail.com; davem@davemloft.net; kuba@kernel.org;
> robh+dt@kernel.org; devicetree@vger.kernel.org; linux-
> kernel@vger.kernel.org; UNGLinuxDriver
> <UNGLinuxDriver@microchip.com>; Madhuri Sripada - I34878
> <Madhuri.Sripada@microchip.com>; Manohar Puri - I30488
> <Manohar.Puri@microchip.com>
> Subject: Re: [PATCH net-next 2/3] dt-bindings: net: micrel: Configure lat=
ency
> values and timestamping check for LAN8814 phy
>=20
> EXTERNAL EMAIL: Do not click links or open attachments unless you know th=
e
> content is safe
>=20
> On Wed, Mar 09, 2022 at 02:55:49PM +0000, Russell King (Oracle) wrote:
>=20
> > I think we understand this, and compensating for the delay in the PHY
> > is quite reasonable, which surely will be a fixed amount irrespective
> > of the board.
>=20
> The PHY delays are not fixed.  They can be variable, even packet to packe=
t.
>=20
> https://www.researchgate.net/publication/260434179_Measurement_of_e
> gress_and_ingress_delays_of_PTP_clocks
>=20
> https://www.researchgate.net/publication/265731050_Experimental_verific
> ation_of_the_egress_and_ingress_latency_correction_in_PTP_clocks
>=20
> Some PHYs are well behaved.  Some are not.
>=20
> In any case, the linuxptp user space stack supports the standardized
> method of correcting a system's delay asymmetry.  IMO it makes no
> sense to even try to let kernel device drivers correct these delays.
> Driver authors will get it wrong, and indeed they have already tried
> and failed.  And when the magic numbers change from one kernel release
> to another, it only makes the end user's job harder, because they will
> have to update their scripts to correct the bogus numbers.
>=20

If you are referring to the delayAsymmetry of ptp4l, I think that is differ=
ent from this latency value.
delayAsymmetry of ptp4l says "The time difference in nanoseconds of the tra=
nsmit and receive  paths.=20
This value should be positive when the master-to-slave propagation time is =
longer and negative
when the slave-to-master time is longer. The default is 0 nanoseconds."
In my understanding, master-to-slave uses reference timestamp which is defi=
ned in IEEE specs.
   <egressTimestamp> =3D <egressProvidedTimestamp> + <egressLatency>
   <ingressTimestamp> =3D <ingressProvidedTimestamp> - <ingressLatency>

These latency is egreeLatency or ingressLatency to get accurate timestamp a=
t reference point from=20
timestamp of clock in MAC or PHY.
So, this latency should (hopefully) be not-much-change in the same board af=
ter manufactured.=20
But, value can be different from design to design and port to port if some =
path (PHY to RJ45) is longer than others.

This doesn't cover any latency from cable length and/or asymmetry which may=
 come from RJ45-to-RJ45.
But, delayAsymmetry may care cable type/length in application point of view=
.

Of cause, all values may be small enough to ignore though.
Do I miss something here?

Thanks.
Woojung
