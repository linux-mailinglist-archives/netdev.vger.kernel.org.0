Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27D4B13BFAA
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:15:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730211AbgAOMPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:15:21 -0500
Received: from mail-bn7nam10on2064.outbound.protection.outlook.com ([40.107.92.64]:33252
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731595AbgAOMNl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:13:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LhPC/Oz7GTWoTlcKRzY7XIX5VutUKlmUfIiylZ95AiIZkjwmlWHw4A5cxNYa9lpKsuNor4Y2CZaLVwOzsREHwF/fhuJ1gorc8XqeexQIqBWfck1ECS/GN9cQzk58Ln0kgQuPcZeCbs5V1+CJfu872f5C30zvwUBbN5CI26Y6MhtwOUtDpd/9zr9QC7GXskhAW49teAIAkoTo3t4E2khgNUZm7DE7CalRqU01Xg+h4aqQzzQhC+1dACDVBIKFgeJe3ZQWRVA174kKLICUaB81yExDCVIqN5Kd/1K/As8P+MTBA9v0HOBKdMIwD/hzlUyVeSo3/WkG13Gg+1eGk1dRHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X87pVtcmYHDi0ljQJpF2xoldyQ1lZON43WhiEKBHxLo=;
 b=oel8xPEjpbVMT2wntj27hXOGXbl43b3aTnI4gzYVgo+NG7CnbuCf/Lo8shp5gs3q0eQNlxQZE0ircO0vZz/FyDYQ3Mvpqkhso/z7L2hg0uBVJVPtU5eeSr7NPTsEDRnyfqFJQIYeW7KMWslg2rEcfF0d0yokySytA06BYcw49TBEyqthRvX+vi5JFFjxUQJi1a3jjRO+UK1Rp2G7g9+QIEfvy53YOPKXvwYKRfhMUBYpqCg2lSuXNRpKM2h++0CDjNXBYlIk20hUdqLn5drLg7QcQJTn3eUCNgShwkOh5v+CX5QzO4on/7oz9afXFJA5M0YvMi3LJH3cLK87zDcILQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X87pVtcmYHDi0ljQJpF2xoldyQ1lZON43WhiEKBHxLo=;
 b=aDXvbV9mo8zO47E+mQXW4uunAbCadxuOPi+7z1FZXYrpTPi2UVR5My5RWgVn8M5HnQFfMxpm8LzsS0scK01T5vYKQcWF2tkhr/9riB/DLliw96uVbpOmv+wEnNsAsH8Hdl460kITTx5cZ5qor8Jy75X4d+Oui90fmvntjesJ50I=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3934.namprd11.prod.outlook.com (10.255.180.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Wed, 15 Jan 2020 12:13:30 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 12:13:30 +0000
Received: from pc-42.silabs.com (37.71.187.125) by PR2PR09CA0009.eurprd09.prod.outlook.com (2603:10a6:101:16::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 12:13:11 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 48/65] staging: wfx: fix RCU usage
Thread-Topic: [PATCH 48/65] staging: wfx: fix RCU usage
Thread-Index: AQHVy50ocDCEU8Gjt0qJg2yqX6q8RA==
Date:   Wed, 15 Jan 2020 12:13:12 +0000
Message-ID: <20200115121041.10863-49-Jerome.Pouiller@silabs.com>
References: <20200115121041.10863-1-Jerome.Pouiller@silabs.com>
In-Reply-To: <20200115121041.10863-1-Jerome.Pouiller@silabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR2PR09CA0009.eurprd09.prod.outlook.com
 (2603:10a6:101:16::21) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.25.0
x-originating-ip: [37.71.187.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e1cf2f07-0ed3-4bff-7185-08d799b44b05
x-ms-traffictypediagnostic: MN2PR11MB3934:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB3934B7C4C3790C8D2DBD741193370@MN2PR11MB3934.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:390;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(39860400002)(376002)(366004)(346002)(199004)(189003)(54906003)(110136005)(86362001)(956004)(107886003)(2616005)(316002)(36756003)(71200400001)(52116002)(7696005)(478600001)(8936002)(81156014)(8676002)(4326008)(81166006)(6486002)(2906002)(26005)(66946007)(16526019)(186003)(5660300002)(66574012)(1076003)(66556008)(64756008)(66446008)(85182001)(66476007)(85202003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3934;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9Ij81oAA8ek2uA77ex5PEIvaq6reXFaTaLSD+7a+avmCEPPHb+EsHRnCWNv0LFkbh0HLlUH/Kw+xRJkYN/D9kAGc30FQ4SIbfk9h8nJfQg7c2SIf+arEj/9jNj5m88H7uAYfLhf4ZcL0kCmpY7lRd5a54eCPHNOSsxm3oeBo9FoFJGfF14kwb1O3qMEu5cyPFSCDUE//s6t+bkZ4StME/BT5/m3GjwBLk0kTDb/41+i2iiMnYsnYDoz/+9WIYzGvFPuNodbeLHJkXH95cHIAojSfPXbZsgrDVH6YeenOJYx7LjIs5B6ig7MmLLXr9retqld0vuuETdxt7oPBK9XNDcMoyui+NKsff0H0LwB0P7z6/nVsAWuzSL9zEYjRST+Fpd7ljFIJwL5w3v/nsyi7h4sJGUtv+R2yAAXZljKvoGWz9S52XdiiHtY9XbH1n9A0
Content-Type: text/plain; charset="utf-8"
Content-ID: <1823F1EF4BF0EE4F80C3CF25E5E2925E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1cf2f07-0ed3-4bff-7185-08d799b44b05
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 12:13:12.9854
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AdhJuCBuoHwIOaIixyVYpN6cmFksCNJMK9SpLyfPnlTGwkw7RMG2wUbPDEQ7AhFPXsf/jbliBX+tsp828C6NIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3934
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSW5k
ZWVkLCBzdGEgd2FzIHVzZWQgYWZ0ZXIgY2FsbCB0byByY3VfdW5sb2NrKCkKClNpZ25lZC1vZmYt
Ynk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBk
cml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jIHwgNCArKy0tCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNl
cnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93
Zngvc3RhLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCmluZGV4IDgwYTJhOWU4MjU2Zi4u
ZDUwYjU4M2FmMTg3IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCisrKyBi
L2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKQEAgLTY5MCwxMCArNjkwLDkgQEAgc3RhdGljIHZv
aWQgd2Z4X2pvaW5fZmluYWxpemUoc3RydWN0IHdmeF92aWYgKnd2aWYsCiAJc3RydWN0IGllZWU4
MDIxMV9zdGEgKnN0YSA9IE5VTEw7CiAKIAl3dmlmLT5iZWFjb25faW50ID0gaW5mby0+YmVhY29u
X2ludDsKLQlyY3VfcmVhZF9sb2NrKCk7CisJcmN1X3JlYWRfbG9jaygpOyAvLyBwcm90ZWN0IHN0
YQogCWlmIChpbmZvLT5ic3NpZCAmJiAhaW5mby0+aWJzc19qb2luZWQpCiAJCXN0YSA9IGllZWU4
MDIxMV9maW5kX3N0YSh3dmlmLT52aWYsIGluZm8tPmJzc2lkKTsKLQlyY3VfcmVhZF91bmxvY2so
KTsKIAlpZiAoc3RhKQogCQl3dmlmLT5ic3NfcGFyYW1zLm9wZXJhdGlvbmFsX3JhdGVfc2V0ID0K
IAkJCXdmeF9yYXRlX21hc2tfdG9faHcod3ZpZi0+d2Rldiwgc3RhLT5zdXBwX3JhdGVzW3d2aWYt
PmNoYW5uZWwtPmJhbmRdKTsKQEAgLTcxMiw2ICs3MTEsNyBAQCBzdGF0aWMgdm9pZCB3Znhfam9p
bl9maW5hbGl6ZShzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwKIAl3dmlmLT5ic3NfcGFyYW1zLmFpZCA9
IGluZm8tPmFpZDsKIAogCWhpZl9zZXRfYXNzb2NpYXRpb25fbW9kZSh3dmlmLCBpbmZvLCBzdGEg
PyAmc3RhLT5odF9jYXAgOiBOVUxMKTsKKwlyY3VfcmVhZF91bmxvY2soKTsKIAogCWlmICghaW5m
by0+aWJzc19qb2luZWQpIHsKIAkJaGlmX2tlZXBfYWxpdmVfcGVyaW9kKHd2aWYsIDMwIC8qIHNl
YyAqLyk7Ci0tIAoyLjI1LjAKCg==
