Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC9F19AA08
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 13:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732408AbgDALFH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 07:05:07 -0400
Received: from mail-bn7nam10on2067.outbound.protection.outlook.com ([40.107.92.67]:6024
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732342AbgDALFD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Apr 2020 07:05:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kqwDvwWpu9EOyjjL45spTvaufqYvVAEdMRDKfq4E0g9JteIy6liea/orSsOn03zobvFBCLiWBFYqSuEjwTyDMhrKIEWiWRG+MCi15ocJKSumFMYpFnUN8DMDS/uEiOzqxkkTLzXbaFSQese2OXRvHf8GFVju7muwpx4810Pcfyy+aK88tCh4P+BOpDZhsMkYAeVk7e1mJZ3HcSw2ng7FbNJLl7pBB5Z+tlAvJQhhvaOlSLRCM+DwoU69LTZiipQF2kVEXAzhooxDC9OJrzMdhcC/Y+1xRLypxG2xuWogOO1xAzQtXaHGD1PLYR+W4oeAe2d3g3VD2wRmVf/G0tLD8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g9coPk8RKrRy4Cc4Jt799tpxHC3TTIwZMKSK8VkA+ZA=;
 b=gDw9bdur37DNPZK1kUDsoq/8FZOa0/GpjNT1OsaxWdBTpeidh39FbsChzuMiz/kOTIWPKt/uquVw+d8kVapYlBP8g93qKFArAQgD8juy2DUnW1Cg3qFO3mDOcUT5DdNrsQI98tT+QFTEDyi8Df5ZkIvOHmls+KJaJWwNwd7I7+u60GqrNR9aEnEejU9xXltnBZwJT5ObKmv1UBjL6r6/Lxrc12QsAx57GDM+VWeMLqNaY+w8ynbBY+lh7k8Irgw+Z/+/hFx2yDpA454XX85udryJ5TNDPhrF/aa1LHirs5m0MOpRPyPC6++J62YG6FjK96TNmRhgL6SAmiLiEQXQ9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g9coPk8RKrRy4Cc4Jt799tpxHC3TTIwZMKSK8VkA+ZA=;
 b=a7Xk/QAoo3uua27vCJ/esbFjzIr38NBX07tgzT9s9l/fIncQPQ+9+6o+69QulQ2wDs4gtIjz/VN6/EE3sERSRFUZJ/Xy8uPt9822qwt0vFc52H8MF2TM9Ja0gbO1zxtQ6+vksbdBDkVUwOnhnk23vD2mv+tVoEKvgvbkX4al7V8=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
 by MN2PR11MB4285.namprd11.prod.outlook.com (2603:10b6:208:191::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20; Wed, 1 Apr
 2020 11:04:46 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3%7]) with mapi id 15.20.2856.019; Wed, 1 Apr 2020
 11:04:46 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 13/32] staging: wfx: drop argument tx_allowed_mask since it is constant now
