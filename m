Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99AC44D142E
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 11:05:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242126AbiCHKGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 05:06:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231400AbiCHKGN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 05:06:13 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C66E240919;
        Tue,  8 Mar 2022 02:05:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1646733914; x=1678269914;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/CuB+cj7wIAwDipqyjRs9f2gsUIjoXrtXDbpqEqnzYM=;
  b=0VwEs1RZEIx5ydMPJ3DbB4FFiSzCUJG0dXGESVk8UnyyXR5QQ6E24N2f
   T0A0tJ53pNxHFElShQY2emIOQjS4CwJSn4oWUj7IgerQcHK12Bh9DqIF9
   dOrYL8xZQaGg5fM7DUXlEmmsk2hvNJ7xQbURdcqWdajxThOOCgEj1dcyB
   F7304JjC/L5sHdqVU0146/UDKwGZPiQwAqt4U7TosBVNHVK2fbc92u85M
   PdgbbnMkJyWqc8yxy8DYCahZM9gC72d84/oT/nXYfEmgrkLsqvUBKSBZH
   CX8AKDkteTsJBhAfy9f0yV4qYImvheuJs4M3e9zr6o/rSkdP0ukg7gNbJ
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,164,1643698800"; 
   d="scan'208";a="151222886"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Mar 2022 03:05:13 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 8 Mar 2022 03:05:13 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Tue, 8 Mar 2022 03:05:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oY4a7uMXWnnHR+Qeo1HcN4kim6VNI79zsLOijPGPcAqU8JJW6hgY7r+bWVvm3F9hCOWMJKRRtLOcZYc+8KQoAw5mQlwMrYTDOkOoD4MJKRxkaH/pIsDsjZIZAmV9UVWmyR1n5/mg7d3c6+g2/5bO5UIuEbCD/s/7JWPDR35yPxapaFtmHyCostcM3lVeTL2B+1jzi0Nx68YkDXA4yDwyMoZD0LWqPPSr2PvvBpu+xZaOWrEH78exkYVBbcHGu6kI3f5n87iayKSNh2OVTvYc1LQC4LWi1NwiORnYFeAYHZ10F4LH7F0rVVvIIk8YizfC4670zJO/AKV7GQjKEixt0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DKjNlqSh67e8kagNslwztgfvYGoWUEI7L/CpdlyBe9s=;
 b=O3bFbRQcmQP0lTyGjU1DTej3p1uoRM9BBugMra9R2E/A+h9XGSuV9YwRWxdFBUPkQbTRJSda8as9r4GsN8oCIa7IGWgVQo9z+Lds11ZXrG8SSsP/WuzK0mgIYZONVIr2ZmHmFZ1bbpoXzglSxTUPfR910CvYUbpUgLaMGIL/9Q8YgYT5IJqmbvXjuQrsy3QwS/+MKqsNHFOcqovceiAWLWbX9Enxkmsl2x/szyE3nzWE68kmmcyrVJ/rSp9LbSoPE+/kowgxwYmSYPI47TJQL82/kPoOUuGQ5X3k33dFXevDKMMrO0hBCqQUxYwbqE4tQg3XQmRzX3eWAhoC4HGxrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DKjNlqSh67e8kagNslwztgfvYGoWUEI7L/CpdlyBe9s=;
 b=PMKOD+KTm6S2fjWOOP6zVGpN5QdR3sXJpWE9L+Ou8GVhzXGcT/VzDqfmX4CAcFLKlR9nxKImN8DozEkQcttyu7eXfzFgDspb/tuQnj1P++dvTX5RvqZntv8Vzpto0NmAzsyi9Q1xI7t1IMCsBAJedzqnRUuveD7Di9fH1y4DVIE=
Received: from CO1PR11MB4771.namprd11.prod.outlook.com (2603:10b6:303:9f::9)
 by BYAPR11MB3656.namprd11.prod.outlook.com (2603:10b6:a03:f8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Tue, 8 Mar
 2022 10:05:08 +0000
Received: from CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::7861:c716:b171:360]) by CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::7861:c716:b171:360%3]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 10:05:08 +0000
From:   <Divya.Koppera@microchip.com>
To:     <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, <hkallweit1@gmail.com>,
        <linux@armlinux.org.uk>, <davem@davemloft.net>, <kuba@kernel.org>,
        <robh+dt@kernel.org>, <devicetree@vger.kernel.org>,
        <richardcochran@gmail.com>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <Madhuri.Sripada@microchip.com>,
        <Manohar.Puri@microchip.com>
