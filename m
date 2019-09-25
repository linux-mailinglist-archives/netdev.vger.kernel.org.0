Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48E86BDD48
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 13:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404106AbfIYLlR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 07:41:17 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:49936 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732353AbfIYLlR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 07:41:17 -0400
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 91920C0444;
        Wed, 25 Sep 2019 11:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1569411676; bh=Ozt3AeUJmG/UhtrNAKolaq0b3Bz77aErX4Uc+QGY11o=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=hZCommNJ+5vp/hwrqYWKj363N8nKA19GenTS0SuSvFfVdV1wnBrCfKVxusd/XCXJ0
         0/Szop2XHUeBlbHjnc3jRQGGj+ay8CpocKlgE/w5adpm9vg2fQ7Smm/iiYNpOtFsjL
         7fH/0tDaNcsrw+9fpMb54HBQkOlrpoefWvo7FFTf5WWGMxi6J9oXCDbbOqoaLcnkk8
         vMuS/8tTafijIfYHZLz5biO86sak+VOgwWCFfC9wR6IUnrAyuyZ0D8drOJZZjA0vCO
         ndL7xWTV6L00/VuLy46Pl75cABD00/YLjqZFQ+g12//92UzY3kmAeWwsIb02V2c9VB
         QA6sf0oJsE1fA==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id B1D6AA006B;
        Wed, 25 Sep 2019 11:41:15 +0000 (UTC)
Received: from US01WEHTC2.internal.synopsys.com (10.12.239.237) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 25 Sep 2019 04:41:08 -0700
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC2.internal.synopsys.com (10.12.239.237) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 25 Sep 2019 04:41:08 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Wed, 25 Sep 2019 04:41:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hIBZBPxglvb/KCd4vZrA7ZGmjQ93Da7F+MHvS4oKZ9zcDS8+5xjqDHpJBTmblIsCyENw0/Oibbhe3WNIEvKVdW6jMYWxezRHeDBcqbNE7CI9J7J7KAEQy1AvPfpKKBdrsddB/1Hw9SLvMvTFuO5aVM+gAREkSTJTW73mDBnUsQ+VkGaTSEVGVvPnzf/VxHwl2eCq9ZRuhbncnHYdIYxbZF7uKkv6gPicisaudbdFggtMsrBcsgRr08tDNFYPEpATw/7ddowonT9Yfdc5FeJAzbuoA3S4EDVhZcu1yoo5uVXCgCbfB4qd0jAXl1kR0D5UvVrMaRItpYcCG9eoX2QNJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p5B0dFQ3HXj0Fe2aJ9YU8v1JnOcqGxFBgozx9D6fi3o=;
 b=CszM/AnsMHvnHC1P35VFikRXZR6FTPrUCc2CiU9Hgfg5wxPhVOFkGuapTNEXPRxMmucwlOsuOwNV1qxMTDvEZpBwtpo9JzwV+7k6+igyXmoYXAYHKNxUQ6MnrZs0Ur6CUCg3NWkExUBaZDlCUBP3znX9op90c+A1sOCa4Lllkf3hyRQFua5DvwHt3yqWOAQTuPEHCWx2YMYiJAaDlmg8+1PhZotzZ2OurkCPrc4dUEbkQbOjeZqLC9GdhbkrTp65SFhXD8EznF9EUb4SGTgEsFyaZPrZB6MDZlK40ApppeKmCJVIr8YN3iBoBJQtNHV4wf2X3S541v9GreTKXt1+gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p5B0dFQ3HXj0Fe2aJ9YU8v1JnOcqGxFBgozx9D6fi3o=;
 b=Tl0AaqpZ4eWPPA6MbxpgMybsqYmEgZ8z6iXnRBpqtq4vzFjqpKN80IJapunZEE88tSoqpczc/Q1DhohJIelWFL6LYj+yb8j/MMdFNhopXKbBXyzfwoAHfcnSeen9Kt1doXqpyZKeJZiBC1/4hZePEDI+nCksAXn+r6zhTHJAGtU=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB3251.namprd12.prod.outlook.com (20.179.64.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.19; Wed, 25 Sep 2019 11:41:04 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::59fc:d942:487d:15b8]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::59fc:d942:487d:15b8%7]) with mapi id 15.20.2284.023; Wed, 25 Sep 2019
 11:41:04 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     David Miller <davem@davemloft.net>,
        "Jose.Abreu@synopsys.com" <Jose.Abreu@synopsys.com>
