Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CDA320D7C1
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 22:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733212AbgF2Tcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:32:31 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:52985 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732951AbgF2Tc0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:32:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1593459146; x=1624995146;
  h=from:to:cc:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=gGQVZwE+pnzncmQh0KEc1c95kDfMl6zV343reXKcIds=;
  b=gOIOM1xDMhvgqXf3lUb1FDjcsPdQPqTt0OyCc44949cv1cwJ+utrVwAp
   OijKloph3rXoIOaFqdvjI8z4CpoiHReb4skXSw5cpl19QwxUIMYMbWFZt
   nG99LRGrsOIvAS64aXnHZuCMdsHd/7vwh8Z8sp0abeopaRtaZVB5Gtcxp
   oOLSjLDYolytsHrmDLCLS0PRMDw+FtcLlfoFUf7S420LjX+3BoZ7gC7/8
   UhwAWRNoN4kpFtxgSHrOda14qHqI9XetF10oxpt2WfVdMKPmJizXagvcl
   MgszoFc1Lw+ih+ONhcoRDK2/xsXBeug24a7dJjRM7hU4R+gD6HBvzIz9E
   Q==;
IronPort-SDR: +GRppOEDOZSQRMMvMEFnKzUoTxHv6A5YH1EH+pJXoobK9HS04/qaa9aiO0irWHdMpK2U8+QLwu
 1yU+ejAcTytFvezhqnpNEPbV3YhH/ooNiICkBZqhJKi9RV8hMrmdN1rjCHzrb4wNFPr2iFln6o
 hAfSYUzz6g2v9Fl4HcswwHsSlS7ew5B78vRJFf0qdpd4/d8TmiUqE146xy8FX115U8/ZyGwxbS
 flRvVUakFj4zhEHxVXlA8DgCn/8r6XoceJGcfxtxR5K07cclpnOMkmfc/yt8YmdMCmYu2DlKiT
 +KE=
X-IronPort-AV: E=Sophos;i="5.75,294,1589266800"; 
   d="scan'208";a="78141532"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Jun 2020 06:10:49 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 29 Jun 2020 06:10:31 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Mon, 29 Jun 2020 06:10:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HcV9pyWCJjif3kn1BBx9YbW7MyZt+r38YSAJLjCqz9dm/dgUx27gm99LYDJeZNLbiUS1ELC6x5aaFe6f1hFmhXVhH41z04YgPzpMlaheLxYcVe4KOheiwQQ18hRQMfoWGw8F7st4MIVo2dToiFD9nrjJnQpfTzRbXiKi45QNm8FYDnUGwttB/pahXcIjXWCnMxInFHstGstJDYO/4NZLJWKDJ9LXIhSknRlfvT/G5owf+j0QQ/feIrSot/b5CdupBXctmXGFfek44IBjZ951Sh/GHSwTK1HMTweKtQoMsOzgOfkC1p9JvTPA34+guK/W5Ihadif9Dlm8LGkFxpwFVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gGQVZwE+pnzncmQh0KEc1c95kDfMl6zV343reXKcIds=;
 b=mC/6Mcj9bkTsaieIMa1oN1bZvqMBBS6FV7WOEyvNR2pcq6lpSuG/lZC0TLiiTt4p1m20BSkg+qAkiSeFTxZOaKU59c6gDaU0L37naNA80trmnH632iDHBKwAq7Aru8M3xAPfk8fosww5mEY+VbwwjL4maRZauXK79VvBqFMp8igi7mL3YJCQ/ccpjSyHa4AohngAoToe3pDRofSg10vPZhlXKGbL1Wal9snA9VfBewsDyhoNXl+sL3D6jHpaacYgQUfDIxiM4YsArzb0s2dGrXc0SCLygnO2ZEBfdGcaEEInuReX5naXkH6qTz58nsfoCCNTxrC8eC6jHwpVu1UHew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gGQVZwE+pnzncmQh0KEc1c95kDfMl6zV343reXKcIds=;
 b=fZa2Re/3NOcJbwRomZz7QjQUXoRJ/z2esFEipFEl1FhWYE2AczQurD3N23fqqWSodFeE4y6iLT/doD8xzEaZGTIr9ZYHcLCdV5mMZVDFqRdicSfHD94OQq6DGUvvQKZ5dl/tudhdXmNrPkhXW6nHKQGtG1MK51x9kvzBmZrXJek=
