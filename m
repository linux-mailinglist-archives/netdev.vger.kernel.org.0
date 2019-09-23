Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08FEABAEA9
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 09:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436851AbfIWHrn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 03:47:43 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:33904 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2436796AbfIWHrn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Sep 2019 03:47:43 -0400
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 92803C03A3;
        Mon, 23 Sep 2019 07:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1569224862; bh=Y8CxeHMC2uXuND2uLrUZYTT0JUm795vCHzxbDqZmemQ=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=TvINwtsDRplRxiC85VtMLbJ2nwF3oUSxqKHqNq8Zs102zlQkBj6tCSSSd45QpDqOu
         lDHdwX6rBOWwm/+UdM4ARo7S3GPP5felEmwe/f8HeAlCk1Ss8+7F1JgCLPsQKqEH4s
         mhHDBCwCJt7NH3bm1kkDYcKLh3uEETpUPLuvoXJ7omaLFIlIJmve0w4IXCsk6ACf3F
         iiXBiC0xufQfCWT7Bw+5xhqNKTRVUZ7V1LPeXLv2VgOojIbRldy8yDZP3ud2UtoATH
         Gv1PSiJeRFQyo51f9d/dUf9MHmglHZ9SXsltsQQaLTLKA7sETt2b+P0m2l7fucH4sx
         0wx6PNf45CHFA==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id D9E39A006A;
        Mon, 23 Sep 2019 07:47:41 +0000 (UTC)
Received: from US01WEHTC2.internal.synopsys.com (10.12.239.237) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 23 Sep 2019 00:47:41 -0700
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC2.internal.synopsys.com (10.12.239.237) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 23 Sep 2019 00:47:41 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Mon, 23 Sep 2019 00:47:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GLTx1s+fMN5PEiNrRp0NS9R+Hru9STLImF6+fXdB3hpJ28VJ8biE/qgh6P9fYFfqovzmU9vbuU0KAbp04QUfK+umJjoxIdq+O/c+GUFHDLFCtB/PWXLnEG9w8PbvHfkU+eg0oMuQI+5JQ9FsuxgbpJhGCD2u9K/KJk/G2IVcYBGhBKKDYlx3P7D3OypoxXEUnszwx6qUxPMzw9brkuF4uaq/iJJKYSSRVVPzJ+DUgyKfS7nLtXXToiAxRoXYB91J7ssjAjB/1NsWEBhjvVq24JNiR4PossejRzCHHKd9w+/124M+bb1w7QMqmcmP/oc9YTGMzlGm+vsmR21tgl3vuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y8CxeHMC2uXuND2uLrUZYTT0JUm795vCHzxbDqZmemQ=;
 b=kFYwEU2UM1J8jCe2+CGhwm87JYNO+kvElg8o0q8jrnj2ZgLV7ygRyT560sEuS+IM21Aj/q/u3k/taACjSe1x0+UNqIXH+gFbZAwvagszidsHPHZnavYjPEr0K3rG/xuCRusxX9QfyYaOL1DgfYjoNvGt3wbqaReE+M9lAlmiPgxZgbpJjfL2aipzSG0T9oh8Qp1YBnAa1L44F8Gbz/zhf5Jak+nrVounR6GnT7X4WXvXq2x9M+VsuF+rfrTmqaYjHkcoBfzCU9T/fNJbeb9H74BL32w26nHFjrCkf3zM4NuoRwL7TSMbJiPLWhYKNybei2lKBmxOxQMREHSfMAbc7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y8CxeHMC2uXuND2uLrUZYTT0JUm795vCHzxbDqZmemQ=;
 b=E7I0Tbf0oGMagMs8oQinfVqM+XDvMHRJj1qQEwd60t6WbPKUtZ0FLqKjJGZWJ4KMBLZj7Lgjw1/ze7sAfvIkDzBigC+tGMQ0FfjCzZfyMah1VBok1UmywQEgcJahpALeRLIiUnBaRGmTDfBaMUSAxp76j+nYpvnwUk81EE67XZE=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB3393.namprd12.prod.outlook.com (20.178.211.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.20; Mon, 23 Sep 2019 07:47:39 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::59fc:d942:487d:15b8]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::59fc:d942:487d:15b8%7]) with mapi id 15.20.2284.023; Mon, 23 Sep 2019
 07:47:39 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net] net: stmmac: selftests: Flow Control test can also
 run with ASYM Pause
