Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE4D91E286B
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 19:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388992AbgEZRTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 13:19:07 -0400
Received: from mail-bn8nam11on2083.outbound.protection.outlook.com ([40.107.236.83]:48578
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388898AbgEZRTB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 13:19:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Eq++fMwcJ7YPJTbGcz/FRaXrhFJ/xXLQJnTmMymXJGvSc89Xoj2nxsjX8Ffm86b726EfxvoKuGhgt+wTm9Rr2mt249A0gcSLfrQqtoj1Y/ZB33TgTit8w3qrTUKseoeQYf6sFEzH/VYhxhPFU+aEGKkC/bz/iGzjCWYjK3eTrXzZxfvoeodqUCIAsrIQxeBu7iMkFeBFsKA5TBKig6oFv+us+es2dZJEm/klkAzJtDvwC8TdOVZu7CiTf+fn0+2ObnD1KRM8W8skw6MOR18q2qCbp0bXkB4WqqNJzY88oYzuCA3B+v6nBPbaW2GxQ+zefwgsPfv8KtHse/7xVUzcvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wXGHy+DOkIwG3kemaOa8KHPH2RZ2MpmCkltH0RA9COE=;
 b=FVGVyJ6eNnxBbHRepdirCKVN1mcpfHvMLjZSPUTjIWorlNQ6ynZFqHjwq2WwbdkBXeMkO3Gqou+2BIhqHxZiJiKrW1nZQYT1k+vAcqOr0T4/ku/IOM5DugyY5PWocP5XlLrhAjqIySwZbLq1iE7MVUfTisAWc8LZh7xFxEUg58ckHm5wCbEFJx9+ayStl6pMBy8xzKGJvUVSSRzSPLQeSfb5s4gA3vbrY+XCprXzKNKEoXcQpddpt3lODoSdvFunveIiMuwyYelKIRfjf3sIXxd7k1BB/ws0+FwdcuWk2g4tubbTXagS2/aMtBwkyVcPLwrO3CKLjsyturphEU2N0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wXGHy+DOkIwG3kemaOa8KHPH2RZ2MpmCkltH0RA9COE=;
 b=B+GpilbkkULrsxzj5IRbHwhjJDGzl+GBX9d9vG1lnlfnObiXagfPWYqP6hu+MH7kpMq7dVQyk0PLIvQp1lDmHZvGPZp0RF9Vzra9ogGPdyTclxDVGBc3bv6SNplnhSk68m2wEWJn2NdxX/P40NzWRhkmIb6tg7fEsYNT1JrbSSU=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2750.namprd11.prod.outlook.com (2603:10b6:805:54::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.25; Tue, 26 May
 2020 17:18:50 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::c504:2d66:a8f7:2336]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::c504:2d66:a8f7:2336%7]) with mapi id 15.20.3021.029; Tue, 26 May 2020
 17:18:50 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 06/10] staging: wfx: split wfx_get_ps_timeout() from wfx_update_pm()
