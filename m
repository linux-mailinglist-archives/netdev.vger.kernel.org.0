Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4E019BEA
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 12:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727318AbfEJKuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 06:50:18 -0400
Received: from mail-eopbgr20060.outbound.protection.outlook.com ([40.107.2.60]:55334
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727261AbfEJKuS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 May 2019 06:50:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1DlB1haInKXf/Dxfc9Hwk+6zqoGSaoLWePK/2PsJ7aM=;
 b=fc3OQJOiQ8j37EsReMHfT59SBtU+KSXM9ha5F8TERuxvr+wQyG+UkrxW9tc14TuLAspzSUhGaXPdxtN3uH3Z59ZUOKB5upOvr2blUqOsgUHcyACJzrNAiHQc84iffxXWaTWmriSahsb+BLN4ETbVbM1ckteMyi5iLt48GjOMpVQ=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.138.152) by
 DB7PR04MB5994.eurprd04.prod.outlook.com (20.178.107.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.21; Fri, 10 May 2019 10:50:11 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::dcff:11e1:ab70:bb81]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::dcff:11e1:ab70:bb81%5]) with mapi id 15.20.1878.022; Fri, 10 May 2019
 10:50:11 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Stefan-gabriel Mirea <stefan-gabriel.mirea@nxp.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Subject: [PATCH V3 6/7] can: flexcan: add ISO CAN FD feature support
