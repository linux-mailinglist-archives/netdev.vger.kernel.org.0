Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AEE31BA511
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 15:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728215AbgD0Nl7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 09:41:59 -0400
Received: from mail-mw2nam12on2078.outbound.protection.outlook.com ([40.107.244.78]:6167
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728181AbgD0Nlr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 09:41:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q+m8A4dkt537S3/+e0Yhi6kWCWCNBlzSx4OyA5+s4UoKGCxvOGFUFsocOc42lHWt79wBYkivluKtwsT1SS69y1MAWZwqusiwProb2egybPXU0Fip0V1yXUJNufUMHNgd08TN8sSwZIu+lbzTtc8IfKtP6GfgopgWF81XuuEQ9gW+7HG/f8zHdeLXNCkaEXIysvTV50BMC3xjoHzUsDaACuwNwOmPmJ6f93+669c6JAtcbu1DPBChKM9i5Nm0Lblbo03+5HABnCEqtpVk65duCvWknMNJs9Y55Ez/di8+acWzwqZRpjk9PVUw4dl+sJ37vNxC3hVv6K9Z2u4qMMPpNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U4Qf85QInMmItIH52jEcdSx4hflv5Asj3HUCTAdM1jU=;
 b=UZd0Z97EnilVKjt6MqDEZ5/1uN4az8WdeM9ZfqSEMsNkCmX4Ha8mmTinKHKCvuokJ/TDfN7q6IM1yoDR56c0bwsDeMpaqWWOKV07eBVVVpPMhMIjrmnpTAQgGCmwZ9gbjfWr1O3U2zl30Obiji0to0Bb4bYCff6vQXT9P5cLK89HVVTDXBrohJRSGwS2xsKEsKyamulOqCl5WYA0ycBuMjcWdzZoYL90Xe+Hx2/c1HM/a05P67AgkndO4aXFA9KILlYWRl/NHXQCq5q6CBh4KddaUeOp5+Um04QL6IwhUg/VvZ3Ic/JRDehh3krA2tqFsLMJHHOXX2JZuVWgW7mGRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U4Qf85QInMmItIH52jEcdSx4hflv5Asj3HUCTAdM1jU=;
 b=jYxyC/OAyvoD3iX17p7QvSisTkTj13bnCgIo1oXn6rQC3j5C4om5j3SdpmGRAGZjmyJY+A893YBZRMh/kGydtNWaeuMgN4tm65RSimoRzI+wrhO1tQNWbKa8sZlwCadb7LGr7lRHml6lxceBGnW5vp/4VhaFM94JbqGEQONBu+c=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1424.namprd11.prod.outlook.com (2603:10b6:300:26::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Mon, 27 Apr
 2020 13:41:45 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe%10]) with mapi id 15.20.2937.023; Mon, 27 Apr
 2020 13:41:45 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 16/17] staging: wfx: fix display of exception indication
