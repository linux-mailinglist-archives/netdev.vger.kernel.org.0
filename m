Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A09719F44C
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 13:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727548AbgDFLSa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 07:18:30 -0400
Received: from mail-dm6nam11on2071.outbound.protection.outlook.com ([40.107.223.71]:6126
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727181AbgDFLS3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Apr 2020 07:18:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UszR6/0gk9VuQBwHKFB8DrB25i6FRuuY/CizCaSZPUYgQUNY6PZKHs+PQdwN+rhGxv+Mv8qJLoIWy9GVebRTQFArMZWuwt2Y4l6MCIz1b83TmGlMNErus5MHy0UwNqdiRVDYrt8kpTTEtGUoTBV6E7IUFmrTQlwsNwWg3ZPOZR78OUUdfWDGt9tMKFLeKBm8/EiEE7nOS+yGL93kcJn8rDErx+dseiT/0EE16wIvlJ8JTylbesac+i/5Q4rkmt/DrderG+G7sKIn+qnw3J+Bttw9Aq/zrwb3vtsiAqvAOTusxFDOwTfQqg0u3yBH9OK2aKu9htBkoLT7Qa4Mcu7M3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=71xh9u/RIMkG499DwssDiiGYNVHPEa5/cKqpph8ivW0=;
 b=KC8NVAg0V8i+ZnmEibnY/mNFDki/jDyD8LZ9wpW/PSG8dWs+QZM+kysoYZOH08JhAFU2HQ4fNYdGEIQFYZ8lCCVN39m2pESzB66TiAALfo1PH2Zi0TdMu4SrTHayGgTh1NxK+1tXZPjgKfoOnvsixydzfkTAscM0dnD1/DAtVoyL50ndbxFW/gK5RoO69+cII2bumCtvWp9E62BCSOgTdO8i/GCicnkUR5+HFObT4D0sRUFffaWtCwHJu9Nzt6v3TtGG9q+pNoNXn0TEI9XsC1YiZknxfSNgdbIt6S9wqQ7x8dS7pYtV3/21SDDKQ9qylMr/jsmdKptNft2YgoXNLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=71xh9u/RIMkG499DwssDiiGYNVHPEa5/cKqpph8ivW0=;
 b=bopQMs9/GIZbQIw/p9kkbheBG5p/rtt5U5Ow7dnNNrObrYClrETlszZDYkhNbyuKeVlDrAy9+AJZbu1xwuoJH+xRb3iBTBHDeuqdL6q5KMW/OGBu1lxmAbMLmRY6r7QGkYgNNZ903uUwephMFY4pzgICt5v4+OQFH88L9umANFk=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from BN6PR11MB4052.namprd11.prod.outlook.com (2603:10b6:405:7a::37)
 by BN6PR11MB3860.namprd11.prod.outlook.com (2603:10b6:405:77::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.15; Mon, 6 Apr
 2020 11:18:18 +0000
Received: from BN6PR11MB4052.namprd11.prod.outlook.com
 ([fe80::e0af:e9de:ffce:7376]) by BN6PR11MB4052.namprd11.prod.outlook.com
 ([fe80::e0af:e9de:ffce:7376%3]) with mapi id 15.20.2878.018; Mon, 6 Apr 2020
 11:18:17 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 02/11] staging: wfx: relocate LINK_ID_NO_ASSOC and MAX_STA_IN_AP_MODE to hif API
Date:   Mon,  6 Apr 2020 13:17:47 +0200
Message-Id: <20200406111756.154086-3-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200406111756.154086-1-Jerome.Pouiller@silabs.com>
References: <20200406111756.154086-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: DM5PR05CA0010.namprd05.prod.outlook.com
 (2603:10b6:3:d4::20) To BN6PR11MB4052.namprd11.prod.outlook.com
 (2603:10b6:405:7a::37)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by DM5PR05CA0010.namprd05.prod.outlook.com (2603:10b6:3:d4::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.13 via Frontend Transport; Mon, 6 Apr 2020 11:18:16 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e7e5e3a6-3ccc-4a30-aa6c-08d7da1c34bc
X-MS-TrafficTypeDiagnostic: BN6PR11MB3860:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN6PR11MB3860F10F0CCF2B7093C71FF893C20@BN6PR11MB3860.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-Forefront-PRVS: 0365C0E14B
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB4052.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(396003)(39850400004)(346002)(366004)(136003)(376002)(186003)(16526019)(7696005)(52116002)(36756003)(5660300002)(107886003)(316002)(54906003)(66946007)(66476007)(4326008)(2616005)(66556008)(1076003)(81166006)(6666004)(6486002)(8936002)(2906002)(86362001)(81156014)(8676002)(478600001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ARabYavYWCGuNVhIPfFJTw4dYllGb+FCgUD5tt+/bM2vBRaz3izBD0F9hSpM4yduFOHXkRsnJ0IdCsdWOc9Fv39BCDdsKWAR7S+XU57hc3Vky9d+cXfgNEOKJlBl0qCdrM6gDV0DZaqQznZ6vfLVE49Bh+RfTVO6pS5BNnD+yo19sC0RxoRrDh+d5E3LJ1pudkvAbCrydgTRPMskSp4eVRVYz28uVZDm4l6s2Ja038eYuyKBJtrIMXvkfDA8ws2gS2+F/edaKXd9X9EY4EqJSztcmp77T+XgnlSJqqDPHFL3fwq6lektRgMotcwSU9TeoAmjFgwgs2z3Xx/YXU4HjyLyEu4aqNujQZj1f0kMaIC65Y+7Iutn6XpUNaMvYHaFyeCkx21vqZ5lhH2p2f0mM4abEWjAiQPUxAxomAm05Zj++bKBt3Z6psj26Li7ieie
X-MS-Exchange-AntiSpam-MessageData: pUj5x91NcaoWydM2gOqqsZ8olywHjMLS7dPc/Zh+oEc/XuLvLguUHWvosQoD+lpPuHzCo3MO3bWihm5BA7900KlXJmG7SndKAql0Bs8VeagvyOEVZU6meYzm2GuVJVhQABIuPHo7iANauoII1CivSyMuEKWKoQr8DFCvbyZmN1coF4CEAbPutEB49L2VIv9TzGBCHrcRUN5sGKgTXSAYsQ==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7e5e3a6-3ccc-4a30-aa6c-08d7da1c34bc
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2020 11:18:17.8261
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NsOC8tziAf9AxdkpUM3rzT4chvooRv/1dHH1acc6rGZvevGYVAsISLZH469jpj/oBwiEiHjwRNHdJYeoTWlykQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB3860
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGRlZmluaXRpb25zIExJTktfSURfTk9fQVNTT0MgYW5kIE1BWF9TVEFfSU5fQVBfTU9ERSBhcmUg
aW1wb3NlZCBieQp0aGUgaGFyZHdhcmUuIFRoZXJlZm9yZSwgdGhleSBzaG91bGQgYmUgbG9jYXRl
ZCBpbiB0aGUgaGFyZHdhcmUKaW50ZXJmYWNlIEFQSS4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1l
IFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdp
bmcvd2Z4L2RhdGFfdHguYyAgICAgfCAyICstCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlf
Y21kLmggfCAzICsrKwogZHJpdmVycy9zdGFnaW5nL3dmeC9tYWluLmMgICAgICAgIHwgMiArLQog
ZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5oICAgICAgIHwgMyAtLS0KIGRyaXZlcnMvc3RhZ2lu
Zy93Zngvc3RhLmMgICAgICAgICB8IDIgKy0KIDUgZmlsZXMgY2hhbmdlZCwgNiBpbnNlcnRpb25z
KCspLCA2IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0
YV90eC5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmMKaW5kZXggYzg4ZDE0ZmU2MTRi
Li43NTdlMzc0NTQzOTEgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5j
CisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jCkBAIC0yNDYsNyArMjQ2LDcgQEAg
c3RhdGljIHU4IHdmeF90eF9nZXRfbGlua19pZChzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgc3RydWN0
IGllZWU4MDIxMV9zdGEgKnN0YSwKIAkJcmV0dXJuIDA7CiAJaWYgKGlzX211bHRpY2FzdF9ldGhl
cl9hZGRyKGRhKSkKIAkJcmV0dXJuIDA7Ci0JcmV0dXJuIFdGWF9MSU5LX0lEX05PX0FTU09DOwor
CXJldHVybiBISUZfTElOS19JRF9OT1RfQVNTT0NJQVRFRDsKIH0KIAogc3RhdGljIHZvaWQgd2Z4
X3R4X2ZpeHVwX3JhdGVzKHN0cnVjdCBpZWVlODAyMTFfdHhfcmF0ZSAqcmF0ZXMpCmRpZmYgLS1n
aXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfY21kLmggYi9kcml2ZXJzL3N0YWdpbmcv
d2Z4L2hpZl9hcGlfY21kLmgKaW5kZXggMDcxYjcxZTJhMTA3Li5mNjkzNDU5OGYzMTkgMTAwNjQ0
Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9jbWQuaAorKysgYi9kcml2ZXJzL3N0
YWdpbmcvd2Z4L2hpZl9hcGlfY21kLmgKQEAgLTQ4MCw2ICs0ODAsOSBAQCBzdHJ1Y3QgaGlmX2Nu
Zl9iZWFjb25fdHJhbnNtaXQgewogCXUzMiAgIHN0YXR1czsKIH0gX19wYWNrZWQ7CiAKKyNkZWZp
bmUgSElGX0xJTktfSURfTUFYICAgICAgICAgICAgMTQKKyNkZWZpbmUgSElGX0xJTktfSURfTk9U
X0FTU09DSUFURUQgKEhJRl9MSU5LX0lEX01BWCArIDEpCisKIGVudW0gaGlmX3N0YV9tYXBfZGly
ZWN0aW9uIHsKIAlISUZfU1RBX01BUCAgICAgICAgICAgICAgICAgICAgICAgPSAweDAsCiAJSElG
X1NUQV9VTk1BUCAgICAgICAgICAgICAgICAgICAgID0gMHgxCmRpZmYgLS1naXQgYS9kcml2ZXJz
L3N0YWdpbmcvd2Z4L21haW4uYyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvbWFpbi5jCmluZGV4IDcz
ODAxNmQ0NWQ2My4uMWU5ZjZkYTc1MDI0IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4
L21haW4uYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L21haW4uYwpAQCAtMzEzLDcgKzMxMyw3
IEBAIHN0cnVjdCB3ZnhfZGV2ICp3ZnhfaW5pdF9jb21tb24oc3RydWN0IGRldmljZSAqZGV2LAog
CWh3LT53aXBoeS0+ZmxhZ3MgfD0gV0lQSFlfRkxBR19BUF9QUk9CRV9SRVNQX09GRkxPQUQ7CiAJ
aHctPndpcGh5LT5mbGFncyB8PSBXSVBIWV9GTEFHX0FQX1VBUFNEOwogCWh3LT53aXBoeS0+Zmxh
Z3MgJj0gfldJUEhZX0ZMQUdfUFNfT05fQllfREVGQVVMVDsKLQlody0+d2lwaHktPm1heF9hcF9h
c3NvY19zdGEgPSBXRlhfTUFYX1NUQV9JTl9BUF9NT0RFOworCWh3LT53aXBoeS0+bWF4X2FwX2Fz
c29jX3N0YSA9IEhJRl9MSU5LX0lEX01BWDsKIAlody0+d2lwaHktPm1heF9zY2FuX3NzaWRzID0g
MjsKIAlody0+d2lwaHktPm1heF9zY2FuX2llX2xlbiA9IElFRUU4MDIxMV9NQVhfREFUQV9MRU47
CiAJaHctPndpcGh5LT5uX2lmYWNlX2NvbWJpbmF0aW9ucyA9IEFSUkFZX1NJWkUod2Z4X2lmYWNl
X2NvbWJpbmF0aW9ucyk7CmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3F1ZXVlLmgg
Yi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3F1ZXVlLmgKaW5kZXggYWI0NWUzMmNiZmJjLi4xMDIwZGZk
ZTM5OWIgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvcXVldWUuaAorKysgYi9kcml2
ZXJzL3N0YWdpbmcvd2Z4L3F1ZXVlLmgKQEAgLTEzLDkgKzEzLDYgQEAKIAogI2luY2x1ZGUgImhp
Zl9hcGlfY21kLmgiCiAKLSNkZWZpbmUgV0ZYX01BWF9TVEFfSU5fQVBfTU9ERSAgICAxNAotI2Rl
ZmluZSBXRlhfTElOS19JRF9OT19BU1NPQyAgICAgIDE1Ci0KIHN0cnVjdCB3ZnhfZGV2Owogc3Ry
dWN0IHdmeF92aWY7CiAKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgYi9k
cml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCmluZGV4IDJlOGQzZjU3MWMzZS4uNjRjZjU4MTIyNjYx
IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCisrKyBiL2RyaXZlcnMvc3Rh
Z2luZy93Zngvc3RhLmMKQEAgLTU2Myw3ICs1NjMsNyBAQCBpbnQgd2Z4X3N0YV9hZGQoc3RydWN0
IGllZWU4MDIxMV9odyAqaHcsIHN0cnVjdCBpZWVlODAyMTFfdmlmICp2aWYsCiAJc3RhX3ByaXYt
PmxpbmtfaWQgPSBmZnood3ZpZi0+bGlua19pZF9tYXApOwogCXd2aWYtPmxpbmtfaWRfbWFwIHw9
IEJJVChzdGFfcHJpdi0+bGlua19pZCk7CiAJV0FSTl9PTighc3RhX3ByaXYtPmxpbmtfaWQpOwot
CVdBUk5fT04oc3RhX3ByaXYtPmxpbmtfaWQgPj0gV0ZYX01BWF9TVEFfSU5fQVBfTU9ERSk7CisJ
V0FSTl9PTihzdGFfcHJpdi0+bGlua19pZCA+PSBISUZfTElOS19JRF9NQVgpOwogCWhpZl9tYXBf
bGluayh3dmlmLCBzdGEtPmFkZHIsIDAsIHN0YV9wcml2LT5saW5rX2lkKTsKIAogCXJldHVybiAw
OwotLSAKMi4yNS4xCgo=