Subject: RE: [PATCH net-next 2/3] dt-bindings: net: micrel: Configure latency
 values and timestamping check for LAN8814 phy
Thread-Topic: [PATCH net-next 2/3] dt-bindings: net: micrel: Configure latency
 values and timestamping check for LAN8814 phy
Thread-Index: AQHYL6tdGiDfF8muKUy6jpI4YK/Ta6yvLZmAgAQXZ7CAAKSZAIABWZAA
Date:   Tue, 8 Mar 2022 10:05:08 +0000
Message-ID: <CO1PR11MB4771F7C1819E033EC613E262E2099@CO1PR11MB4771.namprd11.prod.outlook.com>
References: <20220304093418.31645-1-Divya.Koppera@microchip.com>
 <20220304093418.31645-3-Divya.Koppera@microchip.com>
 <YiILJ3tXs9Sba42B@lunn.ch>
 <CO1PR11MB4771237FE3F53EBE43B614F6E2089@CO1PR11MB4771.namprd11.prod.outlook.com>
 <YiYD2kAFq5EZhU+q@lunn.ch>
In-Reply-To: <YiYD2kAFq5EZhU+q@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 125cbc08-396a-4182-06f1-08da00eb2014
x-ms-traffictypediagnostic: BYAPR11MB3656:EE_
x-microsoft-antispam-prvs: <BYAPR11MB36566F5B8B7C1E62EEB9C823E2099@BYAPR11MB3656.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GcVBt614fXuK3E3Hlkr6y5xNhhSNygM0+svdIbJ3kYTxtAcOXgvFmLhYgrkPGU4ymF6jK2IAWL0MQ7tiznvTM03bm0mTVzSQQwKZ372bOkqBjV7lVS0ELAcyJBfYhIpepH9VkrwIN0+aQitoAQzDmJFi6D/xcydpwJxW590+MywdmFk1UQNe3z0YIq/CgIHK9i3kvPALY1LrdeitDotP8TuqjwL56ajJ8QlAcdcD14JvDx1/wl8/DBrNGTO0CkEyGDIUbfWuAY1WdAzkiFpRja0j/gsRruqJk8J4b0ic0l8C8HccsSXg89SW5PwgDGYThva9UQw8qqwlzrlI9fbaQcfvLCiOu7zLxQ/Ms51SyvGRtdz6J5zeYLiQde4HJwk76hCHB96o3UjOFuwuFcMl9YxLj461XBCjzLQAa+fiFsC/gBf0dikdAHBQ4lzY8yTxEFifhP6Rulj1n1iXwfZYz1uNkz7i0cmJjM/Y4dyc0nrzbxBdBqRaxY+A3A4k3pL8lLQ+JhJOI0+F+UYyvq5zfBbI8dCCpd+yScqrE3ytcHCoTgnfDHANGS9rKoB7Eh8B+OOvVta/LXWEEwKLoMVhRdfnTxdlNV05BrV+1j0Zh07drGGC5Y7SpufsYfr+5KgMaswyUXTAP2fERzYPGBHd52cgroXjXl1yoDkMARn2VLVRfosGiz+YoiGr4ixZUrcQeWT1ptlh3dg1HeLZVWV/3Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4771.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(7696005)(38070700005)(6916009)(54906003)(66556008)(76116006)(66946007)(26005)(186003)(122000001)(6506007)(316002)(9686003)(53546011)(71200400001)(8936002)(52536014)(33656002)(38100700002)(83380400001)(86362001)(55016003)(7416002)(4326008)(8676002)(107886003)(64756008)(66446008)(2906002)(66476007)(5660300002)(508600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?nCh9TnrvSRvT4ZOWZlsNEaLCHiL5fntzDk4517p9rvL6E1sxa437oopWMUJo?=
 =?us-ascii?Q?dp0gDkfKl0lN4JbtOoDc0GyIptNHlsJVcTeQ7/F5rlPnRnRABXyNynycLsGk?=
 =?us-ascii?Q?ERQwPZ+wlnOuDYpsEM492Vu1YC7ftdXj5KStzhpvg4PZ3NAKjPZ4cY4IELdp?=
 =?us-ascii?Q?dIBVxgaUEL7+yjdlUbcusg9uypnCpj+kW+TiZFEefbWF3xJTN6PA9trwVkop?=
 =?us-ascii?Q?XR88m3TcLefNiAwRdzKThd2h39omgDkNvhe/e4x9gAJ965Ly4oMnz7VOMxan?=
 =?us-ascii?Q?LZYTb2WxxM/R4DUZUj9l4hEFUUVLomnGjdDEGhwIuBbEd9qt94YmVSkfa/XA?=
 =?us-ascii?Q?J1uhkEGUei+GyUxcqYxXnrnWYvkLnY43RPsOSvYIJ4gPVBkn0CeVTB55wZ6Y?=
 =?us-ascii?Q?zcL1/0bvmb+j5AazLmCCyKiToRL0kAgmeje1g0tHKWt4zn8YVuq70gsRqmQT?=
 =?us-ascii?Q?5Dmu4quEDGdF3Xt2ZIQca85ve58Is/Tp/M8FKhi6KO5MyHsEnACz5IkrGUuQ?=
 =?us-ascii?Q?3qUPLCbqDmq1FWWfAZQt2JFCsF10BVDd51Bqf1li15h7bJvNSVioNDWzQYcP?=
 =?us-ascii?Q?HvIYezysYMBb1bGAOeryvlMTF2xxttbL3Gl7jmbXTNGb5zmM5caMowYi1trF?=
 =?us-ascii?Q?SfjOtWIJbPvRnzUPMtu/2pANr4yBeQ9u7iA4J/OLh2+VICi8WORoCR2S8pCF?=
 =?us-ascii?Q?a8Qnm4xdxH9h0f61SYlvkW+eoTvx0Vxki23qZ9vnbAtEiZKrnhu0yFBfZ0lj?=
 =?us-ascii?Q?0B0MapTFF895mYHeaYvVEAhA9ehaZHO3VI8A+HDz9Lyx2q0fWxKevFtKXOcb?=
 =?us-ascii?Q?YyhVsxhsbwrjzmSL8HYxCg9YJWh7hMsP/lO+VGzpXpcxuwfOYCUHgGOiCvdP?=
 =?us-ascii?Q?JwwOICfd4wK3lZ5z7DfSGGeXQaPghwXha1121Y5JUDuEizgkLZALMmx2id3l?=
 =?us-ascii?Q?jwMSq0ShZJa46UNMuKFzRGGLd2cZa7IfecEIctyzX24RTrd5yZ87AsY/q78X?=
 =?us-ascii?Q?i2J2IBCFxSa3tzPh/xs6mECRGbJw7sPZHV/qcw7VPVOoJN3PSHNYo1Sfrqn6?=
 =?us-ascii?Q?E8HGeR1fNWrNLqZm48ul5v7EYLDO47wANiQR2yqT34uTDLy2ItT1JPOIELxS?=
 =?us-ascii?Q?d4PPwUS7VFUUy2Xz9yLyxW+9L+w59ZQ/H9FvFwfIBQmjwjJgCSxKTNloh9hE?=
 =?us-ascii?Q?lgY2a5sFvT1ZSOmfFgLymPOjCkkokYhXfXQMDGm1NiAcGcaeJFY3E1IVim+h?=
 =?us-ascii?Q?EeOCE5C4ZokHpq+7rQbTMrkYJrKZywmn9FQshkrK+9gxL5cjIQPFNN4I2Aqs?=
 =?us-ascii?Q?AvSf3LuLLOqRAivKcXpd1RgWDYHcfWx17YaIUKC3YcSuCHyJ44VYr/+tPus4?=
 =?us-ascii?Q?MQ6RXqXXN6+lqKKOxK22VhmcohnHzz4EIl8tv4LrlTbhEjlXZGTiaq670Uda?=
 =?us-ascii?Q?zO1Ho5VeU3bQpYDxB2Nk9NXJ16LF50ziu2RM2iEW96PXtKPI/XF1c+/6IIBk?=
 =?us-ascii?Q?TX5a+83zaEC5ReK9wtlFzUTFr0qHhmE3/mgkDdmmZebHjyMbgws36Dw8m/20?=
 =?us-ascii?Q?OewwhBh64icSTNZV5gh1Y5/A+3rg9GsT4ie/3H3jjTMVLkIrW1PYWICfopfm?=
 =?us-ascii?Q?znPNoSujs4bYvj/rQeWEtB8tLypdnNCajMvGHJ8ulX84OAf2n5ZVSbrk2yc2?=
 =?us-ascii?Q?LJptQw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4771.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 125cbc08-396a-4182-06f1-08da00eb2014
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2022 10:05:08.0438
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vfM6qDnLKtgjbGvxxqMK3/OjncK6nPAaCBSfL0KlE3pz1k11Ntnb69tPpWqPJY2K7LbU5NvhGDTgihVY6K7nPtAeE7xcJzb4icgkGw8MrP0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3656
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
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
> Sent: Monday, March 7, 2022 6:39 PM
> To: Divya Koppera - I30481 <Divya.Koppera@microchip.com>
> Cc: netdev@vger.kernel.org; hkallweit1@gmail.com; linux@armlinux.org.uk;
> davem@davemloft.net; kuba@kernel.org; robh+dt@kernel.org;
> devicetree@vger.kernel.org; richardcochran@gmail.com; linux-
> kernel@vger.kernel.org; UNGLinuxDriver <UNGLinuxDriver@microchip.com>;
> Madhuri Sripada - I34878 <Madhuri.Sripada@microchip.com>; Manohar Puri -
> I30488 <Manohar.Puri@microchip.com>
> Subject: Re: [PATCH net-next 2/3] dt-bindings: net: micrel: Configure lat=
ency
> values and timestamping check for LAN8814 phy
>=20
> EXTERNAL EMAIL: Do not click links or open attachments unless you know th=
e
> content is safe
>=20
> > > > +
> > > > + - lan8814,ignore-ts: If present the PHY will not support timestam=
ping.
> > > > +
> > > > +     This option acts as check whether Timestamping is supported b=
y
> > > > +     hardware or not. LAN8814 phy support hardware tmestamping.
> > >
> > > Does this mean the hardware itself cannot tell you it is missing the
> > > needed hardware? What happens when you forget to add this flag? Does
> > > the driver timeout waiting for hardware which does not exists?
> > >
> >
> > If forgot to add this flag, driver will try to register ptp_clock that
> > needs access to clock related registers, which in turn fails if those r=
egisters
> doesn't exists.
>=20
> Thanks for the reply, but you did not answer my question:
>=20
>   Does this mean the hardware itself cannot tell you it is missing the
>   needed hardware?
>=20
> Don't you have different IDs in register 2 and 3 for those devices with c=
lock
> register and those without?
>=20

The purpose of this option is, if both PHY and MAC supports timestamping th=
en always timestamping is done in PHY.
If timestamping need to be done in MAC we need a way to stop PHY timestampi=
ng. If this flag is used then timestamping is taken care by MAC.

> > > > + - lan8814,latency_rx_10: Configures Latency value of phy in
> > > > + ingress at 10
> > > Mbps.
> > > > +
> > > > + - lan8814,latency_tx_10: Configures Latency value of phy in
> > > > + egress at 10
> > > Mbps.
> > > > +
> > > > + - lan8814,latency_rx_100: Configures Latency value of phy in
> > > > + ingress at 100
> > > Mbps.
> > > > +
> > > > + - lan8814,latency_tx_100: Configures Latency value of phy in
> > > > + egress at 100
> > > Mbps.
> > > > +
> > > > + - lan8814,latency_rx_1000: Configures Latency value of phy in
> > > > + ingress at
> > > 1000 Mbps.
> > > > +
> > > > + - lan8814,latency_tx_1000: Configures Latency value of phy in
> > > > + egress at
> > > 1000 Mbps.
> > >
> > > Why does this need to be configured, rather than hard coded? Why
> > > would the latency for a given speed change? I would of thought
> > > though you would take the average length of a PTP packet and divide i=
s by
> the link speed.
> > >
> >
> > This latency values could be different for different phy's. So hardcodi=
ng will
> not work here.
>=20
> But you do actually have hard coded defaults. Those odd hex values i poin=
ted
> out.
>=20
> By different PHYs do you mean different PHY versions? So you can look at
> register 2 and 3, determine what PHY it is, and so from that what default=
s
> should be used? Or do you mean different boards with the same PHY?
>=20
> In general, the less tunables you have, the better. If the driver can fig=
ure it out,
> it is better to not have DT properties. The PHY will then also work with =
ACPI
> and USB etc, where there is no DT. Implementing the user space API Richar=
d
> pointed out will also allow your PHY to work with none DP systems.
>=20

Sorry I answered wrong. Latency values vary depending on the position of PH=
Y in board.=20
We have used this PHY in different hardware's, where latency values differs=
 based on PHY positioning.=20
So we used latency option in DTS file.
If you have other ideas or I'm wrong please let me know?

> > Yes in our case latency values depends on port speed. It is delay
> > between network medium and PTP timestamp point.
>=20
> What are the units. You generally have the units in the property name. So=
 e.g.
> lan8814,latency_tx_1000_ns. If need be, the driver then converts to whate=
ver
> value you place into the register.
>=20
> If you do keep them, please make it clear that these values are optional,=
 and
> state what value will be used when the property is not present.
>=20

Yes units are Nanoseconds.

>         Andrew
