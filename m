Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0251BA503
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 15:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728186AbgD0Nlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 09:41:46 -0400
Received: from mail-mw2nam10on2043.outbound.protection.outlook.com ([40.107.94.43]:22881
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728159AbgD0Nln (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 09:41:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SPGai4T3gpVYGVPs5rxSWq4xVRwX6E5gpCKYb2g4ZCKTm0ZG1PLAynlETYY+HXU7ufZZXE+37IVRg6Q0O3Ss4fUWea56R0ROnvfpXfJGW4uIu7Opuk9blsORAlyTPKGytVTb8xuHypZnbwDL97heM6DE69dLXaJUwIhe5Zx7RFmlhOCUIInymBWudT24FmeJ0AmTPx2sKMeyE+NybDrczxKv3ZDltnWCv5Ty7se+qJ1qGUytlgNeOL2FzzjnZQfsQJ7bgj14y+Zdgb6llv2lGc7Al5YznujnUrzGB8AxM5mJIDmFFn1fAmlhfzwxp7foeEr3bDJ+F91Q4SBsseNVuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fhp0x+pyCoDjQ41/lER5crX4TiQhMwkEuHtqx0ROSEM=;
 b=m3kLjlhfHOpHdXLrIyAhDQC2y0XwNH21SmYMwKMBVXEtcWiXdPzZqUqZ0SVKYaBImxUR+MpUNj6eh3/HxavMwxIt+hOifkZmokbTZ/cDm5JsAM05ZJmOe74LuUHh+hYS2Vlcj5Vh/NWwqXnnr3Ejwq+HpWtPJyYr7gS+J8caOpMT7xGkT3nBQeqwWXeRovUUV9Qx1DaW3ZjKsFa+/e2ezZqQHR31JbomoxOezsjRntMde3kA3NY1KK5waD/XUJxvxkYhzE1sywEiXigh8BJ7QQiM/qBLgyvqzJXCHQgvM+HQ6SgqI6vnaCtROZcTsgTFfTvDbLtxvd5dMk3uTXBOlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fhp0x+pyCoDjQ41/lER5crX4TiQhMwkEuHtqx0ROSEM=;
 b=NGsd0IfJqX6ncjQcWpLtmNsZtDAf0+d2p5+q+YalSLq6r7D8KMxcqthR4+Qb1FfqhZOjx1e9shvFLMxmXTnSIYMrB4SVmf4fRfxo/mOP/2Qv8NJUtHaQ5dlECsYZaxyXqaiG4ZN/W/0X5TlAgcGxIBovJVG2JdvW19ky7zQZ9Dg=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1424.namprd11.prod.outlook.com (2603:10b6:300:26::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Mon, 27 Apr
 2020 13:41:41 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe%10]) with mapi id 15.20.2937.023; Mon, 27 Apr
 2020 13:41:41 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 15/17] staging: wfx: fix messages names in tracepoints
