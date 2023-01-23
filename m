Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0B74678087
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 16:51:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232964AbjAWPvo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 10:51:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232951AbjAWPvi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 10:51:38 -0500
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2113.outbound.protection.outlook.com [40.107.241.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E54E1EFF1;
        Mon, 23 Jan 2023 07:51:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XdF3XBEbbxuNITI0+gAKJeXBbmCJk1valm19lgI1AF3DKmSqguCnQkCnA5y6T0Mj0C1FzpX8rYGhFlr89hE6pVnG3g+uim1KmScEFDNJ8h0vBs3Y+cIsnqo55CeLQAaZ5BfcT7RoQ3iRhmwyv3ufKsL6u1nnnEpPS6JClZyU2jf8TcKF4TfkcrcIngfH9rq82meRM5/v8NiDcaKsWV8UDpVcB2ZLQdinFQBdNQIQYsu+nulVTx+9cm94S4SvA4pPuihTM/XNkxvAW2lMOF2UhfFpy+xFVMe0leqr5WzqvRnJ77rOjzOo9BAqGU9vtM8kzSoSdfOpfX0EzPygUeI1vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zup7Qv07NCQvuWDpC0pQrBahOrndwNtvkrl3G4pJTaw=;
 b=P6jF/CUwm4k3eygLXNLBW6HKkbneoVnYMt5uIIBMutI4KXnIMIF88ceQl6pjirlAbn9G8bll1OGaFo82Nv1uqfOmo7DENmPTiD3xJueX/LnFwSd6+slCgs/sbghXZan1TbiaaAcOX4I1CUCzrVmOSZ4YJmwlGZ3FbAYyhiaA0OnswDF6encBRl4Ch8gndkUf1tNJLXwkB5V+c6HyG2Z8v8euZK7BttvTs9Vx+yz6xQ5O4VL274CaPuVFRrEbCN9vdyCNk/MvevkEeYxjw4isYK1TQQIxY2/4v3L26tmUU3k2f9ALQVkbKVd/sHgsOxkfME130OMPsIfsvE2DPV5IHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=esd.eu; dmarc=pass action=none header.from=esd.eu; dkim=pass
 header.d=esd.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zup7Qv07NCQvuWDpC0pQrBahOrndwNtvkrl3G4pJTaw=;
 b=t97ibxSvrlrsT2i0kSYHbjG069n6AzsYxL9hmYcMr6/E24GxJjNos8W+JZsjvBCGMIxpcXBYFF4Gy47eZ/In9VrEKpvm+OiwlOlJ5E0X5CqjwXW6alTjEQESLJxgx/W+/c8NNmM4TG7iEg+GAXBRDyJ4JKVPlS93GH9bnyLFK8Q=
Received: from GVXPR03MB8426.eurprd03.prod.outlook.com (2603:10a6:150:4::9) by
 AS8PR03MB7142.eurprd03.prod.outlook.com (2603:10a6:20b:23d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Mon, 23 Jan
 2023 15:51:30 +0000
Received: from GVXPR03MB8426.eurprd03.prod.outlook.com
 ([fe80::acef:56e7:b5cf:317d]) by GVXPR03MB8426.eurprd03.prod.outlook.com
 ([fe80::acef:56e7:b5cf:317d%3]) with mapi id 15.20.6002.033; Mon, 23 Jan 2023
 15:51:30 +0000
From:   Frank Jungclaus <Frank.Jungclaus@esd.eu>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "mailhol.vincent@wanadoo.fr" <mailhol.vincent@wanadoo.fr>
CC:     =?iso-8859-15?Q?Stefan_M=E4tje?= <Stefan.Maetje@esd.eu>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] can: esd_usb: Improved decoding for
 ESD_EV_CAN_ERROR_EXT messages
Thread-Topic: [PATCH 3/3] can: esd_usb: Improved decoding for
 ESD_EV_CAN_ERROR_EXT messages
Thread-Index: AQHZE/C023IBXwmcgEW0dqi5txYJI652P5GAgAA5mwCAAANXgIA14LUA
Date:   Mon, 23 Jan 2023 15:51:29 +0000
Message-ID: <8dad612dc67b19d1f5c295b46e70ad56666c1b17.camel@esd.eu>
References: <20221219212717.1298282-1-frank.jungclaus@esd.eu>
         <20221219212717.1298282-2-frank.jungclaus@esd.eu>
         <CAMZ6RqKMSGpxBbgfD6Q4DB9V0EWmzXknUW6btWudtjDu=uF4iQ@mail.gmail.com>
         <CAMZ6RqKRzJwmMShVT9QKwiQ5LJaQupYqkPkKjhRBsP=12QYpfA@mail.gmail.com>
         <20221220090525.tvmgmtffmy7ruyi3@pengutronix.de>
In-Reply-To: <20221220090525.tvmgmtffmy7ruyi3@pengutronix.de>
Accept-Language: en-001, de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=esd.eu;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: GVXPR03MB8426:EE_|AS8PR03MB7142:EE_
x-ms-office365-filtering-correlation-id: ca9ff66e-73af-489d-41f0-08dafd59b19d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: C92JyGyLxjd/wSvEgoDz/zHqu+L8Fb2rov3PGa9QGhghW41moAlWOSiR5KvJqRfkMd4BEY2lr2yXqAQd813FZCz/+yPPSwAsJSjzXTx99a45Hzzx5VRVlfaL9H6XmPRVQdgMOyjG+RvMyQDT/yJ33Yd2t48XGLMUfZ/GFYo65sV5I9XyLPhnKvISGoo3DJAHjKwDV4xY4itZhOL91ZLOB3ABbfkqJVsmhpK2bGEtXRWBjE5YNPTVBf4SErSwPSALIxOSXgyhzrWFWcFm+re/ZjTjq/UJAsOw+98vVCNDYLEotjPoP8FsfbjMXI3OBFjHAOynVyQVk/TI1Bw1DXlHjxbIIEManZOLEATiBqih/B6Q4q+JIDREDGmSheQgKPIwxSD4JPiRRvXsZTTLP1mFcBsSvniqW0SbJsdbME7L+D8jAF5OSWV1PSdKxLHAZUxFZAC4Tm0d56VacOvMXEkNapxmGPmbl3VGCUqfUd0ST4oucP5Qc95akJ8HJ2tqe4Pq3DgCnOoe+8qy015X/H32GgZuI6JOMOYWMNd35AXtV5Mgfi67lftDt8dgtkOCYNNftFgSY/mnA5V5v8+JXd0Yfw7+sS6tFFk3tePRjIIuDfXeJKc9KbQS0svKsgTSLQcykOCOXnS9OmgoeMc415CHrwL28/ydZbqQiWxPuCeOgZ0j1AyUg3647G4jrZX1TWI+SBzOh+S34TzLCZVGM+ox9zq9xQm0gU8+DYThTmBAXeQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR03MB8426.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(376002)(346002)(39840400004)(396003)(136003)(451199015)(122000001)(38100700002)(36756003)(86362001)(478600001)(316002)(38070700005)(110136005)(54906003)(966005)(64756008)(66446008)(6486002)(8676002)(66946007)(66556008)(76116006)(4326008)(66476007)(91956017)(2616005)(71200400001)(2906002)(4001150100001)(6506007)(53546011)(83380400001)(26005)(5660300002)(6512007)(41300700001)(186003)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?q6+nLdX11RJDucU74dPJtH7tIoKi0EPWhTarUI0NCIvi6vII1LWioGOIr?=
 =?iso-8859-15?Q?S9XBCSwXkrk5necW6sIlK7Tattd3gbOcUilIJ2ZoKBNtAIRe/Xiplw//J?=
 =?iso-8859-15?Q?3r7RDBsB2NkoJRVZ5TugzSdfLvLB/WVnIgN/8P7bcRYthbP3DaAcR6UVN?=
 =?iso-8859-15?Q?wNU73FM+5oA6KBj+n+h1M1fQvUoxZbnjO8x2qEmJO2dL6q9T/F0DPykea?=
 =?iso-8859-15?Q?iGUSdDyv69Bor6NMeh/EHvsrGVhdevN1Z/ZiYaay2811qxUjYbcW9oqm4?=
 =?iso-8859-15?Q?HYuql67vCco3mYtrKGG1HW40nROwrrDc630YMFKMWblJeNrktiaexxHhu?=
 =?iso-8859-15?Q?PV8h5eEC96QuWpJ6WPh2LySdcdQE+xtithZZiDsS7K74LtBBCJC3gYzN9?=
 =?iso-8859-15?Q?UMXGxS2U8Pm2Q8jYnm2ZiTeJUm13fNYi9lcpHrmpFbca2gOSHC4mg/A+U?=
 =?iso-8859-15?Q?5hfaUo7Rf8qPrtfm3ae8nByIjUiC+dEBqYuhfoSXCPsDpNohVHY8jq180?=
 =?iso-8859-15?Q?WQDtf2sj9DsUDvk55nPOSoKWdS1JjXF8sobmRY2lHpw9V+YLiHTU4B9/f?=
 =?iso-8859-15?Q?iUQfcdltxNH9sPRtA9U0ADW0r4YD42XxiUMcoc0vnfpgTihlR1nVnm1tq?=
 =?iso-8859-15?Q?jgL9U/Xntr7In1p9Uf5v9/Jw2hjXjtEp7wawM5Wefz3rla29dIYvL4V0b?=
 =?iso-8859-15?Q?i7OxaA5MW3Y2+dxvd0GlVp3gZ2NwVqJMSbRarOAWMfJtHjLG+zNTU2g+r?=
 =?iso-8859-15?Q?9J4sCPHtFSySOURnBzHYxzQ+0oyOTW9q16yI2DAvnQO/OLJKnCgoUccc5?=
 =?iso-8859-15?Q?Vi9JoqPxh+qgJr9dAuMTiEM2n7CAAop9BVVIqx4vAQ0FRAbwwbqLmz9cJ?=
 =?iso-8859-15?Q?uqNXGEoNd7lc4jjDJEnpZQVSi5HeJRSkDgnxe/vtRqN+eHzKevpYqz7sL?=
 =?iso-8859-15?Q?ovfRDZ9KqvQoiTEcfUt6TX9wH1A9G2n3DnFhxObZx52cex19e90A6eToZ?=
 =?iso-8859-15?Q?hG7szak+VNDlR98ZtUOTVhGoUYTpcmSv3evFCTl4KsxUBx3xUN0ShHVct?=
 =?iso-8859-15?Q?OacjvnpmPzp1i5lsFpz8F5VYea7ZFKAZzIt/ElXDwaUyMe1jlWOnRLD7O?=
 =?iso-8859-15?Q?G9uvEsPPi7siWLkzlRL5+45Lp0qvXwvxU7lGljZI+kBp50hwVe8NBdQSn?=
 =?iso-8859-15?Q?ZirhECEgsjw7Wy9EHHbPQYkpnPaCtIgC8K5ViNJaOGdVcsiL1Inx+ODUO?=
 =?iso-8859-15?Q?8M6cmiIzDIdOf6sh7ukPBc/QlQP4Vv6fYP+2S95zrOWn179J5reLDypBZ?=
 =?iso-8859-15?Q?1MGyrLcZeypifhMLtiibUzVE+rT1P532JGPTYVc7DDkgEermY/9XG2T+W?=
 =?iso-8859-15?Q?1ZGmKcifiREBGiOU1skGwsunNJJnbuIMGCTbpY3BvnigN3JOJkcK8Ffeo?=
 =?iso-8859-15?Q?4EVxw/2osVeC27pCujS0c9709fJmQhIthr4hMfGFIQ2rf2sc0f8Xccq98?=
 =?iso-8859-15?Q?txh7IRpZounRLZ1RW0hKkrZ8kgQo4JkKj5yRKcO3uG7+4F+DPCYmysnae?=
 =?iso-8859-15?Q?hTDSYYTLJJ74tkHM3PkgbBfQJsdBvVovXuyZPQKzlDdVbMNRBtRI+dL0D?=
 =?iso-8859-15?Q?hk7jdQvnnv91Zn+vddhoaJQ2yAmAkgsI/nt0KlTYy7PY29UqDRYuUP0gd?=
 =?iso-8859-15?Q?NoibBzIMtIpdfUV5rPtDGHWQGQ=3D=3D?=
Content-Type: text/plain; charset="iso-8859-15"
Content-ID: <6CAE58EFABAC8E4DBF8BB453258D1BDC@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: GVXPR03MB8426.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca9ff66e-73af-489d-41f0-08dafd59b19d
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2023 15:51:29.9823
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lvJxfglS1/uKsADVru+2l8hpjT1IKGaPrmudPG+N82BjIWmXptKz9YmCnz5zBFdztgDhL12kKUcEl2yRNqKL/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB7142
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-12-20 at 10:05 +0100, Marc Kleine-Budde wrote:
> On 20.12.2022 17:53:28, Vincent MAILHOL wrote:
> > > >  struct tx_msg {
> > > > @@ -229,10 +237,10 @@ static void esd_usb_rx_event(struct esd_usb_n=
et_priv *priv,
> > > >         u32 id =3D le32_to_cpu(msg->msg.rx.id) & ESD_IDMASK;
> > > >=20
> > > >         if (id =3D=3D ESD_EV_CAN_ERROR_EXT) {
> > > > -               u8 state =3D msg->msg.rx.data[0];
> > > > -               u8 ecc =3D msg->msg.rx.data[1];
> > > > -               u8 rxerr =3D msg->msg.rx.data[2];
> > > > -               u8 txerr =3D msg->msg.rx.data[3];
> > > > +               u8 state =3D msg->msg.rx.ev_can_err_ext.status;
> > > > +               u8 ecc =3D msg->msg.rx.ev_can_err_ext.ecc;
> > > > +               u8 rxerr =3D msg->msg.rx.ev_can_err_ext.rec;
> > > > +               u8 txerr =3D msg->msg.rx.ev_can_err_ext.tec;
> > >=20
> > > I do not like how you have to write msg->msg.rx.something. I think it
> > > would be better to make the union within struct esd_usb_msg anonymous=
:
> > >=20
> > >   https://elixir.bootlin.com/linux/latest/source/drivers/net/can/usb/=
esd_usb.c#L169
> >=20
> > Or maybe just declare esd_usb_msg as an union instead of a struct:
>=20
> +1

Accepted ;)
I'll try to address this in a separate code-clean-up patch.

>=20
> >   union esd_usb_msg {
> >           struct header_msg hdr;
> >           struct version_msg version;
> >           struct version_reply_msg version_reply;
> >           struct rx_msg rx;
> >           struct tx_msg tx;
> >           struct tx_done_msg txdone;
> >           struct set_baudrate_msg setbaud;
> >           struct id_filter_msg filter;
> >   };
>=20
> Marc
>=20

