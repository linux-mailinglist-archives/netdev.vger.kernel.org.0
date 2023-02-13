Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2960694CA2
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 17:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbjBMQ0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 11:26:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229965AbjBMQ0X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 11:26:23 -0500
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2076.outbound.protection.outlook.com [40.107.104.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38E1A1DBB5;
        Mon, 13 Feb 2023 08:25:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DJnXhj8BSxSRS4u6J7RZnFbe4Ib/FzI0DFcxUwAhI4dwfjdJiBfDApEML2G4rYmMEhnNAPs8INQo4GWPiOruW7zt/4Ty1GZcb4N0wpBoidIzmwtMkfq0AdRHs8/FlUQuE0zkeTPZjnlMLzbWUgm2O24P/Q9cUEUJPS76rcVLK0gmjc2G6/2ZvoThuENa6s38X3OVzAFFz8jaPyWDaCZEwAhnBIA7Etnh5btM2mW22hvj0rVj9NxyVWbngQrIO9iesLKktntjozY3ZTOfCgTsTpJBzg+2gcg8/Uqk4nAT9bfcaBoTfLIUynVKNxF4z4+yb/K7MPzBfEgOMaWKLyjxnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tH+viuJg5E1udMCRZsgfOeXdA+WcmAvOoIwex8tpkWQ=;
 b=oGLmQwhG9FQ5GpYzQuhx/jzKWHOJzX770HkHRoBXRLagN/M509NPY9ai8RUZwKduifNnHtuL3q62e7HS+YpAGm+k82P3p6tKx/sD0IaWc6vJhVihXjVhDwJo/CrQrvRB2BcKYqnawmmm6s/SXc6OUD/R3vYS6bC7M281d4B7IwH5GyFFp2TG8KYKV4k68YTkgA3wFRWBshgH2yr6RuUNhZGynywVaI4LsVnJ5GbuzbpVoi3KGJOo4bvOfc7eIECiklcb2gGvWPDy+yTYKYVAPDG0NJRy/9eq7pFHK8kC3M7r0jbced9s5VZpUHjCXbAC1ArOEHwgGVB1afKcVHhZbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tH+viuJg5E1udMCRZsgfOeXdA+WcmAvOoIwex8tpkWQ=;
 b=fRBGgD/ZaQDqE9j5knm0Bqf4UI3ex8xQqTQDP4UYExeUqp3GGv8L0PVdgJhrblSRiJiKQQ+/Z+vN0oLeIsNx05bzsy8M84M9vUDwYBM+k/3GdMNGoyBzwx13Wm2io+i/cF36CiWz3j0uSnMcIh6Td0VSOo2B66AOB5HqqqKzs9o=
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com (2603:10a6:20b:43a::10)
 by DBAPR04MB7431.eurprd04.prod.outlook.com (2603:10a6:10:1a1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Mon, 13 Feb
 2023 16:25:44 +0000
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::f8fe:ab7c:ef5d:9189]) by AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::f8fe:ab7c:ef5d:9189%9]) with mapi id 15.20.6086.024; Mon, 13 Feb 2023
 16:25:44 +0000
From:   Neeraj sanjay kale <neeraj.sanjaykale@nxp.com>
To:     =?iso-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "marcel@holtmann.org" <marcel@holtmann.org>,
        "johan.hedberg@gmail.com" <johan.hedberg@gmail.com>,
        "luiz.dentz@gmail.com" <luiz.dentz@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        linux-serial <linux-serial@vger.kernel.org>,
        Amitkumar Karwar <amitkumar.karwar@nxp.com>,
        Rohit Fule <rohit.fule@nxp.com>,
        Sherry Sun <sherry.sun@nxp.com>
Subject: Re: [PATCH v1 3/3] Bluetooth: NXP: Add protocol support for NXP
 Bluetooth chipsets
Thread-Topic: [PATCH v1 3/3] Bluetooth: NXP: Add protocol support for NXP
 Bluetooth chipsets
