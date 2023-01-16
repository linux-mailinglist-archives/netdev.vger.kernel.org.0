Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E93E66CDDC
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 18:44:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235046AbjAPRn6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 12:43:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235004AbjAPRnT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 12:43:19 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58C7653F94;
        Mon, 16 Jan 2023 09:22:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1673889729; x=1705425729;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HuKJfjdj/S6D8OS/qnivmTDojtcE9ZYSzGdJFuqHEVI=;
  b=keuMeIniwvQ32pj4xzjrSPXx6C8C7O4T2GjiWzPrShZN7OVmC01H0EDk
   +MLkTw2r8N3aRAOv3r7CC9wTjfEAACKOajFJxQC0AYzqA6xvfedfrzXML
   XAOlcrVj9ZKtWzcDvaIOp5prgAMyuFpl0XweqnGy+RAKhbWG1xCKEGNr/
   KzTDQXuH6bzgkh6o35uRt6Y0ezv3XkVyvFnQ8LYdmrBOlH3yhMcwiynt7
   eNz4qBBUXGElhGr8Df0k8joe3Nj4vWlVXOoczwhF7nzE0uorK5iKgxZnZ
   9v1xanWTTxKhC6hy9ATDfnDhGwwdB46JLG93CdRa5LxakYh+bBFweJ3Sd
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,221,1669100400"; 
   d="scan'208";a="132576520"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Jan 2023 10:22:07 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 16 Jan 2023 10:22:07 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 16 Jan 2023 10:22:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bNbR8TwAZ4jyX8ClmBTAMB8gyRZOI/tofZbVDwg6utma6b11HP3AawuV9IC7TK8JMK3Pk+TZaHHlynAOOu1zqSBw2PCbx6Pwn7BnF5YJhroUeXPkjgtw8oh962QR9Od7RuwZDGpufvlwXwgYaNscR+tF9K/yN80SFDPyHuIgJgEmpYLyAvMCjlvRg+a+L/DW5uAQX7ghP4idDgjAqhInhUxQnVAzKMhgTJ0MVGx4XUms5qFal1b2XvtAQ1CsQmayY18hogUrmPVJxFtyLdApFMZQDU8vjH4y94jltkqxSySFDNMaSKpziLGKr3RJSuBrB+yfmglJuhGB8HLQIIqICA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Thoamgvzrdc2IgH6ljpVu0tFYU5lYCQMQV8PSL63COk=;
 b=a3QrOgKHjL/sV2D7+gUVpoUkuyX7nqcOZTxwRmC398sMEzs9x8dATiS4gdSyWP9G4hYoVpcOXnJ/vfMNo6RmILNy1fby6Pj9GtsmCTmvQqFZO9cXSlNz62xGg4HnWuIREsGcKwtIoeVB8xAL/SGwM6EKn+Am8nGQLILRf0gVw6nCi/4Lgz/V8o++TpVP9md9kDoy5c1lprGQDT648M6arYbRe4fly/PmCyoD3l1xNpfaBgksDBvvlMvLj297Evw7VSiF/1gFI9LziDavXLFsW2GY9gSMHZMpZNm7jnHau2ygGdNZYmvrIzqnqqBkVbW1C6NfNTAL2H5H5kilsYwW4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Thoamgvzrdc2IgH6ljpVu0tFYU5lYCQMQV8PSL63COk=;
 b=LBzcj8EWhc1uo5uc2L7oBOtSpUO0w4vV12Cb7Iy0e/SWMqBB0PHCUkG1miJkw/hBdDAQY8Gr7TPmKMkWRlm3ajdLkD885GgDtTq9SU/RhBzxgRf9kIDEOR5RP/NBbw+3SQh7fyeK0ZjUzBAeKx801cfv7J4zgy1d8VaCWTtRvOU=
