Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8FB3594D7
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 09:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbfF1H1f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 03:27:35 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:53412 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725792AbfF1H1f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 03:27:35 -0400
Received: from mailhost.synopsys.com (dc2-mailhost1.synopsys.com [10.12.135.161])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id B22BAC0A6E;
        Fri, 28 Jun 2019 07:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1561706854; bh=zYe5/mN81Wu4tL48o2Soq2Ioh9hXQALfNlBRak2re20=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=GJyI995X4UEHFz4nvJ2nZ9JqOn4Gry1IZ4Ux9HnmwLvoM3jx0L7WM7Rz89R2ZHosM
         wwUHaxPDgPQCsM/h0vBRup7/UQb1vxPTlgyfTeqQPTACG3MQSh5NJ0YhxvMRZNDFQr
         CG+yFn2DO9hVeEgVAMvWe9XkIx3eUuEFT2PYA9d6GepHEQBnq/IPL5EwvNYcI/5Bea
         nMpVr+j1heb3SyAUotyduP1OslNs8Kc+Rt5WrW60OV54aIEzyr5hG1+BoDOM+RU+oO
         9hPqi4lHmMaxd9QmY4FWIhtktwgfzNsB8I716PjkNaMWdZ4jEAYGtZASPfDQU2YBOl
         CSgF0/cXCKYcQ==
Received: from us01wehtc1.internal.synopsys.com (us01wehtc1-vip.internal.synopsys.com [10.12.239.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 4A7EEA0093;
        Fri, 28 Jun 2019 07:27:34 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 us01wehtc1.internal.synopsys.com (10.12.239.235) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Fri, 28 Jun 2019 00:27:33 -0700
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Fri, 28 Jun 2019 00:27:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector1-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zYe5/mN81Wu4tL48o2Soq2Ioh9hXQALfNlBRak2re20=;
 b=fZCnvgTcQpA7PDONJmRCNxklUTotTS1P7j0Z7wueIEC67Rr5hvOgW7IcdKm1r3opZqKk037CJflQQEDkMEqy6CiYpO90b1T1O9DcmHUUM/UajI6Cb4OO01/6JVu/TXNPqneWvMF+dHdyrYtprtvMeKUsMsRu+zCyZUSiL6lPags=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.66.159) by
 BN8PR12MB3457.namprd12.prod.outlook.com (20.178.212.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Fri, 28 Jun 2019 07:27:32 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c922:4285:22a6:6e]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c922:4285:22a6:6e%5]) with mapi id 15.20.2008.018; Fri, 28 Jun 2019
 07:27:31 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Andrew Lunn <andrew@lunn.ch>, Jose Abreu <Jose.Abreu@synopsys.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: RE: [PATCH net-next 10/10] net: stmmac: Try to get C45 PHY if
 everything else fails
Thread-Topic: [PATCH net-next 10/10] net: stmmac: Try to get C45 PHY if
 everything else fails
Thread-Index: AQHVLCXCrx1niaeCs0CBNlrs4Af9k6auOg4AgADniCCAAF0vAIAAAOYggAAKKwCAASOeIA==
Date:   Fri, 28 Jun 2019 07:27:31 +0000
Message-ID: <BN8PR12MB32661430AED6693B860EBCC0D3FC0@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <cover.1561556555.git.joabreu@synopsys.com>
 <c7d1dbac1940853c22db8215ed60181b2abe3050.1561556556.git.joabreu@synopsys.com>
 <20190626200128.GH27733@lunn.ch>
 <BN8PR12MB3266A8396ACA97484A5E0CE7D3FD0@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20190627132340.GC31189@lunn.ch>
 <BN8PR12MB32666DADBD1DD315026E9A2BD3FD0@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20190627140316.GF31189@lunn.ch>
In-Reply-To: <20190627140316.GF31189@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3892826d-0cd0-4657-9756-08d6fb9a1514
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:BN8PR12MB3457;
x-ms-traffictypediagnostic: BN8PR12MB3457:
x-microsoft-antispam-prvs: <BN8PR12MB3457B3621BAF20DDC0B6BA65D3FC0@BN8PR12MB3457.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 00826B6158
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(396003)(346002)(136003)(39860400002)(366004)(376002)(199004)(189003)(11346002)(25786009)(74316002)(3846002)(5660300002)(66066001)(6116002)(6436002)(55016002)(68736007)(4744005)(26005)(52536014)(9686003)(66946007)(73956011)(76116006)(64756008)(66556008)(4326008)(66476007)(8936002)(86362001)(66446008)(53936002)(256004)(8676002)(54906003)(14454004)(316002)(110136005)(81166006)(186003)(71190400001)(81156014)(478600001)(486006)(446003)(2906002)(76176011)(305945005)(7736002)(476003)(6506007)(229853002)(102836004)(6246003)(33656002)(6636002)(7696005)(99286004)(71200400001)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3457;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: jZVhHRCGw6F6IAyHCV9n0NIzpgRGxFW5a5aXOmLtFZZA2b+Xtddyq+kD6LePgilRcbr1uUO0f1axBJsFc9kTtX5uS4MQoByYYtzggj3fqbORXizngPtViBuF38wD748nEGpRVm1itPut9gboCHpzXRuHTyONJbrPzsfMv3uWhFekU92its4+IZ9lmtAmosgwv6SXcoOuhlH9TflzTGrDdgzb2JwuGv4hwIL47KgCY5SpikPhKIAYEkReAHP14gXt3bScGyTnpNRpCzEAwzTfdPiGYbzbAl0PjpqABg8f/99S3/s7mQ99/xTOQEfPq4igvqq1SWCPHf7teL9WHce5sunCm2zGYgNoMG/zTN35tuij7B7uiJkjk3Gn1LEAKM4DPS1gLOF4qIrxZdEVTfBCsHqzLiSlaeF4gKNHKtXHKqI=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3892826d-0cd0-4657-9756-08d6fb9a1514
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2019 07:27:31.4761
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: joabreu@synopsys.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3457
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>

> On Thu, Jun 27, 2019 at 01:33:59PM +0000, Jose Abreu wrote:
> > From: Andrew Lunn <andrew@lunn.ch>
> >=20
> > > There have been some drivers gaining patches for ACPI. That is
> > > probably the better long term solution, ask ACPI where is the PHY and
> > > what MDIO protocol to use to talk to it.
> >=20
> > Hmmm, I'm not sure this is going to work that way ...
> >=20
> > My setup is a PCI EP which is hot-pluggable and as far as I know ACPI=20
> > has only static content (????)
>=20
> I've wanted to improve the PHY probe code for a while. I was thinking
> we should add a flag to the MDIO bus driver structure indicating it
> can do C45. When that flag is present, we should also scan the bus for
> C45 devices, and register them as well.
>=20
> With that in place, i think your problem goes away. Architecturally, i
> think it is wrong that a MAC driver is registering PHY devices. The
> MDIO core should do this.

Ok, I will drop this patch from the series until we come up with a=20
better solution.
