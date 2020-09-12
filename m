Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 218A6267C06
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 21:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725902AbgILTgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Sep 2020 15:36:21 -0400
Received: from mail-dm6nam12on2125.outbound.protection.outlook.com ([40.107.243.125]:4489
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725838AbgILTgR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Sep 2020 15:36:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b+pLPBlzazy4BGOZvgzsxLWGPx34pMki164ZaEz3B2ElEfaX7f9X8XFUCf7HGPf7BvPg6X/K6SXw1GLzFivTLG8APgPdjOKNzYZsM5SIjDREOfzUtMlUdmpRNYXh94Ia/bgFYwQHJ/2SHOlNSEjxUlU1aG5mDXQN5N1KL/HsNz8r8OFr3kNKeLlS6wpXBEcQdMXrE9WD9ZdAc3A6RRiy79ZdFuCvmNYLAYyo/g95jP/X3oGnCRTc2tedWvHS6ZsBXFNaFEag/jKyaWcmZxhz/EUb7/zM8okv2Llny9Gyb+inZRUr7ENhpqx5L8w/LVvl8iH8vsFn3MdasagjWnXL3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ifQ5wLFhuP4P9BpX8//V7BzRlDUTFyd4YNiUW6iU708=;
 b=TQB9Ot9ABdVC1I5W1kNxc9z4gVvaHFLe2NYr3NHCwMWMRVnfZElgmCSO7Gd9ONAR+Isn4BWHt7oF/BilVt1EugkXEm0VWKlg/I324zEwwMjwbq9umuPmUChPf5wf6LrzyGFel/zTuvhHj8cN1vumusBK7g4S4dEMBhSL1tt+LjUTuBez10R0KWkg+WEbibHbPxZKKrlY5Yo2yUROOdGBAtan1LuhHj5E8WciRCPayJw1Ni1gOrIYcd73vHtQjSpEJi8az/apF9R/stsfRFMCl5hS+X/WG/dLEQa8ArSlsGO0Ih9ODtWWk1wCBDwqC25zZO+MprV4yTXFo7cadS7Ktg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ifQ5wLFhuP4P9BpX8//V7BzRlDUTFyd4YNiUW6iU708=;
 b=GO87ZfTY5N4fNhfYmzF7mIAiiP2wNLxyf5XBTLl94botELUFExl1f7o9OBfAYbD1oHf3x5gA+rArRaCt2Nezc6/auq72l2/uXjiU4nqLILChjU+IHK9NyKk597m+HVWzxPHkImw+AFSFNHutuqYHsASJ5hgm+UUkIVvWwLYVai0=
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com (2603:10b6:302:a::16)
 by MWHPR21MB0512.namprd21.prod.outlook.com (2603:10b6:300:df::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.0; Sat, 12 Sep
 2020 19:36:13 +0000
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::d00b:3909:23b:83f1]) by MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::d00b:3909:23b:83f1%4]) with mapi id 15.20.3412.001; Sat, 12 Sep 2020
 19:36:13 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     Boqun Feng <boqun.feng@gmail.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
CC:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "will@kernel.org" <will@kernel.org>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "Mark.Rutland@arm.com" <Mark.Rutland@arm.com>,
        "maz@kernel.org" <maz@kernel.org>
Subject: RE: [PATCH v3 07/11] hv_netvsc: Use HV_HYP_PAGE_SIZE for Hyper-V
 communication
Thread-Topic: [PATCH v3 07/11] hv_netvsc: Use HV_HYP_PAGE_SIZE for Hyper-V
 communication
Thread-Index: AQHWh3+dtzc6hmL7/kKq9yixyCiJi6llaE9A
Date:   Sat, 12 Sep 2020 19:36:13 +0000
Message-ID: <MW2PR2101MB10522C2677F328D45796D267D7250@MW2PR2101MB1052.namprd21.prod.outlook.com>
References: <20200910143455.109293-1-boqun.feng@gmail.com>
 <20200910143455.109293-8-boqun.feng@gmail.com>