Date:   Mon, 27 Apr 2020 15:40:30 +0200
Message-Id: <20200427134031.323403-17-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200427134031.323403-1-Jerome.Pouiller@silabs.com>
References: <20200427134031.323403-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR0P264CA0232.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1e::28) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.home (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by PR0P264CA0232.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1e::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Mon, 27 Apr 2020 13:41:42 +0000
X-Mailer: git-send-email 2.26.1
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ca74b27a-f279-4da2-a0fa-08d7eab0b9ba
X-MS-TrafficTypeDiagnostic: MWHPR11MB1424:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB14248EE44E8797FEA0CAFD2493AF0@MWHPR11MB1424.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0386B406AA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(39850400004)(376002)(346002)(396003)(366004)(8886007)(66476007)(66556008)(4326008)(81156014)(86362001)(8936002)(6486002)(52116002)(6666004)(6506007)(5660300002)(16526019)(6512007)(1076003)(478600001)(8676002)(36756003)(186003)(2616005)(54906003)(107886003)(2906002)(316002)(66946007);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5xis6d1uaPVeI6VEx1aEabKBIGp1o17Acq+U8LrhdMuKiEWuOjlXTsL/Fjod7KAxp6KjyAIn+VJw2MdYTe9JWderKZRteIKGm9B2PKkcPTeaA0xu9Fxizfna4WBsEaWVj0l5dAYAX1+kJaYjHeyx1dOzsewCHMipZjFS9thGdDLp+A5fSL4RAJPIVUNvVtIewgyZHcaDZE5HU7altJmQODnG1gLqI8t7vFcjrKAK377fGMKFTAjAi+WYFeBJYMTr4s1+nb9Z45R82egNqp8tmSGaZQt7+k+WphaM9ydoImB+kFJso+cUkqaQKvgy2+7XlcQgCc0FD4RsZ7cQQDE0OSN8i5J1+AX+p8hpEebHkAhAfJlS5ul5s5vJ3Bnzkaai1+Ocw9l7u1qfFjaL+/avSGj4p9HcmJeMuiAgVE6ftxJ1Lf4GaDe+wnn0gcS0zt98
X-MS-Exchange-AntiSpam-MessageData: JIRBfXEPyonqzp5gVPWhM1IBmZ4UgoN4ixLvUKphcwR51GDWKY8Snrwdm7i8DomLqwzH3NwWpYucRZt89RkDozxILHbSmuvIJ5iMmUprZTqkbDG/Wvu7SUCjGM7HqGJzpTXRaBnQsyHQKEK3rQ/xXNl3XMbgkfT2pKd1G2syK3M79+stu1CuhEGPVqbiJsk+SC0i7FkI1+zgKHNgp2vftEDHBiMNTm5TvLha9WgF8zUGrOudV9fksgdzjUKcfB/9KWUAl4T2woBe7uYJ/47n0bui6cUhiUOh+pI5PNWD+sSs20TAP/Gsf7p/XObr2MHHIWKcQ7uqTR6h6uzgTR0rWiYQzUawrWDzQgtdP2PIXppChIzCD5yD4j81mq97WnMsN+hzhhn5zKeJ6rQzMTna+aaEDUJtgAz3e9Lhyz6Lrb5bdDGkxCKaI1NfyacMRnymR05ImJqbz6eCW+dRtl8RHLJTlScfPtoMNBWKlOpDjQjcM+EN9hKMH6OIY0pmXi4Q3cS+eXjfceV2h4Co3e5K/veyHeVcxS6JbM/zcfdFKNW154WfkPz+KmzigmyWyAu+aXr/PBdAjEGfWUdFbQzVI/P2vXONwd/aoviD1hU88rgWlFW3LoxfI4aGPzZpG7m4TN8cPdhTWKCBumWWmfMtde5RFUe7dk7jhyyk4dyYRJ1w+vC3gq5cE5mnlH3LhWzN+4+ifaDYuLXJj11Au7oH5eKZcwC7RBbMfbjDaY51OoKfyQ6Cgh4wPQViLJSDNg2h4+qjp+H3K8plIooja226JH069RGXc913DOH1aQdGJerQtxqXV/OIGP1TQ+eR9pCYbkeRpyHG9Qsv7e8rS6rJA0j9gxf5YhXey+YAKzNKa3A=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca74b27a-f279-4da2-a0fa-08d7eab0b9ba
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2020 13:41:44.9663
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +HPJC8v9Ilapq407cIMrFpD6Ze1uJYMSdekVnQE7J8bQN+BdYAdWM1tGCqAMu2Biuf+zDOc/yCWFksdDFUYW3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1424
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVW50
aWwgbm93LCB0aGUgZXhjZXB0aW9uIHJlY2VpdmVkIGZyb20gdGhlIGNoaXAgd2FzIG9ubHkgZGlz
cGxheWVkIGlmCmRyaXZlciB3YXMgY29tcGlsZWQgd2l0aCBERUJVRyBlbmFibGVkLiBJdCB3YXMg
bm90IHZlcnkgY29udmVuaWVudCB0bwpoZWxwIHVzZXJzLiBXZSBwcmVmZXIgdG8gc2hvdyB0aGUg
ZXhjZXB0aW9uIHVuY29uZGl0aW9uYWxseS4KCkluIGFkZCwgdGhpcyBwYXRjaCBwcm92aWRlcyB0
aGUgc2VtYW50aWMgb2YgdGhlIGZpcnN0IGJ5dGVzIG9mIHRoZQpzdHJ1Y3QuCgpTaWduZWQtb2Zm
LWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQog
ZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfYXBpX2dlbmVyYWwuaCB8IDExICsrKysrLS0tLS0tCiBk
cml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9yeC5jICAgICAgICAgIHwgMTIgKysrKysrKysrLS0tCiAy
IGZpbGVzIGNoYW5nZWQsIDE0IGluc2VydGlvbnMoKyksIDkgZGVsZXRpb25zKC0pCgpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfYXBpX2dlbmVyYWwuaCBiL2RyaXZlcnMvc3Rh
Z2luZy93ZngvaGlmX2FwaV9nZW5lcmFsLmgKaW5kZXggMjc1MzU0ZWI2YjZhLi4xYzAxMGYxNWM2
ZDAgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9nZW5lcmFsLmgKKysr
IGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfYXBpX2dlbmVyYWwuaApAQCAtMjIzLDEyICsyMjMs
NiBAQCBzdHJ1Y3QgaGlmX2luZF9nZW5lcmljIHsKIAl1bmlvbiBoaWZfaW5kaWNhdGlvbl9kYXRh
IGluZGljYXRpb25fZGF0YTsKIH0gX19wYWNrZWQ7CiAKLQotc3RydWN0IGhpZl9pbmRfZXhjZXB0
aW9uIHsKLQl1OCAgICAgZGF0YVsxMjRdOwotfSBfX3BhY2tlZDsKLQotCiBlbnVtIGhpZl9lcnJv
ciB7CiAJSElGX0VSUk9SX0ZJUk1XQVJFX1JPTExCQUNLICAgICAgID0gMHgwLAogCUhJRl9FUlJP
Ul9GSVJNV0FSRV9ERUJVR19FTkFCTEVEICA9IDB4MSwKQEAgLTI0OCw2ICsyNDIsMTEgQEAgc3Ry
dWN0IGhpZl9pbmRfZXJyb3IgewogCXU4ICAgICBkYXRhW107CiB9IF9fcGFja2VkOwogCitzdHJ1
Y3QgaGlmX2luZF9leGNlcHRpb24geworCV9fbGUzMiB0eXBlOworCXU4ICAgICBkYXRhW107Cit9
IF9fcGFja2VkOworCiBlbnVtIGhpZl9zZWN1cmVfbGlua19zdGF0ZSB7CiAJU0VDX0xJTktfVU5B
VkFJTEFCTEUgPSAweDAsCiAJU0VDX0xJTktfUkVTRVJWRUQgICAgPSAweDEsCmRpZmYgLS1naXQg
YS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9yeC5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZf
cnguYwppbmRleCBlNmRhYWMzNmY1YzguLjc4M2YzMDFkNThhOCAxMDA2NDQKLS0tIGEvZHJpdmVy
cy9zdGFnaW5nL3dmeC9oaWZfcnguYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9yeC5j
CkBAIC0zMzEsMTAgKzMzMSwxNiBAQCBzdGF0aWMgaW50IGhpZl9nZW5lcmljX2luZGljYXRpb24o
c3RydWN0IHdmeF9kZXYgKndkZXYsCiBzdGF0aWMgaW50IGhpZl9leGNlcHRpb25faW5kaWNhdGlv
bihzdHJ1Y3Qgd2Z4X2RldiAqd2RldiwKIAkJCQkgICAgY29uc3Qgc3RydWN0IGhpZl9tc2cgKmhp
ZiwgY29uc3Qgdm9pZCAqYnVmKQogewotCXNpemVfdCBsZW4gPSBoaWYtPmxlbiAtIDQ7IC8vIGRy
b3AgaGVhZGVyCisJY29uc3Qgc3RydWN0IGhpZl9pbmRfZXhjZXB0aW9uICpib2R5ID0gYnVmOwor
CWludCB0eXBlID0gbGUzMl90b19jcHUoYm9keS0+dHlwZSk7CiAKLQlkZXZfZXJyKHdkZXYtPmRl
diwgImZpcm13YXJlIGV4Y2VwdGlvblxuIik7Ci0JcHJpbnRfaGV4X2R1bXBfYnl0ZXMoIkR1bXA6
ICIsIERVTVBfUFJFRklYX05PTkUsIGJ1ZiwgbGVuKTsKKwlpZiAodHlwZSA9PSA0KQorCQlkZXZf
ZXJyKHdkZXYtPmRldiwgImZpcm13YXJlIGFzc2VydCAlZFxuIiwKKwkJCWxlMzJfdG9fY3B1cCgo
X19sZTMyICopYm9keS0+ZGF0YSkpOworCWVsc2UKKwkJZGV2X2Vycih3ZGV2LT5kZXYsICJmaXJt
d2FyZSBleGNlcHRpb25cbiIpOworCXByaW50X2hleF9kdW1wKEtFUk5fSU5GTywgImhpZjogIiwg
RFVNUF9QUkVGSVhfT0ZGU0VULAorCQkgICAgICAgMTYsIDEsIGhpZiwgaGlmLT5sZW4sIGZhbHNl
KTsKIAl3ZGV2LT5jaGlwX2Zyb3plbiA9IHRydWU7CiAKIAlyZXR1cm4gLTE7Ci0tIAoyLjI2LjEK
Cg==
