Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F134C1C55C3
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 14:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729035AbgEEMiX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 08:38:23 -0400
Received: from mail-eopbgr680041.outbound.protection.outlook.com ([40.107.68.41]:21169
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728905AbgEEMiV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 08:38:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WclLI/0sVU7P9GDFcBNjourF+Z/IJgStgqenhHnWVxUhxPDtKVuQGcLCyXb3ksbOtrv+TEBfDWief2cjeVysvirafucYKPK4XB1v6yfFmwf2eynnc48yc0CRkGHDATe+FV3YXhQqe//xSslVX/Ak/wiMz6qQFZjsLFQ1rgX1lvKBhwmJBF3zg9s/5lw2d9JBhKgYada37fLPvJb7vgJW6Oqd6fwstW9PPjtXD2Espw0HmhaSgNcRCUt7nhJY2bC0HknQPW8ENvVkjjQpryCrZgEdiVTTSlNMAFE708v5/zNvKQxNXvUp8E7MXIEshw4Lrre5KtvNlSNs8JCEreZZwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H8vGgHyHnPGPOF1YWFtZk/kRrA+ZPjDjlBfPtzkeBtE=;
 b=iRctM9V7TrKmDQE4mYwD+sdBcxu/fZ9s1c7/h8aBMvgMVoGTBPQhW0xarUjWF3P5zyZbP0xO9Z9UzcmqVs2wAo0SX3xQE+NSU87+psXSPtb/s10D8JLleDvTDgBPxkx2HImeX8RjKM0esjTxL489yKthhdZMpLvHJTgsv3yl/9jd/YfCwAElQqtbBNx+LUz8fVuVx67PtUf5Y2a3TYQVD8XY53SLX8mGGSMEmxFxtrnVQu8DsvxVQ5kKLj88dBya+qRimv8q7zTQguo219nVMecS6lmXQAd0WQp/5QBO9dxOkIcg+/UGDqTvi0GuvkVM5/qreaIjbfw/uwxYXyq5UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H8vGgHyHnPGPOF1YWFtZk/kRrA+ZPjDjlBfPtzkeBtE=;
 b=C4NZGn2vjk202iVTqHRtwRNvt19QkHYoXN8IS6keDHSFfAn4vDVospk1PWF7XX0zJdJbaUQ7l1R7GD3n9a0JtNV2LLt/CVyAMUgLZZAfaKxrj7p9f53b70D4JoqyoT4ve8wzxdAxheZlGAWEvE2krUOcYm6GvOENZwFaqemB0Bg=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1824.namprd11.prod.outlook.com (2603:10b6:300:110::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19; Tue, 5 May
 2020 12:38:16 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe%10]) with mapi id 15.20.2958.030; Tue, 5 May 2020
 12:38:16 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 02/15] staging: wfx: reduce timeout for chip initial start up
