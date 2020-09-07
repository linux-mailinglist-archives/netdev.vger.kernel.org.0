Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B157A25F806
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 12:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728870AbgIGKZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 06:25:30 -0400
Received: from mail-mw2nam10on2078.outbound.protection.outlook.com ([40.107.94.78]:7488
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728743AbgIGKQh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 06:16:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CiGL2KCcEGCkGb0mBduwvtibvb74QMkUKiQXYv3TAKZTfgl4I3dUV3u+iwJndqUE4M3pR5QXzj/3swAG6xpez2hQMGwcuHofsSUSivSQ7VzGCG0cthVi7efAPaITuhMA73MGck8CZtbtKVQUAzdrHBNUOfugwaCjNIxRrbWWOxgZvbEPxewm7/a+XWvXl5nqQkvWOO76ufpdcz2a/YoTcu0jHmRCpe0E97ln+qVBeyNHaywGaut62htE9bGk0xmeBiVhl/MmUQFiJP+5X1h0X1QTfpXbc9gsB7nAEFvn9A7xanwd+QbBuCoL+8OvSJ2IUr1SIenAhxZtWo5WtHJ5tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b9+HgoqKyWO/WNKMbwFLCH48hV1aj5DkkNWjjjRegOk=;
 b=J4nAp5+rtwU7F2aLA89pRLnJXWL0kUNaKuBT/hAcmnBJ5HgxImFET5hhGFqccdz7z3RID/WTDeRuR/4lT1ZBKqVpVh4dUh0uml4vc7BO9UB6jzIPjIOdZVLu3iSo0vsMLgQmkvV/gnbRDfRY61KlM0jFNObtyDeJQb4nHAEIh8h9mT36Lrov6OCmwPL+rKvkeHZXtN5AzME9S96v002ruTAXH0fgkL8oxvaQZzE2LwRzsPxS1CXRkoRBO4ZBT3jHoLVB0Ja0ilLL8pGYZRDyYx0qcZlooFqsEbQXGYzEBZ3P4dTlzATYbwPILsh3bNzACgTNOxuNDc12SFLWb1JWzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b9+HgoqKyWO/WNKMbwFLCH48hV1aj5DkkNWjjjRegOk=;
 b=MtRvB3y6yglEt/bySvtwt71xJxrRrEx+GZ0aiU43FxMYL5zj25HE3VClaat2vBpm92jxfuG4KGYMT1NLpSHI+VV8SX3dFmMYpPv6I9KBszyrV0oJWLcJazi4tdHMGsFwxk6jzmLPT42UjNm0ffV3mXj9dh0xYaA+0KUc+b2mtFU=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2720.namprd11.prod.outlook.com (2603:10b6:805:56::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15; Mon, 7 Sep
 2020 10:16:17 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6%4]) with mapi id 15.20.3348.019; Mon, 7 Sep 2020
 10:16:17 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 20/31] staging: wfx: drop useless stricts only used in hif_req_start_scan_alt
