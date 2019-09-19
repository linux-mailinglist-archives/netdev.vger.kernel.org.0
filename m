Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 801D2B79FF
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 15:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389778AbfISNBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 09:01:40 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:53982 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388246AbfISNBk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 09:01:40 -0400
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 040B7C03C9;
        Thu, 19 Sep 2019 13:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1568898099; bh=YfXw06JFLXkRXBWLf7XuIs4VLX1eRirJz3D/FKf+swQ=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=IKewLTg7q5Y58k+QRTLDA1TP3hz8wF0YDAnpVTipberdyAN1xRUMeiIv2T/ZkA7rt
         54s/5dL1Pa7ahdJjR/O/+61oTLFa9ZrK8VhZIOci19Y2B18IjOVINAzig8HIoc9Cor
         32md1QBC7YQw6772pHSSxgAmIeOwDXstKVPn2iCoNIkVlkyn9boy3Cgp9qZkG1P0CG
         M5E2ivBDlYv9uv5rF6yPxFRYlNIdzATX7cO1ACjSRAX3bHSEBG99UzwgGh27SXj6p8
         6/fwS0uHqoTF6E0nDi/LKbI5boYxFupNk1wKggS507pzssgIpsgdAUDr3OoHejoxUG
         H5nrNGdzK9Z1w==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id D6080A006B;
        Thu, 19 Sep 2019 13:01:25 +0000 (UTC)
Received: from US01WEHTC2.internal.synopsys.com (10.12.239.237) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 19 Sep 2019 06:01:24 -0700
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC2.internal.synopsys.com (10.12.239.237) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 19 Sep 2019 06:01:24 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Thu, 19 Sep 2019 06:01:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NfYGk8JFXIpCpkLeqH/vhPtGAwgPpVo+1rB/nI60GmdXZYqJOx3TTcoLxL+kJ7OvMVbmq83rMe0xLdNKXRDDmqEMzjR3kF3uFmEqQvTJ1nv9ARwH0/lpByCK1Yvr3EsJxcERT/mRUmsrtSRXJsClpTIJQWnRtldIb6XOWPEqJGbzuco5ioyJQumTLkCZDFeFJ+2IGhC4bMPUv3CtzsILBzlHtsxaclWWzi968Tv9exHsP2M2JHe1+F1eA92+ytpeBq/FpRBT16pSLVs2KGM/8VhYVoRT3vHb99D0RhTssiGgL2rLhBXyUBuIV+NmubBfu5mNuLLbyGgBsLwmIS+sgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YfXw06JFLXkRXBWLf7XuIs4VLX1eRirJz3D/FKf+swQ=;
 b=XumakY/DY9SuVOrMk5cqSm6q0A4+iZdNjv1MRAXfFPAhTnMAMemop+MMju3TPFhWIbGYEU4QwWLUt2eJ12mnigBgxf9mdvHUwnKCJrhwvk1yr+GsT/HRh/+XzoRmB8Q8FAYWiNJ2ZFT/20zK5ZL+KC2uwD0p/9kWilKu/EgS6XCuFc82GUWhXQLO6JvbjkzG3oc7wQaMtX43PcIKJ2wpcbpePL7dC+hU/l/C9zw37yxKcgsi+3XIpK49PcSUSz6A45QgNMApvRCNDERajS//zNi213nG9cJBVm9k0g7ftvwGOt5FhhSAXR7pq+r8hVJ4E6NhD675cmJhttwXyU2ENw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YfXw06JFLXkRXBWLf7XuIs4VLX1eRirJz3D/FKf+swQ=;
 b=FaPl70fjtbIO7wuyqDVBqBy/g4n5mKUNGEk7XlDsAjCKBtICLocjIok6/rg2yPgxikCOB+/q+eZF9DpSnBZNePcMgYYzLtrcPSKxDILFrSIzvr2DAXbqndOF0I+N91OlBzoYogtxxGNn4VdFWjw2x5BI7OidADC683OyECVWXno=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB2947.namprd12.prod.outlook.com (20.179.67.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.21; Thu, 19 Sep 2019 13:01:23 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::59fc:d942:487d:15b8]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::59fc:d942:487d:15b8%7]) with mapi id 15.20.2284.009; Thu, 19 Sep 2019
 13:01:23 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Arnd Bergmann <arnd@arndb.de>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] [v2] net: stmmac: selftest: avoid large stack usage
