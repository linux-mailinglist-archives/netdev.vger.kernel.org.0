Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE17C63ECB
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 03:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727010AbfGJBEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 21:04:50 -0400
Received: from mail-eopbgr770125.outbound.protection.outlook.com ([40.107.77.125]:52429
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726710AbfGJBEs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jul 2019 21:04:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EX2LGnEvapj0sFwnsFURqORE3wlL5XS0tmCGEnhh3HJ5qYYpNGZKyxLS+V96MU6CEtfitvpnAZhUw/Id58KSNGmlPMriAebY+V2hsSghaBIFraZStLOzuoVO1SyldZYds0y1JscdyiJuc8Tf87a96c6tMjs9pB7PIWtZOujg98dQW3ci2hMuUNnG5MWNtQUqKl5bIZD7pRQde0udsB6dWPdfWdz2ui07SNd4pWKKMpLiWM7WUVlhz2hWB5r9b/KZZbWlqJOGGq+Ob8xql/XQ5aisJIY9bVP1EeToETBSDv1TPAXzYj3fRnNyehp0h+f3kjz918VIircdJI848q2hgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aPNNUnNZUmydsPDIRnEZcUils3sRed325LUfrTyp+MQ=;
 b=XoJ+O/irpBlbzIylrmMswv+X5z5O3ubYEHKmX6/T2QumLlrRESaGFqrR4Hh2qd2eCxH6Wd0WuskflGYSHb8W2Xn06losbv5imV3zyJb95HlYxQEyH48+Jxh5f+VVebT3hYHKRZcA9r7qx4T6tKJPL08L8gaTGUJ4zUNjGnK4erlpwcneknG4ZLTAuyqGWpB+paclsdURIQud/apgBLkU6NKEAskceKgKahmMqHTFqLW8Jq/DJfC70lmAUcryTEMDlaLQJMWqkyVEcgl7Dc54CzQJoRuE182tEVrjHLQZn7S/+nPaR7aZCZqWXIESZooHg5GYnaGb+eVHTJAyD1AyIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=microsoft.com;dmarc=pass action=none
 header.from=microsoft.com;dkim=pass header.d=microsoft.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aPNNUnNZUmydsPDIRnEZcUils3sRed325LUfrTyp+MQ=;
 b=M64FY2Y/rBaKy6B6cv7TpzpTPJhrEKQTZ1rzTR5MZ7+6Us6ExijasppvW58acHRPOBSxvT8sbIHkgiceX/5aezNPF6ZM2grcNUl7GS6/Ucr7gV7iof9Q4m1bN7ch24ttpDEwn4rJ2GdMvLnZBY9LBW63Ou6liBxiD7ofI+FQrQI=
Received: from DM6PR21MB1337.namprd21.prod.outlook.com (20.179.53.80) by
 DM6PR21MB1146.namprd21.prod.outlook.com (20.179.50.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.3; Wed, 10 Jul 2019 01:04:44 +0000
Received: from DM6PR21MB1337.namprd21.prod.outlook.com
 ([fe80::5067:7dee:544e:6c08]) by DM6PR21MB1337.namprd21.prod.outlook.com
 ([fe80::5067:7dee:544e:6c08%9]) with mapi id 15.20.2094.001; Wed, 10 Jul 2019
 01:04:44 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     David Miller <davem@davemloft.net>
CC:     "sashal@kernel.org" <sashal@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next] Name NICs based on vmbus offer and enable async
 probe by default
Thread-Topic: [PATCH net-next] Name NICs based on vmbus offer and enable async
 probe by default
Thread-Index: AQHVNqmLUJAyxztGLUGuWv2QILreQ6bC/8cAgAAJnzA=
Date:   Wed, 10 Jul 2019 01:04:44 +0000
Message-ID: <DM6PR21MB1337BA65754C4378239B4886CAF00@DM6PR21MB1337.namprd21.prod.outlook.com>
References: <1562712932-79936-1-git-send-email-haiyangz@microsoft.com>
 <20190709.172936.1666884223446806217.davem@davemloft.net>
In-Reply-To: <20190709.172936.1666884223446806217.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=haiyangz@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-07-10T01:04:42.6565530Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=a8beef6d-53de-4daf-bd7b-3704ecc94531;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=haiyangz@microsoft.com; 
x-originating-ip: [96.61.92.94]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5432f746-5cb2-4728-1de7-08d704d2985f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR21MB1146;
x-ms-traffictypediagnostic: DM6PR21MB1146:|DM6PR21MB1146:
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <DM6PR21MB11466432A8A7B7D028DA87A4CAF00@DM6PR21MB1146.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-forefront-prvs: 0094E3478A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(189003)(199004)(13464003)(186003)(7696005)(256004)(25786009)(8936002)(22452003)(229853002)(6116002)(8990500004)(4326008)(66066001)(11346002)(446003)(86362001)(316002)(66946007)(26005)(3846002)(476003)(486006)(99286004)(76116006)(54906003)(6436002)(102836004)(66476007)(6506007)(71190400001)(66556008)(6916009)(33656002)(53546011)(10090500001)(64756008)(66446008)(53936002)(81156014)(4744005)(76176011)(9686003)(305945005)(55016002)(74316002)(8676002)(478600001)(6246003)(2906002)(7736002)(71200400001)(68736007)(10290500003)(14454004)(52536014)(5660300002)(81166006);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1146;H:DM6PR21MB1337.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: YjZAQV1IY0mx7pl7UCJJhLtXc6ryTf94G0Rr+AO0BLEpPzWOMJL7Bs/qRFPc5sYvBcDD62LYst+8ABnNdlCFf2TLsv9VjbCot4YabE9zHQgJJHyhncnVXmynjvmftT3C41W2n9fJU2tYdhdl/SfsLnLu4iztSDGXzX0X7mD/8XpLFc9ln8lAoP6XRcIzSf0TCfFF7I70O71PhUD63jITijpKjbThk5kosm4CIOuwjiuayCEyIc+AYwgM4ZjjAykQbVt9HfiMr249vxh2Ng3TauqVevuO45AqLHo5GG5wCcvOl38f1ezDAOc8hmPZZMUOmG6r6lRRb7u7CinC9DuSSUT68Mv/BgrhvVp4K47XCuN32+H7uSPPabp8HBn8UxD/KPI3VJDq9/jlI1w+RMwj7m/U3fcc2sW3mDZYlEsZq1Q=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5432f746-5cb2-4728-1de7-08d704d2985f
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jul 2019 01:04:44.1282
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: haiyangz@microsoft.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1146
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: linux-hyperv-owner@vger.kernel.org <linux-hyperv-
> owner@vger.kernel.org> On Behalf Of David Miller
> Sent: Tuesday, July 9, 2019 8:30 PM
> To: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: sashal@kernel.org; linux-hyperv@vger.kernel.org;
> netdev@vger.kernel.org; KY Srinivasan <kys@microsoft.com>; Stephen
> Hemminger <sthemmin@microsoft.com>; olaf@aepfle.de; vkuznets
> <vkuznets@redhat.com>; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH net-next] Name NICs based on vmbus offer and enable
> async probe by default
>=20
>=20
> The net-next tree, if you are reading netdev today, has been closed.
I will re-submit when the tree re-opened.=20
Thanks,
- Haiyang
