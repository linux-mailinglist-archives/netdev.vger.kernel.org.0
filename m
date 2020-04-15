Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 510861AAD1C
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 18:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1415185AbgDOQMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 12:12:15 -0400
Received: from mail-eopbgr700077.outbound.protection.outlook.com ([40.107.70.77]:38433
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1414917AbgDOQMM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Apr 2020 12:12:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dKHAQ+5+goXh1acgHNCj8H5ee37N9gIAqHwYI5au3uRQqG8CaIYokYZP1hrpA9Hm6f+MxZ0uOri2YEnyfPLFDVYtEBf+6GNVFI6zf6BR/tw/ZXGlWGiqTFrxTrp0KEXTmlgqBZoL2LiD87+3fEdn2hW13YIZk85YiJSQR+raRXnFCGeRY2EQbJwy0vBIqna02N+DPPssDDdcbGbGMv0RQRYkQnQry4viN1m1dV+mKCy5yP2DRkjjAiEVDdNlHze5aEXqOy06uynFqIn0Ih2R5aX/QvXUibCvMNIVtCgHNmGkwCqJ4JQDJpzqz10p8Grd+1YRPwmm/vrXBJHtKX0SoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hNKsHEJP/VKZtmDt4JTSPFNDm15L7SxRxvkDxasxFdc=;
 b=IRzfmYfAmXWbKndo29ApRikWMGkIRZ4FuXUVHoCnC9WAuVvQxhDCCIt4I2D86VabWxsv/Dppw/2QgjACBPwDpGvjjBc9D2WrjNL3ms3XgFzvrPrONyrQ3OM6hFeLsKOoVJZHDQMZJA8ZcPDfqmT1r+FOLESR7GLdLGAUGgFUf8vwcDSgQhSDQnCNTI/0e8EWxjG0vrc65jc6Ps31vkIhuMhBwXKXZZzSNLO/fuBThA8MeAiMpo2Co0dxu4uOuzItfqUhchkmPl0m4lkD92GByZq/xU0ecBypy3rnparBmDJw7G3/ef0ye2rjSZu/djAnCPH7/JwMc7hdD4dxUugNnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hNKsHEJP/VKZtmDt4JTSPFNDm15L7SxRxvkDxasxFdc=;
 b=S5zFdA8VZxGG/HPjyz4RT5o7XMuJEzVZ6xjbYdtVtIGlz5b4KnPSLmwGfkn2QFOZlxTtHgqcnG9qWURhSGZf3TP4U6AVbTkYLCJFnU/Zb5wLWiNyU7ZyL4GmiRMWuBoopt3G8IkJ5YQv1wDCWFkchRYJoZ9DmSMcvv9iNN68074=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1408.namprd11.prod.outlook.com (2603:10b6:300:24::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25; Wed, 15 Apr
 2020 16:12:09 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe%10]) with mapi id 15.20.2921.024; Wed, 15 Apr
 2020 16:12:09 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 00/20] staging: wfx: simplify filtering
