Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA867210E7B
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 17:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731803AbgGAPIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 11:08:14 -0400
Received: from mail-bn8nam12on2056.outbound.protection.outlook.com ([40.107.237.56]:52640
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731343AbgGAPII (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 11:08:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dLtVOTIyxNjfZ97B5IDP1E8on7lY4OqCW04YfDR1iCWOJWODDnSjY5bgAmprZcDObnW2qcX/jyH6LTcxzScHVtn4d93aTREu3Fc02O+jJmBe4tTx8JRgV+FVMD/QaT+Vd45d/4ojwkcf1S/9QG0aUSahop7w8BWCki9ZurYOddyPfLLfIezSWO46RYZCak1FOEq8OIm8j2C0IfqxjOKS8lYeTVRlJiZem5e/PVAXXoGfFNvaVemCqnb0MVqB8h9KlYiB3ETFvyLK+qr3xH+FItIo/Vk9BgSz5lgHE4I/2CA3bfJHZbZHfaqVgMt4ReI4ox7Oj3Xb9HrWM1O2K68mHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aimN+AaiepU4T6Nj1hRXGIK/xOM4dQ1aepcJh7YyftI=;
 b=Z2qhlTLaP/LoVZ7kr1/1xHQl9aWnZQtRcqxe/J/a8RyNpZQlDwQqJUkXlSPNx0uiVaZI0NyK0BApJoW4m+nBdw4R4xVGMr1qVY7oF//v4drJ6eTEvt4eOlVD+l/hIc8DHWd//AWVLqaU6A92NRwcWxKgIS9Iu7g3e3uEXjCZiP1nxxilIhyMP+ekF3j0VlYxTXyZbXc0pZZkM2NBeGbEbJjfK0vR+UnZWN72GHZgIalXs2XTgldSTJxAtBbrzBPeGueL16dH8gP5uiu1tnOCYWvB2jSFX8eSNXJZ0Iq62VYNMWoQCmPEvJT/2IKPWxTkVa71ucVIhzoraJuicZHInQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aimN+AaiepU4T6Nj1hRXGIK/xOM4dQ1aepcJh7YyftI=;
 b=EiewfaC3tMrj6aWlCvQW5Adnz90T8b3Nj7OW6NHWyQUzjH8Ib22mFNV8yKtEhWp1tq959UQTN6FF3jjNW4SrKfXr0OIA1/RRHj9l6j+A6sCxr5QMHkzCFhs3CxMH4J4m48WJghDpQTpVzwwr7qAI+Yvw2qYWbBLDCm1lliZskGQ=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA0PR11MB4736.namprd11.prod.outlook.com (2603:10b6:806:9f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.22; Wed, 1 Jul
 2020 15:08:03 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::c504:2d66:a8f7:2336]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::c504:2d66:a8f7:2336%7]) with mapi id 15.20.3131.033; Wed, 1 Jul 2020
 15:08:03 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 02/13] staging: wfx: check the vif ID of the Tx confirmations
