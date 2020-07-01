Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 351E4210EA4
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 17:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731908AbgGAPIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 11:08:42 -0400
Received: from mail-bn8nam12on2056.outbound.protection.outlook.com ([40.107.237.56]:52640
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731894AbgGAPIk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 11:08:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hDaBIpifOQRyC+dV7neHvPHVDo5V3fdnuMB/MAjg0Bxs4OBbbRWu7tzf1Nh0dc/2SJvvPOiZ/FxzdsQKn8ZoCoLVn0NQwBmjQrf/qe3saqJgFW5om+BYfIAiemnJfJBMph02ec38aD+WDq4KjfCrznsXi6VByULisxTuALFJTDrej+yL+o3fz//a9U8ydGetU1/lMYaWDkLFIBoqOocZpydGnSnrx3YHJfkeorgdEXJg3HYi5faetyLkS0CbLxCNvnADkCSMm89NyE7SqEZ71DmB/DDz6v80M05fVpUYVEawf4HVWyWZY30QCxwypf0w1EK9Xp7kD2euaYiM+3dfYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/tFsZywwSyc+AP6p6DjdgN/d574t4Q2WgeJIgrywvdw=;
 b=UD+dWBp5EpL097MwGwCj42qMQqX1xkrFRC7qE7Fq1axlymldnjmE4OboH8UHKG8LZi4a4+dwM7WIWt8isgU9AFMEuC/ni0wYre+Bu+xGB9mH3o+UI0WlApMMTW4+r3ZV2VlTNAq4qUV84GOOWZdbeIsu9/iUhApmUUv4PEK7tgUEeuHAXzzXx3rFBvfwgoxN1wHF00PgN5guzz9K9sUGueUOGhjnAHOnOGbRJqkjCqJJrbVasRcZNf7EueEJBLIfJ4zsxop8HyQdSg3wv3kW/bZ3XnRbXaLKJWHq1KMSTTP9x6Xmui+271OMLUDVBjNsEvREygYrBfrxOCV+f25+yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/tFsZywwSyc+AP6p6DjdgN/d574t4Q2WgeJIgrywvdw=;
 b=mEkzev59kiz/jQIlQQ6Xg0mhpk0JWkZ0Zn89V/fo1NtoLedLYUsRwyyvc6FoUu84hPf2G4e7PJ9djHOrFzgtUV4Z6bUCKAXxCKatcM7+Pxq2lznshZ7HrDksGCbCshMgEYw+ivf7mgxESjoIIuv89f84eUXeqSN/QdWfNWa1WBU=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA0PR11MB4736.namprd11.prod.outlook.com (2603:10b6:806:9f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.22; Wed, 1 Jul
 2020 15:08:26 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::c504:2d66:a8f7:2336]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::c504:2d66:a8f7:2336%7]) with mapi id 15.20.3131.033; Wed, 1 Jul 2020
 15:08:26 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 13/13] staging: wfx: always enable FastPs in combo with new firmwares
