Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC5D422942
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 15:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235881AbhJEN5w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 09:57:52 -0400
Received: from mail-dm3nam07on2066.outbound.protection.outlook.com ([40.107.95.66]:60512
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235306AbhJEN44 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 09:56:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UZEzwUpysi3znIcndF3qSsLU2HxmUPEHkE1PagIfnFCsXeTuc8BxCRb/V7e1pUd49FHfn8EQEklXhDEec9QxJbwK8ASA/wVhp6V7IzaWRSqkTn2gqDoBRmiRUPenPo10Pv6K6DIuxVoFgDZiYoC6yTnZcW2WBZUolboV7ts+iqSFE7/CjnujKvXWdNPowUKYJOSGQwiaA29X/kyZ98XBw+c2494bVem49R0M8eSUMZbri42Ya0moemJd3CjfAFUTKpRH+YWGDGrBxn1f9GFf65ZJzRaTfOF8pyngtvC0y166+Oj3BYK1875LysfFU6Ui4pLv9l/30zgQ/IpF8qoR8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LNjFHnj7/iedQ+w5rqTk4AU6AQWwlFSosoP8VtyHfp8=;
 b=WMwQ/mV73zDXQ+BnM/WwUTB4HxP3D/hrXrTvVNi2Cukwj7FyfEIJWDaRreMzK+2bPewowu/G6ii2gnnICWQD2yIhFMWT9/8rL95F++eP3k3tq5itpPjoYhZyZU2PZHxtS/Y5H8fPnW4LgDn4G6xUwaSOQyeG16GLkoXnPiS6lJgc9iDUD9dIVv0+khdkYqU1yzA6aPQWtkoQmBMlEcCE1NOfQHEj9c5NpD8x2hT8edSIRLPCeszysOG4ZTuejWrGttqnjZovXP7PCHhao0WOEqsR1XU9XUPMboewqD82aYia03/uH56dmLbQSuxmwBeZzmu0oCzQ52kVRZ1UY/X9rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LNjFHnj7/iedQ+w5rqTk4AU6AQWwlFSosoP8VtyHfp8=;
 b=qJ2TBXW0qqmXZoJkqyfiHXbAdRcz50LgSlwiyDaLE7pPmvCFbSle7Os4Jwc3v8v1WOTWaFzW7QsG5lpG+RUD8ddEGCA8x4I6q12fM4T7tlvrkPDIg1OmHL5Kd8EQDDZOA5dyuGj4Z6LCKob9OMG5RUJeZS+UgTffM+3N0EdBhGs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by PH0PR11MB5643.namprd11.prod.outlook.com (2603:10b6:510:d5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Tue, 5 Oct
 2021 13:54:28 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::31cb:3b13:b0e8:d8f4]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::31cb:3b13:b0e8:d8f4%9]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 13:54:28 +0000
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
Subject: [PATCH v8 03/24] wfx: add Makefile/Kconfig
Date:   Tue,  5 Oct 2021 15:53:39 +0200
Message-Id: <20211005135400.788058-4-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211005135400.788058-1-Jerome.Pouiller@silabs.com>
References: <20211005135400.788058-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR3P189CA0084.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:b4::29) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PR3P189CA0084.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:b4::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Tue, 5 Oct 2021 13:54:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 521e59b0-65a9-45f1-79d8-08d98807a5fa
X-MS-TrafficTypeDiagnostic: PH0PR11MB5643:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR11MB56430F5C9342A06C9C128ED893AF9@PH0PR11MB5643.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ngSit5vvNvStPJF7ATz0/3mBnsGinXM7kzxwl/X2BoY8w3Tk344drOEofSPU7s2b4rjF41g8IxE7TRO5YXta7BhhcwLH79+mVX0RBTZKIAGktVGEdn5X5lBbyEdy/U08E+qhDy1gtZspEpj6vp99TToiQSsiw2cdIHcx5e5OXu5yyi6kM+BNagr/j3xoumXyQRsZkd0VL7u9ARLbDpbmCYKaSiKhmVTW7hNX7SK+p6QGwbSxQAyCcNMhx0aAkkOpKnB6mXvVoMwb657lRVTgMAQQ8ff051g2WTgqL2myvLSCUEfZ/8epEPYNG0NYjcG52Y98r3Aphckx8OFGb7Jp1huumKQYrBd+aXpFo60eYDbH80PE1AE925Flko3/eBSJutXUffq5InKStXKHKOzazRvvJRgLr4GXHoEg8FkMRwnIV1X44B+KY7EFIHbpUNizgDmkpvPV81G2yRVA2ErCtkXh0vU84b0jbboRvsapAho8o5mRe6w00EEYpvz6dnkBZ9u3XrUNl5U/Ebd7K++ZolZbBZw2Tykxby8wiC3iNzqYWgzAzFuULr2h2jdg24GM+8tGcPvW9DjuROlWk61MLguFN95Cw9nbtmmEgYdanfz/kEebMsxRzLmAUrQcDDUFTaLYYa4FhtSK0gCpOn0+mZuNME8+/a9e9+S880Q4WEcLfPqniEtFUJWvDTCZ+ISZwp6dyu+Hs8XzmSvNAgGpZQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(7416002)(2616005)(956004)(54906003)(8936002)(66574015)(36756003)(1076003)(186003)(38100700002)(86362001)(6486002)(6916009)(5660300002)(38350700002)(66946007)(66476007)(66556008)(52116002)(7696005)(508600001)(6666004)(2906002)(316002)(4326008)(26005)(107886003)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UFJLQWU5SUhnaHo0Nnpodm9lblRBU3E4MXdRK3JMNU05aXlRUXVoWis5UGZo?=
 =?utf-8?B?NTdRcGN2Q0xVeEh3Rks2aWgwNTNNVENvNDh5a3kwd3UveGs1OHRRSFRIb3BO?=
 =?utf-8?B?ZzFRelZxSTlQcjh4bTVxWWJDRjdIV2tUOTh0U1Vtd09EY2Y1ZE1zOG9TS3dv?=
 =?utf-8?B?aWlOY01RZjQ5NXYzY09jcVBXTm1SZStrRDlGM0RsVHFoVEZTNTlubGhEVERs?=
 =?utf-8?B?WitVeFQrWjJVOFBQdU1lVVRQMzNUVC9aakRpNmxjUlBMZ09aV0U0bHQxWkNF?=
 =?utf-8?B?UHN3aVJnaXF3QjBrSDg4UUFwNTllVG9WUWt0Q24xM3VyT0FKMzIwNWtZOEIx?=
 =?utf-8?B?b2xreUNiaFBjNWZaa2tONW5JcFZHMFRsZXRpLzU2ZHFwdjNIaEZNcXZGbzcy?=
 =?utf-8?B?REtOM25nQjBXbEVCUE13ZXVSbTYwaWxGMmt3dGNwdWxjR0JndHNBVmlvU21J?=
 =?utf-8?B?a2hJNzR1dXYwL0ZkSUUxMlRoNGJXRmRHZG9qYVJxdzZvTzRwRXlhYlN6TENj?=
 =?utf-8?B?MEFUeGJTa05qMFcxV2FoM3NXUWVuMVgwdHQyTmRuMnlLZ01uYmVRaGRTWUF3?=
 =?utf-8?B?VWI1SnMyZlBwYUVqdzEyRHF3a0lhYjUrYzM4ME5tejhKUlNwL3ptbzh1TUJj?=
 =?utf-8?B?NTFiRjAxTUZRWkpaRERsbjNGU25GdzBJVWpSMGxLRk1hbWVka3I0TWZMRWxO?=
 =?utf-8?B?bzFnTXhLMEtBMVcvK0FRSkpkbFE4amF3RHgzY3RITkNXR3FrSU5BaEQxTlZH?=
 =?utf-8?B?UXNUby9mME5xSGxIZFdRSW11VWVTdHdMbVJWQkdPRjl3YW5Zak9XK0pGYURW?=
 =?utf-8?B?cExlejRCV0F5dGVGWGMyaXdqM216YlVoVFFQWXhudytxSDFwNkgwV1A1cVE2?=
 =?utf-8?B?Y2lTVW5hTHhuNnhXa1BjQzY3ekJlWFFKOUd6OUNrY0N3UE9oVHJlMW9BcHJj?=
 =?utf-8?B?R09lS0JhUjV6N0hUWmROVERVNjFLZmdnRzUxdStEMU5HSGRYQS8wMGZTa2kx?=
 =?utf-8?B?eDZwN24zYnIremJOL1ZDd2hyOHAzREJSZkFpSjI0dXFHNERBYXVsblVZTTBH?=
 =?utf-8?B?VHlXNWFaZDVjb2ozNkJ2Q0trd2xjajZHZW5NemRmMFFkSFF6M1M0cWlvdEsy?=
 =?utf-8?B?N3R0cm15ZzVqb253cmorOTNKQTlGdjJZNmcvMEg0WVRJM3hvdkVhTFpubXFq?=
 =?utf-8?B?eURJYitMWnJtQStMQk5oeEJGbmJJZ1drTHRJb2VzVitpaHVFanNYelovTHZn?=
 =?utf-8?B?WmdNZjZ1NkRlZXMzY2F3R3Y5K2M1QjEzUE9tRmZqalY1TlpvbUVLUitzU20w?=
 =?utf-8?B?a1JJYWN5TUNQYkY5OVEzSlNTZE9YLzFGRDVReDArcGhRZjlURUtYeGlZbHB6?=
 =?utf-8?B?NCtlVmxsM1pFcStaRnMyamVsTy94V24yS1FlLzZkQ2xVTTFMems4SjZMOSt2?=
 =?utf-8?B?eENVQVMydG9wSi9xbVRrem1pQnlpKzZNOWNta2NuZUVxR1c1K1hOM3ZZOTZv?=
 =?utf-8?B?bTI2V2x3cHBsMCtpTnhwQm9UNnVtOUpTT1oyZ3ptcDFKdWw0T3RwcWI5RkNS?=
 =?utf-8?B?VGxMWFRMOHNkOTB3RXBkUVlidUhOUzJidm9tdFNoazdjS3EycWVVeHc0Rkw3?=
 =?utf-8?B?QzdWQXQ4MlVJZkc0UXZmTWV2RHVTRlNKN3c1MFZ1U2lQR1dXc0Zsekg2VWhj?=
 =?utf-8?B?elA0VmduK2FvT2NsYStYRzUzSk1MNlE3NVJDdWt2WFNuMmt0MXJIczl2YXFE?=
 =?utf-8?Q?b4GFYWhGsgsp4enuYS4tZf9stBrpgmlpaOU8SX1?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 521e59b0-65a9-45f1-79d8-08d98807a5fa
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 13:54:28.1664
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zHPdIjihHU4WfrGHZfURV7cuPS+ZpanT0bv56PV2yFjz3iuB8klG2+lxqzdMMs9JVK4jQLbDvkuYVjhxvNv8KA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5643
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU2ln
bmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29t
PgotLS0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvS2NvbmZpZyAgfCAxMyArKysr
KysrKysrKysKIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvTWFrZWZpbGUgfCAyNiAr
KysrKysrKysrKysrKysrKysrKysrKysKIDIgZmlsZXMgY2hhbmdlZCwgMzkgaW5zZXJ0aW9ucygr
KQogY3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvS2Nv
bmZpZwogY3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93Zngv
TWFrZWZpbGUKCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvd2Z4L0tj
b25maWcgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvd2Z4L0tjb25maWcKbmV3IGZpbGUg
bW9kZSAxMDA2NDQKaW5kZXggMDAwMDAwMDAwMDAwLi44MzVhODU1NDA5ZDgKLS0tIC9kZXYvbnVs
bAorKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvd2Z4L0tjb25maWcKQEAgLTAsMCAr
MSwxMyBAQAorIyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMC1vbmx5Citjb25maWcg
V0ZYCisJdHJpc3RhdGUgIlNpbGljb24gTGFicyB3aXJlbGVzcyBjaGlwcyBXRjIwMCBhbmQgZnVy
dGhlciIKKwlkZXBlbmRzIG9uIE1BQzgwMjExCisJZGVwZW5kcyBvbiBNTUMgfHwgIU1NQyAjIGRv
IG5vdCBhbGxvdyBXRlg9eSBpZiBNTUM9bQorCWRlcGVuZHMgb24gKFNQSSB8fCBNTUMpCisJaGVs
cAorCSAgVGhpcyBpcyBhIGRyaXZlciBmb3IgU2lsaWNvbnMgTGFicyBXRnh4eCBzZXJpZXMgKFdG
MjAwIGFuZCBmdXJ0aGVyKQorCSAgY2hpcHNldHMuIFRoaXMgY2hpcCBjYW4gYmUgZm91bmQgb24g
U1BJIG9yIFNESU8gYnVzZXMuCisKKwkgIFNpbGFicyBkb2VzIG5vdCB1c2UgYSByZWxpYWJsZSBT
RElPIHZlbmRvciBJRC4gU28sIHRvIGF2b2lkIGNvbmZsaWN0cywKKwkgIHRoZSBkcml2ZXIgd29u
J3QgcHJvYmUgdGhlIGRldmljZSBpZiBpdCBpcyBub3QgYWxzbyBkZWNsYXJlZCBpbiB0aGUKKwkg
IERldmljZSBUcmVlLgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3Mvc2lsYWJzL3dm
eC9NYWtlZmlsZSBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvTWFrZWZpbGUKbmV3
IGZpbGUgbW9kZSAxMDA2NDQKaW5kZXggMDAwMDAwMDAwMDAwLi5hZTk0YzY1NTJkNzcKLS0tIC9k
ZXYvbnVsbAorKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvd2Z4L01ha2VmaWxlCkBA
IC0wLDAgKzEsMjYgQEAKKyMgU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjAtb25seQor
CisjIE5lY2Vzc2FyeSBmb3IgQ1JFQVRFX1RSQUNFX1BPSU5UUworQ0ZMQUdTX2RlYnVnLm8gPSAt
SSQoc3JjKQorCit3ZngteSA6PSBcCisJYmgubyBcCisJaHdpby5vIFwKKwlmd2lvLm8gXAorCWhp
Zl90eF9taWIubyBcCisJaGlmX3R4Lm8gXAorCWhpZl9yeC5vIFwKKwlxdWV1ZS5vIFwKKwlkYXRh
X3R4Lm8gXAorCWRhdGFfcngubyBcCisJc2Nhbi5vIFwKKwlzdGEubyBcCisJa2V5Lm8gXAorCW1h
aW4ubyBcCisJc3RhLm8gXAorCWRlYnVnLm8KK3dmeC0kKENPTkZJR19TUEkpICs9IGJ1c19zcGku
bworIyBXaGVuIENPTkZJR19NTUMgPT0gbSwgYXBwZW5kIHRvICd3ZngteScgKGFuZCBub3QgdG8g
J3dmeC1tJykKK3dmeC0kKHN1YnN0IG0seSwkKENPTkZJR19NTUMpKSArPSBidXNfc2Rpby5vCisK
K29iai0kKENPTkZJR19XRlgpICs9IHdmeC5vCi0tIAoyLjMzLjAKCg==
