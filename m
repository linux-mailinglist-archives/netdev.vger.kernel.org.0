Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB9EF4086E6
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 10:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238727AbhIMIfY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 04:35:24 -0400
Received: from mail-dm6nam12on2048.outbound.protection.outlook.com ([40.107.243.48]:60019
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238401AbhIMIep (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 04:34:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FKY8mtkdZHgS6gq47zBdF0/IZ7atbN6CKmYQP/uUrJGxq+GSdE8IobxbKQTLskhPhJHJoZI32XRG7jvJmCapxuC1pUfg51T2OqG4T4SVsdiF1c/CFRi6i+2oTrxu3Pd0zelu7lVJFUSQ82KZXkBhR8PQM7gBjHgmdMMQ3uYZF4O1R4DnvBu/bHe2Q1nU1lYN9zgzu+5fY3P4obYzOH7ERwY5nnokNaS1TmS4JS8YzAHL+ZYE3I2U4wnV1UutINtQwvC8OQYnraWjnpw7RfDIjlap2d22PZgX4Pi7kXDrAbyd7d/91RZ0va2m8ndXFOXg7jqJZXAh5s/e0X0mVGhvFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=NeuP4ZGKysxm7prZcyq2SedkVKYixC5BJTpVRPC2uYI=;
 b=H5IerR+Cw0Tp5MGR94md1dBoib26Ap/rQLcMMdPeErRj7dm7Et1gl8Eo6OleA4DZFJkZFQbH3lpGkyEIRlQhvSyrYjifaJkOlob6aCSN75yiSd3u3p+pH/28Nf0IH6duTXmQOXS/+ADwl/NEwKKCPEc4zyeRrSVRKWQRoXhKXJe7VNmErRwXjqb4APBzDargnAKSpIZeTsI1YEkdoAhG9uAmAEEqghDp5ODIjnJ1+D5LPkoq5LsafhmmxsQMblLodBqJQJQpVOze8fQMxAmlYwZzaZwxOPaecct+O1Dsqawb1AD4T+AgPpodEtagrRRNKzGxX2HugWM6znJNOQaXHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NeuP4ZGKysxm7prZcyq2SedkVKYixC5BJTpVRPC2uYI=;
 b=e6lSDYWh4WLVkQ1sv1ZpPiUPH1XR4Meu3J7GCTAt8FjxzBS6wNd9O1GygGXnJOs0Kzp9VFVGYzIX/EfHBS3Q1SWkmr3y4OnK6huBJQimkmZ0k4+A9PZyhPZRCYI0LwTnJ4l9DQ18GG19dS60k7vQJV5iDtyXjMKrH0LxK8YAjbw=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (52.135.97.18) by
 SN6PR11MB3263.namprd11.prod.outlook.com (52.135.109.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4500.18; Mon, 13 Sep 2021 08:31:57 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Mon, 13 Sep 2021
 08:31:57 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v2 19/33] staging: wfx: fix error names
Date:   Mon, 13 Sep 2021 10:30:31 +0200
Message-Id: <20210913083045.1881321-20-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913083045.1881321-1-Jerome.Pouiller@silabs.com>
References: <20210913083045.1881321-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PAZP264CA0067.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:1fd::10) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PAZP264CA0067.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:1fd::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 08:31:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 66885a40-108e-410b-3006-08d97690e778
X-MS-TrafficTypeDiagnostic: SN6PR11MB3263:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB326372057D1AD62E74AE3A0193D99@SN6PR11MB3263.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P9eBg+VHhT6+MQiut6ga3YW0TKoAHAzuMnuT8soVKUo4AiV2xhuKncdd1lKpxzH14LsbKbKD55tPUFrbhR+vO0dNl5YGinAT952rl+32V0AamDEInw0Eec+zhEICB+JG7iHcUHZ6TlUxldezXfUX974Xty4osSBl65ZlvcaPcaPEbb9AkF0wB2wa6tbTAVZkTm7UMXde/han31tvJ9vfbMRXH7HBgEtgoWe9grgG01RyGmb15aVFqhV+S3m5AiTlS6LPuPHxRgP4T9MlzSs/igGUtjEh8Sx5Us7WGA09Y7NVNi0iWYQ5iqf5cn7qFxmT6lKHYaqjxatLnMl50neRNecneh3I4jSkwjJlQiam3h6pA7CskXaW1D5OB2TCRrItT0z8btbP0FEl6yVeqQ99A588otZd7hPOuNul3lEwWWqS0YFW9yGjW8564GbecQT1Ox/AUmQXurc32KkpND8hf5iuKtLSqouVl1/GVaEsbR2uTIe0QdXwFWeFF12oCNz11kOOWz/FHyleOJ8j0hHFDyFF5UDpjQtxrB+bPIsLmuXrYX7tN+w/xqdlxiOW78fen2g4c9iOFs7ZF3DpGMqIq4gYUKsiPHWUQfpkTGZOyKX9qjJ888D5OjFc4mzeW793xpN8fNkTz3bqw7ciyvkcy9ER2d3kVuJOHybj6INkdYjcJ4zGzEBTtBycQahhCmfvU8V+vDLo/0iD/Jaq8hRJtg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(66574015)(107886003)(956004)(2616005)(5660300002)(54906003)(38350700002)(4326008)(6666004)(316002)(38100700002)(66946007)(26005)(66476007)(66556008)(186003)(8676002)(36756003)(8936002)(86362001)(4744005)(508600001)(52116002)(7696005)(6486002)(1076003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bEYwcUpHdk9CSUFNakxpUk5uMWZRQ3pLdG1TTm9GSUdWRkJPU0o2b1JwT2xK?=
 =?utf-8?B?YmlIdytEa3lMZURadTJhRzQranNCRFA3bENoQ0dHcWpwK0VYNktUYkh1WDNu?=
 =?utf-8?B?VDc3ZWlyNGs1MzRqQU5XUVVuSEMwVTlMUmZaWkRBYTFVNnoxSEZuaml5d3NT?=
 =?utf-8?B?N1dRTGtkN1RibDI0dHBOdGRHV3cySjNVSkNCQUY4TUNXTStXaXd6bytwSEVT?=
 =?utf-8?B?UmlQUndiejM5WHhpOE4wSmVhYWdKcTQvNUJjZzhKdldmeVZNMUxnTjNUanJX?=
 =?utf-8?B?TnZkTlNJWDh5enFsNGVCc0xXa2ZLS08yR3lFNEl3dFZya1pBeEhsYTNvRkJH?=
 =?utf-8?B?MGh0SFdObVhUMTRXbUxhN3ZZZDFwVWZwYTZKaG83Y25KUjBFY2RHTFdBNFFs?=
 =?utf-8?B?T21ibjhSMFNIUmQ3M3FjQVpXYzJpZzBCQ0U3dzZYZWV0QXhGVEFaYkVOQjJH?=
 =?utf-8?B?VnYxQ0pzMGU2SU5GMHFBNUlqTUdSTDJOdHZXdEJZTUJhOFZoUEJXeS9KNG1m?=
 =?utf-8?B?ZmlSbVdmSC8vVSs5TlJ0enRsSmlxR0NnZy90YkNhOFFqVGo3VkZIQ1k2VklC?=
 =?utf-8?B?Y2hGSG9iMS96clN4UTMyMXQvOWx1Q2trZ3I0MDZ1YUs2L294ajdPNVE1S1V3?=
 =?utf-8?B?S3ZsOWF4azl1cGN3cUk0ZXpRUmxMYnp1RWZ0bTh1M3BYdVVXQlV2c0dkWmx3?=
 =?utf-8?B?OWtpam1rUE1Va3RqYnZFaFhlWWNKd0dTcG9FNTdySmhCcnNBVTllTFZjaC82?=
 =?utf-8?B?T0lJSWJQMEtLbDdjMHkvdTE1MHZjYTkrc1NJNXVFdHRxbm1yMGk4cEt4VXFR?=
 =?utf-8?B?M256cXlHV1RzU2lmT2phNFkwWkF5UnJ3bDk0MEtndmJUclA2ZTFxemxnOWZ5?=
 =?utf-8?B?UnN4Unc1SHRvMHNHZGo0dkZHeWN5REJZVU1FMGMreGY0MFBkSkdFZXU2Yzdo?=
 =?utf-8?B?Vk5PYURyVnZ6SXZLZUNPOU9Rd2ZaY3VidnVGOThYYVZzcFJFN3dkUGxrbFZW?=
 =?utf-8?B?VFZISVY5VUk2VzQ0RFkzTFdKQ05leXpqeHVKYlBpN0ZCN2JlNjcwbXZIR3Bt?=
 =?utf-8?B?YjBBb3kwNW5pQ3l2UjlYS0lVR1M3cUxSek42ZzhuWXJ1Y3IxYUduR0pJUlJX?=
 =?utf-8?B?R0xtTnJ1VExoUzUreGdibmh2THNJNm13cFVkbTN0dEEybDluS3NmRk4va1ZQ?=
 =?utf-8?B?ZUFMTXovcXpJOVRmZnFtWWY2VXhLelZ2OXIwenZmcjI3TXE2QmtBaFpFQ1JP?=
 =?utf-8?B?OUtyN3BUTHVVaFFDYTNvbmJ2RU9tMW5NeWJKLzJJbHUrNVF1amN2ajdiMi9G?=
 =?utf-8?B?S0JxZTArQUVhUW1RdEVwRVIvbzY1OHg0UjNDOXFIY0dyUHFxaEZVSFZ1d2xT?=
 =?utf-8?B?K1pWMk9QQTJBTURtVWNPb3pNdTAwWGQ1SlB4SmJrc2xBU0dCMm1CQXc2WnFM?=
 =?utf-8?B?bmhoaDh6Vllnb1JPSFRCdm00Tkt3ay9xMGd5blpwejhMRngvYWQwR1BITUxa?=
 =?utf-8?B?eXgvZkRqS28zWG50djNHTWtkTzZhMW15LytsZDVXNER1WGRtYzY0VzV0UEJD?=
 =?utf-8?B?Z0ZwT3NtRVVQRzBUYU8vNFArZkxGZnRnSEQyWi9qMENUREFMUXMxMXY5bXFL?=
 =?utf-8?B?QkhudUJrbGZnQUpHcDB4T0dhL2YrMGRGYnpJRFpWdTdaR3JzczJPM2FrZ29R?=
 =?utf-8?B?QVlrOUZHU21pMUtRM1B6MVNGRXVVZVhhSldyaERRUnJKZnlKMEdBdGQxWGVv?=
 =?utf-8?Q?+VixRYA1qp7hNlC3xefRSKqGNV5M9DJDpNqyE6R?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66885a40-108e-410b-3006-08d97690e778
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 08:31:38.2936
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zuloeR0Igb6puEENPHew0/pfdqu/buQ/+fBV2ayDlfMVYF+TxlA4ighQoqIB2SKeFCi3PR4bmL2QK1QepCZwjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3263
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
