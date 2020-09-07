Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 602EE25F815
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 12:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728905AbgIGK0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 06:26:33 -0400
Received: from mail-mw2nam10on2078.outbound.protection.outlook.com ([40.107.94.78]:7488
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728715AbgIGKQV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 06:16:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WOcpuNQgbkztH+G4oB5ExDGswBchCTwVjuFRWn9EtS+Wa+p80q9djXD0Cu4VmC6o3oIMn1OFE8HFVXuyO71D41Eer6I9MRPbnB4D8mkhb4WuRs1OInivAysMFFxyhoTaSqODABZtrmo9s0gelgKUULUrs8hbIevX5qS6AWxmOqMrR1MhESqigN6RsXmqkagprbZRq72nwGidK/83Jy/RZMzp6cR8qYycHzM7z7AzMN9iFFfcyHg48QbXV0WcuJJ/0aEWdecac+YW4FetsB32yDGfNT0gsZAZk7liUQ6hx6G3cnRCyemQbsaEEm0ua6Oev/aqTCGZ7RJY+GwiE/UCiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ujUlujIB6wO1ZYDJtSkyrb3rog6jRF8m+w6QhN2mNYo=;
 b=haYdRMZsQ/mQbHPCZBLsC8OFNEXT6eENo4n6767X5yl5+oB47skzE6PPdZI5k1SS6nrIuE6dAAXKEw0UDu6yKxzGe+wg08UBWInHohBAkdRQQHnxPWEeMc/IYg88Hz4ia+RRRX2GA0gNXrIgWw2uGNhUzA3bKTIoYWOVIgX/S3Lg3uwCWUJmFe4Y2+UXMulQzir1P6qxHs3s1yFuhIp/mkmL1I2GXRnSBpF5QwUn4KpWVUvUK7P4YQYdqMvmBzJFRFvCGLZYuN6wFsMMVdTFR/xkkKyRv3aDCR7fFWOdW2Cl/s8BBWLbqx3xgATkOjUrEzuIFORmIKLrESHPtLtiag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ujUlujIB6wO1ZYDJtSkyrb3rog6jRF8m+w6QhN2mNYo=;
 b=GEehFPpS2BbJ13qKf1uzyznk20YmcHB1Q2SXp5JMugWwL17OPnvVq+nw1xZX2bxgvnEByMMrVDc3d73tWjPOB7rY2ZbHqJlzKA27DKkaQH3jOhctHY60aOcWY7MvUFF6erAliNekUonlGObmEKJmRm2D3HCbf8Y21LPyaSblca0=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2720.namprd11.prod.outlook.com (2603:10b6:805:56::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15; Mon, 7 Sep
 2020 10:16:14 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6%4]) with mapi id 15.20.3348.019; Mon, 7 Sep 2020
 10:16:14 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 18/31] staging: wfx: drop useless struct hif_tx_result_flags
