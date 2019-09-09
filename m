Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9ED0ADCB8
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 18:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733198AbfIIQHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 12:07:09 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:41626 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1733030AbfIIQHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 12:07:08 -0400
Received: from mailhost.synopsys.com (dc8-mailhost2.synopsys.com [10.13.135.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 46CC7C0B21;
        Mon,  9 Sep 2019 16:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1568045228; bh=ew92XB07/w2pmJSr0MYUWYGWt+V/AYxSEIeQj0XfX1c=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=NBFdf0Tp+mawyLizBTP9P1zbf1/QsjfXX3JpbzrrXNc6erfj5ZpBcNlUNz906H7aa
         LrwGD2xYkH2GMkbM/dHwI6bggAIVkOLY+QBjNityj8IQxh07y9NPV11j9ze1idw/vD
         UHYze8IEP3lAvgjkaydGKgewo7ioHhIkXDteAQ4YNSO+9Zpb5AuC26dJ0IFjIO+9vZ
         g9eHEm6Tg/qUwQD00QahPLguAFauTE6U6sPHzn2HLwK/165pkTjR34MVOinN+oWmZJ
         SPHp/eG4/WDa9/y5CKxPz3e+f+ViPF3YMKmXJy/FKkHRZm4UGodBkhaBRHPf3hJP3p
         8FV6LxBY85nFw==
Received: from us01wehtc1.internal.synopsys.com (us01wehtc1-vip.internal.synopsys.com [10.12.239.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 87742A005A;
        Mon,  9 Sep 2019 16:07:07 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 us01wehtc1.internal.synopsys.com (10.12.239.231) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 9 Sep 2019 09:07:07 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Mon, 9 Sep 2019 09:07:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KMy4MuGcdOGAx0vpiDa00Z/+93mF7ajx9+lhZsmGx8jL7+XNpdh76w03ySV/QJWbFgull9InZpeK8/dILoA798bsqf/HIHKR8S7QqGbPeBtmkpqcheZY2EqYGoiAr0bv39ZajpKrQpUF2DCXsGmweKB5ri5VxTwZU/fHckUgrwr6ho/M8Oh2sJ3XB5ba/8RXcmzoBhhLJugTsz5xRijSPxmsiBOC8Vq7AvAWxEHbWjiw4mQlvmK+Ogyyma0U8ZjSMcsGnH6b2tN7EEIishzFmaU4Es9OtsbBMpplqPy2QWSFQNGidSq0/tFgVFmjaSb4gv+ypiPxR/hJtbfBoTlXyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o7i4lTWNyr9yFFupLE9ug0xHNg2fExSBQ53SxV5nj4Y=;
 b=MQVCoSjBSgtpTCETAwMDVi0wDKoKO1y7iCWplz7juI8uIHb6ObZcZzVGHNL/T19NY+YqZWEwDiw+WDy0a4ll4ikzGpCnX1vcekPz/9cLw9h9zk+RWIpFH/VOJauiMNR+NTO1Gd1NcGeHvqlNHOK9KiWYcQMu+f6CWYAokMcZeRQseWhMerVB4k46uqk0VBf/wYYKyTt8dQG8H051ZNq+/Z4QHxF+6dV9/HrEJKmcK4hsJmrmeUnGD+itSmUXdQcM9NuerkGFA7kFRC1plp1SRkOKS1OIXgInWd3MJbMyVM7NGj/p39kDETs0YjIv6aGi+Ji5I1eMyEYtgkGQZjsThA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o7i4lTWNyr9yFFupLE9ug0xHNg2fExSBQ53SxV5nj4Y=;
 b=LHKIYK8WhKfvW6OpLZ4Ge3/+w5CFU0AjsWj7TTL/DN2vwKbo3BFL+fJCpfPAmv4GZCpRYRs6iGTBaoVrzw8ulGpcEqVm2hKOQ+ySoDe3osgAeH9Gwqo8rp2njSTjAjbdJ9kqr3o2hO9OWCgankJzkZcqZOFSfK8kMhQBP9/S/P4=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB3443.namprd12.prod.outlook.com (20.178.208.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.18; Mon, 9 Sep 2019 16:07:04 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::59fc:d942:487d:15b8]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::59fc:d942:487d:15b8%7]) with mapi id 15.20.2241.018; Mon, 9 Sep 2019
 16:07:04 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Thierry Reding <thierry.reding@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Bitan Biswas <bbiswas@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: RE: [PATCH net-next v2 1/2] net: stmmac: Only enable enhanced
 addressing mode when needed
Thread-Topic: [PATCH net-next v2 1/2] net: stmmac: Only enable enhanced
 addressing mode when needed
Thread-Index: AQHVZyLsOFcggZ86CE2HdVeFQfSucacjgrww
Date:   Mon, 9 Sep 2019 16:07:04 +0000
Message-ID: <BN8PR12MB3266B232D3B895A4A4368191D3B70@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <20190909152546.383-1-thierry.reding@gmail.com>
In-Reply-To: <20190909152546.383-1-thierry.reding@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [148.69.85.38]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c4394db9-0f38-4156-71f5-08d7353fc19a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN8PR12MB3443;
x-ms-traffictypediagnostic: BN8PR12MB3443:
x-microsoft-antispam-prvs: <BN8PR12MB34437E380DD9060600567403D3B70@BN8PR12MB3443.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 01559F388D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(376002)(396003)(366004)(136003)(346002)(199004)(189003)(53936002)(486006)(5660300002)(26005)(478600001)(256004)(52536014)(3846002)(6116002)(76116006)(66446008)(66556008)(229853002)(66476007)(66946007)(9686003)(7696005)(76176011)(6246003)(54906003)(110136005)(14454004)(558084003)(55016002)(316002)(99286004)(66066001)(2906002)(6436002)(64756008)(4326008)(81166006)(81156014)(25786009)(305945005)(7736002)(33656002)(8676002)(71200400001)(74316002)(86362001)(6506007)(71190400001)(186003)(476003)(11346002)(102836004)(446003)(8936002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3443;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: FjVd+Ho0QOSqGcUnT3e3RW2mtaP9U2sRJ79jwd6MY8k/UIyEUtD3MrxyV2rUg50tEH7ZjAdQCbbxCGBDgholtThgRDg+YF7F+c0s/7W0xfU+3lg947Jdn4bPG1vN2dj4WtP12OEudD/rT92+JP+A1OmQ2gyDEqZw7IJWo0WsulOF19v3WiC+1RQsFXmCfW7qtddv12qT8HLkz1sOASrjltW3JviNepgQZYX08reRpsKY50hBputobAMMf65SRtyW8r76OZ8kiwlbTitabifraNaQzqusA2FOpbRVPDenK/hJKYqd8mqTZQlgra7s0nX/7Z0C2cCxhiCxmjz4vsGUJUuK9ne6Tg/iboTbRE/KQT6IiYF8JfPJ8K763wCbuaNrDOgOi519gz/zD/FQC3oChjBKJ4gxsYSAURLw8Km4ock=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: c4394db9-0f38-4156-71f5-08d7353fc19a
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2019 16:07:04.2681
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o/g2XQUrQtxn0tDbMQkK+IMKwS4h7r3rDj3Ql+grWzBefcwOMmRrRH430j0dXc7ybVptDBY6W8S+A3zKC9JmAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3443
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thierry Reding <thierry.reding@gmail.com>
Date: Sep/09/2019, 16:25:45 (UTC+00:00)

> @@ -92,6 +92,7 @@ struct stmmac_dma_cfg {
>  	int fixed_burst;
>  	int mixed_burst;
>  	bool aal;
> +	bool eame;

bools should not be used in struct's, please change to int.

---
Thanks,
Jose Miguel Abreu
