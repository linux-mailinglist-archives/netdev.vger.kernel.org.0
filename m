Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E55BB167CF8
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 12:57:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728656AbgBUL5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 06:57:20 -0500
Received: from mail-eopbgr760043.outbound.protection.outlook.com ([40.107.76.43]:28579
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726934AbgBUL4Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Feb 2020 06:56:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eP8arfOgRqSNn3QHFSg6EJBWK47PV84J7ymhHYF/Zx/Ts0Dtpp+eEw03DwUPHXgrL6EJ9qjb1FcjQk97qR+TOoO9PMJnhZ/JXzcs+Ar4OYcDcjQg2lGVGQeH1yxgpSi9dTQUD/H8ZjbgXbvJkC0mWnPWxffHHkRp63SFGwYRNkj7jg2E56o/6gZErbAdwOejPujhj8w1F5kFT7VPrv/JIkxkisotCJ/YeaEyQWohK+RFj0r+rZSdN6r2rJ2/Bq0Vnn80X29u+ZkkM/l6nixz9ratGZYXIQbOrVfB+OIx0PgvUzmx5nPrHz5GRzzDpYVZwh6zbXgPp4GAGIBrvU32XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kpmE+FLwHhMiA8/AhyQ44C82l8XnVJHToF+gYr5fb0o=;
 b=UnLFTFr4IgW5EiyJUY8/LjD2oySCKRVDHYTLssuEa3ghK9a4kE3t88OSXw66gXTqwrkbc2DtgBWeXqWqLfyi4ZitKDQk/vawPquEsfWrVvKwY6ZKUfjyhtNhxWcB4lOuWI1Gfcb+IkdBlNvZvRB7E8o7fGy0FyffGg1DyHAOVb+4oXFmkL80w/ux+5CJ0weceIYJQWqQngekbAmg3dzgaZOMGfmxDh7ZeK7DHKmgpLqQDYhE3ELaXDuFvGgy6FvjRWHdmgeis0FW5wtbMZvQN/0frZOBOl8fUX5OKo7FVXduSnqj2vGzcmeLVAoRXLu/rr1lj2coPler5ms69umRtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kpmE+FLwHhMiA8/AhyQ44C82l8XnVJHToF+gYr5fb0o=;
 b=gNfm1P1EgXROBAND5Pt4OJM9rr7ZrZA3gnVyFRvhWakGZZzm46/tnitev6aE8/Eiy6KteBC5oWTkFj79uEU9gGkjyuyk9StWOSJPofHprq3JT+xzYPRQykigJdEzK74Mqll+EOFBoH56VZh06Oh85T5583NzKhsDkFw9RMgKY/s=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
 by MN2PR11MB4662.namprd11.prod.outlook.com (2603:10b6:208:263::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.17; Fri, 21 Feb
 2020 11:56:22 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3%7]) with mapi id 15.20.2729.033; Fri, 21 Feb 2020
 11:56:22 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 03/10] cfg80211: drop duplicated documentation of field "registered"
