Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9E2633B3E1
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 14:26:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbhCONZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 09:25:43 -0400
Received: from mail-eopbgr700053.outbound.protection.outlook.com ([40.107.70.53]:6432
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229734AbhCONZb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 09:25:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wqq5vQNDWwz8MDLD1KQBo6GvHxhIlyqdge10vqqjA40IV90Ltw6OK7KeTS7U1NWhW2rz9UEK33o1Fxpv6VhbSN//KkO+/585J0GykiTXaQYuJvEAlrdHtqo231p2Du7iwoMsP30GicM7yi5k/D/l1fN0AioTR2ekl9APZu6oREpBKqjSpzaGX89CtRNZuBFkbOga1dzQmmGmPnpXphyhObYOY1mn++XJMrNqqQ3xiTdLXliMDxxkLS2FWLTHDeGcZ4wwfGVyWv0g1XUNP/etccPEc5WKcKEHdkQAJP7r5aLPL1IQLsIXqufr52XI7unxzMOqVjvxuJzKW3ONfTbpYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8OQFrQkSEbB0f/oOBiSAUF6puJvb1qAefZXuBDO6sJY=;
 b=Izy/6kseI/XzGZWuoj8Uufy9gCAYdn2QQtCoLV0djof0eSDznK/PMCtC70lXOh4qL22Xr2ghttCWEBRJSpOIkBbRNUwDXUy8dulbhuAQv1plbbUjgdnLA5avpauHyRPdFqH49LVLpsg+rJtQ99rhqGaXDgPbhhmcib7TxFmVPECoht2S/IE9F2SYNBnHIPBRlZtt4/4IIpGcC1TWnqcExpyeYJbIg5xy0fpA81TUaxLEzAszW43sqWv4QjQRcv2JqjzJBTp9tdeUou5lxgYPVTD+XPqcVi8KnXHueYT6fecCIIoAcZ50OB1ANYiodkPw73fdpcJ18OGHkW25KvreXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8OQFrQkSEbB0f/oOBiSAUF6puJvb1qAefZXuBDO6sJY=;
 b=fFuqp3i4rUf2Cfu5Np32+aSDBBfCPPWnGU8xZ/1M9JE1FnI8K0M6aT/8l1F9TrYSxg+o4Mj0lcBfyCVPY5laj4IWuns3s9qXQrJjX7huLiluHH08/A4LJLCRHgqxAsJi1kFA68Lf6nSog5hkFnId0Hj/1dlb2ZqB98V4mf9Rh/g=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA2PR11MB5099.namprd11.prod.outlook.com (2603:10b6:806:f9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Mon, 15 Mar
 2021 13:25:30 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::41bc:5ce:dfa0:9701]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::41bc:5ce:dfa0:9701%7]) with mapi id 15.20.3933.032; Mon, 15 Mar 2021
 13:25:30 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v5 03/24] wfx: add Makefile/Kconfig
