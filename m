Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0450D6B5025
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 19:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231463AbjCJSdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 13:33:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbjCJSdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 13:33:44 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2053.outbound.protection.outlook.com [40.107.8.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94A7B10A123;
        Fri, 10 Mar 2023 10:33:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bBQS7VGUh+/SvFqPTs+yTMBQz1lOuyTUKE3re9l91xDcKbhcYCGpASSTBf1+SOnMTabhp0eeU3Z5Q7enAqf8wLpCLCYu43ibk2N4/4yT9Lj0OOkLqam/T2OSTX7D6Z8iFKU3DXqIkKwsah5W2q+SgnhUTI8pqgigKaHuPtmk4kGoBTrCUso4Wq6xFdhwFSUPJBCsLa7D77bm3Ty8u8Z8dDyjeejLRIhiX2+bWnB9p67cI/wZa24oho3M2DvBC6PCijaWxT7c3HDpNNp0xgruI3AV3+Bg0MZ6m2BTN2rkYMeAmBpA0HgYuE3e7ddCet7ylAJvsa59Rqw2YS8GgIp1VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DitS9nXi1gChqN1dCcK7q40Flq61J/KD8CMuhpceJEg=;
 b=lJjWDVAl0gwHZl2E9vYHMs9RanRFq+nFqhmI/SuCM0nOPT4kybWl21/1Fm6Apinx4rNc0fQLwWT9om0mfqbLL2Kvfdi5r+V9QPxrFM41oRmdIS2gNf5vZ+Hd0hYCQcUEglm5zBr6shKE8d0fIMB+8VdF0QSWMm560/SrKd5Mh7vQXCBiIZNwzBzw1Lv0/6EYkIEp0LU6gDplb1RbQbNL1l89NwEHPwR5uTbNSjjlvt/wV6auBKeekcTrBy53eRd56Ymp3Pto72NLXgmynqsdYDxXeKTIYJy0fMKCUZCFhXqpdwQLuf43fivBMYds4NotsNIlp4dSM5eMls28655DNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DitS9nXi1gChqN1dCcK7q40Flq61J/KD8CMuhpceJEg=;
 b=hagOgHM0h+JCD4UzAvhAveCkN2CBZWDA7vmEaFPqRicFLIqquPjQEYJR9LbGlbtsi+pNkJ7sWJlMplOz/xvswhPSMbbYIsAfsjdRswp/aOtxGTSmzdA9QxE/OU5cLkQxVzRmdnrcFGJSvKaxqYqydahF4OJaQYBFFD/rFbYXzOY=
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com (2603:10a6:20b:43a::10)
 by AM7PR04MB6997.eurprd04.prod.outlook.com (2603:10a6:20b:10d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.18; Fri, 10 Mar
 2023 18:33:39 +0000
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762]) by AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762%5]) with mapi id 15.20.6178.019; Fri, 10 Mar 2023
 18:33:39 +0000
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
Subject: Re: [PATCH v6 3/3] Bluetooth: NXP: Add protocol support for NXP
 Bluetooth chipsets
Thread-Topic: [PATCH v6 3/3] Bluetooth: NXP: Add protocol support for NXP
 Bluetooth chipsets
Thread-Index: AQHZU37Vjd7Ix4B5hkSh358K3L6HrQ==
Date:   Fri, 10 Mar 2023 18:33:39 +0000
Message-ID: <AM9PR04MB8603D2F3E3CDC714BDACECC0E7BA9@AM9PR04MB8603.eurprd04.prod.outlook.com>
References: <20230301154514.3292154-1-neeraj.sanjaykale@nxp.com>
 <20230301154514.3292154-4-neeraj.sanjaykale@nxp.com>
 <73527cb7-6546-6c47-768c-5f4648b6d477@linux.intel.com>
 <AM9PR04MB86037CDF6A032963405AF0CEE7B69@AM9PR04MB8603.eurprd04.prod.outlook.com>
 <48e776a1-7526-5b77-568b-322d4555a138@linux.intel.com>
