Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C32F1CF88D
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 17:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730753AbgELPFp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 11:05:45 -0400
Received: from mail-eopbgr770070.outbound.protection.outlook.com ([40.107.77.70]:42722
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730239AbgELPFF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 May 2020 11:05:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ltCaxKBxARH6ICDDkv9ENs56DCoCC9vZAoZUAbHAj/i0skp+cETRP1E2pjGs92eYHpQqsHjhG97xB+PR3GiNcqoQZDLn/CtHlZxDHhkLbEf8+N2EFBslPMzeIOEu9jXBSw9Uuyt2vWceyekddfQUAbuVo8xLRDqpDEXD2E7aIFDgPgIs0Y3iEfnWBsyiWC8MQi6U+pLnjIab9ZRGXUm54BAASyaUoT93Y9tASjg1RG44Fh8fZ/FrkzJ8Ay24klAJNaiqh8ELJZBHRKY4D6qIKXNMREk9E01fbGwBOiZ2NkKy4UFQqChUDr55xwALP3AnDOI0mj4HrbUFZgQQOZO/Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lMU9prHPQ5lHqZN+StG88B7rwQkzvC3y06Aj7lGDv00=;
 b=F1qdTWeTm5AKpPlGIRToDrrDYmYNLV9ruzP+urPzr8GPuajzuGyLF7ItriWqwEpaMpdYqts78BLOfPgZKX+ZVIWN4czcei0duo7urt8rX17FNgN4ngbZ79rXgMfjUBgU8Qy6HJbcEaKVBUMy5qL1wJx7uBIVyJYj8jh+/MbxM1yDNN1wUT8gNTuS+C/jmt1qnYmWeFfUJwpvYivZi41Ykov41iufh2Ro6zaFPKcvanD9733a1ThVBTQMfNgycYNwBuUsKU/gsy+UJVSS1pTxXEQ+UYoQv4GYE2083fZT7qjud+Px2+0WLaj5JRe49yojEBr9ISrerqHG2SQs87vXzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lMU9prHPQ5lHqZN+StG88B7rwQkzvC3y06Aj7lGDv00=;
 b=NR2NSMXOEe9Y8QSdPocBJekAKOfmxvNg2qNedOfdpQRaX5MPTQ7Wo/G3fXud0DLaCtQSCv1ykBdjHDmTaTqgmt2KumUAXrDzYuHJw3KPbfRgg4DNraoF0CbqB+wHDw8LgwR+yXcy4E3oO024FdL9tU+eGQQn5WhgDZ0ZQi9qoaU=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1741.namprd11.prod.outlook.com (2603:10b6:300:10d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.34; Tue, 12 May
 2020 15:04:51 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da%5]) with mapi id 15.20.2979.033; Tue, 12 May 2020
 15:04:51 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v2 11/17] staging: wfx: declare the field 'packet_id' with native byte order
