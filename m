Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE62B8B276
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 10:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727988AbfHMIaw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 04:30:52 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:55024 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727784AbfHMIav (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 04:30:51 -0400
Received: from mailhost.synopsys.com (dc2-mailhost1.synopsys.com [10.12.135.161])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id F0105C0092;
        Tue, 13 Aug 2019 08:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1565685051; bh=f/H5GhgZuZJg1KUWGt76m54d/3PtlkmeTTRXx0ZZOnw=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=LS1HAOtvXNN1Wrpm7SS+RIQ5HvndwEYY2uXgnXK9FH/QgAIMhbTIgndHa1eKMMmET
         yMBkDZNX1ZrRlsvQqh6OhZkM2l/uIp3jf/2lUAKWvnO4RssHTCPvtd4wPhT+K3tgG8
         brFMjBiSIF1YN8dKx0UUNHQdVGONPkJ9ce1ACNyKsHSdLKiLfVNmA76mlhrEY9D2zv
         YYOtsy/I/LLWJ69DGtvF9lHl9xw5vhfoAEUCvq2AJU5O/fkQqJzzkNg87Q/wyN4unQ
         SAqBEJyoDOs8XssW74H0l6pE/UpFa6ZCHqpL/eXtke7JYtqYLEfWaGzJWexx83pn/W
         skHoJl26y1FzA==
Received: from us01wehtc1.internal.synopsys.com (us01wehtc1-vip.internal.synopsys.com [10.12.239.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id B4E4CA008B;
        Tue, 13 Aug 2019 08:30:49 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 us01wehtc1.internal.synopsys.com (10.12.239.235) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 13 Aug 2019 01:30:48 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Tue, 13 Aug 2019 01:30:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ebMEtp7YArLulQVRxeJde4gVW9cz9Nt45DYHwgsZ6lqhMM5rTxAdiq2n8Q4uPjfF8F2L3uYf2UbGRiHQ4Vq5XXhd/2wWtIMdhf5g2SDYz8iQOZDTWSowJheEW+1BQk9Fa/w58H7UZLuuP8UMJBm/S76wdXCupbVTMOi4f1u+675nAWqrVGzzX38+WFHcN32Iur+L/GSzjWCNpcxCsEmVz0bOpGHPBvA+ZV5XkEk+odr+rmL0fT1qHIvBewKlvY8HqqPM+WRKZfKQS+ybA0jBrW4bwY067HYGkHOkpZ/rtybeex1ODjoWwXHlzrRvWKhWU+UR7j6WDsw4YjGrv0hPtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n5w2tv9O0XWTTFTKsZq2fAuaX9S/HYIVb4hwMmUIUss=;
 b=W6h3dUJ5SkzK8P8ygqoKTZinyxzcItXeLLEEcr7yfAzWKRpDU46bt3HCAoh2Jzsty9726gAuPDOpxkzXvH4Y7aUuzDGRLLj/ZHp0piGaeZbTGQeIr0AhO36HKCqMtGwlt2SoAQlH2MvqMUVXdhzKGSrwwIpwNkWCtXUi+dMyIYpnKj72d9UiG3kIVUac+7kg1pqhD9Dnfv89hAxla83lTGiQa32NKO0udMtbvDT5/+7+7GyGefokyrap8uIOUJ03MZ6BtHlg1oyVZ+ReC52DGoL/fDYufPO6da3T4f4CBrj1vf5872mQqulPjqxg/uZixR+/lURB6pIBpFU2oxKgFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n5w2tv9O0XWTTFTKsZq2fAuaX9S/HYIVb4hwMmUIUss=;
 b=lyP0zMj9wEw1DWBqVPih9b/atUGoZlj5xEo2d4G5Vhrh+345BcITviWNjIpR7/8cVaDytewSQ4N90HQzIgnb1k5ozBrPxZT/+sN2lWAnjKmc0ToaCvOzVf3c5ZOgahvM80KE7Vmkk7yIqTSMnZzI8dBlJ94BkhZCZkb1TH/KuRE=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.66.159) by
 BN8PR12MB3089.namprd12.prod.outlook.com (20.178.209.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.16; Tue, 13 Aug 2019 08:30:47 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::6016:66cc:e24f:986c]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::6016:66cc:e24f:986c%5]) with mapi id 15.20.2157.020; Tue, 13 Aug 2019
 08:30:47 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     David Miller <davem@davemloft.net>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Joao.Pinto@synopsys.com" <Joao.Pinto@synopsys.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next v2 04/12] net: stmmac: Add Split Header support
 and enable it in XGMAC cores