In-Reply-To: <48e776a1-7526-5b77-568b-322d4555a138@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM9PR04MB8603:EE_|AM7PR04MB6997:EE_
x-ms-office365-filtering-correlation-id: 8c22357d-fc06-4269-aacc-08db2195f7b8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zo+lgLcn58JgQg1OT9tmL9ae6GSOK4yzzKvGveASJvkI6Av7lQlpps88M3MaC3JpbM4o/dizjFD7DKH5bqje6hrwianwusfRG1tjBRCK7i6PQZV7p0y0acIohcAznD3ZtPRuU5//xJege8fIITn7K/4Q294y2EIeNKW4XdnvKaBy4K7dAGCQKgmlQ4HOA43OP2Y3bzowl2nu+FIa/cfz5kLerbRUpGdy5r69hyxPl5/Tno++JZCvH9wANSa33qOnparOz+y3qiIp65O2Jzi0/UwNAbR2AqSR8/s4ceI2pvXMIJg9HqKvDmSv9QZxcvjTeKj9UOumCrkUzY47IelqjZ4wrnkiqjHuOLboi1I4qrLHJXGrzVMNoOVVG1zkf/Kpzq++t+KiwPCVOqmaG5IMFTj9jIpFugUFkpPb0kXdkJmDltkhNI16PTmaUehr9BOe3ZZxyJA3xFB/EbKpR8Kp/kZpooqfmYo3oYmSRoQV8FDc5RoE9c1TQLCN1ttrqdEy65gKCJPA0N63vTJcMVsTO3kwMs4HnbvSxbhF9DWBGj7BdGs/sVXow3quacxAvdz5I6V/TYQwQTQsUEIMoQO1RtSivuXKsk4e3ZfIY3GlIdj5obALaedoOdIxaR5l7A8TVy7CMh5TqnFkj40k9paqKZtyRcpjmFUr0ZfrrEZq5eqKe7Qc2zFLZ7x8zcXcyufWqTqgo1QenzyIQlAYdPZZng==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8603.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(396003)(39860400002)(136003)(376002)(451199018)(33656002)(186003)(54906003)(478600001)(5660300002)(66446008)(2906002)(71200400001)(52536014)(316002)(7416002)(66476007)(8676002)(66946007)(7696005)(76116006)(64756008)(66556008)(41300700001)(6916009)(4326008)(8936002)(122000001)(86362001)(38070700005)(38100700002)(55016003)(9686003)(26005)(6506007)(55236004)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?ASeMjxcyhH7BMTkdtT/1AHH1Qz4Vo8A1Nojc7Sr4nDCPD4N3XBx4lJ0EHN?=
 =?iso-8859-1?Q?Prn+R828Zt/Q/2T6J8LBuYeCrx6dHJsAIYsVd50YnbkzEij+Qp8JQrC5Km?=
 =?iso-8859-1?Q?kqsgTLJfjlg5mPyPu+TpQ/3uE/2ZoL+2PUOevyiFeipl+gxBwoz6ybiYhN?=
 =?iso-8859-1?Q?TQUBF+xAGwLv4aKFCzdqJCrVbtpJX7AQQ+QqIrT54ywZtWjCSYgGCzQCz+?=
 =?iso-8859-1?Q?NiH5Z7MIKPievthP4RJte0ZrLd04khzV/iEhe8gwFmjszzMdOHH4CsoGX3?=
 =?iso-8859-1?Q?Li81YK3bW8WKcFYaTpGn4vmFeSbfjjD9nlZxyKefYR48Wb88VRvFTC3SHg?=
 =?iso-8859-1?Q?dUdC5ZYHk68fR7EX+bx17WVBbH0lAUaUruq9pWXCt3b9KjflZCg8PHGfR5?=
 =?iso-8859-1?Q?5FaCWsCyYkXI5xLB0hHsmFaK9PS4IT0SJiZSHtJJ2Met2+i0MonYcHIndQ?=
 =?iso-8859-1?Q?701LvseEz0yTpzU9XutOCwnNHI+hcweM0zZbocjfcVxoXKM9jgU/vr8Ikl?=
 =?iso-8859-1?Q?cNx1DELRqtNUh9XHSh+hAHWGAToNpMOgPl3wf2LIfOTbv+Z3uC8HNMYn/G?=
 =?iso-8859-1?Q?NaETe3mVgZ7ARS9QFywgg25bAExs8Lbi5JcSLSEZnoOpAsFg3cFVUmnQZk?=
 =?iso-8859-1?Q?jr+d2GIhklJ0XS8waF4xxY1CYi3ZRZq3VqIwxJSJ0I6wQ1qahUQOs7sleG?=
 =?iso-8859-1?Q?gea8QQTfII34l/uJIf7NScLspA0f364oqWwBUsRh7X4dhNYUqSL92OWVBr?=
 =?iso-8859-1?Q?Ln9zBzIqLTmgrVkSxJB9qy/IufzoUtY8HFag4Xg9ZwriU8oY2pWiv1B53g?=
 =?iso-8859-1?Q?x/byh943DJidUYo/b3A+WMaLQAe4FXeJdTkpAILoDRQKS63XgGOQIxojkM?=
 =?iso-8859-1?Q?ya0X9nPwEVRVMjTeE4AtR7WLaSPDZ6OZ8uuceHrrMeFfRvF8tXxQxl6qvF?=
 =?iso-8859-1?Q?uJnjdyl1rsfx3KJwxWrA9TsvcbBZ/IA4JZ44bW9ZhVKrNv2kzkdTvcRqpQ?=
 =?iso-8859-1?Q?Pbw2qvIJpgcRbL0kfPJkjUehjAg8PL3uYz2crCkH6XkWoWHiKrQa+BKwzC?=
 =?iso-8859-1?Q?QomFiNB/wBOIOsIweHzNrUTA55ap1Ckx6El0pTJ4p5ZRS5QzvxsXyFpIV+?=
 =?iso-8859-1?Q?/I/OD4QR7G6DXA9EFrp4aH1oOyYcJHysNEd76rBYL/vSNpI6f03JbfDWg/?=
 =?iso-8859-1?Q?l3psRrdzKMO82a6oBvu4SdJZfA4iM7Sz0LzO7e+egxDS3cLHkiaAyTx5ls?=
 =?iso-8859-1?Q?PDUezxY/y1Nm38C0F+NcmNZhnqzye3/o1GyxhdeqDq8i7GxXjqtbF77HLn?=
 =?iso-8859-1?Q?1fcPrXabLHx5Nr4RtYeW12v0Fh3TgGfRRfsoX+1RbTT4qcB/msIH210FYw?=
 =?iso-8859-1?Q?Rf3KqY5XWounz9jQKBWHc5ZJ52fDCvPZF9ZfkYvEFKY7wMWMub8Sx3sZ7/?=
 =?iso-8859-1?Q?2Lt06yzyqsLQLbKIiH0p11C52hP76O2ERlYI+L4ymIqbBKe8Kab5sOKPan?=
 =?iso-8859-1?Q?CLs7MRCWezxUrChiYr5Hmr8Zs5OLQWZ6o1t4haASPinTMmLDDin/RRq8EZ?=
 =?iso-8859-1?Q?cdSjYcyW0lIWQYGSjzLOm0cSR1tXO/d3yYUSDDH0jilfmoVDdhNX8/gYWv?=
 =?iso-8859-1?Q?xA4dC4zTLZm6E3PZq5HAXaEVFfIbeIqYgX967fmCHb9FS7TNwvEMnurg?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8603.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c22357d-fc06-4269-aacc-08db2195f7b8
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2023 18:33:39.2819
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IkAnuwgxxUUx9MJ0fvE8vrjfGa9GkGvawpKQ5DDZoTg9ODeFgWz84uprnRQA2Dp4oU7QYQ7R60R2AvkuAhPTpcolIobdOexP16dyuPZJapM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6997
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ilpo,

