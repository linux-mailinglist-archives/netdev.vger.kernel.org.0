Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 248A463C643
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 18:16:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235518AbiK2RQF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 12:16:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230217AbiK2RQD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 12:16:03 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2112.outbound.protection.outlook.com [40.107.6.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A51A766C87;
        Tue, 29 Nov 2022 09:16:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TTknm2fFQ37jaJ38qXfg7Xf4gjqfbH1CcrA4h2bibqyy8/avKAA6f4h0mc76voHAYn0di23zk98owW9Y12iPIplCj+/Tr+Pkvnv5Mx9fPgtllDLEfBwvNouO8OVercpMuaqmBn0KmQXxeMBThba3YE/Udu+swnIR/dxFP/MJYxwAzzDfCn/tQWy/a7MrIfusDhVNymS19ESpmNI+1l9L1GUhPb7fHC8o8VnK0GPVhNLZQD0gWaA/ecLBBG4GuqmC4iO2Lk8tmhB31EwNIvf024fkbYzuCSuQCzetOIOamSAUhOKW0vU75plHz6ewjOeaX7iXbtOqP22Q6WyvIWZA7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ftyvnqijf3T4oFrw30QLTODi4w+NJBc63SOL4IdUaEk=;
 b=P7HJdTbwdJRtglnEBHx93r48ya7PwhnTJ+/YhsqI7QTlW88neI4jROdpNGa0PpdBkAU3VNGzNgzP9uqXqXpDGmza5fZ29v4N1oVxjYkC6TY41wH4MrJBk7l/oeO1+b84AsTqbtwkP7hHnWfG00PLbzePgvtafsoYUMoWQUAhK+AKszUIWvtsGkHuNpLYZ10Cs/Nen4NtT1RoGE/PZwA9IWepflIYdi/UczWsek6yvbThWcu8pPyAa8NqO4jXYIT/NBw6loz7qXycMysFIGov/nkN1xXz9WiGv8xTwsAYK2N8a707k2ooWDnZzLvHXH3S44aAA26xP3hljQCUXcTVqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=esd.eu; dmarc=pass action=none header.from=esd.eu; dkim=pass
 header.d=esd.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ftyvnqijf3T4oFrw30QLTODi4w+NJBc63SOL4IdUaEk=;
 b=FULlQJQMjLtGRjc4xnXWqFMyTrbT4IAJDotrdKPWJimBtDor7NJDp9SKE54L1C8tcBye7CCiYAKXS8/f6Em4GJ2z6ohg2lmc05QNNSh5tZk9Yck9i2HaHGyRcq+BESgPszTFo8NN31SLDoOisLaqPnbN1H1gqJQp+9xzsoPGUPU=
Received: from GVXPR03MB8426.eurprd03.prod.outlook.com (2603:10a6:150:4::9) by
 DB9PR03MB9711.eurprd03.prod.outlook.com (2603:10a6:10:453::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.21; Tue, 29 Nov 2022 17:15:56 +0000
Received: from GVXPR03MB8426.eurprd03.prod.outlook.com
 ([fe80::acef:56e7:b5cf:317d]) by GVXPR03MB8426.eurprd03.prod.outlook.com
 ([fe80::acef:56e7:b5cf:317d%3]) with mapi id 15.20.5857.021; Tue, 29 Nov 2022
 17:15:56 +0000
From:   Frank Jungclaus <Frank.Jungclaus@esd.eu>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>
CC:     =?iso-8859-15?Q?Stefan_M=E4tje?= <Stefan.Maetje@esd.eu>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mailhol.vincent@wanadoo.fr" <mailhol.vincent@wanadoo.fr>
Subject: Re: [PATCH RESEND 1/1] can: esd_usb: Allow REC and TEC to return to
 zero
Thread-Topic: [PATCH RESEND 1/1] can: esd_usb: Allow REC and TEC to return to
 zero
Thread-Index: AQHZAES6tPgW1JW2aUWnZtafT+CSX65PzIaAgAZfa4A=
Date:   Tue, 29 Nov 2022 17:15:56 +0000
Message-ID: <567bb7208c29388eb5a4fe7a270f2c3192a87e0e.camel@esd.eu>
References: <20221124203806.3034897-1-frank.jungclaus@esd.eu>
         <20221124203806.3034897-2-frank.jungclaus@esd.eu>
         <20221125155651.ilwfs64mtzcn2zvi@pengutronix.de>
In-Reply-To: <20221125155651.ilwfs64mtzcn2zvi@pengutronix.de>
Accept-Language: en-001, de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=esd.eu;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: GVXPR03MB8426:EE_|DB9PR03MB9711:EE_
x-ms-office365-filtering-correlation-id: b7253028-f9c7-44f8-373c-08dad22d60c9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uGCJNhmRpixrVCdujGiamzrPKdTfFo3rP0Nc2kYSXyE6Abr0JwiVcSch7r5mOn9GRVUKz9B6AKhTyf5EcK4ika40L5Bq97QnIVsEIpZdEk5fJD0ESrtF2S3P8t+j2IzrV4nj+MqEGYbNhn10EMBXBoUi1hEghSdrDExKg+xpPs6Mm3Vj23nd+G3JXMjbdlBetRiMs2OiEXuSmLU/FJfJS1pmcufcb5pzAkPvG4sMLDcIaKSeTPuRuNU5IKzFQ4eS4VVNTcSIHOyVzeyDPWNbhTSsE7u/1kqqLA6a9vytVgDKu90L7e4uYTkIG8coCwnt2QvMEcnU/5UV3IPho7rfo13SEUEspUwMJQ52nrBfyRlTNAsmlY1MGGZ6Y/iVJGNUVA5LoYcBSR9iXbIsCjAOFMAA1MR5ghVS5PzjGfJnmF2gkBumYGn/opszjS5SmRx2ORl5f37sgYuQ8DTYmx/BhXY/kamingjIpCBN8+Dw3dKjN8KFftLrOQ+x4LLnwPB37oCJeOMsdVTKjjaPx4ywZfAwM5Nh+GOKXMjNzbqwpKbKBp8awwl11YbDcOqrxEjqAc9tnaSxe4LrsU3NlDO9FuDXbUheD1fQM15sVvVQywBw/YkSRdwDTdOeABtuVJVNALblZJfaR62zarkTAFSUmdYbXuWdNbFYAR1ZaIyuXHSBEzqfqssPfmNyM+XSxLk+0Ohd5F0jmL1vjyq8rArPhA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR03MB8426.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(396003)(346002)(39840400004)(376002)(451199015)(6506007)(122000001)(41300700001)(478600001)(966005)(6486002)(71200400001)(38100700002)(53546011)(36756003)(316002)(54906003)(4326008)(8676002)(66556008)(66476007)(64756008)(26005)(66446008)(66946007)(76116006)(38070700005)(8936002)(6512007)(2906002)(186003)(4001150100001)(2616005)(5660300002)(91956017)(86362001)(83380400001)(6916009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?Q5a8Y0hDjJUEWhwMkXoxA7UcBk0Ey9+QvxzZa4KYmkrq1cJREycEe7sBX?=
 =?iso-8859-15?Q?F6FRBh+7JtgaX2gK84j2saACqqQ/50DPvcj3WmuRZxRXCibn0sBsQZXO0?=
 =?iso-8859-15?Q?cJttCWhQZhy2IY0dXrLj8Ad8uZDXBWKB/BWI1wG0p3NN+W1Spocd3mQPU?=
 =?iso-8859-15?Q?RA3ZNRq8QElGEWCoQgcigvfAvs/Lr1edl6UstYCybLho4jArcqTuFHgId?=
 =?iso-8859-15?Q?KLV4IR609Os8FHE+oehbdTeI7Y2/b6SqhjRls9Pj51EBeQjN1wDxYV1Xa?=
 =?iso-8859-15?Q?Gso1v13TPpufb1wERW3KdOS/vYFcDnLDk60yoq5fv3MIqVDqaUTVTjKyQ?=
 =?iso-8859-15?Q?h5BksKv4LrmiYkXMbOs2dt+rUBsmIYYAlXyz5tBUgPT9vElrgR1A0BvaA?=
 =?iso-8859-15?Q?gQvLtsCcC+I9B1w5mDCQ2aJKQP9C0UCa8R7na/emhk8GsfjDPRogN/Uwl?=
 =?iso-8859-15?Q?6ZufCzt3UuKRg+Y/LNjAYsappm6hmBkEla0HFfi68P1bOpjUZ4IjqZ81g?=
 =?iso-8859-15?Q?eyVS1vSkDDujv8YLVWXTQsjFGvLF2YJ02ddOcnIvuVIi/SJOJTLxamov5?=
 =?iso-8859-15?Q?csJmsp2Ic7aCC/UZJKZ8l4bT69FtuFxFZhAGdtblhNOsBEww5hOe1/NK/?=
 =?iso-8859-15?Q?LxqAqy5Rm73CRc//da0GFrBBOoiUIZGKRZanpJWt+a4jMVL4vBgdi0zLd?=
 =?iso-8859-15?Q?1Tu4WjHzkwITpxBD4XpftZxlCyBWHuNxOLDBfF3Nm4oMkrgVsJgVn2K+R?=
 =?iso-8859-15?Q?nyc1DouGyIt/r+7P+6NbZ4WXZVbbvshrfCHsumnEpsLKubz3fJfj/JXis?=
 =?iso-8859-15?Q?2wkvlfdRt3zlAqREvUGf3CAF4exqapU15znsy74WjXYeLEZCbWzQhMjV7?=
 =?iso-8859-15?Q?sj1I4XsP4Q3bfpOEiw+d9LeolNd+GkgiVYCvq4wyCN6/KJhLDNn6IGUSj?=
 =?iso-8859-15?Q?duOMM6IAAytGxxtmJnSphxXZIVeb7mAWHtsvwGugVS2dbUKsWfo3erOXX?=
 =?iso-8859-15?Q?gUjxRDeWrcuoCrhUBjFhVf4ERun1JVmg0TsRe8oHfE89aWlkffFsT+YNU?=
 =?iso-8859-15?Q?kM5kHYPpqKPEZs+3vwIR9MVjVKZpYa2a15DZeT5HKjanLZO3t/+zfyfM4?=
 =?iso-8859-15?Q?HqRUS2M3CLeUNGtJ3qF7T5lolDVAIH+QXWY5iuJVf36Yhk7qRaXJKBiXD?=
 =?iso-8859-15?Q?KwaChCYbdL8cPIvUSyT5mgxTlG6LW5anvkhOqyiHXSR0rTpZdWYAh7vpx?=
 =?iso-8859-15?Q?S0nOVBU5iq8affnfbmN2GN3RJmnoKprwTP2b1H+m2I4+LB/7/tzASbMjF?=
 =?iso-8859-15?Q?shxfw9jYbg8GV3+I5j+B/J8tU8MoM7SsyDF+qz0WnFZnoZzFId67Z+t9h?=
 =?iso-8859-15?Q?ZCakHW8mIh6JpgtmaLvFD8dRJJgUkc0DVoo/tBz08hGqJ6Ym0zMFL4C0I?=
 =?iso-8859-15?Q?XkpDtOl4CH7gPM0jIn4LhomF/h4kIkXKDlPVuz2oI7ROpcDOABGDHPTzC?=
 =?iso-8859-15?Q?FY7FOICjJtThhSCACQze1P5CorlnphaM6P8Fl4RJPfiMU04jDsImJIt/1?=
 =?iso-8859-15?Q?of8ERFHJ4zJCIvL2k/lBgRWAUU1cNKNaiu4G5kx06VMDVPmAjatCMXU8O?=
 =?iso-8859-15?Q?5mtEvcfWt69zCNj+HqdakTjTz9d43xiVNyrQZK1sNTkqY1J2YXQRtJTcA?=
 =?iso-8859-15?Q?5+HMi+r6eiq66HaxV+/MV94BxA=3D=3D?=
Content-Type: text/plain; charset="iso-8859-15"
Content-ID: <0911C8CE3D9DD942ABA0335C71884FAA@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: GVXPR03MB8426.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7253028-f9c7-44f8-373c-08dad22d60c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2022 17:15:56.5351
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YcEIIotrWPNSF31DVy8OtptUp1hMJfvrx6I+PtA2/Rw5g3mORt8M53JqSjFBWq3F3JsS3s3BWAaQ0rUm1AxPWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR03MB9711
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Marc,
thanks for commenting.

On Fri, 2022-11-25 at 16:56 +0100, Marc Kleine-Budde wrote:
> On 24.11.2022 21:38:06, Frank Jungclaus wrote:
> > We don't get any further EVENT from an esd CAN USB device for changes
> > on REC or TEC while those counters converge to 0 (with ecc =3D=3D 0).
> > So when handling the "Back to Error Active"-event force
> > txerr =3D rxerr =3D 0, otherwise the berr-counters might stay on
> > values like 95 forever ...
> >=20
> > Also, to make life easier during the ongoing development a
> > netdev_dbg() has been introduced to allow dumping error events send by
> > an esd CAN USB device.
> >=20
> > Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
>=20
> Please add a Fixes tag.
>=20
> https://elixir.bootlin.com/linux/v6.0/source/Documentation/process/handli=
ng-regressions.rst#L107
>=20
From my point of view this is not a regression, it's a sort of
imperfection existing since the initial add of esd_usb(2).c to the
kernel. So should I add a "Fixes:" referring to the initial commit?
(Currently) I'm slow on the uptake ;)

> > ---
> >  drivers/net/can/usb/esd_usb.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_us=
b.c
> > index 1bcfad11b1e4..da24c649aadd 100644
> > --- a/drivers/net/can/usb/esd_usb.c
> > +++ b/drivers/net/can/usb/esd_usb.c
> > @@ -230,10 +230,14 @@ static void esd_usb_rx_event(struct esd_usb_net_p=
riv *priv,
> > =20
> >  	if (id =3D=3D ESD_EV_CAN_ERROR_EXT) {
> >  		u8 state =3D msg->msg.rx.data[0];
> > -		u8 ecc =3D msg->msg.rx.data[1];
> > +		u8 ecc   =3D msg->msg.rx.data[1];
>=20
> unrelated, please remove.
>=20
You're right, sorry, will be removed in v2 ...

> >  		u8 rxerr =3D msg->msg.rx.data[2];
> >  		u8 txerr =3D msg->msg.rx.data[3];
> > =20
> > +		netdev_dbg(priv->netdev,
> > +			   "CAN_ERR_EV_EXT: dlc=3D%#02x state=3D%02x ecc=3D%02x rec=3D%02x =
tec=3D%02x\n",
> > +			   msg->msg.rx.dlc, state, ecc, rxerr, txerr);
> > +
> >  		skb =3D alloc_can_err_skb(priv->netdev, &cf);
> >  		if (skb =3D=3D NULL) {
> >  			stats->rx_dropped++;
> > @@ -260,6 +264,8 @@ static void esd_usb_rx_event(struct esd_usb_net_pri=
v *priv,
> >  				break;
> >  			default:
> >  				priv->can.state =3D CAN_STATE_ERROR_ACTIVE;
> > +				txerr =3D 0;
> > +				rxerr =3D 0;
> >  				break;
> >  			}
> >  		} else {
>=20
> regards,
> Marc
>=20
Regards, Frank

