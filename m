Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 049F5BDC5F
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 12:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390505AbfIYKpB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 06:45:01 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:34922 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387944AbfIYKpB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 06:45:01 -0400
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id C5C38C03C0;
        Wed, 25 Sep 2019 10:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1569408300; bh=mLgbbewSI9u8gits1uVq2paS8q2Q8dyY4aDIBmv8I7Q=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=VlK0kz8jjyPS5y181V0qOUDRZrCPdxuHq1LAWozSbfzqE58Yp3Zg9zOtwNo2NTVzj
         OVtf+FjHb9Juy3E4rcPYdpKPEC5eCTkjTRup1yNkV8zKF3VFvTT2qux8Xa4rZEqJn9
         u0JbxtipKoXeFewMCWZ/NIUoULjvChTedXezUi3Du4gtf986LhYf3UuAc3dBu5lSWd
         DvZ5bYdqJ6THi7UMCU0Uj+azIwMda7jSjH/upqmer/PHWGaTJ3TJD/ev2gXRxN+Tpr
         6cfzrAqNMmE+0O/Q+K2jtHGg8Z4cPjQYbXVdo2ih7F8F6aceH/FHMijjoNvWdxTXLd
         ARhF1OOaG48wA==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 35CFCA005A;
        Wed, 25 Sep 2019 10:45:00 +0000 (UTC)
Received: from US01WEHTC2.internal.synopsys.com (10.12.239.237) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 25 Sep 2019 03:44:55 -0700
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC2.internal.synopsys.com (10.12.239.237) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 25 Sep 2019 03:44:55 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Wed, 25 Sep 2019 03:44:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XTQleLfEg/zIdGe0TfHOHx/XHz2x3dtv2iROo4WygppZ5FH8QKZyEJ95/N5ITi831BYZMZBY1qwlzEGCyVANS32rRwvTBYpZcATgjIXd1JDtvLKdGh79bp2RhaEiM/pEN9naHnMfZbl7r1zuWRV0xWH5UGv0Vde/ZxnC0kEgszVOjchlOd5qzq8Y8+UD3xqLHbHivUBzDN0wjCRPE5rrNrL5HdsfanybpEqTxfRdKnKOFZm8PZDr0H2JeEuqDAUlkLQLhGolkdacvzmfaJsXmX8ne3esXK1j42uvWAYY5xp09D9ungvKIcynA/IeOwRxU+pjm0k9yfHl2DYvKLMoag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uN15jqXDNFziV0XSLrpXf1x5dOdopYowZcZ0z15BWa4=;
 b=Y22rx3c7erd0n9rOcdoXQO9EKhCNMdYlWA5WUISN+5/RSBLQ7ujerhk8wptUtN8Kb+RgVzWnwvWz4KHJezoIgerggI/g18SgR+Kr5nfeO/pRtVHf7Lq6VKznktLODkov94AMiT6cSYX387t6TbOtKMEH64YHrTAC8l/TBL8BzHnxrSIN4WhmStTvDiQkzUZZIKMVQ93PBRdZE/7U+saAdHawaavf8y0Md3Wdqm4fxp0YV2ifSKO5TLWobtUVcU8xEbpkUw8Wwh9DWtVPo1f1hmDUQbhpxy6tlYFXD50aALILHY1qC3AQCfmAw1jcuZu2Dyty7H5V5jf1/92CCQr7eQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uN15jqXDNFziV0XSLrpXf1x5dOdopYowZcZ0z15BWa4=;
 b=BGmoVu67/GhzipGizge3tK4iNnG1lIMQYu1kk1HKbTdN9KwLjbiV08V02rGdx4Q14Dnq9in0jtos74DfxLQj1mjJSHIkKlaVmlGHVneicZf0RKit+wcJGBBDKQAeRRgXOXT0kv5bYfCeVJCKMqwZWXQy0Kvkc5jiRiLXyp6QHHk=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB3026.namprd12.prod.outlook.com (20.178.210.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.25; Wed, 25 Sep 2019 10:44:54 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::59fc:d942:487d:15b8]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::59fc:d942:487d:15b8%7]) with mapi id 15.20.2284.023; Wed, 25 Sep 2019
 10:44:54 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     David Miller <davem@davemloft.net>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>