Thread-Topic: [PATCH net-next v2 04/12] net: stmmac: Add Split Header support
 and enable it in XGMAC cores
Thread-Index: AQHVUPKdBvuj8ZjSi0+3V315mYCFAKb4AawAgAC8LGA=
Date:   Tue, 13 Aug 2019 08:30:47 +0000
Message-ID: <BN8PR12MB3266B9314CF13A9140A72354D3D20@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <cover.1565602974.git.joabreu@synopsys.com>
        <cover.1565602974.git.joabreu@synopsys.com>
        <6279e35421e17256ac023227ec8cd5c8498d34d0.1565602974.git.joabreu@synopsys.com>
 <20190812.140618.1288127671943783439.davem@davemloft.net>
In-Reply-To: <20190812.140618.1288127671943783439.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9930fd1a-1ed8-4c1a-f990-08d71fc88a99
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN8PR12MB3089;
x-ms-traffictypediagnostic: BN8PR12MB3089:|BN8PR12MB3089:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR12MB3089C7835E53782C02E1297CD3D20@BN8PR12MB3089.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01283822F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(376002)(39860400002)(136003)(346002)(396003)(189003)(199004)(8936002)(54906003)(316002)(110136005)(76176011)(7696005)(81156014)(81166006)(26005)(5660300002)(52536014)(186003)(6506007)(102836004)(14454004)(86362001)(9686003)(55016002)(53936002)(7736002)(8676002)(2906002)(66066001)(6436002)(305945005)(74316002)(25786009)(229853002)(99286004)(71190400001)(71200400001)(3846002)(6246003)(6116002)(4326008)(66476007)(66556008)(64756008)(66446008)(66946007)(76116006)(33656002)(256004)(486006)(11346002)(476003)(478600001)(446003)(2501003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3089;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Uxe/C62RXOcoZXuImCo3gCV339H6UDi3vMh4Bp1go9t9Nswzi9EZLxnEBgNwpMlVHBqlnblc5aVlSPAmem2DeD3Q4z8rnLNqlT4ZImhKk3vcI/AHjqAjJ38mLkCQYPZHKVPtk5xaV+wy9G1PMHWWLkFfsLAVL2HFKe+65YsUy0S+D0dGgYm7CYRfdh/FzWD6r0hMqOk39yRPfRfmlOL4/hbK8UUtQEpsnbN9/hdKREwKA0HJhlijawB0kMJwgKVyBpPxKwvqZQgDs6ByL//cJ/6rkJYnuXhswSCDNqZ8etJYBH87lDsOxQWFS8tQkVJ7IBmR5NR9p1Le+bkIvjm4lwCC8YLeO1lI3OVc9ZHFMgGg4L5YwM54peaDJzix2p9+Q1hT2kgCcubBQMAY1veG1FLPNGd9wkzmgyBWGHYj2l4=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 9930fd1a-1ed8-4c1a-f990-08d71fc88a99
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2019 08:30:47.3842
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FWQu6g12LBxHz9UmikQ95/+jKx0A3sRxyzidoasQQoHFMVsSBUhnlVvYBCqK3EEIL/96TMv/idBxyB6PZrcBVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3089
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

++ Jakub

From: David Miller <davem@davemloft.net>
Date: Aug/12/2019, 22:06:18 (UTC+00:00)

> From: Jose Abreu <Jose.Abreu@synopsys.com>
> Date: Mon, 12 Aug 2019 11:44:03 +0200
>=20
> > 	- Add performance info (David)
>=20
> Ummm...
>=20
> Whilst cpu utilization is interesting, I might be mainly interested in
> how this effects "networking" performance.  I find it very surprising
> that it isn't obvious that this is what I wanted.
>=20
> Do you not do performance testing on the networking level when you
> make fundamental changes to how packets are processed by the
> hardware/driver?

I do.

In my HW this feature does not impact performance neither improves it as=20
I'm already on max of theoretical bandwidth.

I do expect it to reduce CPU usage and memory footprint because we no=20
longer have to memcpy the entire buffer to SKB and instead we just copy=20
the header and then append payload as page which is passed directly to=20
net layer.

This feature is already used in some drivers and is part of GRO=20
offloading I think.

Jakub, as David is off can you please comment on how can we proceed with=20
this series ? I can add more information in commit log for this patch=20
...

---
Thanks,
Jose Miguel Abreu
