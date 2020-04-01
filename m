Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D873519AA6B
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 13:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732747AbgDALHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 07:07:43 -0400
Received: from mail-eopbgr750070.outbound.protection.outlook.com ([40.107.75.70]:46082
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732006AbgDALFC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Apr 2020 07:05:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UMjCCSfMFGMYz4Xy9NFmXPU4fVd+zjN9MPvzmM/hCZvBa2GA3x+5VuSuuaw2VUhsfspNOt5TmMzsIdG0JFCX6UUx1y6Szy6Y4K4Vmy+1iX8fUknb1AHCBOxLfEKT8Y2IXawUBO0ZlDGrbSWNxqkAFdTXnWpx+HWi083Ac4qSo5L4h6kuYKN1xfmPCDi8B2EFdBz0o5g8ULJFZmG772v884beGq6UhKuCWz/usLeSd786U0pYPP1Z54OmyPGFM2pRhX4X5lXU67t9Tvu9leoHbRb4I0bnDQGLusk0pPzmvYidZFGCeFA9L8uTzssU04jN705CnOoUnfdtdRyJhLK2Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OI17RmbECAmpL6nfGn5OFPse05O3F+L2zD1msQh2kXI=;
 b=EAsRE6kxVp9Yff85cgMkacor0k9kP+zhuqj9M0LNcV8at95HI+IN4w5Vo+hmDK80O/m0jvlgJijRNoL7eZcs3fT/EtG4IN9xrStwmCGkopJTIb63EQsT3xT+SrY99oGbrozw/YKqDRdxRUifkb7ni/t4w+K219wCPSmp43BbFa8Jy2lCpZPlAReAsDhggKaSBx5eXzSiTFnoHwG7iUlVzrPHZE7BHfHyyv0SkPb5w9wj3ZbO2Q9/kOfoYb5z8dJ0H0RaqoZTuftijL2Qoc7SPhZRIAfkfwRGfo6S1SLwzqU2dpcE95FYzYqxnzr+ae6bv//do3Uc1pJsm7eDmG/zNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OI17RmbECAmpL6nfGn5OFPse05O3F+L2zD1msQh2kXI=;
 b=QWCHOiXW3V3yZYw9A6DYR80QwD5dw70eCLp2+znZk7sKblRvvWtMB9BN99ZibqS+A66nxi+iDmxQwvo85r9ZT6MgDn516qbBYOGRunvbwsaXsKY72MCId449/wXJQJhGoTEpxvXr+pnjBCOwK/NzHEecbp/czcbFO+9HQebJqPg=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
 by MN2PR11MB4285.namprd11.prod.outlook.com (2603:10b6:208:191::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20; Wed, 1 Apr
 2020 11:04:42 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3%7]) with mapi id 15.20.2856.019; Wed, 1 Apr 2020
 11:04:42 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 11/32] staging: wfx: simplify wfx_tx_queue_mask_get()
