Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32BCE411907
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 18:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242498AbhITQNg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 12:13:36 -0400
Received: from mail-bn8nam12on2051.outbound.protection.outlook.com ([40.107.237.51]:10688
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242368AbhITQN3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Sep 2021 12:13:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UkbsHm+jvGHABoAWrwC5dE0yjp5TlexJbys5Fg67IczydctZcl4hWuXgC3D38/eBE0zncOqGmT2fhtUnG7MMQCirztIgy/BKEMlAmqWpbzsRh+eFm0PryTQOilmJR5RDtJqYRfGC1ijHpCjgS/pDNZtpdNdHet8xW4XAIlJgWUD1Fm5YIz0twLHX/KRUYOXLscLncWj2cpAWnuwvehKStaXym5a6JA9zpeCrOOSkvWmioa1uQVKsHi6rAeWEBOA9F8h134j7X3mDK5dGTWjXWCrv+kfvpC4bRqFrxGzQY2TGVRK9kjsub1JBTvhoVQ9S+QpG8r9USdXfmniavbmjiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=GNjCa2/lBKQ/1xBUi2Ezo8tCWK2S1z49PHV2SuZVb4o=;
 b=Q05r5zhS66rnfz1omxdxZqTna+R/UHChXNSMihw8eWA5e2RXedYgWDkHKUsaweKB9ylbZyUB0sBHX+CghuF5Aw0V2cszfwwS2wd4DKK2LrnhZHjteF115SYJW8uxT9LFiPCMMXvvYhdiyGoTDVus46Jv4cSHswCMtJCdhktve+5oHCnLwcIzUN0mAiT9jd2czch4w2DASQvJltHTUqVufW2Q4FjX+HFPs3w0ucQStKJD9ErybgmF1RHn87N30UAIb0SHTSQTPzZ92sJWDQO4ELhA1VjwX9qkRDulVRxLvn2IeYlV1KAK3DKyC627ShtznONVREOafLQwe9ELfF6WOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GNjCa2/lBKQ/1xBUi2Ezo8tCWK2S1z49PHV2SuZVb4o=;
 b=Q+2U4W1WRWbqhijTp26F59cQQB9Rbu2bi7CGMoLt1cu6LbYCcMbwVzlWF0GG02haW1xxh0ijgLq4p0ZePJpiHoPGI5VxBg78XtPuk9oxh+ZbJoqX90kN/wPnw0jG1G46f7UAS76MDV9lX2q3EQnvO55pFQvaXmZN7kZuH0YKfHI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA2PR11MB5002.namprd11.prod.outlook.com (2603:10b6:806:fb::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.16; Mon, 20 Sep
 2021 16:12:00 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4523.018; Mon, 20 Sep 2021
 16:12:00 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v7 03/24] wfx: add Makefile/Kconfig
Date:   Mon, 20 Sep 2021 18:11:15 +0200
Message-Id: <20210920161136.2398632-4-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920161136.2398632-1-Jerome.Pouiller@silabs.com>
References: <20210920161136.2398632-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SA0PR11CA0064.namprd11.prod.outlook.com
 (2603:10b6:806:d2::9) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (2a01:e34:ecb5:66a0:9876:e1d7:65be:d294) by SA0PR11CA0064.namprd11.prod.outlook.com (2603:10b6:806:d2::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Mon, 20 Sep 2021 16:11:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 126a7755-6629-483f-3587-08d97c516093
X-MS-TrafficTypeDiagnostic: SA2PR11MB5002:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR11MB5002608D8912F1AACC3D38B693A09@SA2PR11MB5002.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ly5He/F+1LF2pjtD9sGdb6tPuCQOhDz6lIv+XSvrUJ64pEgyBm4FbLAxhD+Y1c+CSmtNCPl7TsfuLq9fKIVOfwK2r+TpLcrlX2/Y1Q8xrMt8XR/EyGMgHqv/4vnA4yp+/pO787n+FwoOM/kCaQ7GxSuvfc0M0Q8QJ7HjpJsMhX0Pk4ngDUnf4G5HrPvztGUsgjXN4c8yFxMXOfhuZ99BSl3BkyesoQQLH8p2kyTN9CfdtO60AdLdZtcpxr/m53UpBvRn4bDRGlYYA8WanDpzl0LE54u80tXZLq0HWj8yO3O+fv2c/9QkwC5rVe+oYRhjjK4gfmMrweK0051Tdut/EKJ3FdGyE3xcllCVKbZFH4xdQipqO7EQVioLcb8A+4lbnIJ2j4qdRlDtsJwLlMDvJ/pE0BksyAEn/isAey6ShSj7yu9a6hROeo0lD1SrZRxXsTBXgC3yBKASpSIu6R3HrU+MhM0tE5kN7pHlo4mEEuB4C9/rsbZotqaEWN59SINZmHmlYCWWHrYM2BohDqeS7TtketXK8/0XrtVRuyBxwQgPyfOUwMsUFB1N6KgZedBxUlmgVqKO1D8VPdmykA98D7W6k1lrKEbhHCKKdLIs9gLAZH3EWv49PrUT8pa02/6u/DzGhvNBWB8HeZ/lgd2SpQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66476007)(36756003)(2616005)(66556008)(107886003)(186003)(54906003)(5660300002)(6486002)(66574015)(66946007)(52116002)(38100700002)(7696005)(6916009)(2906002)(1076003)(4326008)(8936002)(316002)(8676002)(508600001)(86362001)(6666004)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: bOjIgo+kcj8mN2eb44nn/T+Va/JuGYHsbKuqSkjivS+1H7UGu2Ec8dSysb/rqbwnIT2eIJlNYdR7QWTp59vaxe5b7hAMae2Rk9MeWw2dFOxwwJR403ShpOf6wu7qZ8z8bEMYMrN3SuSwLViLMcYKL5XtChxoPg/bSy5kmEF6Gc3I4Szww7sGtuWX12BTgjY1GlKoGNpbZLZ8eKDlB05bHjUspBkovqu2FQx1dH9Q4NCUFMXOkSvl0uzNJHpP5K8o7llrV/awYwkVRF2vsE+OYFsy+rVmUlzJwsaU28verH9oxTODIRbwLmmPrr1gqtGO+fexOq8lCLTBZamE+pOSBD4Qu/D6GqabiKgYbH/9UO2lzFXt0UAn2kBLZv/Mz3gncbUVrXiZZyYRCz9NAOPeVDrWAEYHBNFa0SLfP1f3M6/9GhmIqEzecQKcSvqSajfRVv2kLSlnLHnKmUmcQ3086AQxC1oI6dQMZGJTBXvZGjYOPXXGuh/9vv9ywyCgWJ3BJl0FwlBu66MBD/KVjyZuGNuXCf6J2N1yy580VKWvQOtx5ht9drcl+vHGILTk8NIda1a7WwOLU9X1SR9cqoIgboQmDAWQGvEyEWQznzUh2pHsSV4V2R8UWcduqtsHVTLO4pmoQlX4YRHVZGiLdZd4BLDuM0+9xmirbntVa/Gh5vVJiY1W2T+4yAL2gCU4Gx2v3AYRYp4ssRsVSmbVbQioAEWiA80Wu5WfOO0gbosoES9ppjZFTYDupWG5xFTWugIOov694ERNFf0JhhYeivf5VoUEzQtUxO2Xeh2t9aZBfAYRpMQaHT8D0Q/U1SZrC/uT
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 126a7755-6629-483f-3587-08d97c516093
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2021 16:12:00.6719
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 49n6/yiGj0w3RLwsl6aQj5S2djNuXfw2n2wOjKnSc718zPBilQKt4Ms0rwdJ4aAI5jSX2U+aUH8xkSOuCgjf8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5002
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU2ln
bmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29t
PgotLS0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvS2NvbmZpZyAgfCAxMiArKysr
KysrKysrKwogZHJpdmVycy9uZXQvd2lyZWxlc3Mvc2lsYWJzL3dmeC9NYWtlZmlsZSB8IDI2ICsr
KysrKysrKysrKysrKysrKysrKysrKwogMiBmaWxlcyBjaGFuZ2VkLCAzOCBpbnNlcnRpb25zKCsp
CiBjcmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy9uZXQvd2lyZWxlc3Mvc2lsYWJzL3dmeC9LY29u
ZmlnCiBjcmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy9uZXQvd2lyZWxlc3Mvc2lsYWJzL3dmeC9N
YWtlZmlsZQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvS2Nv
bmZpZyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvS2NvbmZpZwpuZXcgZmlsZSBt
b2RlIDEwMDY0NAppbmRleCAwMDAwMDAwMDAwMDAuLjNiZTRiMWU3MzVlMQotLS0gL2Rldi9udWxs
CisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvS2NvbmZpZwpAQCAtMCwwICsx
LDEyIEBACitjb25maWcgV0ZYCisJdHJpc3RhdGUgIlNpbGljb24gTGFicyB3aXJlbGVzcyBjaGlw
cyBXRjIwMCBhbmQgZnVydGhlciIKKwlkZXBlbmRzIG9uIE1BQzgwMjExCisJZGVwZW5kcyBvbiBN
TUMgfHwgIU1NQyAjIGRvIG5vdCBhbGxvdyBXRlg9eSBpZiBNTUM9bQorCWRlcGVuZHMgb24gKFNQ
SSB8fCBNTUMpCisJaGVscAorCSAgVGhpcyBpcyBhIGRyaXZlciBmb3IgU2lsaWNvbnMgTGFicyBX
Rnh4eCBzZXJpZXMgKFdGMjAwIGFuZCBmdXJ0aGVyKQorCSAgY2hpcHNldHMuIFRoaXMgY2hpcCBj
YW4gYmUgZm91bmQgb24gU1BJIG9yIFNESU8gYnVzZXMuCisKKwkgIFNpbGFicyBkb2VzIG5vdCB1
c2UgYSByZWxpYWJsZSBTRElPIHZlbmRvciBJRC4gU28sIHRvIGF2b2lkIGNvbmZsaWN0cywKKwkg
IHRoZSBkcml2ZXIgd29uJ3QgcHJvYmUgdGhlIGRldmljZSBpZiBpdCBpcyBub3QgYWxzbyBkZWNs
YXJlZCBpbiB0aGUKKwkgIERldmljZSBUcmVlLgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2ly
ZWxlc3Mvc2lsYWJzL3dmeC9NYWtlZmlsZSBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93
ZngvTWFrZWZpbGUKbmV3IGZpbGUgbW9kZSAxMDA2NDQKaW5kZXggMDAwMDAwMDAwMDAwLi5mMzk5
OTYyYzg2MTkKLS0tIC9kZXYvbnVsbAorKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMv
d2Z4L01ha2VmaWxlCkBAIC0wLDAgKzEsMjYgQEAKKyMgU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6
IEdQTC0yLjAKKworIyBOZWNlc3NhcnkgZm9yIENSRUFURV9UUkFDRV9QT0lOVFMKK0NGTEFHU19k
ZWJ1Zy5vID0gLUkkKHNyYykKKword2Z4LXkgOj0gXAorCWJoLm8gXAorCWh3aW8ubyBcCisJZndp
by5vIFwKKwloaWZfdHhfbWliLm8gXAorCWhpZl90eC5vIFwKKwloaWZfcngubyBcCisJcXVldWUu
byBcCisJZGF0YV90eC5vIFwKKwlkYXRhX3J4Lm8gXAorCXNjYW4ubyBcCisJc3RhLm8gXAorCWtl
eS5vIFwKKwltYWluLm8gXAorCXN0YS5vIFwKKwlkZWJ1Zy5vCit3ZngtJChDT05GSUdfU1BJKSAr
PSBidXNfc3BpLm8KKyMgV2hlbiBDT05GSUdfTU1DID09IG0sIGFwcGVuZCB0byAnd2Z4LXknIChh
bmQgbm90IHRvICd3ZngtbScpCit3ZngtJChzdWJzdCBtLHksJChDT05GSUdfTU1DKSkgKz0gYnVz
X3NkaW8ubworCitvYmotJChDT05GSUdfV0ZYKSArPSB3ZngubwotLSAKMi4zMy4wCgo=
