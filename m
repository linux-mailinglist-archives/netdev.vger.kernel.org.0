Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2C16B6397
	for <lists+netdev@lfdr.de>; Sun, 12 Mar 2023 08:01:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbjCLHB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Mar 2023 03:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCLHBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Mar 2023 03:01:24 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2084.outbound.protection.outlook.com [40.107.15.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 992E459414;
        Sat, 11 Mar 2023 23:01:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z1C7h/7B8C6cAprnwTkovhF8/hqlnnIfxCfoYBsvHj6YkKdmBmFYWq24yUY0AfkXmFihJX/qNP5gLq3FyRDv1xoFj6PIrlrSst0v8YF05R28r1Zwwlh1JFcU1c6WDejD5J4R2ixoxxBCErR4TWs40aDRJoE8ZP6NV16d8KQS34A3JAV9ymjQPt6bHrPIMeq9XkHJrpBMkSrCdagQwh34Q12wifdD+qmk1vyDXicpRyOReyAU30WyO+NbJvOWjR4Tw4rYKzAZ1m+MYGhkPbooEkqYFUEMMD2PnpjXgyDkln3ypoWiL4hpXKkaLDj9GKL4/AbkyT3m8FEkqC5+cDHB7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uC8MgtKCeNNcd3KrRDVoylxM2ZqEB4CpsWqvJmgmvRQ=;
 b=hYO0gZCDPMK+/0eSnX5ZIbAPNxiu7pskJPxKc2r5vNKYZTR1xJ/0HwgRq4LZG5VPJ4Xk3dxQ/HQEB7ddc3CTdi8ADPxQlZKWYSEPR9KVrbAbnSIw04xYdflsbm9x4wJ1sNlIx3yio2sOV3tydZqHlgU2MdVmwFik5LfuqnR4lI84MvJ9he45a75cU5woT9HU7lmcaZyjYk6O381iTaf3A9z6gZBteRXIa6P/8J3lQgZ/RPPN8x2bi1hkoAiLDG6NP3vTvkLTfDilU2syviLmzUd1TFJ5o51wMlnqiEDpteIB3BnInNoQqwdayAJM8FMw0cOGooGawPV19KR7ASieBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uC8MgtKCeNNcd3KrRDVoylxM2ZqEB4CpsWqvJmgmvRQ=;
 b=HI0W/nAVPy8rdLwjxts3g5qZamO7xG8uA/cqK9Msy6vV4ocDiNxPBIRMHCLudAnT8OeNmN06grXPbxyNIq523qomAKiAiFWHAqgHUuHqEVJuEHBpNvmfulvpp0ONiYnwqt1kSMQn1XUhZeE3OkMD1jpq3pA0kvc3OY8hOoowiYI=
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com (2603:10a6:20b:43a::10)
 by GVXPR04MB9901.eurprd04.prod.outlook.com (2603:10a6:150:113::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Sun, 12 Mar
 2023 07:01:18 +0000
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762]) by AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762%5]) with mapi id 15.20.6178.024; Sun, 12 Mar 2023
 07:01:17 +0000
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
Thread-Index: AQHZVLBx4j9x7ZOdd0mla+luXOKNmA==
Date:   Sun, 12 Mar 2023 07:01:17 +0000
Message-ID: <AM9PR04MB8603EDB41582B5B816993B12E7B89@AM9PR04MB8603.eurprd04.prod.outlook.com>
References: <20230310181921.1437890-1-neeraj.sanjaykale@nxp.com>
 <20230310181921.1437890-2-neeraj.sanjaykale@nxp.com>
 <ZAx1JOvjgOOYCNY9@corigine.com>