Thread-Topic: [PATCH] [v2] net: stmmac: selftest: avoid large stack usage
Thread-Index: AQHVbuaov9I2jrOCSkeQgisvfsMsf6cy9npg
Date:   Thu, 19 Sep 2019 13:01:22 +0000
Message-ID: <BN8PR12MB3266871030D8556836F2B7C9D3890@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <20190919123416.3070938-1-arnd@arndb.de>
In-Reply-To: <20190919123416.3070938-1-arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [198.182.37.200]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e4f309d1-88a8-4ca2-1fe6-08d73d017903
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN8PR12MB2947;
x-ms-traffictypediagnostic: BN8PR12MB2947:
x-microsoft-antispam-prvs: <BN8PR12MB2947286E2D2E1D655D4CB708D3890@BN8PR12MB2947.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 016572D96D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(39860400002)(396003)(346002)(136003)(376002)(189003)(199004)(51914003)(8676002)(446003)(11346002)(486006)(4326008)(476003)(64756008)(66556008)(6246003)(66476007)(316002)(110136005)(54906003)(66446008)(5660300002)(81166006)(81156014)(229853002)(4744005)(256004)(14444005)(6436002)(55016002)(9686003)(52536014)(71200400001)(86362001)(8936002)(71190400001)(66066001)(478600001)(33656002)(6116002)(3846002)(7736002)(99286004)(74316002)(305945005)(14454004)(2906002)(76116006)(102836004)(6506007)(66946007)(186003)(26005)(7696005)(25786009)(76176011);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB2947;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: llpcdbvvZJQnjHBmeTd/QuhXrazqy84hwIsiPhujnlWvfXtxx1kwfDuxFO+KcnC4yFDAGG39GC3RCH6vnW4qQIy6nqvSXVx+aNfCY5WkF+LFjIZAMg2yvx2Y/buxzGsF6v/Sahx3hjtIoucnSGIAz9eUtYWdpR7FZ3Eld/6z1CiMQ5m9LL6J0+gXnUtfhJ8ZvWb7I17jpImQsJUHmt5Spm/lKsAltReUFSpVvl7LMHW/MDirIcnG7L3K4RNGLQQfwSgr8RiH0wX3K1STyHYLjzHao+EysXRLNEzjq6Fm7HRDjtQ8yj4H8pbsEcBAEfBDDYxUpvFrU9rPRipUGZcYciWLsKKjOX8sE2M42VKMHTLA7mS6pgoCxZvfdv3+uj6hCtiKP9CxixBR191ewqw1kR4sIQFl2TjZHZPG/AaTLp4=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e4f309d1-88a8-4ca2-1fe6-08d73d017903
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2019 13:01:22.9264
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RlcYrJEvcs48DZRJw0h4yuYLC4XapBRf8AIGQqRkQ0kDcVlmpcgrCE3uI2fdHb/9ogyE85Kvdgf4MOx3I4235g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB2947
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Sep/19/2019, 13:33:43 (UTC+00:00)

> Putting a struct stmmac_rss object on the stack is a bad idea,
> as it exceeds the warning limit for a stack frame on 32-bit architectures=
:
>=20
> drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c:1221:12: error: st=
ack frame size of 1208 bytes in function '__stmmac_test_l3filt' [-Werror,-W=
frame-larger-than=3D]
> drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c:1338:12: error: st=
ack frame size of 1208 bytes in function '__stmmac_test_l4filt' [-Werror,-W=
frame-larger-than=3D]
>=20
> As the object is the trivial empty case, change the called function
> to accept a NULL pointer to mean the same thing and remove the
> large variable in the two callers.
>=20
> Fixes: 4647e021193d ("net: stmmac: selftests: Add selftest for L3/L4 Filt=
ers")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> v2: simply configure function, based on feedback from Jose

Looks good to me. Thanks for the fix :)

Acked-by: Jose Abreu <joabreu@synopsys.com>

---
Thanks,
Jose Miguel Abreu
