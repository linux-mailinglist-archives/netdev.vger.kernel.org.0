Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C38A1AF726
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 07:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725994AbgDSFIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 01:08:31 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:17576 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725769AbgDSFIa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 01:08:30 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03J57iuO019262;
        Sat, 18 Apr 2020 22:07:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=Hze6eJcQaBvBwRk4Uu8GpnnohOomUk3J0gv4mNvf8vM=;
 b=Pt3bl+9ZC2iQrHb9khdTf2HZWKmdlnxT5TmxEFV7BH/b22Te91Jm5AMv0zlOKtW+wPpn
 6rEZbYMpgmMES8N940N52JTCbx/NaKV1fwVD4FnY2Lm0XTUjLP3wQazwZKImUhxY6Shp
 7No21rKp6zi3NuVBvn+4SSVrpeYpESyTzmJoY7eYrq/GdJ21wbHLbvcEVAAVuHP9X/AV
 oMP5svtc1+5wqRS/Ffp7Z3rRix4RsgFgAxEQjFLo8bMi0Wl655pPAwM2nYPZ4MKwZWbS
 PAQDcmADR/leLT+2xQVj7kxXHVtbgC6Dps2r0h/2ocUi2Kk3v58RsD/JxxyqZiB9FXpc CQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 30fxwp2s25-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 18 Apr 2020 22:07:44 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 18 Apr
 2020 22:07:43 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sat, 18 Apr 2020 22:07:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P0dWnN/FsBNHNEvt7xRdKmLbrpUcLZ4nwi5iR3y+tpZSaOhofebAOVwgK0xY8sw6pvam/kqNk2NLfgj/wK2qO68RXjwLqnolbxKqwbAMRIPmpbwKsXvw73gHUw4r9y4oVzW0WBMCOAY6dIQucrb3e8XDSeHutubAyRDmrQBcmPSLGMloCHAx89TxcjLgcPNW0PlyNmNxJqY+XA4hF22NiOHcZ97YucjstF+6I5pVsTffzrJ2gXp/tb/9ZAy/vO9RXzqOE+W4/KTTdyUxg6H0+ra3ESxuXNbWR4sANHG8NH6Jz4WH/i9xeM6jPtpJMFGwwTOZsvbHDGHomAwnMwBoXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hze6eJcQaBvBwRk4Uu8GpnnohOomUk3J0gv4mNvf8vM=;
 b=jzzZmnbcjtmybp3lm5PY45QcULi+lzPjQ2QFK1IKxnykuAYivZkupn2l8IDj/K1kmaUH1UD1Z+bFmjfgxdDOa/lKb+r0qnA9rUoKQCE82pnWXBEKiBlXBNm9wSOqqVnrAHh+Nd1ITLcWn+lAL92Vx2RX7+alk57g3x+LKR6sEyiTI8jAfKIpUxKJ4lcIOPZEQb2Ngfu9R4UFvs7Ct7fNsgz838rPP7yJ7JGk3JWEdb6S6Kx+7jZe75+r7ZU6EGBg5Kpjw4GpRxxgFR6GcNeVgxu6zkBWjd1Zb4bvj0zX28oxmvNb1Q5QVYMDuMKilzaVeds7Tk9v9HHzv30fiD3tnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hze6eJcQaBvBwRk4Uu8GpnnohOomUk3J0gv4mNvf8vM=;
 b=hNqDcqvETGN66slKJ8iKPL2V9YAWQq/7Pbh7AP8bVmzNuCtiHxn7JlVsiAmQE5zqYMTb98cn4Pl2TCYyWntqoJN64SD4CDKQMEo40Ku+fraG+vp01ka+xadBCdetO39KNZxoMcz5uvCqloBiZuUsp0EEmXqNDsVCjgXj7WTlhZM=
