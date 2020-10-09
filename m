Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51664288FB6
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 19:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390116AbgJIRNl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 13:13:41 -0400
Received: from mail-eopbgr760074.outbound.protection.outlook.com ([40.107.76.74]:48911
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732488AbgJIRNd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 13:13:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ipMie+1kAjsJKmk5z5eQ8/ZI1BbbSTuYHGyTmB43gh1quCD8nT2icBpX5RYzH/k85abx/zOd9MicKwHYZWC8FK/Lgeb01I0Oxxo94zOkO0Bg6QmqDyep38O0IQntUg7LbMQf2ToRl7lIdaqal2L9E4naUUOiXIWDDDakznQVZj7FNsQDT+79Bm2/xWAACI2OX+cX5MhlHL5gR3zHE5l+K/Ggf82vKCVKSaJojfLmeAbnlbNPomw8ZxVgwnQeLQqEegS6ZSVMPgiHA01jOaXptu/6w4hnV4kZDr5jk53pkpQoSyAweg0RohLxGx/icKt7MjYIUqXdoBt+LgS9I0zXdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uQt70Y/LPjZH5xiGV8CtR5xvL0XVIYWyKXWcFkSGMBg=;
 b=JpkW5B+AqtSEN2IP+yJ2BoEQLFKy4aJBMKD3Teq69p6rNUn7eteq9RCpv7wra8xSpnw2PxbIN+byDkAwZu8xr5TmTorDj+p+6mY3lPC8efQUkE+dOpCwXqX2kT7bxREnwuiJuRQDDc15zo+lhkWgAkWvoIzZrVzn8ScWOvZCIwfWQK2xzOqYZhq1wfdEQqitZGg9bWxMYonrY6K50Apuiz4E+3OGd1pgloKHzeWWHP8URELyhCirpEcEgOr38yU7Puh3V4DLizdpdhXHEma3MbTEPLJwyuwf1XfLxzD4+PyFxUgqwsHpGO1f+purnEhluk6QUdnlxUK/Bz/OMrUrRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uQt70Y/LPjZH5xiGV8CtR5xvL0XVIYWyKXWcFkSGMBg=;
 b=UlzW7vllx1MVMpA5P7GStxkGQwhAlzzojkPcO02EynKDd/tL5iHtxmakze3OLE+1dr5FuNR08sgETaIuwRiXhPOnMd8eoG3X1rnsCxIkH6I1kIYQGQgrrqsqojndWYWOkuJTPCIk9O5Ij+LUV87OTWAmhS2p68Pl6FW/gB1ROXo=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB3455.namprd11.prod.outlook.com (2603:10b6:805:bb::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.22; Fri, 9 Oct
 2020 17:13:28 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a%5]) with mapi id 15.20.3455.024; Fri, 9 Oct 2020
 17:13:27 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 3/8] staging: wfx: standardize the error when vif does not exist
