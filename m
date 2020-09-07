Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64E7125F7A2
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 12:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728836AbgIGKRr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 06:17:47 -0400
Received: from mail-mw2nam10on2078.outbound.protection.outlook.com ([40.107.94.78]:7488
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728491AbgIGKRd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 06:17:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZcKhNdFLaqkLysfFoH33sbdHHCpCCV0rTVrI2mFJfdHVg4RVlhY5vkpXnBiUl0peN7uQzRGwSrFXzG4slSOKfxz+TbQjnnRCL1YTpCUQxv8tU+3ael5HVXnFI+PMJzZPcDcNLGGaKnPdvEIciJis67+IFgKNEB2G9ybYPyW1pNldVGjIMBvO2e5jIP+Pn4MT7BVTwvHPh1/THHLPotWVnda8nOHrJkI21rxNc2kb+qPYoisO+bz5r9VXBC7HGKy1Cz2voEH4XW+JI4E2PAi9bIXERYpSv/3LaBcJH6kDKNc2CL7vH4VSoUK7Tqlv29IezO8WzSehrva+OqFQTIHAqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uCXLlvSneXCHNUu//m0D2+mQC7GzCWYN0ggpoiqqiTY=;
 b=IRu6A3oUtetNp0KsHYs4P+gabI0fINidTOvVG4ul0hEisX1RNCR3uoOtq3WLDs2mu+ROZoBSEi8AqXI5FJr/H/7kQunU7ksKpfjlWANg8+J0/cmRplsOoZ5tKGktbWT1SkeIm+bUEBG2fxFoLq+GpvqG0vS3oE9Ov+6+7VdI1QSpc9E5VS9T1GWH0HR9WAPFbtMVnOcqHduTUa6OEcTGsIKLHObQyeijt+FbDubaPPAavTVLlzzpKWEvZ8sjM5e1PC87oM6YRyptrhwC6g7d8P+0hZHPIVzQHuCpZoi00ltpDGcvWi4pP1rugvLWoWOmho+NsSQKjFK5hTbse4HudA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uCXLlvSneXCHNUu//m0D2+mQC7GzCWYN0ggpoiqqiTY=;
 b=SGWpwTM5z4Gh7PWPam/ocsB05094I+QA4OmkMGDg86CDU8W1rS43QFsMc6u/wTlALHkvEsuulMOxgOzvOVKWhhGBpEl2PNsOipM47eXbaR0EggM4tBkau2nNXGIEBdL2GRFqQ3kYKjOkqKobXB0ZZUyyA/EQXqnh6dO212Kds4k=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2720.namprd11.prod.outlook.com (2603:10b6:805:56::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15; Mon, 7 Sep
 2020 10:16:29 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6%4]) with mapi id 15.20.3348.019; Mon, 7 Sep 2020
 10:16:29 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 27/31] staging: wfx: fix naming of hif_tx_rate_retry_policy