CC:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>,
        "bbiswas@nvidia.com" <bbiswas@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: RE: [PATCH v3 0/2] net: stmmac: Enhanced addressing mode for DWMAC
 4.10
Thread-Topic: [PATCH v3 0/2] net: stmmac: Enhanced addressing mode for DWMAC
 4.10
Thread-Index: AQHVb9UIZvUBuIRUTEGi7mSYMt4cT6c7QXkAgAD6QdA=
Date:   Wed, 25 Sep 2019 10:44:53 +0000
Message-ID: <BN8PR12MB3266F851B071629898BB775AD3870@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <20190920170036.22610-1-thierry.reding@gmail.com>
 <20190924.214508.1949579574079200671.davem@davemloft.net>
In-Reply-To: <20190924.214508.1949579574079200671.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7a0ef96d-483b-46d5-10dd-08d741a5666f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN8PR12MB3026;
x-ms-traffictypediagnostic: BN8PR12MB3026:
x-microsoft-antispam-prvs: <BN8PR12MB30264E1063E343DF13556274D3870@BN8PR12MB3026.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01713B2841
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(136003)(376002)(396003)(366004)(346002)(199004)(189003)(52314003)(8676002)(54906003)(3846002)(4326008)(14454004)(71200400001)(478600001)(7696005)(76176011)(9686003)(99286004)(52536014)(33656002)(476003)(6246003)(186003)(66066001)(66946007)(86362001)(26005)(55016002)(76116006)(229853002)(71190400001)(5660300002)(66446008)(66476007)(66556008)(6116002)(2501003)(64756008)(14444005)(446003)(6436002)(305945005)(110136005)(81166006)(8936002)(25786009)(6506007)(486006)(11346002)(7736002)(316002)(74316002)(256004)(102836004)(81156014)(2906002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3026;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: rLVMkeS+MvscYj9ssq5GlDTAQtbMuvh+NC8pS4NXkjvfuWWKgRquJAZ1DKuc1QLu9tZbb7SEIEwXoVNNWU/C3Bv+tpqt/KlJATaH8uuWXj4O3fgbhgwS+c1sg+aIGbPzNtC88+jHqv20ABCC14JQjVfNir8J5CD5Anz+hyXExAdrx15RtYzcNKV0tRllZfCFZfbxYAKqcRqqSEpP4d2YNaEigRpKiZPr0wVjoe+b/VaSsHD/FAvdvElwuK9z2vi1qAm21ScmVXgkDHV/z03HYAtj7ybvTbDfLqQAt34ee+WDXpjgMkSLYiNfgSWmosOt8TRCfdUN8AYRQjD7MbQTY0OL1SrqM6fIPvpTFHdyQsUEuunbMyPAnOVQWH7t22brCDU4ffVOs3Niwc5fLhImUx/FERwr8R200QteapYZMug=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a0ef96d-483b-46d5-10dd-08d741a5666f
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Sep 2019 10:44:53.8899
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qIHzM13jvCiMHgw7ETSA3otV8tM+E1ZI8BPK4Ke80u4zON/QW2K9/+eRVBOws1KK024Tnsrxn5f52QBcv65SSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3026
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Sep/24/2019, 20:45:08 (UTC+00:00)

> From: Thierry Reding <thierry.reding@gmail.com>
> Date: Fri, 20 Sep 2019 19:00:34 +0200
>=20
> > From: Thierry Reding <treding@nvidia.com>
> >=20
> > The DWMAC 4.10 supports the same enhanced addressing mode as later
> > generations. Parse this capability from the hardware feature registers
> > and set the EAME (Enhanced Addressing Mode Enable) bit when necessary.
>=20
> This looks like an enhancement and/or optimization rather than a bug fix.

Agree.

> Also, you're now writing to the high 32-bits unconditionally, even when
> it will always be zero because of 32-bit addressing.  That looks like
> a step backwards to me.

Don't agree. As per previous discussions and as per my IP knowledge, if=20
EAME is not enabled / not supported the register can still be written.=20
This is not fast path and will not impact any remaining operation. Can=20
you please explain what exactly is the concern about this ?

Anyway, this is an important feature for performance so I hope Thierry=20
re-submits this once -next opens and addressing the review comments.

---
Thanks,
Jose Miguel Abreu
