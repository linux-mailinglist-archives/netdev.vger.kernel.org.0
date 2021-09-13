Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA50408C07
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 15:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240156AbhIMNIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 09:08:16 -0400
Received: from mail-mw2nam12on2056.outbound.protection.outlook.com ([40.107.244.56]:27422
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239037AbhIMNGR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 09:06:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PAoxs17gunVKoXVVQNScYbBmksyC17a89wkOnjL5BJ0GtBSsLl5HLz9pEYhOU4MtfnGVaGO50VDznP6mKx9dbyPFEy/hmPzKfqR6uV7+2E/juho1DEN+5IZQEo127fW5ov6wfMhVqntkZLGs8u67E0xLLJcd2lxrHg9XY9maG2XDyyXVEQGvV/gkXTu0pvt5Tf56p3y8tPtlfJDz40yD1fh6jp8sAn5T9Wy5RbuXtAVNIkkkwkbXdqMe3122+L+Z3Lg2tgsRGkKORorpdA4gtgRqzpnH3J0BrqXqcT3hMkN2StNcaqxGB9XOWAXvHjTqr3xaYqJJpzosRvFHNHdiRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=NeuP4ZGKysxm7prZcyq2SedkVKYixC5BJTpVRPC2uYI=;
 b=FY8i55wlIcGfFhjO6eDWD0WdqFarX1IFTaS3mbfG7j8xa5n/40csbQ13aDRpU6GJC/UahBLjS597RMVHuySYxeKj9rJ8lFefweiG+mQy3nWZ/oYujL9rGV6yCj28B7TdiTkgsDc0u1e5MO2S7Nn2itzU2xXaU21lgeR7BzbFzl8X90Y69Rj0Qc+QUckofJ1byh6KudUay4Q5tnO8Tk7aDvsD4su2JkY5layfgR7FDYRGnN34Equn8IzVjc2tIgyY1Oa6lU0unPgnYs29ohYglCPUChdVfdBCAwy3XZ8qNGy7Xocypj+5X7wRVzeHnEAICsbwuyxNP3cC1Vsmq4UEBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NeuP4ZGKysxm7prZcyq2SedkVKYixC5BJTpVRPC2uYI=;
 b=HTowKYxINM0jjdJoNUgY+eGkKgJbiTZ6nD9NUq0AHbDX2yGJ6HMKS5n6nDdhDk1uiMBN5dR0d3Ndz84Xe9H5P7TyRq/GaeQVn5wqUdmnQpY924rDdfxqGZWmj4otMy8wWvzRfZKLroIbrGDPP5mLWY145yMbWWOUPtd96WeVTL4=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA2PR11MB4860.namprd11.prod.outlook.com (2603:10b6:806:11b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Mon, 13 Sep
 2021 13:02:52 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Mon, 13 Sep 2021
 13:02:52 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v3 19/32] staging: wfx: fix error names
Date:   Mon, 13 Sep 2021 15:01:50 +0200
Message-Id: <20210913130203.1903622-20-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913130203.1903622-1-Jerome.Pouiller@silabs.com>
References: <20210913130203.1903622-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR2P264CA0021.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::33)
 To SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PR2P264CA0021.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 13:02:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: feaf2996-5cd3-4909-7d70-08d976b6cbb9