Thread-Index: AQHZP8fSwC80CTkixkyeQycS/pGl8w==
Date:   Mon, 13 Feb 2023 16:25:44 +0000
Message-ID: <AM9PR04MB8603E350AC2E06CB788909C0E7DD9@AM9PR04MB8603.eurprd04.prod.outlook.com>
References: <20230124174714.2775680-1-neeraj.sanjaykale@nxp.com>
 <20230124174714.2775680-4-neeraj.sanjaykale@nxp.com>
 <bd10dd58-35ff-e0e2-5ac4-97df1f6a30a8@linux.intel.com>
In-Reply-To: <bd10dd58-35ff-e0e2-5ac4-97df1f6a30a8@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM9PR04MB8603:EE_|DBAPR04MB7431:EE_
x-ms-office365-filtering-correlation-id: d7e5fc8e-8808-49d8-c06d-08db0ddef4ce
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UklabDWW2rggjoa+dJb9d2chbw6O9J44Gro3mS0NU5aJKiOusaseQN++cbaSiiuoilQPTBkf0Fm9AnjPV+a2hztd6iaXnLMDT5Q7oq+K9QdhDsV2r4W8HE+Pmz/0JsGrUr+hjIE0NGel0LMfLQhikGjdE0aU6nj/c8TH1weGZa2PzsebLUUm0Mo+0BoT6XnvQ9iALhf0UbgdX40Kt/mUc5t1IITn82/dklHX8i7VIV8heMCxnxJHmcavVQwIC7yqNFFGemPncGWkN1M3aeaYmdfvY2BV+EgIjH4AMyUnQyDbKdoPmtLAAdEPwpg1qJ3XqekgH3DNN/PtKcTOp92QRdMk/IqDH5awx6EWHjb1f3CjlKs7bKdjIv77OjiggP44LEl9hMSI/+gRg6/n+1TAZ1B2UiEdGFyKU8b6ss3CjENPickL09o2dQnGh74oFAzsQzatiyJL2XYCrC2RmZCKmpmfJtdvxVvtTLJVTZwGlrleE7NqVI/poYIcID4dRekF6drHEHLWLlcDFhIhwtqLojqZYh1lRRY2FN4+z4XZfVYMeTb+wHErwxHnfKNi/sKk+6BfMUJ3N1t6tyE2M/URbvGvMYum7QaUDiVYh6ustm78KwLtTMpwNbSG1JuJt9wQZelbWAnJ2QBn1xLcVxeGhujwUnKefYX02IEF0yvGJiTtdTMwc1dG9t8+ym/QMx6+BvuCTMPG0+kMyMjNIRtGGA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8603.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(39860400002)(346002)(366004)(376002)(451199018)(66899018)(33656002)(66946007)(8676002)(4326008)(76116006)(71200400001)(54906003)(316002)(86362001)(26005)(83380400001)(9686003)(6506007)(186003)(53546011)(55236004)(38070700005)(55016003)(38100700002)(122000001)(66574015)(41300700001)(7416002)(6916009)(7696005)(478600001)(66556008)(30864003)(2906002)(66476007)(64756008)(66446008)(8936002)(52536014)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?TbOjkZpX+NT2SbDdTGaotWNRess6ZPdZ1TXL6PHWFXO6mGgS5HQd6KHRPL?=
 =?iso-8859-1?Q?vVNN0RP7OjZWR329m/hphHADjhw7BZCMD4qYXaaD6IX9jLIP0QqfHZDDJ/?=
 =?iso-8859-1?Q?uezorERLNu5uZWKjIB6AMPM2DqnIeCoJlR51MgVD5gC1URkbuMRoB7qRLb?=
 =?iso-8859-1?Q?YDm3MV7W9V25yL92vp75opXVTBUX4GTqWgDt0z0LTS7Rl1E0MzVTOSX2eJ?=
 =?iso-8859-1?Q?2IgG08V1CXLPvg24tGy2WNCnklrDPdnZtl1mnOP4IHfi9eLucxcm/fhf0q?=
 =?iso-8859-1?Q?U6rdrt+3ErRBIVz9wLF8ccWuOlm3FC7ulwI3lGY1UyigpJ9IPBqIoD5KsC?=
 =?iso-8859-1?Q?NJaMcH5RFzUvxhsLKTUreHHHxQq+K0jKyQ16WK+EGAU2cKt1pRONYEv/SY?=
 =?iso-8859-1?Q?N1QnNGGtzhmO7+5YO77FHtQSa6sBj5hKZ0yfCXF4lxflCTNk9RhVARNagu?=
 =?iso-8859-1?Q?+yX5FacueW14dHhz9T3ZBEiZkqAFJFhTGvgEyr4s1CtmLyfkPKKtlqxuYA?=
 =?iso-8859-1?Q?Epno7OoLaVZOU4r9OYuRWnHdClQUn5ZreAdAOfQifMTHisSABuIdlIgoSF?=
 =?iso-8859-1?Q?bcb74hg0dhu+Ytr4IdYXzKER730FVHMA0QxE9DlySjtssk8dRnY/qrfwu9?=
 =?iso-8859-1?Q?MwRx1jhXVSrfT001P+KeRiEphNTSyg9xotG6DMP2CJgdgH1TwnnRmpfPo3?=
 =?iso-8859-1?Q?uDUeMdxEG5lKBhN6l3EZfEFftnQ+jI8FdIl9CRquUmYhrE/ThaAbTSphJj?=
 =?iso-8859-1?Q?UoRfEDpet1MHHpeN9MU9NWBhDvzSZs5Fb2vA2ntW9NNbRWsSxbBLdr7qnO?=
 =?iso-8859-1?Q?KtwdRae0bbSPWXS7DbahfQVgyk9PcMYztkoQTdwE0XaAv4452gvhaabO4+?=
 =?iso-8859-1?Q?17ZmvYGUyEZv6lreLUIhrpj82EcLJ2P9OYUW5XNywOh7T8CtMu33hgNxF3?=
 =?iso-8859-1?Q?IJvTW+/WJwjrpPRr5oK/mIVdoGFvB+aji0l+I7V24ga2eJN4v1n4BhlJ5M?=
 =?iso-8859-1?Q?jCduhg3YmxHx+LFSmbpIqMeU1Iae2Myp0MSPDuuCvGsvmK1dQKlmFe3zYI?=
 =?iso-8859-1?Q?j+nh538w0/ReQKpaC4lNHqtk4tupn9FjR1YIRGmhTgw1w1Mp5rOHBGOi+A?=
 =?iso-8859-1?Q?ftZiRwKaMVLDtiXrqmEhgXwIR0c9PNRj9OquLYeg/ERlSL8UxCy5KK6Ol6?=
 =?iso-8859-1?Q?0MYRlSAj9noz4JxJ22lzAaFKKYttSxc60Vqf4jSS/97o426Dy2UzN8OgmW?=
 =?iso-8859-1?Q?qfsLV3WR3b31UcqPlHLr6k2biR3mPea1KU8WpLtB0H07kZHljfkOjj68Mu?=
 =?iso-8859-1?Q?5sxEQuEjgCSeMfNNTL/TDXhYknN1rTCn4xLUeXCsANd/bPEaNGftqYWBCC?=
 =?iso-8859-1?Q?iFM8IYS2X91v63fbu5Qv5rrUtypSPnUl5pxmiypH3UuMrTXx/PIYw4hs+M?=
 =?iso-8859-1?Q?2fs3wKGDXCA5rONB6yr2MyiCMHxwHToyPb9RCuhsOlceHSuuW2wIomNjAm?=
 =?iso-8859-1?Q?ZOMpHZCVv5+Z6Kv4DA0RzKAxlYx8nVxAWnZLjp1GZuNHh0CErfLUjDXRix?=
 =?iso-8859-1?Q?jw+iXFIe/y4Vgvg/H2KUHio4HXOdd6GvhUpU7wH3cWBKFrMpDJkEboLOdg?=
 =?iso-8859-1?Q?T1oowAyE1HFNFeR7VuoyYC+sJx1m1UgL2rZGDCE336FGGrpkZUfg1ZLw?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8603.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7e5fc8e-8808-49d8-c06d-08db0ddef4ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Feb 2023 16:25:44.3835
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BEFu8Bch9SyvQIC3mhYR5xHAXVVA6LIdi0e8s2Uc/ZPjHnQ3+OfvJhD2j0u4+/DBZmM3Y64127azsI2cqSOYJ2c3CR8amhonnO2XSQ99D5I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7431
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ilpo,

