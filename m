Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4938B408B9E
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 15:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239992AbhIMNEe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 09:04:34 -0400
Received: from mail-dm6nam10on2042.outbound.protection.outlook.com ([40.107.93.42]:9633
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238540AbhIMNEN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 09:04:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HgvUbHrK5/J2ONvgjVIVgA8H0xOaT0JOtZ2tZjCr7R1W+sBd+3KdAKN+8zVHOv/PXHJ1I+vmK+p5pXptLJZen40nix2UhM4wcyt5YuxY0tAV6e3julb/VYX2rGZ0tqCbKFtbfBd2DuaA2uek2nMHGA9WwEqT8z1s3hsWxfebxH637eZ+dTLyxSibqKqnnZwPxs77OFPGTQhD9bPhz69zg6q/vlch5GE2QTtMBNkYWmK1vJN2Ne8himUW2HT1eLLcfUFPPiZ6SHxKEDxFz19AL7PgNH1zOLoZ4n+EfwhlD3A6FFTgu7Go1BIZI/FIlblrFpjNIgMIVISm2Qc7hRsbJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=zepjhr/9IN2TlKMACudigtOtb0JfVXPJtJXaDzy1Q/o=;
 b=Hy8DkU3HtsxC4yITYA1exB/xfZvzO/HghjZ97+dmr8OZThgxYSseGiBXsO281MyohsSGDPv9OI1L1VNaeU5HYpgJ1XdminiI83u7IDvoT0QvKwCCL+sPN+kDBlEgtK62lSQ3OD0HUalB7bsxdwLOZxx9rvoyOzWP8FRVQ8sxx9IGA3ZDtlUux+trI57AEF23n3TvhTBdWEH7VaycJ8e+eB4KOK/EnRS9UVQCjvEoDBd0j+HPbY24WyMPm8i/3tUvbam3AjUs+YdffvKbvnrG7vCliZ4+UnQi3G7MxDnHjK5YJ/Fg1HMY/doeNXDMYFWo+1eHrYjRQ3NgcQyIkOBq7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zepjhr/9IN2TlKMACudigtOtb0JfVXPJtJXaDzy1Q/o=;
 b=iA5dfYgCcu1Ie/+3003OxgQ6eyaRjLmKHHSKyL51z8J+2M7IEkdwZ3X9psGOPh8LnmCVfLUtYZKT0xIzWyrZdAu/Ioj7hF4A60j9BSkSek3vSKMocoet5QBjjahLIxp9Ihu0ODSA7/SytOlKgHAl77a9Eto2nz3etN6DkEfXzhI=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB3502.namprd11.prod.outlook.com (2603:10b6:805:da::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Mon, 13 Sep
 2021 13:02:54 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Mon, 13 Sep 2021
 13:02:54 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v3 20/32] staging: wfx: apply naming rules in hif_tx_mib.c
Date:   Mon, 13 Sep 2021 15:01:51 +0200
Message-Id: <20210913130203.1903622-21-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913130203.1903622-1-Jerome.Pouiller@silabs.com>
References: <20210913130203.1903622-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR2P264CA0021.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::33)
 To SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PR2P264CA0021.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 13:02:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b3cf8750-7a61-41a0-e511-08d976b6ccf0
