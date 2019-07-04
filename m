Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5C355FAC1
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 17:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727520AbfGDPS0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 11:18:26 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:41170 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727066AbfGDPS0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 11:18:26 -0400
Received: from mailhost.synopsys.com (dc8-mailhost2.synopsys.com [10.13.135.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id DC6DBC0AE0;
        Thu,  4 Jul 2019 15:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1562253505; bh=srltxvcCNE27p/53vIXTcjaOoxeWYcyt0sOFzbvpfoQ=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=MDRk62j5WsURUzlJA+F0XDEAdFzT+64iMozavHLOOwx+r5kGKMhSdLpgbWKV6LW+u
         S0q22RzQ667W4xh//Ba1vCVonoOMlwYn3G6nY3jVdcutFW8fMRAqa/oSJMZVvGjxGA
         HsAoN8/3UpL6SefwVSBeyhnX20nx7m/5xRc/KS3eyu4IEAmRbDJ/mYJorozl7m114e
         WpEns8d3HQIxoBZsIT9T4z7Q8IWmMWsLftZKRjWaZbqCodXmKE9iCxerO17kUCA7aN
         YAvM4+BNGf5+zu1qb6YTfxc62VNhUPFAl9TC1n+5wCbZZf/xeficfzKBz09QUTcmz0
         rs6YkMda+7yfw==
Received: from us01wehtc1.internal.synopsys.com (us01wehtc1-vip.internal.synopsys.com [10.12.239.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 9E4FDA0067;
        Thu,  4 Jul 2019 15:18:23 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 us01wehtc1.internal.synopsys.com (10.12.239.231) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 4 Jul 2019 08:18:23 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Thu, 4 Jul 2019 08:18:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector1-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OkNNuoLq0RLATA5MIKKj4Xs29f1xTdGnJi7uKUt0++E=;
 b=AIpasKFGlJJUixm88XSKIllMYBYvQ8jTnoDmUZxyJcW9SThAc8obvJQ3412GAzkZuQmFCcFhUll9B1mtNDtIfLNGYRHDjSDlA53PO4gzg9K3sA/VZGG41HKebTriSkC3jjdWCX+RgMD9XK4D4M0nXlbrYRFEBu+9wmJuHHtMMTQ=
Received: from BYAPR12MB3269.namprd12.prod.outlook.com (20.179.93.146) by
 BYAPR12MB2742.namprd12.prod.outlook.com (20.177.125.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Thu, 4 Jul 2019 15:18:19 +0000
Received: from BYAPR12MB3269.namprd12.prod.outlook.com
 ([fe80::f5b8:ac6e:ea68:cb1c]) by BYAPR12MB3269.namprd12.prod.outlook.com
 ([fe80::f5b8:ac6e:ea68:cb1c%4]) with mapi id 15.20.2052.010; Thu, 4 Jul 2019
 15:18:19 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>
Subject: RE: [PATCH net-next 3/3] net: stmmac: Introducing support for Page
 Pool
Thread-Topic: [PATCH net-next 3/3] net: stmmac: Introducing support for Page
 Pool
Thread-Index: AQHVMYtq2Zx4WVoG/U2kL8GCK0bP/aa6NZoAgABVQYCAAAb3AIAAAeRQ
Date:   Thu, 4 Jul 2019 15:18:19 +0000
Message-ID: <BYAPR12MB32692AA2F18A530D56383739D3FA0@BYAPR12MB3269.namprd12.prod.outlook.com>
References: <cover.1562149883.git.joabreu@synopsys.com>
        <1b254bb7fc6044c5e6e2fdd9e00088d1d13a808b.1562149883.git.joabreu@synopsys.com>
        <20190704113916.665de2ec@carbon>
        <BYAPR12MB326902688C3F40BB3DA6EEEBD3FA0@BYAPR12MB3269.namprd12.prod.outlook.com>
 <20190704170920.1e81ed6e@carbon>
In-Reply-To: <20190704170920.1e81ed6e@carbon>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 69672202-5818-4cc7-b13e-08d70092d8d1
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR12MB2742;
x-ms-traffictypediagnostic: BYAPR12MB2742:
x-microsoft-antispam-prvs: <BYAPR12MB2742E1FFCBC0DB6B64D6A0C7D3FA0@BYAPR12MB2742.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0088C92887
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(366004)(376002)(396003)(136003)(39860400002)(199004)(189003)(73956011)(66946007)(66446008)(66476007)(66556008)(64756008)(7736002)(86362001)(6436002)(55016002)(229853002)(8676002)(76116006)(486006)(33656002)(6246003)(53936002)(476003)(76176011)(305945005)(81156014)(81166006)(2906002)(4326008)(14454004)(8936002)(25786009)(66066001)(52536014)(68736007)(110136005)(74316002)(54906003)(9686003)(316002)(5660300002)(186003)(7416002)(6506007)(26005)(478600001)(102836004)(71190400001)(71200400001)(7696005)(4744005)(14444005)(256004)(99286004)(11346002)(446003)(6636002)(6116002)(3846002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR12MB2742;H:BYAPR12MB3269.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: UXMjPlASMAfGpXlf/ywuAow/ETwYoZmHI9x5ncqG+Fq9dQRrPNDpGvIjc8zgvro6DKvXkk3UYjz6dHmnog61tz6adlKifK8TnIPpq99kt3eN/rH1uRDcS2jty64vYwzXAC4cgV02y60248cuj+CXuccegG8W8skwYaKV4RTR6SpITSwi39boLAeZfcrkH+arPC+ZTAjiR7BE/iQpNJP69wVxs9KW9f+foR/1qLLncAT3iNry0AVHe/RAPbQCVE2iv7IzFdFz+gN38VVHG7oBn6yiM8DocZACaXRxk4mRWwSeP67reSCz2DIehFrkzRtah4eM3kkgK/wss4b3cK5nRmCmpb6ruE75uQfLyQj9eDnOcbquhaGbN7nXQmucflJ7oMWHLIBhspqcLy3ukznzBHsXNcaexswexGuyvEiU1mw=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 69672202-5818-4cc7-b13e-08d70092d8d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2019 15:18:19.8061
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

From: Jesper Dangaard Brouer <brouer@redhat.com>

> You can just use page_pool_free() (p.s I'm working on reintroducing
> page_pool_destroy wrapper).  As you say, you will not have in-flight
> frames/pages in this driver use-case.

Well, if I remove the request_shutdown() it will trigger the "API usage=20
violation" WARN ...

I think this is due to alloc cache only be freed in request_shutdown(),=20
or I'm having some leak :D
