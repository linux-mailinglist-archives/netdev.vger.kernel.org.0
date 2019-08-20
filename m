Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F91C96C96
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 01:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726256AbfHTXA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 19:00:26 -0400
Received: from mail-eopbgr750124.outbound.protection.outlook.com ([40.107.75.124]:2549
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726028AbfHTXA0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 19:00:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k2pSIxb3vGNFKQ2AGngvx1CC377QywYN4fJne9npi5p2BMfb4pP7WbXnH27BDhcCRuuIE+UjFrLMNDU/1/chzhHhReUSqbGmANlcTyuv5ItUa3/16GoPwDPz3/3jBcNCsNx0d//8CcT/++ob97OQfaru566WTBFuIJlY4mLoQssUGwme5Kw93u9Owu48WTDUif8v48UWX+hPWAS1SKuPww5bOekQcDIEcL72VQzFY0yZ/PuzBb4dcNCUk00GlEV7SLW5+isdh2eLJs0n0rMVll1fYtzmHZuDYlhk/0dHhJf89UiKFDi/TKrBnm01nrhkJMlMAOVvxO0C2suA/Yo7cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MR0VZaEZLdxY9z75jCWi0hPlqHKns2uqrzNdyNs772M=;
 b=Rv47X1ElEXMypApuQAmRUmhMhi4D4HbqbWu3qMe/C6DQzocWREHKCkWz0WrVYoZNnUU4HGXtqhq5boAQSN9iOE/2kGr4WYZJMLNU9/B5PCmsOQw0HZmCNByhKiYJRXwbssVWlIh99KrPHWvMsnfPUVulKvfRIqWA/FhBfw7tVQNw/Er8IYoDQuAL4F4W5NBf42bC3f+oS0zx8vR0MkG2eJI/0EUPayIziGBcRppPPg8hh+PmQwRn733vQSA7jXIA0v9Pw45Fxjn29JJb3rw3J7tcB3gLBzd602l7HNRae+5QylGcztPrrgAm3OR7DsawiFR6yYsgHXWcEkWdnUiTOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MR0VZaEZLdxY9z75jCWi0hPlqHKns2uqrzNdyNs772M=;
 b=cQHGdpTDEhUFY/WrRxUTVrfG3DYPzPwZ8wQpKTWs0rLVBeHFloVwVDn/1kYttbqbjTqqzSbn74PXrZ0d1SIlqIzBVempHrhd3ljFh/2vp0x0Kdl4h68Mj00hqPtnSaczIvcnbKwbtRSV5PhCuApMOiV8AsfN5gqPoioPIERxBiI=
Received: from DM6PR21MB1337.namprd21.prod.outlook.com (20.179.53.80) by
 DM6PR21MB1451.namprd21.prod.outlook.com (20.180.23.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.3; Tue, 20 Aug 2019 23:00:23 +0000
Received: from DM6PR21MB1337.namprd21.prod.outlook.com
 ([fe80::28a1:fa7:2ff:108b]) by DM6PR21MB1337.namprd21.prod.outlook.com
 ([fe80::28a1:fa7:2ff:108b%5]) with mapi id 15.20.2220.000; Tue, 20 Aug 2019
 23:00:23 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     David Miller <davem@davemloft.net>
CC:     "sashal@kernel.org" <sashal@kernel.org>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "eranbe@mellanox.com" <eranbe@mellanox.com>,
        "lorenzo.pieralisi@arm.com" <lorenzo.pieralisi@arm.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next,v2 2/6] PCI: hv: Add a Hyper-V PCI interface
 driver for software backchannel interface
Thread-Topic: [PATCH net-next,v2 2/6] PCI: hv: Add a Hyper-V PCI interface
 driver for software backchannel interface
Thread-Index: AQHVVsSabXkFF5JzvUOerk/7F+w+SqcEbZ2AgAA6XzA=
Date:   Tue, 20 Aug 2019 23:00:22 +0000
Message-ID: <DM6PR21MB1337D02F2DE44173AD64734DCAAB0@DM6PR21MB1337.namprd21.prod.outlook.com>
References: <1566242976-108801-1-git-send-email-haiyangz@microsoft.com>
        <1566242976-108801-3-git-send-email-haiyangz@microsoft.com>
 <20190820.122925.1080288470348205792.davem@davemloft.net>
In-Reply-To: <20190820.122925.1080288470348205792.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=haiyangz@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-08-20T23:00:21.1479761Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=373ea2b7-f035-43cb-b372-7a26cd2ba4ab;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=haiyangz@microsoft.com; 
x-originating-ip: [12.235.16.3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 43700d19-88a3-4728-3fd5-08d725c22e99
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600158)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR21MB1451;
x-ms-traffictypediagnostic: DM6PR21MB1451:|DM6PR21MB1451:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR21MB14518A09D02C5330845547ACCAAB0@DM6PR21MB1451.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 013568035E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(39860400002)(136003)(366004)(346002)(396003)(199004)(189003)(13464003)(52536014)(66446008)(64756008)(66556008)(66476007)(476003)(229853002)(478600001)(22452003)(86362001)(53936002)(6116002)(316002)(3846002)(76116006)(6246003)(66946007)(256004)(74316002)(14444005)(4326008)(8990500004)(6916009)(10290500003)(7736002)(14454004)(486006)(25786009)(305945005)(10090500001)(33656002)(186003)(54906003)(2906002)(8936002)(26005)(71190400001)(71200400001)(9686003)(55016002)(5660300002)(76176011)(66066001)(7416002)(11346002)(102836004)(7696005)(8676002)(6436002)(81156014)(53546011)(6506007)(81166006)(99286004)(446003)(142933001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1451;H:DM6PR21MB1337.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: J2k3WyFgNCv653qIxQw8OjEXZ9Vf2Niw/d0DeSx5LsvhGyw5+KbNnzsXc4GlmpMuU6lsNCmve/iR4HaFp5moQyQYKiix+f3Qa4AgPDHhbuKcTS6grs95PlBX0T9oNJp23Mt92JEFG/4kV4xOf+vvBhLMbY2dbVW7HB47Zr2QFMH8MM9Iq+TVvrUYCW2SRSP4Zy250E+c0d2uj+zSQmyKE4WwtM0pPhdkh2G2j8icmlvBXVCZsBvGesHyzwDcjzvqkO7w9Lcx1X3Kb7kTKBnbi+6RKwJMiB7yx5BC0qIU/Ng4y23R1oLrOr8n3V9XhL1fqTYO/YxwacPc0dLdVP93FtomaSZ199kKbQ0V4YrCpPhMmi6hRe7F2x0JilaKgEVeAE0bO4qU3UOjqchoWfY8c4X1Ocw0DS/2ksxMIBg1fZo=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43700d19-88a3-4728-3fd5-08d725c22e99
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2019 23:00:23.0230
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NI7zPLD4aYFUkiduwJnPPrh90xcbk2AsnXaVBUNHSZW+H6y8iYbj9/URLq+CVD4Q6aC20JxKgzlvaFnyCNNxfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1451
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: David Miller <davem@davemloft.net>
> Sent: Tuesday, August 20, 2019 3:29 PM
> To: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: sashal@kernel.org; saeedm@mellanox.com; leon@kernel.org;
> eranbe@mellanox.com; lorenzo.pieralisi@arm.com; bhelgaas@google.com;
> linux-pci@vger.kernel.org; linux-hyperv@vger.kernel.org;
> netdev@vger.kernel.org; KY Srinivasan <kys@microsoft.com>; Stephen
> Hemminger <sthemmin@microsoft.com>; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH net-next,v2 2/6] PCI: hv: Add a Hyper-V PCI interface
> driver for software backchannel interface
>=20
> From: Haiyang Zhang <haiyangz@microsoft.com>
> Date: Mon, 19 Aug 2019 19:30:47 +0000
>=20
> > +static void __exit exit_hv_pci_intf(void) {
> > +	pr_info("unloaded\n");
> > +}
> > +
> > +static int __init init_hv_pci_intf(void) {
> > +	pr_info("loaded\n");
> > +
>=20
> Clogging up the logs with useless messages like this is inappropriate.
> Please remove these pr_info() calls.
>=20
> Also, all of these symbols should probably be GPL exported.

I will update the patch -- remove the pr_info, and use EXPORT_SYMBOL_GPL()
for the symbols.

Thanks,
- Haiyang