X-MS-TrafficTypeDiagnostic: SN6PR11MB3502:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB3502BC7F526446B2D5A16B6E93D99@SN6PR11MB3502.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ug3x70gRVgneeNIIPiKQkGBrj9NsHy5rCF51M73tTiwEiUy12ewjkCArNQiWcA95uPtY6ovFOt7q/TtlVhnu0S8SWW8Mkeu3H16l/FCFD4qoMcLtajHz3e4ZMZwPE9Pyfi//8fhFqYjfmSlY8htLFlVKTzo7gazGVLUGhFkUIRlPHIPSh0wR6U6ul9L8LcdwEnvNL8vfBHolIBd75Hbar3SVJij1xdg3m86HKZFoAgNeoC+BrY9ZszIm8I7k//ooHWZAfdQhtHCGM+2eu1KxARZ58uqN474zhZ/B54GIA5CdMKLgLWBZ7r+gH1Q/+mDKwtyyZhQaicHstEGcDaK2LjNAdLcVYI7xvN97zxqQZxCMCymTzis2QYI8k8qpNgGGV7+LI1hDY4BCFG3us7pbQWEy6BpJlaD7+YCrTgSDd14zfKYEpG0gI8TTmmyZ8C5QM9OuI/WZm+DkLSpqBc+uIOhXb4iugkUr6UFSdcl3oIcFayUEyA8SRrj9C+E8DdOk8YPoSfMfRhwoFv0SOdODP77NbIvvGA51kxTeJrNqrnFG4J5+ZbdqA2fm9FxubR2VxAS5iOCnLkmvN/PxclzzZnpeWjlP5wdhuo0xP1ntfdRxglhUK54tua6JJHqoeNm54FG1Bdy4wcLIyQLgsqmXIN8tn0CyDkl/0VE2Opwrt87wWzmLOTSyddRz4Ruwe5l4sAJeSD5W6mUhshcczda+Dw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(136003)(396003)(376002)(346002)(366004)(316002)(66476007)(8676002)(186003)(7696005)(52116002)(66946007)(26005)(4326008)(66556008)(2906002)(54906003)(107886003)(6486002)(2616005)(478600001)(1076003)(36756003)(5660300002)(956004)(8936002)(86362001)(38100700002)(38350700002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?THdDSzY0aXNqcjFJSHE2cDhzcDJZNzA3Y0M3b2FqOXk3ZDR1REJuWlNueXVJ?=
 =?utf-8?B?dXBGbEMxM2RGVk01aWRmcnlZc2pibVpiNDljSzltVW13cFpqa0xiU1NLM1dn?=
 =?utf-8?B?WlpFbjNHODZvamQ2S3FQdFQ1MWFPWkVYME1qN1J4MVdneXpEeVdqTkptb1Jx?=
 =?utf-8?B?K1ZDTDhUNlp5cWl3RHMxWHJPckcyaStUSzhGY2I3bEVTWU1yTktWaDF1ZTBG?=
 =?utf-8?B?QUNFQTk1KzVyYy9NUVJRMVdDWGhDNTFoM0s4azNzbThZY2FNWmg4QS9QL29j?=
 =?utf-8?B?REc0UitvQnltanM1OFUvVFd5NnpTWTBWSW1DcEl3L2pCM1pRc3crM2U3Sk1h?=
 =?utf-8?B?VkVGZC8rVFZOdmphSjRZRTJrYnZ3WWd4cVgwZm5GVy9JZmx4NHlMRk1na3hY?=
 =?utf-8?B?Sm02MFEyWDlPaThOVDVWUW9sNFJKRXVKcDZQYjBSazRmV2pzRkUrc2UydmUw?=
 =?utf-8?B?VmJHVC9SNStLOW5NcGNkYXBoZmN2THlvUlBTS3VCY2pDOGF1MnZlMGtBYlRN?=
 =?utf-8?B?WndlZ0tONDBpQTBKbzlXakF6S1hNTFZ0Rk1pZXY3TlZTcS9SMUIwYzlac1ZM?=
 =?utf-8?B?L3dLRitocVZ1NnJCUU5DWGVUM1pxUi9MbEloWWxOVWJhVHoxNEkwRExveVQ4?=
 =?utf-8?B?T3FWYkd2cUNhWUNiMzNzQU9reXRkVEtqREd4aU94QU44WVYrZFRZbFZOV3Jh?=
 =?utf-8?B?T3lpR2Jna29DVkQ0aUJFbWVDZVVJcVRHTm93ODM1a2pCaHAzSThOVTdXbS8y?=
 =?utf-8?B?d1lIWGFDU3F2UTJBeVhvN2VjQ1I3WnZDclpQUlA0azBjYmJOSFZ1ZDVwY0I5?=
 =?utf-8?B?aGwzNkxEUUtyaFpialdWMHpZY2tYMWNnWFIzRnRsR3lXeXdIdE1ZQmdyY2dJ?=
 =?utf-8?B?MGxTOUN0VzVIYVN1Q0ZWMlpEOUIrWjc4aC9Pa21ONGpIbUxjdWpRWklXRnIw?=
 =?utf-8?B?SXp6Wk96Zy9oRTV0UmdtMFJyaXgzdlVnSm1yTnJBZ290ajROZkdSc1B4RmV0?=
 =?utf-8?B?SW5JSXIzYkFhOEZCWmRPMHpqNkE4UEVEQTNqRjVIN3haclFXaVNCUVZ6KzQ1?=
 =?utf-8?B?cDg2d244dHI2RHJETXFNdExiTmE1NjBiWmVmVk13Mnlsd1NSUzJjMHhvV0xo?=
 =?utf-8?B?SUpSTDB0NU9waDV1UDRVTWorL1FPakJVT3Ixa2ZxUDIzYyt6aUJXSFA1dkpx?=
 =?utf-8?B?MnFmOEc3aDMybkVYUXpvaTA5enJKaExFWjE1OThjQjV5Vitza0RwcjArckcz?=
 =?utf-8?B?dTc5TlFraXRjcFFrRjFDQm9Va2sxbGxPdEVrclhoVEd4eG54bjRoRWN6VHFa?=
 =?utf-8?B?SEJJYStUMXYwdVhoTk5neHRPc1lIQkJHOTJXME9BeVpITC9CeEVHa3QwWVIr?=
 =?utf-8?B?N1hRajhEdm9Va3htM2hUVFNKQWdlZVNjMkIxN0F6NTdFRloyaTRZNGJLa25p?=
 =?utf-8?B?S2REb3ZESFZFc1lxYTJXaWxRT0hGSXVxcXpvNHducnovWFoxcHJzbVZXZmx3?=
 =?utf-8?B?TW1pbHplVnBXdXdYREJsRURKditCcEJ6VkZLem9JL1Q2UEZzeEM4ZCtydS9q?=
 =?utf-8?B?ejRqb1NxRDRSWGZWZXovV3ozdkJZNk8vKzUvRUJ3S3V3bkNLT0NXYnZyY3R2?=
 =?utf-8?B?MWkzeFNtRU5uOUk3aTdXL2Iybi9aQW1kRWVpTDlRbERWZU56dTBnUUI5V0RX?=
 =?utf-8?B?azhVZ0lKVGhCNWRoZFpKeWg4UXVEMXJDZEJxZWswaVlGdGZvOFRqRVRHbUNE?=
 =?utf-8?Q?avWSXwvBYFmWN1rJ51O77rV1WWwF1AxjOvuG6zN?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3cf8750-7a61-41a0-e511-08d976b6ccf0
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 13:02:54.5199
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fwLMis47clHoasLdVRUD49uBjxbBUmvdeA4wJmpGAjSgNe25zEcfGutjCqc1Ded9MZu0DJECe+2Tj9xUxKvlpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3502
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKQWxs
IHRoZSBmdW5jdGlvbnMgb2YgaGlmX3R4X21pYi5jIGZvcm1hdCBkYXRhIHRvIGJlIHNlbnQgdG8g
dGhlCmhhcmR3YXJlLiBJbiB0aGlzIGZpbGUsIHRoZSBzdHJ1Y3QgdG8gYmUgc2VudCBpcyBhbHdh
eXMgbmFtZWQgJ2FyZycuCgpBbHNvIGFwcGxpZXMgdGhpcyBydWxlIHRvIGhpZl9zZXRfbWFjYWRk
cigpLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBz
aWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4X21pYi5jIHwgNiArKyst
LS0KIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pCgpkaWZm
IC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHhfbWliLmMgYi9kcml2ZXJzL3N0YWdp
bmcvd2Z4L2hpZl90eF9taWIuYwppbmRleCAxOTI2Y2YxYjYyYmUuLjE5MDBiN2ZhZmQ5ZSAxMDA2
NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHhfbWliLmMKKysrIGIvZHJpdmVycy9z
dGFnaW5nL3dmeC9oaWZfdHhfbWliLmMKQEAgLTgxLDEyICs4MSwxMiBAQCBpbnQgaGlmX2dldF9j
b3VudGVyc190YWJsZShzdHJ1Y3Qgd2Z4X2RldiAqd2RldiwgaW50IHZpZl9pZCwKIAogaW50IGhp
Zl9zZXRfbWFjYWRkcihzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgdTggKm1hYykKIHsKLQlzdHJ1Y3Qg
aGlmX21pYl9tYWNfYWRkcmVzcyBtc2cgPSB7IH07CisJc3RydWN0IGhpZl9taWJfbWFjX2FkZHJl
c3MgYXJnID0geyB9OwogCiAJaWYgKG1hYykKLQkJZXRoZXJfYWRkcl9jb3B5KG1zZy5tYWNfYWRk
ciwgbWFjKTsKKwkJZXRoZXJfYWRkcl9jb3B5KGFyZy5tYWNfYWRkciwgbWFjKTsKIAlyZXR1cm4g
aGlmX3dyaXRlX21pYih3dmlmLT53ZGV2LCB3dmlmLT5pZCwgSElGX01JQl9JRF9ET1QxMV9NQUNf
QUREUkVTUywKLQkJCSAgICAgJm1zZywgc2l6ZW9mKG1zZykpOworCQkJICAgICAmYXJnLCBzaXpl
b2YoYXJnKSk7CiB9CiAKIGludCBoaWZfc2V0X3J4X2ZpbHRlcihzdHJ1Y3Qgd2Z4X3ZpZiAqd3Zp
ZiwKLS0gCjIuMzMuMAoK
