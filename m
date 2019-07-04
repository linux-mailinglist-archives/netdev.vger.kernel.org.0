Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FDD35FAD6
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 17:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbfGDP1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 11:27:24 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:47646 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727066AbfGDP1Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 11:27:24 -0400
Received: from mailhost.synopsys.com (dc8-mailhost2.synopsys.com [10.13.135.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id C1C99C0008;
        Thu,  4 Jul 2019 15:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1562254043; bh=tWhVrwNQwMylUXeLl5bGI+0zEW71xFdtiMHgnjrZ/Lw=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=QZ2FmLXkFolrc9vs4QVfY1zCaQ+DRNnBgWZJPAkSZinQbzYeLhm0TfJyxEiEE2+iW
         sfOPHGP0exCK26z0HnN90q4B40vcmnhLqwI6l3O6Y6nzROo6bnqPwjlAWGWBW9tXhR
         GhcnPZQlFQiKX0rGv8ze9fLEA04KpNabIkT+90JIhv12TgXgNAur5WTePRnnvwxCBk
         gDTpkqzXNbBSnqc5KbseXfFifCg08j8rsiAEw5vF7lo+B6cbxmS7NX+VuLQInPifWb
         G92hAgWQGC8BxC0lSm4v0qOLfqnKpjP0q8lU7ipviQ+NI65mFoqWldeNUYVn/9d3JX
         V3yn0ywUMbUZw==
Received: from us01wehtc1.internal.synopsys.com (us01wehtc1-vip.internal.synopsys.com [10.12.239.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 517AAA0067;
        Thu,  4 Jul 2019 15:27:19 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 us01wehtc1.internal.synopsys.com (10.12.239.235) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 4 Jul 2019 08:27:18 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Thu, 4 Jul 2019 08:27:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector1-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tWhVrwNQwMylUXeLl5bGI+0zEW71xFdtiMHgnjrZ/Lw=;
 b=fYMq+GGw7r7ZfkqGCKAjHCUlire2Chq9/AVRE6tKeXWynBERBOJuqvv8GHG5PmpRTljQdQ42vK9fF5tU3e2AC7GrFGjGnJ5zzH5pO+qUGD/tr+hFHo7xmyHaAp/D8uLnwX6qYIlYyAOqg/9/qpoFSDFTaz7Q+hzV9sEfUvX8ZvI=
Received: from BYAPR12MB3269.namprd12.prod.outlook.com (20.179.93.146) by
 BYAPR12MB2742.namprd12.prod.outlook.com (20.177.125.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Thu, 4 Jul 2019 15:27:17 +0000
Received: from BYAPR12MB3269.namprd12.prod.outlook.com
 ([fe80::f5b8:ac6e:ea68:cb1c]) by BYAPR12MB3269.namprd12.prod.outlook.com
 ([fe80::f5b8:ac6e:ea68:cb1c%4]) with mapi id 15.20.2052.010; Thu, 4 Jul 2019
 15:27:17 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        "Voon, Weifeng" <weifeng.voon@intel.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        biao huang <biao.huang@mediatek.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
Subject: RE: [PATCH v1 net-next] net: stmmac: enable clause 45 mdio support
Thread-Topic: [PATCH v1 net-next] net: stmmac: enable clause 45 mdio support
Thread-Index: AQHVMUG0rCeMq5nLQ0Cy/xNSJ9TQsKa47i8AgADANQCAACDKAIAAKz2AgACDBgCAABlnoA==
Date:   Thu, 4 Jul 2019 15:27:16 +0000
Message-ID: <BYAPR12MB3269D85EA4B012B71E896900D3FA0@BYAPR12MB3269.namprd12.prod.outlook.com>
References: <1562147404-4371-1-git-send-email-weifeng.voon@intel.com>
 <20190703140520.GA18473@lunn.ch>
 <D6759987A7968C4889FDA6FA91D5CBC8147384B6@PGSMSX103.gar.corp.intel.com>
 <20190704033038.GA6276@lunn.ch>
 <D6759987A7968C4889FDA6FA91D5CBC81473862D@PGSMSX103.gar.corp.intel.com>
 <20190704135420.GD13859@lunn.ch>
In-Reply-To: <20190704135420.GD13859@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0df199ff-029f-47aa-de4a-08d70094190a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR12MB2742;
x-ms-traffictypediagnostic: BYAPR12MB2742:
x-microsoft-antispam-prvs: <BYAPR12MB2742031B921DAF4DEABB63FED3FA0@BYAPR12MB2742.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0088C92887
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(366004)(376002)(396003)(136003)(39860400002)(199004)(189003)(73956011)(66946007)(66446008)(66476007)(66556008)(64756008)(7736002)(86362001)(6436002)(55016002)(229853002)(8676002)(76116006)(486006)(33656002)(6246003)(53936002)(476003)(76176011)(305945005)(81156014)(81166006)(2906002)(4326008)(14454004)(8936002)(25786009)(66066001)(52536014)(68736007)(110136005)(74316002)(54906003)(9686003)(316002)(5660300002)(186003)(7416002)(6506007)(26005)(478600001)(102836004)(71190400001)(71200400001)(7696005)(4744005)(256004)(99286004)(11346002)(446003)(6116002)(3846002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR12MB2742;H:BYAPR12MB3269.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: f7FCiuNqyfvEOqoBc+FemxRHkkHvilOiLjw5vT6Jic5JhwdJMU2+sbeDZkAh7fCeOzcDdQY8D+tlzWiokuOKrlgE955q8tddoHl8AIRCSjBb2Uirv0YlJBvcG/IS8FtjZdjcxcm7tfwzsJRngwxRwrSUSZ+Hreehe39vbHHhAvHPzRtJspndvm7sVBBJGdIn8quc55fk+0rkixi4UWeKqeHbseiHMqyxOseAK+domW0590ebekhZz5gv5FDBuhvUKe7SvzqQVY7bSa48hzSvGN4RayDh/6VUH/by92GPfq4lB8EnkBPvYJoL0BkTp4gNhFsif6x/hGIULYJ3niKIyHDB6lPlRA5K9wKcfvUWWRvYMziZJDjTEDRJg9mqr797/3RcXIdajfCVB6oxTxOCIttyF1pTxWlPX5BpE4uSpBw=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 0df199ff-029f-47aa-de4a-08d70094190a
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2019 15:27:17.0427
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: joabreu@synopsys.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2742
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>

> Yes, that is all clear. The stmmac_mdio_c45_setup() does part of this
> setup. There is also a write to mii_address which i snipped out when
> replying. But why do you need to write to the data registers during a
> read? C22 does not need this write. Are there some bits in the top of
> the data register which are relevant to C45?

Yes. The register is 32bits. 16 lower bits are for data and remaining=20
for C45 register address.