Date:   Mon,  7 Sep 2020 12:15:17 +0200
Message-Id: <20200907101521.66082-28-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.silabs.com (37.71.187.125) by PR0P264CA0109.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:19::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.16 via Frontend Transport; Mon, 7 Sep 2020 10:16:27 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [37.71.187.125]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: edf85acd-5203-4114-72f5-08d8531715da
X-MS-TrafficTypeDiagnostic: SN6PR11MB2720:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB2720A1B6A238C89F9C0E5DD893280@SN6PR11MB2720.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pNVjhHygl0Ywz8PHz0ENHdym59F5xvRxTsDhC/fIVANnr4EfweuvrfSxMhhadAeDC3whzHWD3APl9uM7z53hQP7CZHrGtOxB2KoCSRXW6LX6SVmy1o+vITDJNf55OSqwOpup3OVGXomX16gudumqAs0PDQpHCuCEGeCYx3MdECaAmmEYFupuATWl0mjA9ZJi6ANXahUddp0lNOGG/kN/XVdxHfLjlg0xYWLZ05XI/nsnSZoriLbRXycxf1w9eSYIFgwjI55oCtT3PHwZWZtZQZVMhIzP0L5fuYozTvvFl76BjDoH173RW2HGT807b/87X68rOw8hYRoN+WMuJZjQKA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(39850400004)(136003)(346002)(396003)(66946007)(66556008)(66476007)(54906003)(26005)(186003)(16526019)(83380400001)(107886003)(6486002)(8676002)(956004)(2616005)(2906002)(316002)(86362001)(8936002)(478600001)(4326008)(7696005)(36756003)(52116002)(6666004)(1076003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: vPW1i3Y1YFYi2/cxSsQsdsHWW6qAEvOaoHneXjgudfluNF2JKN717o+feLmRZ1YYAsRtviwekaZhPB7Gc3Gxd2nB+Vjkh0tDDsXIK5uyBXrDzKtoc4cJRmxWNi/WLmE+nr+E2/MxgSOq9ymNFaAyBp0Dju/d6TfcVHLT51ZkHVhHqiX+p+fiEUePZPG8mG9Z87GdCHiP5SyvW7e1tS1X9nQMDf7EVhK0XhCc7ICr3BGktGlyT/tCyFSoNIQsIgeSeoQujDP9tOIdIQsT5LGVJ/bMGn++bUWPdzQ6gww48wjfTJB8typoN85oTzvbx2yic25KEiVD+2+FGBKJ5Tg4nqAZcboxEW1FE7yUbYuYXbY11yALr2Mzb4cf749Amau6pGqeSdujIwKjrlC3wkgUqRJG1sc8xj868w9S3O8XjtfkiSkZdHNcKzMWjpPjmPMOIRk+YLDA9vb1wqSxCYDMlmkTHWqmDtjokhRYa55Y+Olld7KhF7dZOK7ZqwaIAUnKQX1W1gOSz3rIWFTLk4fk8mJQmt44Zyt29qDOxOcL57VTMuCLYISNzh6GRWLC7gosRPWr+k4oDqgMs2Mc0MdjSTDA65V+k3S3ZK7dxNpYtbsb1w+TcyWvzqCe8NNjOiYq/FWtUS/vp0TLA+xZdsHu0A==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edf85acd-5203-4114-72f5-08d8531715da
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2020 10:16:29.0645
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YFI3f5LT3oIkGDTPc9C526Tgm2ELevb6BuR3Sdl3FfQrZO12r4HwDzmqXAAmp/xkt/zk4eYZTFoaswhAeyPofg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2720
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSW4g
dGhlIHdmeCBkcml2ZXIsIHRoZSBwcmVmaXggJ2hpZl9taWJfJyBpcyBub3JtYWxseSB1c2VkIGZv
ciBzdHJ1Y3R1cmVzCnRoYXQgcmVwcmVzZW50IGEgaGFyZHdhcmUgbWVzc2FnZS4gaGlmX21pYl90
eF9yYXRlX3JldHJ5X3BvbGljeSBkb2VzIG5vdApmYWxsIGluIHRoaXMgY2F0ZWdvcnkuIFNvLCBy
ZW5hbWUgaXQuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWls
bGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfYXBpX21pYi5oIHwg
NCArKy0tCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoK
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9taWIuaCBiL2RyaXZlcnMv
c3RhZ2luZy93ZngvaGlmX2FwaV9taWIuaAppbmRleCA3Mzg3M2QyOTQ1NmQuLjU1YmQzOTljY2Rm
YiAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfYXBpX21pYi5oCisrKyBiL2Ry
aXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9taWIuaApAQCAtMzA1LDcgKzMwNSw3IEBAIHN0cnVj
dCBoaWZfbWliX3NldF91YXBzZF9pbmZvcm1hdGlvbiB7CiAJX19sZTE2IGF1dG9fdHJpZ2dlcl9z
dGVwOwogfSBfX3BhY2tlZDsKIAotc3RydWN0IGhpZl9taWJfdHhfcmF0ZV9yZXRyeV9wb2xpY3kg
eworc3RydWN0IGhpZl90eF9yYXRlX3JldHJ5X3BvbGljeSB7CiAJdTggICAgIHBvbGljeV9pbmRl
eDsKIAl1OCAgICAgc2hvcnRfcmV0cnlfY291bnQ7CiAJdTggICAgIGxvbmdfcmV0cnlfY291bnQ7
CkBAIC0zMjQsNyArMzI0LDcgQEAgc3RydWN0IGhpZl9taWJfdHhfcmF0ZV9yZXRyeV9wb2xpY3kg
ewogc3RydWN0IGhpZl9taWJfc2V0X3R4X3JhdGVfcmV0cnlfcG9saWN5IHsKIAl1OCAgICAgbnVt
X3R4X3JhdGVfcG9saWNpZXM7CiAJdTggICAgIHJlc2VydmVkWzNdOwotCXN0cnVjdCBoaWZfbWli
X3R4X3JhdGVfcmV0cnlfcG9saWN5IHR4X3JhdGVfcmV0cnlfcG9saWN5W107CisJc3RydWN0IGhp
Zl90eF9yYXRlX3JldHJ5X3BvbGljeSB0eF9yYXRlX3JldHJ5X3BvbGljeVtdOwogfSBfX3BhY2tl
ZDsKIAogc3RydWN0IGhpZl9taWJfcHJvdGVjdGVkX21nbXRfcG9saWN5IHsKLS0gCjIuMjguMAoK
