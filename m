Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C06F5B8D0
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 12:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728758AbfGAKPW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 06:15:22 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:52438 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727644AbfGAKPV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 06:15:21 -0400
Received: from mailhost.synopsys.com (dc2-mailhost1.synopsys.com [10.12.135.161])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id BB212C00FF;
        Mon,  1 Jul 2019 10:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1561976121; bh=Sv1ZgUib96RyXkxn0q8ZzmxhGzWoAqtETMLbbtHTfdQ=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=e5ziYV+dMQMPK8z+5J0AR/iuURMg/IxOYtLLtWerj1vQ7RJ1kVVMDrfdU0NJfnOVF
         AtMs2zGXqKFh5mDjHiH9m+rWgX2qkgnkxLBW9bhtuwp/QoPnNxOy1GMJjOdP93f1Je
         fQdNcdbgkP+zRnGpJQ0UXZscddt/PE5MTwaKREmOXZUj8wHq6lJaILPU2itDENjcMc
         moCJOVnqMEjMedmBNZCrTYaysmsb8ZLecWVJp+MUt63RxhTJWMiDGS4ha4ExrDwz7/
         OuoNPnaj+qpmpRiMsd9C2ahP4nRaaGPyoyhV1Vvj3wsq3njp7th3zHFZ6HAQA9D1eI
         mpOJtS80czSCw==
Received: from us01wehtc1.internal.synopsys.com (us01wehtc1-vip.internal.synopsys.com [10.12.239.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id C7252A009B;
        Mon,  1 Jul 2019 10:15:19 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 us01wehtc1.internal.synopsys.com (10.12.239.231) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 1 Jul 2019 03:15:19 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Mon, 1 Jul 2019 03:15:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector1-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sv1ZgUib96RyXkxn0q8ZzmxhGzWoAqtETMLbbtHTfdQ=;
 b=tFds4nKMiXRW6vLVveMcWcCXOrQqnDZCgfGhg7w/3wFLVnidESI5MstnuRIe4f5bEi74gp3QZkAUi7JVWzPuByBqF4bt8+fQDlJB/58+gR5ECrraDdb+DJoZ/KcXty2xVbjnuFauELShcAmBOokuyMCCo6kNmD2w82LgBqXWSg0=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.66.159) by
 BN8PR12MB3249.namprd12.prod.outlook.com (20.179.66.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Mon, 1 Jul 2019 10:15:17 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::61ef:5598:59e0:fc9d]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::61ef:5598:59e0:fc9d%5]) with mapi id 15.20.2032.019; Mon, 1 Jul 2019
 10:15:17 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>
CC:     linux-kernel <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: RE: [PATCH net-next v2 06/10] net: stmmac: Do not disable interrupts
 when cleaning TX
Thread-Topic: [PATCH net-next v2 06/10] net: stmmac: Do not disable interrupts
 when cleaning TX
Thread-Index: AQHVLYNKlfBlGR56zUCG1H10tvKrnKaxbs8AgAQgg+A=
Date:   Mon, 1 Jul 2019 10:15:17 +0000
Message-ID: <BN8PR12MB326638B0BA74DA762C89DF54D3F90@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <cover.1561706800.git.joabreu@synopsys.com>
 <e4e9ee4cb9c3e7957fe0a09f88b20bc011e2bd4c.1561706801.git.joabreu@synopsys.com>
 <CA+FuTSc4MFfjBNpvN2hRh9_MRmxSYw2xY6wp32Hsbw0E=pqUdw@mail.gmail.com>