Date:   Mon,  7 Sep 2020 12:15:08 +0200
Message-Id: <20200907101521.66082-19-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.silabs.com (37.71.187.125) by PR0P264CA0109.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:19::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.16 via Frontend Transport; Mon, 7 Sep 2020 10:16:12 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [37.71.187.125]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 585bd539-aa85-43ee-994d-08d853170cf9
X-MS-TrafficTypeDiagnostic: SN6PR11MB2720:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB2720D3F2B1296B787472DC1793280@SN6PR11MB2720.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:983;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 26zSf+fku1CJgDZNSj1WeYHrkksqERmHU5JX0DZSv+5vsQooHWvnmaYAVV/hbL0DO2b5a1LU0Lh6k4YW6r4x6/C8yyIy85bWXfziEAMcemJEIi9St9+GwpczUWkEzapDL3XeS9FbG8MVC/JRfrwYzdHXvgrYn80WtHT/zEGIyhhaVBDdW+pikUng7ysG8UVpwpvrBRL/Y47F/Q13e1Nks2767cUQ93NY5Oxyz4f4+VxjmofJkQywnaoB9kzNii9NKjxQAKS24RmIdehWRtiadeJbpuqEub4Jgys15C/8yeHt2nZf2/X18Y9BnxAWVFmGYuMPFDgkeQOGqLB7Dv+Adg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(39850400004)(136003)(346002)(396003)(66946007)(66556008)(66476007)(54906003)(26005)(186003)(16526019)(66574015)(83380400001)(107886003)(6486002)(8676002)(956004)(2616005)(2906002)(316002)(86362001)(8936002)(478600001)(4326008)(7696005)(36756003)(52116002)(6666004)(1076003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 26C4kXXEYDyiRKdFVfHOul2K/V+u9RpDh7HtpSUvSO/5HQiqHFqAEFr8IMd59YkgAMOm0LLIGLjDPw+4SKtY5BngZqKYfGfgPQ7eGCLblmQwEKE0Z/FIvv5YfRvhW4SevgOUijSqQ1lKzjHqQbGVUbNIQyo2Cf7NpOKdugId3djHuxCPX8Sr3bEwQ80mZlhItSQlNiSZWCTm2NV1ikKQ42GAjVvHeQVbFC+t7U2zasLVA1OdsIVIopjzrV0+4d42sPhOtQXZvlnI6THvGULwx5OFxTzW9yeFx+ZuO9IFW0uETK9rnMMZ+fAjwYCepJKM4YXI6dVFDn4yb+zygAW+hw+Cey+e/7+B1CtOIyo4a1PiG6TiyCqUlWCVAQV3feGmkudYMRv63wS0i4JK73IzhtyckrW1ZJ5r9eoSeSrNyseWp0iqXm4z/J4b7S/PqHhA5o2jfZLPSiEzAkHyHsl6BBtqW7yj8nKctsnXd3Zbqca7JANUuYFR8oOAHLBKbhEnD/bCBaXF0FHiyocRxrMPX78Lc80QfMqYSs5eY+XGevmnGYMqBbwI7DfLicJTkpjwALP6+QkDv/syIKcfm7WXSNbIyHiKFnstATZEqfoIrWI7dvm5nKzcIGjZCXJAnWJy0CAqID3MCaBrGWjbdvEk+w==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 585bd539-aa85-43ee-994d-08d853170cf9
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2020 10:16:14.1701
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pONOz0MD3uOszb0NWpPGrrUgsizqVM14chk+86bFKo8rI96coRhLTck60b1NumI5Rf21H/7CNko9Tv3xedsU1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2720
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU3Ry
dWN0IGhpZl90eF9yZXN1bHRfZmxhZ3MgaGFzIG5vIHJlYXNvbiB0byBleGlzdC4gRHJvcCBpdCBh
bmQgc2ltcGxpZnkKYWNjZXNzIHRvIHN0cnVjdCBoaWZfY25mX3R4LgoKU2lnbmVkLW9mZi1ieTog
SsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZl
cnMvc3RhZ2luZy93ZngvZGF0YV90eC5jICAgICB8ICAzICstLQogZHJpdmVycy9zdGFnaW5nL3dm
eC9oaWZfYXBpX2NtZC5oIHwgMTYgKysrKysrLS0tLS0tLS0tLQogMiBmaWxlcyBjaGFuZ2VkLCA3
IGluc2VydGlvbnMoKyksIDEyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3Rh
Z2luZy93ZngvZGF0YV90eC5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmMKaW5kZXgg
NDg1OTA3YjBmYWEyLi4xZjIxNThkNmVhYTkgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93
ZngvZGF0YV90eC5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jCkBAIC01MTgs
OCArNTE4LDcgQEAgdm9pZCB3ZnhfdHhfY29uZmlybV9jYihzdHJ1Y3Qgd2Z4X2RldiAqd2Rldiwg
Y29uc3Qgc3RydWN0IGhpZl9jbmZfdHggKmFyZykKIAkJZWxzZQogCQkJdHhfaW5mby0+ZmxhZ3Mg
fD0gSUVFRTgwMjExX1RYX1NUQVRfQUNLOwogCX0gZWxzZSBpZiAoYXJnLT5zdGF0dXMgPT0gSElG
X1NUQVRVU19UWF9GQUlMX1JFUVVFVUUpIHsKLQkJV0FSTighYXJnLT50eF9yZXN1bHRfZmxhZ3Mu
cmVxdWV1ZSwKLQkJICAgICAiaW5jb2hlcmVudCBzdGF0dXMgYW5kIHJlc3VsdF9mbGFncyIpOwor
CQlXQVJOKCFhcmctPnJlcXVldWUsICJpbmNvaGVyZW50IHN0YXR1cyBhbmQgcmVzdWx0X2ZsYWdz
Iik7CiAJCWlmICh0eF9pbmZvLT5mbGFncyAmIElFRUU4MDIxMV9UWF9DVExfU0VORF9BRlRFUl9E
VElNKSB7CiAJCQl3dmlmLT5hZnRlcl9kdGltX3R4X2FsbG93ZWQgPSBmYWxzZTsgLy8gRFRJTSBw
ZXJpb2QgZWxhcHNlZAogCQkJc2NoZWR1bGVfd29yaygmd3ZpZi0+dXBkYXRlX3RpbV93b3JrKTsK
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9jbWQuaCBiL2RyaXZlcnMv
c3RhZ2luZy93ZngvaGlmX2FwaV9jbWQuaAppbmRleCAzYTYwYmRmMjg2ZjMuLmI4NmVjMzlmMjYx
NSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfYXBpX2NtZC5oCisrKyBiL2Ry
aXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9jbWQuaApAQCAtMjQ4LDE1ICsyNDgsNiBAQCBlbnVt
IGhpZl9xb3NfYWNrcGxjeSB7CiAJSElGX1FPU19BQ0tQTENZX0JMQ0tBQ0sgICAgICAgICAgICAg
ICAgICAgICAgICA9IDB4MwogfTsKIAotc3RydWN0IGhpZl90eF9yZXN1bHRfZmxhZ3MgewotCXU4
ICAgICBhZ2dyOjE7Ci0JdTggICAgIHJlcXVldWU6MTsKLQl1OCAgICAgYWNrX3BvbGljeToyOwot
CXU4ICAgICB0eG9wX2xpbWl0OjE7Ci0JdTggICAgIHJlc2VydmVkMTozOwotCXU4ICAgICByZXNl
cnZlZDI7Ci19IF9fcGFja2VkOwotCiBzdHJ1Y3QgaGlmX2NuZl90eCB7CiAJX19sZTMyIHN0YXR1
czsKIAkvLyBwYWNrZXRfaWQgaXMgY29waWVkIGZyb20gc3RydWN0IGhpZl9yZXFfdHggd2l0aG91
dCBiZWVuIGludGVycHJldGVkCkBAIC0yNjQsNyArMjU1LDEyIEBAIHN0cnVjdCBoaWZfY25mX3R4
IHsKIAl1MzIgICAgcGFja2V0X2lkOwogCXU4ICAgICB0eGVkX3JhdGU7CiAJdTggICAgIGFja19m
YWlsdXJlczsKLQlzdHJ1Y3QgaGlmX3R4X3Jlc3VsdF9mbGFncyB0eF9yZXN1bHRfZmxhZ3M7CisJ
dTggICAgIGFnZ3I6MTsKKwl1OCAgICAgcmVxdWV1ZToxOworCXU4ICAgICBhY2tfcG9saWN5OjI7
CisJdTggICAgIHR4b3BfbGltaXQ6MTsKKwl1OCAgICAgcmVzZXJ2ZWQxOjM7CisJdTggICAgIHJl
c2VydmVkMjsKIAlfX2xlMzIgbWVkaWFfZGVsYXk7CiAJX19sZTMyIHR4X3F1ZXVlX2RlbGF5Owog
fSBfX3BhY2tlZDsKLS0gCjIuMjguMAoK
