Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE2B848D49F
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 10:49:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbiAMI77 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 03:59:59 -0500
Received: from mail-dm6nam11on2047.outbound.protection.outlook.com ([40.107.223.47]:10080
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231576AbiAMI6l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jan 2022 03:58:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HvJOz/IvskuhSKI5wiP3W84rWUYTEuBXWqjV0rlq+b0fuO+LwmcXBVIETMoa89UVsXD1Lq4slt3JIgeyGjaXbHh83+x22oKj0B7IF9/6zxLZlPJya4N5s8crMB7yh5a0qtnPY7OrjGpOYfnHi1bkq0p7FF3A7ucElDVNNrYi0kYUE5oHa3TIjMOWOVqOcWvZC921rhAlAASNaK2RjiRQP+PIW+cFQk77+/NRS8t5Y1gZf+qGP3Cup7vcFf0M5hxVFTTM/K9QgVS+q/fvoLEkWdrbf4MTYmPwwsvHiERBJoShxUUbDObnl/heCCViTc9rRqF5koP1zK7Fw8ja7ABqnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fga0Vvkv5TIpQBCpG1FdA+lj1LRtkHc3USzK+Erj9MM=;
 b=JNll201+HiMtb2Qjb7xFvpKKDPQ98igKBCtFpd+IGQQVpHH1iFGjp/oXsHrr496QJQCAxtCqx6vA+E/dawBoJMo4gw9rkIR7SIWEWXzxWXfwk8CICPFDnYYvr8buIDXuA+MzsrYG5UsvDES9s77BYCCLIzkqLbQgEs8alIaI11GmmsgSz0pf2Ar/K52PFG4SxfHTz98kjAWSFOxXuSIgN6NztrBnlvOEm2X1rze4FgeCCeT+Qruv7u+HAVW/COBr07nlcYeiyLurW+ESes22pXHdFzAg153Kyd2KmSH/RkV3/1jkFTaENm7MyjtcaIBjxNJH8XaKp1h7yxvlUKLJjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fga0Vvkv5TIpQBCpG1FdA+lj1LRtkHc3USzK+Erj9MM=;
 b=j8yP5Nbt5JtRqE7mxarj2ZbZacRIUpSvj9JJBYGGGM635YZNkuJ69lgsaISgDIVIXg46QIsyFdtqiYQsYXpramG++SlPJJoNdmSaVlpumC0KcmnO9ZNoiDcNEyS2mKCC9+UFzeplotzW/WIBPH31gAkeTipiTY+VvhXgnnEyUFY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by CY4PR1101MB2071.namprd11.prod.outlook.com (2603:10b6:910:1a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Thu, 13 Jan
 2022 08:56:40 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4%5]) with mapi id 15.20.4888.011; Thu, 13 Jan 2022
 08:56:40 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 31/31] staging: wfx: do not probe the device if not in the DT
Date:   Thu, 13 Jan 2022 09:55:24 +0100
Message-Id: <20220113085524.1110708-32-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220113085524.1110708-1-Jerome.Pouiller@silabs.com>
References: <20220113085524.1110708-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SA0PR11CA0117.namprd11.prod.outlook.com
 (2603:10b6:806:d1::32) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fb830ddc-7db8-4aab-9199-08d9d6729d51