Date:   Wed,  1 Apr 2020 13:03:46 +0200
Message-Id: <20200401110405.80282-14-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200401110405.80282-1-Jerome.Pouiller@silabs.com>
References: <20200401110405.80282-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SN4PR0501CA0156.namprd05.prod.outlook.com
 (2603:10b6:803:2c::34) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:1265:30ff:fefd:6e7f) by SN4PR0501CA0156.namprd05.prod.outlook.com (2603:10b6:803:2c::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.9 via Frontend Transport; Wed, 1 Apr 2020 11:04:44 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:2435:66a0:1265:30ff:fefd:6e7f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cdae392a-cdbe-41ba-ff2e-08d7d62c7d07
X-MS-TrafficTypeDiagnostic: MN2PR11MB4285:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR11MB4285514956E00EFB8D59B20E93C90@MN2PR11MB4285.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-Forefront-PRVS: 03607C04F0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4063.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(136003)(366004)(346002)(376002)(39850400004)(396003)(7696005)(8676002)(1076003)(16526019)(186003)(5660300002)(86362001)(4326008)(66574012)(52116002)(478600001)(66946007)(66476007)(54906003)(36756003)(8936002)(316002)(81156014)(6486002)(2906002)(66556008)(107886003)(81166006)(2616005);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D9YcBb/cPXoCz8WKacl2zAxaW+wS9bD/FVyieYLC5D9p9BqDo43hpxnzAQ7YV6eZSjY7UmwuG/PWcjHxbabr7Bo++X4rpPcD4PXnRnhJiHjHMjiyMPaG0fL3QvczUet1gDty3fgWFc3UnLZtLWyj6P1okPS28wogo/6U7aKgZvust0CVLiWFsDl6m8j2YQVEE9XNq/EeiAqViXU/LzHPUo8xXxS8AhZLhQMzRqJ5g4R3HsKdzZazNQsFN4DOxQgWe73vHq2ZUFnzfwoXY5psQgdxa1jtUq1FFgh8Le8LFC9NMuoaKW+XOM0w2PnwvDw+QWIu+r1M6au7OL4gyAJdbCUKFHvdrdKm+YjtluIhi8RZOSrQ0EcHATtTWXKleN4Ad3e3N/N4TaqJEzLXxotYkHCnlfdxjiM2mEmw9DCiaYceMBbUGHxpjGrvgupc1CoW
X-MS-Exchange-AntiSpam-MessageData: o4/B18IYZrKVQshBLlqeZ/bseWHsPBiBP22IpK6rRD5KHkjLXTM+tvwFIJ16VuxmgjtQudp5iBzXMIJJ5bzD5d8TWKBr+DfXr7J89w2shYsbKfOUKpw7j0Df4zZ4euiVa1Gx7JFr2YxiIanPpMUbBYMHnDkJlU6rLRsNhalfqsakZgFcZs5S6//f6DGDtOhGflR8wy/DXmHrXIXTbB3XRQ==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdae392a-cdbe-41ba-ff2e-08d7d62c7d07
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2020 11:04:46.3184
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pyU8L/9m0q9tiZqwj/IaefHJTATMIVCmyCS6ysC5CnA5wMe5CtKNSRbug+FpPZRzwbHRW5u4KSnsq5DqkLIzHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4285
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKRm9s
bG93aW5nIHRoZSByZW1vdmUgb2YgYXNsZWVwX21hc2ssIHRoZSB0eF9hbGxvd2VkX21hc2sgYXJn
dW1lbnQgcGFzc2VkCnRvIHZhcmlvdXMgZnVuY3Rpb25zIGlzIG5vdyBhbHdheXMgdGhlIHNhbWUu
IERyb3AgdGhpcyBhcmd1bWVudCBhbmQKc2ltcGxpZnkgdGhlIGNvZGUuCgpTaWduZWQtb2ZmLWJ5
OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJp
dmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5jIHwgNDggKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5oIHwgIDIgKy0KIDIgZmlsZXMg
Y2hhbmdlZCwgMTIgaW5zZXJ0aW9ucygrKSwgMzggZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5j
CmluZGV4IGU2NmRlYmQ2MGUzZi4uY2VjZjlhYTdiM2NhIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0
YWdpbmcvd2Z4L3F1ZXVlLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5jCkBAIC0x
NDQsMjIgKzE0NCwxNSBAQCB2b2lkIHdmeF90eF9xdWV1ZXNfZGVpbml0KHN0cnVjdCB3ZnhfZGV2
ICp3ZGV2KQogCXdmeF90eF9xdWV1ZXNfY2xlYXIod2Rldik7CiB9CiAKLWludCB3ZnhfdHhfcXVl
dWVfZ2V0X251bV9xdWV1ZWQoc3RydWN0IHdmeF9xdWV1ZSAqcXVldWUsIHUzMiBsaW5rX2lkX21h
cCkKK2ludCB3ZnhfdHhfcXVldWVfZ2V0X251bV9xdWV1ZWQoc3RydWN0IHdmeF9xdWV1ZSAqcXVl
dWUpCiB7CiAJaW50IHJldCwgaTsKIAotCWlmICghbGlua19pZF9tYXApCi0JCXJldHVybiAwOwot
CisJcmV0ID0gMDsKIAlzcGluX2xvY2tfYmgoJnF1ZXVlLT5xdWV1ZS5sb2NrKTsKLQlpZiAobGlu
a19pZF9tYXAgPT0gKHUzMiktMSkgewotCQlyZXQgPSBza2JfcXVldWVfbGVuKCZxdWV1ZS0+cXVl
dWUpOwotCX0gZWxzZSB7Ci0JCXJldCA9IDA7Ci0JCWZvciAoaSA9IDA7IGkgPCBBUlJBWV9TSVpF
KHF1ZXVlLT5saW5rX21hcF9jYWNoZSk7IGkrKykKLQkJCWlmIChsaW5rX2lkX21hcCAmIEJJVChp
KSkKLQkJCQlyZXQgKz0gcXVldWUtPmxpbmtfbWFwX2NhY2hlW2ldOwotCX0KKwlmb3IgKGkgPSAw
OyBpIDwgQVJSQVlfU0laRShxdWV1ZS0+bGlua19tYXBfY2FjaGUpOyBpKyspCisJCWlmIChpICE9
IFdGWF9MSU5LX0lEX0FGVEVSX0RUSU0pCisJCQlyZXQgKz0gcXVldWUtPmxpbmtfbWFwX2NhY2hl
W2ldOwogCXNwaW5fdW5sb2NrX2JoKCZxdWV1ZS0+cXVldWUubG9jayk7CiAJcmV0dXJuIHJldDsK
IH0KQEAgLTM1NCw3ICszNDcsNyBAQCBzdGF0aWMgYm9vbCB3ZnhfaGFuZGxlX3R4X2RhdGEoc3Ry
dWN0IHdmeF9kZXYgKndkZXYsIHN0cnVjdCBza19idWZmICpza2IpCiAJfQogfQogCi1zdGF0aWMg
aW50IHdmeF9nZXRfcHJpb19xdWV1ZShzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgdTMyIHR4X2FsbG93
ZWRfbWFzaykKK3N0YXRpYyBzdHJ1Y3Qgd2Z4X3F1ZXVlICp3ZnhfdHhfcXVldWVfbWFza19nZXQo
c3RydWN0IHdmeF92aWYgKnd2aWYpCiB7CiAJY29uc3Qgc3RydWN0IGllZWU4MDIxMV90eF9xdWV1
ZV9wYXJhbXMgKmVkY2E7CiAJdW5zaWduZWQgaW50IHNjb3JlLCBiZXN0ID0gLTE7CkBAIC0zNjYs
OCArMzU5LDcgQEAgc3RhdGljIGludCB3ZnhfZ2V0X3ByaW9fcXVldWUoc3RydWN0IHdmeF92aWYg
Knd2aWYsIHUzMiB0eF9hbGxvd2VkX21hc2spCiAJCWludCBxdWV1ZWQ7CiAKIAkJZWRjYSA9ICZ3
dmlmLT5lZGNhX3BhcmFtc1tpXTsKLQkJcXVldWVkID0gd2Z4X3R4X3F1ZXVlX2dldF9udW1fcXVl
dWVkKCZ3dmlmLT53ZGV2LT50eF9xdWV1ZVtpXSwKLQkJCQl0eF9hbGxvd2VkX21hc2spOworCQlx
dWV1ZWQgPSB3ZnhfdHhfcXVldWVfZ2V0X251bV9xdWV1ZWQoJnd2aWYtPndkZXYtPnR4X3F1ZXVl
W2ldKTsKIAkJaWYgKCFxdWV1ZWQpCiAJCQljb250aW51ZTsKIAkJc2NvcmUgPSAoKGVkY2EtPmFp
ZnMgKyBlZGNhLT5jd19taW4pIDw8IDE2KSArCkBAIC0zNzksMjMgKzM3MSw5IEBAIHN0YXRpYyBp
bnQgd2Z4X2dldF9wcmlvX3F1ZXVlKHN0cnVjdCB3ZnhfdmlmICp3dmlmLCB1MzIgdHhfYWxsb3dl
ZF9tYXNrKQogCQl9CiAJfQogCi0JcmV0dXJuIHdpbm5lcjsKLX0KLQotc3RhdGljIHN0cnVjdCB3
ZnhfcXVldWUgKndmeF90eF9xdWV1ZV9tYXNrX2dldChzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwKLQkJ
CQkJICAgICAgIHUzMiAqdHhfYWxsb3dlZF9tYXNrX3ApCi17Ci0JaW50IGlkeDsKLQl1MzIgdHhf
YWxsb3dlZF9tYXNrOwotCi0JdHhfYWxsb3dlZF9tYXNrID0gQklUKFdGWF9MSU5LX0lEX01BWCkg
LSAxOwotCXR4X2FsbG93ZWRfbWFzayAmPSB+QklUKFdGWF9MSU5LX0lEX0FGVEVSX0RUSU0pOwot
CWlkeCA9IHdmeF9nZXRfcHJpb19xdWV1ZSh3dmlmLCB0eF9hbGxvd2VkX21hc2spOwotCWlmIChp
ZHggPCAwKQorCWlmICh3aW5uZXIgPCAwKQogCQlyZXR1cm4gTlVMTDsKLQotCSp0eF9hbGxvd2Vk
X21hc2tfcCA9IHR4X2FsbG93ZWRfbWFzazsKLQlyZXR1cm4gJnd2aWYtPndkZXYtPnR4X3F1ZXVl
W2lkeF07CisJcmV0dXJuICZ3dmlmLT53ZGV2LT50eF9xdWV1ZVt3aW5uZXJdOwogfQogCiBzdHJ1
Y3QgaGlmX21zZyAqd2Z4X3R4X3F1ZXVlc19nZXRfYWZ0ZXJfZHRpbShzdHJ1Y3Qgd2Z4X3ZpZiAq
d3ZpZikKQEAgLTQyNCw4ICs0MDIsNiBAQCBzdHJ1Y3QgaGlmX21zZyAqd2Z4X3R4X3F1ZXVlc19n
ZXQoc3RydWN0IHdmeF9kZXYgKndkZXYpCiAJc3RydWN0IGhpZl9tc2cgKmhpZiA9IE5VTEw7CiAJ
c3RydWN0IHdmeF9xdWV1ZSAqcXVldWUgPSBOVUxMOwogCXN0cnVjdCB3ZnhfcXVldWUgKnZpZl9x
dWV1ZSA9IE5VTEw7Ci0JdTMyIHR4X2FsbG93ZWRfbWFzayA9IDA7Ci0JdTMyIHZpZl90eF9hbGxv
d2VkX21hc2sgPSAwOwogCXN0cnVjdCB3ZnhfdmlmICp3dmlmOwogCWludCBpOwogCkBAIC00NTks
MTIgKzQzNSwxMCBAQCBzdHJ1Y3QgaGlmX21zZyAqd2Z4X3R4X3F1ZXVlc19nZXQoc3RydWN0IHdm
eF9kZXYgKndkZXYpCiAKIAkJd3ZpZiA9IE5VTEw7CiAJCXdoaWxlICgod3ZpZiA9IHd2aWZfaXRl
cmF0ZSh3ZGV2LCB3dmlmKSkgIT0gTlVMTCkgewotCQkJdmlmX3F1ZXVlID0gd2Z4X3R4X3F1ZXVl
X21hc2tfZ2V0KHd2aWYsCi0JCQkJCQkJICAmdmlmX3R4X2FsbG93ZWRfbWFzayk7CisJCQl2aWZf
cXVldWUgPSB3ZnhfdHhfcXVldWVfbWFza19nZXQod3ZpZik7CiAJCQlpZiAodmlmX3F1ZXVlKSB7
CiAJCQkJaWYgKHF1ZXVlICYmIHF1ZXVlICE9IHZpZl9xdWV1ZSkKIAkJCQkJZGV2X2luZm8od2Rl
di0+ZGV2LCAidmlmcyBkaXNhZ3JlZSBhYm91dCBxdWV1ZSBwcmlvcml0eVxuIik7Ci0JCQkJdHhf
YWxsb3dlZF9tYXNrIHw9IHZpZl90eF9hbGxvd2VkX21hc2s7CiAJCQkJcXVldWUgPSB2aWZfcXVl
dWU7CiAJCQkJcmV0ID0gMDsKIAkJCX0KQEAgLTQ3NSw3ICs0NDksNyBAQCBzdHJ1Y3QgaGlmX21z
ZyAqd2Z4X3R4X3F1ZXVlc19nZXQoc3RydWN0IHdmeF9kZXYgKndkZXYpCiAKIAkJcXVldWVfbnVt
ID0gcXVldWUgLSB3ZGV2LT50eF9xdWV1ZTsKIAotCQlza2IgPSB3ZnhfdHhfcXVldWVfZ2V0KHdk
ZXYsIHF1ZXVlLCB0eF9hbGxvd2VkX21hc2spOworCQlza2IgPSB3ZnhfdHhfcXVldWVfZ2V0KHdk
ZXYsIHF1ZXVlLCB+QklUKFdGWF9MSU5LX0lEX0FGVEVSX0RUSU0pKTsKIAkJaWYgKCFza2IpCiAJ
CQljb250aW51ZTsKIApkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5oIGIv
ZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5oCmluZGV4IDVhNWFhMzhkYmIyZi4uNThkYTIxNmQ0
N2RkIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3F1ZXVlLmgKKysrIGIvZHJpdmVy
cy9zdGFnaW5nL3dmeC9xdWV1ZS5oCkBAIC00Nyw3ICs0Nyw3IEBAIHN0cnVjdCBoaWZfbXNnICp3
ZnhfdHhfcXVldWVzX2dldF9hZnRlcl9kdGltKHN0cnVjdCB3ZnhfdmlmICp3dmlmKTsKIAogdm9p
ZCB3ZnhfdHhfcXVldWVfcHV0KHN0cnVjdCB3ZnhfZGV2ICp3ZGV2LCBzdHJ1Y3Qgd2Z4X3F1ZXVl
ICpxdWV1ZSwKIAkJICAgICAgc3RydWN0IHNrX2J1ZmYgKnNrYik7Ci1pbnQgd2Z4X3R4X3F1ZXVl
X2dldF9udW1fcXVldWVkKHN0cnVjdCB3ZnhfcXVldWUgKnF1ZXVlLCB1MzIgbGlua19pZF9tYXAp
OworaW50IHdmeF90eF9xdWV1ZV9nZXRfbnVtX3F1ZXVlZChzdHJ1Y3Qgd2Z4X3F1ZXVlICpxdWV1
ZSk7CiAKIHN0cnVjdCBza19idWZmICp3ZnhfcGVuZGluZ19nZXQoc3RydWN0IHdmeF9kZXYgKndk
ZXYsIHUzMiBwYWNrZXRfaWQpOwogaW50IHdmeF9wZW5kaW5nX3JlbW92ZShzdHJ1Y3Qgd2Z4X2Rl
diAqd2Rldiwgc3RydWN0IHNrX2J1ZmYgKnNrYik7Ci0tIAoyLjI1LjEKCg==
