Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 051ED1D4888
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 10:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728331AbgEOIef (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 04:34:35 -0400
Received: from mail-dm6nam11on2053.outbound.protection.outlook.com ([40.107.223.53]:55808
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728305AbgEOIec (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 04:34:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dkvGPDRhx5zYtXEByF7oAux1HeDwRhjfQOWmC9QIoGCj7GP5TdcCN7jKG5p/OWmUr1U6Fpp8FmwHwykoFbiSiWRQ4ve3bZ9NVDFnygQX2U5LLoW3ZTwFjdFnVYL0iMMKBXzRVmwIkOu+whL5WTdT+479lP+ve1U0xbETa57Gx4/BuqH4zGSPH6Cawu/NLFeT41CQn6mYV/ESJrxPZi9VBMlIjFQznnx1z1twmAzilxoBSSb4QBtNF2Oy4zPp/nz6d0Cb5mOCjsEKzGjgVAOfEkO9Cyaw+2uaSTmQbkxXh/Ffc30BL68leE8My6KuxEojndh0p3aT7PSEiNyzIKt2cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EYjX8N6WvaJV/3mN6jM7EZ7iDmTvplyybVaBshUG9T8=;
 b=HAkVHc8X5sYg2p9sZ7JCx4o07BRW38JJ0hokk5vzsQ8TG3+SdLa4+Ao8NwQGD44SiAYLqR9g+qiYbJSGY7GEZ58DxvRaja1SdfL0yy+cajZ5UVJsoWVnLA3noQAUB3bJ9zvzTvq1Wv25tWg5Wh4du+zaO66ydiv9e8FuW2e4qYjLj4lbaoLj+ZmDE3KzcTnrUqf9gbRge1Gafehd6izz4eRSG2qO09QDkkjaM0JWauzPmjSP4rru7hDme6UbAxob9fLeBh+jVXohILUS821GUFCrAQ001OQNxXcel1ZO2+YrV2EhMQX3wzIUaLu3UiFJUQthhx8X3a1BN0O4YHzYKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EYjX8N6WvaJV/3mN6jM7EZ7iDmTvplyybVaBshUG9T8=;
 b=p/34v0f1C2OqxBuR+GJ8fLDhXlcqdDp6PZuFO3savRgNfk9WZMZK2K9T9WGr6Gr4qyBy414pRUtTQ+hgnX1qtsCJqX/V5jACg6TWyO/OjVMG9ifhnUZpMTDPSdGyZjaLOci4X8JHMLn76nIj4BtgVxADkFN4JARzu3/Yb49/kD8=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1310.namprd11.prod.outlook.com (2603:10b6:300:28::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26; Fri, 15 May
 2020 08:34:17 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da%5]) with mapi id 15.20.3000.022; Fri, 15 May 2020
 08:34:17 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 15/19] staging: wfx: drop unnecessary filter configuration when disabling filter
Date:   Fri, 15 May 2020 10:33:21 +0200
Message-Id: <20200515083325.378539-16-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200515083325.378539-1-Jerome.Pouiller@silabs.com>
References: <20200515083325.378539-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR0P264CA0076.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:18::16) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.home (82.67.86.106) by PR0P264CA0076.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:18::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.24 via Frontend Transport; Fri, 15 May 2020 08:34:15 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [82.67.86.106]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f31271fd-43d1-4bc4-1c2f-08d7f8aac154
X-MS-TrafficTypeDiagnostic: MWHPR11MB1310:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB1310136C4325FDC62D7F025093BD0@MWHPR11MB1310.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1360;
X-Forefront-PRVS: 04041A2886
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7spwvnyZz1zDCdwFVLqPTMw9uigAeEJCaKbESp3Wd7/Yu43irsj7sTV4vuDxdab1yBgnfhIv8vprm2uXoxH9F4frgnrLKJ41Y84ly1mcXHEp8iphxHfo/+vKrjXpGG7cgTggft2aXU6Ky+PopnHRkx2i+zNxLFwmEYZ3QjX2xc9RdVSXfjLKSWj+m2VeUYbrqHYvRsYVTbw5UdDXk00r9sC+hvcBLHlVxS2fH9LMVJikDwH3wuaXomqVDEBzoWcUpq+Yfx1u5a35ww7YI8P7J6WCuF7Sy+W+xn/oRxkfjhXy/6yLoF9IFtxPEWGET4uFi70lCalPQhFn9aS2WdhZ6R75a/o2Dg+sbal0LEjESxyAtxKJeYhagLKK3mDTlkmYs6bqrZxpBF+ryqOPIiajPHtgjpJfKRiz08vzRV7vroh/4/BBks7BSE9NiZbJVfnX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(136003)(376002)(366004)(39850400004)(396003)(8886007)(66556008)(186003)(6512007)(4744005)(66946007)(6506007)(36756003)(316002)(66476007)(26005)(52116002)(16526019)(6666004)(54906003)(2906002)(2616005)(478600001)(66574014)(107886003)(956004)(8936002)(86362001)(8676002)(6486002)(5660300002)(4326008)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: mY0kyWcsGMoETkrbbtgi+BWDTKhHnrPQtKMReK2QcokXzHYyozw/zipmcgvDnpTf03f88KdC1KubO/GmWDAjOSnjT2l5Z9WisVN1K53bymp0nvXr8hhkcmlAwZuuCmyBnehLHNRG3panMH1FYgO38T56FUoskspF6Hb8eB/66riaeGEZDZ4yRiJO1LowO9Cq7/kxLcx+zR3yDbaIQQtpeBmz5PfjUNaAk5S8nzjjpITlOlkrPUvmaH7Q4v3YVyRdcC7QOUVJ2lNjfRn5Jx6YtKK7BdWSxGYFG8b74WG8Y8NsNiAcLLrSS8690lkjq2eRiAnZqQQd510Sk2AJ8SJeLgxJckLv1Hvof2lw7ZCBqwtPr9GA2ORZxdihlQTix4Qq7omE5/T2SCDHkcVTMNOGkWS6xExpjjF4l/EFeh0dkjmwsfqwP9/uWHDqJItplK35S8/uRyiqTmxHOJ8sd0+UFG0ohvwFITwoc3+PlnkV4Zs=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f31271fd-43d1-4bc4-1c2f-08d7f8aac154
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2020 08:34:17.0726
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B/E9qCeCJYuiYUt7By3Kvd1mwq456uyT6LO40NoM3Z560Rz5cLcOqmiZqX2lTj9lWyqsBG3gsyMKIKxy/MR15g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1310
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKQ3Vy
cmVudGx5LCB3aGVuIG1hYzgwMjExIHdhbnQgdG8gZGlzYWJsZSBiZWFjb24gZmlsdGVyaW5nLCB0
aGUgZHJpdmVyCnJlc2V0IHRoZSBmaWx0ZXIgdGFibGUgYW5kIGRpc2FibGUgdGhlIGJlYWNvbiBm
aWx0ZXJpbmcuIE9ubHkgdGhlIGxhdHRlcgphY3Rpb24gaXMgcmVxdWlyZWQuCgpTaWduZWQtb2Zm
LWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQog
ZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyB8IDEgLQogMSBmaWxlIGNoYW5nZWQsIDEgZGVsZXRp
b24oLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jIGIvZHJpdmVycy9z
dGFnaW5nL3dmeC9zdGEuYwppbmRleCAwY2I3MzE1YmIwNTAuLjU3MzA0ZWQ0MmU3OSAxMDA2NDQK
LS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4
L3N0YS5jCkBAIC04NCw3ICs4NCw2IEBAIHN0YXRpYyB2b2lkIHdmeF9maWx0ZXJfYmVhY29uKHN0
cnVjdCB3ZnhfdmlmICp3dmlmLCBib29sIGZpbHRlcl9iZWFjb24pCiAJfTsKIAogCWlmICghZmls
dGVyX2JlYWNvbikgewotCQloaWZfc2V0X2JlYWNvbl9maWx0ZXJfdGFibGUod3ZpZiwgMCwgTlVM
TCk7CiAJCWhpZl9iZWFjb25fZmlsdGVyX2NvbnRyb2wod3ZpZiwgMCwgMSk7CiAJfSBlbHNlIHsK
IAkJaGlmX3NldF9iZWFjb25fZmlsdGVyX3RhYmxlKHd2aWYsIDMsIGZpbHRlcl9pZXMpOwotLSAK
Mi4yNi4yCgo=
