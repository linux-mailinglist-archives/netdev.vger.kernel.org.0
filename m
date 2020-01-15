Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90F1C13BF62
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:13:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730867AbgAOMMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:12:49 -0500
Received: from mail-co1nam11on2084.outbound.protection.outlook.com ([40.107.220.84]:24056
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730774AbgAOMMs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:12:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EIvhs5/bMPTur7d+v3iYBoaLnWcmfN9uhS89qeibfrqaq4gEjoS0QRQLIMKMSzyC7aQkBCfXkERPOBR7bahjK1PSbwWGhxl0ZhuGGqi0MegqPD+cA1opRsgAvPL6NX04FeP8+yH6NE6Lhs06iT7LRqrS81LzXAq7EJRAS1Qry0CxXaRgPvg83p9jCvvyu74zwN0cJivUef74rX87K4dNdMW6fQGI/W1NAxSiKJoFBmC/RhLFuwxpwmu6zPPW86miuuUGUW2qro9ea8Q7tsbiVpXnB1JK566UCWLL++epyumTpZBue+ffmlnlporhiKoe6gO4+ryY2PwuWUM4a0mJHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n2ETDyqVciDrVTsElmWoRWuQT1mIpukmooLN9gH5YIg=;
 b=lPVAuvPAUtikXE1ogZOnwmdLWJLEwwW5/73YXdgH/hWHcToPnG6Ndh1O6LFmZrQJyrrxbcZ2m9fHV9AN32k3FBh6/qNhDEhUy8PH9+Z7trWLOMinRIxia8rF8oebi5fxexQbDiP2GohmEl5wHsxqkmjO8ChxkoaFzEGusl6lcdtKefkZ8O5epHpdRPWC5Cwz0U4zrJdyGs74vOAPuuC8v5oYQsIIMk8j7WLNGcwUALKnOU+tisY+15anWXp2qSoN3grKQsFFflaUBXhJaaQqxkaLcspOM3gTemaXiQOPXjOs/G6EWDBIXhQ1aIus4LOR/kOd2aRYQ2RUx/Ctm5uZPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n2ETDyqVciDrVTsElmWoRWuQT1mIpukmooLN9gH5YIg=;
 b=ed75+Q7TVSf69D+b07eUmEMufg4S/cEvNlaiXhNsLIcJEaY3LScVYxNGXYXrdzeblSEMvUgEZIP+ttDCnjCno/Ge2wpHY/guKTgs8oIz9GwLFoX/Fhc22YsXybe4Ng08WQJdLWe88Y4ZEj/mIpLV0JTfdZxPAs+KVVz++WoYhEg=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3934.namprd11.prod.outlook.com (10.255.180.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Wed, 15 Jan 2020 12:12:36 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 12:12:36 +0000
Received: from pc-42.silabs.com (37.71.187.125) by PR2PR09CA0009.eurprd09.prod.outlook.com (2603:10a6:101:16::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 12:12:34 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 20/65] staging: wfx: simplify wfx_flush()
Thread-Topic: [PATCH 20/65] staging: wfx: simplify wfx_flush()
Thread-Index: AQHVy50S5Npa2w6+aU60uLFekLvtug==
Date:   Wed, 15 Jan 2020 12:12:35 +0000
Message-ID: <20200115121041.10863-21-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 8eebd3c9-ba64-4375-bda5-08d799b434f7
x-ms-traffictypediagnostic: MN2PR11MB3934:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB3934BF4B4DB1F5928C20D5DA93370@MN2PR11MB3934.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(396003)(136003)(376002)(366004)(346002)(199004)(189003)(54906003)(110136005)(86362001)(956004)(107886003)(2616005)(316002)(36756003)(71200400001)(52116002)(7696005)(478600001)(8936002)(81156014)(8676002)(4326008)(81166006)(6486002)(2906002)(26005)(66946007)(16526019)(186003)(5660300002)(1076003)(66556008)(64756008)(66446008)(85182001)(66476007)(85202003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3934;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2cIcSOotlZNRxRRtnk0MnIL0Z4hcmTutzrMerWKoegEYM8u0rSpaRkJ8Z42tMSggHMq1gZCxiaAzfpvnkMYSt8oRuWo/ZicCfn1BQ+bQnONMkeISUzwiNl7QBuf56fw/ii1gi1fXqd9xa0yJms6myUXXJh0Utno6efTQLDivrxrEtU1ChwyMQ4fyRL+hlDXLZHuXpZFOkSKdbSzkLVjCfQAdpFAwqW+jNY2tu7qvZjz8q07v6yCunNHNRxl1dPrVZdnE3NYSqn3G9d62pohu9cMKfyZWPgTRHjK31k2Ednnko0pjPwAHiu16vziTUli2QLddSVFDe5rq4266Fpdm1MWLFCFO3+NIDAwn41CB057aQM4YTjnUi2+AQ1dm/pQz0eIISuywa5G1n4mntmSVgi882Y8fUqJjDtX7tkuzJNGbDtxfrY3FOsKVWJSFYQgY
Content-Type: text/plain; charset="utf-8"
Content-ID: <D9D2CDB40477784BAF9DBB190D2EC145@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8eebd3c9-ba64-4375-bda5-08d799b434f7
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 12:12:35.9767
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RQEdIoH1e0bCY9mA6mATss/zuPX6gQtkTdFsgqQIPo1ti25t5VMd23efCR/HRLlDs6bUVWyCQqsuuHG0ayNFLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3934
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKQ3Vy
cmVudCBjb2RlIG9mIHdmeF9mbHVzaCgpIGZvcmNlIHRvIGRyb3AgcGFja2V0cyBpbiBzb21lIGNv
bnRleHRzLgpIb3dldmVyLCB0aGVyZSBpcyBubyBvYnZpb3VzIHJlYXNvbnMgdG8gZG8gdGhhdC4g
SXQgbG9va3MgbGlrZSBhCndvcmthcm91bmQgZm9yIGEgYnVnIHdpdGggdGhlIG9sZCBpbXBsZW1l
bnRhdGlvbiBvZiBfX3dmeF9mbHVzaCgpLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxs
ZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngv
c3RhLmMgfCAxMiArLS0tLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwg
MTEgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyBi
L2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKaW5kZXggM2Q2NjVlZWY4YmE3Li5hZTAxZjdiZTBk
ZGIgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKKysrIGIvZHJpdmVycy9z
dGFnaW5nL3dmeC9zdGEuYwpAQCAtMzYyLDE3ICszNjIsNyBAQCBzdGF0aWMgaW50IF9fd2Z4X2Zs
dXNoKHN0cnVjdCB3ZnhfZGV2ICp3ZGV2LCBib29sIGRyb3ApCiB2b2lkIHdmeF9mbHVzaChzdHJ1
Y3QgaWVlZTgwMjExX2h3ICpodywgc3RydWN0IGllZWU4MDIxMV92aWYgKnZpZiwKIAkJICB1MzIg
cXVldWVzLCBib29sIGRyb3ApCiB7Ci0Jc3RydWN0IHdmeF92aWYgKnd2aWY7Ci0KLQlpZiAodmlm
KSB7Ci0JCXd2aWYgPSAoc3RydWN0IHdmeF92aWYgKikgdmlmLT5kcnZfcHJpdjsKLQkJaWYgKHd2
aWYtPnZpZi0+dHlwZSA9PSBOTDgwMjExX0lGVFlQRV9NT05JVE9SKQotCQkJZHJvcCA9IHRydWU7
Ci0JCWlmICh3dmlmLT52aWYtPnR5cGUgPT0gTkw4MDIxMV9JRlRZUEVfQVAgJiYKLQkJICAgICF3
dmlmLT5lbmFibGVfYmVhY29uKQotCQkJZHJvcCA9IHRydWU7Ci0JfQotCS8vIEZJWE1FOiBvbmx5
IGZsdXNoIHJlcXVlc3RlZCB2aWYKKwkvLyBGSVhNRTogb25seSBmbHVzaCByZXF1ZXN0ZWQgdmlm
IGFuZCBxdWV1ZXMKIAlfX3dmeF9mbHVzaChody0+cHJpdiwgZHJvcCk7CiB9CiAKLS0gCjIuMjUu
MAoK
