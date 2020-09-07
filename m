Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4332825F856
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 12:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728695AbgIGKQO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 06:16:14 -0400
Received: from mail-eopbgr770058.outbound.protection.outlook.com ([40.107.77.58]:18596
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728632AbgIGKP6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 06:15:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RYu1s9j5YSqKyuGghTgdV8kaOmw1cjlozgoChDbkOIt+1m+b4rwWZAPsTt8hyOoB2RHCFNjrLqoI8JpO4oUnTgmwdFxjxVhP9Zh+1Px6s/jJN3oIPdSflhhkWEb118HHpgPoPe/X1QKGUawldY4ujHnPcraKPzPMsGhgvgC5PUV3ABON1862tvfFIWD8FO1z+hZJEnWl1UUSCAr6p4rOjNnv3RILCjuUhsBzlyI5nK1JIbfAuxn4PisfLSwmhOf/pl9L9J/t+AdMyuMxyuSFomZCDDHsc4g84UA+SnvCoir/KJvrIBZgFFIEANamGe2cqypQYD1W80umf2IyCjWpJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3G1qs8X9ThRzfl04Z5X/p574+vMrzA+ay+RNKLM/kPg=;
 b=Gi2KJF6S1E8i44h3YKUV9E8UZgqZc1+rp9yoYw8xB9Y1qchdfdHq+5EFjDyekEcxVR5hR0QbFmPlVTrPIh6lbGeiSNYfUZOFuC25L7R0g1NYzQ1DWGdg8hxRfNkSzfjg3aC+eBYEd6r+OhPJlrebGG2vnV8cZ2lX8Ljc4WPkgTwaEUSEIth9BOuxwYi+NKT0Qt1las0WMLmYa+Vk2KnL1ags7Fr2nCh1enDfI04ASax8uLogmh26QZLjvsSCJvcbSeNPKpMKvP0nJXeoi66aiB3C6fuaRrQfbR1BZrq9J1imHDR814swR0e5Os3KyaaKdKMTgggle8UHA8c+Ud6k+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3G1qs8X9ThRzfl04Z5X/p574+vMrzA+ay+RNKLM/kPg=;
 b=L+LfQRYZAi2Xl0priuEQXT3Y4E1ncK2VZkVmmBQuPf8y628KcmoBE86sFlmWD1Q66njpecBSMQg2Vu23NycrkrQShbuuXLWG2PsEUP1nrqaBzVoTqZ2SUwrMGQ0Dt1c/ou9IASq+ghD2SJleZs3ycHzQiawrTEamyKtAL5WrrH8=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2606.namprd11.prod.outlook.com (2603:10b6:805:55::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.17; Mon, 7 Sep
 2020 10:15:50 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6%4]) with mapi id 15.20.3348.019; Mon, 7 Sep 2020
 10:15:50 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 04/31] staging: wfx: keep API error list up-to-date
