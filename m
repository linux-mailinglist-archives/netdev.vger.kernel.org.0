Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0CAD288FBE
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 19:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390174AbgJIRNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 13:13:50 -0400
Received: from mail-eopbgr760074.outbound.protection.outlook.com ([40.107.76.74]:48911
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390148AbgJIRNp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 13:13:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NBvYZ73B3kZIPoOowYMaiHN0W+BXoGcFx7j0nlQFrxlg8QtoyL0Rh6A996BCU1+/sI71eQEPJiE8U8zi5JSuYJyNP2ro8WiwDZKWgE5aLXWngrhLFb1LIyfi7L/lRlXXKmtJTOt7MNtK1ScZRyBOIdDybGJ7g71ogp++SPj9xS3zFyjkwhBZTwMao8fywz4v7VXmq1SkyoZNrMd8JfL5XnXR6wJT9nqX1cAFUqyc1EQnN54yG73S8Js/VNQj9ee9IJagi1OM29FR9EQPtT2jq4wpMnKB8lSviuBsm84zUiDv0HlmIyPALF2XXg/fh77FKhTYTSIDvsHEfoZ2wFDIBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gFamtZ+oLsXr5s+k5oJSr9zgVd2lARoDpqvQrwygSkI=;
 b=W7UeOmylrbNDKqid79upbMYTMgH+7vJVIqX5HMXsFkyVrCr6H58SHVcRf0izJN20rp78su6R0Cf4DS0NzQvn2tr0tbNNLQcE8W/43+y2ELQUpS/yEUdEPAYzkHBwhGOURgryM4o+RrMVUYdL3CMfcbpASQZUC5VyHDqmj+ld96SkvYUzCZJ/kweAW9dUHe0mX5PP3bMlGHRoxUJVIMCP80KJBKGgufsPrunDn/z5jJlC1wu+Qrj0hQ2e47dBBup+3DEYMQ+Z4+hE7e5GAUDJyooxkhwDzZXC7p5jormf0aHsRlZovvh/Qzncga7tBSXCA3bYEnXwspUoCq2bjjZTAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gFamtZ+oLsXr5s+k5oJSr9zgVd2lARoDpqvQrwygSkI=;
 b=HwpLplVePJQhgklHZKsiG1LMxP5ro7ZpvMZA6f0alnIaOpMAStVzrtWEkbZbBYx7SEGlPbrZgTpvIOb7cy7hznbGBvVQNkK0YDVmYBLXnT9fOTEXSMynqZ+bQ+jGhGpn3tCKQTeU7XORz+g8olbaEcQCQWR0RAFLyPHmN4A9lHQ=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB3455.namprd11.prod.outlook.com (2603:10b6:805:bb::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.22; Fri, 9 Oct
 2020 17:13:32 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a%5]) with mapi id 15.20.3455.024; Fri, 9 Oct 2020
 17:13:32 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 5/8] staging: wfx: increase robustness of hif_generic_confirm()
