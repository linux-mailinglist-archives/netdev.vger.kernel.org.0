Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD4AE19AA26
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 13:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732588AbgDALFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 07:05:35 -0400
Received: from mail-bn7nam10on2084.outbound.protection.outlook.com ([40.107.92.84]:6083
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732561AbgDALFe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Apr 2020 07:05:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CgZX1sVmmmsImtvIFJXGN68MmR6nkJUBC9vAOQj5pK0Tky998kAZXmmp5NlGf+mqmj2oUmAnnCiDgqLikEn5FqC5v1WfOnu6Z/Xid2U5AJaR7TZY7pTigbNDZBx3zem6M83OfnA+0G/YfMk8IqLdAQPK5LPiSOMIdWmvXo5iSzBt3lDLFS9p+6Fk+NACoG+LMO6br5pUzDivPO5nkxjLweEAfCTxEzf9jqG0fjU0nijiuAHNzo5i+k8VfXL2JcJEzX3y7KC+XtIY67ynJOAYiMK1lBP4d+tkFaWSy5h9WR4wgUXLfGZhvkC/qGc0exWU7WV7YdqW9hdnUrlbYP4Ybg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RPrxWdWGNJvYjUT2owohbDyOyC0Vbtfc7ra7B4ROlWQ=;
 b=BR5+gGsllV6XE30EYTOXrpuesGKnj3fu7Si7rTskYWmLcpuA0CLmdxStu7Z3fKO0Y3xMhQ+VFBr/Qf48fSsnMxPI+1+yQeEdm3o1m1sYYwuJrHuE0cRjkZs1aHIMX4LT7GCAYT7JJ3fzxUUn1G+AF8qsDmVz8LeAPkwn8TK8mj2o89wUSbbktwBBIkqk4CB97vn7PbpZvuWkKk+DnJqdunRJYSEzuNiALb0HiRzsmI+Xv0ddhJ2pDJ/BpGT+GQoRnSYPl+lRfnsLfiCvNVfOIIkN6l+7P6eEjbOqlUOb/RrsC5NV8AECcHVQ9C3+4JPELQs4XvqaKppDbRlATN7gWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RPrxWdWGNJvYjUT2owohbDyOyC0Vbtfc7ra7B4ROlWQ=;
 b=Y5QjFHLSt+COTKOYugvB7uaQi6yDAfdAuLXrVGaKOYzSlFK4c5+aibM8+qvWUziGzLwJNOXlErbBHcTEupDyd5QIpj24OxqYA0Mu6XffXKlQ/EoNt8i9dnlX2nGEfYDelOyRGJ/Yq7u3O9aVRKAovM61b+WstvtNdSt1US1gJCY=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
 by MN2PR11MB4285.namprd11.prod.outlook.com (2603:10b6:208:191::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20; Wed, 1 Apr
 2020 11:05:27 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3%7]) with mapi id 15.20.2856.019; Wed, 1 Apr 2020
 11:05:27 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 32/32] staging: wfx: remove hack about tx_rate policies
