Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7DE25F858
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 12:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728918AbgIGKb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 06:31:57 -0400
Received: from mail-eopbgr770058.outbound.protection.outlook.com ([40.107.77.58]:18596
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728672AbgIGKQO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 06:16:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jXWiNeCl8b527bbRTVrZVoJmfl2Nm4H5SW+VhhHCTqLjvBkXEQV+j4g9pohq/SW04h1NqA1zt65+kDDKFMFRa4/t2Gs4ebzM9/fiw9T6Fb8sTxwllFutjqSs+VH3dm82/YnhRgfnqVJg4LRBu068zHa0aXbUgXO6ruzx9d7JTNeZsm8TvogZhFU843M58xYwXwL2bZHvwv41M1Uc4V3H02lvSz07xCPqZHIWHWlhPOkEdeN9NrgqWoE4OG7OJty6Z5WqZXxxdMriGS6eGrii/DOcAzFMAvjzguCZPjE2p+/TRpEdEjOg/cFBatw9X8BDAOzkL/31rY2ZFqTmO7LuqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zq8ya5wHIwkpQIly5Lrv5/t7dlnJkuTFSda/nJRjc2k=;
 b=a7CN1JggqI0b7zKKuum7cf3nJyifn+4wJ44B9b9kXqD/U0n2qhSsXhpDAEjm6WDFrW0aNX1G/UzPMHZ5MtwEtw5mo+7Ei+nHP7kQaDc2Cbjt2ei/0BAkeLjkZs+76HLqVYGbqcpGEYft7mpTCjb4RmqLRBd3KmGgKXwAMoOVLqkyymGt/ECiRNS4J5M8YRf6rcFMKhtDluc1Z2REqaXyq5tOocn2qARijCgOZ6OYHW/xuWXfO6l26ygkO01WFsHUXysayark2JRdRPGr8++TBDrTbseecg3q6EK+2ZsJ75SjWN8NUuGeK1laIeKD1mLDn9GLgUZQ3ZTsJ7Fx9hpYMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zq8ya5wHIwkpQIly5Lrv5/t7dlnJkuTFSda/nJRjc2k=;
 b=BIX352u7++eExV5V7QSkWVEeA5qKKlpiIm4TOC7kadHtAfsC2P9z7mSeghZ7MM4+79DcZj1rplDKMT/L8AYlK7Ml3VZ2Jn7YvtxHkOzd1ovoYP85+ggKKc9NLMFfVw//ITDWUli+ZSK18JXWn18YKqXx9lJm7yHoFfGl/6wMxWI=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2606.namprd11.prod.outlook.com (2603:10b6:805:55::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.17; Mon, 7 Sep
 2020 10:15:59 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6%4]) with mapi id 15.20.3348.019; Mon, 7 Sep 2020
 10:15:59 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 09/31] staging: wfx: drop useless union hif_commands_ids