In-Reply-To: <20200910143455.109293-8-boqun.feng@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-09-12T19:36:11Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=67d59c26-bc83-4a81-9c9e-fa38e61a058f;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 84b6c0d9-d05d-4358-70cf-08d857531be9
x-ms-traffictypediagnostic: MWHPR21MB0512:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MWHPR21MB0512E4A6C18FFAFFD05CBE40D7250@MWHPR21MB0512.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0yVbUzpNeSRONdBRxpswOpAAwulMnCpm4Loyy09o7z2k6shtyut+dL+5nV7ErwJQATqA6/49qOU6J4MQImLQAPLEBcyDze06u2euMEQCdyOX+XqkAtRAz0a3jMYc97LsWmvJ7ac7G/aCbLJrOD4ReAnjIrOTY6LUSblEUe+wgiX0qA1HLq6yD/+BD4g8/fh0vI28tUVLavjEXMEk+rz+Yy3PeeOVUwiOECNxvt4tZGHpJ4yiNsxbH49/kaQ0zgtlW3O7xoGbyVqCVcBf6gHQDBD19D1IVc3W2u1EW2LXL6mePoLr8ESLC2OCW12/66B/QlJk5wAuFI1BbmVehAvxaeHoxP5QbXsgFvBVZYnNL2f3qWKOMr4fTNu2z6lMieQL
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB1052.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(346002)(39860400002)(396003)(136003)(33656002)(83380400001)(316002)(4326008)(9686003)(10290500003)(2906002)(71200400001)(52536014)(8990500004)(86362001)(66556008)(64756008)(66446008)(66476007)(6506007)(55016002)(4744005)(82960400001)(82950400001)(186003)(5660300002)(8676002)(66946007)(26005)(110136005)(76116006)(478600001)(7696005)(54906003)(7416002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: XIavS+UQjtRKG/YsHnoKhiZnWEDWGflsHp4cra7o0LVMQRlU2vSAPxjx2naJh8/A5mVei6zBbp2zmLPBO3KSTAzSW6F11HgjTY+ugLfykTZAPBwK+nOx8HzrCFRNHMU+0w3dAc/4jYrmQhLSh+W6/SHbe4xf6eCR/wrIpwiJn7xngvEFDwsXFjvCaCNng9scbothRm4jMizB1cHY/wtJTx761d9rDcLhnFnSLinnpGW9sq+YCTUj9NZ9tELvpTGVIWLqWYIvwmOPoNGBZSrnZ4EwOyvK+f/8NXUtOtYFhipuOavuGV/Aqeb7clysD4JHk0QsMQy1WhTUflAWg6k1z67raPeV7vsBgeO5AyLZJoRu0mMSa3220K7/RUnPV943X+/X2ShKEh1Dd1kOzmM7Xerm4cVOjADivHMVOHVMYHGTr86RkeQ10Xj/g8UK/HShkppDqIyMlx73AcHUmOXImJdoJPZHJDfP+kzFdfKP2hxGWJ5M4HwYAC4P7oKUsaIaTftzhfJjWpgHURebo8q4XFLcOiSwPgpE/7q8p9i0Ln4WmhlqwKSOe6ZJbesjAEZhWM9+y++3PuJJ2i+YcyFNxHFNqzuDhM9P2GMBRvgxoC61qMkI9QyjjuhCMaW6VWUBAr67LGYHZyQF0YNvXy1I5Q==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB1052.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84b6c0d9-d05d-4358-70cf-08d857531be9
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2020 19:36:13.2742
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SS15zBQG1MKUIZrlC/jxI8wHYlYs56JcNeAJ4xqs7ReuyGKMvhNQl3LZ3Ly/mYFgueIiwVu5J0d1YZ/8FSm4/Ly46QGg8VCyWa4ZG9xzI20=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR21MB0512
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Boqun Feng <boqun.feng@gmail.com> Sent: Thursday, September 10, 2020 =
7:35 AM
>=20
> When communicating with Hyper-V, HV_HYP_PAGE_SIZE should be used since
> that's the page size used by Hyper-V and Hyper-V expects all
> page-related data using the unit of HY_HYP_PAGE_SIZE, for example, the
> "pfn" in hv_page_buffer is actually the HV_HYP_PAGE (i.e. the Hyper-V
> page) number.
>=20
> In order to support guest whose page size is not 4k, we need to make
> hv_netvsc always use HV_HYP_PAGE_SIZE for Hyper-V communication.
>=20
> Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
> ---
>  drivers/net/hyperv/netvsc.c       |  2 +-
>  drivers/net/hyperv/netvsc_drv.c   | 46 +++++++++++++++----------------
>  drivers/net/hyperv/rndis_filter.c | 13 ++++-----
>  3 files changed, 30 insertions(+), 31 deletions(-)
>=20

Reviewed-by: Michael Kelley <mikelley@microsoft.com>
