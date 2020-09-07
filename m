Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14C9525F82B
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 12:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728867AbgIGK2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 06:28:09 -0400
Received: from mail-eopbgr770058.outbound.protection.outlook.com ([40.107.77.58]:18596
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728706AbgIGKQQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 06:16:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hPsS2KZL0aGeG0uPYyKDn7S1XSxX71twJkRbmg1MKedMy0G44gmF/o9ftqshjYJed/f/OoYiwxIBhgVozPVCaqGh0676G66IiBC4ATpYpQvBsWKatmpozWIdF/veZMj/S4m8HRe6R9PSt3QCRA4z3VzWgzB29uayNxJE+oOfWc+PFTE2rKtIAjOhRst55P8SZsJp1bAfxl+8jNByOSwNvlF9Qm5Zmbw6PQsYkvG/tecuzRRVmyn38VD4eWtgEsOCYPybSNoHbAdnPTrEmPs7q2zxhL3glOvQ9CSCKkUGqPCfiP8MvvFWfyHD0sDge6N91sR2H8JFhVShcuN7LT9A3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KFPDdFefJRslQCCpL0dfvmzXLY8YZF9YL8lX1uV0Z9I=;
 b=LjNqJOSH+YzkMczxceNxhhRemL7tHezUJ9K8lVMd/nzWJDhdpmoXmb4vYS4Kb/KcRBT9uLYrvShdpjVrFNskDFT8ju1Cgm8qNxmPcBTpc2bpc77arVjRoimZBtDTYrOqMYqy8b8G/Z2RF39GZwszjeEH312uHLEbD2vEzhqugcV8wH4BxFh4czAjRKqsajRrPxOYu4Ie1BuJPtMF38He4gRZxM7gSNWQydOrC0uknhj5ZdzGG+d1gsPDSOZtmLWTaHxE5PQtd2S/NWbb/zbXU3NpZZ7Ws2533U6icbsKgf5E+qBIsfU7DOjjvmSKzoHE3UUVkPboyCbVNxXa/AgKPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KFPDdFefJRslQCCpL0dfvmzXLY8YZF9YL8lX1uV0Z9I=;
 b=cR4f1bm6koyIfiLVpoq4LDbASoBlyZKT4qmR5+FrWgDz4hVATGXapTO7mbMm5OKyUhckZELRiATQ0L0HTVOX7VT42eBbYUh1Czv9QwE81WSb1snjpX7v6ZQ9vlrTZ2esRG6/h3m7Er1Lt36ks1iGHPnqHt2/zfEsOXiAsNCIi4U=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2606.namprd11.prod.outlook.com (2603:10b6:805:55::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.17; Mon, 7 Sep
 2020 10:16:04 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6%4]) with mapi id 15.20.3348.019; Mon, 7 Sep 2020
 10:16:04 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 12/31] staging: wfx: drop useless struct hif_join_flags