Date:   Mon,  7 Sep 2020 12:14:54 +0200
Message-Id: <20200907101521.66082-5-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.silabs.com (37.71.187.125) by PR0P264CA0109.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:19::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.16 via Frontend Transport; Mon, 7 Sep 2020 10:15:49 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [37.71.187.125]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c38a19b2-e95c-4271-79a7-08d85316fefa
X-MS-TrafficTypeDiagnostic: SN6PR11MB2606:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB26062991B1F6F55BADDE606193280@SN6PR11MB2606.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ugy5JBhDZc9uy3zlYkrZwNvsZPJFLPqv0+y3MySstnYmQ9VEOxlB5yQ0R3DMwlCKG3THeUdGwAPVBeRSJGUJFFgGhAvoSTdiVg59FCBhrQXrgoJve5as/atE50dG2prqmRAHLqlraUjJ/dx5LhmY1bo7W5c4ZCoPXCssHvJIM4lzK3ltXyEylHjmb2RkPwlgp8k6T6KWIPlR/QXAdLG/meQy/Itl7y/Dnx2VZO+2Da9BaAHDaEMN7uhrhALOD9Ec585Ybk5sURjPnIOM9S7fcgM0diIvasWMQyNwvCRGcqvG3ujZAOCf4inSkwNvxq8VosIJE/MlX6qR5qE2voeHEg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(346002)(366004)(136003)(39850400004)(66946007)(4326008)(5660300002)(2616005)(66476007)(316002)(956004)(478600001)(6666004)(54906003)(52116002)(2906002)(66556008)(1076003)(36756003)(8676002)(86362001)(6486002)(8936002)(7696005)(83380400001)(26005)(107886003)(16526019)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: UuFZUpMXv5qu3+jwGT+Hp/gCfGuDCOQbOGfiiZP2gdAJ4Fbmvrzre0w+Glv5Y2OXC8j9towF3YsuWr2p7YE8o1/yJi4XVkF4ZoAUPMTuMkPqbPmMcZTan5KoHozqvHUV0zyVeT2xeKhjRipOwE8XRpPGZqWnyyHeL5IzECnb59/maYzbTIxwtZyq7J6ws2Dh6swwFWG2KwQrBh/lw+050XU43DI5iA9LgeCL1rhNBZoUj00EeQkogjvPTYFetUcQ+K2phzWwbwvaPP4UWckGsWiCUZTJWrJeNVGHRWkxi5CwdzK3V1FrcK2C0faVJ1yR/ilTujY/eatxCh41HFJNwqK6liTUznBv31eNSyYirE39JrR8ENjMx6KjN3S1ZZI8n/Z5ib43rspVE/Fxse8vsoFfyB+Ab+YieRgmC0gkNU6NxC4juQUMwmFWmvDtidXIlBdiP9A++rGhnuQXGZjqo6+2pE3DywSKc5/Y1g2pqH4JK3mlQEOG1xxiNRXB/ALp4CrnPl6hDX0vrzGoLZMIvf9xJ328bKeZLSoP96hnXVCyNY9CdGJv6T4XNyeAd2oFe/U8qIOYsPOYTPAicRnkH+Kps8vKHGy/wGXVFBVK+zbe0xcxjMuTQ3x/xtc/MwldvfpOp8ps7YDWU1PKRTmKQQ==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c38a19b2-e95c-4271-79a7-08d85316fefa
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2020 10:15:50.6918
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3EppnKB+hsL0TlwSgOCjNLB3t6iZ9bFxMlr9eSxW0LLDVTSFIthiOH6B+XwE9QETNv2YvxTLlvbHrzpkBJedEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2606
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKQSBu
ZXcga2luZCBvZiBlcnJvciBoYXMgYXBwZWFyZWQgaW4gQVBJIDMuNC4KClRoZSBMaW51eCBkcml2
ZXIgaXMgbm90IGNvbmNlcm5lZCBieSB0aGlzIG5ldyBlcnJvciwgYnV0IGxldCdzIGtlZXAgdGhl
CkFQSSBpbiBzeW5jIHdpdGggdGhlIGZpcm13YXJlLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUg
UG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2lu
Zy93ZngvaGlmX2FwaV9nZW5lcmFsLmggfCAxICsKIGRyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3J4
LmMgICAgICAgICAgfCAyICsrCiAyIGZpbGVzIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKQoKZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9nZW5lcmFsLmggYi9kcml2ZXJz
L3N0YWdpbmcvd2Z4L2hpZl9hcGlfZ2VuZXJhbC5oCmluZGV4IGRiYTE4YTdhZTkxOS4uNzkxZDcz
NzViZDdmIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfZ2VuZXJhbC5o
CisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9nZW5lcmFsLmgKQEAgLTI2Miw2ICsy
NjIsNyBAQCBlbnVtIGhpZl9lcnJvciB7CiAJSElGX0VSUk9SX0hJRl9UWF9RVUVVRV9GVUxMICAg
ICAgICAgICA9IDB4MGQsCiAJSElGX0VSUk9SX0hJRl9CVVMgICAgICAgICAgICAgICAgICAgICA9
IDB4MGYsCiAJSElGX0VSUk9SX1BEU19URVNURkVBVFVSRSAgICAgICAgICAgICA9IDB4MTAsCisJ
SElGX0VSUk9SX1NMS19VTkNPTkZJR1VSRUQgICAgICAgICAgICA9IDB4MTEsCiB9OwogCiBzdHJ1
Y3QgaGlmX2luZF9lcnJvciB7CmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9y
eC5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfcnguYwppbmRleCAxZDMyOTczZDhlYzEuLjM2
YjM5M2I5MjkzNiAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfcnguYworKysg
Yi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9yeC5jCkBAIC0zMDEsNiArMzAxLDggQEAgc3RhdGlj
IGNvbnN0IHN0cnVjdCB7CiAJCSJzZWN1cmUgbGluayBvdmVyZmxvdyIgfSwKIAl7IEhJRl9FUlJP
Ul9TTEtfV1JPTkdfRU5DUllQVElPTl9TVEFURSwKIAkJInNlY3VyZSBsaW5rIG1lc3NhZ2VzIGxp
c3QgZG9lcyBub3QgbWF0Y2ggbWVzc2FnZSBlbmNyeXB0aW9uIiB9LAorCXsgSElGX0VSUk9SX1NM
S19VTkNPTkZJR1VSRUQsCisJCSJzZWN1cmUgbGluayBub3QgeWV0IGNvbmZpZ3VyZWQiIH0sCiAJ
eyBISUZfRVJST1JfSElGX0JVU19GUkVRVUVOQ1lfVE9PX0xPVywKIAkJImJ1cyBjbG9jayBpcyB0
b28gc2xvdyAoPDFrSHopIiB9LAogCXsgSElGX0VSUk9SX0hJRl9SWF9EQVRBX1RPT19MQVJHRSwK
LS0gCjIuMjguMAoK
