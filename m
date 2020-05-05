Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52E2A1C55A2
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 14:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729123AbgEEMiq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 08:38:46 -0400
Received: from mail-eopbgr680041.outbound.protection.outlook.com ([40.107.68.41]:21169
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729075AbgEEMih (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 08:38:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WyZOdAUg06ZPSarKOwtVZeDHOB5QqqBM6oeH/U9/a9aL3Z3XhEOPxEqPlUauJ5SHNPWfvFKHWEQTk36DIzORMjHXZy7pTQNmk+znvsmu3wgKuKvId7/lD/9qWzX313FU2S6S9hmPtVdJUMxoH77XhvFNezDZ247/w0icTGyX1C1cvyas9eDVrfJoTBPRkD+fSk3lVoFiBTgTefANlcPm4/BNQ7oLBRiadRMFB4HWcyKsYCcjOVZDyYb8WODopulRzw3ZPbl+qB6FHb5R7Ego3dsP6Zph1f8gRGoFGfgAw14VzuEOZLT4rqpfCEWdGmgxw1qXf5boLS6f0hsqLUfFkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NMpfck1aDMqtJrUHlkcbaq7MiZYLPBmRtELEHKBmXaQ=;
 b=FBNElqP6deGRhtAE2CTWGyOiTAJX5UPQ21yDmQHT1lylZEtHRFVkRU325JLPiuyWMlp0gxiUuQrYbGpB503yUU/25wPsEkZ+whSRCLTrTO0qL+8WngnD45jaNrm7k1KD86RBQcSLiUTpH5cX+6j6FuxUDEK+db4Wbhhnm3Ni7h+CLXHhjsgSOSMoKDpoeM98PXKsFyqPvVm4tTDDD2rpxilUqFyX6sXn2beuKK39s7W1xrx0P3y1SABewnjnIhHl6/65FPZ1DnqLI9edi4H0g+Uca81wGXRskCLiQFsNp7k7eAzwiWlLdmCoq0gQT8upOe2tPh3uG7gwZ7kDZcOXow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NMpfck1aDMqtJrUHlkcbaq7MiZYLPBmRtELEHKBmXaQ=;
 b=VtOxdcZoe9IM8wislvQNVjnuSKt5EV8B5RdS9GnwoOYfc0oKWU5V6CVyzWpnLKd9yv5lmtQIaEHmhDFwOYeCz0fMEwhUpyLZ6G41DeFz4T3B+JwzdOyM6Az4Qn4IhT6Ik7W7U7kBwDocKC5jmK2BizJi0QSr/bwx7Qn86BVoZUA=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1824.namprd11.prod.outlook.com (2603:10b6:300:110::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19; Tue, 5 May
 2020 12:38:24 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe%10]) with mapi id 15.20.2958.030; Tue, 5 May 2020
 12:38:24 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 06/15] staging: wfx: use threaded IRQ with SPI
