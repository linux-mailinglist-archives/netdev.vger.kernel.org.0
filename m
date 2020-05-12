Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49B621CF858
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 17:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730566AbgELPEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 11:04:44 -0400
Received: from mail-bn8nam12on2076.outbound.protection.outlook.com ([40.107.237.76]:45896
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726168AbgELPEm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 May 2020 11:04:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q1uTPTRVFFLZsmPcrFjICeqezdmk+fruoxrJB3A7A0JcEN78uCEVCuUvPzQ1OfBRpfjjW5+lI992qwclndpCPlKlT/zUkdjUwGqV8MLjXF7waUssMyf2D8uV3vhXws8r+6lNb97g3C8pYfp0yPqtrjwsKSk5auL2BHDxIAvcudGDi1uinvWWAQxmU/Wtfpia9KEoTprIIFP+ACTZTfmK4gBIsowh8nPMYv30/1wOZU9mCilLBXcoTPA9cFTsXQDpAzLs9reiuohmwJMJVIP77obSttV7SI6FGc618z30xXRvhgP8O/TPq1DVuA5PJYnxKuPFODnfHh8lVrO6X7MBOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+EkGpEd85h4vR2Ni4US7JJOSHnUAz2lbZZenwSq/nkY=;
 b=Bmb3yU3vfAOpMfT02jKmw8s9KMikGGXSCwYZ2WRcgcxjoZ3F8I4uXeLrz/9yWVYgoT9c1Kvab2GrcpdZVBJP+sxAh6C+780Qheq7EGS+MtnW0N7im9JtJxZiC6VFDEmuI2mznSPr6RqgogOhLHoq9w+qXLqqBwyHd+GBQyq2osvc+k7iJaxl29bemOGFO9FGuwZLVC5UqCAE5SoRTsXebQX0Jsdh3sVLLiDHu6+FCFj1r7SJSJ4hYzBaGb11zDsS/QP332BNANVao7U+su+xpq4zjgJaeRtwFL7jxUyq+PpoUGNGgWQhS6EvzHqHi3qZK9W0XVTWg7im6PEoQMgLPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+EkGpEd85h4vR2Ni4US7JJOSHnUAz2lbZZenwSq/nkY=;
 b=hB/J6sSMldzFn2MVNE3ynlJg8sI3CvFD9JFlU/OK5rS5BQZe6FEtcwCiCLoFl6VjqnSN3JVQt9kVOZQuhVSmcPXbq1hx7kDsHKKG+LLSeMh2xap5PWI54sypPNxbwzT9gd9iDdf3bDUKp9MshwedNv5CWJjEXap4nWe7w4Rpxcs=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1741.namprd11.prod.outlook.com (2603:10b6:300:10d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.34; Tue, 12 May
 2020 15:04:36 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da%5]) with mapi id 15.20.2979.033; Tue, 12 May 2020
 15:04:36 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v2 03/17] staging: wfx: fix cast operator
