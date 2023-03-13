Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE1A06B6E60
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 05:20:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbjCMEUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 00:20:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbjCMEUF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 00:20:05 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2057.outbound.protection.outlook.com [40.107.15.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 885DB2A15C;
        Sun, 12 Mar 2023 21:20:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kNlDkPo77GRddcSJxQ4EOFIJAft6foIUQF8LEWUnTFnN5hyN8aF9ArPpvFwCwaNJbgTMx3U9zYQXIc21qqJOwCAGj0PCPyHQl6rU98MyJlMDKn3LsJsZk3jfiHVqFI5QQZCxVp2G3qOXVwj3KRBgpW8bnmvCMrpOMJwQ2aPggFDiNZPv2MxvAXpbfuqFJccC3vZBNyFJSThWEWuLIOfPvNPfZThu/h5CyJVdo6qlG99cfkqXG4fQj0835geSbIdrewJweDHantal7DA9vN93LguwXp1h+H/64S5YsMQvMwvInSVFLCbkzSs5nVu0/ztnTr/Hvt1Hsc/89aeLXmIJRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=paD4DchBs6Er9Yy4y14kS63xzYN9pT4JpapCKrc9Nfk=;
 b=LOPGT5s0GMyQNYilOM4DXFkPfh7KyvZM6/ZW+b5ApYmnLAD9BqqW1w9S5JkPrHrVtzq7XkcO7nT7sTYCSxvoz/ChL0p4FDOWKP/0aA6YG958/HCzNvf9SSp9fYdggMsLbkb2z3snuQas3wdE2iiI5nvTCXchZucLUq9Y32xmqoFUHmUTMe8+tXHZTh5p5J5HhlkZ2b589b5cB9/dm3AUtSCqwAnUJNGekODNgjzfkxQVM0b1nw2v3jNvAw5NoOVXknw8qr228T+FrpIiaBcggxxTlE+JE1rGuShrVtACrDqE08E3CxRTVDMLz6taVvKAA/u1E813DE9/cHBn8k0d+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=paD4DchBs6Er9Yy4y14kS63xzYN9pT4JpapCKrc9Nfk=;
 b=Ycf0pq5Slhp9aJnK+FC0C0eea7rlZgM4ClDNnPq+uQ6V+skXynTmvNZmpFCWbY9eQw7ju6ggS8TMLyKEatAQIQA8/Xs/+jiEZSIyVKSjGP7BLT5uRh9du3r0IySaf5vB7ol8szD3JPJDhdiRaubLCaAjjLXdmEYwbjVtjH4zdM4=
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com (2603:10a6:20b:43a::10)
 by AS8PR04MB8086.eurprd04.prod.outlook.com (2603:10a6:20b:3f6::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 04:19:59 +0000
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762]) by AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762%5]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 04:19:59 +0000
From:   Neeraj sanjay kale <neeraj.sanjaykale@nxp.com>
To:     Simon Horman <simon.horman@corigine.com>
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
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
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
Subject: Re: [PATCH v8 1/3] serdev: Add method to assert break signal over tty
 UART port
Thread-Topic: [PATCH v8 1/3] serdev: Add method to assert break signal over
 tty UART port
Thread-Index: AQHZVWMSA8lSGgT3OkG0NPPUzZM6KA==
Date:   Mon, 13 Mar 2023 04:19:59 +0000
Message-ID: <AM9PR04MB8603CD84C41775AE83CCDB88E7B99@AM9PR04MB8603.eurprd04.prod.outlook.com>
References: <20230310181921.1437890-1-neeraj.sanjaykale@nxp.com>
 <20230310181921.1437890-2-neeraj.sanjaykale@nxp.com>
 <ZAx1JOvjgOOYCNY9@corigine.com>
 <AM9PR04MB8603EDB41582B5B816993B12E7B89@AM9PR04MB8603.eurprd04.prod.outlook.com>
 <ZA4kG1gG2qoEGZLK@corigine.com>
