Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07BE719AA33
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 13:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732354AbgDALFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 07:05:02 -0400
Received: from mail-eopbgr750070.outbound.protection.outlook.com ([40.107.75.70]:46082
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732335AbgDALE7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Apr 2020 07:04:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oWEweFxP8RflJJVWA1cp8SZjkDPllXFmen0QHeZGAfTm2wVXL0Ckm2wRu8EUKV8ftuGfgYrY15DaLeImd2CmhdCvx+YhDVigux4zVOlHTqfltCt2G1zsCch5Hl/FG75r2xlncGNag+z9HT6hXtXl1BfBn7z2rijYX+RSPNGH2XbnaiHN1BD6X6yNxkHAH8F+tC33L/GRVQpaX0WF4cXR6+1Lswu7tUlfJbCrXsss7SNkYh4LgPBO9mojVkoCzPS8T/X5IsjpEbB9ML220jK3DHzc2gG3Pe/YRibRTTs8yQCqY6fmeRp5NPEiSpbYHJW5kz/cWGvXrYms/4pAkEyjqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+PagPWzCkbCX2OEL2UTnVfEMuWRkvSgV+q27nmCjK0c=;
 b=OsIfBnr343ELacbhqr3VyvOfhgL5gYSZhfOYIG7JWC9NLxH/pl6ItuQtj/vRm04Kooosxl9HXpa0Y8I1vBkomQg4MAtjmDj/9mfWFM1FHK7X8h7HlIX+NsbAbn21JJgzhLAaMHq/nYRkhotIJn1neJabS/I/CZl+KIql21vBmWL3Ra1cQ/OFaU1mYczpAjkBfilgaRqfoHMgAxYbmBBTTNE2g06tA9J4DdPEiSXQyAKbBDI5d9y40geTxbpR8GCqTwIa0FqGS6LMu2zO78ntIfHSkRVbngiIcPYxTLmNQ1uh/Lw40Un4U4G29/8ClVv5PihuQAs1LvFNFXrVW5btOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+PagPWzCkbCX2OEL2UTnVfEMuWRkvSgV+q27nmCjK0c=;
 b=hOTvwm/WTOu87pcv63FAM2QqgmQ/eKLvSxzMyEnJpvK+QC3C8TCUM4RWMO4TQOv3geOcLqr57/feQx4w0kIadDDTnoXZfMGzjTNJbMF2/pXFnG+UrLxCtOZj+mClG7Wbe0LCn3gQ3Ts9SbgMm1CCaAAp4y9RuPOFOFZAEEeQsiQ=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
 by MN2PR11MB4285.namprd11.prod.outlook.com (2603:10b6:208:191::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20; Wed, 1 Apr
 2020 11:04:40 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3%7]) with mapi id 15.20.2856.019; Wed, 1 Apr 2020
 11:04:40 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 10/32] staging: wfx: drop unused argument in wfx_get_prio_queue()