In-Reply-To: <CA+FuTSc4MFfjBNpvN2hRh9_MRmxSYw2xY6wp32Hsbw0E=pqUdw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8a89c852-6191-43b9-d31d-08d6fe0d03df
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN8PR12MB3249;
x-ms-traffictypediagnostic: BN8PR12MB3249:
x-microsoft-antispam-prvs: <BN8PR12MB32495DE4EE0D7BB570193EECD3F90@BN8PR12MB3249.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 00851CA28B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(136003)(39850400004)(396003)(376002)(366004)(22813001)(199004)(189003)(4326008)(6436002)(55016002)(66946007)(66476007)(66556008)(64756008)(66446008)(73956011)(5660300002)(2906002)(53936002)(6246003)(9686003)(52536014)(316002)(25786009)(86362001)(446003)(76116006)(229853002)(54906003)(33656002)(6636002)(26005)(102836004)(186003)(486006)(11346002)(110136005)(476003)(8936002)(8676002)(81166006)(478600001)(81156014)(99286004)(7696005)(6506007)(76176011)(256004)(14444005)(66066001)(14454004)(68736007)(71200400001)(74316002)(6116002)(3846002)(71190400001)(305945005)(7736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3249;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 0B8BuWG2BvMf2TxK9TE8rjiG5NSQvSxLErYg8gihVPNFqA+4sL9lgKM97x1viK3Z4QtgHhy28bH+a7po6AGH548dgHugI6lakvgo1Z0Ne8v1UAEWRfEd05Fd0bBoiyzXxUBX3wW2s2SjRBJldT0Zt9Qs96q1gjXAxjBi6M9w/vuVr/f/S2j1n/bap7AD/RoWd5g4mjqXBuVTR+nvHhHGHTTKieWwiHit8X3R7MwAqc4QxpXKnYFrgKl95OzzHYmEWO7H9dhyIaKpsQ6qAp5/QCcFYG+wrOFORHu1otGVEzGCNSDcNZmBlGsZ1fFEHX2X/8qIX12HqMc1PQlmFULhHD0m29BVn1zcNmudD8duCBE5kQq7GYEOJu98Fwb30KCGdYTxgDOX5JSZzmw6JBOwxDCMd37ck3GenoKwQycVZWI=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a89c852-6191-43b9-d31d-08d6fe0d03df
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2019 10:15:17.1014
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: joabreu@synopsys.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3249
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogV2lsbGVtIGRlIEJydWlqbiA8d2lsbGVtZGVicnVpam4ua2VybmVsQGdtYWlsLmNvbT4N
Cg0KPiBCeSB0aGUNCj4gDQo+ICAgICAgICAgaWYgKChzdGF0dXMgJiBoYW5kbGVfcngpICYmIChj
aGFuIDwgcHJpdi0+cGxhdC0+cnhfcXVldWVzX3RvX3VzZSkpIHsNCj4gICAgICAgICAgICAgICAg
IHN0bW1hY19kaXNhYmxlX2RtYV9pcnEocHJpdiwgcHJpdi0+aW9hZGRyLCBjaGFuKTsNCj4gICAg
ICAgICAgICAgICAgIG5hcGlfc2NoZWR1bGVfaXJxb2ZmKCZjaC0+cnhfbmFwaSk7DQo+ICAgICAg
ICAgfQ0KPiANCj4gYnJhbmNoIGRpcmVjdGx5IGFib3ZlPyBJZiBzbywgaXMgaXQgcG9zc2libGUg
dG8gaGF2ZSBmZXdlciByeCB0aGFuIHR4DQo+IHF1ZXVlcyBhbmQgbWlzcyB0aGlzPw0KDQpZZXMs
IGl0IGlzIHBvc3NpYmxlLg0KDQo+IHRoaXMgbG9naWMgc2VlbXMgbW9yZSBjb21wbGV4IHRoYW4g
bmVlZGVkPw0KPiANCj4gICAgICAgICBpZiAoc3RhdHVzKQ0KPiAgICAgICAgICAgICAgICAgc3Rh
dHVzIHw9IGhhbmRsZV9yeCB8IGhhbmRsZV90eDsNCj4gDQo+ICAgICAgICAgaWYgKChzdGF0dXMg
JiBoYW5kbGVfcngpICYmIChjaGFuIDwgcHJpdi0+cGxhdC0+cnhfcXVldWVzX3RvX3VzZSkpIHsN
Cj4gDQo+ICAgICAgICAgfQ0KPiANCj4gICAgICAgICBpZiAoKHN0YXR1cyAmIGhhbmRsZV90eCkg
JiYgKGNoYW4gPCBwcml2LT5wbGF0LT50eF9xdWV1ZXNfdG9fdXNlKSkgew0KPiANCj4gICAgICAg
ICB9DQo+IA0KPiBzdGF0dXMgJiBoYW5kbGVfcnggaW1wbGllcyBzdGF0dXMgJiBoYW5kbGVfdHgg
YW5kIHZpY2UgdmVyc2EuDQoNClRoaXMgaXMgcmVtb3ZlZCBpbiBwYXRjaCAwOS8xMC4NCg0KPiA+
IC0gICAgICAgaWYgKHdvcmtfZG9uZSA8IGJ1ZGdldCAmJiBuYXBpX2NvbXBsZXRlX2RvbmUobmFw
aSwgd29ya19kb25lKSkNCj4gPiAtICAgICAgICAgICAgICAgc3RtbWFjX2VuYWJsZV9kbWFfaXJx
KHByaXYsIHByaXYtPmlvYWRkciwgY2hhbik7DQo+ID4gKyAgICAgICBpZiAod29ya19kb25lIDwg
YnVkZ2V0KQ0KPiA+ICsgICAgICAgICAgICAgICBuYXBpX2NvbXBsZXRlX2RvbmUobmFwaSwgd29y
a19kb25lKTsNCj4gDQo+IEl0IGRvZXMgc2VlbSBvZGQgdGhhdCBzdG1tYWNfbmFwaV9wb2xsX3J4
IGFuZCBzdG1tYWNfbmFwaV9wb2xsX3R4IGJvdGgNCj4gY2FsbCBzdG1tYWNfZW5hYmxlX2RtYV9p
cnEoLi4pIGluZGVwZW5kZW50IG9mIHRoZSBvdGhlci4gU2hvdWxkbid0IHRoZQ0KPiBJUlEgcmVt
YWluIG1hc2tlZCB3aGlsZSBlaXRoZXIgaXMgYWN0aXZlIG9yIHNjaGVkdWxlZD8gVGhhdCBpcyBh
bG1vc3QNCj4gd2hhdCB0aGlzIHBhdGNoIGRvZXMsIHRob3VnaCBub3QgZXhhY3RseS4NCg0KQWZ0
ZXIgcGF0Y2ggMDkvMTAgdGhlIGludGVycnVwdHMgd2lsbCBvbmx5IGJlIGRpc2FibGVkIGJ5IFJY
IE5BUEkgYW5kIA0KcmUtZW5hYmxlZCBieSBpdCBhZ2Fpbi4gSSBjYW4gZG8gc29tZSB0ZXN0cyBv
biB3aGV0aGVyIGRpc2FibGluZyANCmludGVycnVwdHMgaW5kZXBlbmRlbnRseSBnaXZlcyBtb3Jl
IHBlcmZvcm1hbmNlIGJ1dCBJIHdvdWxkbid0IGV4cGVjdCBzbyANCmJlY2F1c2UgdGhlIHJlYWwg
Ym90dGxlbmVjayB3aGVuIEkgZG8gaXBlcmYzIHRlc3RzIGlzIHRoZSBSWCBwYXRoIC4uLg0K