CC:     "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
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
Thread-Index: AQHVb9UIZvUBuIRUTEGi7mSYMt4cT6c7QXkAgAD6QdCAAA7TgIAAAZPA
Date:   Wed, 25 Sep 2019 11:41:04 +0000
Message-ID: <BN8PR12MB3266A2F1F5F3F18F3A80BFC1D3870@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <20190920170036.22610-1-thierry.reding@gmail.com>
        <20190924.214508.1949579574079200671.davem@davemloft.net>
        <BN8PR12MB3266F851B071629898BB775AD3870@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20190925.133353.1445361137776125638.davem@davemloft.net>
In-Reply-To: <20190925.133353.1445361137776125638.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 52cbe06b-b141-4132-41fb-08d741ad3f57
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN8PR12MB3251;
x-ms-traffictypediagnostic: BN8PR12MB3251:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR12MB3251EE8E15F5BAE0371B6C70D3870@BN8PR12MB3251.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 01713B2841
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(376002)(346002)(136003)(366004)(39860400002)(189003)(199004)(52314003)(229853002)(26005)(5660300002)(305945005)(14454004)(256004)(102836004)(14444005)(186003)(74316002)(6246003)(52536014)(3846002)(66066001)(6506007)(2906002)(478600001)(6436002)(81166006)(316002)(8936002)(76176011)(110136005)(4326008)(54906003)(8676002)(6636002)(6116002)(66556008)(11346002)(64756008)(71200400001)(71190400001)(66446008)(446003)(7696005)(66946007)(66476007)(55016002)(86362001)(9686003)(2501003)(25786009)(99286004)(81156014)(33656002)(486006)(76116006)(476003)(7736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3251;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: f4l8getvjB41dE4G+1cTnVtVnafBrXUsnEx3MBg23D7RwWkfUe8Ue63Y+qACzj1l/e4eAahZKYE6jfLH0DprfurDaq9ZgPwp8yD3P/cVntACAj2Z0vB9FhAVxecSh3Cqfd1CYDMnXD2jriTrD2C3p8JtKuamvUN18lmeB0nI4M/NeYLhTikEwIYcyR8lcjYwp1tDvSvPeZii6rpD6fyej64WpOllleBPv3DAZ2q6CLvtvUjJTtokhv/rQkhWozjzBd0ALPvc37Xpc2F1qqZQAk5qeDgZWxsJVCW3oPLATDolaNNf4+DlHxVMk9AOYreVjhoq/cdXdUmcvXImGkeTXIL9CKY5B54+tM+657gqlYYZNU93vB5rw+CQYtqL+m0ZcmPazn6MRtJp9P9219gGYlZFLwLAxq9unX4dC2tB6hw=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 52cbe06b-b141-4132-41fb-08d741ad3f57
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Sep 2019 11:41:04.2336
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SD4sx2kW+kIINcn9ywYk3C36xVHQPARLIAe1As7d5TK/WgJBoT17WlqyGRzfnfJszCVz5KFol8s4EtkiBO9yeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3251
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Sep/25/2019, 12:33:53 (UTC+00:00)

> From: Jose Abreu <Jose.Abreu@synopsys.com>
> Date: Wed, 25 Sep 2019 10:44:53 +0000
>=20
> > From: David Miller <davem@davemloft.net>
> > Date: Sep/24/2019, 20:45:08 (UTC+00:00)
> >=20
> >> From: Thierry Reding <thierry.reding@gmail.com>
> >> Date: Fri, 20 Sep 2019 19:00:34 +0200
> >>=20
> >> Also, you're now writing to the high 32-bits unconditionally, even whe=
n
> >> it will always be zero because of 32-bit addressing.  That looks like
> >> a step backwards to me.
> >=20
> > Don't agree. As per previous discussions and as per my IP knowledge, if=
=20
> > EAME is not enabled / not supported the register can still be written.=
=20
> > This is not fast path and will not impact any remaining operation. Can=
=20
> > you please explain what exactly is the concern about this ?
> >=20
> > Anyway, this is an important feature for performance so I hope Thierry=
=20
> > re-submits this once -next opens and addressing the review comments.
>=20
> Perhaps I misunderstand the context, isn't this code writing the
> descriptors for every packet?

No, its just setting up the base address for the descriptors which is=20
done in open(). The one that's in the fast path is the tail address,=20
which is always the lower 32 bits.

---
Thanks,
Jose Miguel Abreu