Date:   Wed,  1 Apr 2020 13:03:44 +0200
Message-Id: <20200401110405.80282-12-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:1265:30ff:fefd:6e7f) by SN4PR0501CA0156.namprd05.prod.outlook.com (2603:10b6:803:2c::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.9 via Frontend Transport; Wed, 1 Apr 2020 11:04:40 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:2435:66a0:1265:30ff:fefd:6e7f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 405b75bb-a459-4b5d-4c19-08d7d62c7ab8
X-MS-TrafficTypeDiagnostic: MN2PR11MB4285:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR11MB4285B6675D8F16EC346724E793C90@MN2PR11MB4285.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:862;
X-Forefront-PRVS: 03607C04F0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4063.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(136003)(366004)(346002)(376002)(39850400004)(396003)(7696005)(8676002)(1076003)(16526019)(186003)(5660300002)(86362001)(4326008)(66574012)(52116002)(478600001)(66946007)(66476007)(54906003)(36756003)(8936002)(316002)(81156014)(6486002)(2906002)(66556008)(107886003)(81166006)(2616005);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RlIQgCWSZjSOX6jN7lKkQxMCESRlzwO5ntHB0S0gJczTzTn0lXr15WHr31gM8VGwGoxHDIURK2bzHuZiXZ4rZ8kQq/TixDhZQbeDqJdViuQfKGgwjXSAtHMIpoxVh8h9M2MNOg+ax0LJBiiveZlAlwkY9MihN8I7c0bQCpnOpLly91090rgk+hE1aIHMNYhB7UYyxoWs8vAXaUyXF4L/VoXqtMyer3osAbgQBufOWEcning4JaoIqOVBcQSlN0On75a8m28oqWE6W6b/RrI8ZRWNk+FXprmmvUOEJcJttuc1RsMKNi8cJjNl+PvMUgG+eUIP6GgEKkEyT32rC9r6UOLssp125ODULpmfqM34d7vAuU9Mh3Rzla+m5iZ8DzsaAWXikfE2Ga+Rnflu+Oc4MVhlQTFZFvvpfhJaU6KWZv/4bQvRCjtgIVVK82I5pAMk
X-MS-Exchange-AntiSpam-MessageData: gRnXkQs4G/5j0sODkYCWlYp0OXMMSV++WlxnVxclVT6tJYb29NFZop6fTQDCsgpzjNTFnf2DdBn13SMRCdJ/QZcXiiVqZ0x7LeaF9nM+7N37O//+Lju8sHq8rUoxXb/6GPriBh2TO0yAgND6PGhxYPo15Mn/GTA4NF4yCHtUA01LhHkO0xT3nAaQmQqsXBKolm3LcQPpxEqbFM8JJFO9aQ==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 405b75bb-a459-4b5d-4c19-08d7d62c7ab8
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2020 11:04:42.4286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0euN3I6vF25zGSeSxll9rReu7sL+dXp6bdjbRvHI3NEvfY4INa4SazOlvgZw4FJG0CcI4H/dqUstyomrrgqoyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4285
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSXQg
aXMgZmFyIHNpbXBsZXIgdG8gcmV0dXJuIGEgcG9pbnRlciBpbnN0ZWFkIG9mIGFuIGVycm9yLiBU
aHVzLCBpdCBpcwpubyBtb3JlIG5lY2Vzc2FyeSB0byBwYXNzIGEgcG9pbnRlciByZWZlcmVuY2Ug
YXMgYXJndW1lbnQuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBv
dWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5jIHwgMTUg
KysrKysrLS0tLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCA5IGRlbGV0
aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvcXVldWUuYyBiL2RyaXZl
cnMvc3RhZ2luZy93ZngvcXVldWUuYwppbmRleCBiYmFiNmIxOTJiMGMuLmM2MDI0OTY1ODBmNyAx
MDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5jCisrKyBiL2RyaXZlcnMvc3Rh
Z2luZy93ZngvcXVldWUuYwpAQCAtMzgyLDkgKzM4Miw4IEBAIHN0YXRpYyBpbnQgd2Z4X2dldF9w
cmlvX3F1ZXVlKHN0cnVjdCB3ZnhfdmlmICp3dmlmLCB1MzIgdHhfYWxsb3dlZF9tYXNrKQogCXJl
dHVybiB3aW5uZXI7CiB9CiAKLXN0YXRpYyBpbnQgd2Z4X3R4X3F1ZXVlX21hc2tfZ2V0KHN0cnVj
dCB3ZnhfdmlmICp3dmlmLAotCQkJCSAgICAgc3RydWN0IHdmeF9xdWV1ZSAqKnF1ZXVlX3AsCi0J
CQkJICAgICB1MzIgKnR4X2FsbG93ZWRfbWFza19wKQorc3RhdGljIHN0cnVjdCB3ZnhfcXVldWUg
KndmeF90eF9xdWV1ZV9tYXNrX2dldChzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwKKwkJCQkJICAgICAg
IHUzMiAqdHhfYWxsb3dlZF9tYXNrX3ApCiB7CiAJaW50IGlkeDsKIAl1MzIgdHhfYWxsb3dlZF9t
YXNrOwpAQCAtMzk4LDExICszOTcsMTAgQEAgc3RhdGljIGludCB3ZnhfdHhfcXVldWVfbWFza19n
ZXQoc3RydWN0IHdmeF92aWYgKnd2aWYsCiAJCXR4X2FsbG93ZWRfbWFzayB8PSBCSVQoV0ZYX0xJ
TktfSURfQUZURVJfRFRJTSk7CiAJaWR4ID0gd2Z4X2dldF9wcmlvX3F1ZXVlKHd2aWYsIHR4X2Fs
bG93ZWRfbWFzayk7CiAJaWYgKGlkeCA8IDApCi0JCXJldHVybiAtRU5PRU5UOworCQlyZXR1cm4g
TlVMTDsKIAotCSpxdWV1ZV9wID0gJnd2aWYtPndkZXYtPnR4X3F1ZXVlW2lkeF07CiAJKnR4X2Fs
bG93ZWRfbWFza19wID0gdHhfYWxsb3dlZF9tYXNrOwotCXJldHVybiAwOworCXJldHVybiAmd3Zp
Zi0+d2Rldi0+dHhfcXVldWVbaWR4XTsKIH0KIAogc3RydWN0IGhpZl9tc2cgKndmeF90eF9xdWV1
ZXNfZ2V0X2FmdGVyX2R0aW0oc3RydWN0IHdmeF92aWYgKnd2aWYpCkBAIC00MzQsNyArNDMyLDYg
QEAgc3RydWN0IGhpZl9tc2cgKndmeF90eF9xdWV1ZXNfZ2V0KHN0cnVjdCB3ZnhfZGV2ICp3ZGV2
KQogCXUzMiB0eF9hbGxvd2VkX21hc2sgPSAwOwogCXUzMiB2aWZfdHhfYWxsb3dlZF9tYXNrID0g
MDsKIAlzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZjsKLQlpbnQgbm90X2ZvdW5kOwogCWludCBpOwogCiAJ
aWYgKGF0b21pY19yZWFkKCZ3ZGV2LT50eF9sb2NrKSkKQEAgLTQ2OSwxMiArNDY2LDEyIEBAIHN0
cnVjdCBoaWZfbXNnICp3ZnhfdHhfcXVldWVzX2dldChzdHJ1Y3Qgd2Z4X2RldiAqd2RldikKIAkJ
d2hpbGUgKCh3dmlmID0gd3ZpZl9pdGVyYXRlKHdkZXYsIHd2aWYpKSAhPSBOVUxMKSB7CiAJCQlz
cGluX2xvY2tfYmgoJnd2aWYtPnBzX3N0YXRlX2xvY2spOwogCi0JCQlub3RfZm91bmQgPSB3Znhf
dHhfcXVldWVfbWFza19nZXQod3ZpZiwgJnZpZl9xdWV1ZSwKKwkJCXZpZl9xdWV1ZSA9IHdmeF90
eF9xdWV1ZV9tYXNrX2dldCh3dmlmLAogCQkJCQkJCSAgJnZpZl90eF9hbGxvd2VkX21hc2spOwog
CiAJCQlzcGluX3VubG9ja19iaCgmd3ZpZi0+cHNfc3RhdGVfbG9jayk7CiAKLQkJCWlmICghbm90
X2ZvdW5kKSB7CisJCQlpZiAodmlmX3F1ZXVlKSB7CiAJCQkJaWYgKHF1ZXVlICYmIHF1ZXVlICE9
IHZpZl9xdWV1ZSkKIAkJCQkJZGV2X2luZm8od2Rldi0+ZGV2LCAidmlmcyBkaXNhZ3JlZSBhYm91
dCBxdWV1ZSBwcmlvcml0eVxuIik7CiAJCQkJdHhfYWxsb3dlZF9tYXNrIHw9IHZpZl90eF9hbGxv
d2VkX21hc2s7Ci0tIAoyLjI1LjEKCg==