In-Reply-To: <ZA4kG1gG2qoEGZLK@corigine.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM9PR04MB8603:EE_|AS8PR04MB8086:EE_
x-ms-office365-filtering-correlation-id: 2d6d55aa-39c8-4bb6-c165-08db237a3569
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zxyduras6UixuhJNKcRc5s+UHI3yvHIO0x2z7bnpaIsgD1vdoTKruqhMjmX43JT4JZCr4SunjiFlsDI8HecMtTs4dI1lFkOtTUzKTwHiOxomM4QqszK3bhA13WXS3RB8zqyFiizFwoDomCaoZoOHbfi1SnA4/biLyLyi9Hz3af44cwndqWwTc9UP1hk/0iAF9+pGq/QMNowsKUrD08IWc395+w8ez+m2udYT2CdE57CbH02cSaSyu0wJiL9V/OyjtZIwn712KOhWkpegAux1GioNUW0vZyKZIRGlInwz7SiZglz2Mta+4NpnXwylrb9Sk4ONRhk0YrC3B5ytdPcB8p2jxLcuSwWAeXA21EF3HXOPMKyjxSbXGKJ5wJXN/MkaJH7ddJmN4wIt2aGUQv0sXUCUSCgIhOFU8PAjLVGcn7mDltgkZyZZvl5W6EX+6T8TolTdzYqllLx/h4Q/y5ykz33m20Jfp/9S9mkRn+hdLx+d2S+MvdkEO4S+cFz5Kph1i6xREOTkDPWtRRrleh3gDD5pfOak1g2geoNO/ujRP5sJf3dFW01Ur1xSP/mW43l7niUQFxBQZAGRMazPYbrjGO268i61GmFV0EQtXQq8Bez+ZeahTXpr3EOfxZDIqTpYCeFBaDnWy96Qt2yJpHNtM0Q0iYSQpSzOkvn0LGmyFu2sUu90Timap6S7E8IJCJXoUDKoZuIeCZkfKBZazQLOsj9dwCkMTGI59pUOVgHPnePDUfXqmFqqqxIzbGdWIz0C
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8603.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(366004)(396003)(346002)(39860400002)(451199018)(9686003)(4326008)(7416002)(5660300002)(8936002)(6916009)(52536014)(41300700001)(186003)(55236004)(6506007)(26005)(33656002)(86362001)(83380400001)(2906002)(66946007)(64756008)(66556008)(66476007)(76116006)(966005)(8676002)(66446008)(7696005)(55016003)(71200400001)(316002)(54906003)(478600001)(45080400002)(38070700005)(38100700002)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?K/+ZzKy/dZNZJZs5HHrHf2BuLtLSV4omXRMv0qo8Bn7lFDzth9kAqLUytfdw?=
 =?us-ascii?Q?u7gU+qA5Aj8ysLQV/9NMz8699kGIUlFFfD1LzrGLxNFyEiO4aJFimNfhs1pp?=
 =?us-ascii?Q?+gIXdjuf1rKEaqkI2Zl7AYF9RlUJAcOGw6tbUPIZFPfCh2qi9h8cLP1H6AGe?=
 =?us-ascii?Q?VeTyzj6dAAFkMvAz3tEMDVPOSrAizpIdkRphIk9w78bRiIRcxYU35xYRNOdV?=
 =?us-ascii?Q?q6Jv2BzOfxI1vnepwigscih2n01ce4tIe+Kq/mx4wsi5PL8upS5GsJdrxw/V?=
 =?us-ascii?Q?QMqAEOcXIihhq1HMkr0L8Dw5FMxikK/7kdugT7ehtz8MyfAbfe14B7/1KjGA?=
 =?us-ascii?Q?fOZQHGLXMs3RO/z0MiA2/IbDE19nQaknbdRXf/JDoURmtRbN/6pfnXa3V62T?=
 =?us-ascii?Q?dYrUFdjm1MDyQp12HFWYyJW2XYzjgDyTgsj+I43D7P8NUqxK1vPWhD9A5sFZ?=
 =?us-ascii?Q?BcHJjC4RcnaKKizWSwqTcUh9OnTVQaTuMInnB23gYWvsbG+S3C8a91m/Q5O0?=
 =?us-ascii?Q?evDZIw962nQtoOaucbBpFDSWsS6hf/UrBLWmDLeZoBz+aHP4eAZCvhebbQy2?=
 =?us-ascii?Q?DoX41b3C8KjLmVV4NW8/1heTmQFT6bNeOPOYtfpBDDxy/67Rd2vWWyPqA+FJ?=
 =?us-ascii?Q?Fr09iRYFoTcbi7bBU/1rgbnRgv7Y92ZYnUQPo5QsHkAytLtV5Puw7Hj7gf5p?=
 =?us-ascii?Q?rwKyJaFmspZLeGdP/Qp9kxKQOi3FjDVSTcj08F7lkd65K/+JkfRrXsda/5GC?=
 =?us-ascii?Q?W6JDGaAp/AShP3v+rqI9D8m8Mjhj7wPNj/RZ5+jCXubOnFvowUdx23dgbMqj?=
 =?us-ascii?Q?iad48g5FczCJ5+aYMMDgIFZkLo4TJ3/chVKsqAckx/g8ZXkruKmN1ixIL6fU?=
 =?us-ascii?Q?ThmPxd+ABq5Z1ojB9A1PIFOM6MVqHNzuQYlF6ra3tO2artbUUD//ahKkP5Oc?=
 =?us-ascii?Q?V7roFVKZuXWQYja4Gc+o0lUcLI/hcIMjRJSju/TzTGSNHQpVuz9gGSN6z10j?=
 =?us-ascii?Q?+izkAl0AE/kfIBr91+zqST4yFDH39AnsOPMmADDrecGLDdEZyK8gSXrPPzes?=
 =?us-ascii?Q?S9+43zeTDBOAT6PTzn2iPydK0qw/m9R05Dq5DVq39kLCWERFQUOjTdJv27xR?=
 =?us-ascii?Q?aqN7eiofbrolkh0Xmr7bRJBu6kNeQBPn5Vd2ab4l+nHOgTNBxk7Zq42gVuy3?=
 =?us-ascii?Q?8jtjtbfFV6/kWMWzwdevw8obwdFm6wnf5xlp3HjPPQyPVI4ozF30EA5obTQN?=
 =?us-ascii?Q?hWinaBNAceWIqbRgNA9TRxNO41/nyHWfVq2r2ZGO3+ZcAnsn6XgePCVRnbPj?=
 =?us-ascii?Q?27KfHFyWEHXFke0XCILKI3NCzPU65JZ3T8BjZ9ok5UMMbvKvC3ByIGQQjYbN?=
 =?us-ascii?Q?kNXGiH6vj8oglrb4ymN4V4CNehNCzDKI0lYdt1lCabDIoOE2ff1HoOCXjzqP?=
 =?us-ascii?Q?ep+jNJd25eAfjO1NV8KO8tQ8MJFNxkPY80mDcZ54l+Vm0weglHipnN1fQcwl?=
 =?us-ascii?Q?E8AUVAjkQ534ZqznRU7NW34pW020EKWxYPMLUvzgg6MGlVM9yiCiyGGndkj+?=
 =?us-ascii?Q?SMZOENzLP9puZKCVe3X+3vGKtGa4VdgoI7AWut42Jm1dTxRD4pKmnfzB5mmz?=
 =?us-ascii?Q?UA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8603.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d6d55aa-39c8-4bb6-c165-08db237a3569
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Mar 2023 04:19:59.1851
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bnTFfxQf8zPOSHNEbCKpH6UjMZKoYPO0IP02mX7SrLXug2/zzZIO3Zz9siGpyNQYiDAmPSGntNS80wTyQFWTAOJpOtul4bV6/cea8OBKU9U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8086
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Simon