Received: from BYAPR18MB2535.namprd18.prod.outlook.com (2603:10b6:a03:137::17)
 by BYAPR18MB2933.namprd18.prod.outlook.com (2603:10b6:a03:10e::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Sun, 19 Apr
 2020 05:07:42 +0000
Received: from BYAPR18MB2535.namprd18.prod.outlook.com
 ([fe80::65f8:9bfe:5fa5:1280]) by BYAPR18MB2535.namprd18.prod.outlook.com
 ([fe80::65f8:9bfe:5fa5:1280%3]) with mapi id 15.20.2921.027; Sun, 19 Apr 2020
 05:07:41 +0000
From:   Alex Belits <abelits@marvell.com>
To:     "luto@amacapital.net" <luto@amacapital.net>
CC:     "mingo@kernel.org" <mingo@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Prasun Kapoor <pkapoor@marvell.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "frederic@kernel.org" <frederic@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "will@kernel.org" <will@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 04/13] task_isolation: userspace hard isolation from
 kernel
Thread-Topic: [PATCH v3 04/13] task_isolation: userspace hard isolation from
 kernel
Thread-Index: AQHWFgh0Cq6Sp1qrB0WB/pY8n1YWIQ==
Date:   Sun, 19 Apr 2020 05:07:41 +0000
Message-ID: <bdea1b5d70460386303e59fdc7438d9013293147.camel@marvell.com>
References: <58995f108f1af4d59aa8ccd412cdff92711a9990.camel@marvell.com>
         <915489BC-B2C9-4D47-A205-FC597FC68B98@amacapital.net>