Date:   Tue, 12 May 2020 17:04:08 +0200
Message-Id: <20200512150414.267198-12-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200512150414.267198-1-Jerome.Pouiller@silabs.com>
References: <20200512150414.267198-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: DM5PR1101CA0003.namprd11.prod.outlook.com
 (2603:10b6:4:4c::13) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (82.67.86.106) by DM5PR1101CA0003.namprd11.prod.outlook.com (2603:10b6:4:4c::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend Transport; Tue, 12 May 2020 15:04:50 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [82.67.86.106]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 524598f1-a049-4321-a735-08d7f685d24c
X-MS-TrafficTypeDiagnostic: MWHPR11MB1741:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB17415AC2876F95CD224EF28593BE0@MWHPR11MB1741.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 0401647B7F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9NG8OIc0qJZlNQo3gd/8+kmHBtAWmGeSdqn8K/h7HIjbjC7Yq4+8IY/vBFaGNo7bDOOJNQ9naAhg3o4bOr3BLcAiXIvsEDIzsqVnpxJt94qM87iCnKWiJQuUDZN3Jw0qCVpl6ASf4D6jtJKyhIQJUoUgZrTCdkw1uyB39I/51J2rn6i03TthBEWprcZ7ANmdBG+bd+pzghHeOwf4c+mQbwKHyET1BnaXC0cUPqLtys8bboxhknajqAaaj7SDC7DovIEdGxHzgOn7CE7ixFp15d0sclQg7QCLWy4TCPXRoVbFkjJE6bIxlNida2OVR3HWpk8HRCYKyb2m4ZfmuYssg3bg28wsYyHBfyV8NjuJjGICzXBhjv/izgsjqzDJzbZ8OnRd5f8ou72LPpo4MEob6vnC6sbS2zBbGSop/GYCC6b11TCx8hx+Ets1+7b4s03P/wQi+3atd0mogLpp0mpD5sMKdId0jd1cDkN/zOaxwxzTgPxBjTT/TIWoi23TkoVas5VCqIS3LkX/dCSgTayFng==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(366004)(376002)(39860400002)(346002)(136003)(33430700001)(54906003)(107886003)(478600001)(8676002)(5660300002)(316002)(1076003)(956004)(8936002)(2616005)(186003)(2906002)(7696005)(86362001)(4326008)(52116002)(6666004)(6486002)(66476007)(26005)(66946007)(66556008)(33440700001)(16526019)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: bRf0hvcre0zkpGwlQOGA2+6rbDE91KdRz1bzxnv4k2EJL2iuXPhqgXNdxaCTLiVEhry2O1hveDup9CKdM/jXLTH47Bo4tSoh0N64z62pJFLS1tdG2bOZjOafi0o+QHS6K/8rgHAT16iO5pLwYKdPMoT+P0TiMUub42x802prXIexmeAAR7YdOPkYY7kGZD5SrReSb2Am18gxJNzkEVjnRKJW6Q99Ciul46fOZfT82o3hpspq/AsY4YH7iW0om49X0yk3JmZ3w1eRS5hOhERaYWGx/TwvGNqEv/6a/ABg03r2cTTpRPGeoZJUIidLzXQltyxooc0nAHr0l6IxrzFXpnb5nKO1snsjtP4dPLNiciNo6LToxiIlXSeyToz2tavxto4wfqxQvV6NOUlE7Gb0QXZdRAj+peG+X/sgQKnTjMlmdr3G0XVUyAbKiUHeyF/aLHWV6Oh/2uup+p/YuMbKWznFZMtBhu6cpxV87LUA1RU=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 524598f1-a049-4321-a735-08d7f685d24c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2020 15:04:51.8085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xLZp7P/zAQhsEiPCTDfbFQaKz+viDOgp985QsiQBz3940Q6SA21n2+7N/DmaW8U7FDsXVb2zyHDKKEg4k9UWzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1741
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGZpZWxkIHBhY2tldF9pZCBpcyBub3QgaW50ZXJwcmV0ZWQgYnkgdGhlIGRldmljZS4gSXQgaXMg
b25seSB1c2VkIGFzCmlkZW50aWZpZXIgZm9yIHRoZSBkZXZpY2UgYW5zd2VyLiBTbyBpdCBpcyBu
b3QgbmVjZXNzYXJ5IHRvIGRlY2xhcmUgaXQKbGl0dGxlIGVuZGlhbi4gSXQgZml4ZXMgc29tZSB3
YXJuaW5ncyByYWlzZWQgYnkgU3BhcnNlIHdpdGhvdXQKY29tcGxleGlmeWluZyB0aGUgY29kZS4K
ClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJz
LmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfY21kLmggfCA4ICsrKysrKy0t
CiAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAt
LWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9jbWQuaCBiL2RyaXZlcnMvc3RhZ2lu
Zy93ZngvaGlmX2FwaV9jbWQuaAppbmRleCA2ZjcwODAxOTQ5YmIuLmJiOGM1NzI5MWY3NCAxMDA2
NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfYXBpX2NtZC5oCisrKyBiL2RyaXZlcnMv
c3RhZ2luZy93ZngvaGlmX2FwaV9jbWQuaApAQCAtMjU0LDcgKzI1NCw5IEBAIHN0cnVjdCBoaWZf
aHRfdHhfcGFyYW1ldGVycyB7CiB9IF9fcGFja2VkOwogCiBzdHJ1Y3QgaGlmX3JlcV90eCB7Ci0J
X19sZTMyIHBhY2tldF9pZDsKKwkvLyBwYWNrZXRfaWQgaXMgbm90IGludGVycHJldGVkIGJ5IHRo
ZSBkZXZpY2UsIHNvIGl0IGlzIG5vdCBuZWNlc3NhcnkgdG8KKwkvLyBkZWNsYXJlIGl0IGxpdHRs
ZSBlbmRpYW4KKwl1MzIgICAgcGFja2V0X2lkOwogCXU4ICAgICBtYXhfdHhfcmF0ZTsKIAlzdHJ1
Y3QgaGlmX3F1ZXVlIHF1ZXVlX2lkOwogCXN0cnVjdCBoaWZfZGF0YV9mbGFncyBkYXRhX2ZsYWdz
OwpAQCAtMjgzLDcgKzI4NSw5IEBAIHN0cnVjdCBoaWZfdHhfcmVzdWx0X2ZsYWdzIHsKIAogc3Ry
dWN0IGhpZl9jbmZfdHggewogCV9fbGUzMiBzdGF0dXM7Ci0JX19sZTMyIHBhY2tldF9pZDsKKwkv
LyBwYWNrZXRfaWQgaXMgY29waWVkIGZyb20gc3RydWN0IGhpZl9yZXFfdHggd2l0aG91dCBiZWVu
IGludGVycHJldGVkCisJLy8gYnkgdGhlIGRldmljZSwgc28gaXQgaXMgbm90IG5lY2Vzc2FyeSB0
byBkZWNsYXJlIGl0IGxpdHRsZSBlbmRpYW4KKwl1MzIgICAgcGFja2V0X2lkOwogCXU4ICAgICB0
eGVkX3JhdGU7CiAJdTggICAgIGFja19mYWlsdXJlczsKIAlzdHJ1Y3QgaGlmX3R4X3Jlc3VsdF9m
bGFncyB0eF9yZXN1bHRfZmxhZ3M7Ci0tIAoyLjI2LjIKCg==