Date:   Fri,  9 Oct 2020 19:13:04 +0200
Message-Id: <20201009171307.864608-6-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201009171307.864608-1-Jerome.Pouiller@silabs.com>
References: <20201009171307.864608-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Originating-IP: [82.67.86.106]
X-ClientProxiedBy: SA9PR10CA0004.namprd10.prod.outlook.com
 (2603:10b6:806:a7::9) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (82.67.86.106) by SA9PR10CA0004.namprd10.prod.outlook.com (2603:10b6:806:a7::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.24 via Frontend Transport; Fri, 9 Oct 2020 17:13:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 55c31237-5da1-4da5-1254-08d86c76a5cc
X-MS-TrafficTypeDiagnostic: SN6PR11MB3455:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB3455CF96576B3C4B25588D4393080@SN6PR11MB3455.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k6xJxDPNrx1xeQSJ4CvK7qH4MKNdh3mDrbKkZsn60S/4dskwe+xHxZG7au/IsrdFBeUJfv5uusZyyIQVWqeULFd6MTkX1Kd0AZUEk7oadXQkbtVTwGHaaD1we53uMNPSTZQhLbYvfugAS7uicw62wVCXo4+yKkPK6bzZg9/AKfC06wpPW/rmDSbS2/W44bs+jn+VL2IQA/BVb/Jw722cXzntnVrh5914ZutoGqMcs0rfPB83cSgxfFoCPchi+dejQNmXMeH1yr/r9JYdWdc3dtzKSeW5F77r+SRlOm2iMwXNeC1UQ/A8P+GKNGdZdtv3DXEnOIUqKAHto6vd89HW+zkqIPU/ZrnyOO96wJhjq2PH0f7Qcx0WCygvRKdnb5aE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(376002)(39850400004)(396003)(136003)(8936002)(36756003)(54906003)(1076003)(316002)(52116002)(7696005)(2906002)(5660300002)(478600001)(66574015)(86362001)(4326008)(66946007)(66556008)(66476007)(6666004)(107886003)(26005)(16526019)(2616005)(83380400001)(186003)(8676002)(956004)(6486002)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: D/38gC1g/3u8VoaBRMtRZf748kKMNequ7C0RWSafUyF+xvZo+3nKSTnmj7HQbdABVU6eZssim7N05nB8cmDAEzYZYpKPk3zCxseAG+euJizQGK617uWkevyfK+OyZdTCrqCWE3gsM3NmosWImBTG3ntRC8Wih6cJh5A5PDQfI8KaNilLaRXw5fzeKdHUg+VFKtczTZtPO26g1PJ1TtcvafXQhi5B2esyQoqfsZTQM/CIVoyVq8vINAAPneC1j5yyd2Ko5VoSMW/oKw9Gfp751u0C9LiZwi9FZdRC8Rp0o6bgF0RO4PCtvhUTjKtVXWIjnEmugsRu4SEgERBH0myE/Q3R+3H4iiwnWYC1YxGW/Cx7YPtqemWtlkgAeaPhw3+MZD124n1kpnpfacW5R6GSKKAG9YXhH6q+HaeDTVabsaHC5Qu6pM2SBFxGowB3MwLlYwZyZYJeEHrySbXlzdgmY/NX+7DdryVXLrg1ohNw841UUmoswxRn8cxo4a6pBXauP6xR6KWE/G5nJMTce4xM0l8e9rWHV/ZM8z1Jvo8R4jlBRVU5WnhN5BSYShDALXPCenthBNIVmcvQQQ1j0TgH154yGG0XlrdiRQWJq0iGPKEQG8+cWExt8PwJylM3rTBZkjZidIoVn/SfBBkNrB2Aug==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55c31237-5da1-4da5-1254-08d86c76a5cc
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2020 17:13:31.9428
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wIrH+nz/bqRtteRt8XjzqJIWDN5CSghEBWEnPqBivvyCnHZKCGeC/B4uD5xVEFn+I5TnqUF9ygGVuvEA20FfAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3455
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU21h
dGNoIGNvbXBsYWluczoKCiAgICBkcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9yeC5jOjI2IGhpZl9n
ZW5lcmljX2NvbmZpcm0oKSB3YXJuOiBuZWdhdGl2ZSB1c2VyIHN1YnRyYWN0OiAwLXUxNm1heCAt
IDQKICAgIDIwICBzdGF0aWMgaW50IGhpZl9nZW5lcmljX2NvbmZpcm0oc3RydWN0IHdmeF9kZXYg
KndkZXYsCiAgICAyMSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGNvbnN0IHN0cnVj
dCBoaWZfbXNnICpoaWYsIGNvbnN0IHZvaWQgKmJ1ZikKICAgIDIyICB7CiAgICAyMyAgICAgICAg
ICAvLyBBbGwgY29uZmlybSBtZXNzYWdlcyBzdGFydCB3aXRoIHN0YXR1cwogICAgMjQgICAgICAg
ICAgaW50IHN0YXR1cyA9IGxlMzJfdG9fY3B1cCgoX19sZTMyICopYnVmKTsKICAgIDI1ICAgICAg
ICAgIGludCBjbWQgPSBoaWYtPmlkOwogICAgMjYgICAgICAgICAgaW50IGxlbiA9IGxlMTZfdG9f
Y3B1KGhpZi0+bGVuKSAtIDQ7IC8vIGRyb3AgaGVhZGVyCiAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICBeXl5eXgogICAgMjcKICAgIDI4ICAgICAgICAgIFdBUk4o
IW11dGV4X2lzX2xvY2tlZCgmd2Rldi0+aGlmX2NtZC5sb2NrKSwgImRhdGEgbG9ja2luZyBlcnJv
ciIpOwoKSW4gZmFjdCwgcnhfaGVscGVyKCkgYWxyZWFkeSBtYWtlIHRoZSBuZWNlc3NhcnkgY2hl
Y2tzIG9uIHRoZSB2YWx1ZSBvZgpoaWYtPmxlbi4gTmV2ZXIgbWluZCwgYWRkIGFuIGV4cGxpY2l0
IGNoZWNrIHRvIG1ha2UgU21hdGNoIGhhcHB5LgoKUmVwb3J0ZWQtYnk6IERhbiBDYXJwZW50ZXIg
PGRhbi5jYXJwZW50ZXJAb3JhY2xlLmNvbT4KU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxs
ZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngv
aGlmX3J4LmMgfCA0ICsrLS0KIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDIgZGVs
ZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfcnguYyBiL2Ry
aXZlcnMvc3RhZ2luZy93ZngvaGlmX3J4LmMKaW5kZXggY2EwOTQ2N2NiYTA1Li4yZDQyNjUyNTcx
MTIgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3J4LmMKKysrIGIvZHJpdmVy
cy9zdGFnaW5nL3dmeC9oaWZfcnguYwpAQCAtNDAsMTAgKzQwLDEwIEBAIHN0YXRpYyBpbnQgaGlm
X2dlbmVyaWNfY29uZmlybShzdHJ1Y3Qgd2Z4X2RldiAqd2RldiwKIAl9CiAKIAlpZiAod2Rldi0+
aGlmX2NtZC5idWZfcmVjdikgewotCQlpZiAod2Rldi0+aGlmX2NtZC5sZW5fcmVjdiA+PSBsZW4p
CisJCWlmICh3ZGV2LT5oaWZfY21kLmxlbl9yZWN2ID49IGxlbiAmJiBsZW4gPiAwKQogCQkJbWVt
Y3B5KHdkZXYtPmhpZl9jbWQuYnVmX3JlY3YsIGJ1ZiwgbGVuKTsKIAkJZWxzZQotCQkJc3RhdHVz
ID0gLUVOT01FTTsKKwkJCXN0YXR1cyA9IC1FSU87CiAJfQogCXdkZXYtPmhpZl9jbWQucmV0ID0g
c3RhdHVzOwogCi0tIAoyLjI4LjAKCg==