Date:   Tue, 12 May 2020 17:04:00 +0200
Message-Id: <20200512150414.267198-4-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200512150414.267198-1-Jerome.Pouiller@silabs.com>
References: <20200512150414.267198-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: DM5PR1101CA0003.namprd11.prod.outlook.com
 (2603:10b6:4:4c::13) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (82.67.86.106) by DM5PR1101CA0003.namprd11.prod.outlook.com (2603:10b6:4:4c::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend Transport; Tue, 12 May 2020 15:04:34 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [82.67.86.106]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e10a1d1f-b408-4211-7a95-08d7f685c8df
X-MS-TrafficTypeDiagnostic: MWHPR11MB1741:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB174154219551E73C5B17EAD993BE0@MWHPR11MB1741.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-Forefront-PRVS: 0401647B7F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tXLOcj/bQMTnktDKehYZUgpdLXbtL/nG6Vm6rJJoTN6wvZIkMXKz2hX1SjhRyr6iUXiVdkKreItSn/cc/j7RQKNqziv5tT18GQMDCYznBhvkBg3JnvlSQXQywX42gXZujuUQL7Mx38qfnxPRatxWgd736ORuSCTnX8iouGFXNMRIQg8xhDIA9+QPz1XjcIj3plAFoepmyOGnBryBlJXBSNKVt7xqIGFIHI1NUUMfFktxxiyIXk4eldpVlrUGYwobGuVEUM47POWqnh/Tl1pBBIyazth8jYCdUVIeEh1UD4JFySWE8h69zfAqSgyy7ioPHYUC3UHLUre7nLfpmNM3I63abMtP4wEWCn1bHc6HgADGdm++N1ZJzQ21eltvVK4TWFvfl/P5kXDk0GaE1XdrePsURNYgi6J+LfVEd+Ugh/DAdFQZBwCiKX2dAogywLbxvwjUl3MtIYO6bQHQmsnAxyds2WADAWvwswNdQAXJnt8a3pa7bJ2FkVBESvwPBtQzCLUldbov+OokeFK6ByqTYQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(366004)(376002)(39860400002)(346002)(136003)(33430700001)(54906003)(107886003)(478600001)(8676002)(5660300002)(316002)(1076003)(956004)(8936002)(2616005)(186003)(2906002)(7696005)(86362001)(4326008)(52116002)(6666004)(6486002)(66476007)(26005)(66946007)(66556008)(33440700001)(16526019)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 16vecmAjvvi8H8PcGWpm3T0KJDThcyHoxtl8mwpvGXivZfmBeNtt1NAEZzunSg6v6+++5Az8XO5RfU9/chyoV1rlRyJ0olsmPiVcEe6zQ3sEdEMMrquRxFntG7YhvIBzhxnyOq99nuQ1vBhaU7SQz7T2k6hq6Wiv+cTfz3+v0gjZggziWDMIzroFF2Xs7gYnHTQYd/ttdtyMc1VBzCHummTnwWkbNOFkYacs/nRPCX0rVsYV7ULp25+0bzaqa4pZhPWmFqvRKzQKLrktfrNjegNyYLJn9Ds5HFPHRIWtMsF4c5Xjwe8DbyPELQXL5bTEu956EBeLuGF7vqHdpq6i4NAMSHHWP1dREaMIDm6nohOMFW1AsTfKtrGt0PLzSiiK9/h5T4m7ZZMSmlGnuHV62k9E139pXFWpwy4aYwk6y17gqwDg6yTcdeiw58F++z7eDL1wJ/bG8hk3cJxjQV9ikg/bzKvwI98akBXxhbI4O0g=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e10a1d1f-b408-4211-7a95-08d7f685c8df
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2020 15:04:35.9605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L3UjiLyWrH7cGM21jmow/A+e4m27rNhHKPUBF4vNHtzJCNCuYbMmAhOD1h6t0NZl6JAvzPBrqD2EwxJ0bxpoDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1741
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU3Bh
cnNlIGRldGVjdHMgdGhhdCBsZTE2X3RvX2NwdXAoKSBleHBlY3RzIGEgX19sZTE2ICogYXMgYXJn
dW1lbnQuCgpDaGFuZ2UgdGhlIGNhc3Qgb3BlcmF0b3IgdG8gYmUgY29tcGxpYW50IHdpdGggc3Bh
cnNlLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBz
aWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvYmguYyAgICAgfCAyICstCiBkcml2
ZXJzL3N0YWdpbmcvd2Z4L3RyYWNlcy5oIHwgMiArLQogMiBmaWxlcyBjaGFuZ2VkLCAyIGluc2Vy
dGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dm
eC9iaC5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9iaC5jCmluZGV4IDI1NzJmYmNmMWEzMy4uNTU3
MjRlNDI5NWM0IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2JoLmMKKysrIGIvZHJp
dmVycy9zdGFnaW5nL3dmeC9iaC5jCkBAIC03MCw3ICs3MCw3IEBAIHN0YXRpYyBpbnQgcnhfaGVs
cGVyKHN0cnVjdCB3ZnhfZGV2ICp3ZGV2LCBzaXplX3QgcmVhZF9sZW4sIGludCAqaXNfY25mKQog
CWlmICh3ZnhfZGF0YV9yZWFkKHdkZXYsIHNrYi0+ZGF0YSwgYWxsb2NfbGVuKSkKIAkJZ290byBl
cnI7CiAKLQlwaWdneWJhY2sgPSBsZTE2X3RvX2NwdXAoKHUxNiAqKShza2ItPmRhdGEgKyBhbGxv
Y19sZW4gLSAyKSk7CisJcGlnZ3liYWNrID0gbGUxNl90b19jcHVwKChfX2xlMTYgKikoc2tiLT5k
YXRhICsgYWxsb2NfbGVuIC0gMikpOwogCV90cmFjZV9waWdneWJhY2socGlnZ3liYWNrLCBmYWxz
ZSk7CiAKIAloaWYgPSAoc3RydWN0IGhpZl9tc2cgKilza2ItPmRhdGE7CmRpZmYgLS1naXQgYS9k
cml2ZXJzL3N0YWdpbmcvd2Z4L3RyYWNlcy5oIGIvZHJpdmVycy9zdGFnaW5nL3dmeC90cmFjZXMu
aAppbmRleCBiYjlmN2U5ZTdkMjEuLmM3OGM0NmIxYzk5MCAxMDA2NDQKLS0tIGEvZHJpdmVycy9z
dGFnaW5nL3dmeC90cmFjZXMuaAorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3RyYWNlcy5oCkBA
IC0xODQsNyArMTg0LDcgQEAgREVDTEFSRV9FVkVOVF9DTEFTUyhoaWZfZGF0YSwKIAkJaWYgKCFp
c19yZWN2ICYmCiAJCSAgICAoX19lbnRyeS0+bXNnX2lkID09IEhJRl9SRVFfSURfUkVBRF9NSUIg
fHwKIAkJICAgICBfX2VudHJ5LT5tc2dfaWQgPT0gSElGX1JFUV9JRF9XUklURV9NSUIpKSB7Ci0J
CQlfX2VudHJ5LT5taWIgPSBsZTE2X3RvX2NwdXAoKHUxNiAqKSBoaWYtPmJvZHkpOworCQkJX19l
bnRyeS0+bWliID0gbGUxNl90b19jcHVwKChfX2xlMTYgKiloaWYtPmJvZHkpOwogCQkJaGVhZGVy
X2xlbiA9IDQ7CiAJCX0gZWxzZSB7CiAJCQlfX2VudHJ5LT5taWIgPSAtMTsKLS0gCjIuMjYuMgoK