In-Reply-To: <915489BC-B2C9-4D47-A205-FC597FC68B98@amacapital.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.228.7.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a76721a9-0958-463b-db22-08d7e41f96b0
x-ms-traffictypediagnostic: BYAPR18MB2933:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB2933646E962406E3700A9CB5BCD70@BYAPR18MB2933.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0378F1E47A
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2535.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(366004)(136003)(396003)(346002)(39850400004)(376002)(316002)(66476007)(26005)(66446008)(64756008)(76116006)(66556008)(66946007)(186003)(478600001)(2616005)(6916009)(7416002)(966005)(54906003)(6506007)(5660300002)(8676002)(6486002)(8936002)(81156014)(71200400001)(6512007)(2906002)(4744005)(4326008)(36756003)(86362001);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jIOsfThepBKKZbqgekvEPqCT6xjC7BhjUDrDTxtujcZiFrXCaTwsOMGTwfZUmtN/AfLmMN9eW5wLT3ceWTcHR3+p6vSdwUJRg/iFXciapok0YPgnQjjZ0mkbVmB15IFPfS3wWQnqkcCYaSwA6IPqLp0u4iC5CHPmcUx12qAaCd9fekI8I9LwsbN/U8aWqH9bcMO9IzexUwyDt+NpITlTS6vr7XLUWzaK/ermrZOoidvpcdInSpoM8Fdu/2bWchYWMGNVuK+SGgmx1FNIae2+ew3wWlmObWCsTCOfgzA4NadZ/zB/jZdR7Pt0MHQaT+xxew5OppMwy1yyssOplggBycz9qXyOXZTb0gA6ebssYLcItTBpSb6d18bnpkU42GWItLtYeQribprVhA+yabheZrDOE2RwhqXGzL3K0bpIpcqDq08es3Q34YaaZV+O/suqlhWted9FKlL6ergj/v4srQ1/03DDFKuleHL16bID6p+a1zak+YljFFU4rsBmVhIu8yox0kNaT8GfhXwL/j/TyQ==
x-ms-exchange-antispam-messagedata: HfwMLOOr/4m5fZ3OxVU9q/ib++cpJxWwoprn88tLImVBvEZCgqtyaRoyamrE+HnLqJQO4T1IWmiMeSAfP3P8I0uSuTndoVVUaTHh+kI1GwuxlDbpsaUeNelWDHP3RexB7zIwhIx4tK1gkC4NLNlwYHUeJbX5njTzTsqX5Q2jn/zZ+np5fQW8xpbMcgTonhNwzoyTtnaTTUL3tlLMJpr7ZkhSC0BmTSJsqBWKc6bBXLgOho3y+5uo8AM3bAjOOInZoxhDx9u0AvZS98bLGhX3YpzSQJxSVOCVaPeNpWxInFx+TSZFDG/Jyp6MxD5uI8WpWDNd7hufWzG9ACFjTcByuzb3uWddyIUKYvGJ02huHgUy/2UTxRh27Lvx1q3TwU57KxJsQtTldkXcHiS64veof9+sAXMo9edZU24bsPbE6dHWCvLjcel40gV84XPD0t5s9GTTYt+hI+RWwkyLPu2AZ4/r+Rfj2y2bhZvEabzS0E0A8OGE0YII+fNgfUD2ziGf0y59+dWgyS8kX8avYhp5UVT4iJDoGTEVOBllUSyrSGACF+TNHjMaCaGf4lalL0evpKZ/dRIhXFR5zEyuQ7itQ7//WavHCyKtjLUuy9rJbJyw7FqcjoYJojH9rBX66zL6IhcUwrvQAQ5TL9ZHg9pnvy5MuNnDR6ZC36ycaOBf42mJHCVvcZmpTEiVFkG8vfwx/jGLS5E4g/TF3Koo9HKFUx7QprHQXSQVsRXtPJ7xP0EJ63mhHNyXhp8oVxgSqYFUGHFfD5JhgiyQCEUB8vqwml0zk4y7d4eFHc6yArt687Q=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C53B81AD43CDF74E93D23C0D24037623@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a76721a9-0958-463b-db22-08d7e41f96b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2020 05:07:41.8407
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MfbkLB4IQWWoIfrbGP9p9M9GYlXjMGkWZ7tLbQ7fl75JGvjUefZs/cOaR+R6jyReTTyF2iaoDZpHIB7GfDqIzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2933
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-18_10:2020-04-17,2020-04-18 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiBUaHUsIDIwMjAtMDQtMDkgYXQgMTE6MDAgLTA3MDAsIEFuZHkgTHV0b21pcnNraSB3cm90
ZToNCj4gDQo+ID4gDQo+ID4gT25jZSB0aGUgdGFzayBoYXMgcmV0dXJuZWQgdG8gdXNlcnNwYWNl
IGFmdGVyIGlzc3VpbmcgdGhlIHByY3RsKCksDQo+ID4gaWYgaXQgZW50ZXJzIHRoZSBrZXJuZWwg
YWdhaW4gdmlhIHN5c3RlbSBjYWxsLCBwYWdlIGZhdWx0LCBvciBhbnkNCj4gPiBvdGhlciBleGNl
cHRpb24gb3IgaXJxLCB0aGUga2VybmVsIHdpbGwga2lsbCBpdCB3aXRoIFNJR0tJTEwuDQo+IA0K
PiBJIGNvdWxkIGVhc2lseSBpbWFnaW5lIG15c2VsZiB1c2luZyB0YXNrIGlzb2xhdGlvbiwgYnV0
IG5vdCB3aXRoIHRoZQ0KPiBTSUdLSUxMIHNlbWFudGljcy4gU0lHS0lMTCBjYXVzZXMgZGF0YSBs
b3NzLiBQbGVhc2UgYXQgbGVhc3QgbGV0DQo+IHVzZXJzIGNob29zZSB3aGF0IHNpZ25hbCB0byBz
ZW5kLg0KDQpUaGlzIGlzIGFscmVhZHkgZG9uZSwgZXZlbiB0aG91Z2ggdGhlIGRvY3VtZW50YXRp
b24gaXMgbm90IHVwZGF0ZWQuDQpUaGVyZSBpcyBldmVuIGEgdXNlcnNwYWNlIGxpYnJhcnkgdGhh
dCBkZWFscyB3aXRoIHRoaXMgd2hpbGUNCmNvbXBlbnNhdGluZyBmb3IgcG9zc2libGUgcmFjZSBj
b25kaXRpb25zIG9uIGlzb2xhdGlvbiBlbnRyeSBhbmQNCmF1dG9tYXRpYyByZS1lbnRyeSBhZnRl
ciBpc29sYXRpb24gaXMgYnJva2VuOiANCmh0dHBzOi8vZ2l0aHViLmNvbS9hYmVsaXRzL2xpYnRt
Yw0KDQotLSANCkFsZXgNCg==
