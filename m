Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2435A4086DE
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 10:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238595AbhIMIfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 04:35:11 -0400
Received: from mail-dm6nam12on2050.outbound.protection.outlook.com ([40.107.243.50]:38689
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238591AbhIMIee (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 04:34:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nZq3n0lO0Fw7ai2oYzJ48xxXpAeR1AIzJFMnBMlVj6JjblX2bF6g3OEs4iXtsDSkon6z581CBXG0j/HnxVQxefCnox2ZZjPUavd8yGX/34IHEzlZEBtPCgwFFhVS4/bYh/hiI69nOgmRQJQy2C+dTlQkVeV5PVQWOwAzc4oEnpPRPw1xPA+U44QvcEmriwy3rjF8oLz/KGfE0lMy+mvIFm25pkDNCFhtXTlhv7Bi/qBZiPg+9tBJXvnWAKhcsnnd5spMB/ECDcxjXaJ0npcJ6HLjZaOW2EFRSwzxugWDlf4DOfJ7kDFzOqUyk7B3lqX3xAASWYqYr9B9UZX/6AwVvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=D2RF/Y6vM+Lj63470xCmRdZGPoY4c0kiDfF+JTD4zDA=;
 b=bZDxxidLZXheAYUlpH+bC6X8z8+MkHZTIlrLURTmgsJOYeUtWEJe2B8HvPAxhdeEcCm3xYCVSIX73Dk28X8OGF9HyDujAFZeftbsVGWuKZnXhR/Jw9yaSWfin8B3gD4wH2s/UOGKPG1emn162VBwKXudOVDXL4+08YjPQNU3l+I4n1+oRvJBzyntHaPTECOo+WeWnHtVvKc7RTaPKiPdQMmQnlDnARLKa0XRDdhezN2G4o9sTLbjV+YWenjk6K0gAEQh5S43Yayr8trgOwnRFPvuD8R72QsD113sg/oTTF6Nlrmyy3fk6I3fFU6O1YWWrQRwvKwyvvDM5K1Ohrt2Zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D2RF/Y6vM+Lj63470xCmRdZGPoY4c0kiDfF+JTD4zDA=;
 b=ACCQEBzXWCszHiTjNq9W1SOMZP8guPpVHTtIOPrTcs2CrMxLQCUaW7EWf0oOdVYEDdNLD+ETnVel05jwTMxyLhxyW251e/hgK6mRkwLQ0IFEaPETAySKLo9h45CXTA30utas7lZKQVfMtDoU8XNa5lP0u2N7l2N78fqI4YpAE70=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (52.135.97.18) by
 SN6PR11MB3263.namprd11.prod.outlook.com (52.135.109.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4500.18; Mon, 13 Sep 2021 08:31:56 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Mon, 13 Sep 2021
 08:31:56 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v2 18/33] staging: wfx: reorder function for slightly better eye candy
Date:   Mon, 13 Sep 2021 10:30:30 +0200
Message-Id: <20210913083045.1881321-19-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913083045.1881321-1-Jerome.Pouiller@silabs.com>
References: <20210913083045.1881321-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PAZP264CA0067.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:1fd::10) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PAZP264CA0067.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:1fd::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 08:31:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a530b546-4bd0-4ca4-20ba-08d97690e668
X-MS-TrafficTypeDiagnostic: SN6PR11MB3263:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB3263BF767EF1F0FF6F78235093D99@SN6PR11MB3263.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:483;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O8dvUi2QX+uQC+iECkKK2bmXX/er2kAcYIjH/r9XlR/JvLaDrDzS+HG2UZuqvA7DQsoXKiww+rYimtSt5rhiRWHYd0Rc4VPh42P+1hq0lzgm40t5RSKNtPUThPklImYs/VlfwwHpjD8rzOcO6JNO4Aqm2qwJz4C4cs4EpvSJgF1ywaHwlaAK0CHjhvrdi5oPh/quKyBbqMlGaE5tw6dm4ERwt1oas/1UkR2Ja2+WiVDr2LzalLvAf93+ZG7xO4tSTn0KNWosNmWRhZ3R/XUDkZ62roHayYTxMldkCs8rl7ihXQaS7mCahT1Dpd3KnZk97iIpCaLjYAmhgh8pV4+PNKznu9IEX1lDBEPSLj7AWupksdR0kvJ5Jr+CRtx0zUxK4+V7bRXJZ5uj2Bm8C385aDhQD/su/612ay7fCcoxEnaJ63sn43Z5oFGrtdSXAkCWeKpaTS8d3fHIgFlJgsYhQwl6jP9ZLqVb84/Fw7eOfe3Aq2T8Piw2NFnIfkKTeGnE1Qp55dZ41YnG41LHR5TfLZzW2jAnB7B53nAxcRwEYz6kTRcGcgrPeh5cF1cQk0Ykxyhf0BtGu60Z8fYl0YTP8MIF9ihhUYASjbTQgcfn4rFiMf6FosuqunKRUymQh6j4D3soqcPDCDeZ9BJjhbvAnPKenYhzm8U49aHTSDwoN0BsoM3fLvxaMtn1hmiwYph7/HtPZvREPwg2UQqwJTuP1Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(107886003)(956004)(2616005)(5660300002)(54906003)(38350700002)(4326008)(6666004)(316002)(38100700002)(66946007)(26005)(66476007)(66556008)(186003)(8676002)(36756003)(8936002)(86362001)(508600001)(52116002)(7696005)(6486002)(1076003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?djlGdGdVclROWDc0UE53TW5YZmJaUkhTYkxIMnkxOEVvUy9PYjdDbW5TVHBs?=
 =?utf-8?B?UmxXRzViTnF0QndLRm9TVTI1VWRKSGQ2R0I4cVJ0djZlWXBRWHd0VUxjZWFD?=
 =?utf-8?B?UVNOTEsvQXFzbDQ2VGtFblU5dVEzRS9sOGJmMlFJMUMxMWozSGFBYTNnQ29s?=
 =?utf-8?B?QldleXg1NGVJd0EzSDAyMzB3OHdZbkI3aHNoUDV4a0lleFZFa3BRWlpWZG1T?=
 =?utf-8?B?S05Gd1JzV1RBMmtzVWlKUmJ3NXE0Z3pJYkdoT2FydkN3V3BYQWswWWRmY1JF?=
 =?utf-8?B?aFk3ZmZDalhCK2hPUWIyU1NuaGljUFBoUVpHaGkyMDgzVGt0UmtYUG9nK01X?=
 =?utf-8?B?b2N2UC8xcHV1ZW9KajkzTlZCWXBaWWhMTVBkRmFqL0krWG5GTkdJWW9DYWI2?=
 =?utf-8?B?RVdzbEtiakJlRnFmSVFSdkRKVHZQd3VjblE0NVZmVGNFR2V3NXp5aUdNUjh1?=
 =?utf-8?B?NnVxdzMzYURzRkJ2elZ3NUlXMzA2OEM3S2dlZTlENTQ3QlNLU0czbHBsd3NX?=
 =?utf-8?B?Y1JQeDZPdjlQQWZMSXZneHlqSGxtWHlDSVJ5MEErcWlWZHYxMXAxMTlFNEpM?=
 =?utf-8?B?WEJreWRjV014VnVSN0o1dUN6U1JmRXc1QkZHNWRLVW1POG84KzlqQXFnSGhu?=
 =?utf-8?B?T05kQjZjTXhBN1RoN0Y2L1pwUVlhbU5vWlZSTXBiRm5CTjNoa045akhaMnhj?=
 =?utf-8?B?WUNGWjR1bjNVeXpXZCtwZ2o5VWVCZTJjSlVqZjBGYkU0UUF3R0tJeW9mWW5I?=
 =?utf-8?B?TUI4VEh0SXE4c2tKdUo4aUlETWVoOVVobjJsSllxaG50VmxYSGt1SWg5MjBn?=
 =?utf-8?B?dTZNbjlUNlBHcWlwWHZuc0VQdzVraUx6ZGJibmJBM1ZHcy9lVnZKT2lDak5H?=
 =?utf-8?B?azBleVZTNy9QVzU2akpmdTJyRUNCWisxbzNSZ1BpWk9PdU9JcnVsZXhrUU5W?=
 =?utf-8?B?Q3ZTK1BJL3B5czBMV1pTaDBKd2p1T3BiTTJhelY2a2YxZEpkS1BPTW9zRkNG?=
 =?utf-8?B?WU1DOTl1eS9qKzJ6UThWSmUvSzBOVVk0N0lLWFhUbko5RXhpdWU1dDhZS25S?=
 =?utf-8?B?VnNRaEk0amt2dlhaZWZ2OU4wVGVBYUlsSHBrNWhLSGZuS3VEbjk0Y21wcThU?=
 =?utf-8?B?Y3pIS0JYUnErT1dJWGJZcGg5NGYxclNUY1FPUkd4dUxwQXllME9JWUo4cFd1?=
 =?utf-8?B?VTEzN2VaL1pWYW5qV2VVOVhWeU95Y0QvZktBNS9tMU5RVHFCeUo4b3JNTEFY?=
 =?utf-8?B?NXZtemNETkJRZEUybEtnR3BwbVUyVlI3YW1EcXpsa0FQLzFCYzRQMVE1WW0r?=
 =?utf-8?B?WjYvMk14YzhUemZFb2N1ZmhrQ3MwYXcrNEExYTdDVHh5RGdGN3VNMXA3MFFN?=
 =?utf-8?B?OVFBRGJkSE1EMnFEUWxSUkRpN0Vzd3k0YUR0TGpEbkJkcXBDcFk2TGVrYURr?=
 =?utf-8?B?elgydnowMjZNckRUVlpUTE9mT20wbndPWCt1TExuNkxOSXVJbFhRcHdhdy9R?=
 =?utf-8?B?eG9SVlFTZDNjODYrVS96MWRiQ0xpbTNpdUVxNWJ2NHF6L3dPL1dSM0dnZGM2?=
 =?utf-8?B?RnhsMkpNWHdxdXNLbVVMWVNSd2pKcjBkN3YyYVpFczF3YXQwNVNrNnI3NnRz?=
 =?utf-8?B?UlJqZXhldEtOZXBaenJON3dmRHJwd0tuK1BIdExoYzl1ZHNxaGZHU05hbWdk?=
 =?utf-8?B?YXJiT0JKVk5kaWIyS2NlT0l4UWEzUTBqTUYzZHhGMFZQcDJldFUzYmh4U1FG?=
 =?utf-8?Q?n0VuKxqm9jYIYfuZfXNSmrCf6Mm0VHjOj+ZzXft?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a530b546-4bd0-4ca4-20ba-08d97690e668
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 08:31:36.4286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oeItaCF/q4GGMJ15KhR2iRz/GNRbiejme+D4Vjvo8LBU0M3E05cSNkY1A3jbyCuJFkwUVPpS9b9OzapPFK10wA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3263
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKRm9y
IGEgY29kZSBtb3JlIGV5ZSBjYW5keSwgZ3JvdXAgYWxsIHRoZSB1bmNvbmRpdGlvbmFsIGFzc2ln
bm1lbnRzCnRvZ2V0aGVyLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9t
ZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5j
IHwgNiArKystLS0KIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25z
KC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmMgYi9kcml2ZXJz
L3N0YWdpbmcvd2Z4L2RhdGFfdHguYwppbmRleCAwMGMzMDVmMTkyYmIuLjc3ZDY5ZWQ3M2UyOCAx
MDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmMKKysrIGIvZHJpdmVycy9z
dGFnaW5nL3dmeC9kYXRhX3R4LmMKQEAgLTM3NiwxNSArMzc2LDE1IEBAIHN0YXRpYyBpbnQgd2Z4
X3R4X2lubmVyKHN0cnVjdCB3ZnhfdmlmICp3dmlmLCBzdHJ1Y3QgaWVlZTgwMjExX3N0YSAqc3Rh
LAogCXJlcS0+cGFja2V0X2lkIHw9IHF1ZXVlX2lkIDw8IDI4OwogCiAJcmVxLT5mY19vZmZzZXQg
PSBvZmZzZXQ7Ci0JaWYgKHR4X2luZm8tPmZsYWdzICYgSUVFRTgwMjExX1RYX0NUTF9TRU5EX0FG
VEVSX0RUSU0pCi0JCXJlcS0+YWZ0ZXJfZHRpbSA9IDE7Ci0JcmVxLT5wZWVyX3N0YV9pZCA9IHdm
eF90eF9nZXRfbGlua19pZCh3dmlmLCBzdGEsIGhkcik7CiAJLy8gUXVldWUgaW5kZXggYXJlIGlu
dmVydGVkIGJldHdlZW4gZmlybXdhcmUgYW5kIExpbnV4CiAJcmVxLT5xdWV1ZV9pZCA9IDMgLSBx
dWV1ZV9pZDsKKwlyZXEtPnBlZXJfc3RhX2lkID0gd2Z4X3R4X2dldF9saW5rX2lkKHd2aWYsIHN0
YSwgaGRyKTsKIAlyZXEtPnJldHJ5X3BvbGljeV9pbmRleCA9IHdmeF90eF9nZXRfcmV0cnlfcG9s
aWN5X2lkKHd2aWYsIHR4X2luZm8pOwogCXJlcS0+ZnJhbWVfZm9ybWF0ID0gd2Z4X3R4X2dldF9m
cmFtZV9mb3JtYXQodHhfaW5mbyk7CiAJaWYgKHR4X2luZm8tPmRyaXZlcl9yYXRlc1swXS5mbGFn
cyAmIElFRUU4MDIxMV9UWF9SQ19TSE9SVF9HSSkKIAkJcmVxLT5zaG9ydF9naSA9IDE7CisJaWYg
KHR4X2luZm8tPmZsYWdzICYgSUVFRTgwMjExX1RYX0NUTF9TRU5EX0FGVEVSX0RUSU0pCisJCXJl
cS0+YWZ0ZXJfZHRpbSA9IDE7CiAKIAkvLyBBdXhpbGlhcnkgb3BlcmF0aW9ucwogCXdmeF90eF9x
dWV1ZXNfcHV0KHd2aWYsIHNrYik7Ci0tIAoyLjMzLjAKCg==