Date:   Wed,  1 Jul 2020 17:07:07 +0200
Message-Id: <20200701150707.222985-14-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200701150707.222985-1-Jerome.Pouiller@silabs.com>
References: <20200701150707.222985-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: DM5PR07CA0143.namprd07.prod.outlook.com
 (2603:10b6:3:13e::33) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by DM5PR07CA0143.namprd07.prod.outlook.com (2603:10b6:3:13e::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.21 via Frontend Transport; Wed, 1 Jul 2020 15:08:24 +0000
X-Mailer: git-send-email 2.27.0
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0b5f5ab2-27ca-4028-0a00-08d81dd09aa7
X-MS-TrafficTypeDiagnostic: SA0PR11MB4736:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR11MB4736E79A8D66255BA3BA559D936C0@SA0PR11MB4736.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1388;
X-Forefront-PRVS: 04519BA941
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V9vHIZFE/Cke8VZOAgjzr9tiatQXjNUZA267rfJ/hfRGXrQ9cCQLZXhRvCxav0oz67X0MeEFeikhbd708aChDd+4b9Uq7IxFmEDX5ikXaVpst3uDbv5vgmGtrBeHK8AbXLGH5PmfTClo7JIyLj3SJH7RrtYlcN0l9+U6A9XMTPiNgU+qTHL5eHW8P/BItrwVl3NbiW+DLzD6qAu8ByD3tgoxVJNA30zn3b0pFlOx/E8Vj+9FZCj1wBxYU1AZiRXJOx/sTtf/ZwL4utoGTha7gWRLxua2RAVOqae0JaLHJr5qwO+RbxBByzLIgOrzItfnS/NUnmbZIEgMcIbrWLZ8sA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39850400004)(366004)(346002)(376002)(396003)(136003)(5660300002)(6486002)(86362001)(6666004)(66574015)(36756003)(2906002)(186003)(83380400001)(16526019)(8936002)(66556008)(66476007)(107886003)(4326008)(8676002)(2616005)(1076003)(478600001)(316002)(54906003)(66946007)(52116002)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: z5vKuWNgOGebDIFzr/TuK5f3VWsnYDDxjMve2HlhYocRHZmS1OV3+jdYb42pNja1Ft1iTLQ0zgYIBY/MYUQx6mjcieFDc05aevQAT9nzoIzRREzDCukNMsx15rB5eTw6ysTO+ID679Ccl/Cf1a/pSN2GkNk49rzyOedVGYHvhe7plrL5zhnEOHYsvtKN6ARHMeBnyxn9QCpOxfopgRxsHIrZ6zI0pUT1DjSwVwPRil9NhaCzhEg6ZRpl8rVeruBRWPDj4nNDcehmZL7Vy/vBsa7BQ2UhyDQYgDma0f5Zp7UURlKErg3XaiphuoymiUbospodgcnt3csn5afRjaOmdIUrU17WBXYU6bt6BJ92s6ZhrcYXoBsDj/HD+H2dGMys1S9+hNtzERy0tMK71qxJs8B9/1dzCNB5ibciXvsxy00WD3ymmO5WdUUpMDEwLEmM5bIZ7xays78fZF0TTxhMjvX+6up0im3SqkssEW0Dg6Fl7sp7v0FPT+tmg0X0lbQn+/cupOWqh2RfWRbPzjCZ5oQoNYt9yjw5ywYOmFn7bsI=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b5f5ab2-27ca-4028-0a00-08d81dd09aa7
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2020 15:08:26.0395
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qe65E8kDruc3BLLvdwDKZ7wJT8FJLkN6Bj71LuyQVWv8HfYfcN/F3vv0FYvfJQN0aRZchkhjHcc7lXTu8sgBgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4736
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKV2hl
biBtdWx0aXBsZSBpbnRlcmZhY2Ugb24gZGlmZmVyZW50IGNoYW5uZWxzIGFyZSBpbiB1c2UuIEl0
IGlzCm5lY2Vzc2FyeSB0byBhZHZlcnRpc2UgdGhlIEFQIHRoYXQgdGhlIGRldmljZSBpcyBubyBt
b3JlIGF3YWtlIGJlZm9yZSB0bwpzd2l0Y2ggdG8gdGhlIG90aGVyIGNoYW5uZWwuCgpVbnRpbCBu
b3csIFBTLVBvbGwgd2FzIHRoZSBwcmVmZXJyZWQgbWVjaGFuaXNtIGZvciB0aGF0LiBIb3dldmVy
LiAgVGhlCm5ldyBmaXJtd2FyZXMgKD49IDMuNykgbm93IG5pY2VseSBzdXBwb3J0IEZhc3RQUy4K
CkZhc3RQUyBpbXByb3ZlcyBiYW5kd2lkdGggYW5kIGNvbXBhdGliaWxpdHkgd2l0aCBBUC4KClRo
aXMgcGF0Y2ggZHJvcCB0aGUgY29tcGxleCBhbmQgcmFyZWx5IHVzZWQgbWVjaGFuaXNtIGludHJv
ZHVjZWQgaW4gdGhlCmNvbW1pdCBkZDVlYmExYmI1YjRmICgic3RhZ2luZzogd2Z4OiBmaXggc3Vw
cG9ydCBmb3IgQVAgdGhhdCBkbyBub3QKc3VwcG9ydCBQUy1Qb2xsIikgYW5kIHVzZSBGYXN0UFMg
YXMgc29vbiBhcyBpdCBpcyBwb3NzaWJsZS4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWls
bGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4
L2hpZl9yeC5jIHwgIDggKy0tLS0tLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgICAgfCAx
NiArKystLS0tLS0tLS0tLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3dmeC5oICAgIHwgIDIgLS0K
IDMgZmlsZXMgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspLCAyMiBkZWxldGlvbnMoLSkKCmRpZmYg
LS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9yeC5jIGIvZHJpdmVycy9zdGFnaW5nL3dm
eC9oaWZfcnguYwppbmRleCBlM2ViZDkxMGZhYmZkLi5jYzdjMGNmMjI2YmExIDEwMDY0NAotLS0g
YS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9yeC5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngv
aGlmX3J4LmMKQEAgLTE0OSw3ICsxNDksNiBAQCBzdGF0aWMgaW50IGhpZl9ldmVudF9pbmRpY2F0
aW9uKHN0cnVjdCB3ZnhfZGV2ICp3ZGV2LAogCXN0cnVjdCB3ZnhfdmlmICp3dmlmID0gd2Rldl90
b193dmlmKHdkZXYsIGhpZi0+aW50ZXJmYWNlKTsKIAljb25zdCBzdHJ1Y3QgaGlmX2luZF9ldmVu
dCAqYm9keSA9IGJ1ZjsKIAlpbnQgdHlwZSA9IGxlMzJfdG9fY3B1KGJvZHktPmV2ZW50X2lkKTsK
LQlpbnQgY2F1c2U7CiAKIAlpZiAoIXd2aWYpIHsKIAkJZGV2X3dhcm4od2Rldi0+ZGV2LCAicmVj
ZWl2ZWQgZXZlbnQgZm9yIG5vbi1leGlzdGVudCB2aWZcbiIpOwpAQCAtMTY4LDEzICsxNjcsOCBA
QCBzdGF0aWMgaW50IGhpZl9ldmVudF9pbmRpY2F0aW9uKHN0cnVjdCB3ZnhfZGV2ICp3ZGV2LAog
CQlkZXZfZGJnKHdkZXYtPmRldiwgImlnbm9yZSBCU1NSRUdBSU5FRCBpbmRpY2F0aW9uXG4iKTsK
IAkJYnJlYWs7CiAJY2FzZSBISUZfRVZFTlRfSU5EX1BTX01PREVfRVJST1I6Ci0JCWNhdXNlID0g
bGUzMl90b19jcHUoYm9keS0+ZXZlbnRfZGF0YS5wc19tb2RlX2Vycm9yKTsKIAkJZGV2X3dhcm4o
d2Rldi0+ZGV2LCAiZXJyb3Igd2hpbGUgcHJvY2Vzc2luZyBwb3dlciBzYXZlIHJlcXVlc3Q6ICVk
XG4iLAotCQkJIGNhdXNlKTsKLQkJaWYgKGNhdXNlID09IEhJRl9QU19FUlJPUl9BUF9OT1RfUkVT
UF9UT19QT0xMKSB7Ci0JCQl3dmlmLT5ic3Nfbm90X3N1cHBvcnRfcHNfcG9sbCA9IHRydWU7Ci0J
CQlzY2hlZHVsZV93b3JrKCZ3dmlmLT51cGRhdGVfcG1fd29yayk7Ci0JCX0KKwkJCSBsZTMyX3Rv
X2NwdShib2R5LT5ldmVudF9kYXRhLnBzX21vZGVfZXJyb3IpKTsKIAkJYnJlYWs7CiAJZGVmYXVs
dDoKIAkJZGV2X3dhcm4od2Rldi0+ZGV2LCAidW5oYW5kbGVkIGV2ZW50IGluZGljYXRpb246ICUu
MnhcbiIsCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jIGIvZHJpdmVycy9z
dGFnaW5nL3dmeC9zdGEuYwppbmRleCBmZGY0ZjQ4ZGRjMmNlLi40ZTMwYWIxN2E5M2Q0IDEwMDY0
NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93
Zngvc3RhLmMKQEAgLTIxOSwxMCArMjE5LDEwIEBAIHN0YXRpYyBpbnQgd2Z4X2dldF9wc190aW1l
b3V0KHN0cnVjdCB3ZnhfdmlmICp3dmlmLCBib29sICplbmFibGVfcHMpCiAJCQkqZW5hYmxlX3Bz
ID0gdHJ1ZTsKIAkJaWYgKHd2aWYtPndkZXYtPmZvcmNlX3BzX3RpbWVvdXQgPiAtMSkKIAkJCXJl
dHVybiB3dmlmLT53ZGV2LT5mb3JjZV9wc190aW1lb3V0OwotCQllbHNlIGlmICh3dmlmLT5ic3Nf
bm90X3N1cHBvcnRfcHNfcG9sbCkKLQkJCXJldHVybiAzMDsKLQkJZWxzZQorCQllbHNlIGlmICh3
ZnhfYXBpX29sZGVyX3RoYW4od3ZpZi0+d2RldiwgMywgMikpCiAJCQlyZXR1cm4gMDsKKwkJZWxz
ZQorCQkJcmV0dXJuIDMwOwogCX0KIAlpZiAoZW5hYmxlX3BzKQogCQkqZW5hYmxlX3BzID0gd3Zp
Zi0+dmlmLT5ic3NfY29uZi5wczsKQEAgLTI1NSwxNCArMjU1LDYgQEAgaW50IHdmeF91cGRhdGVf
cG0oc3RydWN0IHdmeF92aWYgKnd2aWYpCiAJcmV0dXJuIGhpZl9zZXRfcG0od3ZpZiwgcHMsIHBz
X3RpbWVvdXQpOwogfQogCi1zdGF0aWMgdm9pZCB3ZnhfdXBkYXRlX3BtX3dvcmsoc3RydWN0IHdv
cmtfc3RydWN0ICp3b3JrKQotewotCXN0cnVjdCB3ZnhfdmlmICp3dmlmID0gY29udGFpbmVyX29m
KHdvcmssIHN0cnVjdCB3ZnhfdmlmLAotCQkJCQkgICAgdXBkYXRlX3BtX3dvcmspOwotCi0Jd2Z4
X3VwZGF0ZV9wbSh3dmlmKTsKLX0KLQogaW50IHdmeF9jb25mX3R4KHN0cnVjdCBpZWVlODAyMTFf
aHcgKmh3LCBzdHJ1Y3QgaWVlZTgwMjExX3ZpZiAqdmlmLAogCQkgICB1MTYgcXVldWUsIGNvbnN0
IHN0cnVjdCBpZWVlODAyMTFfdHhfcXVldWVfcGFyYW1zICpwYXJhbXMpCiB7CkBAIC0zNzIsNyAr
MzY0LDYgQEAgdm9pZCB3ZnhfcmVzZXQoc3RydWN0IHdmeF92aWYgKnd2aWYpCiAJCWhpZl9zZXRf
YmxvY2tfYWNrX3BvbGljeSh3dmlmLCAweEZGLCAweEZGKTsKIAl3ZnhfdHhfdW5sb2NrKHdkZXYp
OwogCXd2aWYtPmpvaW5faW5fcHJvZ3Jlc3MgPSBmYWxzZTsKLQl3dmlmLT5ic3Nfbm90X3N1cHBv
cnRfcHNfcG9sbCA9IGZhbHNlOwogCWNhbmNlbF9kZWxheWVkX3dvcmtfc3luYygmd3ZpZi0+YmVh
Y29uX2xvc3Nfd29yayk7CiAJd3ZpZiA9ICBOVUxMOwogCXdoaWxlICgod3ZpZiA9IHd2aWZfaXRl
cmF0ZSh3ZGV2LCB3dmlmKSkgIT0gTlVMTCkKQEAgLTc5MCw3ICs3ODEsNiBAQCBpbnQgd2Z4X2Fk
ZF9pbnRlcmZhY2Uoc3RydWN0IGllZWU4MDIxMV9odyAqaHcsIHN0cnVjdCBpZWVlODAyMTFfdmlm
ICp2aWYpCiAKIAlpbml0X2NvbXBsZXRpb24oJnd2aWYtPnNldF9wbV9tb2RlX2NvbXBsZXRlKTsK
IAljb21wbGV0ZSgmd3ZpZi0+c2V0X3BtX21vZGVfY29tcGxldGUpOwotCUlOSVRfV09SSygmd3Zp
Zi0+dXBkYXRlX3BtX3dvcmssIHdmeF91cGRhdGVfcG1fd29yayk7CiAJSU5JVF9XT1JLKCZ3dmlm
LT50eF9wb2xpY3lfdXBsb2FkX3dvcmssIHdmeF90eF9wb2xpY3lfdXBsb2FkX3dvcmspOwogCiAJ
bXV0ZXhfaW5pdCgmd3ZpZi0+c2Nhbl9sb2NrKTsKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2lu
Zy93Zngvd2Z4LmggYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3dmeC5oCmluZGV4IDQ3N2MwOGZjNzEz
ZmEuLjM4ZTI0ZDdmNzJmMjQgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngvd2Z4LmgK
KysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC93ZnguaApAQCAtOTMsOCArOTMsNiBAQCBzdHJ1Y3Qg
d2Z4X3ZpZiB7CiAJYm9vbAkJCXNjYW5fYWJvcnQ7CiAJc3RydWN0IGllZWU4MDIxMV9zY2FuX3Jl
cXVlc3QgKnNjYW5fcmVxOwogCi0JYm9vbAkJCWJzc19ub3Rfc3VwcG9ydF9wc19wb2xsOwotCXN0
cnVjdCB3b3JrX3N0cnVjdAl1cGRhdGVfcG1fd29yazsKIAlzdHJ1Y3QgY29tcGxldGlvbglzZXRf
cG1fbW9kZV9jb21wbGV0ZTsKIH07CiAKLS0gCjIuMjcuMAoK
