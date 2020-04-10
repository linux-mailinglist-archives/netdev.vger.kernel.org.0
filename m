Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35B8F1A46D1
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 15:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726895AbgDJNd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 09:33:28 -0400
Received: from mail-dm6nam12on2082.outbound.protection.outlook.com ([40.107.243.82]:31903
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726864AbgDJNdZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Apr 2020 09:33:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ks0tzMRNSlp+K9JFj2EkLMSGAGWpQxjjyfvgkq3dNDBW5WkjAcO5/231P0BsqGmMoSEIjfwKw1QZvvZeEKm1xh3fgkdPwuynuiicFwAdvB+nRf9TWs7E7QwSQ90pWGnUELPKd8FMjBzG2n7elLMxa3GqJec01iuEQpNMohkRJogyyE20lAhx+r0IVx3Y5hC0rghby3bLYkeKEUxKSQGRzLq3ohzyisYP/Au9RWR1XPdeVHDjx8xOsxQJqu3CvfY5BnatOG74n+GSLYv9t7uFrBGkjGELbGHKxGMTVYH+YOxe7Q3G/dst87ei7/57nQIqbchsJyQCiMmH886l/kLXkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nvcvWBQXy23qgYN6qax3oOEPpAc4Ie94rn39rMo5Ljg=;
 b=NYQjyI1mUhYp8sqYNBERvWeKzwp12kzvrGvM3xrzWXxz7CEUi7Xuv4RBfNgA20oV8BE/pLeOJhnSHSBuRiYB0nLzLdGvpRXB2VcATQgVHU+vKKrSn/GOxUiSevxJHNjEzvrB7gXpMTe9pJ6Yd+mx1OKeDn3TFcZGni6GtGNMynegCaQ8NiuYSLgZ6AJwzpuqfQ6qsiRy47DHRU+evTrdhr7odRbI6bRpqmbzznT6Y5I6lpWxMgd9jJeasXLkpgoKgUu/sJIWiPvvCL6ZjIqfH4k+FmuCE0lJ1GCfeaLj/uzwEqdag78w2aMFKdPbK1tP+aZi0lOwNN6GXmqmE3fXNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nvcvWBQXy23qgYN6qax3oOEPpAc4Ie94rn39rMo5Ljg=;
 b=Gb6NmkZn2NtEzXkvhe4PBl2zu+3+zhuJ9VKYwUlZqDrbWtCR5k3W8XUo2VwDN4u/Zd8m363fhN6oce2QpAb05BbUz33h/rLNL+LB9eJEaW34ycrVBF5r4ReDzKxd0cv1PgEjFdFcqiWxGMeesuSOJ1d5I9ESmmqF3qQP+CpilWI=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
 by MN2PR11MB4398.namprd11.prod.outlook.com (2603:10b6:208:18b::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.20; Fri, 10 Apr
 2020 13:33:18 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::3d0a:d9ac:3df4:8b1]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::3d0a:d9ac:3df4:8b1%6]) with mapi id 15.20.2878.021; Fri, 10 Apr 2020
 13:33:18 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 10/19] staging: wfx: drop unnecessary condition checks in wfx_upload_ap_templates()
