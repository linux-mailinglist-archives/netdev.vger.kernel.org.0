Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CCC019AA55
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 13:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732674AbgDALGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 07:06:42 -0400
Received: from mail-eopbgr750070.outbound.protection.outlook.com ([40.107.75.70]:46082
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732431AbgDALFL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Apr 2020 07:05:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OyuqE/tBDSZxMzwEkCKdSiIy+kgsn0n/RLXKFXvnXHoSgjte5T4e0TMHUgx9CEfu/hvYW2vje2l+RwS3ra32EOV0QRzkcTfv/Wq90ez4aV0a0hr/K/KIKf+lg93Uuc8cPtN40AWr3xEE1M80csF2+aM8Mm6CdUF0Nlvtnx2zMN0SoXiJ+2KgPctX+VqdARCOga/6uj6OkVsZb9BUklgeZH+b2uwBNfn+sLgOX4YF/uoLHB7iTXpgv1f1fm3jERqznnW3Ywfo750Szh0NRGst6uC48t2WffJ3mcPyDvzczUPz5r+X7x++7uzZXiaPxtNn66qTcM52bemEKZAUz9hMrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w5RE61aEh8TA6jceHMMeJhKCrBm8qbsZvDmJckrPQdc=;
 b=ItZhHK9MYMcbYRxfT05dNZI7KrM1iQQ6ThhOQeBVnVsCzkG6iOm/6xH6y0OCmCK61qA3Zav8FlV1uhLjIhsqj4oZdZag3krPUzCSOr4cDrMjh1t2y8hpqhyBdHHFafS+lki2wMunGZHgV7p2AD4K3KCKgalmRRgk5SKWAZLATB4jYxA10YkD6yeAECRClYjNPLPiDbczxsv+W5p9wkBNdHiK2umVm2kK21SPHQ+z7Y8+gpm+b1iC2jiQFGbRbLYNsbhuNRdoDaOoAvO1OG9xHJA41/zGRRBposZ0ScZyoOC3lq/GYicaes4w+HPv+BZ/KkqHxzbHRnV6DUh8Qavvvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w5RE61aEh8TA6jceHMMeJhKCrBm8qbsZvDmJckrPQdc=;
 b=RgY7f7V0FiTRJd9W1erFykLxXLWZ5XDIudtghoUCfe1rkgUK62D3TFTeMXma/xbG2dWR9ihOUjY3xwPhUXpdGQkthct6JJjLZkAtiLF30a5mUl5Sc1aN+4+osoP6er3znCh0B7/o7tAvHdbdiouMhgVSk7hnhIS9NPav3UqURqY=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
 by MN2PR11MB4285.namprd11.prod.outlook.com (2603:10b6:208:191::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20; Wed, 1 Apr
 2020 11:05:07 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3%7]) with mapi id 15.20.2856.019; Wed, 1 Apr 2020
 11:05:07 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 23/32] staging: wfx: drop now useless field edca_params
