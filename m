Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD8606A0679
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 11:40:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233372AbjBWKkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 05:40:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233248AbjBWKku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 05:40:50 -0500
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2044.outbound.protection.outlook.com [40.107.247.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 567D4269E;
        Thu, 23 Feb 2023 02:40:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UWouw/Xj4k6SQ9f5ncD3V1X9IiUmjSSU+wubZa+IFABQt2ZxCPtC7gjL4+jN2sg9cGecjEBkcrtaFN5M+/UNM6N3vXLiPfUycSQPT20hTOPpFpG3JVBNcUh6cZjUUcGsg2GQAlZkDbHd9fZmExiw0ayv0+rLuFbaQ/pwTOrPxHd2oRATmON3lNzXjnKuFslio77pPdqZ8RXkcK0fWkxKSH0qGjosluXuiRm/uV9bn0sB+CTGdq6TekkXCTCoo+kf61uWAf/q9SgasKkubAn+1cWANCOa773Ifs3991awJu5MFRoY4sMMN5yFU9oHffzt+Gr1aglGe/r46rAW+OIaMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OSwIeIS+Gx3HVz2c0h5Q6TOY6T4PFiGtFdsiGogpHLg=;
 b=aDxP/16i0Z4qgQO4kTH3DnqJ/3noLPle214rRlgrsTtk0/Yo3S3EIImD7+Mu2UefG8QkUgyYXZc0vOXd5s3AhWpZV4sBlfRXDDA5BQMu8QVhzfdHsdaDVFq4J+EioN4Wd7LvJetbYkSgHuJ4RHu1EPN1JslfOpArcDdQkvuh3YFEtJ1OlhMxAHpeYNiCugZ+SAMVvfEUd/dOj7eL7P+WxN1vPq4qvFyUEbOCpgkIpkfEZCv+VtfZWWfJjMtFyESpZnrJyhSyQfmT6GuRN5dbFYWY3RdRfkYQrgsrZp5rjh9znmvK6ekK6manLJkjikOH7cmzs2iyR0IFay+sZraXkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OSwIeIS+Gx3HVz2c0h5Q6TOY6T4PFiGtFdsiGogpHLg=;
 b=AYqOHUD7q+fNtloVkbadAYSRa3+VdR5TRtpZqaY/m31/qm5XGwaWa3JNf2Wkw+tYrUOyg8lwqaMO8CDxgK+OWyQFhEkMYZBbCYITnZRegv5jSCIHSALKsoyLCNLbEqjeP2OD/f41bkyvzCJZmIz4QMjHnNHJKq4OMcPMCTL1/qs=
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com (2603:10a6:20b:43a::10)
 by AM0PR04MB6945.eurprd04.prod.outlook.com (2603:10a6:208:17f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.19; Thu, 23 Feb
 2023 10:40:46 +0000
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::f8fe:ab7c:ef5d:9189]) by AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::f8fe:ab7c:ef5d:9189%9]) with mapi id 15.20.6134.021; Thu, 23 Feb 2023
 10:40:46 +0000
From:   Neeraj sanjay kale <neeraj.sanjaykale@nxp.com>
To:     Greg KH <gregkh@linuxfoundation.org>
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
        "jirislaby@kernel.org" <jirislaby@kernel.org>,
        "alok.a.tiwari@oracle.com" <alok.a.tiwari@oracle.com>,
        "hdanton@sina.com" <hdanton@sina.com>,
        "ilpo.jarvinen@linux.intel.com" <ilpo.jarvinen@linux.intel.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Amitkumar Karwar <amitkumar.karwar@nxp.com>,
        Rohit Fule <rohit.fule@nxp.com>,
        Sherry Sun <sherry.sun@nxp.com>
Subject: Re: [PATCH v4 3/3] Bluetooth: NXP: Add protocol support for NXP
 Bluetooth chipsets
Thread-Topic: [PATCH v4 3/3] Bluetooth: NXP: Add protocol support for NXP
 Bluetooth chipsets
Thread-Index: AQHZR3NJNMeQaxHX80659kDSqon6Tg==
Date:   Thu, 23 Feb 2023 10:40:45 +0000
Message-ID: <AM9PR04MB8603910A3247C4649648C21DE7AB9@AM9PR04MB8603.eurprd04.prod.outlook.com>
References: <20230221162541.3039992-1-neeraj.sanjaykale@nxp.com>
 <20230221162541.3039992-4-neeraj.sanjaykale@nxp.com>
 <Y/T1uMqUeW67tgzX@kroah.com>
