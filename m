Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1F016B7A28
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 15:17:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbjCMORs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 10:17:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230243AbjCMORq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 10:17:46 -0400
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2048.outbound.protection.outlook.com [40.107.241.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 824117EC6;
        Mon, 13 Mar 2023 07:17:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IVnYRV0N6uSpSXxQxMNCumdAU82PxWN4BgZz64IuBLyj8erF///AXZkWDVBgfE3wZA0vSPkkiLVTkpwEiwggUhifPYxtHOwv94N7oEzTyESY+JqWYQUG7sJxNCVJf7iPmJo19KV4j59QssflHdIo8YNOvr5oHnWnmEtjtik1pm2+TowlKWvqminLF8xJzin55oCEdX7nCEYBpCN+UHgij0BMBYHKv+WcUpf+BDV4QmybNMrRKpdKqkpMrhrvuWQ644mPNcP5HpEAduDnAeyUmevKslXRZsXAWiyomG8wuqYFQr+BtweGtaK5efdoymMychahshABnwkxU3r50uef4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uuIXniFsYqj1m8zHEFTJZCSyAt8PdEQnOqrMp1KN73A=;
 b=UqBUEETtV7/GWRlOgiQWE2F8nr0ZFfrTnTjoYUoDB7oOyki22w7EeWmYUK3ZtvRalUPxLNYU3OiB+m3j3mooJilT1+U6jSsk4BcdSjeeBTLRgkwoeUcsj9fL4dzq/qTTHmKBAc6oS+ujsfGCLqHNQFBmPVOtbFz0FHM0NH89B74orwgoSilcVXPmp2uUC956iEp8LRNCxZZCR801nh/kp0yCLy+U3xdZVSLfGr+sc0ZhrBiETmyfksKdaPHzw+EVYvWsdGO4eV5arrIk90IlrrwP9UuIc57qg6SElmbPFAbizCRKmcHHYHWQEevY7G37zcfflqdSZoHAAMMGf0nR6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uuIXniFsYqj1m8zHEFTJZCSyAt8PdEQnOqrMp1KN73A=;
 b=dSKWaVfYwTE9Y/3ozttH3BInedovPuG0OjKDxrEHnvbuctu+d5nmsxyvAY0gVy2JWZi6uGyMCL8uyUCM/9KR8GDNWwqeRljEsKLmtllkJ62h6InP0rASLO1i8QQW3RCiKdJ+HAb5OS24juw7U7KZc2bxDlEkDJ+oyzw35dzPrGQ=
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com (2603:10a6:20b:43a::10)
 by AM9PR04MB8924.eurprd04.prod.outlook.com (2603:10a6:20b:40b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 14:17:41 +0000
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762]) by AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762%5]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 14:17:41 +0000
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
        "alok.a.tiwari@oracle.com" <alok.a.tiwari@oracle.com>,
        "hdanton@sina.com" <hdanton@sina.com>,
        "leon@kernel.org" <leon@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        linux-serial <linux-serial@vger.kernel.org>,
        Amitkumar Karwar <amitkumar.karwar@nxp.com>,
        Rohit Fule <rohit.fule@nxp.com>,
        Sherry Sun <sherry.sun@nxp.com>
Subject: RE: [EXT] Re: [PATCH v6 3/3] Bluetooth: NXP: Add protocol support for
 NXP Bluetooth chipsets
Thread-Topic: [EXT] Re: [PATCH v6 3/3] Bluetooth: NXP: Add protocol support
 for NXP Bluetooth chipsets
Thread-Index: AQHZU37Vjd7Ix4B5hkSh358K3L6Hra74b8eAgABVvFA=
Date:   Mon, 13 Mar 2023 14:17:41 +0000
Message-ID: <AM9PR04MB8603BE475B041AD1B45BBCC0E7B99@AM9PR04MB8603.eurprd04.prod.outlook.com>
References: <20230301154514.3292154-1-neeraj.sanjaykale@nxp.com>
 <20230301154514.3292154-4-neeraj.sanjaykale@nxp.com>
 <73527cb7-6546-6c47-768c-5f4648b6d477@linux.intel.com>
 <AM9PR04MB86037CDF6A032963405AF0CEE7B69@AM9PR04MB8603.eurprd04.prod.outlook.com>
 <48e776a1-7526-5b77-568b-322d4555a138@linux.intel.com>
 <AM9PR04MB8603D2F3E3CDC714BDACECC0E7BA9@AM9PR04MB8603.eurprd04.prod.outlook.com>
 <11c7e098-19c8-6961-5369-214bc948bc37@linux.intel.com>