Date:   Mon,  7 Sep 2020 12:15:02 +0200
Message-Id: <20200907101521.66082-13-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200907101521.66082-1-Jerome.Pouiller@silabs.com>
References: <20200907101521.66082-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR0P264CA0109.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:19::25) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (37.71.187.125) by PR0P264CA0109.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:19::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.16 via Frontend Transport; Mon, 7 Sep 2020 10:16:02 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [37.71.187.125]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9286ac69-7fc9-4be6-a87e-08d8531706fe
X-MS-TrafficTypeDiagnostic: SN6PR11MB2606:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB2606523A050C46D449A47E2A93280@SN6PR11MB2606.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4fWJVwKIO98VlgFPu63CCJdnxNz4NiAKEVa/oe2PQg99/gTup6vuN5Dj1NL46yrgg9ABWtbkfbVzs7KLBeTfSIJYMidTla0t1DxwvsW8+ha8OgKC8UNmWskoSDruwy5K0/SMrVJY10TxH145fP5Yli2hRbUIYCdkzgsbYM06H4QSyBbb+rgAY0aefyZ8dNQF1Kj9zmceiHQRBCPgOP5TtUCLe8ObHtZ36Ex/BNL9ErHyL7/aqCVzfohItZ41SxKek4sg7tySvNih+msNoeuS6ncNfjntvRiQ4szt19h+a0c4aAppo53OcwampKEN1qP9aNQrvIDt5NRBxpl/TUleWw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(346002)(366004)(136003)(39850400004)(66946007)(4326008)(5660300002)(2616005)(66476007)(316002)(956004)(478600001)(54906003)(52116002)(2906002)(66556008)(1076003)(36756003)(8676002)(86362001)(6486002)(8936002)(7696005)(66574015)(83380400001)(26005)(107886003)(16526019)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: r397UsputiUaQsBA3pofR4TIHR4EtMy/Ek9hE03s2goJvWvTUleV5zuNCwKXMYMEjO0UMud0pdQhnBP9xfak6Ch42ZJFdls90T5NDhr3QkdZS8/pDnfYCb7M81jhQIHLIF5SFMl5d9642hAYmKoUeza9vO4FTPMZM9vnIjcQFK9jmeUMvh4xk0J9inQMPmTn1zqVzbAEKUiQHjAqBX6SSaKf4oMap+VzSvRnF7bEleEy0ut0YKQLUGhUotnaGbTnBwS+R096iaKBa3cRP9457NJTpKWt4WaUg05iRMtzN60+VaGNRX2ZfM9phIBornl5stxLCG6jK+AzOWMWIBFDaANeb/NFZ/7AHlDrvF8F8RDzMBlzpfq4+i0eO+DcISR+hxxnu2s2RJhKfnJgK01l5u8IzyYbCNIn0b3buR2cu9r2LTNas37wxdVAjkqNvJ602ePjEXcukv8Jyid1/Rjqb2nt15jJLXL0W+53sCmaOLW0r2GRZf07RpFsM5TXU2SY+YSYPYrrdpzpaiq7pxL+WPv7qR/dT3vUBIC/lv9YbZG3B4RxuDMUVievTGxmpEMbBcAidY/yn2pDZeN88IPP8+QVxKIOCe1FwaNb/XWYPwqvqQQYuBqWnUC5dGwq21VNkNaAsbRLvB7A9R0u/wU+8A==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9286ac69-7fc9-4be6-a87e-08d8531706fe
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2020 10:16:04.1329
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mhFOhyAomG8jRMVMBczgxbr0BCzklTW7EGIqURTESt02NvJVO/BQ+HhL+rH56jf1wm1l8RDEMnxHFwypj3xOcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2606
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU3Ry
dWN0IGhpZl9qb2luX2ZsYWdzIGhhcyBubyByZWFzb24gdG8gZXhpc3QuIERyb3AgaXQgYW5kIHNp
bXBsaWZ5CmFjY2VzcyB0byBzdHJ1Y3QgaGlmX3JlcV9qb2luLgoKU2lnbmVkLW9mZi1ieTogSsOp
csO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMv
c3RhZ2luZy93ZngvaGlmX2FwaV9jbWQuaCB8IDE4ICsrKysrKystLS0tLS0tLS0tLQogMSBmaWxl
IGNoYW5nZWQsIDcgaW5zZXJ0aW9ucygrKSwgMTEgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfYXBpX2NtZC5oIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9o
aWZfYXBpX2NtZC5oCmluZGV4IGIxMDRhYmJjNWIyNS4uMWM5OTQzMWViOTBmIDEwMDY0NAotLS0g
YS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfY21kLmgKKysrIGIvZHJpdmVycy9zdGFnaW5n
L3dmeC9oaWZfYXBpX2NtZC5oCkBAIC0zMzYsMjYgKzMzNiwyMiBAQCBzdHJ1Y3QgaGlmX2NuZl9l
ZGNhX3F1ZXVlX3BhcmFtcyB7CiAJX19sZTMyIHN0YXR1czsKIH0gX19wYWNrZWQ7CiAKLXN0cnVj
dCBoaWZfam9pbl9mbGFncyB7Ci0JdTggICAgIHJlc2VydmVkMToyOwotCXU4ICAgICBmb3JjZV9u
b19iZWFjb246MTsKLQl1OCAgICAgZm9yY2Vfd2l0aF9pbmQ6MTsKLQl1OCAgICAgcmVzZXJ2ZWQy
OjQ7Ci19IF9fcGFja2VkOwotCiBzdHJ1Y3QgaGlmX3JlcV9qb2luIHsKIAl1OCAgICAgaW5mcmFz
dHJ1Y3R1cmVfYnNzX21vZGU6MTsKIAl1OCAgICAgcmVzZXJ2ZWQxOjc7CiAJdTggICAgIGJhbmQ7
CiAJdTggICAgIGNoYW5uZWxfbnVtYmVyOwotCXU4ICAgICByZXNlcnZlZDsKKwl1OCAgICAgcmVz
ZXJ2ZWQyOwogCXU4ICAgICBic3NpZFtFVEhfQUxFTl07CiAJX19sZTE2IGF0aW1fd2luZG93Owog
CXU4ICAgICBzaG9ydF9wcmVhbWJsZToxOwotCXU4ICAgICByZXNlcnZlZDI6NzsKKwl1OCAgICAg
cmVzZXJ2ZWQzOjc7CiAJdTggICAgIHByb2JlX2Zvcl9qb2luOwotCXU4ICAgICByZXNlcnZlZDM7
Ci0Jc3RydWN0IGhpZl9qb2luX2ZsYWdzIGpvaW5fZmxhZ3M7CisJdTggICAgIHJlc2VydmVkNDsK
Kwl1OCAgICAgcmVzZXJ2ZWQ1OjI7CisJdTggICAgIGZvcmNlX25vX2JlYWNvbjoxOworCXU4ICAg
ICBmb3JjZV93aXRoX2luZDoxOworCXU4ICAgICByZXNlcnZlZDY6NDsKIAlfX2xlMzIgc3NpZF9s
ZW5ndGg7CiAJdTggICAgIHNzaWRbSElGX0FQSV9TU0lEX1NJWkVdOwogCV9fbGUzMiBiZWFjb25f
aW50ZXJ2YWw7Ci0tIAoyLjI4LjAKCg==
