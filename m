Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0987319AA3C
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 13:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732440AbgDALFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 07:05:10 -0400
Received: from mail-eopbgr750070.outbound.protection.outlook.com ([40.107.75.70]:46082
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732371AbgDALFG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Apr 2020 07:05:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BTBCDlXI+zA7cFT5E+ifbDyWTUdmiynArXdH2xGwHS1nKdizyvzDoQ81T1/rL50/tPTYk9OB63E4iMt2lQe2yrjyfMdTjVYrTyp+SmPco67ZLj3jR/bQNUJQvW5YKQ1HBsBDWDMAIyJyNF1FKGAbRMVKGYE4UT7iMuySx6A2G/pc4R5vPfTZlp0rP/IsgkdD8Wbllo+P9HRSfKaPv+XIM2CgyZMObRYRyn+wf71nRy8Ez0DLu6A+NGFJY2o2x+f8LqCehymwmhbUQgBLjZhdTUZQUaobK6dtOGDr7MuQS/NFsU6kcO3yv85gpsTaP2AynoIiNK8WQRTyYZBzstQssw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xQ7YYdW/7wdJYTGnqtNObTowuAlDxIcPNkAKBaBDW2w=;
 b=D9jsXmCn3nKL7NXE6qsACmCjLBvvpbR7rXN+vTU7I60PH7gLuPaHVShj3wMOhC42gkBtA/DnNvzDVCEwptFdvXccMKeZT5zIY6ttc+B1AE/gNbhYvDAlpiAzfYkAitdtQxryskTE3in2wJnsETK1phpYm4Nk9aqT1iViHhECZskmWol/zQvtQSo51OcKAwNbI58zq9T899uDDvo05yoqb0CgG1nZkbpFCl3PZnVk4EWF5Q8vSiiwCfUGGKBPveoJBAsvpAY7oHg28DSAkOQmJ09lhom1iJi2V+d10Td5NgUnY0LWSc+uSTiIDqr+V231M7dZBe4nXBA2B2D+tV+Kyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xQ7YYdW/7wdJYTGnqtNObTowuAlDxIcPNkAKBaBDW2w=;
 b=Hszff1kABiaIVEwlgQU3casYo8wg0imDSg/eV9TPH5mXL+zbszjEUtRphbg8xaiQFVBfWb+xVq9kmY2b8mmZsirxdHFXNEyc8ZBP2rbHixKS682DIPtUtyvmKLqEFIkjLY9hW2cN0fg+Mkul0t7tXBxseDdFChXSwn6v/APvQps=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
 by MN2PR11MB4285.namprd11.prod.outlook.com (2603:10b6:208:191::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20; Wed, 1 Apr
 2020 11:04:54 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3%7]) with mapi id 15.20.2856.019; Wed, 1 Apr 2020
 11:04:54 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 17/32] staging: wfx: drop unused link_id field