Date:   Tue,  5 May 2020 14:37:44 +0200
Message-Id: <20200505123757.39506-3-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.home (2a01:e35:2435:66a0:1265:30ff:fefd:6e7f) by PR3P189CA0022.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:52::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Tue, 5 May 2020 12:38:13 +0000
X-Mailer: git-send-email 2.26.1
X-Originating-IP: [2a01:e35:2435:66a0:1265:30ff:fefd:6e7f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bd98bebb-69f0-49bf-3d4d-08d7f0f12e83
X-MS-TrafficTypeDiagnostic: MWHPR11MB1824:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB1824624CCA96B09D338B4D1D93A70@MWHPR11MB1824.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0394259C80
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nSoXxKGIpt9uaq50KWLTIbkC61+w1yBOGthmsMtIvXqsVpS+NhdiXOn8/szZ4z050d1Ix/xrYvNM0xw7VuCRFWmZFQTAZBozEdnk3F4+J6aXgeQGiE3LDw3nHc/BCbn7fwAUwkOI4ezetpV9MzQvQzx2Llku9i7BvIrEbGp1KnyufVpqs9P9I3b3h9OGEd5WNS0SVEBuqSM2XcV9Q9fB1lkENwIx8lHc0Dj/bVoYTQAVXJWcr6TAz04ndJIm9CoFib+oXvYx1FwuKRRn8WJT5vYIsXY68Nw/MYfo6nhYBMkbVi7r+KbPAZgNlpsa02mNik8mpnMFzy+nOKZ36WfUjRt2EHEKZyZLyktlUlXbU23TfndKfokV7q/cDicWMusbfywzWypcG6HIhcFlNgh9bWtECveNKRXL4ZIfbNlD/GMgvDpGwysUKkorK0mAuE5nHS1W9W+bD1KSDMZ3hGrgwxZjC7pFWHvfR9OKeixf/5jbi/xpm0TQZhJVUVyRe6L4AR0hft1khFY2SGNooWULTQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(396003)(39850400004)(366004)(376002)(346002)(33430700001)(86362001)(6666004)(107886003)(8886007)(1076003)(6512007)(6486002)(4744005)(36756003)(5660300002)(2906002)(66476007)(6506007)(16526019)(186003)(52116002)(66946007)(66556008)(54906003)(2616005)(4326008)(8936002)(8676002)(316002)(33440700001)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: SaKm2ISjGz3lQOWUGLE26Iquehe5Z2351YY5B77P5ZJkNPNglw80o9//BcNyul9RqAzoCKdkDMEkDon6ysa/Meu3bqxgcVq9NLkgTqElIMCb/14kosBcqBGcJXbWna3jhVXiVkRxLivdhmH0b3gcQQEQ0aEhl6DU/S1ZRD/U1IK9v509A4dDk7hkeiMYqbgAuG4Q6NViPuo/2WtQqaVFEj9ixUC+z47VoYW2u8mD3+gwG9eWDbqS4BlYWkfzpojxKqj/o0HIvghW40+kgkyco+JTbAyjnEhHQGdcTbz7FpAM0b03iVoNj8er1y0zllKXRta082u2CwQJRPnO0I7O3GSEuHerUv65SNkMiqRSGvM6wIyy7HTTHFysBVSxZ074RLRWiRsGMZStjZ6rg3F+w9xM7+1ccQhST6LAWrRp5Gk+demEn1R1IFE6PaKgwO/iCmaolcuEK2HNq91l5boQION8gFI8cS+Vsh+bZs5RbqA9/EzYGCKHHu+nRIu5a1OtVygmLprtSpblpRohafEv9nx3iV0dbhHkMgP4h/40s+yJpTSHQv5Aiou0/5hwiI1c/I6lQo0EvdsuVayRl0awcPSmN0k2gF6FdmIiKTsTn1BLK1VMX4KjrtmnfUdqb2dECY5pYDYIZ1iITodMmzfQ0EE7FUW0/Q4VnKHaSCUlnqB4ycQiqbL6GmWD1nT2BrHXSAtrlk3o2ZFD3elZt+jSidnbJFA2AHZXVxTZ7NiUFl67S046fSNTi3Gr85eSNPPDfGiTpVbKpJCjbC3GTggrKQAqAq3pjEhUuJC4wXIhkHIW87BxpdKgq4vLOLZfOeAq69//wD9rQ76R/Z092d+0UpmMue4Nsxn/gO9jpK2UrDU=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd98bebb-69f0-49bf-3d4d-08d7f0f12e83
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2020 12:38:15.8770
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H16RZVPmpgFbNWKEmCyJLwlAJdpQOIu/4U+6IUxq48+B8/QVPSF7sI0MJh7H3LKVv+GEaooSrqjjUT5l9+cXEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1824
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGRldmljZSB0YWtlIGEgZmV3IGh1bmRyZWRzIG9mIG1pbGxpc2Vjb25kcyB0byBzdGFydC4gSG93
ZXZlciwgdGhlCmN1cnJlbnQgY29kZSB3YWl0IHVwIHRvIDEwIHNlY29uZCBmb3IgdGhlIGNoaXAu
IFdlIGNhbiBzYWZlbHkgcmVkdWNlCnRoaXMgdmFsdWUgdG8gMSBzZWNvbmQuIFRoYW5rcyB0byB0
aGF0IGNoYW5nZSwgaXQgaXMgbm8gbW9yZSBuZWNlc3NhcnkKdG8gdXNlIGFuIGludGVycnVwdGli
bGUgdGltZW91dC4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91
aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L21haW4uYyB8IDMgKy0t
CiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9tYWluLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L21h
aW4uYwppbmRleCA3NDJhMjg2YzkyMDcuLmJhMmUzYTZiMzU0OSAxMDA2NDQKLS0tIGEvZHJpdmVy
cy9zdGFnaW5nL3dmeC9tYWluLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9tYWluLmMKQEAg
LTM3MCw4ICszNzAsNyBAQCBpbnQgd2Z4X3Byb2JlKHN0cnVjdCB3ZnhfZGV2ICp3ZGV2KQogCWlm
IChlcnIpCiAJCWdvdG8gZXJyMTsKIAotCWVyciA9IHdhaXRfZm9yX2NvbXBsZXRpb25faW50ZXJy
dXB0aWJsZV90aW1lb3V0KCZ3ZGV2LT5maXJtd2FyZV9yZWFkeSwKLQkJCQkJCQkxMCAqIEhaKTsK
KwllcnIgPSB3YWl0X2Zvcl9jb21wbGV0aW9uX3RpbWVvdXQoJndkZXYtPmZpcm13YXJlX3JlYWR5
LCAxICogSFopOwogCWlmIChlcnIgPD0gMCkgewogCQlpZiAoZXJyID09IDApIHsKIAkJCWRldl9l
cnIod2Rldi0+ZGV2LCAidGltZW91dCB3aGlsZSB3YWl0aW5nIGZvciBzdGFydHVwIGluZGljYXRp
b24uIElSUSBjb25maWd1cmF0aW9uIGVycm9yP1xuIik7Ci0tIAoyLjI2LjEKCg==