Received: from BY5PR11MB3927.namprd11.prod.outlook.com (2603:10b6:a03:186::21)
 by BYAPR11MB3237.namprd11.prod.outlook.com (2603:10b6:a03:1e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.23; Mon, 29 Jun
 2020 13:10:47 +0000
Received: from BY5PR11MB3927.namprd11.prod.outlook.com
 ([fe80::5993:d0ac:9849:d311]) by BY5PR11MB3927.namprd11.prod.outlook.com
 ([fe80::5993:d0ac:9849:d311%7]) with mapi id 15.20.3131.027; Mon, 29 Jun 2020
 13:10:47 +0000
From:   <Andre.Edich@microchip.com>
To:     <netdev@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <steve.glendinning@shawell.net>
CC:     <Parthiban.Veerasooran@microchip.com>
Subject: [PATCH net-next 1/8] smsc95xx: check return value of smsc95xx_reset
Thread-Topic: [PATCH net-next 1/8] smsc95xx: check return value of
 smsc95xx_reset
Thread-Index: AQHWTha0HM5d9HIF0k+uJoncphZKgw==
Date:   Mon, 29 Jun 2020 13:10:47 +0000
Message-ID: <07d84bc9ea8a7282b790795ca3ebfc0c7d63447d.camel@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.3 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=microchip.com;
x-originating-ip: [93.202.178.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3ba32816-673b-4cfa-3faa-08d81c2dd69a
x-ms-traffictypediagnostic: BYAPR11MB3237:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB3237BB936B4E04FBBAC127ECEC6E0@BYAPR11MB3237.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-forefront-prvs: 044968D9E1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HwaAJxdVUwU0eNgUDqIi0SHbm6qgPtarQvB5wFPGYMqekmlwh6O2iPiR3A7utkdld6bqJRqyqySnqZe65D9EPu+bkYztvT06kLDQgGiFflUQ0rG4wmXvDfLSjz4TMWX4a8ak6ky12h3x3890gJfUSnZhmqFa5Wqm/7f0BYI3IA1GYhe0SDOp4qfWO/OLLcwL6iBzWxkoSEaDE7fu5zh8/8+g16y8oMX2JFXwkrDfwA1lBzqq9+ZCFcDI1nYZcWQpWtlosLsI3uNr+o21EaTcLn4IWdxxj88/Qgbunbmj0VJJ6G0ajXcrP1xKV9nxvEq/
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB3927.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(136003)(39860400002)(366004)(396003)(346002)(186003)(76116006)(4326008)(6512007)(8936002)(110136005)(36756003)(71200400001)(66446008)(66946007)(91956017)(66476007)(6486002)(2906002)(86362001)(66556008)(5660300002)(107886003)(64756008)(8676002)(316002)(83380400001)(2616005)(26005)(478600001)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 3G9pdN1LrhoEOTRSRM5kOy9H+4aIeeRnHpRO/RRHzsjNYiFFt6wFPCmDEEf8vOCZKFY2vJyIwcbzOJegP77izPt/J0zD1odQLfqKAujSL8xums61HFgxLvmagnBV8k5CSMTnNDVTttdxvDOpAACa7hTCnGrbYYxuE+GlK3SxpKko42QfD1M0eUU7Q9UArMY2KOHVjPEw5mkq/Ya/6fJet0JbUwHrUXBGTl6qVALXCpmCCsRiT4aW5yM9glpj6ZGUzxoKGCxT1GcWOpT0FQctBI0n+JIB152MUOsQgVSpBl+G14MIUWL4C/tjcfYNzrRTVXRku6GEI2jR53mE8JmAnRpMSwXawXqsZ4ALq0cAtSj2/gDkxFVqawByzSVGJZ5JL7FrA7VwGk8F75LCqeoGMDXUTl5fD8vLFn10YznNmlbaGtYShMBpFsJ4aKWThE7wJ2V0ub94N3JfNzRQ8j9llXMrtMZ6ZyDmJeYaDuXDTBU=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C90F1E073640AA4E93B27396F5DBCBCC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB3927.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ba32816-673b-4cfa-3faa-08d81c2dd69a
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2020 13:10:47.0525
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d2tfIH5+XvaOWz1R42mGyz6BV+BTujqcX8gIAxVE0MK966+fEZY/81yV/J03r4tjXaoJA05KWJF5/mqg+c8X4RgogAJZ5jUTRMlq4ZoJX6A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3237
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhlIHJldHVybiB2YWx1ZSBvZiB0aGUgZnVuY3Rpb24gc21zYzk1eHhfcmVzZXQoKSBtdXN0IGJl
IGNoZWNrZWQNCnRvIGF2b2lkIHJldHVybmluZyBmYWxzZSBzdWNjZXNzIGZyb20gdGhlIGZ1bmN0
aW9uIHNtc2M5NXh4X2JpbmQoKS4NCg0KU2lnbmVkLW9mZi1ieTogQW5kcmUgRWRpY2ggPGFuZHJl
LmVkaWNoQG1pY3JvY2hpcC5jb20+DQpTaWduZWQtb2ZmLWJ5OiBQYXJ0aGliYW4gVmVlcmFzb29y
YW4gPA0KUGFydGhpYmFuLlZlZXJhc29vcmFuQG1pY3JvY2hpcC5jb20+DQotLS0NCiBkcml2ZXJz
L25ldC91c2Ivc21zYzk1eHguYyB8IDYgKysrKysrDQogMSBmaWxlIGNoYW5nZWQsIDYgaW5zZXJ0
aW9ucygrKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvdXNiL3Ntc2M5NXh4LmMgYi9kcml2
ZXJzL25ldC91c2Ivc21zYzk1eHguYw0KaW5kZXggM2NmNGRjMzQzM2Y5Li5lYjQwNGJiNzRlMTgg
MTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC91c2Ivc21zYzk1eHguYw0KKysrIGIvZHJpdmVycy9u
ZXQvdXNiL3Ntc2M5NXh4LmMNCkBAIC0xMjg3LDYgKzEyODcsOCBAQCBzdGF0aWMgaW50IHNtc2M5
NXh4X2JpbmQoc3RydWN0IHVzYm5ldCAqZGV2LA0Kc3RydWN0IHVzYl9pbnRlcmZhY2UgKmludGYp
DQogDQogCS8qIEluaXQgYWxsIHJlZ2lzdGVycyAqLw0KIAlyZXQgPSBzbXNjOTV4eF9yZXNldChk
ZXYpOw0KKwlpZiAocmV0KQ0KKwkJZ290byBmcmVlX3BkYXRhOw0KIA0KIAkvKiBkZXRlY3QgZGV2
aWNlIHJldmlzaW9uIGFzIGRpZmZlcmVudCBmZWF0dXJlcyBtYXkgYmUNCmF2YWlsYWJsZSAqLw0K
IAlyZXQgPSBzbXNjOTV4eF9yZWFkX3JlZyhkZXYsIElEX1JFViwgJnZhbCk7DQpAQCAtMTMxNyw2
ICsxMzE5LDEwIEBAIHN0YXRpYyBpbnQgc21zYzk1eHhfYmluZChzdHJ1Y3QgdXNibmV0ICpkZXYs
DQpzdHJ1Y3QgdXNiX2ludGVyZmFjZSAqaW50ZikNCiAJc2NoZWR1bGVfZGVsYXllZF93b3JrKCZw
ZGF0YS0+Y2Fycmllcl9jaGVjaywNCkNBUlJJRVJfQ0hFQ0tfREVMQVkpOw0KIA0KIAlyZXR1cm4g
MDsNCisNCitmcmVlX3BkYXRhOg0KKwlrZnJlZShwZGF0YSk7DQorCXJldHVybiByZXQ7DQogfQ0K
IA0KIHN0YXRpYyB2b2lkIHNtc2M5NXh4X3VuYmluZChzdHJ1Y3QgdXNibmV0ICpkZXYsIHN0cnVj
dCB1c2JfaW50ZXJmYWNlDQoqaW50ZikNCg==