Date:   Fri,  9 Oct 2020 19:13:02 +0200
Message-Id: <20201009171307.864608-4-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201009171307.864608-1-Jerome.Pouiller@silabs.com>
References: <20201009171307.864608-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Originating-IP: [82.67.86.106]
X-ClientProxiedBy: SA9PR10CA0004.namprd10.prod.outlook.com
 (2603:10b6:806:a7::9) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (82.67.86.106) by SA9PR10CA0004.namprd10.prod.outlook.com (2603:10b6:806:a7::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.24 via Frontend Transport; Fri, 9 Oct 2020 17:13:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 50745ac1-2daa-4cf9-3c3a-08d86c76a358
X-MS-TrafficTypeDiagnostic: SN6PR11MB3455:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB3455FF7F399DCC8927F61D0193080@SN6PR11MB3455.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1751;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0cTaCDFgiJbIJShhdTmWv44GEgOOebkTn/YiaukrcJ//KjPMErfv8fVtbfYf+iBut2OPkCzmuwTgpZLO42cqj2Tk50z9qUHdwstnOO2TtiRpPBoB1c5H8YDjVvYr17F6yeOXWjWmx4jA+ZkMhY0+pIvkScmGmF2kM+fCqx6KUpX34qX3fc/MlU4mgXlzdgZDK3I+OtQ1kekzGPqmBg+V1JsD+GYWr+wf94fhcHKsjjDM/UjyGMhAOAXwyq18QUEeyrFblHzfspkaS6eIFXPAkOqpfau0MsifBFjvDMxlJucKjXhntWw7/pMApXlYx9YMeqYbCkro8owbehHQG9EnqA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(376002)(39850400004)(396003)(136003)(8936002)(36756003)(54906003)(1076003)(316002)(52116002)(7696005)(2906002)(5660300002)(478600001)(66574015)(86362001)(4326008)(66946007)(66556008)(66476007)(6666004)(107886003)(26005)(16526019)(2616005)(83380400001)(186003)(8676002)(956004)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: +B5GaRfJ1OTE66YUAoc5mtllAer2DWFfJOdbnwR54vQKS9WdzcYc3Jlprj9mxZz0uQnujtNWDuIAjii+fYke/fjh2ghXkWTSvXtK4cwlLAXEH7EJegKruVorupVxlCHIQSOO+qIPy/7b8/tSSLT5kgDDAtWxl2+AnUkuIOERJISY3qryjwbU9zRWSN5x+8aMxT4o1FH0JimhW0Ihv3zYbdSJLdzQ7YN8jg6yGjLBgIgEcB8/LO8Qq0Natjsyts5kVVxEMt7B2WTmKsGDa5OTOZoUvmH52VGO4fljQAoVMq6spL45RRNi8hzVwsm4j80i1IBAnmVoUqVdSJlBeUjJlLLivTDTF8ABkcmNqi+8Hue9NWfGfDMzAkn1wRexZAiiXlMzkjF8u/78eJgxZWutm7jMPwZSKoQ+Qr1A6yYvVqc1x7qCeosCvi2jx4E0fT/Bzav3OJ1bvL5g5Tj08hwKccXsVKdfOfteMv1rm5ibyZ2BKd9lG6GU1NKCOoydw13xv7adgFf7w/Iq/ezwWrMvycV/NoXv16v3pKzsiGfXAvsHhdeloM9TP1NXBUs3WCM2FFzy+7RhoYy74ZvjhfgPXS/oMJ+k3MhCl2dhH+Bq8DsDf3UvvAWMS87C5sn1Ec/IkAJrTX7yzW620zbaLsLEgA==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50745ac1-2daa-4cf9-3c3a-08d86c76a358
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2020 17:13:27.8153
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hd3YAZXdDBfJwd6CJ75t+2yOv9DP6BgJ3EFNwd2QB324uE3tpGftLT01yrYe6cVFgsNPshMvKX6xbTxy+LlIRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3455
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU21h
dGNoIGNvbXBsYWluczoKCiAgIGRyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3J4LmM6MTc3IGhpZl9z
Y2FuX2NvbXBsZXRlX2luZGljYXRpb24oKSB3YXJuOiBwb3RlbnRpYWwgTlVMTCBwYXJhbWV0ZXIg
ZGVyZWZlcmVuY2UgJ3d2aWYnCiAgIGRyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jOjU3NiB3
ZnhfZmx1c2goKSB3YXJuOiBwb3RlbnRpYWwgTlVMTCBwYXJhbWV0ZXIgZGVyZWZlcmVuY2UgJ3d2
aWYnCgpJbmRlZWQsIGlmIHRoZSB2aWYgaWQgcmV0dXJuZWQgYnkgdGhlIGRldmljZSBkb2VzIG5v
dCBleGlzdCBhbnltb3JlLAp3ZGV2X3RvX3d2aWYoKSBjb3VsZCByZXR1cm4gTlVMTC4KCkluIGFk
ZCwgdGhlIGVycm9yIGlzIG5vdCBoYW5kbGVkIHVuaWZvcm1seSBpbiB0aGUgY29kZSwgc29tZXRp
bWUgYQpXQVJOKCkgaXMgZGlzcGxheWVkIGJ1dCBjb2RlIGNvbnRpbnVlLCBzb21ldGltZSBhIGRl
dl93YXJuKCkgaXMKZGlzcGxheWVkLCBzb21ldGltZSBpdCBpcyBqdXN0IG5vdCB0ZXN0ZWQsIC4u
LgoKVGhpcyBwYXRjaCBzdGFuZGFyZGl6ZSB0aGF0LgoKUmVwb3J0ZWQtYnk6IERhbiBDYXJwZW50
ZXIgPGRhbi5jYXJwZW50ZXJAb3JhY2xlLmNvbT4KU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91
aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93
ZngvZGF0YV90eC5jIHwgIDUgKysrKy0KIGRyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3J4LmMgIHwg
MzQgKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLQogZHJpdmVycy9zdGFnaW5nL3dm
eC9zdGEuYyAgICAgfCAgNCArKysrCiAzIGZpbGVzIGNoYW5nZWQsIDMyIGluc2VydGlvbnMoKyks
IDExIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90
eC5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmMKaW5kZXggYjRkNWRkM2QyZDIzLi44
ZGIwYmUwOGRhZjggMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jCisr
KyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jCkBAIC00MzEsNyArNDMxLDEwIEBAIHN0
YXRpYyB2b2lkIHdmeF9za2JfZHRvcihzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgc3RydWN0IHNrX2J1
ZmYgKnNrYikKIAkJCSAgICAgIHNpemVvZihzdHJ1Y3QgaGlmX3JlcV90eCkgKwogCQkJICAgICAg
cmVxLT5mY19vZmZzZXQ7CiAKLQlXQVJOX09OKCF3dmlmKTsKKwlpZiAoIXd2aWYpIHsKKwkJcHJf
d2FybigiJXM6IHZpZiBhc3NvY2lhdGVkIHdpdGggdGhlIHNrYiBkb2VzIG5vdCBleGlzdCBhbnlt
b3JlXG4iLCBfX2Z1bmNfXyk7CisJCXJldHVybjsKKwl9CiAJd2Z4X3R4X3BvbGljeV9wdXQod3Zp
ZiwgcmVxLT5yZXRyeV9wb2xpY3lfaW5kZXgpOwogCXNrYl9wdWxsKHNrYiwgb2Zmc2V0KTsKIAlp
ZWVlODAyMTFfdHhfc3RhdHVzX2lycXNhZmUod3ZpZi0+d2Rldi0+aHcsIHNrYik7CmRpZmYgLS1n
aXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9yeC5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9o
aWZfcnguYwppbmRleCBkNmRmYWIwOTRiMDMuLmNhMDk0NjdjYmEwNSAxMDA2NDQKLS0tIGEvZHJp
dmVycy9zdGFnaW5nL3dmeC9oaWZfcnguYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9y
eC5jCkBAIC0xMTAsOSArMTEwLDkgQEAgc3RhdGljIGludCBoaWZfcmVjZWl2ZV9pbmRpY2F0aW9u
KHN0cnVjdCB3ZnhfZGV2ICp3ZGV2LAogCWNvbnN0IHN0cnVjdCBoaWZfaW5kX3J4ICpib2R5ID0g
YnVmOwogCiAJaWYgKCF3dmlmKSB7Ci0JCWRldl93YXJuKHdkZXYtPmRldiwgImlnbm9yZSByeCBk
YXRhIGZvciBub24tZXhpc3RlbnQgdmlmICVkXG4iLAotCQkJIGhpZi0+aW50ZXJmYWNlKTsKLQkJ
cmV0dXJuIDA7CisJCWRldl93YXJuKHdkZXYtPmRldiwgIiVzOiBpZ25vcmUgcnggZGF0YSBmb3Ig
bm9uLWV4aXN0ZW50IHZpZiAlZFxuIiwKKwkJCSBfX2Z1bmNfXywgaGlmLT5pbnRlcmZhY2UpOwor
CQlyZXR1cm4gLUVJTzsKIAl9CiAJc2tiX3B1bGwoc2tiLCBzaXplb2Yoc3RydWN0IGhpZl9tc2cp
ICsgc2l6ZW9mKHN0cnVjdCBoaWZfaW5kX3J4KSk7CiAJd2Z4X3J4X2NiKHd2aWYsIGJvZHksIHNr
Yik7CkBAIC0xMjgsOCArMTI4LDggQEAgc3RhdGljIGludCBoaWZfZXZlbnRfaW5kaWNhdGlvbihz
dHJ1Y3Qgd2Z4X2RldiAqd2RldiwKIAlpbnQgdHlwZSA9IGxlMzJfdG9fY3B1KGJvZHktPmV2ZW50
X2lkKTsKIAogCWlmICghd3ZpZikgewotCQlkZXZfd2Fybih3ZGV2LT5kZXYsICJyZWNlaXZlZCBl
dmVudCBmb3Igbm9uLWV4aXN0ZW50IHZpZlxuIik7Ci0JCXJldHVybiAwOworCQlkZXZfd2Fybih3
ZGV2LT5kZXYsICIlczogcmVjZWl2ZWQgZXZlbnQgZm9yIG5vbi1leGlzdGVudCB2aWZcbiIsIF9f
ZnVuY19fKTsKKwkJcmV0dXJuIC1FSU87CiAJfQogCiAJc3dpdGNoICh0eXBlKSB7CkBAIC0xNjEs
NyArMTYxLDEwIEBAIHN0YXRpYyBpbnQgaGlmX3BtX21vZGVfY29tcGxldGVfaW5kaWNhdGlvbihz
dHJ1Y3Qgd2Z4X2RldiAqd2RldiwKIHsKIAlzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiA9IHdkZXZfdG9f
d3ZpZih3ZGV2LCBoaWYtPmludGVyZmFjZSk7CiAKLQlXQVJOX09OKCF3dmlmKTsKKwlpZiAoIXd2
aWYpIHsKKwkJZGV2X3dhcm4od2Rldi0+ZGV2LCAiJXM6IHJlY2VpdmVkIGV2ZW50IGZvciBub24t
ZXhpc3RlbnQgdmlmXG4iLCBfX2Z1bmNfXyk7CisJCXJldHVybiAtRUlPOworCX0KIAljb21wbGV0
ZSgmd3ZpZi0+c2V0X3BtX21vZGVfY29tcGxldGUpOwogCiAJcmV0dXJuIDA7CkBAIC0xNzMsNyAr
MTc2LDExIEBAIHN0YXRpYyBpbnQgaGlmX3NjYW5fY29tcGxldGVfaW5kaWNhdGlvbihzdHJ1Y3Qg
d2Z4X2RldiAqd2RldiwKIHsKIAlzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiA9IHdkZXZfdG9fd3ZpZih3
ZGV2LCBoaWYtPmludGVyZmFjZSk7CiAKLQlXQVJOX09OKCF3dmlmKTsKKwlpZiAoIXd2aWYpIHsK
KwkJZGV2X3dhcm4od2Rldi0+ZGV2LCAiJXM6IHJlY2VpdmVkIGV2ZW50IGZvciBub24tZXhpc3Rl
bnQgdmlmXG4iLCBfX2Z1bmNfXyk7CisJCXJldHVybiAtRUlPOworCX0KKwogCXdmeF9zY2FuX2Nv
bXBsZXRlKHd2aWYpOwogCiAJcmV0dXJuIDA7CkBAIC0xODUsNyArMTkyLDEwIEBAIHN0YXRpYyBp
bnQgaGlmX2pvaW5fY29tcGxldGVfaW5kaWNhdGlvbihzdHJ1Y3Qgd2Z4X2RldiAqd2RldiwKIHsK
IAlzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiA9IHdkZXZfdG9fd3ZpZih3ZGV2LCBoaWYtPmludGVyZmFj
ZSk7CiAKLQlXQVJOX09OKCF3dmlmKTsKKwlpZiAoIXd2aWYpIHsKKwkJZGV2X3dhcm4od2Rldi0+
ZGV2LCAiJXM6IHJlY2VpdmVkIGV2ZW50IGZvciBub24tZXhpc3RlbnQgdmlmXG4iLCBfX2Z1bmNf
Xyk7CisJCXJldHVybiAtRUlPOworCX0KIAlkZXZfd2Fybih3ZGV2LT5kZXYsICJ1bmF0dGVuZGVk
IEpvaW5Db21wbGV0ZUluZFxuIik7CiAKIAlyZXR1cm4gMDsKQEAgLTE5NSwxMSArMjA1LDE1IEBA
IHN0YXRpYyBpbnQgaGlmX3N1c3BlbmRfcmVzdW1lX2luZGljYXRpb24oc3RydWN0IHdmeF9kZXYg
KndkZXYsCiAJCQkJCSBjb25zdCBzdHJ1Y3QgaGlmX21zZyAqaGlmLAogCQkJCQkgY29uc3Qgdm9p
ZCAqYnVmKQogewotCXN0cnVjdCB3ZnhfdmlmICp3dmlmID0gd2Rldl90b193dmlmKHdkZXYsIGhp
Zi0+aW50ZXJmYWNlKTsKIAljb25zdCBzdHJ1Y3QgaGlmX2luZF9zdXNwZW5kX3Jlc3VtZV90eCAq
Ym9keSA9IGJ1ZjsKKwlzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZjsKIAogCWlmIChib2R5LT5iY19tY19v
bmx5KSB7Ci0JCVdBUk5fT04oIXd2aWYpOworCQl3dmlmID0gd2Rldl90b193dmlmKHdkZXYsIGhp
Zi0+aW50ZXJmYWNlKTsKKwkJaWYgKCF3dmlmKSB7CisJCQlkZXZfd2Fybih3ZGV2LT5kZXYsICIl
czogcmVjZWl2ZWQgZXZlbnQgZm9yIG5vbi1leGlzdGVudCB2aWZcbiIsIF9fZnVuY19fKTsKKwkJ
CXJldHVybiAtRUlPOworCQl9CiAJCWlmIChib2R5LT5yZXN1bWUpCiAJCQl3Znhfc3VzcGVuZF9y
ZXN1bWVfbWMod3ZpZiwgU1RBX05PVElGWV9BV0FLRSk7CiAJCWVsc2UKZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCmluZGV4
IGEyNDZmMGQxZDZlOS4uMjMyMGE4MWVhZTBiIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcv
d2Z4L3N0YS5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKQEAgLTYxOSw2ICs2MTks
MTAgQEAgaW50IHdmeF9zZXRfdGltKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LCBzdHJ1Y3QgaWVl
ZTgwMjExX3N0YSAqc3RhLCBib29sIHNldCkKIAlzdHJ1Y3Qgd2Z4X3N0YV9wcml2ICpzdGFfZGV2
ID0gKHN0cnVjdCB3Znhfc3RhX3ByaXYgKikmc3RhLT5kcnZfcHJpdjsKIAlzdHJ1Y3Qgd2Z4X3Zp
ZiAqd3ZpZiA9IHdkZXZfdG9fd3ZpZih3ZGV2LCBzdGFfZGV2LT52aWZfaWQpOwogCisJaWYgKCF3
dmlmKSB7CisJCWRldl93YXJuKHdkZXYtPmRldiwgIiVzOiByZWNlaXZlZCBldmVudCBmb3Igbm9u
LWV4aXN0ZW50IHZpZlxuIiwgX19mdW5jX18pOworCQlyZXR1cm4gLUVJTzsKKwl9CiAJc2NoZWR1
bGVfd29yaygmd3ZpZi0+dXBkYXRlX3RpbV93b3JrKTsKIAlyZXR1cm4gMDsKIH0KLS0gCjIuMjgu
MAoK