> > >
> > > On Fri, Mar 10, 2023 at 11:49:19PM +0530, Neeraj Sanjay Kale wrote:
> > > > Adds serdev_device_break_ctl() and an implementation for ttyport.
> > > > This function simply calls the break_ctl in tty layer, which can
> > > > assert a break signal over UART-TX line, if the tty and the
> > > > underlying platform and UART peripheral supports this operation.
> > > >
> > > > Signed-off-by: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
> > > > ---
> > > > v3: Add details to the commit message. (Greg KH)
> > >
> > > ...
> > >
> > > > diff --git a/include/linux/serdev.h b/include/linux/serdev.h index
> > > > 66f624fc618c..c065ef1c82f1 100644
> > > > --- a/include/linux/serdev.h
> > > > +++ b/include/linux/serdev.h
> > >
> > > ...
> > >
> > > > @@ -255,6 +257,10 @@ static inline int
> > > > serdev_device_set_tiocm(struct serdev_device *serdev, int set,  {
> > > >       return -ENOTSUPP;
> > > >  }
> > > > +static inline int serdev_device_break_ctl(struct serdev_device
> > > > +*serdev, int break_state) {
> > > > +     return -EOPNOTSUPP;
> > >
> > > Is the use of -EOPNOTSUPP intentional here?
> > > I see -ENOTSUPP is used elsewhere in this file.
> > I was suggested to use - EOPNOTSUPP instead of - ENOTSUPP by the check
> patch scripts and by Leon Romanovsky.
> > https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fpat=
c
> >
> hwork.kernel.org%2Fproject%2Fbluetooth%2Fpatch%2F20230130180504.202
> 944
> > 0-2-
> neeraj.sanjaykale%40nxp.com%2F&data=3D05%7C01%7Cneeraj.sanjaykale%40
> >
> nxp.com%7Cf2ae2c9ad3c243df2c1a08db232dc0f1%7C686ea1d3bc2b4c6fa92
> cd99c5
> >
> c301635%7C0%7C0%7C638142451647332825%7CUnknown%7CTWFpbGZsb3
> d8eyJWIjoiM
> >
> C4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000
> %7C%7C
> > %7C&sdata=3D6cF0gipe4kkwYI6txo0vs8vnmF8azCO6gxQ%2F6Tdyd%2Fw%3D
> &reserved=3D
> > 0
> >
> > ENOTSUPP is not a standard error code and should be avoided in new
> patches.
> > See:
> > https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Flor=
e
> > .kernel.org%2Fnetdev%2F20200510182252.GA411829%40lunn.ch%2F&data
> =3D05%7C
> >
> 01%7Cneeraj.sanjaykale%40nxp.com%7Cf2ae2c9ad3c243df2c1a08db232dc0f
> 1%7C
> >
> 686ea1d3bc2b4c6fa92cd99c5c301635%7C0%7C0%7C638142451647332825%
> 7CUnknow
> >
> n%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1ha
> WwiLC
> >
> JXVCI6Mn0%3D%7C3000%7C%7C%7C&sdata=3DwFgYY6VnZ8BBn6Wme8%2BYj
> aJRy98qyPnUy
> > XC8iCFCv5k%3D&reserved=3D0
>=20
> Thanks.
>=20
> I agree that EOPNOTSUPP is preferable.
> But my question is if we chose to use it in this case, even if it is inco=
nsistent
> with similar code in the same file/API.
> If so, then I have no objections.

No, it was just to satisfy the check patch error and Leon's comment. The dr=
iver is happy to check if the serdev returned success or not, and simply pr=
int the error code during driver debug.
Do you think this should be reverted to ENOTSUPP to maintain consistency?

Thanks,
Neeraj
