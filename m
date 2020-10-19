Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 079B1292B16
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 18:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730529AbgJSQG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 12:06:28 -0400
Received: from mail-bn8nam11on2051.outbound.protection.outlook.com ([40.107.236.51]:30081
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730320AbgJSQG1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 12:06:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TXqS4D4BH7CccWuKtmfPzTGN09y8hAg1RL2EsbwhTF1JMdETHNpDFk5UBrB/PsPbos8FUPx+QqR1L5hlFfhaLNIVrJbQrIzARrglL8v9h31GA1zkyxijZv2g6hFIQ/csdU3L+ElQw5Tb7yWUq+cSbjC4GssT+hArDu1KffEQoFk8OVH3gFV8Wl9tZq5/hfVR3/t7mM+qOpsObYWL7qKR//SV8aA+DrkIxzUrSQMRJ+bI0UqnD6XNLx3ESQsYal/td4wmVWDJ0nFom0hxl4gsn/hEUxbY1w/dbxkjUd0ROTYDeygzOoKgXuD+68EE6fnmEii2hDGGFXYQHL97JdWtuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Co6dGmH4SD6AAetVLlUR+nXTWfolf7Say6+3lluM7fo=;
 b=Sd/YnsmNKQvmMaNMpe+5CqaIqUIYDQCh3Kaf3Rtx2qeCpEKPdwvbfuNLAsXZXuliJ3dC+cBKLR21biqMT5X/DcGXECN0PKsXo8zLkhcMlTeLg42YZW5rEwdnX4xdQPMfqBP+pUjqvrvibgzYkue4PqI/Dkkhob7/7Xa1ld8sZTh/77pmpoguw6jnK3IwMEWDmjgdA2PdxLYwxUnrtHXS0etdFQbDE6fTlYe02Rg88oah43eSIVllPwCsNQgzCrApeBKtT+MGb1Yo2eZTW0C+2TLrQEqi/VofuVeQVvgtM8XBn27o66lixGouBxEdzRRzxgr3e3s//2qJWKAO1tDNbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Co6dGmH4SD6AAetVLlUR+nXTWfolf7Say6+3lluM7fo=;
 b=Z3XfwT1aM5FxBM/vZWOXIBp9wcq+Ky0YDXKHZtFEVLlKnXgI40frkGr7jPsF7zYKV/e70dTWqo3sDezEBqznFmGh9qKhWEzJMPSSxEwtgkQIjB475S82uivNLkmabfl4/nsSHBu8wW69zcpfhTB14nQ0B32/6J4HpFSGnShBtD4=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA2PR11MB5129.namprd11.prod.outlook.com (2603:10b6:806:11f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.27; Mon, 19 Oct
 2020 16:06:24 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a%5]) with mapi id 15.20.3477.028; Mon, 19 Oct 2020
 16:06:24 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>, kernel test robot <lkp@intel.com>,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH 1/2] staging: wfx: fix use of uninitialized pointer