X-MS-TrafficTypeDiagnostic: CY4PR1101MB2071:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1101MB20710A3307DE446C3BC8A1BB93539@CY4PR1101MB2071.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Oa86KHzRHUVMd5vYf3eJ7UNN0LIGlnJZu1dmJBl0RBu6Q6lBYXXXRhTXn396UjIIu9Txol823vA9mv4QXHkkGtbf6ZXnI3Vrd2Kq5v71AOfQ8XCHNqN/2IXNRRFszMxOBxaCR6IcecFGj44VwQP2eMsJMER7hwK/dKYRx39SwDtR7zxQKl9BsZcRJQEJb6Q+2LB3kqY/BGkEi8OMFcE0n2/zJGWhrfv/on25fEYFGiDSs2TeJOHLL2WgYrCs3l1OO/NVbKOZJYZFe55TZjQ12UCORyqMjNNuCM00W4VGymeqxvaqCx4ONx77H94WefDekIG2wTU7dE8SQZiF0/VFcxmdX4w5fVRAA4HroSRGruarJ5402LfczB6jLVHHuV5ucnW4pOJHaz+wPwd0hRegKF/LU/lWeCoOYOwXwDzU38JAurBN10a98X4rE2iVoOBRZ/4Ti2LNZEBYie7vBRajDgNb2QWm4t9l/Zt556Rz5Crc4lHJjFU4LjHzxyjVV7PEyNTVZ51gyMxfUMqqqMgkN44Lm3YiMZetAH6H8Z7rGmgqz9OzbOwnfKe0VRIL4K8cf9UU2xv+uHFKwN15I7U3dfrxbfsEzRDWFsOAHPjiQYrFi2vXE+MKldcKVjcNP+8WeLJV7T0oum5pu7cS6zndZQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(66476007)(52116002)(8676002)(6486002)(4326008)(66574015)(38100700002)(8936002)(83380400001)(6506007)(107886003)(66556008)(6666004)(36756003)(508600001)(2906002)(5660300002)(6512007)(1076003)(86362001)(186003)(316002)(66946007)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UzF3dHMvZGhLV3lXaXBQM0x4bWEyWktVSEgxOWZkQk9VTlZYdVE2UjZTamE2?=
 =?utf-8?B?UEgxWEhiUWxWa3o2WEJHWnNQKzJCL2JvSXUzOXk4M0Q4WnhXQThGODVndmhW?=
 =?utf-8?B?aTRpYzhjYXlXN1ZJSENDSVEzOXBvTysvTHowc1Q0aEN0WXZqMm5RU3FRNkk3?=
 =?utf-8?B?TVo5cFR1VVpIRG4xU2c4L3hVazF3TlkxaVNvSTFTZkh6VDJaUzUyK1YrUFg1?=
 =?utf-8?B?MThsbWFOTGl0NkN2U3oyNWRuSFRRd1pxM3VyRGlnN00yZkVmWHF6R2xiMDlr?=
 =?utf-8?B?Z0ZJWVJPU3A0M2FQdERWYXB5Qm9jRlhnR0lUa1p1TTBmNFVuNlpaMzdyVUpm?=
 =?utf-8?B?ZzBrOFdRNFZVV3dTWUk2T2R4c3I4M01BNWk4Y3gvcTcvOHRxeThoSW02NWtq?=
 =?utf-8?B?aFB4U2JHQWthdFpnYzZpc2VBazRBc3p3NVY4TUIwOVpsSlU5aWpuSVFqKzhq?=
 =?utf-8?B?VUFRNFlJS20zK3cycjRvUU5PYWJ5bFhJanFlQ0dHQ2xXUG9OVDFoUmtTUTUz?=
 =?utf-8?B?aUliQVJuc2wwU0lVSnNPUTh1d3o4T1IwVFlFRFFMaUlhdXJkeW55Mm00V3FB?=
 =?utf-8?B?SHRzQXRWTVEvdjVPcHZaY0RrUTk1by9hZjd4U2ZVRW1yejJGdGplT0U3NWh3?=
 =?utf-8?B?VkpUY1B5bUtjU24xRHVWTlZRVWpIRDdwV29iTkgvYU1FMHpRa01ick9JbGRl?=
 =?utf-8?B?eUVUZHFqVVFwLzVSSWFGQ1pqQ0NJemRUNUlaRUljOGhtMnFXR0lnZzdGMytt?=
 =?utf-8?B?RUc4eHltMkJhZzV6R2xSSlF0UWFGZEZjUHFvTzV4Rkp2QW9UNkxabEVhcEpj?=
 =?utf-8?B?RWQ1b2dRWlVjeERnZzhkbVF5Q0tEOEIrTTVmU05MZDRtd1BSNGczZmRHcmh6?=
 =?utf-8?B?Z2VuU29TdjFYdXRxNFovTkY5bkJuemF5eU5DM3V5TkREa3NndXgrVWc4eDc4?=
 =?utf-8?B?Qkk5bnFubWRJSkFpN3J5U3ZTRG50M0o4QmdaM2xEcWh2ZnI1ZDFKWkFCdHBG?=
 =?utf-8?B?MzZCUGZnRVJDMk1TVFhvRlJiMmZqaFd5c3BjRzN6enJIRDZGOWtLYVdkYklt?=
 =?utf-8?B?anhVRHVPeEZCdVJxQ005RzFBcVUyemQ3elF2ZDJYYkhQbU0yOXVVMUtPTW80?=
 =?utf-8?B?VHU5bHpBMm15TnpjejI3dGQvQm41RmJ1eC8wNXNEdkZxTFlpdy9XcTh2em5I?=
 =?utf-8?B?VmpMc3RrWFRMQWh6QnRaOTdHQjVaWW1DUkR4bDh2ZVBVQkJjRDR1MDhLVUNs?=
 =?utf-8?B?Q25mZUU1RE1JSlBzaU9sd0F6c25wdlk0bmdwRE94MDFaT0xoTGJ5WitXR3h1?=
 =?utf-8?B?R1A5R1k2eTFWV1hJdkRpdy93dzNRWm1nalRXQXhtMXcrNjVIblBRYjBJMmpJ?=
 =?utf-8?B?YStvd090SlVpL2t1TFV6b052bVVHYkFzQlFpeEpPbmQxVjV5TnhUZUxKQjY3?=
 =?utf-8?B?dHhlMUZFUkZrb0J1N1VpNjlUWVJIN0dEdnVKeHlJTmV4ZjhwdmYxT1dlRGQy?=
 =?utf-8?B?ZkhOcEcwd3RNeXVGMURjT2s4QUh4VU9adDBxUmxJRnhrYmx3Z3hTZWJCbEhO?=
 =?utf-8?B?OHdzTno5K1dtdWQwc3dIY2VBNEZQWm9pL3I3aE43MWZyNjQvVzZXTHJ0K3pE?=
 =?utf-8?B?Z1RJQ0YxQ2Ixcjk3V01TanBUa0RXRWdGL2JsVXROckxvL1JxR1B1S251bVhv?=
 =?utf-8?B?U1BUTzNoRklIbjIwRFN2dEMxR2puT2dCQmlJZm1tcUo4MUExbGdVMldzaW9X?=
 =?utf-8?B?OEhSeEVyNGRJVm5FSkptUHBOaG9oOWFvZ0NETjhHUHVZZU0xVVpiSU91N01B?=
 =?utf-8?B?TXhGcnlSVHFyYStGSGNUWkVXdEV2a1l1TU82NmpGcUpOM0pXRWpSelYxWkVZ?=
 =?utf-8?B?bTNiRUFUSkxJUlE1OVpxQXpkcWNkNGZrQ1hIdFQrSFphd1g3QVptT0pzcTF6?=
 =?utf-8?B?MHZkT01mbm5pbktUTUF3ekV0cDYvKzNkSjFvUHB6cEdoR25HWFJBdjFPd0Vr?=
 =?utf-8?B?VFFSZ3ZRaWVqMU9ZNnJGWTI4dXZ0cm4wVW9mbVVhWHAycnNlSlhsYW1DRjJP?=
 =?utf-8?B?N3hOajhLUElIY0x0YzljUWY1NWFVVlJlNEhpQ0kvSmRhcUZIaXZuMDlpVmc2?=
 =?utf-8?B?SDhtcElTT1RqcmV3eWJ3QUI4cVcvSjRSQkxVZkJGaVlTQkFaZGlKdTRnZWc3?=
 =?utf-8?B?TjNSVEFTVlBaMjQ2Y0Z0WXFOWnNzdzJ1U2o5WnJ0R3VmS0haSHhWT0dubXN0?=
 =?utf-8?Q?5l8IyJryKR8mACVg/5ondzP0a+59g+4IFmIw2Sxld4=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb830ddc-7db8-4aab-9199-08d9d6729d51
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2022 08:56:40.5651
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YmouS+2Rnsvloi6cmM6nnmNo4/2VlYItyjuJqE7lsWReGHHiRQyGzz+MrVd0N9aySwh7vNQUkJoJEqhPcZdLVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2071
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU2lu
Y2UgdGhlIFdGMjAwIFZJRC9QSUQgYXJlIG5vdCByZWxpYWJsZSwgaXQncyByZWNvbW1lbmRlZCB0
byBkZWNsYXJlIGl0CmluIHRoZSBEVC4gVW50aWwgbm93LCBpZiB0aGUgZGV2aWNlIHdhcyBub3Qg
ZGVjbGFyZWQsIHRoZSBkcml2ZXIganVzdApwcmludGVkIGEgd2FybmluZyBhbmQgY29udGludWUu
IEJ1dCwgdGhlIHJpc2sgb2YgYSBjb2xsaXNpb24gaXMgdG9vCmhpZ2gsIHRoZSBkcml2ZXIgbm93
IHJldHVybnMgYW4gZXJyb3IuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVy
b21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9LY29uZmln
ICAgIHwgIDQgKysrKwogZHJpdmVycy9zdGFnaW5nL3dmeC9idXNfc2Rpby5jIHwgMjEgKysrKysr
LS0tLS0tLS0tLS0tLS0tCiAyIGZpbGVzIGNoYW5nZWQsIDEwIGluc2VydGlvbnMoKyksIDE1IGRl
bGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvS2NvbmZpZyBiL2Ry
aXZlcnMvc3RhZ2luZy93ZngvS2NvbmZpZwppbmRleCAwMWVhMDljYjk2OTcuLjgzNWE4NTU0MDlk
OCAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9LY29uZmlnCisrKyBiL2RyaXZlcnMv
c3RhZ2luZy93ZngvS2NvbmZpZwpAQCAtNywzICs3LDcgQEAgY29uZmlnIFdGWAogCWhlbHAKIAkg
IFRoaXMgaXMgYSBkcml2ZXIgZm9yIFNpbGljb25zIExhYnMgV0Z4eHggc2VyaWVzIChXRjIwMCBh
bmQgZnVydGhlcikKIAkgIGNoaXBzZXRzLiBUaGlzIGNoaXAgY2FuIGJlIGZvdW5kIG9uIFNQSSBv
ciBTRElPIGJ1c2VzLgorCisJICBTaWxhYnMgZG9lcyBub3QgdXNlIGEgcmVsaWFibGUgU0RJTyB2
ZW5kb3IgSUQuIFNvLCB0byBhdm9pZCBjb25mbGljdHMsCisJICB0aGUgZHJpdmVyIHdvbid0IHBy
b2JlIHRoZSBkZXZpY2UgaWYgaXQgaXMgbm90IGFsc28gZGVjbGFyZWQgaW4gdGhlCisJICBEZXZp
Y2UgVHJlZS4KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvYnVzX3NkaW8uYyBiL2Ry
aXZlcnMvc3RhZ2luZy93ZngvYnVzX3NkaW8uYwppbmRleCA2ZWE1NzMyMjFhYjEuLmJjM2RmODVh
MDViNiAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9idXNfc2Rpby5jCisrKyBiL2Ry
aXZlcnMvc3RhZ2luZy93ZngvYnVzX3NkaW8uYwpAQCAtMjA0LDI0ICsyMDQsMTcgQEAgc3RhdGlj
IGludCB3Znhfc2Rpb19wcm9iZShzdHJ1Y3Qgc2Rpb19mdW5jICpmdW5jLCBjb25zdCBzdHJ1Y3Qg
c2Rpb19kZXZpY2VfaWQgKmkKIAkJcmV0dXJuIC1FTk9ERVY7CiAJfQogCisJaWYgKCFwZGF0YSkg
eworCQlkZXZfd2FybigmZnVuYy0+ZGV2LCAibm8gY29tcGF0aWJsZSBkZXZpY2UgZm91bmQgaW4g
RFRcbiIpOworCQlyZXR1cm4gLUVOT0RFVjsKKwl9CisKIAlidXMgPSBkZXZtX2t6YWxsb2MoJmZ1
bmMtPmRldiwgc2l6ZW9mKCpidXMpLCBHRlBfS0VSTkVMKTsKIAlpZiAoIWJ1cykKIAkJcmV0dXJu
IC1FTk9NRU07CiAKLQlpZiAobnApIHsKLQkJaWYgKCFvZl9tYXRjaF9ub2RlKHdmeF9zZGlvX29m
X21hdGNoLCBucCkpIHsKLQkJCWRldl93YXJuKCZmdW5jLT5kZXYsICJubyBjb21wYXRpYmxlIGRl
dmljZSBmb3VuZCBpbiBEVFxuIik7Ci0JCQlyZXR1cm4gLUVOT0RFVjsKLQkJfQotCQlidXMtPm9m
X2lycSA9IGlycV9vZl9wYXJzZV9hbmRfbWFwKG5wLCAwKTsKLQl9IGVsc2UgewotCQlkZXZfd2Fy
bigmZnVuYy0+ZGV2LAotCQkJICJkZXZpY2UgaXMgbm90IGRlY2xhcmVkIGluIERULCBmZWF0dXJl
cyB3aWxsIGJlIGxpbWl0ZWRcbiIpOwotCQkvKiBGSVhNRTogaWdub3JlIFZJRC9QSUQgYW5kIG9u
bHkgcmVseSBvbiBkZXZpY2UgdHJlZSAqLwotCQkvLyByZXR1cm4gLUVOT0RFVjsKLQl9Ci0KIAli
dXMtPmZ1bmMgPSBmdW5jOworCWJ1cy0+b2ZfaXJxID0gaXJxX29mX3BhcnNlX2FuZF9tYXAobnAs
IDApOwogCXNkaW9fc2V0X2RydmRhdGEoZnVuYywgYnVzKTsKIAlmdW5jLT5jYXJkLT5xdWlya3Mg
fD0gTU1DX1FVSVJLX0xFTklFTlRfRk4wIHwKIAkJCSAgICAgIE1NQ19RVUlSS19CTEtTWl9GT1Jf
QllURV9NT0RFIHwKQEAgLTI2OCw4ICsyNjEsNiBAQCBzdGF0aWMgdm9pZCB3Znhfc2Rpb19yZW1v
dmUoc3RydWN0IHNkaW9fZnVuYyAqZnVuYykKICNkZWZpbmUgU0RJT19ERVZJQ0VfSURfU0lMQUJT
X1dGMjAwICAweDEwMDAKIHN0YXRpYyBjb25zdCBzdHJ1Y3Qgc2Rpb19kZXZpY2VfaWQgd2Z4X3Nk
aW9faWRzW10gPSB7CiAJeyBTRElPX0RFVklDRShTRElPX1ZFTkRPUl9JRF9TSUxBQlMsIFNESU9f
REVWSUNFX0lEX1NJTEFCU19XRjIwMCkgfSwKLQkvKiBGSVhNRTogaWdub3JlIFZJRC9QSUQgYW5k
IG9ubHkgcmVseSBvbiBkZXZpY2UgdHJlZSAqLwotCS8vIHsgU0RJT19ERVZJQ0UoU0RJT19BTllf
SUQsIFNESU9fQU5ZX0lEKSB9LAogCXsgfSwKIH07CiBNT0RVTEVfREVWSUNFX1RBQkxFKHNkaW8s
IHdmeF9zZGlvX2lkcyk7Ci0tIAoyLjM0LjEKCg==