Date:   Wed,  1 Jul 2020 17:06:56 +0200
Message-Id: <20200701150707.222985-3-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200701150707.222985-1-Jerome.Pouiller@silabs.com>
References: <20200701150707.222985-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: DM5PR07CA0143.namprd07.prod.outlook.com
 (2603:10b6:3:13e::33) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by DM5PR07CA0143.namprd07.prod.outlook.com (2603:10b6:3:13e::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.21 via Frontend Transport; Wed, 1 Jul 2020 15:08:01 +0000
X-Mailer: git-send-email 2.27.0
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 77499cb5-5cf3-4a1d-4e23-08d81dd08cf4
X-MS-TrafficTypeDiagnostic: SA0PR11MB4736:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR11MB4736560B21DA822237BD7CB9936C0@SA0PR11MB4736.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 04519BA941
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vgPRTnkyouHPk4MH3/TrDiLzKM0ZOlM1noE9eDdZ3FcX4TZKB2XPfkpQq31u8RH7EzKAxUWRLt8bzhdPyHGGdM92tkXcN8D7tRfVgrJasaHr5MZ3kZoJG0LjmQ7i3YEFYo6WXhYnXiibKq2GDor0a5SQi6HTtpSEJ0RChmtF+tssDfFAz8qmDocNE5dWEzA6oC+bPMQ/7kJMwxnrPUe2yyv7gEj2oA//7KJqoyFzcvinG+K/bqFWpOfkqJfnBjOZm7cX0ft557YIc9wHbIQoE6JP/9HsiZizCAyOoRkGCynpQ6OqBuqqhQc9Smo1SObzHLpyoaCTSs/xUiXIp1rkgw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39850400004)(366004)(346002)(376002)(396003)(136003)(5660300002)(6486002)(86362001)(6666004)(66574015)(36756003)(2906002)(186003)(83380400001)(16526019)(8936002)(66556008)(66476007)(107886003)(4326008)(8676002)(2616005)(1076003)(478600001)(316002)(54906003)(66946007)(52116002)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: BR5Y/f71hKQ7+i+gIqQVGKi9zhoG5h5B2UmvB9h24Gg7rYg2ULj1mlQa5OW9jLOU/8qgltnjOBZEtickmPl4f64dskd5sklqgRib/RB6T7GNcCmYCRduB6uPCoq4djXlIThAx3+LM9OSaIAzK0J8O6NaK2yCeGmOztTjDtBu0eklpASMkeAigvg0naKvBz3+f33wuYUw+AWkPUmgp35npQE89QjBmlaC19DyqibAbRTHSY7ecktZhxCJZ+TBw8bMKEyXTDYTAq9wyrCAzJsWzhL99RCTktRlcNKW3Uv4yqvN7T5G5+YtYOLUFBceonQXbhi8r9jirPV4GJVcXDmZImF/PflgSsAm+Rpf7gQ8PtM7i7h+9kXYN6gAMy1jcPAihPf+shdTNO72N9zmfcFhN13EBRotyyU4dzSQUXL6KG7sDxkNXbi0SFuEFtvPATJGF/NEskwWyKRdT5OoSTIcBwZDj/7RZuDXRUB25lnzMKGCHo5EBhmegSFMw0C3WYKeKGc0zVHi9J6cBdtJ9NrMVVdaa0WVIKmVlPwgBLRFQUM=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77499cb5-5cf3-4a1d-4e23-08d81dd08cf4
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2020 15:08:03.0577
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JL65GMtsHQRajph+Be1S3+AWoo3JkoRaT+6DslkZKKWQDvZjoe1x93cLPC7ZdgsW7om/Ueoj0J2RKwwLpXdUAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4736
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKV2hl
biB0aGUgZHJpdmVyIGhhcyBzZW50IGEgZnJhbWUgb24gYSB2aXJ0dWFsIGludGVyZmFjZSAodmlm
KSwgaXQKZXhwZWN0cyB0byByZWNlaXZlIHRoZSBjb25maXJtYXRpb24gb24gdGhlIHNhbWUgdmlm
LgoKVGhpcyBwYXRjaCBhZGQgYSBjaGVjayBmb3IgdGhhdC4KClNpZ25lZC1vZmYtYnk6IErDqXLD
tG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0
YWdpbmcvd2Z4L3F1ZXVlLmMgfCA2ICsrKysrLQogMSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0aW9u
cygrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvcXVl
dWUuYyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvcXVldWUuYwppbmRleCA3ZWMzNjU5OGQ5YTgzLi42
MDY5MTQzMzY5ZjMwIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3F1ZXVlLmMKKysr
IGIvZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5jCkBAIC0xNDIsMTQgKzE0MiwxOCBAQCBzdHJ1
Y3Qgc2tfYnVmZiAqd2Z4X3BlbmRpbmdfZ2V0KHN0cnVjdCB3ZnhfdmlmICp3dmlmLCB1MzIgcGFj
a2V0X2lkKQogewogCXN0cnVjdCB3ZnhfcXVldWUgKnF1ZXVlOwogCXN0cnVjdCBoaWZfcmVxX3R4
ICpyZXE7CisJc3RydWN0IGhpZl9tc2cgKmhpZjsKIAlzdHJ1Y3Qgc2tfYnVmZiAqc2tiOwogCiAJ
c3Bpbl9sb2NrX2JoKCZ3dmlmLT53ZGV2LT50eF9wZW5kaW5nLmxvY2spOwogCXNrYl9xdWV1ZV93
YWxrKCZ3dmlmLT53ZGV2LT50eF9wZW5kaW5nLCBza2IpIHsKLQkJcmVxID0gd2Z4X3NrYl90eHJl
cShza2IpOworCQloaWYgPSAoc3RydWN0IGhpZl9tc2cgKilza2ItPmRhdGE7CisJCXJlcSA9IChz
dHJ1Y3QgaGlmX3JlcV90eCAqKWhpZi0+Ym9keTsKIAkJaWYgKHJlcS0+cGFja2V0X2lkID09IHBh
Y2tldF9pZCkgewogCQkJc3Bpbl91bmxvY2tfYmgoJnd2aWYtPndkZXYtPnR4X3BlbmRpbmcubG9j
ayk7CiAJCQlxdWV1ZSA9ICZ3dmlmLT50eF9xdWV1ZVtza2JfZ2V0X3F1ZXVlX21hcHBpbmcoc2ti
KV07CisJCQlXQVJOKGhpZi0+aW50ZXJmYWNlICE9IHd2aWYtPmlkLCAic2VudCBmcmFtZSAlMDh4
IG9uIHZpZiAlZCwgYnV0IGdldCByZXBseSBvbiB2aWYgJWQiLAorCQkJICAgICByZXEtPnBhY2tl
dF9pZCwgaGlmLT5pbnRlcmZhY2UsIHd2aWYtPmlkKTsKIAkJCVdBUk5fT04oc2tiX2dldF9xdWV1
ZV9tYXBwaW5nKHNrYikgPiAzKTsKIAkJCVdBUk5fT04oIWF0b21pY19yZWFkKCZxdWV1ZS0+cGVu
ZGluZ19mcmFtZXMpKTsKIAkJCWF0b21pY19kZWMoJnF1ZXVlLT5wZW5kaW5nX2ZyYW1lcyk7Ci0t
IAoyLjI3LjAKCg==