Date:   Fri, 21 Feb 2020 12:55:57 +0100
Message-Id: <20200221115604.594035-3-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200221115604.594035-1-Jerome.Pouiller@silabs.com>
References: <20200221115604.594035-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR0P264CA0137.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1a::29) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PR0P264CA0137.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1a::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Fri, 21 Feb 2020 11:56:21 +0000
X-Mailer: git-send-email 2.25.0
X-Originating-IP: [37.71.187.125]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9175172f-26f1-44d2-aeba-08d7b6c511bf
X-MS-TrafficTypeDiagnostic: MN2PR11MB4662:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR11MB46623F3A3B0EC89B822122F893120@MN2PR11MB4662.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-Forefront-PRVS: 0320B28BE1
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(396003)(346002)(39860400002)(366004)(136003)(376002)(199004)(189003)(36756003)(86362001)(8676002)(81156014)(478600001)(8936002)(81166006)(7696005)(52116002)(66946007)(2906002)(66574012)(4326008)(107886003)(6916009)(1076003)(66556008)(6486002)(66476007)(6666004)(5660300002)(956004)(54906003)(316002)(2616005)(186003)(16526019)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4662;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PvpHDd9JsN3tUN5ighTEqikZ7Lp6o4kRIlvasKwadngdE2JPaFGqu0FBdZ8yQJHDrPfBIn17gxd2cllVcvZutWoWHM7xQ0jpQqibkMeFnLJ1iVrVEhtb/L+hOMBWtpdFX+BLl5AmacKi4/kDJXbw4xkS35SxHt+F5llbIGfHbxeBpAwmRG4dSxhgWRD889vsPTaGgrc6qXlkAvs7qOHiVe4nhk/L+eMvylslMnlk4bquZPJEoudaApVtrIatgw7dcB2pA5v1TW8iUk7tsGH4LnrO4Lz8MytPsgFT1xsO49Zi5znQ/LL54/btQhA8Q8Knvug+eZ+5ED9QpzlNC4ZZYVaEptFZa3O9tU2gPxyyCqGyA2R0InLybVlVqkhx+ahkdLYhLXX0PY2IHIIHViWPsKMLnGEBTD6n+Oy8i14kz6hqJVoquYhQq7/PAShCjt7M
X-MS-Exchange-AntiSpam-MessageData: v7saaOdzWL0UW32vEKWeltHy7wVsW2VVJQbXeCqcnQAo/JmyRXYu2RCdOZW63EiPxoEVwPqA/kvasnpCLmcLkV4iukLYn80erwCAbBF01DcKiKB4+Kik03fvdy95Ph5Q50NgP0viR1mp+rpS0LPS+A==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9175172f-26f1-44d2-aeba-08d7b6c511bf
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2020 11:56:22.0480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V+1lcdjCOUGlg9U0Vpd/1+QgXjhSi5oQZVAyQW8rA3eM70+eEsR34yN7WhZSpnAA77Bp5L7RGAIMrqU6/9aGsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4662
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKRmll
bGQgInJlZ2lzdGVyZWQiIHdhcyBkb2N1bWVudGVkIHRocmVlIHRpbWVzOiB0d2ljZSBpbiB0aGUK
ZG9jdW1lbnRhdGlvbiBibG9jayBvZiBzdHJ1Y3Qgd2lwaHkgYW5kIG9uY2UgaW5zaWRlIHRoZSBz
dHJ1Y3QKZGVmaW5pdGlvbi4gVGhpcyBwYXRjaCBrZWVwIG9ubHkgb25lIGNvbW1lbnQuCgpTaWdu
ZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+
Ci0tLQogaW5jbHVkZS9uZXQvY2ZnODAyMTEuaCB8IDIgLS0KIDEgZmlsZSBjaGFuZ2VkLCAyIGRl
bGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2luY2x1ZGUvbmV0L2NmZzgwMjExLmggYi9pbmNsdWRl
L25ldC9jZmc4MDIxMS5oCmluZGV4IDI5Mjg3MWFlOTgyOC4uYmYzYmIxMjY1YmNjIDEwMDY0NAot
LS0gYS9pbmNsdWRlL25ldC9jZmc4MDIxMS5oCisrKyBiL2luY2x1ZGUvbmV0L2NmZzgwMjExLmgK
QEAgLTQ0MTIsNyArNDQxMiw2IEBAIHN0cnVjdCBjZmc4MDIxMV9wbXNyX2NhcGFiaWxpdGllcyB7
CiAgKiBAZGVidWdmc2RpcjogZGVidWdmcyBkaXJlY3RvcnkgdXNlZCBmb3IgdGhpcyB3aXBoeSwg
d2lsbCBiZSByZW5hbWVkCiAgKglhdXRvbWF0aWNhbGx5IG9uIHdpcGh5IHJlbmFtZXMKICAqIEBk
ZXY6ICh2aXJ0dWFsKSBzdHJ1Y3QgZGV2aWNlIGZvciB0aGlzIHdpcGh5Ci0gKiBAcmVnaXN0ZXJl
ZDogaGVscHMgc3luY2hyb25pemUgc3VzcGVuZC9yZXN1bWUgd2l0aCB3aXBoeSB1bnJlZ2lzdGVy
CiAgKiBAd2V4dDogd2lyZWxlc3MgZXh0ZW5zaW9uIGhhbmRsZXJzCiAgKiBAcHJpdjogZHJpdmVy
IHByaXZhdGUgZGF0YSAoc2l6ZWQgYWNjb3JkaW5nIHRvIHdpcGh5X25ldygpIHBhcmFtZXRlcikK
ICAqIEBpbnRlcmZhY2VfbW9kZXM6IGJpdG1hc2sgb2YgaW50ZXJmYWNlcyB0eXBlcyB2YWxpZCBm
b3IgdGhpcyB3aXBoeSwKQEAgLTQ2NDAsNyArNDYzOSw2IEBAIHN0cnVjdCB3aXBoeSB7CiAJICog
eW91IG5lZWQgdXNlIHNldF93aXBoeV9kZXYoKSAoc2VlIGJlbG93KSAqLwogCXN0cnVjdCBkZXZp
Y2UgZGV2OwogCi0JLyogcHJvdGVjdHMgLT5yZXN1bWUsIC0+c3VzcGVuZCBzeXNmcyBjYWxsYmFj
a3MgYWdhaW5zdCB1bnJlZ2lzdGVyIGh3ICovCiAJYm9vbCByZWdpc3RlcmVkOwogCiAJLyogZGly
IGluIGRlYnVnZnM6IGllZWU4MDIxMS88d2lwaHluYW1lPiAqLwotLSAKMi4yNS4wCgo=