Date:   Mon, 15 Mar 2021 14:24:40 +0100
Message-Id: <20210315132501.441681-4-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315132501.441681-1-Jerome.Pouiller@silabs.com>
References: <20210315132501.441681-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-ClientProxiedBy: SN4PR0801CA0014.namprd08.prod.outlook.com
 (2603:10b6:803:29::24) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by SN4PR0801CA0014.namprd08.prod.outlook.com (2603:10b6:803:29::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32 via Frontend Transport; Mon, 15 Mar 2021 13:25:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 823159a6-679c-4a4c-7851-08d8e7b5cdc6
X-MS-TrafficTypeDiagnostic: SA2PR11MB5099:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR11MB5099823780F77F3FCD34EB26936C9@SA2PR11MB5099.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RP9K1XLPnI/c3qn6lbDat5xxwT3pjsq7tgJKkF8h531piGfZnxrwXppdCW8+/AaFNLYRv+dWEbNfcVU6x7U7Ssvxh0NM5gbv5HOk+tYaqngIle0Ikl8FEsUvkFV8jAdvMF/PKuPMJobGgqKvyaGh7gQepxqmk0SkLEkY78KRuFrb4CIAhditLO5Lr4FgKR9EegtH2dIcbkAGcRZaiEgTfy3GXhmzNnN3NlPKbK3cYETWCzkm8UEPtjUnmwf31eRk/zBfT4vwkiJjIe4uZZM67o3QhGY8jRZHZa12AvVgnHaOZbRXfix1QuHcznc5cPhcN1Wgdc2A/PQ/v6PBXVtog0TURb/3HurzoF6Nj1QDPzEH5KBSu1dL6Ws9Kg6NiPfWw2LrvX7eufo+AA2DY6xd5C/fD/g2RWkrBASTVwqsMpFetVumM6iUE8J5em6cSOPrpniADRMDw+Yn8FRsEmAU0FK6Cr5p8YFPLag/9pZFpJ22+/4SECNR3+/cDQ3+/qDcuDR6xZFg2ZK6qZWWu95IbgSKlg3lFj1rb4M+a5izu1S11yyJ3FyNwMpdBNV+6YHq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(396003)(39850400004)(376002)(366004)(186003)(7416002)(2616005)(107886003)(4326008)(478600001)(16526019)(66476007)(86362001)(66946007)(54906003)(66556008)(8936002)(316002)(5660300002)(66574015)(8676002)(1076003)(52116002)(7696005)(6666004)(36756003)(2906002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZGsxSU00QXQ4QWQ4Si9NYmNhL3U4ZVI2ckxWQ3JwZEN4a0hPZXRoVGtQMEJI?=
 =?utf-8?B?bjIraUIrWFU4Q0QrWHlCcmxRT2p3ZjFUTGgrT1Z5dVRyQU5hTEdDQ1lXR1Ny?=
 =?utf-8?B?blZ5bk5uakprc2l6UVhrdHZCVngxV1k5TzFCWkEzdkpja0Z6U3Q1alVsUldO?=
 =?utf-8?B?dkw0YlN4dEtxMDh3cXo2aW9wMmpHVHBrRlVxTjNVdFVuUS82SFR1UUFxTFNK?=
 =?utf-8?B?REYrUzJBTjFCangrSG1VakRDOTBGV3oySGc1MzM5eTBGWTF5YXlaN1pwY1dn?=
 =?utf-8?B?ZjZLRk84Vy90WmwwWENSUjBaN2RaVDRLcGtJYmgxblpVSVh5Y29BMC9tRXVZ?=
 =?utf-8?B?d0FzVHhGdEo3eUdjVjUxdFZrU2Y1TmFoU2FGN01RenVqTlBFVGQ5SGZiWWFu?=
 =?utf-8?B?eUVVTzI0NGxSbmVXMDJjejhCU2R3NXYvSXNhWFFuelFBdU5kQndmcTc5WmN3?=
 =?utf-8?B?anJhWSs4blpxODFOUktlY3pRd1hhamdwaVFNenFMUHA2NnFtNGVOZ1IwdXdX?=
 =?utf-8?B?Z1R1WDJ1RERQRWdHT0s4ZklZN0M0Y05iN1ZNdnQrWkhyMCs2UFpqTDJ0UVo0?=
 =?utf-8?B?QUZCRFpMRmZqeXBTL2dJRnRPbEp4ZkdGdWMxK0VhS2paUVJPWTJsckdSMkJl?=
 =?utf-8?B?enlJa0MzelpsZTVvZ3cybEtQMUhuelk2alVUelRJc09kN0J3aWlXQ2o2QUlx?=
 =?utf-8?B?Z1lCUDNwZEV3aGp3b2c1NXUySHNuN3lnZHBmSkxkRHZycFQrZHBJQkhlbXJ3?=
 =?utf-8?B?VTQyb1dOdzBzNjlHTU5taVlVQXJ5WjFJaC9pQWIzeEUyRlhNTG53YzhmWTVY?=
 =?utf-8?B?TlE0eTFQaTE1UjNZNGtYNE11bHZGVFNWYVU2bkM3bkp3QmNCU09obDhQN21x?=
 =?utf-8?B?NGhUR1hqYzBnY1cvTzE1TTYvQ3R0ZC9mTzNKV0dIOGdQaTFNYmpVSlNtMTVF?=
 =?utf-8?B?VVlTSG5pRWZvUjBBc2kzMlMwTitXUUd5RGdmT0hNNkl1S0xwL3NqM09RamlE?=
 =?utf-8?B?bnJLK2R0N29Ic1VmMkJNa2s1d0ttYmp4YkZNd0ljZHczSWtYVmFnZi9RTzF0?=
 =?utf-8?B?WnU4UThiaXVGbEhFVXBaNHd2dllRVzlpV3VpTGJjM0syc1poNFVUMFlsbDZp?=
 =?utf-8?B?dUNUQjA2OU5IRTJZYWsyZ3BMakRVWHg1Zjhadm1wcmFxUG5WQUpoaGZrVXhq?=
 =?utf-8?B?c2doNElVRkpDcXV3cnZ4ZHMrM2VtNXk2d0o1UjZkU2NpYnRUVGxtNDlYVXFr?=
 =?utf-8?B?S1JheWd6NnBDNkJteTQxOTJ1bnNVb1dLalIyOGZLakEwdDl5YU9oMDEwckl6?=
 =?utf-8?B?bXpBK1U3ZGdqUkk5WUViU3ZwbklXZUNwcGUwajRwd1VBMi9WdmxQTXVKa09w?=
 =?utf-8?B?cUt5Z01KMHdhTTkvTWJod1hUWUNsR2xyUDZ3NkNCSy9sNVhyWk9jbGxCekVV?=
 =?utf-8?B?L0RtVEk5Z1ZDZUxLT2lheGEyTC9rZVdaNlM0dGFncnlOUTNXMEVkaEI2NDAx?=
 =?utf-8?B?dERGdVJwZTFnOXhxK0tJbEZPWThQWWptVkVIcWJFZFM2UFM4d3pENEM5bEZy?=
 =?utf-8?B?cEpkQ2FyZmxLQlEyODMrRTl2U2lzY0xiUFltZWFvV2pIZHpySy9YNXkxakVa?=
 =?utf-8?B?WG9rRnp3TGl2T05hSGR6bjdTL1VlcXpPSUtmSmpuN2ZvbmU3VjRGQ0R1ano2?=
 =?utf-8?B?MlhmUjFtaWQ3UlBsQnVvejg0VnJjODVyWW1HVERqWFg1cXNlR2lsaXBhZWNs?=
 =?utf-8?B?d2llSUdkaWlJdEdyZXJJa3ZMcHNSazEwSk05VUxXVy9XK0RHQThmZmNRbFFB?=
 =?utf-8?B?UmFjdmsyT05PSzBGYXlwOElhdEFscm5UMGgrTjVnUDJQaXVacUZBZWUzbkhH?=
 =?utf-8?Q?HwLFdFTWp1dw+?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 823159a6-679c-4a4c-7851-08d8e7b5cdc6
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2021 13:25:30.2726
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IGnh/pwvhnuYVtrb4TNuPeBQ5EIGy98UWiskI4bXvxgNkIrGTdkFhuQcO+FjmBpTes8/uU2d0BXw+jzqadQ0iQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5099
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
X3NkaW8ubworCitvYmotJChDT05GSUdfV0ZYKSArPSB3ZngubwotLSAKMi4zMC4yCgo=