In-Reply-To: <ZAx1JOvjgOOYCNY9@corigine.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM9PR04MB8603:EE_|GVXPR04MB9901:EE_
x-ms-office365-filtering-correlation-id: eb0b2647-03f9-4d9b-b9c2-08db22c793f0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0/Oqc+v2gQJG0IEIozEtuYY/ITbFkREBZPkN6OGiabAnfly27whAFDnD+h4OzYxB3FZ6fnZMqD0YPaCr3Gkm8iswpSXM1oy4Zi/0cY2NZ8XH/4upXdNLgkA1oOs3TDZaxpyL6LdPSO0Z+HZKriW/ppFF4ytzUMFB2nZ6yq6p8VmNYuypiGeFSY/PM/4a25ZabC0uDIz56Nu0O+4KYw1EMp1v9TkOcCRwuztxUbRtO86jsZrT8QlkjdiS1veoEkwae3SyDrrkDL0KiQeFQJvqxaugE80LvEe8a9EJsifhSozNNO9Tk5NcEtiu5axnXrkeZ9pXiPuTOIQiuYNwsYKD3w0iCsr+4H5HvQNEifzNYKHuU+77rd+4/Yvr385gf7nT8fmOWbru9K7GBZ0C/W1wpxIY/jmW7BL2aT6sDIAhuAk2UJqEPo40x3/+xWK1PCMXpKpCcbRVz6YLiUGcjvRkOFIi9Qbdm4gxKFlG9M5xik/ntsd+4uGsYsbSeLrgkgrsbUX/xyaA53RZz+B/nHvVPC20g+EsAXcmPUx6GxOcrXNv9nak/NocqFmG7gs+edwdqgwzdUpyZX0ryghhW8Eat/Bd96GTVYyifH/Zk1U0y03s6sw9i5+1NlXeVHJrlj0R5QPYdbMlWCNhxDd5d+z+73HdHtalRPgQDT03tBeZJiunNX8phB+JjgA2506td/wnyjiuRi/Y48M1UjByGra1wK05oj9/wSlKAivI2Amrba0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8603.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(346002)(39860400002)(136003)(396003)(451199018)(478600001)(83380400001)(71200400001)(7696005)(122000001)(2906002)(86362001)(38100700002)(5660300002)(52536014)(8936002)(33656002)(7416002)(38070700005)(76116006)(66946007)(66556008)(66476007)(66446008)(64756008)(8676002)(6916009)(4326008)(41300700001)(55016003)(54906003)(316002)(26005)(186003)(55236004)(6506007)(9686003)(966005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Paz+K5YIoglQWO9Pcoz+y0wrxuXB6NQS+toRaT+FXn1zySOnR1Xp1Wc/iVto?=
 =?us-ascii?Q?yqb9/LZnGEBdz+Gpt8v2d2hphLSpiFYJkSQQI2ywNLfl8CzMTtwkFN1J4BIA?=
 =?us-ascii?Q?LUN4h/vLNb0/XHFDpNGG21EtiJ3TCJh5wZI18kMDgmIDBKn6JCsIHXgAeN3C?=
 =?us-ascii?Q?QD8UKQsmap6wAP1UHVr2EU14N5fo0DHSvdDv56eV83vvFLZFB08zwdp7Qntc?=
 =?us-ascii?Q?sSM8EI+xT+IkugVqaNzQkKKrbu7LE5ZNPUed9oUqUXSdENoXUJlXHRftuZNv?=
 =?us-ascii?Q?EStnGiJWtaDPUw/JONmQDSDTepdLOw/yvIev3yqbGCtKzlijJ4DWaGo5/6AZ?=
 =?us-ascii?Q?MkiKGSk5Avla9F+R2KwK6/uMTTvap9t58t+pp6rhN/8XeAYFuVCC+Hd3Mi+t?=
 =?us-ascii?Q?LHRpw2j4JHRCyYNOCOznj61oMFlF0+ET8stF+SDquu23Mfg72N7zw0kSW6NM?=
 =?us-ascii?Q?LxHHgNzgmTc5ta729fz6a/5JAbD4MJc0UUWyJMH4on3mfv3putAH/eaOMNel?=
 =?us-ascii?Q?hEfrYTFhsLpstDzSqd8J6CmIkNr0YeerkpeGMVMsvTqZ1r/vGs6yc1tRxI1Z?=
 =?us-ascii?Q?aD0Tix52rLKljX84M9N2qt8qj7v3zuSFdkL5lAgMC+tfNtuS2Rc5UJf3Najq?=
 =?us-ascii?Q?9XZkVP/wal9ieLPPzN32DSG6xmmhFPmBHqq240yg+qMMbuiIMxLmfAsD3KWZ?=
 =?us-ascii?Q?A7E5MEJNbiF8+3VNFyA1kFRZczAeQzaJMxKeR/S/pBaUwyBUfJcx0cseXVry?=
 =?us-ascii?Q?XzT91zzJzypElPcd+vDQR1dXkpfeQI3HpwhQHDW8SYLOCgNBzwJsePWzlbGy?=
 =?us-ascii?Q?EhGv3Oq/jGdnXpu6rbBmu52AW93NaBLYYmcGcRxR/o15Yq7SHHJKIci3Nkce?=
 =?us-ascii?Q?P8DIOrKjzNJi+U1zL5MWDyn+wWIC0aonaY2h6yoLb5C2MU/xXezIabw8MOkV?=
 =?us-ascii?Q?iDl0MWkXRGnna7cCbAa9q+HU2UOT3jH5nRr/nQDG6BlN089HT6s0LX7Asu20?=
 =?us-ascii?Q?IAE6rQ5PoTxjBie1T2eGUydvPJxgHxfZut+D/pQFQwNUaXrKYRV/phJ7N4WY?=
 =?us-ascii?Q?fAfqpLUUiP55dX9WyEkJ4teyCuzAzIcd0bQtR2uOnOtM+piQG46avFrD97dQ?=
 =?us-ascii?Q?NPM/C0WaSRj64ejA/RnvZhr9dcYOhKfCQUYsMvRockdta15ck/WcvpJV51/v?=
 =?us-ascii?Q?XyfxERCByPbCBOptm4D55UfC9xF4jGnXJsEVcMvZheBRU4XT/Qmqg9N9g86k?=
 =?us-ascii?Q?nErUi63ZH6UA10m6TV2nle8MuxZCyxsDIt79HXBRJ9OiJJKI1cAKion8o+2R?=
 =?us-ascii?Q?+b8w4M15YFAegaDbGpO5APgvbl+Qh1QsJOVKCFjiYqMBzn9lbHKPFeFesKYc?=
 =?us-ascii?Q?IL9ho6+rXGa2zF+Fz2qZw4vBucZD6kVMbCPze4rYezSbsAqZzCC0f67vvU+j?=
 =?us-ascii?Q?r1EgPlxp/aeQnWYX/UFQQwh9PIhDyRA1lWKLWKIxxhKTZ0GgMdCtrK7KPxVR?=
 =?us-ascii?Q?MtFdnfOxEcnxvl8KhwqTc4w2koBbGQWd/rOLtRr+GzKuhkQ72QDFXqXKmH5y?=
 =?us-ascii?Q?Du1FvG+9L2na7GgOZkd4vAukutdHq5rFT+arTttvO+YM9iJ/jqHBadE8jAX9?=
 =?us-ascii?Q?0g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8603.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb0b2647-03f9-4d9b-b9c2-08db22c793f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2023 07:01:17.8451
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TYgDVAeu+2gvYr8f9YwLYbHDjXEjSfnO4rCjKMdQnVfBnnaZ/sKipg8iL+tDl4CckvO3F3v946FVjYj/hHoteG84N4lfNZpi682tTgTwPPA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR04MB9901
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

>=20
> On Fri, Mar 10, 2023 at 11:49:19PM +0530, Neeraj Sanjay Kale wrote:
> > Adds serdev_device_break_ctl() and an implementation for ttyport.
> > This function simply calls the break_ctl in tty layer, which can
> > assert a break signal over UART-TX line, if the tty and the underlying
> > platform and UART peripheral supports this operation.
> >
> > Signed-off-by: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
> > ---
> > v3: Add details to the commit message. (Greg KH)
>=20
> ...
>=20
> > diff --git a/include/linux/serdev.h b/include/linux/serdev.h index
> > 66f624fc618c..c065ef1c82f1 100644
> > --- a/include/linux/serdev.h
> > +++ b/include/linux/serdev.h
>=20
> ...
>=20
> > @@ -255,6 +257,10 @@ static inline int serdev_device_set_tiocm(struct
> > serdev_device *serdev, int set,  {
> >       return -ENOTSUPP;
> >  }
> > +static inline int serdev_device_break_ctl(struct serdev_device
> > +*serdev, int break_state) {
> > +     return -EOPNOTSUPP;
>=20
> Is the use of -EOPNOTSUPP intentional here?
> I see -ENOTSUPP is used elsewhere in this file.
I was suggested to use - EOPNOTSUPP instead of - ENOTSUPP by the check patc=
h scripts and by Leon Romanovsky.
https://patchwork.kernel.org/project/bluetooth/patch/20230130180504.2029440=
-2-neeraj.sanjaykale@nxp.com/

ENOTSUPP is not a standard error code and should be avoided in new patches.
See: https://lore.kernel.org/netdev/20200510182252.GA411829@lunn.ch/

>=20
> > +}
> >  static inline int serdev_device_write(struct serdev_device *sdev, cons=
t
> unsigned char *buf,
> >                                     size_t count, unsigned long
> > timeout)  {
> > --
> > 2.34.1
> >

Thanks,
Neeraj