Received: from MWHPR11MB1693.namprd11.prod.outlook.com (2603:10b6:300:2b::21)
 by SJ0PR11MB4880.namprd11.prod.outlook.com (2603:10b6:a03:2af::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Mon, 16 Jan
 2023 17:22:05 +0000
Received: from MWHPR11MB1693.namprd11.prod.outlook.com
 ([fe80::3558:8159:5c04:f09c]) by MWHPR11MB1693.namprd11.prod.outlook.com
 ([fe80::3558:8159:5c04:f09c%4]) with mapi id 15.20.5986.023; Mon, 16 Jan 2023
 17:22:05 +0000
From:   <Jerry.Ray@microchip.com>
To:     <linux@armlinux.org.uk>
CC:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <olteanv@gmail.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <jbe@pengutronix.de>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next v6 6/6] dsa: lan9303: Migrate to PHYLINK
Thread-Topic: [PATCH net-next v6 6/6] dsa: lan9303: Migrate to PHYLINK
Thread-Index: AQHZJHAUgbmW0ofBykmmlKO+Ubpgs66arr+AgAamOBA=
Date:   Mon, 16 Jan 2023 17:22:05 +0000
Message-ID: <MWHPR11MB169301FF4ED0E0BB2305780AEFC19@MWHPR11MB1693.namprd11.prod.outlook.com>
References: <20230109211849.32530-1-jerry.ray@microchip.com>
 <20230109211849.32530-7-jerry.ray@microchip.com>
 <Y7/zlzcyTsF+z0cN@shell.armlinux.org.uk>