In-Reply-To: <11c7e098-19c8-6961-5369-214bc948bc37@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM9PR04MB8603:EE_|AM9PR04MB8924:EE_
x-ms-office365-filtering-correlation-id: 259b4f72-c59e-4c1d-55ea-08db23cdb526
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ed5VRN2JXp0tx/0oDa4hTc7x0cgypYdIxzbTnuZQ0s3Wi0rX6n1zkFJE2hd2tZHYjiCfoeO7ymkoswIcVB+fn8ZYoZCpp3borddVT48nnipEcJm/ifOnNZ1AdFz9PeoFdCvuSpKeIBJ0MYx9Sa3IA+X6+mqTptQ2Hf9H8/eBD+Esgis/v5seqWXaCiKZluOii/cw0O6fE4ti2WyasvlIv3NeKzOL77/XRuDKZqeWtFK+chFUuL8JIezBuRVRmBP/XlMwkSKYm1q7YClsxHDC778GrDl5Cynt4ZX3qtxvC+PQKeSoajImbQa1MMX8+6umwwZ4aO2IQ/UFwOl/EkriVQyvUnsBPWiosi5zeaxTwIDIc11vjtqT5iPTw/6qLRx4Oxb2QTz1q+yuo4m9DdGBxwCNggTP2vZylpdrRBCMpEnw7KP37oN1wU82dMOAWWKgnGSersaJ+TwWyhN4ww0z70F8rxntR11qAZ5kZfc2Ryg8gUVMy+kZ/JiMKZ7ZlX0CIgVP51IXETnuPiZ7SZIVVCEpEi5hMsXJH5PaNAW3/wIN40a6ydnPqEy1AS/F+Az5F5WGg8WT62UsHJP4W/fh9hFnHQLhKT1blqUB/1V06UFk8u8G4IGqvJBuRblMpnyLCkhQtyNLmGyLbmWV6qkODwMwfkEX3qHwhX+bOG5HuQttZrCsCkgZpjXC5NlEBsoZGntscc8N0PCLCXvw2a4rTQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8603.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(376002)(346002)(136003)(396003)(39860400002)(451199018)(5660300002)(7416002)(478600001)(55016003)(7696005)(6506007)(26005)(71200400001)(9686003)(55236004)(38070700005)(4326008)(76116006)(66946007)(33656002)(64756008)(66446008)(66476007)(66556008)(8936002)(8676002)(6916009)(52536014)(186003)(41300700001)(86362001)(54906003)(316002)(38100700002)(122000001)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?V94EspDV5jSr94/XuO7bwie2YhVIHewJ7Z0TKSHXMasbeubgPI6VCfxwjZ?=
 =?iso-8859-1?Q?8DzXqPQLRN8VgfQogGQodbPm00lzVsLBbBYOM7ocLfkO36nyWQf5sLacaQ?=
 =?iso-8859-1?Q?JmzHuNJF50eGtDsG4voqfGyhCKJeLAZZcF6Uz/RWAYHzqve/6YwwCWC/JD?=
 =?iso-8859-1?Q?N5nrZLEwWup1OqnpwMNb4c0vdwvnQ6cXOxWvudmsVlIuqbFNgJGHzooobT?=
 =?iso-8859-1?Q?7tX9AIMrGn9JynWLcD5B+PlzYb+qTkkc8TPTh2GFDSHR5AFfsTrjuan4bP?=
 =?iso-8859-1?Q?L3r6HgweIK2uCNnPKNcseSyd4Z27zHAk23Pn+JQ5Zn/D/FCHAkQzAY3Pef?=
 =?iso-8859-1?Q?fBZBauEZGNgtGeQNDva67UxddAqDqKwLM1E9ITTDfXM90h4sqhKE3N5EL9?=
 =?iso-8859-1?Q?tlVhZZEu4sPU41RsUKcTXVQ36vCItBqf8/16a+Hmzbl2Z6w/fqrHY7aNZD?=
 =?iso-8859-1?Q?ZUM6gTwAKYydC4wA7ez2rlRF4aMa9FLJEtlOolkEe+t8mOnwkpi7nSXiw+?=
 =?iso-8859-1?Q?yYpCw2hRD7xQJUq3cMBfv3FtdzHr3LnSuuJ+/o/+DDX15U/kTO02af0L6H?=
 =?iso-8859-1?Q?RCyMu4NG5+8g08IX2V0fqxFdnvynUAozPnLkHL1pgiSuzrAKffXkYm4biL?=
 =?iso-8859-1?Q?1Uaue4pE7tCP3EKgbIRWQTH09AdFh6g01kswF6t6vSq6Hj7W51wIuhGTtJ?=
 =?iso-8859-1?Q?/rdV1xBMLwlcVaLb5KENsxKtzmSi0ZdAZ+0OQ7mFkFqZxGpj04L/5U2kEb?=
 =?iso-8859-1?Q?gmlToXlDUW9OIAHV3cAFBIwuqB/Ku8bbKLpmfVhWOZLtCQVwebO8wne5Z1?=
 =?iso-8859-1?Q?7gPKvFw0O3S1bG9s+YFLXwKmvtzrnyUu/u/fz6TWWEwZkb0b3xxJF4bMm4?=
 =?iso-8859-1?Q?fML72kKa57dM0MmU0ehuQ9g4Zu1kltqUqzEpTMcHZIfwY86ewyzwf4HNOk?=
 =?iso-8859-1?Q?pfQLCVhMCWWyCd88j8ecLExvaFpiouU8PR0xcN4ExVNbjaf8WnjzWL7j46?=
 =?iso-8859-1?Q?Uy/5P++QjzYSt0g6IzKf+lxqZ6JO72OCulUkDh5tbXD+r/MQpnYSS0ucf0?=
 =?iso-8859-1?Q?vV/6n3uh3RYyZUa/Y35tqXJU1wVkeix+9LTerJ+V0hRZ2unanuLkXSH4br?=
 =?iso-8859-1?Q?vuA8tSn5G7nZi1tXCltDQGjT/WEPqA9p3eaMScSdb5AgoxGZqP855wH+2K?=
 =?iso-8859-1?Q?AXtp2tErSXUrO7qhUQ8nWPhl4Oz2NzZXHM1udUntJqW61UtVvoMsOXgdg1?=
 =?iso-8859-1?Q?V+4PqnWSsOkMOYd2ZaBLNnZg88Zgj2h+1yAfoDfhbL/d5kZu0NGccjFskn?=
 =?iso-8859-1?Q?ludQNeYOdYk8NY60rZDQ1RN9sHZ3kEBaZSxycMBQ1bdhv4pe5rosdZJcQ4?=
 =?iso-8859-1?Q?kA6M+YjifswaVST8HY8OwHT5HE7VPITVaeLyk9s/7av8ussMYC3knzx7J8?=
 =?iso-8859-1?Q?uU55RQJuCvsDSY/zmLtzcCAVykNwm/ozbVYmqXKlmtkPu9oqkDHkAsNoof?=
 =?iso-8859-1?Q?u76X+QJ1cpY+5eHYedSlDStEUZn1MwTg9ySQN+b/vnwylofQuJli4bVsh3?=
 =?iso-8859-1?Q?N8GBdKwU/Vg7/vug7LTidk3nH+Dz1zEGENeyaw2XfdcpYIFqB198oGxsLS?=
 =?iso-8859-1?Q?ZlDsQ3WwiSSJzQ/VyyKLEfGDJJUtaa9oVVyztx9wSE5ShAVPZEeUGVsg?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8603.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 259b4f72-c59e-4c1d-55ea-08db23cdb526
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Mar 2023 14:17:41.7357
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 68+S8xl0X3EPP2NkI8x7P7o1FXQIXg95OxSVdhp+nc1VFMLlDn0iqo2Wlw20YPRt5O+p8kjM9summpGEBDMRbne97a35WYAGV8YAe6DV+bM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8924
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ilpo

