Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 269C1908ED
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 21:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727588AbfHPTuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 15:50:20 -0400
Received: from mail-eopbgr770125.outbound.protection.outlook.com ([40.107.77.125]:52228
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726527AbfHPTuT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Aug 2019 15:50:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G1mrgfPN8o45FnWENs6ZohNG24LGKWSKhqnmlu/dBoWtqYmeaxTR0y/j6ztEa7ZkFtwM5ddkh7o3v5ffl3QVtECMdCoPHNO0C6ute2cgYolUAIz7bs3Ra8zX8kih/CV25QgeBKsmNkpYUbysWzSyYsc7m/lwYMSu2yCA5bqzjlL1bI/DgMTi+InPmlU0HN7Ki2N7aFPROrYk+Uokv/95cityY+dpAcC8z+V/ISd1PkenoMbcVx0v46rGFURTDc2ANyqO08n/m0h5hCe3DQpbc5Ef2p3e4JmX4941hp3Qo7sJOFyoAzghrsQzG+fvmnLjKqz661zsqz8Whn+ic1alwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=58kkHVL5V4CvxRA55qNjAaYGeC1v9AXbqb5e6cYC+/g=;
 b=cB8OhtEwwMUTvA0ect9cnco2A/14PGwU1kh1PIEa5LbK9yfT6CHPRz26Hid1UJ7g6frNzMVsx/J4wRyHwMPKQawAYwK4yoWvnLQUeJXt/2vvEmFF71Kjf4lRT/wMEjx4q4WJ6Ow79uqXnVEerCgn8VCAoRVzYD5Vu2EY0wK+iKX85D3YY6gY37hsxXuiJGt3C0dcqvtCPoAXfxqVE8Cl6gCLHFPgziZM0hxe3HvFTcvMjHbW5KXy1DOpSHd8Ayam2/4MAYFtXIL1O2AV429hKfPViGSKu6pQybFAB1Ethm0/9/4YWI6+yqhKQt5IufSbye4rM8heOzUKyaDT8Ta2Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=58kkHVL5V4CvxRA55qNjAaYGeC1v9AXbqb5e6cYC+/g=;
 b=XG/Cp0fezyen0G9uQkOozuTC8303NOz8c7Mso0yvkfH6vQATagq4eJKkTJVct+LovyZSbhzziAiFk9jAfxEVlZ6meta4YhNiJ6oOMu9hDVGii5bG7XuVlk8Vf16p/yVl+r6tMcoFyX+LrqSjFL+EP+nz582Kj/5AJuJNfaOUEHk=
Received: from DM6PR21MB1337.namprd21.prod.outlook.com (20.179.53.80) by
 DM6PR21MB1417.namprd21.prod.outlook.com (20.180.21.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.2; Fri, 16 Aug 2019 19:50:14 +0000
Received: from DM6PR21MB1337.namprd21.prod.outlook.com
 ([fe80::28a1:fa7:2ff:108b]) by DM6PR21MB1337.namprd21.prod.outlook.com
 ([fe80::28a1:fa7:2ff:108b%5]) with mapi id 15.20.2199.007; Fri, 16 Aug 2019
 19:50:13 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     vkuznets <vkuznets@redhat.com>
CC:     KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sashal@kernel.org" <sashal@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "eranbe@mellanox.com" <eranbe@mellanox.com>,
        "lorenzo.pieralisi@arm.com" <lorenzo.pieralisi@arm.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next, 2/6] PCI: hv: Add a Hyper-V PCI mini driver for
 software backchannel interface
Thread-Topic: [PATCH net-next, 2/6] PCI: hv: Add a Hyper-V PCI mini driver for
 software backchannel interface
Thread-Index: AQHVUtO4i0f5rhE14EmISE1mYwr8y6b9tkuAgAAliYCAABphgIAAO6cw
Date:   Fri, 16 Aug 2019 19:50:13 +0000
Message-ID: <DM6PR21MB1337F60380AA39A65FB83225CAAF0@DM6PR21MB1337.namprd21.prod.outlook.com>
References: <1565809632-39138-1-git-send-email-haiyangz@microsoft.com>
 <1565809632-39138-3-git-send-email-haiyangz@microsoft.com>
 <878srt8fd8.fsf@vitty.brq.redhat.com>
 <DM6PR21MB13375FA0BA0220A91EF448E1CAAF0@DM6PR21MB1337.namprd21.prod.outlook.com>
 <871rxl84ry.fsf@vitty.brq.redhat.com>
In-Reply-To: <871rxl84ry.fsf@vitty.brq.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=haiyangz@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-08-16T19:50:12.3000511Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=209d26bc-6f1d-42b0-a79e-e7ec32f2d7c5;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=haiyangz@microsoft.com; 
x-originating-ip: [96.61.92.94]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b6f933bb-f89d-4a2b-76f1-08d72282f46f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600158)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR21MB1417;
x-ms-traffictypediagnostic: DM6PR21MB1417:|DM6PR21MB1417:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <DM6PR21MB1417DF72F9A6640CA19B2528CAAF0@DM6PR21MB1417.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0131D22242
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(366004)(39860400002)(396003)(346002)(136003)(13464003)(189003)(199004)(2906002)(4326008)(7696005)(478600001)(6246003)(8936002)(76116006)(53546011)(3846002)(53936002)(6436002)(9686003)(81166006)(10290500003)(81156014)(186003)(52536014)(8990500004)(71200400001)(54906003)(316002)(6916009)(66066001)(25786009)(6116002)(55016002)(66476007)(7416002)(102836004)(71190400001)(99286004)(11346002)(8676002)(76176011)(66446008)(22452003)(64756008)(14454004)(486006)(229853002)(7736002)(33656002)(10090500001)(74316002)(66556008)(446003)(5660300002)(86362001)(66946007)(476003)(6506007)(26005)(256004)(305945005);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1417;H:DM6PR21MB1337.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: o/+5iKdXPHGLN1nTujdKKs06bN2r9ndTS6L5JLZeKal1sQbIP+kYW7b+0QFIhG+Ea6P0Rppz6rOuqqQafVoLd3Yi9SW7aBXU1sM+i0XHJeefOYJReg0ZDu1QxIQVqEzv98t4C+WkmM7IitpCwGzFDEGVwCZ17UgRVGBEDpI4UWNN5T9ZfwrxDuPZYwevGVtqbeNBus5g1msiHOc0ExYzmEgekqO0e7oTXif++7hBagne0vbUK1Mf8g5PZMn3BCBFaskAm7BhbNtQhhbJwRo/2pHj7o4xMIlTk4f6LtEGMzxQTIiw9X3Rp3faquhs0DaflEzSGn0kRB2NZTH6VT/BdjX3jvVn5c5twRV9tRBO/vHA1nlSZ1HjjHM98EWUQSy57uvlVXO60TD1roNNgvMGscV+5w3E3ranWLG0McmBVUI=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6f933bb-f89d-4a2b-76f1-08d72282f46f
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2019 19:50:13.7157
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VxDOOaVAVF9VY142Je+vczZbiU6u3Ug1eZe+6z67Ks5p2Ncjo9ObNoupeWnvSl3nyc5UiHN1TxqsnnjuKBTDjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1417
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Vitaly Kuznetsov <vkuznets@redhat.com>
> Sent: Friday, August 16, 2019 12:16 PM
> To: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: KY Srinivasan <kys@microsoft.com>; Stephen Hemminger
> <sthemmin@microsoft.com>; linux-kernel@vger.kernel.org;
> sashal@kernel.org; davem@davemloft.net; saeedm@mellanox.com;
> leon@kernel.org; eranbe@mellanox.com; lorenzo.pieralisi@arm.com;
> bhelgaas@google.com; linux-pci@vger.kernel.org; linux-
> hyperv@vger.kernel.org; netdev@vger.kernel.org
> Subject: RE: [PATCH net-next, 2/6] PCI: hv: Add a Hyper-V PCI mini driver=
 for
> software backchannel interface
>=20
> Haiyang Zhang <haiyangz@microsoft.com> writes:
>=20
> >
> > The pci_hyperv can only be loaded on VMs on Hyper-V and Azure. Other
> > drivers like MLX5e will have symbolic dependency of pci_hyperv if they
> > use functions exported by pci_hyperv. This dependency will cause other
> > drivers fail to load on other platforms, like VMs on KVM. So we
> > created this mini driver, which can be loaded on any platforms to
> > provide the symbolic dependency.
>=20
> (/me wondering is there a nicer way around this, by using __weak or
> something like that...)
>=20
> In case this stub is the best solution I'd suggest to rename it to someth=
ing like
> PCI_HYPERV_INTERFACE to make it clear it is not a separate driver (_MINI
> makes me think so).

Thanks! I will consider those options.