Date:   Mon,  7 Sep 2020 12:15:10 +0200
Message-Id: <20200907101521.66082-21-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.silabs.com (37.71.187.125) by PR0P264CA0109.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:19::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.16 via Frontend Transport; Mon, 7 Sep 2020 10:16:16 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [37.71.187.125]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f6869f43-c49c-4dce-dd37-08d853170eee
X-MS-TrafficTypeDiagnostic: SN6PR11MB2720:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB27209827AF8EC8B23ECA05C493280@SN6PR11MB2720.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1443;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XSZguBvMVIae17vQkizDTP7REJmsboa/SpJ6AuBMLPaxAMxoTHQ9j5L5ffHWXhDQaPvZuccbuLFXbFFOcB1xiNouO0m29MHbrBAapxNJTXwlyQRJgW9BfZCkmmeipF6sA8rsWA4IAlm21Wl21FTXZwpntLDTrX3I5kfIacpJPU9hCC17cpV4x/IwWB4eIYMDDwzAcbg+7VLL+LSDbIfZ1hSI6FfVzWHz7JSXnTnHOZ8CgCXtJBgPOEdHTa8YzU7O4Vj5BusghP/QCwfU5Y4m/9Dz497eZilr/55yGJkfRRzbW3uhKd6EL+DkvvcGCCm3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(39850400004)(136003)(346002)(396003)(66946007)(66556008)(66476007)(54906003)(26005)(186003)(16526019)(66574015)(83380400001)(107886003)(6486002)(8676002)(956004)(2616005)(2906002)(316002)(86362001)(8936002)(478600001)(4326008)(7696005)(36756003)(52116002)(6666004)(1076003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 9iTCWll80ny/bRR99iGctDkOz1Q/yvet5NoK4vUqcBbu5yVPlRfgyOi2HAN8brDigusULr6JLw/x6mBCHSVjbO2yeaNIu9fToNOPNX6VodE8kEuJs0v56ShQ7jWF4Xo6D5ypJeZYT2Vbpt9pArIPvDxA7e6YWwR5lO5BI53K0OGljbF9fm1pKPkNsQxBtuqFOtD5aQvomUXgwgoEIOVwCp6aAg6JivXdEW0BVCPDGBPC6Zg6OI4AV/kqkVRPB9iBkLWW8hk75t2zcE/sqdZxnNdYp9xl0hdcRyPCtt+iFpBYQjcFVjYGQrNSrTOsurqj0MFzYRS6PI4t8mw6qKacJg4Ur6eAEZCOXHgjTdjWbKKNyWP5BPN3ulEMWDT+wT0l6FiB/rHMNPXE7k73B6c7zgpHWUXtZ07+vYk8RYkLUe2Fgben8MOOIN7CK0B5LfNK2GJItt3O+Fu5yCANOmLyXzjLrOiTIEgfeh3ZWWLsTYXp6SPEZ9eloHuGTOOq2edas8g7r94doCEzJzXRyhljflzIbLlUPpQ2oDIatiOX83uTrea61s/L35VtApouKEch/TnouX2tInd8idAFA77FcFb2uiIdqp4VPnCKtEPWSq9+YQymxKlo7Piv3zog6Osmm8/74YGYhCN7ODjE91NVUg==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6869f43-c49c-4dce-dd37-08d853170eee
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2020 10:16:17.4562
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fy+UsMfexcgNEtYGoQEZ8cU/9Tw3Zbn4WIVOcEDGMc2JT4jLFIGdtuDcHtQlq11/u/jnw4hHY7jckbzC0TYlKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2720
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IHN0cnVjdHMgaGlmX3NjYW5fdHlwZSwgaGlmX3NjYW5fZmxhZ3MgYW5kIGhpZl9hdXRvX3NjYW5f
cGFyYW0gaGF2ZQpubyByZWFsIHJlYXNvbnMgdG8gZXhpc3QgKGFwYXJ0IG1heWJlIGRlZmluaW5n
IG5hbWVzcGFjZXMpLiBNb3Jlb3ZlciwKdGhlIG5hbWVzIG9mIHRoZSBmaWVsZHMgd2l0aGluIHRo
ZXNlIHN0cnVjdHMgYXJlIG5vdCBhbGwgbWVhbmluZ2Z1bC4KCkRyb3AgdGhlIHN0cnVjdHMgYW5k
IHJlbmFtZSB0aGUgZmllbGRzLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGpl
cm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2Fw
aV9jbWQuaCB8IDMyICsrKysrKysrKystLS0tLS0tLS0tLS0tLS0tLS0tLS0KIGRyaXZlcnMvc3Rh
Z2luZy93ZngvaGlmX3R4LmMgICAgICB8ICA1ICsrLS0tCiAyIGZpbGVzIGNoYW5nZWQsIDEyIGlu
c2VydGlvbnMoKyksIDI1IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2lu
Zy93ZngvaGlmX2FwaV9jbWQuaCBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9jbWQuaApp
bmRleCBkNWVmMTExOGI4N2MuLmM3ZTZmZGYxODNiMSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFn
aW5nL3dmeC9oaWZfYXBpX2NtZC5oCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9j
bWQuaApAQCAtMTEzLDI1ICsxMTMsNiBAQCBzdHJ1Y3QgaGlmX2NuZl91cGRhdGVfaWUgewogCV9f
bGUzMiBzdGF0dXM7CiB9IF9fcGFja2VkOwogCi1zdHJ1Y3QgaGlmX3NjYW5fdHlwZSB7Ci0JdTgg
ICAgIHR5cGU6MTsKLQl1OCAgICAgbW9kZToxOwotCXU4ICAgICByZXNlcnZlZDo2OwotfSBfX3Bh
Y2tlZDsKLQotc3RydWN0IGhpZl9zY2FuX2ZsYWdzIHsKLQl1OCAgICAgZmJnOjE7Ci0JdTggICAg
IHJlc2VydmVkMToxOwotCXU4ICAgICBwcmU6MTsKLQl1OCAgICAgcmVzZXJ2ZWQyOjU7Ci19IF9f
cGFja2VkOwotCi1zdHJ1Y3QgaGlmX2F1dG9fc2Nhbl9wYXJhbSB7Ci0JX19sZTE2IGludGVydmFs
OwotCXU4ICAgICByZXNlcnZlZDsKLQlzOCAgICAgcnNzaV90aHI7Ci19IF9fcGFja2VkOwotCiBz
dHJ1Y3QgaGlmX3NzaWRfZGVmIHsKIAlfX2xlMzIgc3NpZF9sZW5ndGg7CiAJdTggICAgIHNzaWRb
SElGX0FQSV9TU0lEX1NJWkVdOwpAQCAtMTQyLDEwICsxMjMsMTcgQEAgc3RydWN0IGhpZl9zc2lk
X2RlZiB7CiAKIHN0cnVjdCBoaWZfcmVxX3N0YXJ0X3NjYW5fYWx0IHsKIAl1OCAgICAgYmFuZDsK
LQlzdHJ1Y3QgaGlmX3NjYW5fdHlwZSBzY2FuX3R5cGU7Ci0Jc3RydWN0IGhpZl9zY2FuX2ZsYWdz
IHNjYW5fZmxhZ3M7CisJdTggICAgIG1haW50YWluX2N1cnJlbnRfYnNzOjE7CisJdTggICAgIHBl
cmlvZGljOjE7CisJdTggICAgIHJlc2VydmVkMTo2OworCXU4ICAgICBkaXNhbGxvd19wczoxOwor
CXU4ICAgICByZXNlcnZlZDI6MTsKKwl1OCAgICAgc2hvcnRfcHJlYW1ibGU6MTsKKwl1OCAgICAg
cmVzZXJ2ZWQzOjU7CiAJdTggICAgIG1heF90cmFuc21pdF9yYXRlOwotCXN0cnVjdCBoaWZfYXV0
b19zY2FuX3BhcmFtIGF1dG9fc2Nhbl9wYXJhbTsKKwlfX2xlMTYgcGVyaW9kaWNfaW50ZXJ2YWw7
CisJdTggICAgIHJlc2VydmVkNDsKKwlzOCAgICAgcGVyaW9kaWNfcnNzaV90aHI7CiAJdTggICAg
IG51bV9vZl9wcm9iZV9yZXF1ZXN0czsKIAl1OCAgICAgcHJvYmVfZGVsYXk7CiAJdTggICAgIG51
bV9vZl9zc2lkczsKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4LmMgYi9k
cml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5jCmluZGV4IDEzNGFmNGRhZWU5Ni4uMDU1M2U3OTU5
NWE2IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5jCisrKyBiL2RyaXZl
cnMvc3RhZ2luZy93ZngvaGlmX3R4LmMKQEAgLTI1Niw5ICsyNTYsOCBAQCBpbnQgaGlmX3NjYW4o
c3RydWN0IHdmeF92aWYgKnd2aWYsIHN0cnVjdCBjZmc4MDIxMV9zY2FuX3JlcXVlc3QgKnJlcSwK
IAkJCWNwdV90b19sZTMyKHJlcS0+c3NpZHNbaV0uc3NpZF9sZW4pOwogCX0KIAlib2R5LT5udW1f
b2Zfc3NpZHMgPSBISUZfQVBJX01BWF9OQl9TU0lEUzsKLQkvLyBCYWNrZ3JvdW5kIHNjYW4gaXMg
YWx3YXlzIGEgZ29vZCBpZGVhCi0JYm9keS0+c2Nhbl90eXBlLnR5cGUgPSAxOwotCWJvZHktPnNj
YW5fZmxhZ3MuZmJnID0gMTsKKwlib2R5LT5tYWludGFpbl9jdXJyZW50X2JzcyA9IDE7CisJYm9k
eS0+ZGlzYWxsb3dfcHMgPSAxOwogCWJvZHktPnR4X3Bvd2VyX2xldmVsID0KIAkJY3B1X3RvX2xl
MzIocmVxLT5jaGFubmVsc1tjaGFuX3N0YXJ0X2lkeF0tPm1heF9wb3dlcik7CiAJYm9keS0+bnVt
X29mX2NoYW5uZWxzID0gY2hhbl9udW07Ci0tIAoyLjI4LjAKCg==