In-Reply-To: <Y/T1uMqUeW67tgzX@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM9PR04MB8603:EE_|AM0PR04MB6945:EE_
x-ms-office365-filtering-correlation-id: 37651d70-2489-48c6-5461-08db158a6bb2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Slqch8tv9y5uETXeBNdrOVvVo1lv4MKAOrtU9aRpaEvBlBGRk5+YtRG8TxUVcc5b8g8z18YydwoIkH+4oBTmqMml3BR0DkqD2tVUgMhL1uuJPMFr1WuglA+VP75PiRr/7Y8wDpMNDSPGT/BXkmsaq83UVu0HHB+BFpZNEcIkloqLwdWPpao7OwGzArI1tWOF4UQpsLBic+AetzeV8EJ2muSYEVMBEOqmfJl4YCl0A9BuzArbE44wLT/+Y1d4yDtnAE3ha6nXInyVtst9EYwUQ8jVuTa2DU3gmBC4LIWeQAq4eu2waXVkdszCNXixEKd5+VZvmtdDmOXx03r0yxr+zstbKB58AkSs6IHdjhFDm4eCFFwkPOz60Jk2NpY4iAuIZeswR7SUZ7eVSqNvJPDjSOcld1jgRb8goXzL3BBLurbD21uSJWr1nF9KUIveKQCVKimgaM98e7Xglzo5r+BdrtnYHQxdpOmWUw1MNzTgyZKjm1XDWNNSFtndlAFnN7wCGZPQQApkJ15M2K4yt88dZYAERrT99T7Gi2feG+BN9lwtKY+XNihgEyXuh0C6wZxOeNC/xhwpXCMBIwzLyoM0Jv6qWsYnD8z3/lcpPhFCzQUJJjEm9hlGVGCSLOPETsJfHQqtHFsMfwlSDtdKCBPvTQGs2aSs/CBT1sCRctB7f39wfZtYkW4fibTiIvkwUCRDaGd3FEyjMOm+HPMGFmDjRw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8603.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(366004)(396003)(136003)(39860400002)(376002)(451199018)(64756008)(76116006)(52536014)(55016003)(66446008)(41300700001)(7696005)(9686003)(186003)(66556008)(8676002)(26005)(66476007)(6916009)(8936002)(33656002)(86362001)(66946007)(4326008)(83380400001)(7416002)(6506007)(5660300002)(122000001)(316002)(54906003)(38100700002)(71200400001)(478600001)(2906002)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?mdPVU4w7H+tsByCbpI1CxU75aPOJ56AlOt+GhHfoTee3zHRpb7zr+vgwXhdf?=
 =?us-ascii?Q?LrAoSrZYkFe4g+dWBOvq0a8bq1XdGLscUC/twIEgFjlxN3hdrHciJ26KCb6a?=
 =?us-ascii?Q?LKIas3BZer1topeNQErExFg+v0jdxrDLfblLfFO3xzn0pQ46ZdlniR6ZkP8S?=
 =?us-ascii?Q?6gTtEtVmQvK4odJkEbT5i1A40x7ZKyDVWRyv6gtxNNL0OqbbH/a6N/t0R8EK?=
 =?us-ascii?Q?5GVn+ArKjdLq1WYUVUCJNezmmXe5k04mwZsNcVp9xsJlPQAW24cAhiGYqofE?=
 =?us-ascii?Q?pVqjIxcvwv0ZFR69wiL+2mUZ8XRTjS3WM4NyPKOKaf1I0XRJKJi2A2qmZcu/?=
 =?us-ascii?Q?TkPXEU+WQ2iEzSuPHhEKfj79xmZDmER5LezRc885ANp2UxrlghESZhkI2Cbx?=
 =?us-ascii?Q?DQM8lWhyDY5lwKSk25kQLtmZZ4n9VfxwxL8bOgQc88xFXbpYNUN4KYn3uAxS?=
 =?us-ascii?Q?n2GPsSAKCGikJKC3Ck7j8G4wkeY4IFjFD30qQoSci/ir030BeH+YX6D1TErY?=
 =?us-ascii?Q?13rt/sb7kKRdNHdFsPQDZcTrek9CyhUc6WPBsIlpMxoGnEi1DBnUnGn9Ncx9?=
 =?us-ascii?Q?o4xOCGbNmH95pt4E/ijOqjvS143IDPhQz0RNTkDjQuy3D3ROKNDSFrJ120XX?=
 =?us-ascii?Q?bA6f/hCAvJUhpvWnVHi0ACYajarkmDuaWgEMwHRTMluXfF5RFUsUbUYyi/yK?=
 =?us-ascii?Q?5eYOZCzNcD4kCehsD3EnJareivdGVVnn3XLU94mrf+rSl6/f2MW0ysiOUJmy?=
 =?us-ascii?Q?AoK70rkw84s0JOtcYUbColKtEHPG/u/1ed4WmBqyY4OTIQFZdXSkUm0S4SnA?=
 =?us-ascii?Q?h6lQAU2mmqMq4Sbh9ljO6K9wK678Fxrfmc3z0gcLiBOHYGJo9AS/GJAtdV+w?=
 =?us-ascii?Q?iYkOv7jAusA8qffFw1sBrMO6t+ne9mGYXkZ1hG8wKJ7O5kxlBBOCukU/tns+?=
 =?us-ascii?Q?vs+l6JxaedquoeDE3oCxqHDsYtIrLRzDBAGTfM/sBWyjPElJpIH3aqMUYg7A?=
 =?us-ascii?Q?ZzMN+LxHTi+Af1AcOzxc0C5N3XCy/VQ6IVJ12t4f14E7oOo2Gc4ZuQMoOa+4?=
 =?us-ascii?Q?Pag8ZhHue10AgP6VUPV83uUjp327L0AbrbK+zzLryrYX4coTMtTmMeowADJA?=
 =?us-ascii?Q?FUvD4w6SH0hs0iCn0xUh1X4rFp2p8buEgyQzQgCXq+1fRg+eWF4ZCExLwfWf?=
 =?us-ascii?Q?pF78whPb07AbrzaxM0kxXIfzl5OJwYEUQLNFTjbVo6+kDZsfBl379dtQ/0Gj?=
 =?us-ascii?Q?ltfXN2GCirUCSfrtADwSE5sX+pNkQM/K69megTT7FN2cqhg3Mf741tEZszQB?=
 =?us-ascii?Q?+9N7wUGr+kyFEdpXJKRS7QEKlC77AHGlB+XY+YcyQ/Sbyc9ZnAz0D0s2Jt+g?=
 =?us-ascii?Q?H1ihS13uxN6SyV0UnBftsuVt9m9neEwO7cH0/4gjppA2w76Dkg4sbb9YjGSp?=
 =?us-ascii?Q?OEIxi2lSbyYlWmmEQwE53wkjdPnAOa4ddw8J97HIW6Gk0arw92rIBx0EsGee?=
 =?us-ascii?Q?3qdIQoWGAa835ZQNZ053oIl0jW57O1M+j2viTk+k7XJ+XY5aIiuvR96ViJcX?=
 =?us-ascii?Q?HTGfo9Tkge+SUdu00B3Yv0VNMOwizsfiYZI6wCGnpAuhPEa+XQKf6QuOHJBc?=
 =?us-ascii?Q?Eg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8603.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37651d70-2489-48c6-5461-08db158a6bb2
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Feb 2023 10:40:45.9263
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2AWy27pIhYhbT6rGjP4JvcG/AKpaB7kthGOzkERJr9T1v01y0yD3ZLnCGuCcGYTwCV5P1ayxcOzcoBQNbKDlcoC6cTEohMOwaXD2lQxi2OY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6945
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Greg,