Date:   Wed,  1 Apr 2020 13:03:43 +0200
Message-Id: <20200401110405.80282-11-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:1265:30ff:fefd:6e7f) by SN4PR0501CA0156.namprd05.prod.outlook.com (2603:10b6:803:2c::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.9 via Frontend Transport; Wed, 1 Apr 2020 11:04:38 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:2435:66a0:1265:30ff:fefd:6e7f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 618bdf62-16e4-4f0a-8cc6-08d7d62c798d
X-MS-TrafficTypeDiagnostic: MN2PR11MB4285:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR11MB42855F07A67DC160CE26B70C93C90@MN2PR11MB4285.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:350;
X-Forefront-PRVS: 03607C04F0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4063.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(136003)(366004)(346002)(376002)(39850400004)(396003)(7696005)(8676002)(1076003)(16526019)(186003)(6666004)(5660300002)(86362001)(4326008)(52116002)(478600001)(66946007)(66476007)(54906003)(36756003)(8936002)(316002)(81156014)(6486002)(2906002)(66556008)(107886003)(81166006)(2616005);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xEuvXvVE/+Tz0lLp94EZRk9RJ679sjNbPKe0K9WGp7V+tMx6vTBe449RoqgBTnmUoym/imY633wE+JFFtqaNZLtpf9r5MXImWvDpd7+IdVNag/4vP9uVtTOt7t5rbluJdTUhCwy10oiFB/bqtZX7pcjJgwXTfCe1l1T7zF9QZNp6xZYXQQwzDGETVFkYUULVdmbzQHFJAzKD7ISaEOEdJgcETpJW7/awRiq5ExCtoMMlXzNeZz9NNjj0eMvFs7H2JAYkdxadfvN4Wi5LqmSqeEzN/zddlsEemxYWUVAbxJMMfXjytT5Mw3rwuXjnsfQX0aEBOq3sC+IUHnJ6BIJjPyGdyTCnE8Q3BN46PdqQA2gTIuaBF9oYoKuM+mCeHz7BWTWJ/Y1gEQK1xUcQEnOEdPLMYCJ9qLh5ilVk8Anv4rTNwcztjZM2e511PwLao/D0
X-MS-Exchange-AntiSpam-MessageData: 0eyCTxWLkrtAZYOo7FMivaaYEsNs1FDNk9ibxdJIHxLMoiMXIn557iBQh9cfNrHeX0BhjfspPeqbTKwqeEkIH9+xCgT0RNt8b+aRIsmQJAap9zbVNmn3iL/+LasBPMyp1x93ULCMa7w3sOKw97jzyABq5vFbuWVwPq/pIc1bqtsi7B7kKepBITGKOClwm5KrHBz043a02GvBn/ym4hWBHw==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 618bdf62-16e4-4f0a-8cc6-08d7d62c798d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2020 11:04:40.4728
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gh9anUq6+mEcNY6CCcwbfnh2IQz9m3iczXdM7cQUx857mLZ0TI/jdzR10i0pey/ppBaR4FNu4NgoXBPiUHjOcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4285
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGFyZ3VtZW50ICJ0b3RhbCIgaXMgbm90IHVzZWQgYW55bW9yZSBzaW5jZSBjb21taXQgYTNjNTI5
YTgzNTg5Cigic3RhZ2luZzogd2Z4OiBzaW1wbGlmeSBoYW5kbGluZyBvZiBJRUVFODAyMTFfVFhf
Q1RMX1NFTkRfQUZURVJfRFRJTSIpLgoKRml4ZXM6IGEzYzUyOWE4MzU4OSAoInN0YWdpbmc6IHdm
eDogc2ltcGxpZnkgaGFuZGxpbmcgb2YgSUVFRTgwMjExX1RYX0NUTF9TRU5EX0FGVEVSX0RUSU0i
KQpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFi
cy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5jIHwgNyArKy0tLS0tCiAxIGZp
bGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBh
L2RyaXZlcnMvc3RhZ2luZy93ZngvcXVldWUuYyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvcXVldWUu
YwppbmRleCAwOWY4MjM5MjlmYjYuLmJiYWI2YjE5MmIwYyAxMDA2NDQKLS0tIGEvZHJpdmVycy9z
dGFnaW5nL3dmeC9xdWV1ZS5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvcXVldWUuYwpAQCAt
MzU0LDggKzM1NCw3IEBAIHN0YXRpYyBib29sIHdmeF9oYW5kbGVfdHhfZGF0YShzdHJ1Y3Qgd2Z4
X2RldiAqd2Rldiwgc3RydWN0IHNrX2J1ZmYgKnNrYikKIAl9CiB9CiAKLXN0YXRpYyBpbnQgd2Z4
X2dldF9wcmlvX3F1ZXVlKHN0cnVjdCB3ZnhfdmlmICp3dmlmLAotCQkJCSB1MzIgdHhfYWxsb3dl
ZF9tYXNrLCBpbnQgKnRvdGFsKQorc3RhdGljIGludCB3ZnhfZ2V0X3ByaW9fcXVldWUoc3RydWN0
IHdmeF92aWYgKnd2aWYsIHUzMiB0eF9hbGxvd2VkX21hc2spCiB7CiAJY29uc3Qgc3RydWN0IGll
ZWU4MDIxMV90eF9xdWV1ZV9wYXJhbXMgKmVkY2E7CiAJdW5zaWduZWQgaW50IHNjb3JlLCBiZXN0
ID0gLTE7CkBAIC0zNzEsNyArMzcwLDYgQEAgc3RhdGljIGludCB3ZnhfZ2V0X3ByaW9fcXVldWUo
c3RydWN0IHdmeF92aWYgKnd2aWYsCiAJCQkJdHhfYWxsb3dlZF9tYXNrKTsKIAkJaWYgKCFxdWV1
ZWQpCiAJCQljb250aW51ZTsKLQkJKnRvdGFsICs9IHF1ZXVlZDsKIAkJc2NvcmUgPSAoKGVkY2Et
PmFpZnMgKyBlZGNhLT5jd19taW4pIDw8IDE2KSArCiAJCQkoKGVkY2EtPmN3X21heCAtIGVkY2Et
PmN3X21pbikgKgogCQkJIChnZXRfcmFuZG9tX2ludCgpICYgMHhGRkZGKSk7CkBAIC0zOTAsNyAr
Mzg4LDYgQEAgc3RhdGljIGludCB3ZnhfdHhfcXVldWVfbWFza19nZXQoc3RydWN0IHdmeF92aWYg
Knd2aWYsCiB7CiAJaW50IGlkeDsKIAl1MzIgdHhfYWxsb3dlZF9tYXNrOwotCWludCB0b3RhbCA9
IDA7CiAKIAkvKiBTZWFyY2ggZm9yIHVuaWNhc3QgdHJhZmZpYyAqLwogCXR4X2FsbG93ZWRfbWFz
ayA9IH53dmlmLT5zdGFfYXNsZWVwX21hc2s7CkBAIC0zOTksNyArMzk2LDcgQEAgc3RhdGljIGlu
dCB3ZnhfdHhfcXVldWVfbWFza19nZXQoc3RydWN0IHdmeF92aWYgKnd2aWYsCiAJCXR4X2FsbG93
ZWRfbWFzayAmPSB+QklUKFdGWF9MSU5LX0lEX0FGVEVSX0RUSU0pOwogCWVsc2UKIAkJdHhfYWxs
b3dlZF9tYXNrIHw9IEJJVChXRlhfTElOS19JRF9BRlRFUl9EVElNKTsKLQlpZHggPSB3ZnhfZ2V0
X3ByaW9fcXVldWUod3ZpZiwgdHhfYWxsb3dlZF9tYXNrLCAmdG90YWwpOworCWlkeCA9IHdmeF9n
ZXRfcHJpb19xdWV1ZSh3dmlmLCB0eF9hbGxvd2VkX21hc2spOwogCWlmIChpZHggPCAwKQogCQly
ZXR1cm4gLUVOT0VOVDsKIAotLSAKMi4yNS4xCgo=