Date:   Wed,  1 Apr 2020 13:03:56 +0200
Message-Id: <20200401110405.80282-24-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:1265:30ff:fefd:6e7f) by SN4PR0501CA0156.namprd05.prod.outlook.com (2603:10b6:803:2c::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.9 via Frontend Transport; Wed, 1 Apr 2020 11:05:05 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:2435:66a0:1265:30ff:fefd:6e7f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b28649f4-14d1-4c49-46fe-08d7d62c8943
X-MS-TrafficTypeDiagnostic: MN2PR11MB4285:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR11MB4285225CD1E63950667BB82093C90@MN2PR11MB4285.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-Forefront-PRVS: 03607C04F0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4063.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(136003)(366004)(346002)(376002)(39850400004)(396003)(7696005)(8676002)(1076003)(16526019)(186003)(6666004)(5660300002)(86362001)(4326008)(66574012)(52116002)(478600001)(66946007)(66476007)(54906003)(36756003)(8936002)(316002)(81156014)(6486002)(2906002)(66556008)(107886003)(81166006)(2616005);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hmHILPmTYSTaHZ8WCEY0xJi70LX6RPxqUb8eHFO7R1SHZxtB0Kv5ndwefKGwxSmvySX9ngx0QqBL45AiGyK8Awhs4yPWH3+fGPl2yzTZzRHMHkd1PfB3pIW4v81gQJDdYFszA4YZzxB8TFi0zn76UIjvG2TljU2af+e4J9pk0JhnpgvKE6xEzRhENCSIH0KZoetUvNeGRCvn+joW/zbXvI+R/VWgTP38aIP8R9QZbKFo3p47PfPDah0T+dJcsmzTsJCoAyQII0HSoHQfGbXOV/hPEqH0+moT32FtkEaryfvWJZqn2rNbbcpURjIcyZQVmUuOagvjhGg5uc2psTz3zia+zd8MTpxr7Gw3I3dc76ltEHtAh6EnQGTjbjREjPQhY9QTVZWvZ51zGLTz5VmKtt/ogTzNwY7+C5JJczu1rkD+ex8JKJM88X+iAkdXx8wk
X-MS-Exchange-AntiSpam-MessageData: NKqazT9u1bmKhdCmpJENthVZlJjuMjbOEPzNiYIs5EcloXEI1uhP9+CKn7N1VyM9WfyhzI3Ps3RATvyUsbsejHXn0PrqVINCbKMmzrVa237R+4lXXxjcc7LCgbosDQMWgSVA2st2t7/rQJc2zJTZzKP4FfCxw5UdOlj0DsMfsHZFVrvzNNw+1Y6WKNUCR0pp2rX0QjRQJ2GJ5zEzfvvAXQ==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b28649f4-14d1-4c49-46fe-08d7d62c8943
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2020 11:05:06.8915
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RGq1e84p6mbXbCkAJARsHLnfIWN0AyAo6/+RkoBnu2PPkNs6on2mbFFbOxZ88gIFBjfXmgNWg8vM62+pdHzjiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4285
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU2lu
Y2Ugd2UgZG8gbm90IHJlbHkgaW4gUW9TIHBhcmFtZXRlcnMgdG8gY2hvb3NlIHdoaWNoIGZyYW1l
IHRvIHNlbmQsIGl0CmlzIG5vIG1vcmUgbmVjZXNzYXJ5IHRvIGtlZXAgYSBjb3B5IG9mIEVEQ0Eg
cGFyYW1ldGVycy4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91
aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jIHwgMSAtCiBk
cml2ZXJzL3N0YWdpbmcvd2Z4L3dmeC5oIHwgMSAtCiAyIGZpbGVzIGNoYW5nZWQsIDIgZGVsZXRp
b25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyBiL2RyaXZlcnMv
c3RhZ2luZy93Zngvc3RhLmMKaW5kZXggZTFkN2EwNjcwYzlkLi4xNWYwMGVhODQwNjggMTAwNjQ0
Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dm
eC9zdGEuYwpAQCAtMjk4LDcgKzI5OCw2IEBAIGludCB3ZnhfY29uZl90eChzdHJ1Y3QgaWVlZTgw
MjExX2h3ICpodywgc3RydWN0IGllZWU4MDIxMV92aWYgKnZpZiwKIAogCW11dGV4X2xvY2soJndk
ZXYtPmNvbmZfbXV0ZXgpOwogCWFzc2lnbl9iaXQocXVldWUsICZ3dmlmLT51YXBzZF9tYXNrLCBw
YXJhbXMtPnVhcHNkKTsKLQltZW1jcHkoJnd2aWYtPmVkY2FfcGFyYW1zW3F1ZXVlXSwgcGFyYW1z
LCBzaXplb2YoKnBhcmFtcykpOwogCWhpZl9zZXRfZWRjYV9xdWV1ZV9wYXJhbXMod3ZpZiwgcXVl
dWUsIHBhcmFtcyk7CiAJaWYgKHd2aWYtPnZpZi0+dHlwZSA9PSBOTDgwMjExX0lGVFlQRV9TVEFU
SU9OICYmCiAJICAgIG9sZF91YXBzZCAhPSB3dmlmLT51YXBzZF9tYXNrKSB7CmRpZmYgLS1naXQg
YS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3dmeC5oIGIvZHJpdmVycy9zdGFnaW5nL3dmeC93ZnguaApp
bmRleCA2MTg5OWNkNzk0MmIuLjZiNWI5NWE0NWU2MCAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFn
aW5nL3dmeC93ZnguaAorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3dmeC5oCkBAIC05NCw3ICs5
NCw2IEBAIHN0cnVjdCB3ZnhfdmlmIHsKIAlzdHJ1Y3Qgd29ya19zdHJ1Y3QJdXBkYXRlX2ZpbHRl
cmluZ193b3JrOwogCiAJdW5zaWduZWQgbG9uZwkJdWFwc2RfbWFzazsKLQlzdHJ1Y3QgaWVlZTgw
MjExX3R4X3F1ZXVlX3BhcmFtcyBlZGNhX3BhcmFtc1tJRUVFODAyMTFfTlVNX0FDU107CiAJc3Ry
dWN0IGhpZl9yZXFfc2V0X2Jzc19wYXJhbXMgYnNzX3BhcmFtczsKIAlzdHJ1Y3Qgd29ya19zdHJ1
Y3QJYnNzX3BhcmFtc193b3JrOwogCi0tIAoyLjI1LjEKCg==