Date:   Mon, 19 Oct 2020 18:06:03 +0200
Message-Id: <20201019160604.1609180-1-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.28.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Originating-IP: [37.71.187.125]
X-ClientProxiedBy: PR0P264CA0225.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1e::21) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (37.71.187.125) by PR0P264CA0225.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1e::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21 via Frontend Transport; Mon, 19 Oct 2020 16:06:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 15ebb35f-f089-47fd-2389-08d87448ed77
X-MS-TrafficTypeDiagnostic: SA2PR11MB5129:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR11MB512995FD44BFBA6FDF723E3A931E0@SA2PR11MB5129.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1284;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yyyObbQxzjw5UpK42fAOHCoIDMokRhZBcTjf7vhYSigi+Gty936kgsOTGnM7yRABPksGzxROYaZW1KbfLIsPfRFN6RO6JlgBv3Sea5fMajNIkcpaNrka9IwWK3Qx2J8/JvXNpV/8FECJwtsx1stJh6uPD5/7lIS9r9mdO6gyEBr5RwttmPeiR3f21soi3bvtGddAaSRLp3sYC0PH0YsJzMInA3UoKiDXQA2QNMafYfORcT9092FZWfhqydOlBLOIg/WF9scD6+p1AqrsPXgMJIjZy+TDnOfr5ViqF2LiWLqXG56vMa8dySMQ3m6ILdXk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(136003)(396003)(39850400004)(366004)(26005)(8936002)(54906003)(186003)(6486002)(16526019)(316002)(478600001)(8676002)(52116002)(7696005)(6666004)(2906002)(4326008)(1076003)(36756003)(66574015)(956004)(66946007)(66476007)(86362001)(2616005)(66556008)(5660300002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: XG440Te/cMYsrd0DmOHwgF5/hKgmxUvoGMMZ1eFV2vnqKD5EbcshZdu59XTY16VsTtIIJPKHFUa8CyXOwl9uOLFPtaYbIKf3T4Bq1f/DFBUcWjrsDsFrZuRTMfq/HezA0PEqjsvzgCEtA+TBbN+aNX/W8GBCF0HpHJ+t8JV90bEIZOI+8yOfNDMZ/UWCas5lUqNpS+pHyBaoA3oy+sMe3v2AepxrCMUvRA07aWESXINcCJHZKy+NZE0CWybwH+SGbKB8oX66teX6d1I+DUda6B3xqhRG0oFsfE8mmTXgRjB9zznnYEVrx4KUoPcVH7N1HvVM5AanYxSnXoFkFiQyd7CCPU623WHDgSTNeXFVhXxSKVGFSPbd5C+TI8KUzWPRnUlgCVm6nTAwipLEnRaLj1gLRvZKanp6A7qjrmlUwRDMn0iobrpd4zqSvzJ3tkGVCL+hRvPW8P8e7cPL8KAuf1FmRHB/X9qqz+ZRKFzNSQ64m7W3UzIXMmne1vLruCJKl+J+43ey737GUtKbLAbFomumuOx03hFCgXkd+nvaeWaNMkjoo4sME5U3FKv/wICXVzP+B2MH5sjG7irKsikrM59Ocyv09jBuK/AhY6PrnINCV8qghgmlYwhF9z7hR7abl+y9HQDxDNbOrxA7iI82qQ==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15ebb35f-f089-47fd-2389-08d87448ed77
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2020 16:06:24.5649
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F2fpIke7WEJN9xGDyCOCFhhTWIoFdu8a9HNlSaz2f8pFpe0ZpJiD1XhcqXj1EkVfzeWGkIfEK6zvYgYH98eOuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5129
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKV2l0
aCAtV3VuaW5pdGlhbGl6ZWQsIHRoZSBjb21waWxlciBjb21wbGFpbnM6Cgpkcml2ZXJzL3N0YWdp
bmcvd2Z4L2RhdGFfdHguYzozNDoxOTogd2FybmluZzogdmFyaWFibGUgJ2JhbmQnIGlzIHVuaW5p
dGlhbGl6ZWQgd2hlbiB1c2VkIGhlcmUgWy1XdW5pbml0aWFsaXplZF0KICAgIGlmIChyYXRlLT5p
ZHggPj0gYmFuZC0+bl9iaXRyYXRlcykgewogICAgICAgICAgICAgICAgICAgICAgICAgXn5+fgoK
UmVwb3J0ZWQtYnk6IGtlcm5lbCB0ZXN0IHJvYm90IDxsa3BAaW50ZWwuY29tPgpSZXBvcnRlZC1i
eTogTmF0aGFuIENoYW5jZWxsb3IgPG5hdGVjaGFuY2VsbG9yQGdtYWlsLmNvbT4KRml4ZXM6IDg2
OGZkOTcwZTE4NyAoInN0YWdpbmc6IHdmeDogaW1wcm92ZSByb2J1c3RuZXNzIG9mIHdmeF9nZXRf
aHdfcmF0ZSgpIikKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3Vp
bGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jIHwgOCAr
KysrLS0tLQogMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkK
CmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguYyBiL2RyaXZlcnMvc3Rh
Z2luZy93ZngvZGF0YV90eC5jCmluZGV4IDQxZjZhNjA0YTY5Ny4uMzZiMzZlZjM5ZDA1IDEwMDY0
NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguYworKysgYi9kcml2ZXJzL3N0YWdp
bmcvd2Z4L2RhdGFfdHguYwpAQCAtMzEsMTMgKzMxLDEzIEBAIHN0YXRpYyBpbnQgd2Z4X2dldF9o
d19yYXRlKHN0cnVjdCB3ZnhfZGV2ICp3ZGV2LAogCQl9CiAJCXJldHVybiByYXRlLT5pZHggKyAx
NDsKIAl9Ci0JaWYgKHJhdGUtPmlkeCA+PSBiYW5kLT5uX2JpdHJhdGVzKSB7Ci0JCVdBUk4oMSwg
Indyb25nIHJhdGUtPmlkeCB2YWx1ZTogJWQiLCByYXRlLT5pZHgpOwotCQlyZXR1cm4gLTE7Ci0J
fQogCS8vIFdGeCBvbmx5IHN1cHBvcnQgMkdIeiwgZWxzZSBiYW5kIGluZm9ybWF0aW9uIHNob3Vs
ZCBiZSByZXRyaWV2ZWQKIAkvLyBmcm9tIGllZWU4MDIxMV90eF9pbmZvCiAJYmFuZCA9IHdkZXYt
Pmh3LT53aXBoeS0+YmFuZHNbTkw4MDIxMV9CQU5EXzJHSFpdOworCWlmIChyYXRlLT5pZHggPj0g
YmFuZC0+bl9iaXRyYXRlcykgeworCQlXQVJOKDEsICJ3cm9uZyByYXRlLT5pZHggdmFsdWU6ICVk
IiwgcmF0ZS0+aWR4KTsKKwkJcmV0dXJuIC0xOworCX0KIAlyZXR1cm4gYmFuZC0+Yml0cmF0ZXNb
cmF0ZS0+aWR4XS5od192YWx1ZTsKIH0KIAotLSAKMi4yOC4wCgo=
