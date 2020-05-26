Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7101F1E286A
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 19:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389133AbgEZRTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 13:19:25 -0400
Received: from mail-bn8nam11on2083.outbound.protection.outlook.com ([40.107.236.83]:48578
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388874AbgEZRTT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 13:19:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XCZrc7yv4RENxcbg01cUSfVLI+OZN/0VfoUI+gwFoyKSE1wcql1fSq4WeNMW/ZkDxo6ZURwDBc+XeQHtfSBkPA2cGNhtFeDHu5OIClkfAHYIAtD3Glfar7Og22noa6rpk9RWJAL4WQfy0nv+RQGQPYIyDEPPcZbI5uupPcTVtxS+jWxxcIjbKVT7IEQ2FGgyJ34+2Iqrc3KrL281iIZX278l/i3nn4c61rSXCZ4OTbLuOrgdFOedoPp6ndttya0GXfR7Ht1HPl5dX//E53iCYFVZAjq7diQviZy4aOxGdpsAuK3iiWe6O5mN/8fNeaqvUJDOQunjJPaE/83aWxPIZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GElZCByPklEnoQ8Cdo2ms75WRk4lBT8yiCJV32eEMDs=;
 b=kKs6NnNWHtfUPvFsRUitGYjtWGivR/1phAFAfeWGT+vHjAK2I8sAqL/Vi81+hMYs95XyiI2hrTlOx1Eyw+gIh6LMuvFMUq2tvAQep51j8GmKOkrRnQ1QVkIjVZxLdiPqcPFywW1eXCMil6l15tPImH9QIZkTKeKHO6eJFFCU/c7QvuRPv+fZzN2ZbLqj7zezNLlEFxgRb1xbtRj+g8FKp9VstzHTuqZAB3vmNCAZZIsxDPMOgDAvsFemWrZWyHT7gPAd5K+Da9Ktu8UsB8EB5y4ULZ1zH42YOm6pMJyov1MhSYzngsJmzDixET+P5tHJa+v4X9B0DqCnw0lP3F58RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GElZCByPklEnoQ8Cdo2ms75WRk4lBT8yiCJV32eEMDs=;
 b=HXKvEoFZ+DmgbaEwvrEPUdzvSarppuPxF9Ylc5IqxVATXZ52Hw2+jZdhXP/xC0ZoEZWVvrAUq3Nu1cnSpjpCz4axCJq0AjCSAftP/zQGWikn23w/i/b3dyhqvzeTmAG6rciZwxDBLNpbDdt1VrqpNXWGQlVYXjuaBnpGAPkFf9A=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2750.namprd11.prod.outlook.com (2603:10b6:805:54::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.25; Tue, 26 May
 2020 17:18:57 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::c504:2d66:a8f7:2336]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::c504:2d66:a8f7:2336%7]) with mapi id 15.20.3021.029; Tue, 26 May 2020
 17:18:57 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 10/10] staging: wfx: allow to run nl80211 vendor commands with 'iw'