X-MS-TrafficTypeDiagnostic: SA2PR11MB4860:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR11MB4860E09BD02DB754EF9F9C7A93D99@SA2PR11MB4860.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NWGjbdcTGN/izWcL6iRem3+zV5kozhHwfVhvWREs7aKCkaSiAAsVONnL6rmlg1W0kZfHAFXvqQTfEqtPK2vF37NfsAXodhV6MN7fbHhIi711D4K2mSDGeqr0PUkyB5Pu4JvFmegOR/AtZCZB7Xsmi7vlx5lbM/f+JVqwA9m+aBxWlRWMva160rB71W1Kkidwkm1nYzwTqp5yw9KihIq5cB6VRu1bb2qtkKc3AD7Ca2cXDj0CgqRyB61jGbiha5qDJRMkKDroo874jNusnYn1CE9FaCYjcd5bP7n619BZOgkZv112nxyEfML9nrEt9npic26ePaVHt4C3rRgm1T8iCMLkBQgvjsfda6upbAeXO+9gSvvmETdHL9R1kjKb2TpYIZ0QHEzMVzRlR1Pkn/rLC42w+ztEbkWQF+Jv8gtPZijZDHbk+vwANbDCafskQ34gT8sRsCpdKuclnVu61Lo3JvFAxeJmDP6mzxMXVLLOUHAob/uJXAiqiPUY3N+mhZgpxjjMEygHbSiA1BF4VzsHbNI/jrBlhajoxBLMuEKGpCHqyP34Tsx3mgTNeF5k24bR+csUUyonjRQi5sUqVBAnHQyxLYfEtOK5gxV1wg6nGH3dgYi1ui88rewzBUf8YcEBykhbvvrCjNQfuh6VwpyeoWPTTNxxred4jBpI/i/Ii30zHU5O1YzapxD4TIcQgLNdr260S1EqXE80Q0Vlbzvxlw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(956004)(66574015)(4744005)(66946007)(2616005)(26005)(36756003)(38100700002)(38350700002)(316002)(4326008)(107886003)(7696005)(54906003)(5660300002)(52116002)(66556008)(1076003)(66476007)(6486002)(508600001)(8936002)(83380400001)(86362001)(2906002)(8676002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OS9yNnRjWXZLY3A3YjdHQ3o4VkRTam9xem5GM3QyUGpvMkFYUkhJc3NwQ2c4?=
 =?utf-8?B?L1BBNTU4REZaWnFsbFZrZDhYTms1djIxZ2F0ODZBQXg1ZjVSZXdGTmEweTVE?=
 =?utf-8?B?akdSY3czc2RNTDRudmEwNi9mN2RaWEtBanpZVGJLbStXTVJmV25oU3FIbkpy?=
 =?utf-8?B?U1c3aVE5YzF3RVM4WXhwOHhXdWpBdk81UUh5U29wVnFlbTJEOXhRUDZyaWdQ?=
 =?utf-8?B?QU5uNFZGdVFNRmRMNUs2dndiL05aY0l6YVlocHJLRHRNU0NDSGNuOXI4Zlli?=
 =?utf-8?B?L3NSVmMrY252bkkxYm1sd1d3SHF2Q09JY2R2REZMdEpxSnpxUDRtWVRIVUNM?=
 =?utf-8?B?ekljU2NINmV1RHN4V0VzMFJsbmNFeVB6Kzl1WU5CenhSWW45c1pUbXZjOWVV?=
 =?utf-8?B?YTF6UW85L29XWHNDL3E1MmxBNENmTlB6NTZ2b3MwL0x1K29QMEI0QnFxcnd6?=
 =?utf-8?B?WmlDQXUwVzIrTWlXeFlRQmZkNnh0UklsNk1GUWFtWjRvL2lBN0ZwQ0ozdGFI?=
 =?utf-8?B?bnRESWpUanNEY2ZLeGNkL1NQL2MxZXlmejdNTFJmcUVZcTNoNUxqTUE3K01q?=
 =?utf-8?B?Q3AzK25rdmljRnM5a0Z5dWNsbmRwRVZ6TG5UZE12VUVoa3RXVUFQcjBKS0RF?=
 =?utf-8?B?RlI4SzBIelZyY0lEV0Q1UXhlQ3VMMkMzZkFaRVRBNDVpWTdzc0RmbXBkd2VX?=
 =?utf-8?B?T0QyTmdhQnQ3Q3pkeWpJS0RMTlNLVTZiQXJ2N0xpcU9NTlh6MFJXekdDZVFs?=
 =?utf-8?B?YUZjdDcrcEx4ZElUKzBrQUFJUEJaOXNoUnpBSU0ySnZLMjBMYm5HbEE0Y2xI?=
 =?utf-8?B?c2F1Syt3QldBU25YR25tUyttclpOaDBHS1pRZ3BoSWY2S3R1Qm95N0VTaGpk?=
 =?utf-8?B?UzNySlliRkkwWUxiVnp6d3JFY1BndGFadWNBNGJ6eDNWLzZITzdISXF4VjRv?=
 =?utf-8?B?MVF6M3N1NkZoaFc1UUZoTy9aQ1N6NlQzd0hkM1g1bGwrTVhISmsxcHZ4cTFw?=
 =?utf-8?B?YkVEam9yVk9qYjV5Z21ISGJTQ3JSNmpLeXJ5ZnNIOS9mcnU2Tks3Ni9wbkc4?=
 =?utf-8?B?Tm9DVGlNSXlVZnNiWG5TenRuYVVEUDdyakhSUWx2WGtSYzJIeWxsNHNDUm40?=
 =?utf-8?B?ZzJxd0hqY3QyYjR0clYrOXkzTmRNRjN3THVDUGxMcVkxc2ErYm94bEdla0Zm?=
 =?utf-8?B?TnJoUm5TR1dRMmE2VnFNKzZ1dnpoVnIvM1g3TDN5VjArQkxMVmRrd1NMUnVE?=
 =?utf-8?B?SGs4R3FmeVc4eEFlK3NtencyZTU1Q0daMHdoNW1yb1h2K1JJRktZYlhiRkt2?=
 =?utf-8?B?TlE5WFB6RVB5amdGQ2pKWmlNZlZCUnBUQVluVGpEZThKYnRONFNHMndmRXg5?=
 =?utf-8?B?NWNjMzA0d2JkRW96WDdUWFZhaTAyMTQva0pmTDczNk95UnhuU1MvTTliOHdT?=
 =?utf-8?B?QUtVS1UxaWl5RXBmM1BEVjgwa3EybTVzVzIxbCtFYklqZ3YzRE9Vbm1TTTBE?=
 =?utf-8?B?aElaKzNDcFJWTzZ4ZlhYckU0YUtneGpqc2FaVy92UUpnYmxUWWd2T3U4bVk3?=
 =?utf-8?B?VVB0MmlHOXY0YmxLaVFzY3Q0bjdHQnNKZFY5RSswM3dzZm1WTFdERHdzbW5v?=
 =?utf-8?B?SFc2WHQ0MHlXVjdNZjBtVk1OL0hoUUt0RXczdm1JeXFtLzU4anczQlFIRlI1?=
 =?utf-8?B?a2VMRnN5VTZyeU5XUVg0alFDazFlcFVYLytSUjN3aTBTVS9EYW4xZE1VS2N1?=
 =?utf-8?Q?q91mspYghOGGKM6p5eE4YUx9JKdFZHyKhQuqamS?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: feaf2996-5cd3-4909-7d70-08d976b6cbb9
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 13:02:52.7340
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hWpGax/p36NnSayINwEgJ4nLMD6DhR77SWYj8vmNYuVLgS+8ntq7J5OeoX41Xar2NUjNVBI6Zbnsv4TdxAWGUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4860
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKRU5P
VFNVUCBpcyBhbiBhbGlhcyBvZiBFT1BOT1RTVVBQLiBIb3dldmVyLCBFT1BOT1RTVVBQIGlzIHBy
ZWZlcnJlZC4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxs
ZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jIHwgMiArLQogMSBm
aWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKaW5k
ZXggNWYyZjg5MDBjZTk5Li4xZThkMDVjNGYyZGEgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2lu
Zy93Zngvc3RhLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwpAQCAtNjc0LDcgKzY3
NCw3IEBAIGludCB3ZnhfYW1wZHVfYWN0aW9uKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LAogCQly
ZXR1cm4gMDsKIAlkZWZhdWx0OgogCQkvLyBMZWF2ZSB0aGUgZmlybXdhcmUgZG9pbmcgaXRzIGJ1
c2luZXNzIGZvciB0eCBhZ2dyZWdhdGlvbgotCQlyZXR1cm4gLUVOT1RTVVBQOworCQlyZXR1cm4g
LUVPUE5PVFNVUFA7CiAJfQogfQogCi0tIAoyLjMzLjAKCg==