Date:   Wed,  1 Apr 2020 13:03:50 +0200
Message-Id: <20200401110405.80282-18-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:1265:30ff:fefd:6e7f) by SN4PR0501CA0156.namprd05.prod.outlook.com (2603:10b6:803:2c::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.9 via Frontend Transport; Wed, 1 Apr 2020 11:04:52 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:2435:66a0:1265:30ff:fefd:6e7f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 882a91be-f4be-4538-3a7a-08d7d62c81dd
X-MS-TrafficTypeDiagnostic: MN2PR11MB4285:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR11MB42853403839C5A26B14DFA7293C90@MN2PR11MB4285.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-Forefront-PRVS: 03607C04F0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4063.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(136003)(366004)(346002)(376002)(39850400004)(396003)(7696005)(8676002)(1076003)(16526019)(186003)(5660300002)(86362001)(4326008)(52116002)(478600001)(66946007)(66476007)(54906003)(36756003)(8936002)(316002)(81156014)(6486002)(2906002)(66556008)(107886003)(81166006)(2616005);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nH5nLn8Z2GvzYZUtAkvlfuL27YNTX1DrPgl9yoc0K0wcnOXfbjBp2Q3i+zc9jQr9HaKaE5i6LDJEoOU+zwSIj8aGB0lfZo4nt8LcaVye1IQT/K7Wl3XcvromSlfPenjmZ7n//CR1u3Q2AVbLBJpPxGs3OLQE+KvCBhS58aw0TzQlcfTpMety7aX/IJoD36sVQGc4+o0lEjmCFNtXDnrOgFfQS8x2bIxGa3UH8rJDAHgWJWzfpWAARQS8Lq2xoDSyC7jZb+jeY7JNubYgba/3eHuauFwSz8lUVMFm4yQ0Fe1ASpmItS947kocZYgSYCeGJOUp4I6dejN6HT/SQ8NDgtU8noH+fZubeV4B6Pz8qnWwRCWHkErS3oZJgda3zTOVHCuYZW1Os7WI24XcQEK6o8uh1S2h0Ba1XUhVpunb5gbtsxYiLvydaJaWZCfY9s+E
X-MS-Exchange-AntiSpam-MessageData: sUeLyMOVLHInnwxBcso+5DPv+t0LUuY8TBbNPyTBLvL2XTYh8UjJz6J3vjavF5guKLdaZPIzQ8C6PYNP3Vqcyl5gmPyjShaXq1SUcPB6oJd4WP2KvTRCGzj3eG0cjBfYRze5XWvprNKr08d1ZSWznPZ+uoq/Q+nJ1Y8BOM6c7NChhZUysLkJn9snz7103lLA+ZQ/gBDxahj4JVzjpyvuDw==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 882a91be-f4be-4538-3a7a-08d7d62c81dd
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2020 11:04:54.3977
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6RROmdASlC6TMrFEpdSB5dmamjBs/Y2v4wxUtUUe1ICeYVPcZp7qMBVOgk9r3mYYDH1dEY7jiZVxjLN6w6Uoyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4285
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSXQg
aXMgbm90IHVzZWQgYW55bW9yZS4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxq
ZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFf
dHguYyB8IDUgLS0tLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5oIHwgMSAtCiBkcml2
ZXJzL3N0YWdpbmcvd2Z4L3F1ZXVlLmggICB8IDIgLS0KIDMgZmlsZXMgY2hhbmdlZCwgOCBkZWxl
dGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguYyBiL2Ry
aXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jCmluZGV4IGE1M2U2ZDE1MDMxYi4uZjc5NDIxMmY0
MmUyIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguYworKysgYi9kcml2
ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguYwpAQCAtNDI0LDEzICs0MjQsOCBAQCBzdGF0aWMgaW50
IHdmeF90eF9pbm5lcihzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgc3RydWN0IGllZWU4MDIxMV9zdGEg
KnN0YSwKIAkvLyBGaWxsIHR4X3ByaXYKIAl0eF9wcml2ID0gKHN0cnVjdCB3ZnhfdHhfcHJpdiAq
KXR4X2luZm8tPnJhdGVfZHJpdmVyX2RhdGE7CiAJdHhfcHJpdi0+cmF3X2xpbmtfaWQgPSB3Znhf
dHhfZ2V0X3Jhd19saW5rX2lkKHd2aWYsIHN0YSwgaGRyKTsKLQl0eF9wcml2LT5saW5rX2lkID0g
dHhfcHJpdi0+cmF3X2xpbmtfaWQ7CiAJaWYgKGllZWU4MDIxMV9oYXNfcHJvdGVjdGVkKGhkci0+
ZnJhbWVfY29udHJvbCkpCiAJCXR4X3ByaXYtPmh3X2tleSA9IGh3X2tleTsKLQlpZiAodHhfaW5m
by0+ZmxhZ3MgJiBJRUVFODAyMTFfVFhfQ1RMX1NFTkRfQUZURVJfRFRJTSkKLQkJdHhfcHJpdi0+
bGlua19pZCA9IFdGWF9MSU5LX0lEX0FGVEVSX0RUSU07Ci0JaWYgKHN0YSAmJiAoc3RhLT51YXBz
ZF9xdWV1ZXMgJiBCSVQocXVldWVfaWQpKSkKLQkJdHhfcHJpdi0+bGlua19pZCA9IFdGWF9MSU5L
X0lEX1VBUFNEOwogCiAJLy8gRmlsbCBoaWZfbXNnCiAJV0FSTihza2JfaGVhZHJvb20oc2tiKSA8
IHdtc2dfbGVuLCAibm90IGVub3VnaCBzcGFjZSBpbiBza2IiKTsKZGlmZiAtLWdpdCBhL2RyaXZl
cnMvc3RhZ2luZy93ZngvZGF0YV90eC5oIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmgK
aW5kZXggYzU0NWRkNzU0NDliLi5iNTYxYmJmOWYxNmYgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3Rh
Z2luZy93ZngvZGF0YV90eC5oCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5oCkBA
IC0zNiw3ICszNiw2IEBAIHN0cnVjdCB0eF9wb2xpY3lfY2FjaGUgewogc3RydWN0IHdmeF90eF9w
cml2IHsKIAlrdGltZV90IHhtaXRfdGltZXN0YW1wOwogCXN0cnVjdCBpZWVlODAyMTFfa2V5X2Nv
bmYgKmh3X2tleTsKLQl1OCBsaW5rX2lkOwogCXU4IHJhd19saW5rX2lkOwogfSBfX3BhY2tlZDsK
IApkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5oIGIvZHJpdmVycy9zdGFn
aW5nL3dmeC9xdWV1ZS5oCmluZGV4IGRkMTQxY2I0YmY2My4uMzljMjY1ZTRiODZlIDEwMDY0NAot
LS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3F1ZXVlLmgKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dm
eC9xdWV1ZS5oCkBAIC0xNCw4ICsxNCw2IEBACiAKICNkZWZpbmUgV0ZYX01BWF9TVEFfSU5fQVBf
TU9ERSAgICAxNAogI2RlZmluZSBXRlhfTElOS19JRF9OT19BU1NPQyAgICAgIDE1Ci0jZGVmaW5l
IFdGWF9MSU5LX0lEX0FGVEVSX0RUSU0gICAgKFdGWF9MSU5LX0lEX05PX0FTU09DICsgMSkKLSNk
ZWZpbmUgV0ZYX0xJTktfSURfVUFQU0QgICAgICAgICAoV0ZYX0xJTktfSURfTk9fQVNTT0MgKyAy
KQogCiBzdHJ1Y3Qgd2Z4X2RldjsKIHN0cnVjdCB3ZnhfdmlmOwotLSAKMi4yNS4xCgo=