Date:   Tue,  5 May 2020 14:37:48 +0200
Message-Id: <20200505123757.39506-7-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200505123757.39506-1-Jerome.Pouiller@silabs.com>
References: <20200505123757.39506-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR3P189CA0022.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:52::27) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.home (2a01:e35:2435:66a0:1265:30ff:fefd:6e7f) by PR3P189CA0022.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:52::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Tue, 5 May 2020 12:38:22 +0000
X-Mailer: git-send-email 2.26.1
X-Originating-IP: [2a01:e35:2435:66a0:1265:30ff:fefd:6e7f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dcd27bac-09f5-4129-ba2d-08d7f0f133c1
X-MS-TrafficTypeDiagnostic: MWHPR11MB1824:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB18241E1F49674E8897F3F58493A70@MWHPR11MB1824.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 0394259C80
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uWhmmeoW26eetYjWVYZOOZ3K51gB59q7Tt0Ck9YNqsJ8IXbefmLyTNgQZStLfh/9dnINXjfjsdtBgec5Qqdru2p0TGHDXBy/CWxLA0hlpAxqwCkJNSlpvD2Yhd43SjXIgd7rLsfclcT0j/2WShkXmNjHl7QHHWKggbxu+rjldSzxnxxcm6tWJj7+FHPOzv5xgIRKi0xJy6ZH+U2VfNJMADR3oqUjUe/U9S0WrP9/1erV9oCkoXY7Tai5mtovnxB4zerlvt+egNaVn0//yDtLgSf4+fVrSB+DOCZnuyZm/zBfwf/nngdXopjjdsnyQ6iFVD1gxjOMErrhyMCuY51W/aQb96XevJPCUVwBuTEIWhBlBf/WRA3gfN1kOh/2l2WIo68LDVVznz5BfIBlDUv5j+bYojM2rNaWk80l9uvxAmV4i1Vsq6zUhaTb3yb95Hj2MbS0z0PWs6mjUldNaech3RhwXTS6USWIZeO1WSNPJKBmU2PKtTBamF2jcCfSSJplTs7K7AQv/7sWCD8ENXNoPg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(396003)(39850400004)(366004)(376002)(346002)(33430700001)(86362001)(6666004)(107886003)(8886007)(1076003)(6512007)(6486002)(66574012)(36756003)(5660300002)(2906002)(66476007)(6506007)(16526019)(186003)(52116002)(66946007)(66556008)(54906003)(2616005)(4326008)(8936002)(8676002)(316002)(33440700001)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: I4+zS1QYWZB+VTgBCAv2GA+dJeMROXNC3rUi8qVVTbM7skaaMt0qV3j5vJQZYPss/zvGt16CcRhulZ6iv4PJPBYRRO+pifNn7iIShGxQ0yb9tcVNCy5VwCAh4czs/6Gy4SUKxYmUgaQrjqo0jBhaPxEcOWpNQMj2L4CvRA9UUfkAYvHng4gFAjfn1+csquvr1/k7JUL1Pvzp046DtGaEiDfR48n0XdAKsVb6Zz70ryccYFUBZHJkveDaI4najpbV/w8lDoGL+gDqap46hTXOlGNmTt4jlsz//xIHn1gsBem47rQ81q5t5oc5Kosdv0gxTfTUKzaDNaFI0U6sNpas3g7NlaULkKccq8sSOl6SmYTn7+OCdK3jJK0nfpLJNDgKtEoqYQ9bukZ9/4X2sf0ymSdbscRqsQ0IPcnufKNbCUSPiMWuKqk2xapfjwk8INLRykC4a33rYdb2OGK9NE1rj3Mn4zptlJZkx+sJ24IeMxw33kxaal7qJ4swksZE4GzP0YcajRf1yXvafu5NNxKEpuDc1rrAq6LRbV81rIcGWL+pyOWqd3BRGF/R6qJOhaLfFVzdNQ9Qmxr8+YErT9DNXOKWzpb/T00Tu5Ep2rB0xqD+GYIiQKpZnJJHPXs+1IATnhWIPGp+1pZLOBU2yWiC952Kg4Xln+sW04RwLOi+qQmSE/PdcuOoVrie9At3PCX8NGoh64E4hOjttQB9uKUZvneI9T4erdXNmukv84/koMhLYAXvKG1lBx9RcFU2A7rhyXd5ZQaOjq9C7boKbdB8baWeAtdjGbL2fZ3xmxeWiOSp78hCpy8L/Oe1LLgmd7SbSlt2b/oxwpLp/GH0ELtzNUAYSjoRoJ85cIMemo5Z/yE=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcd27bac-09f5-4129-ba2d-08d7f0f133c1
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2020 12:38:24.6181
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cn3lY4Ul+kogQxEYLoEsyfeSDJm0VTWLDVBFGmKl/mfnQP7+W8leBkqCPaYRANhYOxl6wStid8axk9T5canVqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1824
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKQ3Vy
cmVudGx5LCB0aGUgU1BJIGltcGxlbWVudGF0aW9uIHVzZSBhIHdvcmtxdWV1ZSB0byBhY2tub3ds
ZWRnZSBJUlEKd2hpbGUgdGhlIFNESU8tT09CIGltcGxlbWVudGF0aW9uIHVzZSBhIHRocmVhZGVk
IElSUS4KClRoZSB0aHJlYWRlZCBhbHNvIG9mZmVycyB0aGUgYWR2YW50YWdlIHRvIGFsbG93IGxl
dmVsIHRyaWdnZXJlZCBJUlFzLgoKVW5pZm9ybWl6ZSB0aGUgY29kZSBhbmQgdXNlIHRocmVhZGVk
IElSUSBpbiBib3RoIGNhc2UuIFRoZXJlZm9yZSwgcHJlZmVyCmxldmVsIHRyaWdnZXJlZCBJUlFz
IGlmIHRoZSB1c2VyIGRvZXMgbm90IHNwZWNpZnkgaXQgaW4gdGhlIERULgoKU2lnbmVkLW9mZi1i
eTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRy
aXZlcnMvc3RhZ2luZy93ZngvYnVzX3NwaS5jIHwgMzQgKysrKysrKysrKysrLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDEyIGluc2VydGlvbnMoKyksIDIyIGRlbGV0aW9u
cygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvYnVzX3NwaS5jIGIvZHJpdmVy
cy9zdGFnaW5nL3dmeC9idXNfc3BpLmMKaW5kZXggMDNmOTVlNjVkMmY5Li4wMDYxM2QwNDZjM2Yg
MTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvYnVzX3NwaS5jCisrKyBiL2RyaXZlcnMv
c3RhZ2luZy93ZngvYnVzX3NwaS5jCkBAIC0zOSw3ICszOSw2IEBAIHN0cnVjdCB3Znhfc3BpX3By
aXYgewogCXN0cnVjdCBzcGlfZGV2aWNlICpmdW5jOwogCXN0cnVjdCB3ZnhfZGV2ICpjb3JlOwog
CXN0cnVjdCBncGlvX2Rlc2MgKmdwaW9fcmVzZXQ7Ci0Jc3RydWN0IHdvcmtfc3RydWN0IHJlcXVl
c3Rfcng7CiAJYm9vbCBuZWVkX3N3YWI7CiB9OwogCkBAIC0xNDAsMjEgKzEzOSwyMSBAQCBzdGF0
aWMgaXJxcmV0dXJuX3Qgd2Z4X3NwaV9pcnFfaGFuZGxlcihpbnQgaXJxLCB2b2lkICpwcml2KQog
ewogCXN0cnVjdCB3Znhfc3BpX3ByaXYgKmJ1cyA9IHByaXY7CiAKLQlxdWV1ZV93b3JrKHN5c3Rl
bV9oaWdocHJpX3dxLCAmYnVzLT5yZXF1ZXN0X3J4KTsKLQlyZXR1cm4gSVJRX0hBTkRMRUQ7Ci19
Ci0KLXN0YXRpYyB2b2lkIHdmeF9zcGlfcmVxdWVzdF9yeChzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndv
cmspCi17Ci0Jc3RydWN0IHdmeF9zcGlfcHJpdiAqYnVzID0KLQkJY29udGFpbmVyX29mKHdvcmss
IHN0cnVjdCB3Znhfc3BpX3ByaXYsIHJlcXVlc3RfcngpOwotCiAJd2Z4X2JoX3JlcXVlc3Rfcngo
YnVzLT5jb3JlKTsKKwlyZXR1cm4gSVJRX0hBTkRMRUQ7CiB9CiAKLXN0YXRpYyB2b2lkIHdmeF9m
bHVzaF9pcnFfd29yayh2b2lkICp3KQorc3RhdGljIGludCB3Znhfc3BpX2lycV9zdWJzY3JpYmUo
c3RydWN0IHdmeF9zcGlfcHJpdiAqYnVzKQogewotCWZsdXNoX3dvcmsodyk7CisJdTMyIGZsYWdz
OworCisJZmxhZ3MgPSBpcnFfZ2V0X3RyaWdnZXJfdHlwZShidXMtPmZ1bmMtPmlycSk7CisJaWYg
KCFmbGFncykKKwkJZmxhZ3MgPSBJUlFGX1RSSUdHRVJfSElHSDsKKwlmbGFncyB8PSBJUlFGX09O
RVNIT1Q7CisJcmV0dXJuIGRldm1fcmVxdWVzdF90aHJlYWRlZF9pcnEoJmJ1cy0+ZnVuYy0+ZGV2
LCBidXMtPmZ1bmMtPmlycSwgTlVMTCwKKwkJCQkJIHdmeF9zcGlfaXJxX2hhbmRsZXIsIElSUUZf
T05FU0hPVCwKKwkJCQkJICJ3ZngiLCBidXMpOwogfQogCiBzdGF0aWMgc2l6ZV90IHdmeF9zcGlf
YWxpZ25fc2l6ZSh2b2lkICpwcml2LCBzaXplX3Qgc2l6ZSkKQEAgLTIxMiwyMSArMjExLDEyIEBA
IHN0YXRpYyBpbnQgd2Z4X3NwaV9wcm9iZShzdHJ1Y3Qgc3BpX2RldmljZSAqZnVuYykKIAkJdXNs
ZWVwX3JhbmdlKDIwMDAsIDI1MDApOwogCX0KIAotCUlOSVRfV09SSygmYnVzLT5yZXF1ZXN0X3J4
LCB3Znhfc3BpX3JlcXVlc3RfcngpOwogCWJ1cy0+Y29yZSA9IHdmeF9pbml0X2NvbW1vbigmZnVu
Yy0+ZGV2LCAmd2Z4X3NwaV9wZGF0YSwKIAkJCQkgICAgJndmeF9zcGlfaHdidXNfb3BzLCBidXMp
OwogCWlmICghYnVzLT5jb3JlKQogCQlyZXR1cm4gLUVJTzsKIAotCXJldCA9IGRldm1fYWRkX2Fj
dGlvbl9vcl9yZXNldCgmZnVuYy0+ZGV2LCB3ZnhfZmx1c2hfaXJxX3dvcmssCi0JCQkJICAgICAg
ICZidXMtPnJlcXVlc3RfcngpOwotCWlmIChyZXQpCi0JCXJldHVybiByZXQ7Ci0KLQlyZXQgPSBk
ZXZtX3JlcXVlc3RfaXJxKCZmdW5jLT5kZXYsIGZ1bmMtPmlycSwgd2Z4X3NwaV9pcnFfaGFuZGxl
ciwKLQkJCSAgICAgICBJUlFGX1RSSUdHRVJfUklTSU5HLCAid2Z4IiwgYnVzKTsKLQlpZiAocmV0
KQotCQlyZXR1cm4gcmV0OworCXdmeF9zcGlfaXJxX3N1YnNjcmliZShidXMpOwogCiAJcmV0dXJu
IHdmeF9wcm9iZShidXMtPmNvcmUpOwogfQotLSAKMi4yNi4xCgo=
