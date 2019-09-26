Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95111BF8A5
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 20:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727923AbfIZSEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 14:04:32 -0400
Received: from mail-eopbgr40052.outbound.protection.outlook.com ([40.107.4.52]:60642
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727727AbfIZSEb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Sep 2019 14:04:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NTRzcxWICTt5UFh3E801a+dum3f0L/l9TNtTkUqrUFK9p2vTR20njoBwwl58HUqODt0hDZfzjVuPas0pR58hTF0XK5oZ4ZGQz8OeXHyFOESQNoSewDTM0mZlDX7rKc7H1jiPcSUC5LuwI7RbaMSfIFiWOZbvHk+quJZTBwgein28ap7tGmiYS2Syw4DYnYOrfZw0RUPtFs+ofjeOCF+CiQKlq5hUUaWHqK5trdRNZlXdzxRrVBkDEAnOrsjeiR0MiwXvsjL86WwdWqA4BmqS+ebptJOyI3kc+g/sKcCdAdLMflVLg86KvXGArhzvFGAkkmMuHsnWxsIsFTPzVyy5Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QizePVNwUUNudBAkFXR/Hcch01ezj8muuLA0RnddG3U=;
 b=J4DHuLCxEbHbANirhqCKfI2Mc4ZGnmxDvB6lYQ4SvuzO5F1XB+yU/Ux/q3JHG8bNaWL1ycPqUhGvepzbrVXfivYnKy6Uuk+Gyg4/ga73uQL6PF/pYAEKMdXwtNih2yz9K4DjYCnloBNARwwglqCXxkJGUInnBgBJdni4EF4O95lOZ1Zv1llQMhtrIpWwoztEZZ+aEwsgJzMikb2BB1Zqk22cJQeHGNi1g4npb+I4ILkzVNihac/GlIbb9L0WSkkXxqf0lUSdFsaXWHMpOBQnP5zavCDXS3Q0PQ4Z/4xUIfYepiBatCf5zeZVm/IIKusar2Zra/yRoQqbgTN+CjH4eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QizePVNwUUNudBAkFXR/Hcch01ezj8muuLA0RnddG3U=;
 b=bTXuUZZgJ6owgiLQmw/9Hb7Nv+zBOF8frdrXAArFMe/BMyKC9lt10t5HgCal1K91FvdizB9UIxfpwhPyr+qfDzSdNNBm/5Wn+zujR0t9usTeoYSTK3GabYqFdxuhRI96Ak1a0rHakZD5+tamT+MZNjUiurFge3AwORxHY0QlzV0=
Received: from DB7PR05MB4138.eurprd05.prod.outlook.com (52.135.129.16) by
 DB7PR05MB5544.eurprd05.prod.outlook.com (20.177.193.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.22; Thu, 26 Sep 2019 18:04:26 +0000
Received: from DB7PR05MB4138.eurprd05.prod.outlook.com
 ([fe80::502e:52c1:3292:bf83]) by DB7PR05MB4138.eurprd05.prod.outlook.com
 ([fe80::502e:52c1:3292:bf83%7]) with mapi id 15.20.2284.028; Thu, 26 Sep 2019
 18:04:26 +0000
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Shiraz Saleem <shiraz.saleem@intel.com>
Subject: Re: [RFC 04/20] RDMA/irdma: Add driver framework definitions
Thread-Topic: [RFC 04/20] RDMA/irdma: Add driver framework definitions
Thread-Index: AQHVdInRxKc9Xqm18UKMerHkf/S7lqc+LTcAgAASw4CAAACRAA==
Date:   Thu, 26 Sep 2019 18:04:26 +0000
Message-ID: <20190926180416.GI19509@mellanox.com>
References: <20190926164519.10471-1-jeffrey.t.kirsher@intel.com>
 <20190926164519.10471-5-jeffrey.t.kirsher@intel.com>
 <20190926165506.GF19509@mellanox.com> <20190926180215.GA1733924@kroah.com>
In-Reply-To: <20190926180215.GA1733924@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: QB1PR01CA0024.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c00:2d::37) To DB7PR05MB4138.eurprd05.prod.outlook.com
 (2603:10a6:5:23::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [142.167.223.10]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d6684535-6ee6-415e-a308-08d742abf826
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DB7PR05MB5544;
x-ms-traffictypediagnostic: DB7PR05MB5544:
x-microsoft-antispam-prvs: <DB7PR05MB55449239D0FDE7A787641852CF860@DB7PR05MB5544.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0172F0EF77
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(376002)(346002)(366004)(136003)(199004)(189003)(386003)(2501003)(256004)(446003)(1076003)(4744005)(6916009)(186003)(86362001)(71200400001)(71190400001)(14454004)(2351001)(478600001)(66946007)(54906003)(33656002)(229853002)(6116002)(4326008)(3846002)(316002)(66066001)(2906002)(6246003)(8936002)(76176011)(81166006)(6512007)(5660300002)(66556008)(5640700003)(64756008)(66476007)(81156014)(66446008)(1730700003)(476003)(6506007)(36756003)(99286004)(8676002)(102836004)(2616005)(11346002)(7736002)(305945005)(25786009)(486006)(52116002)(26005)(6436002)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR05MB5544;H:DB7PR05MB4138.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: zKfPo2K6hp97YPQbziMX0PoJF6X5bRbw/oZb7GMViHAtuI9CJnCjg6HlDTJlbfeLfqzutPAE1Zn9PPpDchVPNDy7TIC6K5naAAQRASgKoTjHAOc+yA5ep+gI6+My1JM7xaV4QJRBP2G8eex6HO/Xm3ZDBFRjYDXF7fdKgdle1xzoUYZmIoHDDrlD1Rh9+rzGjm6CormZM+PH53eiJMO4NZDrYr4Sh7/ttzxWmoT2PprTNLfmlIgyImUzoBxWtQw9BwKE52etJ6bkp8DtpOLrnW3JEFUsmYGwWzynZLMGTAz4VrklTYF/9GI5CuoHne62bPBrXnJ5juPl4i/1sv9wjaZuBJ24v3sGCV/esZ2F1Vlx+P9w5UNs7VWQNN2I1pX7Gjz6nRT7VeSfPVIoYZc9T73a4FOtvlBdcrO7Qr2fpQ4=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F0077E29BF457D4FA684824A0D98FEDF@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6684535-6ee6-415e-a308-08d742abf826
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2019 18:04:26.8036
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZLSiZ1TfGN6LUpC+29h1M7RkgJTtsu03ULxfwT9Efzpfz6M11yu5fSDdFg0D1rCg/RDgeSI9hRA3d07lgJsmMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR05MB5544
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 26, 2019 at 08:02:15PM +0200, gregkh@linuxfoundation.org wrote:
> On Thu, Sep 26, 2019 at 04:55:12PM +0000, Jason Gunthorpe wrote:
> > On Thu, Sep 26, 2019 at 09:45:03AM -0700, Jeff Kirsher wrote:
> > > +int i40iw_probe(struct platform_device *pdev)
> > > +{
> > > +	struct i40e_peer_dev_platform_data *pdata =3D
> > > +		dev_get_platdata(&pdev->dev);
> > > +	struct i40e_info *ldev;
> >=20
> > I thought Greg already said not to use platform_device for this?
>=20
> Yes I did, which is what I thought this whole "use MFD" was supposed to
> solve.  Why is a platform device still being used here?

Looks like when mfd creates the 'multi' devices it creates them as
platform_devices

/*
 * Given a platform device that's been created by mfd_add_devices(), fetch
 * the mfd_cell that created it.
 */
static inline const struct mfd_cell *mfd_get_cell(struct platform_device *p=
dev)

Jason