Date:   Mon,  7 Sep 2020 12:14:59 +0200
Message-Id: <20200907101521.66082-10-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.silabs.com (37.71.187.125) by PR0P264CA0109.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:19::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.16 via Frontend Transport; Mon, 7 Sep 2020 10:15:57 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [37.71.187.125]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 78e265d2-dea5-48a6-8de4-08d8531703fa
X-MS-TrafficTypeDiagnostic: SN6PR11MB2606:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB26063D78E4AFC1E655CC7B6A93280@SN6PR11MB2606.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:296;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AzTHSIAnnXAgrUiGu3x7XRgThcWhPgXXmd0bqNT6pza+v7+y7Nxf+7q2uEp9/fF94SriXbQpxztqW5amoKcTYokc5mKxQzh4k6lmrErJ3vCN7bcEDncNVmU9AWym2chTRq/28l5iMi3jJBkBaqNAoph0c12lsYwni51OrTJDuE5hFAt6xUvKbk0oRz7NhS49z6PetbcM9puEGQgf29OaaYlvjm04X4vB/Xv5jEUPx+6QHTe6SHlSwTqa/PIZJmp+ExhDtkY5al3sKbSOFUDqjUiYsaofb1xaFC2cpBpLLSrCTNIOdwPj+KjJxN4C+3l1orNJr7mFGeR34PPQt1OOFw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(346002)(366004)(136003)(39850400004)(4744005)(66946007)(4326008)(5660300002)(2616005)(66476007)(316002)(956004)(478600001)(54906003)(52116002)(2906002)(66556008)(1076003)(36756003)(8676002)(86362001)(6486002)(8936002)(7696005)(66574015)(83380400001)(26005)(107886003)(16526019)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 6kbuX+dtOlBWfusOZKN77qkZT77x9Lfvui/el+GB3EFdyHIjN/DdKqd/ngGyK1S5EwUOB1Kp4to+hzQGz2KYPZufnBojUmznpcjrNG+Eh7xvU3EjSH0er15lafkyeSkHjDVxzx22qRUvfzhiDS6ZxtkPtn+LhFqjSjfoOg4xxdLasImTzAWo5B2giTT6SLCyoegJfUO7OOmRgAJ3n2siPmDkpAOdlUHnsEn03NgRJpBt2ExOjc8pXbaQsLS8H8mJCYp149Y2RIbCjQHP6YHCTAN+kILtxEuairkkr5xe0FAp11Kq9TqLg5u5a+fg4S0xuNzfuml6qZixUuWaGE2HFMeYYhz4g4hNvo4lECJJO3Baqw6zImVwf8urNE4kC987Ug6LiBwJ0QEoLy00ONwpxK8EhNT3p4Y8PYtxe/I4zD2VB0p5W6RTKm/oWqd4WqixRdpIHlyOwgMcEpApsCVgsMLXYsEp/4QFWF2oYdSc5zaxFrBarIEXgQ2HUD1mf6bD6Hzzm+fMaGi26RG9q8404Q5JqKHPTCbYHrln/nIRVtRL90C5Hvwbiv7v/O/Zq+Er2Q3pS5GJILF3J/JVuPET1Ycw3clJruLONdozwar+ynJGcYrCR0PEtNCsZ/W1mVn6337HKiYjieEi6vWsTBzFOA==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78e265d2-dea5-48a6-8de4-08d8531703fa
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2020 10:15:59.2118
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BO8JKs7JaibsZJlEtfRavbQGCwiMPf3F9bveIVAWF6S9SBJ70/iqqnGlq3teUre0nvVcVGFf2CLeJlP93jhrqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2606
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVW5p
b24gaGlmX2NvbW1hbmRzX2lkcyBpcyB1bnVzZWQuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQ
b3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5n
L3dmeC9oaWZfYXBpX2NtZC5oIHwgNiAtLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCA2IGRlbGV0aW9u
cygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9jbWQuaCBiL2Ry
aXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9jbWQuaAppbmRleCA3NWU4YzJhN2ZkZjkuLmMxMzJk
OGU0M2I1MCAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfYXBpX2NtZC5oCisr
KyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9jbWQuaApAQCAtNjAsMTIgKzYwLDYgQEAg
ZW51bSBoaWZfaW5kaWNhdGlvbnNfaWRzIHsKIAlISUZfSU5EX0lEX0VWRU5UICAgICAgICAgICAg
ICAgID0gMHg4NQogfTsKIAotdW5pb24gaGlmX2NvbW1hbmRzX2lkcyB7Ci0JZW51bSBoaWZfcmVx
dWVzdHNfaWRzIHJlcXVlc3Q7Ci0JZW51bSBoaWZfY29uZmlybWF0aW9uc19pZHMgY29uZmlybWF0
aW9uOwotCWVudW0gaGlmX2luZGljYXRpb25zX2lkcyBpbmRpY2F0aW9uOwotfTsKLQogc3RydWN0
IGhpZl9yZXNldF9mbGFncyB7CiAJdTggICAgIHJlc2V0X3N0YXQ6MTsKIAl1OCAgICAgcmVzZXRf
YWxsX2ludDoxOwotLSAKMi4yOC4wCgo=