Date:   Fri, 10 Apr 2020 15:32:30 +0200
Message-Id: <20200410133239.438347-11-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200410133239.438347-1-Jerome.Pouiller@silabs.com>
References: <20200410133239.438347-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: DM5PR15CA0056.namprd15.prod.outlook.com
 (2603:10b6:3:ae::18) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:1265:30ff:fefd:6e7f) by DM5PR15CA0056.namprd15.prod.outlook.com (2603:10b6:3:ae::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.15 via Frontend Transport; Fri, 10 Apr 2020 13:33:16 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:2435:66a0:1265:30ff:fefd:6e7f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 900041d9-e2ef-4dac-68b2-08d7dd53ba82
X-MS-TrafficTypeDiagnostic: MN2PR11MB4398:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR11MB4398E4F03391EA5A9B5B070393DE0@MN2PR11MB4398.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0369E8196C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4063.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(366004)(346002)(396003)(136003)(39850400004)(376002)(107886003)(81156014)(54906003)(8676002)(86362001)(1076003)(6666004)(8936002)(4326008)(52116002)(66574012)(7696005)(316002)(66556008)(66946007)(186003)(478600001)(2906002)(6486002)(2616005)(66476007)(16526019)(5660300002)(36756003);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AFYy6hQPlA3VIDCRL/GOZpCw0tOMIKwHVOLuzVMsW8oCQNQDBh0e37Zw/i0mNv/uXWHPoW9Ay6U7u8pXGMLlxlYTWcGudqKY87J0Nii5MEf4UAqKE6uDQnMoJzegtwF401TrHmRxPLP4SW5bOIUdDKXV2ov0wLHMhtLGoSYNfTSC6C8bnyK8jmEQK+evaCbNpj3GCeg8LU205ZOjhRuhM7GFmCS+mYerpxnDE7LjND+OvcEAMedx4w/Oakt+e/zVjd/Vj/CMwX7vIfBacbsDHlgxmVWtapbvp6fhjbfnpMEdm/hACcv7/w4gLMsuhBV7MMTMi7LZq4ORista8Buy8jTAjsEn/weLV1tOGjZXPOvNxYzr3kw3xDZTgB/cehJj55Cx/oiuIYDWVhNI5N3mJOMBRAs+FojQBGF6kvAOq1WQU4OrtVs4JK0+9dRsXRbs
X-MS-Exchange-AntiSpam-MessageData: 48AbuPnTdC91xtTP9CDaHnfM18A1W8IYZ09GSsse3Vgto+mfH7usELVFtBttbIkKKYh43QeovXKSm2ZErdkUblqGHe8/ZcZ9bYgHTrpSONXON/cSjwX0mMvN88ueaq6veIJQMx+cWCET5rZ9My0zswl2Bm4IfPauEjlJqzrrYqCleQjksCq07BOHVT5HB5xkZSKQQcUB/b60/mEzsph3dQ==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 900041d9-e2ef-4dac-68b2-08d7dd53ba82
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2020 13:33:18.0515
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gCuMVRCn0dlqk9cd3Me4AVnTcc7fOimLmHU72kizjeOP56Fm3rjp0bbwkdgVstbEYYC+dpIwtBBiqJJo+KnttQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4398
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSW4g
Zm9ybWVyIGNvZGUsIHdmeF91cGxvYWRfYXBfdGVtcGxhdGVzKCkgd2FzIGNhbGxlZCBpbiBtb3Jl
IGNhc2VzCnRoYW4gbmVjZXNzYXJ5LiBUaGVyZWZvcmUsIGl0IHRyaWVkIHRvIG5vdCB1cGRhdGUg
dGhlIGZyYW1lIHRlbXBsYXRlcwppZiBpdCB3YXMgbm90IG5lY2Vzc2FyeS4KCk5vdywgd2Z4X3Vw
bG9hZF9hcF90ZW1wbGF0ZXMoKSBpcyBjYWxsZWQgb25seSBpZiBtYWM4MDIxMSBhc2tlZCB0bwp1
cGRhdGUgdGhlIHRlbXBsYXRlcy4gSW4gYWRkLCBpdCBkb2VzIG5vdCBodXJ0IHRvIHVwbG9hZCB0
ZW1wbGF0ZSBpZgp0aGV5IGFyZSBub3QgdXNlZC4gU28sIHJlbW92ZSB1bm5lY2Vzc2FyeSBjb25k
aXRpb25zIGF0IGJlZ2lubmluZyBvZgp3ZnhfdXBsb2FkX2FwX3RlbXBsYXRlcygpCgpTaWduZWQt
b2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0t
LQogZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyB8IDUgLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCA1
IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgYi9k
cml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCmluZGV4IGIwNTU3ZGFiOTFmZC4uN2FmN2JmYTRhYzk5
IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCisrKyBiL2RyaXZlcnMvc3Rh
Z2luZy93Zngvc3RhLmMKQEAgLTU3MCwxMSArNTcwLDYgQEAgc3RhdGljIGludCB3ZnhfdXBsb2Fk
X2FwX3RlbXBsYXRlcyhzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZikKIHsKIAlzdHJ1Y3Qgc2tfYnVmZiAq
c2tiOwogCi0JaWYgKHd2aWYtPnZpZi0+dHlwZSA9PSBOTDgwMjExX0lGVFlQRV9TVEFUSU9OIHx8
Ci0JICAgIHd2aWYtPnZpZi0+dHlwZSA9PSBOTDgwMjExX0lGVFlQRV9NT05JVE9SIHx8Ci0JICAg
IHd2aWYtPnZpZi0+dHlwZSA9PSBOTDgwMjExX0lGVFlQRV9VTlNQRUNJRklFRCkKLQkJcmV0dXJu
IDA7Ci0KIAlza2IgPSBpZWVlODAyMTFfYmVhY29uX2dldCh3dmlmLT53ZGV2LT5odywgd3ZpZi0+
dmlmKTsKIAlpZiAoIXNrYikKIAkJcmV0dXJuIC1FTk9NRU07Ci0tIAoyLjI1LjEKCg==