I have resolved most of your comments in v8 patch, and I have few things to=
 discuss regarding the v6 patch.

>=20
> > > > +static bool nxp_fw_change_baudrate(struct hci_dev *hdev, u16
> > > > +req_len) {
> > > > +     struct btnxpuart_dev *nxpdev =3D hci_get_drvdata(hdev);
> > > > +     struct nxp_bootloader_cmd nxp_cmd5;
> > > > +     struct uart_config uart_config;
> > > > +
> > > > +     if (req_len =3D=3D sizeof(nxp_cmd5)) {
> > > > +             nxp_cmd5.header =3D __cpu_to_le32(5);
> > > > +             nxp_cmd5.arg =3D 0;
> > > > +             nxp_cmd5.payload_len =3D __cpu_to_le32(sizeof(uart_co=
nfig));
> > > > +             nxp_cmd5.crc =3D swab32(crc32_be(0UL, (char *)&nxp_cm=
d5,
> > > > +                                            sizeof(nxp_cmd5) -
> > > > + 4));
> > >
> > > swab32(crc32_be(...)) seems and odd construct instead of
> __cpu_to_le32().
> > Earlier I had tried using __cpu_to_le32() but that did not work. The
> > FW expects a swapped CRC value for it's header and payload data.
>=20
> So the .crc member should be __be32 then?
>=20
I disagree with using __be32.
I have simplified this part of the code in v8 patch, please do check it out=
.
So the CRC part of the data structure will remain __le32, and will be sent =
over UART to the chip in Little Endian format.
It's just that the FW expects the CRC to be byte-swapped.=20
Technically it is big endian format, but you may think of it as a "+1 level=
" of encryption (although it isn't).
So defining this structure member as __be32 can create more questions than =
answers, leading to more confusion.
If it helps, I have also added a small comment in there to signify that the=
 FW  expects CRC in byte swapped method.

> > > > +     serdev_device_write_buf(nxpdev->serdev, (u8 *)&nxp_cmd7,
> > > > + req_len);
> > >
> > > Is it safe to assume req_len is small enough to not leak stack conten=
t?
> > The chip requests chunk of FW data which is never more than 2048 bytes
> > at a time.
>=20
> Eh, sizeof(*nxp_cmd7) is 16 bytes!?! Are you sure that req_len given to
> serdev_device_write_buf() is not larger than 16 bytes?
>=20
I have now replaced req_len with sizeof(<struct>).
There is also a check in the beginning of the function to return if req_len=
 is not 16 bytes.

> > > > +static bool nxp_check_boot_sign(struct btnxpuart_dev *nxpdev) {
> > > > +     int ret;
> > > > +
> > > > +     serdev_device_set_baudrate(nxpdev->serdev,
> > > HCI_NXP_PRI_BAUDRATE);
> > > > +     serdev_device_set_flow_control(nxpdev->serdev, 0);
> > > > +     set_bit(BTNXPUART_CHECK_BOOT_SIGNATURE, &nxpdev->tx_state);
> > > > +
> > > > +     ret =3D wait_event_interruptible_timeout(nxpdev-
> > > >check_boot_sign_wait_q,
> > > >
> +                                            !test_bit(BTNXPUART_CHECK_BO=
OT_SIGNATURE,
> > > > +                                                      &nxpdev->tx_=
state),
> > > > +                                            msecs_to_jiffies(1000)=
);
> > > > +     if (ret =3D=3D 0)
> > > > +             return false;
> > > > +     else
> > > > +             return true;
> > >
> > > How does does this handle -ERESTARTSYS? But this runs in nxp_setup()
> > > so is that even relevant (I don't know).
> > This function is waits for 1 second and checks if it is receiving any
> > bootloader signatures over UART. If yes, it means FW download is
> > needed. If no, it means FW is already present on the chip, and we skip =
FW
> download.
>=20
> Okay, it seems your changes had a side-effect of addressing this.
>=20
> > > > +static int nxp_enqueue(struct hci_dev *hdev, struct sk_buff *skb) =
{
> > > > +     struct btnxpuart_dev *nxpdev =3D hci_get_drvdata(hdev);
> > > > +     struct ps_data *psdata =3D nxpdev->psdata;
> > > > +     struct hci_command_hdr *hdr;
> > > > +     u8 param[MAX_USER_PARAMS];
> > > > +
> > > > +     if (!nxpdev || !psdata)
> > > > +             goto free_skb;
> > > > +
> > > > +     /* if vendor commands are received from user space (e.g.
> > > > + hcitool),
> > > update
> > > > +      * driver flags accordingly and ask driver to re-send the
> > > > + command to
> > > FW.
> > > > +      */
> > > > +     if (bt_cb(skb)->pkt_type =3D=3D HCI_COMMAND_PKT &&
> > > > + !psdata->driver_sent_cmd) {
> > >
> > > Should this !psdata->driver_sent_cmd do something else than end up
> > > into a place labelled send_skb. Maybe return early (or free skb + ret=
urn)?
> > > There's a comment elsewhere stating: "set flag to prevent re-sending
> > > command in nxp_enqueue."
> > I'm sorry if the comment was misleading. This flag is set to prevent
> > nxp_enqueue() from Parsing the command parameters again, and calling
> hci_cmd_sync_queue() again.
> > The commands sent from user space, as well as the commands sent by
> > __hci_cmd_sync(), both endup in nxp_enqueue().
> > Hope this helps!
>=20
> Okay, makes sense now and the logic is also clearer now. However, the bra=
ce
> blocks you added into those cases in bxp_enqueue() you should try to
> remove. I realize you do it to avoid name collisions because you reused
> param in each but they introduced these ugly constructs:
>         case XX:
>                 {
>                         ...
>                         goto free_skb;
>                 }
>                 break;
>=20
Modified in v8.

Thanks again for the review comments!

Neeraj.
