Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7304825F7F6
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 12:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728894AbgIGKVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 06:21:04 -0400
Received: from mail-mw2nam10on2056.outbound.protection.outlook.com ([40.107.94.56]:42336
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728745AbgIGKRM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 06:17:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZiR+qrwRuPv61q96qYRHOZtGN5p3PkmYokYqKn9+S1wbxbvqXPfLmSYrdNdfO93lfz7cgbljI9q3+5hJiS8q5rRTkh9t7k7aTRmOXgQtUmcIHPb7iT9vEVntW4eFoEiWLlVvgMb1ZHxC/1dVK2eUTydBCZ/8H1AiyD69LKcqvPFnosxGy4bnPZK4PKMgda+HqmUGOsBJBHEVqysKhckr3iW2PioThHYRvLiZvjGvkVsOmwlCet/u8I85awxTAyBwyfg2tCImiM9cyVqGxJVUI4kyVE98nzImjfwGHeTiq/zTYCk8gs3HTXKG7UEL4kOXj1mdcCwD6daE56Y7eZRrHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S88uLDlFTB5T8xAtqkryG6651zwk2ZJeueih/rYLPM0=;
 b=iSlmSgQRiz1Kxrfa6G46swXpELRkBO/axVZAdy8YYn0oyiCyRsopWsEBJ+DMR67kbqeghUucBs9KU0QMMe9+fJZdbq9jm+QmFV5zp2tsYVB2kAAgdifsb3e5Km78zc433bV/ORxr0nhhkCOBwObXxV9Bw7iGSlEZOvJsW95EZk0vbOarWyXiE8lLblw+/if4OdHxrlMvn2hy4sh456HzGG0FOh5uMgMnkd2r46Dr4GyMnEg9XHxa8SDpNmI6apRqenFaMZ0X45ntVMEFfdigIURpx9Wk/BwLR2t4BirWSsIlquCrukOBhUn2bVNDhg6rEQzHGxKfX15uknND7hibUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S88uLDlFTB5T8xAtqkryG6651zwk2ZJeueih/rYLPM0=;
 b=XuUxLlz+5HgLfAG32w5wblaKvQojYiDPJ6kHONGaI/ENbrXmq3jU89Wk7WnPQ6FYGPT8d5uf/wK3kCZrUl52FE98zpElhuvWEVCavUtOyK1uAzuksvIgiwP8+API7OPXghUYlM8WvNpgrh7bUHENjg+Mzd8QLQOrvxH1SEassv4=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2720.namprd11.prod.outlook.com (2603:10b6:805:56::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15; Mon, 7 Sep
 2020 10:16:19 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6%4]) with mapi id 15.20.3348.019; Mon, 7 Sep 2020
 10:16:19 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 21/31] staging: wfx: drop useless structs only used in hif_ind_startup