Thank you for reviewing this patch.

> > +             bt_dev_info(hdev, "Set UART break: %s, status=3D%d",
> > +                         ps_state =3D=3D PS_STATE_AWAKE ? "off" : "on"=
,
> > + status);
>=20
> You have a lot of "noise" in this driver, remove all "info" messages, as =
if a
> driver is working properly, it is quiet.
>=20
Replaced all bt_dev_info() and bt_dev_err() with bt_dev_dbg() for all insta=
nces where user action is not possible.

>=20
> > +     } else if (req_len =3D=3D sizeof(uart_config)) {
> > +             uart_config.clkdiv.address =3D __cpu_to_le32(CLKDIVADDR);
> > +             uart_config.clkdiv.value =3D __cpu_to_le32(0x00c00000);
> > +             uart_config.uartdiv.address =3D __cpu_to_le32(UARTDIVADDR=
);
> > +             uart_config.uartdiv.value =3D __cpu_to_le32(1);
> > +             uart_config.mcr.address =3D __cpu_to_le32(UARTMCRADDR);
> > +             uart_config.mcr.value =3D __cpu_to_le32(MCR);
> > +             uart_config.re_init.address =3D __cpu_to_le32(UARTREINITA=
DDR);
> > +             uart_config.re_init.value =3D __cpu_to_le32(INIT);
> > +             uart_config.icr.address =3D __cpu_to_le32(UARTICRADDR);
> > +             uart_config.icr.value =3D __cpu_to_le32(ICR);
> > +             uart_config.fcr.address =3D __cpu_to_le32(UARTFCRADDR);
> > +             uart_config.fcr.value =3D __cpu_to_le32(FCR);
> > +             uart_config.crc =3D swab32(nxp_fw_dnld_update_crc(0UL,
> > +                                                             (char *)&=
uart_config,
> > +                                                             sizeof(ua=
rt_config) - 4));
> > +             serdev_device_write_buf(nxpdev->serdev, (u8 *)&uart_confi=
g,
> req_len);
> > +             serdev_device_wait_until_sent(nxpdev->serdev, 0);
>=20
> You are sending magic commands over the serial connection, are you sure
> that is ok?
Yes, we are sending this only when the BT chip's bootloader is requesting f=
or payload for the CMD5 sent earlier during FW download.

Thanks,
Neeraj