Date:   Tue, 26 May 2020 19:18:21 +0200
Message-Id: <20200526171821.934581-11-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526171821.934581-1-Jerome.Pouiller@silabs.com>
References: <20200526171821.934581-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR1PR01CA0007.eurprd01.prod.exchangelabs.com
 (2603:10a6:102::20) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.home (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by PR1PR01CA0007.eurprd01.prod.exchangelabs.com (2603:10a6:102::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Tue, 26 May 2020 17:18:55 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 469e27ff-2d0a-4bdb-287f-08d80198df6c
X-MS-TrafficTypeDiagnostic: SN6PR11MB2750:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB2750AAEF8328A9D45290DD7293B00@SN6PR11MB2750.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:220;
X-Forefront-PRVS: 041517DFAB
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 36udSgpgpoOqIZ8zH9GZ+plAMD9dD8KsbqJkbww7Iw4e+uCIc4o2VRqncR8JbizYmpvR/r9FetdLJis4sMMBK/v0nkplhQehpOx89JttHNwrUU2ZMLjqfKepPDOzx2PiaJJhkvUGDWPljLNC7Aec1g+BL0PdwnEFpUGPQTd6PuS3slPrv4H6a19NEy9lzhtkAu7i4b1PrcFQfWYFbNiNOhmIVnn7Z+HCF1ErTQyyAocId+PO54Bie1CUEplPCE5x2iLXxACKMdxOPSQntwwLoGn1qtXEJ0vHgE68biN2hYgYCP4atCqRfrT5OfjWkJUv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(376002)(366004)(39860400002)(136003)(346002)(4326008)(6512007)(316002)(8676002)(8936002)(2616005)(6486002)(2906002)(107886003)(1076003)(86362001)(6666004)(186003)(16526019)(5660300002)(66574014)(36756003)(54906003)(66556008)(478600001)(8886007)(6506007)(66946007)(66476007)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: eW0X11/5NdJVp/L4tPsi5E49ykg/A4QckvE3A9nCGKT2P4aDXu6pzFOAneEH9IDSaXSKJsJDnSJXRTg2TxxNHkDTKd21kD0LKlHj0W6KhNfgqv+qh2A3Pj1UBFL964NIPXKd4bYSZQ+KiQcxR9c4nInOmSN++ic2oJlth1LtxCjY1L6gbv3tZ7veHsmhn7kFLBDPl/6fA9LomakmHds0vrJ8cRVuzfjcMbHWR5Ij/LpA86H7Dvdwvzs4l0ELzjnRDE5105LWzfERdshGxirwdQY7/hU+HKyyW759CMPQfu4SHvNLmyXHF8Xf+pSBub75+zibUyf/v4PCg21lTS46Ng0aFv4U8Z0iAwyyS93zQmjsIrEDzU/1yyXJ6E0W3V5hk66ZqRKJOR59oYvhyWIzBTd2UmCToChhotg6+fo1louMHgAOCt90rirKOdtCW82xkp0GmyCF9+RWG4V/shv3VYAV3puH4foOGd591X2EMp5AqVZXlG2Nxh23VBxUzX7DeqHX/tPGnCmJk/iuL+opsaLkBLR9p+Y69i3pNS6BA54=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 469e27ff-2d0a-4bdb-287f-08d80198df6c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2020 17:18:56.9508
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QS6X02ty43r+ZuKDqxZ7ukRsJnf6Zf6CT41EZyDxkfDUCENdsCjmPp5wnGT07rkbuOpGOJVelJA1rOwqsGF4Bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2750
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSW4g
Y3VycmVudCBjb2RlLCB0aGUgbmw4MDIxMSB2ZW5kb3IgZXh0ZW5zaW9ucyBwcm92aWRlZCBieSB0
aGUgZHJpdmVyCnVzZSB0aGUgbmV3IEFQSVsxXS4gSXQgcmVxdWlyZXMgdG8gcGFjayB0aGUgbmV0
bGluayBhdHRyaWJ1dGVzIGludG8gYQpOTEFfTkVTVEVELgoKVW5mb3J0dW5hdGVseSwgaXQgaXMg
bm90IHRoZSB3YXkgdGhlIGNvbW1hbmQgJ2l3IHZlbmRvcicgd29ya3MuCgpUaGlzIHBhdGNoLCBh
ZGQgZXh0cmEgdmVuZG9yIGNvbW1hbmRzIHRoYXQgY2FuIGJlIGNhbGxlZCB3aXRoCidpdyB2ZW5k
b3InLgoKWzFdIHNlZSBjb21taXQgOTAxYmI5ODkxODU1MTYgKCJubDgwMjExOiByZXF1aXJlIGFu
ZCB2YWxpZGF0ZSB2ZW5kb3IKICAgIGNvbW1hbmQgcG9saWN5IikKClNpZ25lZC1vZmYtYnk6IErD
qXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJz
L3N0YWdpbmcvd2Z4L25sODAyMTFfdmVuZG9yLmggfCAyMiArKysrKysrKysrKysrKysrKysrKysr
CiAxIGZpbGUgY2hhbmdlZCwgMjIgaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMv
c3RhZ2luZy93Zngvbmw4MDIxMV92ZW5kb3IuaCBiL2RyaXZlcnMvc3RhZ2luZy93Zngvbmw4MDIx
MV92ZW5kb3IuaAppbmRleCAwZmYzYmY3M2YwYWQzLi5iODA1YjRhYTk1MWEwIDEwMDY0NAotLS0g
YS9kcml2ZXJzL3N0YWdpbmcvd2Z4L25sODAyMTFfdmVuZG9yLmgKKysrIGIvZHJpdmVycy9zdGFn
aW5nL3dmeC9ubDgwMjExX3ZlbmRvci5oCkBAIC0yMyw4ICsyMywxMSBAQCBpbnQgd2Z4X25sX3B0
YV9wYXJhbXMoc3RydWN0IHdpcGh5ICp3aXBoeSwgc3RydWN0IHdpcmVsZXNzX2RldiAqd2lkZXYs
CiAKIGVudW0gewogCVdGWF9OTDgwMjExX1NVQkNNRF9QU19USU1FT1VUICAgICAgICAgICAgICAg
ICAgID0gMHgxMCwKKwlXRlhfTkw4MDIxMV9TVUJDTURfUFNfVElNRU9VVF9DT01QQVQgICAgICAg
ICAgICA9IDB4MTEsCiAJV0ZYX05MODAyMTFfU1VCQ01EX0JVUk5fUFJFVkVOVF9ST0xMQkFDSyAg
ICAgICAgPSAweDIwLAorCVdGWF9OTDgwMjExX1NVQkNNRF9CVVJOX1BSRVZFTlRfUk9MTEJBQ0tf
Q09NUEFUID0gMHgyMSwKIAlXRlhfTkw4MDIxMV9TVUJDTURfUFRBX1BBUk1TICAgICAgICAgICAg
ICAgICAgICA9IDB4MzAsCisJV0ZYX05MODAyMTFfU1VCQ01EX1BUQV9QQVJNU19DT01QQVQgICAg
ICAgICAgICAgPSAweDMxLAogfTsKIAogZW51bSB7CkBAIC01MywxOCArNTYsMzcgQEAgc3RhdGlj
IGNvbnN0IHN0cnVjdCB3aXBoeV92ZW5kb3JfY29tbWFuZCB3Znhfbmw4MDIxMV92ZW5kb3JfY29t
bWFuZHNbXSA9IHsKIAkJLnBvbGljeSA9IHdmeF9ubF9wb2xpY3ksCiAJCS5kb2l0ID0gd2Z4X25s
X3BzX3RpbWVvdXQsCiAJCS5tYXhhdHRyID0gV0ZYX05MODAyMTFfQVRUUl9NQVggLSAxLAorCX0s
IHsKKwkJLy8gQ29tcGF0IHdpdGggaXcKKwkJLmluZm8udmVuZG9yX2lkID0gV0ZYX05MODAyMTFf
SUQsCisJCS5pbmZvLnN1YmNtZCA9IFdGWF9OTDgwMjExX1NVQkNNRF9QU19USU1FT1VUX0NPTVBB
VCwKKwkJLmZsYWdzID0gV0lQSFlfVkVORE9SX0NNRF9ORUVEX1dERVYsCisJCS5wb2xpY3kgPSBW
RU5ET1JfQ01EX1JBV19EQVRBLAorCQkuZG9pdCA9IHdmeF9ubF9wc190aW1lb3V0LAogCX0sIHsK
IAkJLmluZm8udmVuZG9yX2lkID0gV0ZYX05MODAyMTFfSUQsCiAJCS5pbmZvLnN1YmNtZCA9IFdG
WF9OTDgwMjExX1NVQkNNRF9CVVJOX1BSRVZFTlRfUk9MTEJBQ0ssCiAJCS5wb2xpY3kgPSB3Znhf
bmxfcG9saWN5LAogCQkuZG9pdCA9IHdmeF9ubF9idXJuX2FudGlyb2xsYmFjaywKIAkJLm1heGF0
dHIgPSBXRlhfTkw4MDIxMV9BVFRSX01BWCAtIDEsCisJfSwgeworCQkvLyBDb21wYXQgd2l0aCBp
dworCQkuaW5mby52ZW5kb3JfaWQgPSBXRlhfTkw4MDIxMV9JRCwKKwkJLmluZm8uc3ViY21kID0g
V0ZYX05MODAyMTFfU1VCQ01EX0JVUk5fUFJFVkVOVF9ST0xMQkFDS19DT01QQVQsCisJCS5wb2xp
Y3kgPSBWRU5ET1JfQ01EX1JBV19EQVRBLAorCQkuZG9pdCA9IHdmeF9ubF9idXJuX2FudGlyb2xs
YmFjaywKIAl9LCB7CiAJCS5pbmZvLnZlbmRvcl9pZCA9IFdGWF9OTDgwMjExX0lELAogCQkuaW5m
by5zdWJjbWQgPSBXRlhfTkw4MDIxMV9TVUJDTURfUFRBX1BBUk1TLAogCQkucG9saWN5ID0gd2Z4
X25sX3BvbGljeSwKIAkJLmRvaXQgPSB3ZnhfbmxfcHRhX3BhcmFtcywKIAkJLm1heGF0dHIgPSBX
RlhfTkw4MDIxMV9BVFRSX01BWCAtIDEsCisJfSwgeworCQkvLyBDb21wYXQgd2l0aCBpdworCQku
aW5mby52ZW5kb3JfaWQgPSBXRlhfTkw4MDIxMV9JRCwKKwkJLmluZm8uc3ViY21kID0gV0ZYX05M
ODAyMTFfU1VCQ01EX1BUQV9QQVJNU19DT01QQVQsCisJCS5wb2xpY3kgPSBWRU5ET1JfQ01EX1JB
V19EQVRBLAorCQkuZG9pdCA9IHdmeF9ubF9wdGFfcGFyYW1zLAogCX0sCiB9OwogCi0tIAoyLjI2
LjIKCg==