Thread-Topic: [PATCH V3 6/7] can: flexcan: add ISO CAN FD feature support
Thread-Index: AQHVBx4jSxL/V3x400CtMET933q2Tg==
Date:   Fri, 10 May 2019 10:50:11 +0000
Message-ID: <20190510104639.15170-7-qiangqing.zhang@nxp.com>
References: <20190510104639.15170-1-qiangqing.zhang@nxp.com>
In-Reply-To: <20190510104639.15170-1-qiangqing.zhang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: SG2PR01CA0105.apcprd01.prod.exchangelabs.com
 (2603:1096:3:15::31) To DB7PR04MB4618.eurprd04.prod.outlook.com
 (2603:10a6:5:36::24)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e298dea3-d2a2-4b9d-2806-08d6d5354636
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DB7PR04MB5994;
x-ms-traffictypediagnostic: DB7PR04MB5994:
x-microsoft-antispam-prvs: <DB7PR04MB5994AAD3EA45F4F24029E3B2E60C0@DB7PR04MB5994.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0033AAD26D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(39860400002)(396003)(136003)(376002)(366004)(189003)(199004)(54534003)(14454004)(11346002)(478600001)(66066001)(4326008)(66556008)(64756008)(66446008)(53936002)(66476007)(8936002)(81166006)(6436002)(81156014)(25786009)(8676002)(1076003)(6486002)(2501003)(6116002)(3846002)(186003)(2906002)(50226002)(305945005)(73956011)(14444005)(71190400001)(6512007)(71200400001)(446003)(66946007)(5660300002)(54906003)(2616005)(476003)(36756003)(86362001)(26005)(110136005)(7736002)(76176011)(102836004)(386003)(68736007)(99286004)(52116002)(6506007)(486006)(256004)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB5994;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: nUZcg5EB5oSqJhblh+zZT6kjqoZB5sVVgYn2zDleDxLMZKlP4dJBH1eEuNVp2ZHC+Pmxqlx7Ymky01vQFdF2mdikLQ+i4w8D4A6JDxfBRVxT02yvnQ09i0/KtAMjAlRpr7J2wWYcj5Gh8vhQtlAVuhRGlynPHvSq10OdAJVS1gcB63m/UYCJ3MOAKMDTlQiYT55Ql4X1y3QnpxPAx9EjSK8XnydkSt/KnlS3gD4sLA1zW24NlGCsI5vead6RNadqF/z83WvsF+yIP/pZqwxpDybFtTGzhS0qCwWA9YxzqSHIR0cF+LM1+3osS6mVs53qZw7s8f/hLiSkSThBZ7XjmVhnj74zvSBHdcMoEtfjMUFkq8fHWTr2wyyC7nWJa/eky6onl4h7Mslql+R4Kothaiv/igMeuD3FMMYJPFSie1o=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e298dea3-d2a2-4b9d-2806-08d6d5354636
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2019 10:50:11.0593
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5994
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SVNPIENBTiBGRCBpcyBpbnRyb2R1Y2VkIHRvIGluY3JlYXNlIHRoZSBmYWlsdHVyZSBkZXRlY3Rp
b24gY2FwYWJpbGl0eQ0KdGhhbiBub24tSVNPIENBTiBGRC4gVGhlIG5vbi1JU08gQ0FOIEZEIGlz
IHN0aWxsIHN1cHBvcnRlZCBieSBGbGV4Q0FOIHNvDQp0aGF0IGl0IGNhbiBiZSB1c2VkIG1haW5s
eSBkdXJpbmcgYW4gaW50ZXJtZWRpYXRlIHBoYXNlLCBmb3IgZXZhbHVhdGlvbg0KYW5kIGRldmVs
b3BtZW50IHB1cnBvc2VzLg0KDQpUaGVyZWZvcmUsIGl0IGlzIHN0cm9uZ2x5IHJlY29tbWVuZGVk
IHRvIGNvbmZpZ3VyZSBGbGV4Q0FOIHRvIHRoZSBJU08NCkNBTiBGRCBwcm90b2NvbCBieSBzZXR0
aW5nIHRoZSBJU09DQU5GREVOIGZpZWxkIGluIHRoZSBDVFJMMiByZWdpc3Rlci4NCg0KTk9URTog
aWYgeW91IG9ubHkgc2V0ICJmZCBvbiIsIGRyaXZlciB3aWxsIHVzZSBJU08gRkQgTU9ERSBieSBk
ZWZhdWx0Lg0KDQpTaWduZWQtb2ZmLWJ5OiBKb2FraW0gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0Bu
eHAuY29tPg0KDQpDaGFuZ2VMb2c6DQotLS0tLS0tLS0tDQpWMS0+VjI6DQoJKk5vbmUNClYyLT5W
MzoNCgkqY29ycmVjdCBhIG1pc3Rha2U6IGZsZXhjYW5fcmVhZCgpL3dyaXRlKCktPnByaXYtPnJl
YWQoKS93cml0ZSgpDQotLS0NCiBkcml2ZXJzL25ldC9jYW4vZmxleGNhbi5jIHwgOCArKysrKysr
LQ0KIDEgZmlsZSBjaGFuZ2VkLCA3IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCg0KZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2Nhbi9mbGV4Y2FuLmMgYi9kcml2ZXJzL25ldC9jYW4vZmxl
eGNhbi5jDQppbmRleCBjYTcyNDBkNjkwNDIuLmVkMzQ2MzU4MmRjMSAxMDA2NDQNCi0tLSBhL2Ry
aXZlcnMvbmV0L2Nhbi9mbGV4Y2FuLmMNCisrKyBiL2RyaXZlcnMvbmV0L2Nhbi9mbGV4Y2FuLmMN
CkBAIC05Miw2ICs5Miw3IEBADQogI2RlZmluZSBGTEVYQ0FOX0NUUkwyX01SUAkJQklUKDE4KQ0K
ICNkZWZpbmUgRkxFWENBTl9DVFJMMl9SUlMJCUJJVCgxNykNCiAjZGVmaW5lIEZMRVhDQU5fQ1RS
TDJfRUFDRU4JCUJJVCgxNikNCisjZGVmaW5lIEZMRVhDQU5fQ1RSTDJfSVNPQ0FORkRFTglCSVQo
MTIpDQogDQogLyogRkxFWENBTiBtZW1vcnkgZXJyb3IgY29udHJvbCByZWdpc3RlciAoTUVDUikg
Yml0cyAqLw0KICNkZWZpbmUgRkxFWENBTl9NRUNSX0VDUldSRElTCQlCSVQoMzEpDQpAQCAtMTI3
Niw2ICsxMjc3LDcgQEAgc3RhdGljIGludCBmbGV4Y2FuX2NoaXBfc3RhcnQoc3RydWN0IG5ldF9k
ZXZpY2UgKmRldikNCiAJCXJlZ19mZGN0cmwgJj0gfihGTEVYQ0FOX0ZEQ1RSTF9NQkRTUjMoMHgz
KSB8IEZMRVhDQU5fRkRDVFJMX01CRFNSMigweDMpIHwNCiAJCQkJRkxFWENBTl9GRENUUkxfTUJE
U1IxKDB4MykgfCBGTEVYQ0FOX0ZEQ1RSTF9NQkRTUjAoMHgzKSk7DQogCQlyZWdfbWNyID0gcHJp
di0+cmVhZCgmcmVncy0+bWNyKSAmIH5GTEVYQ0FOX01DUl9GREVOOw0KKwkJcmVnX2N0cmwyID0g
cHJpdi0+cmVhZCgmcmVncy0+Y3RybDIpICYgfkZMRVhDQU5fQ1RSTDJfSVNPQ0FORkRFTjsNCiAN
CiAJCS8qIHN1cHBvcnQgQlJTIHdoZW4gc2V0IENBTiBGRCBtb2RlDQogCQkgKiA2NCBieXRlcyBw
YXlsb2FkIHBlciBNQiBhbmQgNyBNQnMgcGVyIFJBTSBibG9jayBieSBkZWZhdWx0DQpAQCAtMTI4
NiwxMCArMTI4OCwxNCBAQCBzdGF0aWMgaW50IGZsZXhjYW5fY2hpcF9zdGFydChzdHJ1Y3QgbmV0
X2RldmljZSAqZGV2KQ0KIAkJCXJlZ19mZGN0cmwgfD0gRkxFWENBTl9GRENUUkxfTUJEU1IzKDB4
MykgfCBGTEVYQ0FOX0ZEQ1RSTF9NQkRTUjIoMHgzKSB8DQogCQkJCQlGTEVYQ0FOX0ZEQ1RSTF9N
QkRTUjEoMHgzKSB8IEZMRVhDQU5fRkRDVFJMX01CRFNSMCgweDMpOw0KIAkJCXJlZ19tY3IgfD0g
RkxFWENBTl9NQ1JfRkRFTjsNCisNCisJCQlpZiAoIShwcml2LT5jYW4uY3RybG1vZGUgJiBDQU5f
Q1RSTE1PREVfRkRfTk9OX0lTTykpDQorCQkJCXJlZ19jdHJsMiB8PSBGTEVYQ0FOX0NUUkwyX0lT
T0NBTkZERU47DQogCQl9DQogDQogCQlwcml2LT53cml0ZShyZWdfZmRjdHJsLCAmcmVncy0+ZmRj
dHJsKTsNCiAJCXByaXYtPndyaXRlKHJlZ19tY3IsICZyZWdzLT5tY3IpOw0KKwkJcHJpdi0+d3Jp
dGUocmVnX2N0cmwyLCAmcmVncy0+Y3RybDIpOw0KIAl9DQogDQogCWlmICgocHJpdi0+ZGV2dHlw
ZV9kYXRhLT5xdWlya3MgJiBGTEVYQ0FOX1FVSVJLX0VOQUJMRV9FQUNFTl9SUlMpKSB7DQpAQCAt
MTc3OSw3ICsxNzg1LDcgQEAgc3RhdGljIGludCBmbGV4Y2FuX3Byb2JlKHN0cnVjdCBwbGF0Zm9y
bV9kZXZpY2UgKnBkZXYpDQogDQogCWlmIChwcml2LT5kZXZ0eXBlX2RhdGEtPnF1aXJrcyAmIEZM
RVhDQU5fUVVJUktfVElNRVNUQU1QX1NVUFBPUlRfRkQpIHsNCiAJCWlmIChwcml2LT5kZXZ0eXBl
X2RhdGEtPnF1aXJrcyAmIEZMRVhDQU5fUVVJUktfVVNFX09GRl9USU1FU1RBTVApIHsNCi0JCQlw
cml2LT5jYW4uY3RybG1vZGVfc3VwcG9ydGVkIHw9IENBTl9DVFJMTU9ERV9GRDsNCisJCQlwcml2
LT5jYW4uY3RybG1vZGVfc3VwcG9ydGVkIHw9IENBTl9DVFJMTU9ERV9GRCB8IENBTl9DVFJMTU9E
RV9GRF9OT05fSVNPOw0KIAkJCXByaXYtPmNhbi5iaXR0aW1pbmdfY29uc3QgPSAmZmxleGNhbl9m
ZF9iaXR0aW1pbmdfY29uc3Q7DQogCQkJcHJpdi0+Y2FuLmRhdGFfYml0dGltaW5nX2NvbnN0ID0g
JmZsZXhjYW5fZmRfZGF0YV9iaXR0aW1pbmdfY29uc3Q7DQogCQl9IGVsc2Ugew0KLS0gDQoyLjE3
LjENCg0K
