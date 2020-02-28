Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEE02173DA6
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 17:54:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726872AbgB1Qyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 11:54:35 -0500
Received: from mail-vi1eur05on2135.outbound.protection.outlook.com ([40.107.21.135]:2209
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725876AbgB1Qyf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Feb 2020 11:54:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UZ7lWOdIzoBGSgWfCep+Pyz9zfgaEtIgYCg0LQuvpAkrdcMIuQxD7NVO4Oh35ZC+SQrgNJ4Veu8p575MoK0uSgcnr4FoIWk+y+MdMGydy8M9w+7HZ6As2iwzAvPZoJvAWHCUHEACfCFVWp4rMhwvdArnnIqM10RPEIqMj55mNx9OQDy0n9VUR5GxzHYqQcTuUrdZLTxTpCsuki0BElkvlmOl2yAuIjBfj9fqlZeZPsb9ptcoOwXFo3s+oGsAgwLstVX4VH0B9HM9X6zAhjfidajTQQtJ4UObb2bqZ0hdv7uzTNXKAmBdF7ZfFYiak/6Rgn9gIkE5ln6Qe/1AbFvSOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9mWbtpjrUBbL3PJKRNrOsqzQFjMuwjWJ1ZAs1tI8pCo=;
 b=Ci1WN7FfQJtutpJNOqppZo6k0980akp6bLwG7Rt/S3iwdO8pt6R5J64IB143sumn0+lenCvUk+9pnJnltzLjedW01Q10ZvRs9G4E7V8v6L8/dv8W7P9hj3v0QqOewi2exO2ucr6vJ/64tCaRtJfg1xXcf3C1YHYWZoh38yCGYZC+zLk0BKeRyQMn8ux4irXC68wMQA7Wf7jrWuyeJWS/IhvZk7hyb++nAuVNxsYC9ufEPxcDekKdj4Vl5Z8C8+xfJjaEAyKu/iuJeUo2HZ5+GqbIPJ+TYp5bdEqLGoXvA2RUPC14FJm2tPfon17DqB4iGPJCLv9ZZ6x0+Y6Wzj7Djg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9mWbtpjrUBbL3PJKRNrOsqzQFjMuwjWJ1ZAs1tI8pCo=;
 b=xMaZkTVcvUpMCA7tLaolVHBEu+agCKwPJfbsxkkfqcZO8RGSsZIKRtCIXuqgkVBJclvqXGjKnroUJe+f57Cd1QElEoIaGXHmw2aI6HQfM4bXm5Y91HbIAEqcceaPmKyOkLma1JA5QUzMgGSKXUiMPwzUhuNiC8R/geGW5FQ772w=
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM (10.165.195.138) by
 VI1P190MB0016.EURP190.PROD.OUTLOOK.COM (10.172.13.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.21; Fri, 28 Feb 2020 16:54:32 +0000
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::a587:f64e:cbb8:af96]) by VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::a587:f64e:cbb8:af96%4]) with mapi id 15.20.2772.012; Fri, 28 Feb 2020
 16:54:32 +0000
Received: from plvision.eu (94.179.130.92) by AM5P194CA0016.EURP194.PROD.OUTLOOK.COM (2603:10a6:203:8f::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.14 via Frontend Transport; Fri, 28 Feb 2020 16:54:31 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
Subject: Re: [RFC net-next 2/3] net: marvell: prestera: Add PCI interface
 support
Thread-Topic: [RFC net-next 2/3] net: marvell: prestera: Add PCI interface
 support
Thread-Index: AQHV6/jzb8NjbprnTkmsDy10O4uRHKgu45iAgAHz8YA=
Date:   Fri, 28 Feb 2020 16:54:32 +0000
Message-ID: <20200228165429.GB8409@plvision.eu>
References: <20200225163025.9430-1-vadym.kochan@plvision.eu>
 <20200225163025.9430-3-vadym.kochan@plvision.eu>
 <20200227110507.GE26061@nanopsycho>
In-Reply-To: <20200227110507.GE26061@nanopsycho>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5P194CA0016.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:203:8f::26) To VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:35::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vadym.kochan@plvision.eu; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [94.179.130.92]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f849a274-d66f-411b-b71c-08d7bc6ee246
x-ms-traffictypediagnostic: VI1P190MB0016:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1P190MB0016E81263E98C13F763925195E80@VI1P190MB0016.EURP190.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0327618309
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(136003)(39830400003)(376002)(346002)(396003)(199004)(189003)(16526019)(7696005)(5660300002)(186003)(71200400001)(44832011)(107886003)(4744005)(66946007)(66446008)(36756003)(66476007)(956004)(508600001)(316002)(64756008)(66556008)(33656002)(8886007)(2616005)(26005)(8676002)(81166006)(1076003)(86362001)(52116002)(4326008)(55016002)(54906003)(8936002)(6916009)(81156014)(2906002);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1P190MB0016;H:VI1P190MB0399.EURP190.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: plvision.eu does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aId2MRPjQRq085BYhUwTlxmQ1F/bWka9gzaj20gwUFdCzCtuGtmP1pubajODDjJXHFCMRY4O3ULHdmwB98vUyzYNqzDqX6M8p16m3VWSctPP3Qf6gav9rzLK7IkrRcctFi64kSGXGc0TaDdZSrZTOKzo4ynvuEHt4vhSimOmtjJKFwA8z4dA3fUqMa8yBoLRJnYmQTE+I0w0ziTg9X8cYpmLxWPdxRIqym62l/aTOJ8AY7PXXaMiwHpNd/UqEvOtEmZ9vHLTSpmaMEUu0jgXIITbNEjJ1KHQMMs50I5oO2koaktFaD6lJYwvGY39SUxaH4WWlimiZLF+EY/1cqDOgw5W0EpaOf9HXoJHpMeNCg0SEoaCfVHdxdT5/1QNc7zMRjruptboFLEtJNN1tUDZyzd4H9H49v5GYODeEOOLpL2iyrnutFvENzmvypxz2uce
x-ms-exchange-antispam-messagedata: TQBvF2YPrsv9BVMEmBRmNx6aFBHIHooLATPMB+0b4vZgHCCHna/oRlHDfmq+yQTjjosXpwXHkpePthGE2nnL7aC0oiWlGo5exdErLdpqkHdK1Y26msH1eAhjJ9PkWi2HgTVLlHApy7NVMRXCtTpB2Q==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <155B807745CBF74DA758337C2107D515@EURP190.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: f849a274-d66f-411b-b71c-08d7bc6ee246
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2020 16:54:32.7022
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2WDJ3aKA+be5H6wkL1lDQR8g7QXaz/WGDa7nmrG+jT2E0uHoRcneZ13FDrudf5EVvmyWTGsNfO2q68EphcI2QWqcN9k2JS2HBiWxa8VrIO8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0016
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiri,

On Thu, Feb 27, 2020 at 12:05:07PM +0100, Jiri Pirko wrote:
> Tue, Feb 25, 2020 at 05:30:55PM CET, vadym.kochan@plvision.eu wrote:
> >Add PCI interface driver for Prestera Switch ASICs family devices, which
> >provides:
> >

[SNIP]

> >+
> >+module_init(mvsw_pr_pci_init);
> >+module_exit(mvsw_pr_pci_exit);
> >+
> >+MODULE_AUTHOR("Marvell Semi.");
>=20
> Again, wrong author.
>=20

PLVision developing the driver for Marvell and upstreaming it on behalf
of Marvell. This is a long term cooperation that aim to expose Marvell
devices to the Linux community.

[SNIP]

Regards,
Vadym Kochan
