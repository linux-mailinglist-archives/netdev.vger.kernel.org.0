Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7347408BD5
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 15:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240060AbhIMNGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 09:06:18 -0400
Received: from mail-mw2nam12on2088.outbound.protection.outlook.com ([40.107.244.88]:10209
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239552AbhIMNEG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 09:04:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V0ChSjLs0T/ngQUAoC68jz2XhNORl9rRr5F0wYlEx/c4ndeA086Lg58Ahq1yyha91UmZr2Z8+nwnNxmfwDdsLjI8DO+tRxTQ+u7WMckXyo/L5E7mUA4WEidpbbPoFEYUFi+QStLwy3KMspvxiRdxDgulBMTHtQzYSJZQrVsPzzMhDOrMsEyaL4gUYp1tb+Sd/TKpu42Nj2gFb/Lq7PDtQgOcEQMhxrNRYrJUh5viLUbzpYV8IRwBclDxX6YUoQCuWn1q+UiwgNV7wMsXLzgnodMN3Ucm8cnyGm27iH96hmsmvj9ossP2y8KKNYUxPpJLTgooiif8FUoBz3xvRKVanw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Jgm7gufk4MiTW/E5bnLdLTFb9rL4DssoymnMgDzNeZw=;
 b=G14tYnDwz9VkMDPCOkQ3pR5gsKjcrrZoxhGUpr/pFAg2NXlMqSS34dbeY0s8xfea64qVR50SCRzzJ3+DzovWfBou2ajGiiktxjm+HBkNgcaWqqzQXdCNxHD4VfIf4+ctDQZwSsJHVqR24QoUGM7eFR7EyFEYhKaw05Rz9sDx2WEkom9X7laZdxpWzF9gB3b2lpsxMJ4eNJrmzPST6bZQUTJt6brqz7ie1f0qUnVPEUzqaiYtBIf/sT7GXOb8gFmQ7RtT/8ipl6XAFIM4YtHcaNrUytu44T7i6DQauxfqjIs88m37hgq/v0l8U0Z22Od6Q7uloN1l2eTZ4rjGiM6yWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jgm7gufk4MiTW/E5bnLdLTFb9rL4DssoymnMgDzNeZw=;
 b=ZtFbSeZfL2sR2FULv3bdxnWyKogTjUzLJzLvtVhsvVhBnMjJ2BChBC9MJW15CAMRLNtc40O26y+lDp4SzJWXZFhQMGCv+JM7YCplXiGUGkhSWd0uDCr4y3n0XJaK9wS9gD0mqHqMcmi1426ItIwHuAhwhCTawnxL9CxtvDcQ7HM=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA2PR11MB4860.namprd11.prod.outlook.com (2603:10b6:806:11b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Mon, 13 Sep
 2021 13:02:33 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Mon, 13 Sep 2021
 13:02:33 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v3 09/32] staging: wfx: declare support for TDLS
Date:   Mon, 13 Sep 2021 15:01:40 +0200
Message-Id: <20210913130203.1903622-10-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913130203.1903622-1-Jerome.Pouiller@silabs.com>
References: <20210913130203.1903622-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR2P264CA0021.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::33)
 To SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PR2P264CA0021.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 13:02:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 78756b84-2275-4793-5384-08d976b6c076