Thank you for your review comments and sorry for the delay in replying to s=
ome of your queries.

> From: Ilpo J=E4rvinen <ilpo.jarvinen@linux.intel.com>
> Sent: Wednesday, January 25, 2023 4:53 PM
> To: Neeraj sanjay kale <neeraj.sanjaykale@nxp.com>
> Cc: davem@davemloft.net; edumazet@google.com; kuba@kernel.org;
> pabeni@redhat.com; robh+dt@kernel.org;
> krzysztof.kozlowski+dt@linaro.org; marcel@holtmann.org;
> johan.hedberg@gmail.com; luiz.dentz@gmail.com; Greg Kroah-Hartman
> <gregkh@linuxfoundation.org>; Jiri Slaby <jirislaby@kernel.org>; Netdev
> <netdev@vger.kernel.org>; devicetree@vger.kernel.org; LKML <linux-
> kernel@vger.kernel.org>; linux-bluetooth@vger.kernel.org; linux-serial
> <linux-serial@vger.kernel.org>; Amitkumar Karwar
> <amitkumar.karwar@nxp.com>; Rohit Fule <rohit.fule@nxp.com>; Sherry
> Sun <sherry.sun@nxp.com>
> Subject: Re: [PATCH v1 3/3] Bluetooth: NXP: Add protocol support for
> NXP Bluetooth chipsets
>=20
> > This adds a driver based on serdev driver for the NXP BT serial
> > protocol based on running H:4, which can enable the built-in
> > Bluetooth device inside a generic NXP BT chip.
> >
> > This driver has Power Save feature that will put the chip into
> > sleep state whenever there is no activity for 2000ms, and will
> > be woken up when any activity is to be initiated.
> >
> > This driver enables the power save feature by default by sending
> > the vendor specific commands to the chip during setup.
> >
> > During setup, the driver is capable of reading the bootloader
> > signature unique to every chip, and downloading corresponding
> > FW file defined in a user-space config file. The firmware file
> > name can be defined in DTS file as well, in which case the
> > user-space config file will be ignored.
> >
> > Signed-off-by: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
> > ---
> >  MAINTAINERS                |    7 +
> >  drivers/bluetooth/Kconfig  |   11 +
> >  drivers/bluetooth/Makefile |    1 +
> >  drivers/bluetooth/btnxp.c  | 1337
> ++++++++++++++++++++++++++++++++++++
> >  drivers/bluetooth/btnxp.h  |  230 +++++++
> >  5 files changed, 1586 insertions(+)
> >  create mode 100644 drivers/bluetooth/btnxp.c
> >  create mode 100644 drivers/bluetooth/btnxp.h
> >
> > +static int ps_init_work(struct hci_dev *hdev)
> > +{
> > +     struct ps_data *psdata =3D kzalloc(sizeof(*psdata), GFP_KERNEL);
> > +     struct btnxpuart_dev *nxpdev =3D hci_get_drvdata(hdev);
> > +
> > +     if (!psdata) {
> > +             BT_ERR("Can't allocate control structure for Power Save f=
eature");
> > +             return -ENOMEM;
> > +     }
> > +     nxpdev->psdata =3D psdata;
> > +
> > +     memset(psdata, 0, sizeof(*psdata));
>=20
> Why memset to zero kzalloc'ed mem?
I have removed all memset calls after kzalloc.
>=20



> > +static int send_ps_cmd(struct hci_dev *hdev, void *data)
> > +{
> > +     struct btnxpuart_dev *nxpdev =3D hci_get_drvdata(hdev);
> > +     struct ps_data *psdata =3D nxpdev->psdata;
> > +     u8 pcmd;
> > +     struct sk_buff *skb;
> > +     u8 *status;
> > +
> > +     if (psdata->ps_mode =3D=3D  PS_MODE_ENABLE)
> > +             pcmd =3D BT_PS_ENABLE;
> > +     else
> > +             pcmd =3D BT_PS_DISABLE;
> > +
> > +     psdata->driver_sent_cmd =3D true; /* set flag to prevent re-sendi=
ng
> command in nxp_enqueue */
> > +     skb =3D __hci_cmd_sync(hdev, HCI_NXP_AUTO_SLEEP_MODE, 1, &pcmd,
> HCI_CMD_TIMEOUT);
> > +     psdata->driver_sent_cmd =3D false;
>=20
> A helper for these 3 lines?
Added a new function where ever setting psdata->driver_sent_cmd and __hci_c=
md_sync() is needed.



>=20
> Do you need to free the skb?
Yes. Freed skb's where ever it needs to be freed in v2 and v3 patches.



> > +     for (i =3D 0; i < map_table_size; i++) {
>=20
> Isn't this just ARRAY_SIZE(chip_id_name_table)? use it directly here,
> no need for the extra variable?
>=20
> > +             if (!strcmp(chip_id_name_table[i].chip_name, name_str))
> > +                     return chip_id_name_table[i].chip_id;
> > +     }
> > +
> > +     return 0;  /* invalid name_str */
>=20
> Put such comment preferrably to function's comment if you want to note
> things like this or create a properly named define for it.
I have slightly changed the way FW Download behaves, and removed this funct=
ion.



> strncpy(fw_mod_params[param_index].fw_name,
> > +                                                     value, MAX_FW_FIL=
E_NAME_LEN);
> > +                                     } else if (!strcmp(label, OPER_SP=
EED_TAG)) {
> > +                                             ret =3D kstrtouint(value,=
 10,
> > +                                             &fw_mod_params[param_inde=
x].oper_speed);
> > +                                     } else if (!strcmp(label, FW_DL_P=
RI_BAUDRATE_TAG))
> {
> > +                                             ret =3D kstrtouint(value,=
 10,
> > +
> &fw_mod_params[param_index].fw_dnld_pri_baudrate);
> > +                                     } else if (!strcmp(label, FW_DL_S=
EC_BAUDRATE_TAG))
> {
> > +                                             ret =3D kstrtouint(value,=
 10,
> > +
> &fw_mod_params[param_index].fw_dnld_sec_baudrate);
> > +                                     } else if (!strcmp(label, FW_INIT=
_BAUDRATE)) {
> > +                                             ret =3D kstrtouint(value,=
 10,
> > +
> &fw_mod_params[param_index].fw_init_baudrate);
> > +                                     } else {
> > +                                             BT_ERR("Unknown tag: %s",=
 label);
> > +                                             ret =3D -1;
> > +                                             goto err;
> > +                                     }
>=20
> Your indent is way too deep here, refactor the line processing into
> another function to make it readable?
>=20
> Wouldn't something like sscanf() make it a bit simpler?

Created a new function to handle updating this data and used sscanf().



> > +             } else {
> > +                     *dptr =3D sptr[i];
> > +                     dptr++;
>=20
> What prevents dptr becoming larger than the size allocated for line?
Used array index method instead of dptr pointer to fill the line. Added che=
ck for index.

> > +static bool nxp_fw_change_baudrate(struct hci_dev *hdev, u16 req_len)
> > +{
> > +     struct btnxpuart_dev *nxpdev =3D hci_get_drvdata(hdev);
> > +     static u8 nxp_cmd5_header[HDR_LEN] =3D {
>=20
> It would be good to prefix HDR_LEN with something to make it more specifi=
c
> to this use case.
We need this HDR_LEN macro while sending cmd7 as well. Hence kept this unch=
anged.

>=20
> > +                                                     0x05, 0x00, 0x00,=
 0x00,
> > +                                                     0x00, 0x00, 0x00,=
 0x00,
> > +                                                     0x2c, 0x00, 0x00,=
 0x00,
> > +                                                     0x77, 0xdb, 0xfd,=
 0xe0};
> > +     static u8 uart_config[60] =3D {0};
>=20
> Is this some structure actually? You seem to be filling it always with
> the same stuff in same order?
>=20
> You probably need to handle byte-order properly too.
Handled cmd5 and cmd7 in a proper way using structures and handled byte-ord=
ering.

> > +static u32 nxp_get_data_len(const u8 *buf)
> > +{
> > +     return (buf[8] | (buf[9] << 8));
>=20
> Custom byte-order func? Use std ones instead.
Resolved in v2 patch.

> > +     if (nxpdev->fw_dnld_sec_baudrate !=3D nxpdev->current_baudrate) {
> > +             if (!timeout_changed) {
> > +                     nxp_send_ack(NXP_ACK_V1, hdev);
> > +                     timeout_changed =3D nxp_fw_change_timeout(hdev, r=
eq->len);
>=20
> You never test if there was enough data? If there isn't req will be NULL
> which you don't check before dereferencing req->len.
Added check for req before dereferencing it.


> > +             if (req->len & 0x01) {
> > +                     /* The CRC did not match at the other end.
> > +                      * That's why the request to re-send.
> > +                      * Simply send the same bytes again.
> > +                      */
> > +                     requested_len =3D nxpdev->fw_sent_bytes;
> > +                     BT_ERR("CRC error. Resend %d bytes of FW.", reque=
sted_len);
> > +             } else {
> > +                     /* Increment offset by number of previous success=
fully sent
> bytes */
> > +                     nxpdev->fw_dnld_offset +=3D nxpdev->fw_sent_bytes=
;
> > +                     requested_len =3D req->len;
> > +             }
> > +
> > +             /* The FW bin file is made up of many blocks of
> > +              * 16 byte header and payload data chunks. If the
> > +              * FW has requested a header, read the payload length
> > +              * info from the header, and then send the header.
> > +              * In the next iteration, the FW should request the
> > +              * payload data chunk, which should be equal to the
> > +              * payload length read from header. If there is a
> > +              * mismatch, clearly the driver and FW are out of sync,
> > +              * and we need to re-send the previous header again.
> > +              */
> > +             if (requested_len =3D=3D expected_len) {
> > +                     if (requested_len =3D=3D HDR_LEN)
> > +                             expected_len =3D nxp_get_data_len(nxpdev-=
>fw->data +
> > +                                                                     n=
xpdev->fw_dnld_offset);
> > +                     else
> > +                             expected_len =3D HDR_LEN;
>=20
> How can you ever end up into this else branch? Why assign expected_len
> here?
There are 2 scenarios where requested_len =3D=3D expected_len.
One, where requested_len is 16, which means a header was requested.
Another, where requested_len is not 16, which means payload was requested.

So if header was requested, we calculate the payload length which should be=
 equal to requested_len in next iteration.
Similarly, if payload was requested, then in the next iteration the FW shou=
ld request for a 16 bit header.
The expected_len is expected to toggle between 2 values: 16 and (e.g.) 2048=
.

>=20
> > +             } else {
> > +                     if (requested_len =3D=3D HDR_LEN) {
>=20
> Never true.
Ideally we should not end up in this else part, but there are various custo=
mers and module vendors who use NXP chipsets within their products, which a=
re already out in the market. Whenever the driver sends the cmd5 and cmd7 p=
ackets, we sometimes observe this scenario where the FW requests 16 bit hea=
der in 2 consecutive iterations, and we need to be sure that we re-send the=
 16 bit header, and not the 16 bit payload.=20
This happens when the chip updates it's baudrate while receiving the 1st he=
ader, and discards it due to CRC mismatch, and requests the header again.

>
> > +=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* FW downl=
oad out of sync. Send previous chunk again> */
> > +=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 nxpdev->fw_dnl=
d_offset -=3D nxpdev->fw_sent_bytes;
> > +=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0expected_le=
n =3D HDR_LEN;> > +=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> > +=A0 =A0 =A0 =A0 =A0 =A0 }
> > +

> > +static int nxp_recv_fw_req_v3(struct hci_dev *hdev, struct sk_buff *sk=
b)
> > +{
> > +     struct V3_DATA_REQ *req =3D skb_pull_data(skb, sizeof(struct
> V3_DATA_REQ));
> > +     struct btnxpuart_dev *nxpdev =3D hci_get_drvdata(hdev);
> > +     static bool timeout_changed;
> > +     static bool baudrate_changed;
> > +
> > +     if (!req || !nxpdev || !strlen(nxpdev->fw_name) || !nxpdev->fw->d=
ata)
> > +             return 0;
>=20
> Who is expected to free the skb? These functions or one of the callers?
> (Which one? I lost track of the callchain and error passing too).
Added kfree_skb() in the called functions.


> > +                     strncpy(nxpdev->fw_name, fw_path,
> MAX_FW_FILE_NAME_LEN);
> > +                     strncpy(nxpdev->fw_name + strlen(fw_path), fw_nam=
e_dt,
> > +                                     MAX_FW_FILE_NAME_LEN);
>=20
> How can this second one be correct if you use +strlen(fw_path) for the
> pointer. Why not use snprintf()?
Replaced strncpy with snprintfs()



> > +static int nxp_enqueue(struct hci_dev *hdev, struct sk_buff *skb)
> > +{
> > +     struct btnxpuart_dev *nxpdev =3D hci_get_drvdata(hdev);
> > +     struct ps_data *psdata =3D nxpdev->psdata;
> > +     struct hci_command_hdr *hdr;
> > +     u8 *param;
> > +
> > +     /* if commands are received from user space (e.g. hcitool), updat=
e
> > +      * driver flags accordingly and ask driver to re-send the command
> > +      */
> > +     if (bt_cb(skb)->pkt_type =3D=3D HCI_COMMAND_PKT && !psdata-
> >driver_sent_cmd) {
>=20
> Should you need to check psdata for NULL before dereferencing it?
Added checks for psdata before dereferencing it.


> > +/* Bluetooth vendor command : Sleep mode */
> > +#define HCI_NXP_AUTO_SLEEP_MODE      0xFC23
>=20
> Try to change all hex letters to lowercase.
Changed all hex letters to lowercase.

> > +struct V1_DATA_REQ {
> > +     u16 len;
> > +     u16 len_comp;
> > +} __packed;
> > +
> > +struct V3_DATA_REQ {
> > +     u16 len;
> > +     u32 offset;
> > +     u16 error;
> > +     u8 crc;
> > +} __packed;
> > +
> > +struct V3_START_IND {
> > +     u16 chip_id;
> > +     u8 loader_ver;
> > +     u8 crc;
> > +} __packed;
>=20
> Struct names should be lowercased. Multibyte fields need to specify
> byte-order?
Resolved.

> > +
> > +#define SWAPL(x) ((((x) >> 24) & 0xff) \
> > +                              | (((x) >> 8) & 0xff00) \
> > +                              | (((x) << 8) & 0xff0000L) \
> > +                              | (((x) << 24) & 0xff000000L))
>=20
> Perhaps something existing under include/ could do swap for you?
Added call to a standard swab32() function.

> --
>  i.

Please review the V3 patch and let me know if you have any suggestions or c=
omments.

Thank you,
Neeraj