>=20
> On Fri, 10 Mar 2023, Neeraj sanjay kale wrote:
>=20
> > Hi Ilpo,
> >
> > I have resolved most of your comments in v8 patch, and I have few thing=
s
> to discuss regarding the v6 patch.
> >
> > > > > > +static bool nxp_fw_change_baudrate(struct hci_dev *hdev, u16
> > > > > > +req_len) {
> > > > > > +     struct btnxpuart_dev *nxpdev =3D hci_get_drvdata(hdev);
> > > > > > +     struct nxp_bootloader_cmd nxp_cmd5;
> > > > > > +     struct uart_config uart_config;
> > > > > > +
> > > > > > +     if (req_len =3D=3D sizeof(nxp_cmd5)) {
> > > > > > +             nxp_cmd5.header =3D __cpu_to_le32(5);
> > > > > > +             nxp_cmd5.arg =3D 0;
> > > > > > +             nxp_cmd5.payload_len =3D
> __cpu_to_le32(sizeof(uart_config));
> > > > > > +             nxp_cmd5.crc =3D swab32(crc32_be(0UL, (char *)&nx=
p_cmd5,
> > > > > > +                                            sizeof(nxp_cmd5)
> > > > > > + - 4));
> > > > >
> > > > > swab32(crc32_be(...)) seems and odd construct instead of
> > > __cpu_to_le32().
> > > > Earlier I had tried using __cpu_to_le32() but that did not work.
> > > > The FW expects a swapped CRC value for it's header and payload data=
.
> > >
> > > So the .crc member should be __be32 then?
> > >
> > I disagree with using __be32.
> > I have simplified this part of the code in v8 patch, please do check it=
 out.
> > So the CRC part of the data structure will remain __le32, and will be s=
ent
> over UART to the chip in Little Endian format.
> > It's just that the FW expects the CRC to be byte-swapped.
> > Technically it is big endian format, but you may think of it as a "+1 l=
evel" of
> encryption (although it isn't).
> > So defining this structure member as __be32 can create more questions
> > than answers, leading to more confusion.
> > If it helps, I have also added a small comment in there to signify
> > that the FW  expects CRC in byte swapped method.
>=20
> I'd have still put the member as __be32 and commented the swap
> expectation there. But it's not an end of the world even in the current f=
orm.
This sounds okay to me. I have changed the CRC datatype to __be32 and kept =
the comment.

Thanks,
Neeraj