Date:   Wed, 15 Apr 2020 18:11:27 +0200
Message-Id: <20200415161147.69738-1-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.25.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR1PR01CA0027.eurprd01.prod.exchangelabs.com
 (2603:10a6:102::40) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.home (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by PR1PR01CA0027.eurprd01.prod.exchangelabs.com (2603:10a6:102::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25 via Frontend Transport; Wed, 15 Apr 2020 16:12:05 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 54e93146-d3b8-4f33-b458-08d7e157bf9b
X-MS-TrafficTypeDiagnostic: MWHPR11MB1408:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB1408C32B8A4381D75289D41593DB0@MWHPR11MB1408.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-Forefront-PRVS: 0374433C81
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(366004)(8886007)(8936002)(5660300002)(2906002)(6666004)(86362001)(8676002)(81156014)(66574012)(1076003)(4326008)(52116002)(54906003)(107886003)(186003)(16526019)(66556008)(66476007)(36756003)(2616005)(6512007)(6486002)(6506007)(66946007)(498600001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /PxQhcvCnwdXvcP/Oy5oSwOWizRaVKrF1OYXaACM0cDAbwRvGmp9dUJLZL8cgL8lXS6Ln2bS9IiZl/ea6yNHXv8+NhS1pSxutJWLg0oecJR8kG3L8tN6hvDTtIMw53ntSEw+bV25m6NPInPaL/GLaa69cgfHI4fTcypuZslF4UehujSajFcVZxXyetTuBUoH3g0aoUUmI499HSjvPEzW3o1Eg1/gf3qbNrOh1ZjxiRQBMScu3MZc5veXGjnWXU2jYGfQ4K35f/+9aN5n5SNzZTtk3EKlIKKJ1jZVR/WegsX8c6X2aDEa3BqddUj+xOS0XUhvei7x7xiRxpGAnbyZiImNh+SNWFpltA32eKydIfW0GreqOOZem0wJacH9JceMx3CuljYYSjqIRqv3vZtLLJy6NuginRwUGi/vx3WalKllGMGoQXRZUyzAOO/pJJmM
X-MS-Exchange-AntiSpam-MessageData: KKZLvU+69XnT6g1WsGZ0bxGoFHg4lCEaRKLtb713APgUuBON29Iv7wp8EObgvx+TW/HmHXxB3vCeT8bFAmf6wBQkYi49jjBg7E/6n2vsh4rhE3gUSHq5AK5r9nJBfrIcbkN6Vcr4MT9AA0TCCtu4YOA1GbVv7MaWm5iLIIr2pzVCOURX+rHVNG4FhUr+/k8lJhQSm22KckzyO58JRQ4fww==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54e93146-d3b8-4f33-b458-08d7e157bf9b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2020 16:12:09.3619
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E+uqeTPMkHLkOpWgJs9gGrBXoV1qkU7RDZUZsuMjjGVOE08MvknFC58QmFlahbbSElzwqZ4diiwMIXeszT5ajg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1408
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGZyYW1lIGZpbHRlcmluZyBpcyBtb3JlIGNvbXBsZXggdGhhbiBuZWNlc3NhcnkuIFRoaXMgc2Vy
aWVzIHNpbXBsaWZ5CnRoZSAgd2hvbGUgcHJvY2VzcyBhbmQgaG9wZWZ1bGx5IGZpeGVzIHNvbWUg
Y29ybmVyIGNhc2VzLgoKSsOpcsO0bWUgUG91aWxsZXIgKDIwKToKICBzdGFnaW5nOiB3Zng6IHVw
ZGF0ZSBmaWx0ZXJpbmcgZXZlbiBpZiBub3QgY29ubmVjdGVkCiAgc3RhZ2luZzogd2Z4OiBzaW1w
bGlmeSB3ZnhfdXBkYXRlX2ZpbHRlcmluZygpCiAgc3RhZ2luZzogd2Z4OiByZXdvcmsgd2Z4X2Nv
bmZpZ3VyZV9maWx0ZXIoKQogIHN0YWdpbmc6IHdmeDogc2ltcGxpZnkgaGFuZGxpbmcgb2YgYmVh
Y29uIGZpbHRlciBkdXJpbmcgam9pbiBwcm9jZXNzCiAgc3RhZ2luZzogd2Z4OiB3ZnhfdXBkYXRl
X2ZpbHRlcmluZ193b3JrKCkgaXMgbm8gbW9yZSB1c2VkCiAgc3RhZ2luZzogd2Z4OiBkbyBub3Qg
d2FpdCBmb3IgYSBkdGltIGJlZm9yZSBhc3NvY2lhdGUKICBzdGFnaW5nOiB3Zng6IGRpc2FibGlu
ZyBiZWFjb24gZmlsdGVyaW5nIGFmdGVyIGhpZl9yZXNldCgpIGlzIHVzZWxlc3MKICBzdGFnaW5n
OiB3Zng6IGRvIG5vdCB1c2UgYnVpbHQtaW4gQVVUT19FUlAgZmVhdHVyZQogIHN0YWdpbmc6IHdm
eDogc3RvcCBjaGFuZ2luZyBmaWx0ZXJpbmcgcnVsZSBpbiB3ZnhfaHdfc2NhbigpCiAgc3RhZ2lu
Zzogd2Z4OiBlbnN1cmUgdGhhdCBwcm9iZSByZXF1ZXN0cyBhcmUgZmlsdGVyZWQgd2hlbiBBUAog
IHN0YWdpbmc6IHdmeDogZHJvcCB1c2VsZXNzIHdmeF9md2RfcHJvYmVfcmVxKCkKICBzdGFnaW5n
OiB3Zng6IGFsaWduIHNlbWFudGljIG9mIGJlYWNvbiBmaWx0ZXIgd2l0aCBvdGhlciBmaWx0ZXJz
CiAgc3RhZ2luZzogd2Z4OiBhbGlnbiBzZW1hbnRpYyBvZiBwcm9iZSByZXF1ZXN0IGZpbHRlciB3
aXRoIG90aGVyCiAgICBmaWx0ZXJzCiAgc3RhZ2luZzogd2Z4OiBkcm9wIHN0cnVjdCB3ZnhfZ3Jw
X2FkZHJfdGFibGUKICBzdGFnaW5nOiB3Zng6IGRyb3AgdXNlbGVzcyBjYWxsIHRvIGhpZl9zZXRf
cnhfZmlsdGVyKCkKICBzdGFnaW5nOiB3Zng6IGRyb3AgdXNlbGVzcyBhdHRyaWJ1dGVzICdmaWx0
ZXJfcHJicmVxJyBhbmQKICAgICdmaWx0ZXJfYnNzaWQnCiAgc3RhZ2luZzogd2Z4OiBzcGxpdCBv
dXQgd2Z4X2ZpbHRlcl9iZWFjb24oKQogIHN0YWdpbmc6IHdmeDogZHJvcCB1c2VsZXNzIGZpbHRl
ciB1cGRhdGUgd2hlbiBzdGFydGluZyBBUAogIHN0YWdpbmc6IHdmeDogZHJvcCB1c2VsZXNzIGF0
dHJpYnV0ZSAnZmlsdGVyX21jYXN0JwogIHN0YWdpbmc6IHdmeDogdXBkYXRlIFRPRE8KCiBkcml2
ZXJzL3N0YWdpbmcvd2Z4L1RPRE8gICAgICAgICB8ICA0MCArKystLS0tLQogZHJpdmVycy9zdGFn
aW5nL3dmeC9kYXRhX3J4LmMgICAgfCAgMTIgLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90
eF9taWIuYyB8ICAgNCArLQogZHJpdmVycy9zdGFnaW5nL3dmeC9tYWluLmMgICAgICAgfCAgIDEg
LQogZHJpdmVycy9zdGFnaW5nL3dmeC9zY2FuLmMgICAgICAgfCAgIDEgLQogZHJpdmVycy9zdGFn
aW5nL3dmeC9zdGEuYyAgICAgICAgfCAxNzEgKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0t
LQogZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuaCAgICAgICAgfCAgIDggLS0KIGRyaXZlcnMvc3Rh
Z2luZy93Zngvd2Z4LmggICAgICAgIHwgICA3ICstCiA4IGZpbGVzIGNoYW5nZWQsIDEwMSBpbnNl
cnRpb25zKCspLCAxNDMgZGVsZXRpb25zKC0pCgotLSAKMi4yNS4xCgo=
