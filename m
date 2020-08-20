Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3AC24C2C4
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 18:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729701AbgHTQBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 12:01:13 -0400
Received: from mail-dm6nam12on2046.outbound.protection.outlook.com ([40.107.243.46]:36576
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729665AbgHTQAh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Aug 2020 12:00:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZSM51jNejaqwl8wnNtDKMy5SpZ9Mqf5gOBHY6Y/E8NvTb7OuVZ/bUzkSS9PR4pQnXsp2qtvAJWnW+EGlhxMDuiltnA5ojhwCuwOZ7/Z8yDvZlauVcServLyJhOQuOCwQSaCsAbDbNEyKjDDcQmTskLAlX7cyfVsisd08IPOkhgTNLAr1CW6BErpXPeRiJT7Nq5pM2W9eCwLOVSjC0wqe70cStgoHj/u8pRFDGUZID+rcgte2iO0SApX4orX9ufJ/ArCg13bLBHCgVd5ob+veG5UAfU0oQQYXom2yUIun0ASAehM7CnqwkvedUtm+rtg0njDY5ThyUeCqZQVnFtgK4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lDRIEs3gitc7zye2/sfjgYma3wmW5ouz2V8A5vvj2vs=;
 b=aDF3E8jfyLdS4uhy5L5i2i/Dd2cmqQ4S9LNNP6FMs5rJ1uJg+OXD9EzCSrvFhi6botWtn0ifph3rEW/a+eLjIZU6EchKWlXxVqCY43BfcOY/AzWJuUswal5hT36sUXzC6eMx/4cCsi1ZFxUMM2aOXUCXOectyuKJS1mFmqLvidM0hYtCxcZTTpeEGcPExL2aXsR9RUK35wzAQbyxBKh1sJihy3dIdklSdMUG7AYmnwXEVByEv8LpPIVsDZfTdOgvbPUf92vtEKvwt7LGqlhOGTZ3+fWZWUFwLYSTnVwbFQI+d6aIj1jIsmzSY4P1+LJAAS5JK5v70SwABDvIqW9PUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lDRIEs3gitc7zye2/sfjgYma3wmW5ouz2V8A5vvj2vs=;
 b=KK9wmAS6wDXfNci3lJmJMVNMiTT855OEW76/gPYKcqOhYMDYKZOhiLhoQHR27+p44Sg/XDHMSDD8qzNvOtAVuulucLm1WCx+9xxF0ZpRb64MmtiBl1YSLZbt0cFTRUc49k09y4iK6qCgtqiiBDFg3VKQL5VsUQuy+WDIvdLYzKA=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA0PR11MB4541.namprd11.prod.outlook.com (2603:10b6:806:94::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25; Thu, 20 Aug
 2020 15:59:40 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6%4]) with mapi id 15.20.3305.026; Thu, 20 Aug 2020
 15:59:40 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 11/12] staging: wfx: remove useless extra jiffy