X-MS-TrafficTypeDiagnostic: SA2PR11MB4860:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR11MB4860E1EBB41CE60ED90C038793D99@SA2PR11MB4860.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1360;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DfZmINL0bOEBvVaDUHt6535l9jYBJ3qADcCQQ5i3Fq49xpUH4fV+1e1x3JDJliALvxVVU5Qw7VWZrfMnZ9bGUUR8M1dv1143DYj/U/KyYsIJvBLbyDrr3WmH+T9GnCgeyHQimzwvRB2ZoDKTeFrQ5xa40na+IOIwikj8pG52CxsGwLY0MCAIk9r/kh9IupAmOA13nhp3bxbnao7bhjU7vw1eGKkB1A8Nvma3IkTiGIHkIhLyMXp1eAfas92boPL+Y52irViSvfARXP0hb9UNC09cpjqpEJuNM5D77cfF4XQ6Lp0R23M2DsIzx+01A/EelVXH3wKEDlhVQpo3fyPIoU5OhDNibikU7Zqo/0lLbz48QdqPx7zIqH5uo9WmN3jdSOfLZBa9821911CQ6fYaSIuZtTxdH47CX/11oRoVT9sPvRRCTCiXt4fqGeFnku/1UXZj12a8Vw/GzjlqiW+6JJghwKX0/iY2sIl2nY+klmsMi9Ih8Vt40Gi89fP5rg69yes99KpZyRopCkOTj4LbsGuxS2eoTYB1E/KTifJAVryEixc1FEjdA7nwTKJObt5aqmXDFPlU+GrOg3OwkZG96UthiySsYEPhZMmewIQ1oU6t5hWNi46m7UOM8payg/tHKZiniy5QX+Kertk+FhRuCJA0HYRjMqB2pW3UkNB5NfcCUHcM6we4x4kDMORYnXX+2qmOZ5+OQehlDPZ4bmUvXQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(956004)(6666004)(4744005)(66946007)(2616005)(26005)(36756003)(38100700002)(38350700002)(316002)(4326008)(107886003)(7696005)(54906003)(5660300002)(52116002)(66556008)(1076003)(66476007)(6486002)(508600001)(8936002)(86362001)(2906002)(8676002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SEg2eFNhbFpnYjNINjR3VWtJRS9BVW9sSVZ0L3BJbXhqMHZxdXg2NnFVbFVE?=
 =?utf-8?B?Nm5ndlhWcmFSSlRJNWw5cms4YmVTazR1SE1pNlNXa3BFK2F5bmpFTWVlbjcz?=
 =?utf-8?B?TnJZTVNhSEVpL2FJYXZ2bDhQS0J0Zk5rWEw5Wk10Y1FwWmFlSldUV1o4TGlV?=
 =?utf-8?B?cEo3anhrNm4yT1R6ZmdTVDh5YnJRYm50QVMxOXRmU0hnNndtaVBLRmhxS3BV?=
 =?utf-8?B?WGJwejh4eFJtREpTZzN5RlAyWnVWRFdLZDA2TFhibG9zUzIrM0YyNUVsSHNE?=
 =?utf-8?B?eFk3MkJMRlNzZFpGbkU2VU5CY1BOZXZSMjVRQ0UrZmlRRWthLyt6dXJQdDBI?=
 =?utf-8?B?R1VjUk9sZVV3SWdYK3RsdThVV3JZclNRSWNaWE1mTFk2TVpXVy9OK0NpSGNN?=
 =?utf-8?B?NDVMS3haRzNSU1BzRmNNMFlPQUlJMFg1cll2b200QTJ2WDhhRm5SWEY0U1p3?=
 =?utf-8?B?T3pBb0l4MVJDaldnOTBLYkRPUFEvZklRVUlOb1FzZXVMc2FlbHZTbHltUW5h?=
 =?utf-8?B?MEpPSnpkVFlPYnVvSkVYS2U0Q1F4NWJ6dnplZ214blVDME9kQUpJelhIZGp1?=
 =?utf-8?B?eXE5Y1l6R3k5SG5VK0o2ZzR4MmxtQVBTRWR2TTVxUHViTlBydm5XVUx3a20r?=
 =?utf-8?B?RHMxVnh1Z0QxLzRxM3FUTXlqdG1jK3lsOXJrSnhiWmhwb0JNT2gwd0hCT01C?=
 =?utf-8?B?eGJBR2RhYThQYUZaOTROMWdzSDVwam5MWXcwblU2NWhRNVpvd1ZtNWZlR0t2?=
 =?utf-8?B?MXMzTTgvWXRxY3FyaDJhVjNzdlp5LzI3RWU1emxVZ1U4VkRHZ1pvcGNBN016?=
 =?utf-8?B?WE5EbTgvSFhNRGhKcjdLT2JYZysweklVQkhCb21MK0dmUlg0Y25iWUZheTlj?=
 =?utf-8?B?UkllQk9tMGFjMW4vcVMyb2lSZzRidXkveFJqcGtEbTMrb2FXcnJWb2dVYmJZ?=
 =?utf-8?B?MDNKZmE5alREamhDMmo2dU14VlNieW5OaDBPZ0dCMENjZVdsZldCdmplSGRv?=
 =?utf-8?B?c3YvUEUxak9IWGdXQ2JtcVBoL2ZzcCtKL09aQlpOL25lUFpyOHlGT1ZUY0Zr?=
 =?utf-8?B?cGpwUUgxYWErd3Q4SlRPQ0QzUmVjeFJEWmRMM1VzNUFOYXhxY3I0S0hpNFQy?=
 =?utf-8?B?d3lHL3VnSS9WS0RIS0hDL0tpc2Y3OGxlRHAzNEVvNHFuVkljS0l2L05CTC9K?=
 =?utf-8?B?eUREeWJJc0FLY2tkdjZvK1BNY1BLRlhXa3pNeHZnbitBWllTOGk5RXFtQmM2?=
 =?utf-8?B?RGQ0NllRcXVpeTlrNU1MZS9RelBMVXFHTjlxQVUzbzh6aTJaekZ3YnpCY0Zy?=
 =?utf-8?B?MFB3NitCbk5jSDJBNkFTT0R2clZiNitmMm9peXRjSTAvS2E2b0RWTXBDOEM2?=
 =?utf-8?B?WmJ6NzJ5aVpJQ2J0S3dpdnQ1b0UydnFtSkVKcG5VVWE1ZTkxdlJkaHMxYWUz?=
 =?utf-8?B?aFBGckc2VlB3S2ZScitGdmRCNDhzUm5yeEhMcFpmR2MwZ3V0N3Q5RFk2TVVp?=
 =?utf-8?B?VFBmbXI4bll4bWttTUpUbEszeGRyUjVvZXpNRFR1QTUyazkwYkRJL3diL2tK?=
 =?utf-8?B?K3EvTDJjNnArMnFIQUp4ZVVUODR0aW0yS2hkNGV2OTVlREJ0OVRHSTdmcHFZ?=
 =?utf-8?B?ODU0VU9paUZGblFtZWxoamhQbmRUai9oQ2hDV2x6WUQ5RnpwdGptNkErd0dq?=
 =?utf-8?B?OU5hTXMrNzN1L3RyUW9SZWtWSkpMZ1pabFNmaC9aalpLTFRIcVJ5QkY2aTdr?=
 =?utf-8?Q?q1Rq1lNo1+x+tEzz/zmopxYQ9mblypHZIx3aydz?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78756b84-2275-4793-5384-08d976b6c076
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 13:02:33.8389
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x5pQ0+nq/kzbK0eMMWT+/pbmWp6JNYGKuyXLgRjdufmyqm8n424IpQdN+71Dqbw5HFSxHGLvpB10IzKHHJ/oFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4860
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU2lu
Y2UgdGhlIGZpcm13YXJlIEFQSSAzLjgsIHRoZSBkZXZpY2UgaXMgYWJsZSB0byBzdXBwb3J0IFRE
TFMuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNp
bGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9tYWluLmMgfCAzICsrKwogMSBmaWxl
IGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93
ZngvbWFpbi5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9tYWluLmMKaW5kZXggNGI5ZmRmOTk5ODFi
Li4wYTlkMDJkMWFmMmYgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvbWFpbi5jCisr
KyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvbWFpbi5jCkBAIC00NDAsNiArNDQwLDkgQEAgaW50IHdm
eF9wcm9iZShzdHJ1Y3Qgd2Z4X2RldiAqd2RldikKIAl3ZGV2LT5ody0+d2lwaHktPm5fYWRkcmVz
c2VzID0gQVJSQVlfU0laRSh3ZGV2LT5hZGRyZXNzZXMpOwogCXdkZXYtPmh3LT53aXBoeS0+YWRk
cmVzc2VzID0gd2Rldi0+YWRkcmVzc2VzOwogCisJaWYgKCF3ZnhfYXBpX29sZGVyX3RoYW4od2Rl
diwgMywgOCkpCisJCXdkZXYtPmh3LT53aXBoeS0+ZmxhZ3MgfD0gV0lQSFlfRkxBR19TVVBQT1JU
U19URExTOworCiAJZXJyID0gaWVlZTgwMjExX3JlZ2lzdGVyX2h3KHdkZXYtPmh3KTsKIAlpZiAo
ZXJyKQogCQlnb3RvIGVycjE7Ci0tIAoyLjMzLjAKCg==