Date:   Mon, 27 Apr 2020 15:40:29 +0200
Message-Id: <20200427134031.323403-16-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200427134031.323403-1-Jerome.Pouiller@silabs.com>
References: <20200427134031.323403-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR0P264CA0232.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1e::28) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.home (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by PR0P264CA0232.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1e::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Mon, 27 Apr 2020 13:41:38 +0000
X-Mailer: git-send-email 2.26.1
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8b8795c0-a427-4535-66ef-08d7eab0b79e
X-MS-TrafficTypeDiagnostic: MWHPR11MB1424:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB142425280F9F9C81820BB3D593AF0@MWHPR11MB1424.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:935;
X-Forefront-PRVS: 0386B406AA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(39850400004)(376002)(346002)(396003)(366004)(8886007)(66476007)(66556008)(4744005)(4326008)(81156014)(86362001)(8936002)(15650500001)(6486002)(52116002)(6666004)(6506007)(5660300002)(16526019)(6512007)(1076003)(478600001)(8676002)(36756003)(186003)(2616005)(54906003)(107886003)(66574012)(2906002)(316002)(66946007);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U8qgvy7uqFhLWDrmCs0wdN6UhSm//JGyXqJ8KmbrNk1ZjOWaD0Vq22UxQLa/a0dCUU5X1y1RqpV7EtXUawZAbh7Z/EsnCG+JqE21hQlA8gTr32fZeEWFRrvLrgUPYgFEXuelxv8G3rwNFjkUNApo3BoSFuH9RRFLVTLHeegoKUGcGP/I0SqwmJaKCGa+FVZ+i0QWoYkCkWt67HegXLuL+eG6L67omWnHUlpKfYSFi4h1qyMZ3i0MCqucW4gMJj1yHpktrQeapPUNERiYJhWv3ntV8J/3yk3luujirf9dSBhqN4u8PBNdNT/1w0ip8KmrvwKuQ8QmWkbXuvRST/PQJwCpyBARcfVlrngytVemmy2mtWGa4Zu8qZmYFFlwqjhnqwhdN+MDfJ+tlGdIK6Wnw+ZJwaEa1RxmRSOk0XFu32hdAFOxI9zi2MYmrls95K43
X-MS-Exchange-AntiSpam-MessageData: iyMbWqIspVvuN/eGRDkAAeyt48pt6UoHgahxYWGy2z0uoFJ12JroQe4efSeYEgzDMYvR8WkgMvwzL5dex5Kfw/D3Qe02lPtZHFJ9w0+GPZCNGQakQd0AVECY/L7LU3AUmT8FQUxmYcpoIP9JivRb1ta+Tgh8vt9gmfkLIgH7Co7U6PGwWMR8L/GnAMXGECcO3CKy/Jpm51Zpz1BmFXITCFXwFpJlUHqfC1Un8utC6X/GK+fRsMvmWHoevEuxZ0VNsQj77vvrgIC+aoHcZ+SUn2LlTA238CwZbeLudqQyS+AzEVee3iuTIieRiZzzNaqHU3WnuiUBtM2NaoAY1ZFDb6T+GK9Fbc0A+iTWtGDDpGvdh+AIHir+PDdOCsmrY8w1hohE5fjY2de9A7F7l2TQjkJz5+w7XI0tRlbE1Uehce1/wn8+j27oCLUSDWTH2dKUgVs7y5tq8aHuKyQYb09+Qqla6a1nWE57e2/uzskkMRqSFhPp7OwYmEyP1fcakW6FkNHl3hVm/mBJnbos8RNQeQyY/5y8xDI+yBtCtIX75KTTf6qZA/QEubj2dfZq+hpjov3d9M1MtkFtxVW03JlJVdLFh7JT/3xOpHLuJWm/POh6yJehDEfBJjQtDVV7x33Tnc+d8GAUU+fz0kiIW7ThCUnrVHH6FNkV8FzC9HdBypHMiKmRGyJ5YGjgg/Wh9+y2MipEUHo0cxkp8/6xEO6nw0rExsJBQhV4LJzRFvQHrz5K65YZnXAWG2Lu8s+MBkq/VFquQyVhe/ZiRDjBmC6BDA/Cd0DFxfvERW1eoS67mXln+I8dQhljbcSNfQL0iCEiKaBHqotCzhuFxmNhz6p6hOYN0NHVE/jiDALIFaryS70=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b8795c0-a427-4535-66ef-08d7eab0b79e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2020 13:41:41.6527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vLMIC2gCPgvZL4CkuNQ6EtknYdojm2o+WPdac0Mh5XTZC81jINeGCFh7GfMvdFSir3Xf3YX+93EU6ACDGfATlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1424
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IG5hbWVzIG9mIHRoZSBoYXJkd2FyZSBpbnRlcmZhY2UgbWVzc2FnZXMgYXJlIG5vdCBkaXNwbGF5
ZWQgY29ycmVjdGx5CmluIHRyYWNlcG9pbnRzLiBUaHVzLCBSRVFfSk9JTiBpcyBkaXNwbGF5ZWQg
Sk9JTl9SRVEuIEZpeCB0aGF0IGluIG9yZGVyCnRvIGdldCB0aGUgbmFtZXMgYXMgZGVmaW5lZCBp
biBoZWFkZXJzIG9mIEhJRiBBUEkuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8
amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC90cmFj
ZXMuaCB8IDIgKy0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigt
KQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvdHJhY2VzLmggYi9kcml2ZXJzL3N0
YWdpbmcvd2Z4L3RyYWNlcy5oCmluZGV4IDdiMjVlOTUxMWIwMC4uYmI5ZjdlOWU3ZDIxIDEwMDY0
NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3RyYWNlcy5oCisrKyBiL2RyaXZlcnMvc3RhZ2lu
Zy93ZngvdHJhY2VzLmgKQEAgLTE5OCw4ICsxOTgsOCBAQCBERUNMQVJFX0VWRU5UX0NMQVNTKGhp
Zl9kYXRhLAogCVRQX3ByaW50aygiJWQ6JWQ6JXNfJXMlcyVzOiAlcyVzICglZCBieXRlcykiLAog
CQlfX2VudHJ5LT50eF9maWxsX2xldmVsLAogCQlfX2VudHJ5LT5pZl9pZCwKLQkJX19wcmludF9z
eW1ib2xpYyhfX2VudHJ5LT5tc2dfaWQsIGhpZl9tc2dfbGlzdCksCiAJCV9fZW50cnktPm1zZ190
eXBlLAorCQlfX3ByaW50X3N5bWJvbGljKF9fZW50cnktPm1zZ19pZCwgaGlmX21zZ19saXN0KSwK
IAkJX19lbnRyeS0+bWliICE9IC0xID8gIi8iIDogIiIsCiAJCV9fZW50cnktPm1pYiAhPSAtMSA/
IF9fcHJpbnRfc3ltYm9saWMoX19lbnRyeS0+bWliLCBoaWZfbWliX2xpc3QpIDogIiIsCiAJCV9f
cHJpbnRfaGV4KF9fZW50cnktPmJ1ZiwgX19lbnRyeS0+YnVmX2xlbiksCi0tIAoyLjI2LjEKCg==