In-Reply-To: <Y7/zlzcyTsF+z0cN@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MWHPR11MB1693:EE_|SJ0PR11MB4880:EE_
x-ms-office365-filtering-correlation-id: 71916cf6-011c-41f9-d345-08daf7e63077
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5lFJfUDnTp+ckO6UhxLHdh9sVgFUuMfXNopDbAsqdXhSg4Ehv1XePaLhbZN2LeF4muJRvia6RY3266m2Kp6iRVB0wVdr9YAWbef9jzZM4wTAxIJGlxP6Cm9VhmRbhCRvt7aINM0Yhyad6lp7Cg3qVRKKMJsxXRwEk3zSLStNTh5hZqOgC7AkEeMZEB2Sei0rkrwl7FLFlBExhTUaI3z92PI7r9eLFOW0aBquYt/SLhksWFMXsri0F6Z9WOA9vv2bGpXABww8k8zQNhaac2iiZnxWfsgCkmJsyaCYNEjfb5ZHIuUCtgunLji3hUmYKbiboH4GfWdo2kDrS/SCTN4ptjsldJMOOcaKrdSCAF62LOZkxQ5+8O1AoPb5BPDtgx5FqO/0qDdKBA3YSeOtBcPMjtQeZebwkD1gCeqQcJausAcCHqsF1zkcN6gRci3lcajb4FiGmsTrPhCbWa3kROKhHIUsb98MwRqcQuiw+srAqvsIQQsAn6EWIy7B+Ddk4CyJa7fFlb8eqqxipH0GXKMcFbl5SCkgTt7IjL9nn1gvPUc6+mgzxm6INMgpZySP2ETiErIje5B8xiWAwCqECDvqhNIrHcpqEgEkYTxxlQjlBu95tKPoOGCiIDfkd96mgDaFTrIw60fCNpYj4yBBEMVVfOsf1gYtJhA/902QB6yKvm9fyj5f/odzMc/9VcVPtJ/hATkcaEldPXPVYldKlvbzZw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1693.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(39860400002)(366004)(376002)(136003)(451199015)(26005)(7416002)(5660300002)(86362001)(83380400001)(8936002)(52536014)(2906002)(66556008)(76116006)(66476007)(4326008)(478600001)(64756008)(66446008)(41300700001)(8676002)(54906003)(33656002)(71200400001)(7696005)(6916009)(38100700002)(122000001)(38070700005)(9686003)(186003)(66946007)(6506007)(316002)(55016003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/C2ZJd+7uzheOpNj4fxOBqYkb6HzXjtmy82s4m91w/X0svw0IR762fpkwi/R?=
 =?us-ascii?Q?o8TiRXrctRWIMFeL3Yl41Lvk/5sQILcusRaKem1rTghnihsgi8tqCilpxLu6?=
 =?us-ascii?Q?9zPekXY+b5zQsgsaPkSzcN9bOUOLSSj4DjXjbXd48lGLV00p/vAmbJsCKy5t?=
 =?us-ascii?Q?aQiC1FPyUSvSjkA7Bs4xQRpT1Z1IrXeTAimvNPjUurBYbqzRCoIVy8rYijGG?=
 =?us-ascii?Q?FMvkoWO39X63IoF+44diyS44hIsg4TuOwsF/2yXYJli9BCx9H66JN+qkRbBF?=
 =?us-ascii?Q?4xTkSNmI0rJwTDTPuMKmjeZmMivhEg/kKEPC05bo6+/hwmdluSyJPHULq1j0?=
 =?us-ascii?Q?Q9M4UCtKxjdj+bG8jOBPQItTEjwT6Z91jddPeTElfujpid1YJuX8YGirovsa?=
 =?us-ascii?Q?VYS7NelRLRx4+O32gabGdepR7rVU0B6948JMqRGwdY8hKR+JCnT4/S6L6sTj?=
 =?us-ascii?Q?M9oHeg8LSMBZg4CcrjThfttEK0Mu/fNLaCT+ImYI+slfwMRtr5lzcUeGMkJF?=
 =?us-ascii?Q?nxsXFFbvtMSF2ekVdiumKbiOt3wC4RjOkQUcGFcppP6RT+emi32w3KMjgASV?=
 =?us-ascii?Q?ihmIDwaJJkL9KmM4dk6GNpX4R0ca5sRxirKWir1AcG1bTp/lNdvyfjnkwgAg?=
 =?us-ascii?Q?INuZ6avK/ANIS2d9x0jQh8a6PwCw5a4M2JX2eWXmE0gVcG5ldcpcxXdl+sIM?=
 =?us-ascii?Q?znSben0AQv8YHrV2WtLjg9WB82Jd21mmS5rPP+qF8Qi+YNrRYMxc9ryQUfX5?=
 =?us-ascii?Q?f/KrfV/ifdUVbN6YC+Vg+3JyiIecGfGqj++DZQaiEgAYv2z04UYT/LtLMtQg?=
 =?us-ascii?Q?z3jSXUF8sMIpDnfU+j+G6TjDCcgHWGJ9b0cOFPWRsK2u0eh3wowKvXvTOntc?=
 =?us-ascii?Q?x7fWAWDjZI2oCgOzmeSme5CJ8Wpp3DxLjtCSUKQyDamroKUoba47pC/Vtx1P?=
 =?us-ascii?Q?fakkPcoQJkQKtve5nVsI2AjClfW5tsttoP2xoy7GLcfiBpBGx1fFRCR18bGu?=
 =?us-ascii?Q?kfeUaJw0+HBEzP0q3lEDSiN1xvrhdfzWPWubmbeFSX8fFJt3FqHjFKFv5oQZ?=
 =?us-ascii?Q?UjCXsQFzvbzd+aRcupmR9N3Vz2MZLVgFawjWg0qOxXc6nEfbt4vwjvqf6B0r?=
 =?us-ascii?Q?VPh4wGTVzpTeiz7+3JU0qHoyLW/ZFMO60Ru/dIBwYTtSEBftykq3BPd1Fk8L?=
 =?us-ascii?Q?zbGILN0W3yYeie3HzS9x7ipwFhQzWJ9tjP7icwz2slVAKAM7vX7kW2giWh0i?=
 =?us-ascii?Q?q1T9SM5+pJG8NadZa5sJ5HtomjcGElfmysAvccBC9JHlHPEV8sWbDBRYLUv6?=
 =?us-ascii?Q?UuLvKz+EqqqXntCJlGW0byThqIavcSqA66slaBev1sSabph9A3HJ/yXsz7Ip?=
 =?us-ascii?Q?FZ9BDwMNnvwbQrwovGsFiJCUUxznX6UwyVP/SP/n50xqDXt5Rg6qV1NNjkSO?=
 =?us-ascii?Q?lSfRt0WupS/LlIviQzLVIOv9ib/gt+k/EhaBfVmySppirzSs3D0xU7+fWcGw?=
 =?us-ascii?Q?ITQjdf0yInFK+b1+p97QyBD/78GDGVB6J3Mk6RKcGvTnhKPcqevcVn+co7x+?=
 =?us-ascii?Q?xW2ORIxLHynVLiBbliUHOtryMQNY9xhnGxpZpEQN?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1693.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71916cf6-011c-41f9-d345-08daf7e63077
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2023 17:22:05.3732
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FM40zN+nnYjl6DWlxxwf6PhraotVj2EsV+Gpml7jYEnkkOCGMErTXwoaPf+LwbMpvwKN+/hmTJcth4w11KaJJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4880
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +static void lan9303_phylink_get_caps(struct dsa_switch *ds, int port,
> > +                                  struct phylink_config *config)
> > +{
> > +     struct lan9303 *chip =3D ds->priv;
> > +
> > +     dev_dbg(chip->dev, "%s(%d) entered.", __func__, port);
> > +
> > +     config->mac_capabilities =3D MAC_10 | MAC_100 | MAC_ASYM_PAUSE |
> > +                                MAC_SYM_PAUSE;
>=20
> You indicate that pause modes are supported, but...
>=20
> > +static void lan9303_phylink_mac_link_up(struct dsa_switch *ds, int por=
t,
> > +                                     unsigned int mode,
> > +                                     phy_interface_t interface,
> > +                                     struct phy_device *phydev, int sp=
eed,
> > +                                     int duplex, bool tx_pause,
> > +                                     bool rx_pause)
> > +{
> > +     u32 ctl;
> > +
> > +     /* On this device, we are only interested in doing something here=
 if
> > +      * this is the xMII port. All other ports are 10/100 phys using M=
DIO
> > +      * to control there link settings.
> > +      */
> > +     if (port !=3D 0)
> > +             return;
> > +
> > +     ctl =3D lan9303_phy_read(ds, port, MII_BMCR);
> > +
> > +     ctl &=3D ~BMCR_ANENABLE;
> > +
> > +     if (speed =3D=3D SPEED_100)
> > +             ctl |=3D BMCR_SPEED100;
> > +     else if (speed =3D=3D SPEED_10)
> > +             ctl &=3D ~BMCR_SPEED100;
> > +     else
> > +             dev_err(ds->dev, "unsupported speed: %d\n", speed);
> > +
> > +     if (duplex =3D=3D DUPLEX_FULL)
> > +             ctl |=3D BMCR_FULLDPLX;
> > +     else
> > +             ctl &=3D ~BMCR_FULLDPLX;
> > +
> > +     lan9303_phy_write(ds, port, MII_BMCR, ctl);
>=20
> There is no code here to program the resolved pause modes. Is it handled
> internally within the switch? (Please add a comment to this effect
> either in get_caps or here.)
>=20
> Thanks.
>=20

As I look into this, the part does have control flags for advertising
Symmetric and Asymmetric pause toward the link partner. The default is set
by a configuration strap on power-up. I am having trouble mapping the rx an=
d
tx pause parameters into symmetric and asymmetric controls. Where can I fin=
d
the proper definitions and mappings?

  ctl &=3D ~( ADVERTISE_PAUSE_CAP | ADVERTISE_PAUSE_AYM);
  if(tx_pause)
    ctl |=3D ADVERTISE_PAUSE_CAP;
  if(rx_pause)
    ctl |=3D ADVERTISE_PAUSE_AYM;

If I can pause my transmissions (receive pause requests), then advertise
symmetric whether I ever sent pause requests or not.
If I can send pause requests (using flow control on my receive side), then =
make
sure asymmetric support is also advertised as rx_pause might have been clea=
r.
Not that if both rx and tx pause is supported, we can support either symmet=
ric
or asymmetric operating modes.

If I receive a pause request, it affects my transmit data flow. So one coul=
d
argue the rx_pause flag controls my ability to receive pause requests. I te=
nd
to overthink and almost always get these 50/50 propositions wrong.

Regards,
Jerry
