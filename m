Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB57E1C5597
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 14:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728997AbgEEMiP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 08:38:15 -0400
Received: from mail-eopbgr680041.outbound.protection.outlook.com ([40.107.68.41]:21169
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728905AbgEEMiP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 08:38:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GzWLUBO5GHXTdpWwmDm/nccXzimAxdW9PqUW+l/MfGnj/mDQmLmd/wq4S6oUl0XnzzjFsOi5Aj8SFq0NYsbs1qQjiN/BybaRePzNVcdQ5+IjpwajugRksg7Dud3GImWHkJF+am2FBdinWuy1AYaXzRwINd+Vf8bGeLOlvTFYiGBEvus4NI78PsjAodCZRB/kp97HdzXEwf18y+pXJlti3XMzTWrwP7UFa0PZZ6k+A1cLuK5OdB0Shv6pjLLfnS9w1X5dRBJm//nCQWmuktGs026h0zddS9GAXFvM3sv53ANImI1Ycnsh4RcX1fLZ59VDocuOSK/CsYwzu0oH1gks1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KR0bsZNq8Uch+UpggPkYnAPAR/hLyI/fS9/AH+R3SIQ=;
 b=nFWM81WSM1aCA5jzoHWZ+VbC7q5MjobArinXZNz3UE/kM1m7rP8kIbYMmvFaa4iSzJLgCz8Nkbh2Q8L7A0UkYCe+aS6h/35siMbQQcW8pKBq8dK//UeM2r7tgenMnJ62xU88l6PWrdeq4r2N5yWbfFy9CkvZCmSSEIUDRJMP+qaHbR2LnAZpdmJ9H81jEwpS/p2GsihT08DxRKeXSeXI8yGW7xbBW7Uqp+jjeE39lzHn0PFH7fSA29cBHISDrofyGvV3ptVVOXVa2QD9k0B5vziHLMGbT68p3hX3a0vJEaSaifry+QtJGPmYetbDJx9wN79oox58q4FVzrNihkU/WQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KR0bsZNq8Uch+UpggPkYnAPAR/hLyI/fS9/AH+R3SIQ=;
 b=T3vXw2PqQ/1jNaXqjpQeQO/nnsgN8w247h3Ijm5I2j6Objo9DXq1jlJklWBBnMkN8EtYkbNppySCW62fPo5ahT/xKVehpiMp+4EoopCd7PQn7VLEjklxlWPh8wZH816l5ybGDnLpLiyceaEkDDmKMjhxbYcU3F2cWfnTVvUTnKY=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1824.namprd11.prod.outlook.com (2603:10b6:300:110::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19; Tue, 5 May
 2020 12:38:11 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe%10]) with mapi id 15.20.2958.030; Tue, 5 May 2020
 12:38:11 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 00/15] staging: wfx: fix Out-Of-Band IRQ