Date:   Wed,  1 Apr 2020 13:04:05 +0200
Message-Id: <20200401110405.80282-33-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:1265:30ff:fefd:6e7f) by SN4PR0501CA0156.namprd05.prod.outlook.com (2603:10b6:803:2c::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.9 via Frontend Transport; Wed, 1 Apr 2020 11:05:25 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:2435:66a0:1265:30ff:fefd:6e7f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 32e0810a-ea3f-483a-d92f-08d7d62c953a
X-MS-TrafficTypeDiagnostic: MN2PR11MB4285:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR11MB4285F5AAEB2BEA5E1389C4A193C90@MN2PR11MB4285.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 03607C04F0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4063.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(136003)(366004)(346002)(376002)(39850400004)(396003)(7696005)(8676002)(1076003)(16526019)(186003)(6666004)(5660300002)(86362001)(4326008)(52116002)(478600001)(66946007)(66476007)(54906003)(36756003)(8936002)(316002)(81156014)(6486002)(2906002)(66556008)(107886003)(81166006)(2616005);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h1qeSPoIe//HHNak+pSUaABbmyQA0ggmemurZGzVSDHV+lsH1cpN8OAf/8aU4nhNl0W+3S0iqUzRf+2AGzPtIB8LzaAGwbi0U2IROY0z/HutS5cP1QrwhV6Bzwf2Jbgq84UJdSMBZDM/HPHK+CN2EeGiFv4X5gEndVIxxSoQPgs3zMPVtj0VtBKC+NifTRRZnUL78bUn/8KakfJc6CMldLkJ75r4hH0FV2OwO3MZ1FJw6xTCHlcAtvdgkmP3ui9VUleakgYwEaihpYz4eTr0tZOqcASrNdWYjnMImVuDpFldletzn8xt6aITj9NDg2w76doZWWs24uN0DM6NR35H/vRyNYHu+3j+zioeNVv90im0AtQu9NbXvMauWve8Il+2uogWtkVzMrnuC9W0cdl1wLy7pxk9BLl0dhYhokril2d2xDh8WaQ5c0PiS9/Vqy3T
X-MS-Exchange-AntiSpam-MessageData: cvMgiYPn/2TlNtXfy5qZ+kggf3E9UStRlG5XJFEfPDo+64PfnBui3mS9D/ojNBsxW0L3Txg98ge5VDT8P2bdIlWbtcKymJBAyM+BBJAPG4a11S5Th6RcKlpyE4s4aYfU3cBveRbDKrKev87Fze31x51r4jwqVyqCIgCjvT1IC9CpytbrtIbDQ14EEIEkhUw/Tttaho/x7jogPwVT9usICg==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32e0810a-ea3f-483a-d92f-08d7d62c953a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2020 11:05:26.9909
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hauASE1EqdAfBmoLfcj8lpqkFGCLqgziLNRUVpvY5P57dY0ZtCHj09C+/vr5CUxg++HO6VtWmxvzV914g8KgQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4285
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKQ3Vy
cmVudCBjb2RlIGNvbnRhaW5zIGEgd2VpcmQgaGFjayB0byBhdm9pZCBzd2l0Y2ggZnJvbSA1NE1i
cHMgQ1RTIHRvCjFNYnBzLiBIb3dldmVyLCB3ZSBoYXZlIG5vdCBiZWVuIGFibGUgdG8gcmVwcm9k
dWNlIHRoZSBwcm9ibGVtIGFuZApoYXJkd2FyZSB0ZWFtIGRvbid0IGtub3cgYW55IGRlZmVjdCBv
ZiB0aGlzIGtpbmQuIFNvLCBpdCBzZWVtcyB0aGlzIGhhY2sKaXMgbm8gbW9yZSBuZWNlc3Nhcnku
CgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFi
cy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmMgfCA1MyAtLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDUzIGRlbGV0aW9ucygt
KQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jIGIvZHJpdmVycy9z
dGFnaW5nL3dmeC9kYXRhX3R4LmMKaW5kZXggMWQ5YTgwODlmM2QzLi45M2VkMGVkNjNiYjIgMTAw
NjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jCisrKyBiL2RyaXZlcnMvc3Rh
Z2luZy93ZngvZGF0YV90eC5jCkBAIC01MSw1OSArNTEsNiBAQCBzdGF0aWMgdm9pZCB3ZnhfdHhf
cG9saWN5X2J1aWxkKHN0cnVjdCB3ZnhfdmlmICp3dmlmLCBzdHJ1Y3QgdHhfcG9saWN5ICpwb2xp
Y3ksCiAJCWlmIChyYXRlc1tpXS5pZHggPCAwKQogCQkJYnJlYWs7CiAJY291bnQgPSBpOwotCi0J
LyogSEFDSyEhISBEZXZpY2UgaGFzIHByb2JsZW1zIChhdCBsZWFzdCkgc3dpdGNoaW5nIGZyb20K
LQkgKiA1NE1icHMgQ1RTIHRvIDFNYnBzLiBUaGlzIHN3aXRjaCB0YWtlcyBlbm9ybW91cyBhbW91
bnQKLQkgKiBvZiB0aW1lICgxMDAtMjAwIG1zKSwgbGVhZGluZyB0byB2YWx1YWJsZSB0aHJvdWdo
cHV0IGRyb3AuCi0JICogQXMgYSB3b3JrYXJvdW5kLCBhZGRpdGlvbmFsIGctcmF0ZXMgYXJlIGlu
amVjdGVkIHRvIHRoZQotCSAqIHBvbGljeS4KLQkgKi8KLQlpZiAoY291bnQgPT0gMiAmJiAhKHJh
dGVzWzBdLmZsYWdzICYgSUVFRTgwMjExX1RYX1JDX01DUykgJiYKLQkgICAgcmF0ZXNbMF0uaWR4
ID4gNCAmJiByYXRlc1swXS5jb3VudCA+IDIgJiYKLQkgICAgcmF0ZXNbMV0uaWR4IDwgMikgewot
CQlpbnQgbWlkX3JhdGUgPSAocmF0ZXNbMF0uaWR4ICsgNCkgPj4gMTsKLQotCQkvKiBEZWNyZWFz
ZSBudW1iZXIgb2YgcmV0cmllcyBmb3IgdGhlIGluaXRpYWwgcmF0ZSAqLwotCQlyYXRlc1swXS5j
b3VudCAtPSAyOwotCi0JCWlmIChtaWRfcmF0ZSAhPSA0KSB7Ci0JCQkvKiBLZWVwIGZhbGxiYWNr
IHJhdGUgYXQgMU1icHMuICovCi0JCQlyYXRlc1szXSA9IHJhdGVzWzFdOwotCi0JCQkvKiBJbmpl
Y3QgMSB0cmFuc21pc3Npb24gb24gbG93ZXN0IGctcmF0ZSAqLwotCQkJcmF0ZXNbMl0uaWR4ID0g
NDsKLQkJCXJhdGVzWzJdLmNvdW50ID0gMTsKLQkJCXJhdGVzWzJdLmZsYWdzID0gcmF0ZXNbMV0u
ZmxhZ3M7Ci0KLQkJCS8qIEluamVjdCAxIHRyYW5zbWlzc2lvbiBvbiBtaWQtcmF0ZSAqLwotCQkJ
cmF0ZXNbMV0uaWR4ID0gbWlkX3JhdGU7Ci0JCQlyYXRlc1sxXS5jb3VudCA9IDE7Ci0KLQkJCS8q
IEZhbGxiYWNrIHRvIDEgTWJwcyBpcyBhIHJlYWxseSBiYWQgdGhpbmcsCi0JCQkgKiBzbyBsZXQn
cyB0cnkgdG8gaW5jcmVhc2UgcHJvYmFiaWxpdHkgb2YKLQkJCSAqIHN1Y2Nlc3NmdWwgdHJhbnNt
aXNzaW9uIG9uIHRoZSBsb3dlc3QgZyByYXRlCi0JCQkgKiBldmVuIG1vcmUKLQkJCSAqLwotCQkJ
aWYgKHJhdGVzWzBdLmNvdW50ID49IDMpIHsKLQkJCQktLXJhdGVzWzBdLmNvdW50OwotCQkJCSsr
cmF0ZXNbMl0uY291bnQ7Ci0JCQl9Ci0KLQkJCS8qIEFkanVzdCBhbW91bnQgb2YgcmF0ZXMgZGVm
aW5lZCAqLwotCQkJY291bnQgKz0gMjsKLQkJfSBlbHNlIHsKLQkJCS8qIEtlZXAgZmFsbGJhY2sg
cmF0ZSBhdCAxTWJwcy4gKi8KLQkJCXJhdGVzWzJdID0gcmF0ZXNbMV07Ci0KLQkJCS8qIEluamVj
dCAyIHRyYW5zbWlzc2lvbnMgb24gbG93ZXN0IGctcmF0ZSAqLwotCQkJcmF0ZXNbMV0uaWR4ID0g
NDsKLQkJCXJhdGVzWzFdLmNvdW50ID0gMjsKLQotCQkJLyogQWRqdXN0IGFtb3VudCBvZiByYXRl
cyBkZWZpbmVkICovCi0JCQljb3VudCArPSAxOwotCQl9Ci0JfQotCiAJZm9yIChpID0gMDsgaSA8
IElFRUU4MDIxMV9UWF9NQVhfUkFURVM7ICsraSkgewogCQlpbnQgcmF0ZWlkOwogCQl1OCBjb3Vu
dDsKLS0gCjIuMjUuMQoK