Date:   Thu, 20 Aug 2020 17:58:57 +0200
Message-Id: <20200820155858.351292-11-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820155858.351292-1-Jerome.Pouiller@silabs.com>
References: <20200820155858.351292-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR0P264CA0122.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1a::14) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by PR0P264CA0122.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1a::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24 via Frontend Transport; Thu, 20 Aug 2020 15:59:38 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [37.71.187.125]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dc26b408-1ba3-4983-65f4-08d845220ba9
X-MS-TrafficTypeDiagnostic: SA0PR11MB4541:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR11MB4541C529024217007E98B35D935A0@SA0PR11MB4541.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SixdycYFZ/xjCe/nAjNkMMcA7fqn6JhcJoiFfFuYm16e75Q52C2BFnHLpmxRnbwWqeV/lhQ8w18t/auzhm9SZw0HvpxDs99Th5YronNBxd9zQD7/7P/HzhrowIkcaF5s2Goe15G0L0TlV+wXMaRUq8i/RWS6E1MquLMIIT4aMUcilO39g9/sB+2MOW5kSR5nKnY5ZuuxI/ae8DiN3vklORkOQgds+e2UPD251Eb8/BqZ7gsoZdPiPbnqIeUeP9skfDUpD+M/1jBYMgWqR7327nPMzQEh6FESdwRxInviktbN7xzLv9lGx6m3KD59G0mSPGxKMHCNBB35E8igah+/SXM5646CxZaLOw7zoUI4P9NVV7RsqbPnsF2VZZdERoeO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39850400004)(366004)(346002)(136003)(186003)(6666004)(2906002)(8676002)(316002)(16576012)(54906003)(956004)(26005)(66574015)(8936002)(2616005)(110011004)(52116002)(83380400001)(107886003)(1076003)(4744005)(5660300002)(478600001)(36756003)(4326008)(66476007)(66556008)(66946007)(86362001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: L1GGP7zSWtqzBT6ZYdhDc/UdR6fk5SgcGnxKkaC4HnDjbc9wbymk/UwE8+XnVcoBMav/Xq4ntTRGrH67bVLDm/8bUg4dE4u2oVykNzmX+qaFpnLEtJLezSjKK6v0t06cug6zWsl6hQGRwz3EWf6+A6rmHY16vouBCjE4NgWIH02yW7vhlRo8GH2fsdB9iVfECClxfCwzeoUv8bfI/fEk5rYzCkH2LfBmGO40I/gAoCElMZ4XBvf3DfLG0BKV/rzWs/PMaUgquCOtTtDqqu7yJ4IsXe6WHnM/tEsoT7RmL4QVyyUBQb8zSWex8vTKPgPpCBxfU0wFhNT8gxBr6m4yWmCQ6NhM/x6EKW77mHNdprXesJCRdHp8eIboz2vt3Y41gNXxUlLN0VU1ncqdIjhCZ9WhWWl3ztivL3BIH8TTkX4bnH9UIXKwi+XcCW9TorTLWMAlZQ+42S0MQqGjMCpXgmsxvWMmFvhmtqnzk7Ca4GifCYNJaXTw6ami5ukc6p3xif/M/f1Yg41j720r6IjWyKP2LnSHPy93yXVLGxKofumk7RbXR+0/6vYxBeDtiMuFH1TQ8KUAhWqKhxgk1VWsDfN9rMYxiOrPPTjcEGeid/Ur6nkJ9qiPBkSBUTAIks1eHcBryukRv3o+rw8OjybqLg==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc26b408-1ba3-4983-65f4-08d845220ba9
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2020 15:59:40.2969
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2CPf1tmAGzgIZo5s5cl/JuMrQ7ZqKG8y+Vjdud9P0rJSikK56BkFslHpQH/BCK7+WdnFp7QYbl+mYoc7fJvo6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4541
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGluaXRpYWwgZGV2ZWxvcGVyIGhhcyBmZWFyZWQgbXNlY3NfdG9famlmZmllcygpIGNvdWxkIHJv
dW5kIGRvd24gdGhlCnJlc3VsdC4gSG93ZXZlciwgdGhlIGRvY3VtZW50YXRpb24gb2YgbXNlY3Nf
dG9famlmZmllcygpIHNheXMgdGhhdCB0aGUKcmVzdWx0IGlzIHJvdW5kZWQgdXB3YXJkLiBTbyB0
aGUgaW5jcmVtZW50IG9mIHRoZSByZXN1bHQgb2YKbXNlY3NfdG9famlmZmllcygpIGlzIG5vdCBu
ZWNlc3NhcnkuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWls
bGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9iaC5jIHwgMiArLQogMSBm
aWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9zdGFnaW5nL3dmeC9iaC5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9iaC5jCmluZGV4
IDUzYWUwYjVhYmNkZC4uMDczMDRhODBjMjliIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcv
d2Z4L2JoLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9iaC5jCkBAIC0zMyw3ICszMyw3IEBA
IHN0YXRpYyB2b2lkIGRldmljZV93YWtldXAoc3RydWN0IHdmeF9kZXYgKndkZXYpCiAJCS8vIHdh
aXRfZm9yX2NvbXBsZXRpb25fZG9uZV90aW1lb3V0KCkpLiBTbyB3ZSBoYXZlIHRvIGVtdWxhdGUK
IAkJLy8gaXQuCiAJCWlmICh3YWl0X2Zvcl9jb21wbGV0aW9uX3RpbWVvdXQoJndkZXYtPmhpZi5j
dHJsX3JlYWR5LAotCQkJCQkJbXNlY3NfdG9famlmZmllcygyKSArIDEpKQorCQkJCQkJbXNlY3Nf
dG9famlmZmllcygyKSkpCiAJCQljb21wbGV0ZSgmd2Rldi0+aGlmLmN0cmxfcmVhZHkpOwogCQll
bHNlCiAJCQlkZXZfZXJyKHdkZXYtPmRldiwgInRpbWVvdXQgd2hpbGUgd2FrZSB1cCBjaGlwXG4i
KTsKLS0gCjIuMjguMAoK