Date:   Tue, 26 May 2020 19:18:17 +0200
Message-Id: <20200526171821.934581-7-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.home (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by PR1PR01CA0007.eurprd01.prod.exchangelabs.com (2603:10a6:102::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Tue, 26 May 2020 17:18:49 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 783d39ca-549f-4436-f0a8-08d80198db9a
X-MS-TrafficTypeDiagnostic: SN6PR11MB2750:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB27501495E43CCD1867FE69B893B00@SN6PR11MB2750.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:935;
X-Forefront-PRVS: 041517DFAB
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B4f6ysuaScRbETCTzEAHlgSWdKMdgX1UVcI6ha2y9XkXi9hyD0JHXuxizEXRibTLWcGga7K6TS0tgzxZ/BZsUnsgU9lyH9iSKdn5xmg2m16FogdL+DVF01vTwPQpKp0SUKuo2kMpX6EeQFG4VhEAwz49q4t41ePZvZDghvjoA4kyn7YDMSYpul4wLCZ6ClVtBCZ4FuA1jrjP3V4V9ns+QTXMJM7/06kEC8c173jZ5v1SCs+5f0/NT3d0T35zoSO5QrMfCCXgupTGijbHZ/9EVTthkkbGUOFLy0mngkAJjiSAuBMx6RRMkDN/TSPDvwcdVuH8TWR+Ik4qpYvTR8TF5g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(376002)(366004)(39860400002)(136003)(346002)(4326008)(6512007)(316002)(8676002)(8936002)(2616005)(6486002)(2906002)(107886003)(1076003)(86362001)(6666004)(186003)(16526019)(5660300002)(66574014)(36756003)(54906003)(66556008)(478600001)(8886007)(6506007)(66946007)(66476007)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: /ZZ59/K/2AV8Nm6I65rxVU9T6b130UO4lQJOOWcEpeU29nK7HqQrIW7K0g3OyFYuZKl15ncebK8omLWLIW5+4yJpC9vZ2yO3ZRfNluT0ZtXFnbvwpLXT1maSFWv6Qnyavur31qgSY7qaVxOhEJFoPpUEbqowtPDuSBUVoYAR5gzF01R0v+ttDFZcK0MbhuIUILVMW+Jpnk2G6G4mmJ5EFErWfbgePMEFZBFfM/JIQSvfH6y4hMsd/tzFtGnsshe7jmUTEx+ZFT5TlhWZe1sZ5yb6AD+xAe/19js6RaDw10jOr2lIpPU4/vveGkX04MCdnIgQzwcrrUuhsln0MtO7xNYKoDGolIpewN15uORX+g6GQyKkEipH5QOl5ht4ObPb66TQq6475PIxqgbwyO4Ps5VLclgbzuzhtu4y6TTySM2x1oIwxo8gd387j7YFJAJQ8mu7yltgGh/nCVo1xgOAH/008sKQDmOMLbemAdlKB4CUjEaoLzjbzmMCNdzXp8BZNsuSpL+0sHbdmrOmkK/6RAeYhUDPa4gu8PpagK6wSBE=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 783d39ca-549f-4436-f0a8-08d80198db9a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2020 17:18:50.5265
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MkErhpNs69lg1cd2oxQCgctMBsfDJzgUqE/eg9cSPKA450ctqfLK9dxpKkGUFtnk0HOq9DYeFm0z6wXWGY6rIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2750
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSW4g
dGhlIG5leHQgY29tbWl0LCB3ZSB3aWxsIGhhdmUgdG8gY29tcHV0ZSB0aGUgUFMgdGltZW91dCB3
aXRob3V0CmNoYW5naW5nIHRoZSBwb3dlciBzYXZlIHN0YXR1cyBvZiB0aGUgZGV2aWNlLiBUaGlz
IHBhdGNoIGludHJvZHVjZXMKd2Z4X2dldF9wc190aW1lb3V0KCkgZm9yIHRoYXQgam9iIGFuZCBt
YWtlIHdmeF91cGRhdGVfcG0oKSByZWxpZXMgb24gaXQuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7Rt
ZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFn
aW5nL3dmeC9zdGEuYyB8IDQ5ICsrKysrKysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0t
LQogMSBmaWxlIGNoYW5nZWQsIDMxIGluc2VydGlvbnMoKyksIDE4IGRlbGV0aW9ucygtKQoKZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4
L3N0YS5jCmluZGV4IGQwYWIwYjhkYzQwNGUuLjEyZThhNWI2MzhmMTEgMTAwNjQ0Ci0tLSBhL2Ry
aXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwpA
QCAtMjAwLDM2ICsyMDAsNDkgQEAgdm9pZCB3ZnhfY29uZmlndXJlX2ZpbHRlcihzdHJ1Y3QgaWVl
ZTgwMjExX2h3ICpodywgdW5zaWduZWQgaW50IGNoYW5nZWRfZmxhZ3MsCiAJbXV0ZXhfdW5sb2Nr
KCZ3ZGV2LT5jb25mX211dGV4KTsKIH0KIAotc3RhdGljIGludCB3ZnhfdXBkYXRlX3BtKHN0cnVj
dCB3ZnhfdmlmICp3dmlmKQoraW50IHdmeF9nZXRfcHNfdGltZW91dChzdHJ1Y3Qgd2Z4X3ZpZiAq
d3ZpZiwgYm9vbCAqZW5hYmxlX3BzKQogewotCXN0cnVjdCBpZWVlODAyMTFfY29uZiAqY29uZiA9
ICZ3dmlmLT53ZGV2LT5ody0+Y29uZjsKLQlib29sIHBzID0gd3ZpZi0+dmlmLT5ic3NfY29uZi5w
czsKLQlpbnQgcHNfdGltZW91dCA9IGNvbmYtPmR5bmFtaWNfcHNfdGltZW91dDsKIAlzdHJ1Y3Qg
aWVlZTgwMjExX2NoYW5uZWwgKmNoYW4wID0gTlVMTCwgKmNoYW4xID0gTlVMTDsKKwlzdHJ1Y3Qg
aWVlZTgwMjExX2NvbmYgKmNvbmYgPSAmd3ZpZi0+d2Rldi0+aHctPmNvbmY7CiAKLQlXQVJOX09O
KGNvbmYtPmR5bmFtaWNfcHNfdGltZW91dCA8IDApOwotCWlmICghd3ZpZi0+dmlmLT5ic3NfY29u
Zi5hc3NvYykKLQkJcmV0dXJuIDA7Ci0JaWYgKCFwcykKLQkJcHNfdGltZW91dCA9IDA7Ci0JaWYg
KHd2aWYtPnVhcHNkX21hc2spCi0JCXBzX3RpbWVvdXQgPSAwOwotCi0JLy8gS2VybmVsIGRpc2Fi
bGUgcG93ZXJzYXZlIHdoZW4gYW4gQVAgaXMgaW4gdXNlLiBJbiBjb250cmFyeSwgaXQgaXMKLQkv
LyBhYnNvbHV0ZWx5IG5lY2Vzc2FyeSB0byBlbmFibGUgbGVnYWN5IHBvd2Vyc2F2ZSBmb3IgV0Yy
MDAgaWYgY2hhbm5lbHMKLQkvLyBhcmUgZGlmZmVyZW50cy4KKwlXQVJOKCF3dmlmLT52aWYtPmJz
c19jb25mLmFzc29jICYmIGVuYWJsZV9wcywKKwkgICAgICJlbmFibGVfcHMgaXMgcmVsaWFibGUg
b25seSBpZiBhc3NvY2lhdGVkIik7CiAJaWYgKHdkZXZfdG9fd3ZpZih3dmlmLT53ZGV2LCAwKSkK
IAkJY2hhbjAgPSB3ZGV2X3RvX3d2aWYod3ZpZi0+d2RldiwgMCktPnZpZi0+YnNzX2NvbmYuY2hh
bmRlZi5jaGFuOwogCWlmICh3ZGV2X3RvX3d2aWYod3ZpZi0+d2RldiwgMSkpCiAJCWNoYW4xID0g
d2Rldl90b193dmlmKHd2aWYtPndkZXYsIDEpLT52aWYtPmJzc19jb25mLmNoYW5kZWYuY2hhbjsK
IAlpZiAoY2hhbjAgJiYgY2hhbjEgJiYgY2hhbjAtPmh3X3ZhbHVlICE9IGNoYW4xLT5od192YWx1
ZSAmJgogCSAgICB3dmlmLT52aWYtPnR5cGUgIT0gTkw4MDIxMV9JRlRZUEVfQVApIHsKLQkJcHMg
PSB0cnVlOworCQkvLyBJdCBpcyBuZWNlc3NhcnkgdG8gZW5hYmxlIHBvd2Vyc2F2ZSBpZiBjaGFu
bmVscworCQkvLyBhcmUgZGlmZmVyZW50cy4KKwkJaWYgKGVuYWJsZV9wcykKKwkJCSplbmFibGVf
cHMgPSB0cnVlOwogCQlpZiAod3ZpZi0+YnNzX25vdF9zdXBwb3J0X3BzX3BvbGwpCi0JCQlwc190
aW1lb3V0ID0gMzA7CisJCQlyZXR1cm4gMzA7CiAJCWVsc2UKLQkJCXBzX3RpbWVvdXQgPSAwOwor
CQkJcmV0dXJuIDA7CiAJfQorCWlmIChlbmFibGVfcHMpCisJCSplbmFibGVfcHMgPSB3dmlmLT52
aWYtPmJzc19jb25mLnBzOworCWlmICh3dmlmLT52aWYtPmJzc19jb25mLmFzc29jICYmIHd2aWYt
PnZpZi0+YnNzX2NvbmYucHMpCisJCXJldHVybiBjb25mLT5keW5hbWljX3BzX3RpbWVvdXQ7CisJ
ZWxzZQorCQlyZXR1cm4gLTE7Cit9CisKK2ludCB3ZnhfdXBkYXRlX3BtKHN0cnVjdCB3Znhfdmlm
ICp3dmlmKQoreworCWludCBwc190aW1lb3V0OworCWJvb2wgcHM7CisKKwlpZiAoIXd2aWYtPnZp
Zi0+YnNzX2NvbmYuYXNzb2MpCisJCXJldHVybiAwOworCXBzX3RpbWVvdXQgPSB3ZnhfZ2V0X3Bz
X3RpbWVvdXQod3ZpZiwgJnBzKTsKKwlpZiAoIXBzKQorCQlwc190aW1lb3V0ID0gMDsKKwlXQVJO
X09OKHBzX3RpbWVvdXQgPCAwKTsKKwlpZiAod3ZpZi0+dWFwc2RfbWFzaykKKwkJcHNfdGltZW91
dCA9IDA7CiAKIAlpZiAoIXdhaXRfZm9yX2NvbXBsZXRpb25fdGltZW91dCgmd3ZpZi0+c2V0X3Bt
X21vZGVfY29tcGxldGUsCiAJCQkJCSBUVV9UT19KSUZGSUVTKDUxMikpKQotLSAKMi4yNi4yCgo=