Date:   Tue,  5 May 2020 14:37:42 +0200
Message-Id: <20200505123757.39506-1-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.26.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR3P189CA0022.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:52::27) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.home (2a01:e35:2435:66a0:1265:30ff:fefd:6e7f) by PR3P189CA0022.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:52::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Tue, 5 May 2020 12:38:09 +0000
X-Mailer: git-send-email 2.26.1
X-Originating-IP: [2a01:e35:2435:66a0:1265:30ff:fefd:6e7f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 200af7fa-2400-4c3a-e0e7-08d7f0f12bd6
X-MS-TrafficTypeDiagnostic: MWHPR11MB1824:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB18244966F79FF7A23ED201BF93A70@MWHPR11MB1824.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0394259C80
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KFAvr10akcvSxe/OtH9cq7UdZTzQ7Gllxe8RK+zkzHcPlDJZ9Ghvr+XcLriA1v7y6nouxaoXX2XihCevSDguec63Vz/JTLAj+IQYoLxwgbHWeKlI0DJCgIkpTmRe0HgMkA+q5VWDNG/hXjM1YkXvqth3zdOAK17yYCOOa/+9airZaNrhxKgtbRQpHfxl3SuAUOfrMZz0Jq+94VlORT5ZIosgXYSSPCln8EHjnFhiPhatp6T7+PssCqxyggEpSUBXd4kkKqDV6pSNo3ExN1+sRLPr5Yd7ZLrGBCGxGaLXVA7P6uyxvbXKb+4jqC6MkcJw6vCMek7MfgV8JT5Ox30txjTpwDJmRe5/D8BJhekIvlm4M6Eh4I02ROOsIZkASk9mOghQZC1aoCgra5CIbCMEQBVKJeL7PH763rf/4hBokCqsNj7ytbo1PcfUe40Lt8Y/adQ7sQJtKVQfdNH1f1iYkF0gX4DodLCqgSfzV9HEPdtK2Y8+SISYMqIgLV69G+GvPbjw3vHZFLZ0AUsEJgzOmA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(396003)(39850400004)(366004)(376002)(346002)(33430700001)(86362001)(6666004)(107886003)(8886007)(1076003)(6512007)(6486002)(36756003)(5660300002)(2906002)(66476007)(6506007)(16526019)(186003)(52116002)(66946007)(66556008)(54906003)(2616005)(4326008)(8936002)(8676002)(316002)(33440700001)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 2LqREWaansKOWHiuaSi35h+vRvxQs4RMhjyxxCXnRov9wdHZ5x9AuSDSx9R/01QB9XP6E4O71lbuChiRZ9/3vWfetoMIrJFo9jm1ToQNJYv9p/FEMPIvy7NG64rJXw8cX8x7uhOFTuLQ4wIdaTPBr0gZs42G7zVfGipWg8x1XkTxIwEW0vT6kzzhAQO5u4awqhYuts1Figyt96voccA002ig6f4NNQTYY9ZlL+gvHDUx59O/3xJ518S5lg7reh4VpSzTFgI6F9Thpu7iZX+BB5ARoofac4K2uJaazVXbygTen2m8cFt2z/1AYzDiWyVY7KGQzfg/XW8JMISbn6Oj8QVelFREi7gTd08F64b/uVEKEX3jpVYvT3oQ3ILJM19RVSBDYtDhVkgwkfz0DCkQiEZ8YbJeGsHo1ha5lEKAwXVH9jLRTxI4Pcw6pjJ3hylpdOW3V1RZcvTn0YSC6DAuWlOJ1Nmf6YG58neEdxnJytTVcduzjQB4MCfPDmy2iBr3wD3xwdPwq8SsDlupKzFCG/ZUai3nav3FLfjr8EUz4va/UpepGEvTZNrx6Da4rvQu3Dn2+Yno4iJ4cutRQI22mCLTFYs073zF8ihjyF3Ndyi1CgYd36tC8/AtG54iNe+LB5XP0evm93AevsTaj8PY4iFdkGlfN7NMLdS0a3HAodDovhSlSuzY79K7SYGskOagQnlSD58WQciJpzvZLPVkgs9NPC2+/wjZo1WszaZCgpxl9SC+C6ocD0GmL0i5MTi+LCY/Q7PlyHyIQki+VtNexI+6Fu4CVr+8MJ7AGH2JKuSTDYLvFROBPhK1MZtQHDMa4nHb+1iRUrtDYbadWZ8ppz4434KBBKzAWwYuftVBgOc=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 200af7fa-2400-4c3a-e0e7-08d7f0f12bd6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2020 12:38:11.2850
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DWwK0qb4zJzXNlQgarUYhFQqcPJycStt6oZZ5/mDPLHAt7lpVW24Dla2dMd6WClHf5GAqvNxUt+ERIpOe4Piow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1824
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IFdGMjAwIGNhbiBiZSB1c2VkIG9uIFNQSSBhbmQgU0RJTy4gV2hlbiB1c2luZyBTRElPIGJ1cywg
dGhlIGRyaXZlcgpub3JtYWxseSB1c2UgdGhlIGluIGJhbmQgSVJRIHByb3ZpZGVkIGJ5IHRoZSBT
RElPIGJ1cy4gSG93ZXZlciwgV0YyMDAKYWxzbyBwcm92aWRlcyBzdXBwb3J0IGZvciBhIGRlZGlj
YXRlZCBJUlEgbGluZS4gVGhpcyBmZWF0dXJlIGlzIHVzZWQKd2hlbiBpbi1iYW5kIElSUSBkb2Vz
IG5vdCB3b3JrIG9yIHRvIGFsbG93cyBzb21lIGtpbmQgb2YgV2FrZS1Pbi1XbGFuLgpUaGVyZSBh
bHJlYWR5IHdhcyBhbiBpbXBsZW1lbnRhdGlvbiBvZiBPdXQtT2YtQmFuZCAoT09CKSBJUlEgaW4g
dGhlCmRyaXZlci4gSG93ZXZlciwgaXQgZGlkIG5vdCB3b3JrIGNvcnJlY3RseS4gVGhpcyBzZXJp
ZXMgbWFpbmx5IGFpbXMgdG8KZml4IHRoYXQuIEl0IGFkZCwgaXQgYWxsb3dzIHRvIHVzZSBlZGdl
IG9yIGxldmVsIElSUSBhbmQgdW5pZnkgdGhlIElSUQpoYW5kbGluZyBpbiBTUEkgYW5kIFNESU8u
CgpUaGUgNiBsYXN0IHBhdGNoZXMgYXJlIGNvc21ldGljLgoKSsOpcsO0bWUgUG91aWxsZXIgKDE1
KToKICBzdGFnaW5nOiB3Zng6IGFkZCBzdXBwb3J0IGZvciBoYXJkd2FyZSByZXZpc2lvbiAyIGFu
ZCBmdXJ0aGVyCiAgc3RhZ2luZzogd2Z4OiByZWR1Y2UgdGltZW91dCBmb3IgY2hpcCBpbml0aWFs
IHN0YXJ0IHVwCiAgc3RhZ2luZzogd2Z4OiBmaXggZG91YmxlIGZyZWUKICBzdGFnaW5nOiB3Zng6
IGRyb3AgdXNlbGVzcyBjaGVjawogIHN0YWdpbmc6IHdmeDogcmVwYWlyIGV4dGVybmFsIElSUSBm
b3IgU0RJTwogIHN0YWdpbmc6IHdmeDogdXNlIHRocmVhZGVkIElSUSB3aXRoIFNQSQogIHN0YWdp
bmc6IHdmeDogaW50cm9kdWNlIGEgd2F5IHRvIHBvbGwgSVJRCiAgc3RhZ2luZzogd2Z4OiBwb2xs
IElSUSBkdXJpbmcgaW5pdAogIHN0YWdpbmc6IHdmeDogZml4IG1pc3NpbmcgJ3N0YXRpYycgc3Rh
dGVtZW50CiAgc3RhZ2luZzogd2Z4OiBmaXggbWlzc2luZyAnc3RhdGljJyBrZXl3b3JkCiAgc3Rh
Z2luZzogd2Z4OiBwcmVmZXIgQVJSQVlfU0laRSBpbnN0ZWFkIG9mIGEgbWFnaWMgbnVtYmVyCiAg
c3RhZ2luZzogd2Z4OiByZW1vdmUgdXNlbGVzcyBoZWFkZXIgaW5jbHVzaW9ucwogIHN0YWdpbmc6
IHdmeDogZml4IGFsaWduZW1lbnRzIG9mIGZ1bmN0aW9uIHByb3RvdHlwZXMKICBzdGFnaW5nOiB3
Zng6IHJlbW92ZSBzcGFjZXMgYWZ0ZXIgY2FzdCBvcGVyYXRvcgogIHN0YWdpbmc6IHdmeDogdXNl
IGtlcm5lbCB0eXBlcyBpbnN0ZWFkIG9mIGM5OSBvbmVzCgogZHJpdmVycy9zdGFnaW5nL3dmeC9i
aC5jICAgICAgICAgfCAyOSArKysrKysrKysrKysrKysKIGRyaXZlcnMvc3RhZ2luZy93ZngvYmgu
aCAgICAgICAgIHwgIDEgKwogZHJpdmVycy9zdGFnaW5nL3dmeC9idXMuaCAgICAgICAgfCAgMiAr
CiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2J1c19zZGlvLmMgICB8IDY0ICsrKysrKysrKysrKysrKyst
LS0tLS0tLS0tLS0tLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2J1c19zcGkuYyAgICB8IDUwICsr
KysrKysrKysrKy0tLS0tLS0tLS0tLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV9yeC5oICAg
IHwgIDMgKy0KIGRyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jICAgIHwgMTEgKysrLS0tCiBk
cml2ZXJzL3N0YWdpbmcvd2Z4L2Z3aW8uYyAgICAgICB8ICA2ICstLQogZHJpdmVycy9zdGFnaW5n
L3dmeC9oaWZfcnguYyAgICAgfCAgMiArLQogZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHguYyAg
ICAgfCAzMCArKysrKysrKy0tLS0tLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4LmggICAg
IHwgIDcgKystLQogZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHhfbWliLmMgfCAgMiArLQogZHJp
dmVycy9zdGFnaW5nL3dmeC9oaWZfdHhfbWliLmggfCAgNCArLQogZHJpdmVycy9zdGFnaW5nL3dm
eC9od2lvLmMgICAgICAgfCAxNiArKysrLS0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9rZXkuYyAg
ICAgICAgfCAgMiArLQogZHJpdmVycy9zdGFnaW5nL3dmeC9tYWluLmMgICAgICAgfCA0MyArKysr
KysrKysrKysrLS0tLS0tLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvbWFpbi5oICAgICAgIHwgIDQg
Ky0KIGRyaXZlcnMvc3RhZ2luZy93ZngvcXVldWUuaCAgICAgIHwgIDIgLQogZHJpdmVycy9zdGFn
aW5nL3dmeC9zdGEuYyAgICAgICAgfCA0MCArKysrKysrKystLS0tLS0tLS0tLQogZHJpdmVycy9z
dGFnaW5nL3dmeC9zdGEuaCAgICAgICAgfCAgMiAtCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3dmeC5o
ICAgICAgICB8ICA0ICstCiAyMSBmaWxlcyBjaGFuZ2VkLCAxNzUgaW5zZXJ0aW9ucygrKSwgMTQ5
IGRlbGV0aW9ucygtKQoKLS0gCjIuMjYuMQoK
