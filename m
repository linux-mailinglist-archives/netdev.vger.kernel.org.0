Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAE10411909
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 18:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242566AbhITQNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 12:13:40 -0400
Received: from mail-dm6nam12on2042.outbound.protection.outlook.com ([40.107.243.42]:26081
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242440AbhITQNb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Sep 2021 12:13:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E2B4OgqDzFXlnjg/RMBCseCgMNt+FJ4P0DYHDH/re/8Rii1tkBpFGY2Eh54i+lF05u/PjsDW+NEaxfnpihseo8t2Sc0iZDlAt8K8zn3eRp7DKWEMymtTZ8zdMhoJP3L0nFZSayJmJIzmwk4HHQMG9eYlyRu8e9zcbxW6Gi23FzKtPTmJqBzZSqTmS6Fgl77C8OYDjTBQcpVX6zoOzqW1rEpe1rcqGDQ3NJ/9dxgBXP3RaY4pYMtEeQTqIWx6YVecAhTfH5hakLv5/obBvjFwF7haztxnMDnDoaNUSvkl2SSlAh8c+8HLWic/xM3SVh5+/B7kDgVXqSHk9+VRBfF3Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=YReMQuBIPzwL0X2SQqdaw4bILayGeux92jRvC6HO64U=;
 b=Ezzkeu1J8qzJ6wmRIuWgdud74yeVVA3xY4ilmT0N2ipcl++OcM+ii7G+snYLNx7WJnK1UEwuhRAYEVfAGXffRVTL0vsyHHzEPN58+iLpsrjEHEK+DJh+GV8ZMDEOvneeK+UMfXuxoJ+B9gPpgQesu4eY43zGXXgVUH3v9FfNavfX21W4FZwMsvGbR+f8Q2Ryt1imQruMI2vwwqiFr0nqZMoToPRuXZdBG5rOCJWpTMY+RwWsBP3gaxcuXWD7fJytjofVjr7bsK/T+auXAOii1SndYS8xZGIBl+hr0v3YgF02jia4bLZAvqV03pGpGFd2ic7f09ev5O5052X/CzjZ/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YReMQuBIPzwL0X2SQqdaw4bILayGeux92jRvC6HO64U=;
 b=Fh5mG9r1bRvj+c5vVCAKKUDHgXqDsKyVGN2MiBOQNAbIt86U2umNPjCf+SBk/YQ3z2cOnvbt/oxr0nqLhrTXpADStKRv6VXN1aonbLA+39ftfHjxuoaaGM75XtyveFtIYXaoJaC1DAaoms6Nd1vkPjeTpTAIZhcOLoHVocNmGrU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA2PR11MB5002.namprd11.prod.outlook.com (2603:10b6:806:fb::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.16; Mon, 20 Sep
 2021 16:12:03 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4523.018; Mon, 20 Sep 2021
 16:12:03 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v7 04/24] wfx: add wfx.h
Date:   Mon, 20 Sep 2021 18:11:16 +0200
Message-Id: <20210920161136.2398632-5-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920161136.2398632-1-Jerome.Pouiller@silabs.com>
References: <20210920161136.2398632-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SA0PR11CA0064.namprd11.prod.outlook.com
 (2603:10b6:806:d2::9) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (2a01:e34:ecb5:66a0:9876:e1d7:65be:d294) by SA0PR11CA0064.namprd11.prod.outlook.com (2603:10b6:806:d2::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Mon, 20 Sep 2021 16:12:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 816aa8d7-db5e-495f-cd1d-08d97c516203
X-MS-TrafficTypeDiagnostic: SA2PR11MB5002:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR11MB5002C582B3DEEDE107EEE80093A09@SA2PR11MB5002.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:773;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6qvBmaFrqJ+i9YvPmPZOtNzzoydLBzEhfRN6Qs1jcQC3agHNS441a374Dd1POiGcbrPlgC9eIjFNlNqu3OUimc+Jr+iaS8qQIa4Vl9eb+51rue67FqgsX4sNd0zl7h/O+lr2ybTroVTk4Td3SsGZcHAeRtTXvtlrbqfIRa4ud/UKHRShgKk0zx+BvUNapnDRRUEAjRZT4p/IlE1jroIg8zoaP5X7nb+fmkGMob3qz6jkwrO0VQRAI25kON1Jgh0Rzc10rR3qhJfmlbTEYHZBHXKoJVGG4XRUEyzH9FvlgdQ165kUwsZ5JZjCV//Z8oRwWwWx1Gh9Usv0KdIZAQ/b9TR1TBQkhOjYCGWQ+NRXzRnvs0d8+F87JbwWS/beRykZ1Xd17jvrfUV3DZ7M/nweCxxxcXkmCzpcY9a/8G7sY5eKinQL8hACAh0H34mW+k4KPjQw403An231CG7IN35I5Lisps8Et5RszXB34DbgR3hLzaBzGgRlUxJ/Fv5oqtaQGAINu4AOn3MuMU1MX5o+Hen7dZ6J6dNUokwe87AUl8uFt+xhyq5DDwb8sWRarp5haOp5LZ/XnBvMGSOkUEXhdyUaBenhOWJ+X6gui7SrLpzTlgS0BK9L34OYZ15Pp1uf3LXDPA6BaaBJnjxBk6mf1w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66476007)(36756003)(2616005)(66556008)(107886003)(186003)(54906003)(5660300002)(6486002)(66574015)(66946007)(52116002)(38100700002)(83380400001)(7696005)(6916009)(2906002)(1076003)(4326008)(8936002)(316002)(8676002)(508600001)(86362001)(6666004)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 5AlCFuwwkm56xHhgsvTn7gOFv4dRXqsawEYPnF9gdPLP34FgKKsAQeLsS2HgtdpXopaNVOoFChkZ4U6fV7pr9xCzTe9clOJfPRaxpmGjF4RwpLFfg7RnnCXZp2AMtQ9HUl2DX60RG8GtjdMGCLH5JUZY29mzjr2TcHO7jxPQLFBho9vx3r6LOkVCK4zcPJ6dTENysNS2OYqiwI70Hazt5wnt1/IEBxodtX3nDVIOD8WGUfsfdeaMkym+vUJZKD9WWfsUFSj+gbvfzkH7wW8jnB4IyhiXLhHc2UoEnwTA+JVScc0AphdMElX6ZpzORzn0cMl6ZNFrdXg5rWwwg9T1aQucSeFxNFgfUoFqC0b7qLvYEA7DrXC/VkIOeoaqd2uVDtQDhn5H7fRwSu4PyiRgzrte6Y60zJlkwlTWnI13baAbYUFXvuS1XkEzPv3PpGE2Dz5SOErXGy1miTkmXBncbEeIXdKKqffdpiOFqSqO/ZnfPfdO49xt5lHMlK6b/6ENywuOS5ccxRqlYP9a90FkJ5U1uDGlH4tGnB4yOsnQMdWU7MQRkYlB/rora9dTzvRXGduQ/En58DxLAPduZndp5nG8fVNow5trfWPZL2hTX9Yr1IPuk87BBNR8so29/QeFpga+xehRdyE0GYP+YpOQ1XXLOEDsDSh3fW5vop2XUj8jzUQkMrv22okX8Rk7463HV+qzv7Ku+QIJKrjdNgc4ZiK6WUfzHy41ztmgRjYTcbteutkftq2D+aE8/TYDKxez9+U2xBocisUHppKhZDBqQj4xvHJuPI95v9WKnTesp4maIRlGAu2Zd8LLgTsLCMi0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 816aa8d7-db5e-495f-cd1d-08d97c516203
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2021 16:12:03.1055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /7pU1F51IwzlBlrLv8Zuj3D1DC0OwsMj3jZiHwIB1b1PgTWY2yolztj4J2daXO2UXXV4QGEw0SyQn8wDtWyipA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5002
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU2ln
bmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29t
PgotLS0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93Zngvd2Z4LmggfCAxNjQgKysrKysr
KysrKysrKysrKysrKysrKysrKysKIDEgZmlsZSBjaGFuZ2VkLCAxNjQgaW5zZXJ0aW9ucygrKQog
Y3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93Zngvd2Z4LmgK
CmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvd2Z4L3dmeC5oIGIvZHJp
dmVycy9uZXQvd2lyZWxlc3Mvc2lsYWJzL3dmeC93ZnguaApuZXcgZmlsZSBtb2RlIDEwMDY0NApp
bmRleCAwMDAwMDAwMDAwMDAuLmY4ZGY1OWFkMTYzOQotLS0gL2Rldi9udWxsCisrKyBiL2RyaXZl
cnMvbmV0L3dpcmVsZXNzL3NpbGFicy93Zngvd2Z4LmgKQEAgLTAsMCArMSwxNjQgQEAKKy8qIFNQ
RFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wLW9ubHkgKi8KKy8qCisgKiBDb21tb24gcHJp
dmF0ZSBkYXRhLgorICoKKyAqIENvcHlyaWdodCAoYykgMjAxNy0yMDIwLCBTaWxpY29uIExhYm9y
YXRvcmllcywgSW5jLgorICogQ29weXJpZ2h0IChjKSAyMDEwLCBTVC1Fcmljc3NvbgorICogQ29w
eXJpZ2h0IChjKSAyMDA2LCBNaWNoYWVsIFd1IDxmbGFtaW5naWNlQHNvdXJtaWxrLm5ldD4KKyAq
IENvcHlyaWdodCAyMDA0LTIwMDYgSmVhbi1CYXB0aXN0ZSBOb3RlIDxqYm5vdGVAZ21haWwuY29t
PiwgZXQgYWwuCisgKi8KKyNpZm5kZWYgV0ZYX0gKKyNkZWZpbmUgV0ZYX0gKKworI2luY2x1ZGUg
PGxpbnV4L2NvbXBsZXRpb24uaD4KKyNpbmNsdWRlIDxsaW51eC93b3JrcXVldWUuaD4KKyNpbmNs
dWRlIDxsaW51eC9tdXRleC5oPgorI2luY2x1ZGUgPGxpbnV4L25vc3BlYy5oPgorI2luY2x1ZGUg
PG5ldC9tYWM4MDIxMS5oPgorCisjaW5jbHVkZSAiYmguaCIKKyNpbmNsdWRlICJkYXRhX3R4Lmgi
CisjaW5jbHVkZSAibWFpbi5oIgorI2luY2x1ZGUgInF1ZXVlLmgiCisjaW5jbHVkZSAiaGlmX3R4
LmgiCisKKyNkZWZpbmUgVVNFQ19QRVJfVFhPUCAzMiAvKiBzZWUgc3RydWN0IGllZWU4MDIxMV90
eF9xdWV1ZV9wYXJhbXMgKi8KKyNkZWZpbmUgVVNFQ19QRVJfVFUgMTAyNAorCitzdHJ1Y3QgaHdi
dXNfb3BzOworCitzdHJ1Y3Qgd2Z4X2RldiB7CisJc3RydWN0IHdmeF9wbGF0Zm9ybV9kYXRhIHBk
YXRhOworCXN0cnVjdCBkZXZpY2UJCSpkZXY7CisJc3RydWN0IGllZWU4MDIxMV9odwkqaHc7CisJ
c3RydWN0IGllZWU4MDIxMV92aWYJKnZpZlsyXTsKKwlzdHJ1Y3QgbWFjX2FkZHJlc3MJYWRkcmVz
c2VzWzJdOworCWNvbnN0IHN0cnVjdCBod2J1c19vcHMJKmh3YnVzX29wczsKKwl2b2lkCQkJKmh3
YnVzX3ByaXY7CisKKwl1OAkJCWtleXNldDsKKwlzdHJ1Y3QgY29tcGxldGlvbglmaXJtd2FyZV9y
ZWFkeTsKKwlzdHJ1Y3QgaGlmX2luZF9zdGFydHVwCWh3X2NhcHM7CisJc3RydWN0IHdmeF9oaWYJ
CWhpZjsKKwlzdHJ1Y3QgZGVsYXllZF93b3JrCWNvb2xpbmdfdGltZW91dF93b3JrOworCWJvb2wJ
CQlwb2xsX2lycTsKKwlib29sCQkJY2hpcF9mcm96ZW47CisJc3RydWN0IG11dGV4CQljb25mX211
dGV4OworCisJc3RydWN0IHdmeF9oaWZfY21kCWhpZl9jbWQ7CisJc3RydWN0IHNrX2J1ZmZfaGVh
ZAl0eF9wZW5kaW5nOworCXdhaXRfcXVldWVfaGVhZF90CXR4X2RlcXVldWU7CisJYXRvbWljX3QJ
CXR4X2xvY2s7CisKKwlhdG9taWNfdAkJcGFja2V0X2lkOworCXUzMgkJCWtleV9tYXA7CisKKwlz
dHJ1Y3QgaGlmX3J4X3N0YXRzCXJ4X3N0YXRzOworCXN0cnVjdCBtdXRleAkJcnhfc3RhdHNfbG9j
azsKKwlzdHJ1Y3QgaGlmX3R4X3Bvd2VyX2xvb3BfaW5mbyB0eF9wb3dlcl9sb29wX2luZm87CisJ
c3RydWN0IG11dGV4CQl0eF9wb3dlcl9sb29wX2luZm9fbG9jazsKKwlpbnQJCQlmb3JjZV9wc190
aW1lb3V0OworfTsKKworc3RydWN0IHdmeF92aWYgeworCXN0cnVjdCB3ZnhfZGV2CQkqd2RldjsK
KwlzdHJ1Y3QgaWVlZTgwMjExX3ZpZgkqdmlmOworCXN0cnVjdCBpZWVlODAyMTFfY2hhbm5lbCAq
Y2hhbm5lbDsKKwlpbnQJCQlpZDsKKworCXUzMgkJCWxpbmtfaWRfbWFwOworCisJYm9vbAkJCWFm
dGVyX2R0aW1fdHhfYWxsb3dlZDsKKwlib29sCQkJam9pbl9pbl9wcm9ncmVzczsKKworCXN0cnVj
dCBkZWxheWVkX3dvcmsJYmVhY29uX2xvc3Nfd29yazsKKworCXN0cnVjdCB3ZnhfcXVldWUJdHhf
cXVldWVbNF07CisJc3RydWN0IHR4X3BvbGljeV9jYWNoZQl0eF9wb2xpY3lfY2FjaGU7CisJc3Ry
dWN0IHdvcmtfc3RydWN0CXR4X3BvbGljeV91cGxvYWRfd29yazsKKworCXN0cnVjdCB3b3JrX3N0
cnVjdAl1cGRhdGVfdGltX3dvcms7CisKKwl1bnNpZ25lZCBsb25nCQl1YXBzZF9tYXNrOworCisJ
LyogYXZvaWQgc29tZSBvcGVyYXRpb25zIGluIHBhcmFsbGVsIHdpdGggc2NhbiAqLworCXN0cnVj
dCBtdXRleAkJc2Nhbl9sb2NrOworCXN0cnVjdCB3b3JrX3N0cnVjdAlzY2FuX3dvcms7CisJc3Ry
dWN0IGNvbXBsZXRpb24Jc2Nhbl9jb21wbGV0ZTsKKwlpbnQJCQlzY2FuX25iX2NoYW5fZG9uZTsK
Kwlib29sCQkJc2Nhbl9hYm9ydDsKKwlzdHJ1Y3QgaWVlZTgwMjExX3NjYW5fcmVxdWVzdCAqc2Nh
bl9yZXE7CisKKwlzdHJ1Y3QgY29tcGxldGlvbglzZXRfcG1fbW9kZV9jb21wbGV0ZTsKK307CisK
K3N0YXRpYyBpbmxpbmUgc3RydWN0IHdmeF92aWYgKndkZXZfdG9fd3ZpZihzdHJ1Y3Qgd2Z4X2Rl
diAqd2RldiwgaW50IHZpZl9pZCkKK3sKKwlpZiAodmlmX2lkID49IEFSUkFZX1NJWkUod2Rldi0+
dmlmKSkgeworCQlkZXZfZGJnKHdkZXYtPmRldiwgInJlcXVlc3Rpbmcgbm9uLWV4aXN0ZW50IHZp
ZjogJWRcbiIsIHZpZl9pZCk7CisJCXJldHVybiBOVUxMOworCX0KKwl2aWZfaWQgPSBhcnJheV9p
bmRleF9ub3NwZWModmlmX2lkLCBBUlJBWV9TSVpFKHdkZXYtPnZpZikpOworCWlmICghd2Rldi0+
dmlmW3ZpZl9pZF0pCisJCXJldHVybiBOVUxMOworCXJldHVybiAoc3RydWN0IHdmeF92aWYgKil3
ZGV2LT52aWZbdmlmX2lkXS0+ZHJ2X3ByaXY7Cit9CisKK3N0YXRpYyBpbmxpbmUgc3RydWN0IHdm
eF92aWYgKnd2aWZfaXRlcmF0ZShzdHJ1Y3Qgd2Z4X2RldiAqd2RldiwKKwkJCQkJICAgc3RydWN0
IHdmeF92aWYgKmN1cikKK3sKKwlpbnQgaTsKKwlpbnQgbWFyayA9IDA7CisJc3RydWN0IHdmeF92
aWYgKnRtcDsKKworCWlmICghY3VyKQorCQltYXJrID0gMTsKKwlmb3IgKGkgPSAwOyBpIDwgQVJS
QVlfU0laRSh3ZGV2LT52aWYpOyBpKyspIHsKKwkJdG1wID0gd2Rldl90b193dmlmKHdkZXYsIGkp
OworCQlpZiAobWFyayAmJiB0bXApCisJCQlyZXR1cm4gdG1wOworCQlpZiAodG1wID09IGN1cikK
KwkJCW1hcmsgPSAxOworCX0KKwlyZXR1cm4gTlVMTDsKK30KKworc3RhdGljIGlubGluZSBpbnQg
d3ZpZl9jb3VudChzdHJ1Y3Qgd2Z4X2RldiAqd2RldikKK3sKKwlpbnQgaTsKKwlpbnQgcmV0ID0g
MDsKKwlzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZjsKKworCWZvciAoaSA9IDA7IGkgPCBBUlJBWV9TSVpF
KHdkZXYtPnZpZik7IGkrKykgeworCQl3dmlmID0gd2Rldl90b193dmlmKHdkZXYsIGkpOworCQlp
ZiAod3ZpZikKKwkJCXJldCsrOworCX0KKwlyZXR1cm4gcmV0OworfQorCitzdGF0aWMgaW5saW5l
IHZvaWQgbWVtcmV2ZXJzZSh1OCAqc3JjLCB1OCBsZW5ndGgpCit7CisJdTggKmxvID0gc3JjOwor
CXU4ICpoaSA9IHNyYyArIGxlbmd0aCAtIDE7CisJdTggc3dhcDsKKworCXdoaWxlIChsbyA8IGhp
KSB7CisJCXN3YXAgPSAqbG87CisJCSpsbysrID0gKmhpOworCQkqaGktLSA9IHN3YXA7CisJfQor
fQorCitzdGF0aWMgaW5saW5lIGludCBtZW16Y21wKHZvaWQgKnNyYywgdW5zaWduZWQgaW50IHNp
emUpCit7CisJdTggKmJ1ZiA9IHNyYzsKKworCWlmICghc2l6ZSkKKwkJcmV0dXJuIDA7CisJaWYg
KCpidWYpCisJCXJldHVybiAxOworCXJldHVybiBtZW1jbXAoYnVmLCBidWYgKyAxLCBzaXplIC0g
MSk7Cit9CisKKyNlbmRpZgotLSAKMi4zMy4wCgo=