Thread-Topic: [PATCH net] net: stmmac: selftests: Flow Control test can also
 run with ASYM Pause
Thread-Index: AQHVceDqbFXTsUNTRUyg8Qcyj7vU6Kc44laQ
Date:   Mon, 23 Sep 2019 07:47:39 +0000
Message-ID: <BN8PR12MB32664C9ED76E9092603F4A15D3850@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <da7e2fb08061b4b89332c0ef014e053f98832894.1569223775.git.Jose.Abreu@synopsys.com>
In-Reply-To: <da7e2fb08061b4b89332c0ef014e053f98832894.1569223775.git.Jose.Abreu@synopsys.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 27f696d2-0675-4e7b-0f6b-08d73ffa4f2c
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN8PR12MB3393;
x-ms-traffictypediagnostic: BN8PR12MB3393:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR12MB339393A043A748429C6B22E5D3850@BN8PR12MB3393.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2331;
x-forefront-prvs: 0169092318
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(39850400004)(376002)(396003)(346002)(136003)(189003)(199004)(86362001)(52536014)(66066001)(33656002)(55016002)(3846002)(6116002)(256004)(76116006)(66446008)(66946007)(5660300002)(2501003)(66476007)(4744005)(110136005)(486006)(102836004)(54906003)(71190400001)(2906002)(64756008)(66556008)(25786009)(8676002)(11346002)(81156014)(81166006)(476003)(6246003)(99286004)(9686003)(4326008)(8936002)(71200400001)(446003)(305945005)(316002)(186003)(7736002)(6506007)(229853002)(74316002)(26005)(478600001)(14454004)(76176011)(6436002)(7696005);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3393;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: iNkRAmM/Epi5OX5TliatyE9yP6NE4U3DsO5I/dl8rmjMA8Ak7TTMmSSkezardVjb+R9eLCeyi8KUWFD1a/0mmQncJJ+YwtI0iLT2PJYmXObKHvwi0U/sgw1NYBCW/5qgn3Jw21ek8PEZtyGLAUiNDh5bX0r1rxrk1NxNFoEeN+5RWyI9AxKUvYV5UsjdSiXNZ21OFD3ekyTdVruz4xsnufUZHHslO2UNbe1l58rle1aMqfl+B2/NHwM/gnx4/03ZVNghTsFQXy1y3nJwVOQsLS9ZUhSyIWwWa8e5l7k/uGoMM7z5qvXBUsbySPVJr9wKRJ5qISJBGDQIMpEC6L4tXhYiTjgQfv0rOdgfvXFyLpT9FdWi5gfx6aahWRkl92TKGIKGw8giVQsyzUU6NetEGLqifHwIr7900GRW3AqMpaM=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 27f696d2-0675-4e7b-0f6b-08d73ffa4f2c
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2019 07:47:39.6867
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: glgX6IoYJxVk48uf8Mm6NQ3uAMboJnFnOjxGAmehYIdUb7X6oVxUw+i3M0S8OeZ4dppsKqfzh5rRYT3UcpXaag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3393
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jose Abreu <Jose.Abreu@synopsys.com>
Date: Sep/23/2019, 08:30:43 (UTC+00:00)

> From: Jose Abreu <joabreu@synopsys.com>
>=20
> The Flow Control selftest is also available with ASYM Pause. Lets add
> this check to the test and fix eventual false positive failures.
>=20
> Fixes: 091810dbded9 ("net: stmmac: Introduce selftests support")
> Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>

Oops, "From:" and "Signed-off-by:" are still different. I'll amend this=20
and re-submit. Please disregard this one.

---
Thanks,
Jose Miguel Abreu