Date:   Mon,  7 Sep 2020 12:15:11 +0200
Message-Id: <20200907101521.66082-22-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.silabs.com (37.71.187.125) by PR0P264CA0109.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:19::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.16 via Frontend Transport; Mon, 7 Sep 2020 10:16:17 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [37.71.187.125]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ac3de66f-4be9-465c-a871-08d853170fe8
X-MS-TrafficTypeDiagnostic: SN6PR11MB2720:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB2720E3AAB806B9B3553C973093280@SN6PR11MB2720.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qaghc2mhWi68i/I5dtnzBsBE6tBoyar523ncFG+95BZvjxHH0qwoxZHFw7AOuoErEpJt7jo3lCa6PYC7R6oUVAKCQnXxJkuvb49ZeG+HBh65yKTwfpi0R86bBKxzEbSZ2wQtphw1zyZQleb3+xydeR4hbH93avpWx2uCjjn6ztWHclofOKmJPRPsIcgfrraTwQQP+B6a0btLSzpIoSco+EFuTCSl5nY57ccD2IFDUiZ9cusI3rlWNXMz5uq2ceq0OqrVssL/CE5+wO9F8S6FEORaHrrOLKRUviXv3iPiSKViHeTPnMjBD53lKIAIF/NZB3XwRzcyZPmu6RX87ohcDw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(39850400004)(136003)(346002)(396003)(66946007)(66556008)(66476007)(54906003)(26005)(186003)(16526019)(66574015)(83380400001)(107886003)(6486002)(8676002)(956004)(2616005)(2906002)(316002)(86362001)(8936002)(478600001)(4326008)(7696005)(36756003)(52116002)(6666004)(1076003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 2e3gCXv3NTw2fNbYGmCw/0OFBvzZcm1dVYqwAbOCrhU3k0i6s2/D4fPUXD2Smsn6qJtz5QelDM/MJVSsNZ94X5Ve56NrhNc/ltdDhsZHvN+Ki1IvdlkoQyDk01aRcd7lTd79JB5v8naM8tCH0GoPl2K23sIapABJgmWyG20O8z0+u/TtY5h6x5hmKOlLkptsYJY2BREgSqDIbGav0PDVnjUEXjAtQ4jpKWNS3PdomijJl4gQ6D3vmVnsgQY9QUZEtR75HDG8mOTkbQbJTddel0x44DQmvdV3HXndgK+0Dtfup/8fasvAcXIo+23CLIXBwZQlSwu9lLKZXYimZGs4RDqmYUBTf+IQ/pDj6m8cthPMTC4+TXsGJFnfX53HZW6MfD0bcj5+URFV0OfAgNpa9HivSr4NwGk+vR88jPyyUASTZe+kQIR1MVt9UX5AiEMsiEFq23B6GRDMUnJc+jJIJELNMFTmVn1ZicL4EUwGuR96DEqjoD17770PCWccipe4vt/s0JdeH09O/bPlokifnpz/0wEOH1vnsCCZJPHHaET6L+2uQMZeW+SEPgDunjQAf3yeF+Zsr2Ctz84WooNZx5h67Yhz0m2EL+zOCfcUEbBFZ5ELJ4cTqX1BkM9S8XESK2T6cxVNzqqx74UPdkLTcg==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac3de66f-4be9-465c-a871-08d853170fe8
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2020 10:16:19.0963
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QsV8WiqSojZecDGpegT8lllzYbldg298EazgjlYDwlcBniVufsczfgy94QMD83obmzOWYdi5XJjMIBM2DY8yHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2720
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IHN0cnVjdHMgaGlmX2NhcGFiaWxpdGllcywgaGlmX290cF9yZWd1bF9zZWxfbW9kZV9pbmZvIGFu
ZApoaWZfb3RwX3BoeV9pbmZvIGhhdmUgbm8gcmVhbCByZWFzb25zIHRvIGV4aXN0LiBEcm9wIHRo
ZW0gYW5kIHNpbXBsaWZ5CmFjY2VzcyB0byBmaWVsZHMgb2Ygc3RydWN0IGhpZl9pbmRfc3RhcnR1
cC4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2ls
YWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfZ2VuZXJhbC5oIHwgMzIg
KysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L21haW4uYyAg
ICAgICAgICAgIHwgIDkgKysrKy0tLS0KIDIgZmlsZXMgY2hhbmdlZCwgMTQgaW5zZXJ0aW9ucygr
KSwgMjcgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZf
YXBpX2dlbmVyYWwuaCBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9nZW5lcmFsLmgKaW5k
ZXggMGRjMTMxNzZhMDVlLi40MDU4MDE2ZWM2NjQgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2lu
Zy93ZngvaGlmX2FwaV9nZW5lcmFsLmgKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfYXBp
X2dlbmVyYWwuaApAQCAtMTIyLDI1ICsxMjIsNiBAQCBlbnVtIGhpZl9md190eXBlIHsKIAlISUZf
RldfVFlQRV9XU00gID0gMHgyCiB9OwogCi1zdHJ1Y3QgaGlmX2NhcGFiaWxpdGllcyB7Ci0JdTgg
ICAgIGxpbmtfbW9kZToyOwotCXU4ICAgICByZXNlcnZlZDE6NjsKLQl1OCAgICAgcmVzZXJ2ZWQy
OwotCXU4ICAgICByZXNlcnZlZDM7Ci0JdTggICAgIHJlc2VydmVkNDsKLX0gX19wYWNrZWQ7Ci0K
LXN0cnVjdCBoaWZfb3RwX3JlZ3VsX3NlbF9tb2RlX2luZm8gewotCXU4ICAgICByZWdpb25fc2Vs
X21vZGU6NDsKLQl1OCAgICAgcmVzZXJ2ZWQ6NDsKLX0gX19wYWNrZWQ7Ci0KLXN0cnVjdCBoaWZf
b3RwX3BoeV9pbmZvIHsKLQl1OCAgICAgcGh5MV9yZWdpb246MzsKLQl1OCAgICAgcGh5MF9yZWdp
b246MzsKLQl1OCAgICAgb3RwX3BoeV92ZXI6MjsKLX0gX19wYWNrZWQ7Ci0KIHN0cnVjdCBoaWZf
aW5kX3N0YXJ0dXAgewogCS8vIEFzIHRoZSBvdGhlcnMsIHRoaXMgc3RydWN0IGlzIGludGVycHJl
dGVkIGFzIGxpdHRsZSBlbmRpYW4gYnkgdGhlCiAJLy8gZGV2aWNlLiBIb3dldmVyLCB0aGlzIHN0
cnVjdCBpcyBhbHNvIHVzZWQgYnkgdGhlIGRyaXZlci4gV2UgcHJlZmVyIHRvCkBAIC0xNTYsMTQg
KzEzNywyMSBAQCBzdHJ1Y3QgaGlmX2luZF9zdGFydHVwIHsKIAl1OCAgICAgbWFjX2FkZHJbMl1b
RVRIX0FMRU5dOwogCXU4ICAgICBhcGlfdmVyc2lvbl9taW5vcjsKIAl1OCAgICAgYXBpX3ZlcnNp
b25fbWFqb3I7Ci0Jc3RydWN0IGhpZl9jYXBhYmlsaXRpZXMgY2FwYWJpbGl0aWVzOworCXU4ICAg
ICBsaW5rX21vZGU6MjsKKwl1OCAgICAgcmVzZXJ2ZWQxOjY7CisJdTggICAgIHJlc2VydmVkMjsK
Kwl1OCAgICAgcmVzZXJ2ZWQzOworCXU4ICAgICByZXNlcnZlZDQ7CiAJdTggICAgIGZpcm13YXJl
X2J1aWxkOwogCXU4ICAgICBmaXJtd2FyZV9taW5vcjsKIAl1OCAgICAgZmlybXdhcmVfbWFqb3I7
CiAJdTggICAgIGZpcm13YXJlX3R5cGU7CiAJdTggICAgIGRpc2FibGVkX2NoYW5uZWxfbGlzdFsy
XTsKLQlzdHJ1Y3QgaGlmX290cF9yZWd1bF9zZWxfbW9kZV9pbmZvIHJlZ3VsX3NlbF9tb2RlX2lu
Zm87Ci0Jc3RydWN0IGhpZl9vdHBfcGh5X2luZm8gb3RwX3BoeV9pbmZvOworCXU4ICAgICByZWdp
b25fc2VsX21vZGU6NDsKKwl1OCAgICAgcmVzZXJ2ZWQ1OjQ7CisJdTggICAgIHBoeTFfcmVnaW9u
OjM7CisJdTggICAgIHBoeTBfcmVnaW9uOjM7CisJdTggICAgIG90cF9waHlfdmVyOjI7CiAJdTMy
ICAgIHN1cHBvcnRlZF9yYXRlX21hc2s7CiAJdTggICAgIGZpcm13YXJlX2xhYmVsWzEyOF07CiB9
IF9fcGFja2VkOwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9tYWluLmMgYi9kcml2
ZXJzL3N0YWdpbmcvd2Z4L21haW4uYwppbmRleCAxMDE3YTIyOTBmMDguLjJhOTA5OGJhZDFmNSAx
MDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9tYWluLmMKKysrIGIvZHJpdmVycy9zdGFn
aW5nL3dmeC9tYWluLmMKQEAgLTM1OSw5ICszNTksOCBAQCBpbnQgd2Z4X3Byb2JlKHN0cnVjdCB3
ZnhfZGV2ICp3ZGV2KQogCWRldl9pbmZvKHdkZXYtPmRldiwgInN0YXJ0ZWQgZmlybXdhcmUgJWQu
JWQuJWQgXCIlc1wiIChBUEk6ICVkLiVkLCBrZXlzZXQ6ICUwMlgsIGNhcHM6IDB4JS44WClcbiIs
CiAJCSB3ZGV2LT5od19jYXBzLmZpcm13YXJlX21ham9yLCB3ZGV2LT5od19jYXBzLmZpcm13YXJl
X21pbm9yLAogCQkgd2Rldi0+aHdfY2Fwcy5maXJtd2FyZV9idWlsZCwgd2Rldi0+aHdfY2Fwcy5m
aXJtd2FyZV9sYWJlbCwKLQkJIHdkZXYtPmh3X2NhcHMuYXBpX3ZlcnNpb25fbWFqb3IsCi0JCSB3
ZGV2LT5od19jYXBzLmFwaV92ZXJzaW9uX21pbm9yLAotCQkgd2Rldi0+a2V5c2V0LCAqKCh1MzIg
Kikmd2Rldi0+aHdfY2Fwcy5jYXBhYmlsaXRpZXMpKTsKKwkJIHdkZXYtPmh3X2NhcHMuYXBpX3Zl
cnNpb25fbWFqb3IsIHdkZXYtPmh3X2NhcHMuYXBpX3ZlcnNpb25fbWlub3IsCisJCSB3ZGV2LT5r
ZXlzZXQsIHdkZXYtPmh3X2NhcHMubGlua19tb2RlKTsKIAlzbnByaW50Zih3ZGV2LT5ody0+d2lw
aHktPmZ3X3ZlcnNpb24sCiAJCSBzaXplb2Yod2Rldi0+aHctPndpcGh5LT5md192ZXJzaW9uKSwK
IAkJICIlZC4lZC4lZCIsCkBAIC0zNzcsMTMgKzM3NiwxMyBAQCBpbnQgd2Z4X3Byb2JlKHN0cnVj
dCB3ZnhfZGV2ICp3ZGV2KQogCQlnb3RvIGVycjA7CiAJfQogCi0JaWYgKHdkZXYtPmh3X2NhcHMu
Y2FwYWJpbGl0aWVzLmxpbmtfbW9kZSA9PSBTRUNfTElOS19FTkZPUkNFRCkgeworCWlmICh3ZGV2
LT5od19jYXBzLmxpbmtfbW9kZSA9PSBTRUNfTElOS19FTkZPUkNFRCkgewogCQlkZXZfZXJyKHdk
ZXYtPmRldiwKIAkJCSJjaGlwIHJlcXVpcmUgc2VjdXJlX2xpbmssIGJ1dCBjYW4ndCBuZWdvdGlh
dGUgaXRcbiIpOwogCQlnb3RvIGVycjA7CiAJfQogCi0JaWYgKHdkZXYtPmh3X2NhcHMucmVndWxf
c2VsX21vZGVfaW5mby5yZWdpb25fc2VsX21vZGUpIHsKKwlpZiAod2Rldi0+aHdfY2Fwcy5yZWdp
b25fc2VsX21vZGUpIHsKIAkJd2Rldi0+aHctPndpcGh5LT5iYW5kc1tOTDgwMjExX0JBTkRfMkdI
Wl0tPmNoYW5uZWxzWzExXS5mbGFncyB8PSBJRUVFODAyMTFfQ0hBTl9OT19JUjsKIAkJd2Rldi0+
aHctPndpcGh5LT5iYW5kc1tOTDgwMjExX0JBTkRfMkdIWl0tPmNoYW5uZWxzWzEyXS5mbGFncyB8
PSBJRUVFODAyMTFfQ0hBTl9OT19JUjsKIAkJd2Rldi0+aHctPndpcGh5LT5iYW5kc1tOTDgwMjEx
X0JBTkRfMkdIWl0tPmNoYW5uZWxzWzEzXS5mbGFncyB8PSBJRUVFODAyMTFfQ0hBTl9ESVNBQkxF
RDsKLS0gCjIuMjguMAoK
