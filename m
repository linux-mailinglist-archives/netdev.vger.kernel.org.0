Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85285CEB1F
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 19:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729359AbfJGRyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 13:54:06 -0400
Received: from mail-eopbgr770107.outbound.protection.outlook.com ([40.107.77.107]:64679
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728031AbfJGRyF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Oct 2019 13:54:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QI2KEt0EO8sk2jvqTlvmCVke1+XTvaTXTO5qze6IYqXMdiMEVZQJoEEaRbgUmjQ6PJ3WtK9ZERsdhguIay4+xIoac5dQsfrf26rL8JncBZ0o3FMIX6FxxCGgkZ/0g3COejmGw4yAtU9M/LxoRNbwGyQgACQxoDh9kJN/j85zCnNgmucv2HdjQIl2+v10P8/wNDRQgo8YmNLQM3CQlIwWB6ea1FFv0uV68CTwCxPIVp+3Ko9CBDMDTJfAzfbqpUD8BRhYoqn5c9CzH1daGNtbHGZI0cqlwqu0l3Jkz4YjGrmJqOKMUxez3ATs9kShY/g2nu2wA8WcqtOjtfq9qXKxbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k67Yd9ComTsp/9U+8HFQTyGyRwGDjPa6W5Fcf8YIxck=;
 b=TKnfxGbJ5tHaIwaSlntGen85gaFe5tRiVuJfNIlY2sU2+fESKf/Yu09w4GtPwVnCDtX5Ax4k4Z+WFnalMV9dwcWumc2wlMtF2M4x3Wd9ed0ws3Jl5idAQs9rxhMRULmY4mIkUs/19bQm5cvMvEQEWSzR640YGAcVNW5fuX2m4Kolw2cBxMeWwWFNk/2INzkByMFmWhnamQRjIjGj6GhEtRG26sr2gAH6gJTcgx5qWSehzKeOXkxO20RLoVtbxO5PSUytmd3787a3OWepGsUdbsh6UWVyB5PW8vcQLg67EOYduNFLAQdVrtgLcfXCrJk/CpgBZav3AavunZfYqVzznw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wavecomp.com; dmarc=pass action=none header.from=mips.com;
 dkim=pass header.d=mips.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wavecomp.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k67Yd9ComTsp/9U+8HFQTyGyRwGDjPa6W5Fcf8YIxck=;
 b=Fw1BaNOyLMSYiKTWWSuMWQhnXUtJ5YC3jgyy8fYSTbYG9pZcKwIKIDDWf5xhLMeWjz+MC0beaDjgk7rAOacwBOfTGW/rqyCp3cJ9EEZLrwBUpDTKHYo8Gj39trkQX+/LDqgSxENS9rKDwYeEW+O0/aDTfWqgmyUWu6nZ7t+gIZE=
Received: from MWHPR2201MB1277.namprd22.prod.outlook.com (10.172.60.12) by
 MWHPR2201MB1549.namprd22.prod.outlook.com (10.174.170.162) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.24; Mon, 7 Oct 2019 17:54:02 +0000
Received: from MWHPR2201MB1277.namprd22.prod.outlook.com
 ([fe80::3050:9a38:9d8e:8033]) by MWHPR2201MB1277.namprd22.prod.outlook.com
 ([fe80::3050:9a38:9d8e:8033%5]) with mapi id 15.20.2327.025; Mon, 7 Oct 2019
 17:54:02 +0000
From:   Paul Burton <paul.burton@mips.com>
To:     Thomas Bogendoerfer <tbogendoerfer@suse.de>
CC:     Jonathan Corbet <corbet@lwn.net>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <pburton@wavecomp.com>,
        James Hogan <jhogan@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rtc@vger.kernel.org" <linux-rtc@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>
Subject: Re: [PATCH v7 1/5] nvmem: core: add nvmem_device_find
Thread-Topic: [PATCH v7 1/5] nvmem: core: add nvmem_device_find
Thread-Index: AQHVfTg0kX/N0hhhMUmGtPbQOCMv9w==
Date:   Mon, 7 Oct 2019 17:54:02 +0000
Message-ID: <MWHPR2201MB12773F2193BDE76C4A5E1A74C19B0@MWHPR2201MB1277.namprd22.prod.outlook.com>
References: <20191003095235.5158-2-tbogendoerfer@suse.de>
In-Reply-To: <20191003095235.5158-2-tbogendoerfer@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BY5PR04CA0013.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::23) To MWHPR2201MB1277.namprd22.prod.outlook.com
 (2603:10b6:301:18::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pburton@wavecomp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [12.94.197.246]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c995cd37-6b11-4d2d-c9fd-08d74b4f567b
x-ms-traffictypediagnostic: MWHPR2201MB1549:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR2201MB154984C25D295B1CE1B464E6C19B0@MWHPR2201MB1549.namprd22.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 01834E39B7
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(136003)(346002)(396003)(366004)(39840400004)(189003)(199004)(52116002)(99286004)(476003)(7736002)(305945005)(54906003)(76176011)(25786009)(486006)(33656002)(42882007)(478600001)(2906002)(11346002)(446003)(52536014)(5660300002)(6246003)(7696005)(4744005)(71200400001)(71190400001)(66066001)(316002)(14454004)(229853002)(7416002)(102836004)(9686003)(81156014)(6436002)(81166006)(6116002)(55016002)(74316002)(3846002)(44832011)(4326008)(8676002)(186003)(6916009)(26005)(966005)(386003)(8936002)(6506007)(6306002)(66946007)(66556008)(64756008)(66446008)(66476007)(256004);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR2201MB1549;H:MWHPR2201MB1277.namprd22.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: wavecomp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CZ7UIjHVFdHwAshDA9YdnVkvufhhc58mNYEhYlHxkGRAY80iwmpDl55Ep3hH46wi5qjE/4C+N2a1hjpHXCFrxcV0NvMIiIW1mXeshqy7fG9l590Juo979W6oTBKU04hVboqJmfbieGA4CcCkAXYotyhl5TSG2JqZOrVnCpLoFCsRFCJRfh0YrZeStX0L9tufM82ILx50Xx1QBQ6KxWMAwWyRbI3cknFNN698ZbNwrpufbV6mxbB1tfADjD9ycloDVjqe8YFr7Vz8FJEcKYp6ceuhgrrpiPYfP1p7wF3m0Zi0f6Dm02oShuV8g40JwOOH2jQVqmxBEIg61ip9gqbPib+TNkIoXYsRnF+Y1C+U4Jnr4jiR7SqKqlhpuIb00rQeHXU8ibJGG3MzdNUfK33M+cQS2o7aolrAN521XET8qh4Q7ruxBY6zbatMBLARwrxNSWg33OClobtPDbd229hkMw==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: mips.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c995cd37-6b11-4d2d-c9fd-08d74b4f567b
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Oct 2019 17:54:02.5855
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 463607d3-1db3-40a0-8a29-970c56230104
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rw3ZTW//Wxh6L1PlbNc2H5Xzh3WG/O++AFpzeiUw6Ct3UWuI2/f9/+QSi7A5CwUA08VQ/PoH4f2rn6PqqtmXUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR2201MB1549
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Thomas Bogendoerfer wrote:
> nvmem_device_find provides a way to search for nvmem devices with
> the help of a match function simlair to bus_find_device.

Applied to mips-next.

> commit 8c2a2b8c2ff6
> https://git.kernel.org/mips/c/8c2a2b8c2ff6
>=20
> Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> Acked-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
> Signed-off-by: Paul Burton <paul.burton@mips.com>

Thanks,
    Paul

[ This message was auto-generated; if you believe anything is incorrect
  then please email paul.burton@mips.com to report it. ]
