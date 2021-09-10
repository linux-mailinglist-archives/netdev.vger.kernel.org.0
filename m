Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB29406EB9
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 18:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231645AbhIJQHs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 12:07:48 -0400
Received: from mail-mw2nam10on2058.outbound.protection.outlook.com ([40.107.94.58]:8641
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230203AbhIJQG4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Sep 2021 12:06:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dzzVYukbVN/2rBYqYlLyn/ks/3faYlLhVOedJZEYSsm1uw937lPIPfIwYjH9wS2kAqK0tJ8C4N6Txl4Pdcp+tkbF2HDldQ0I1d4hO/1TgAMPChL+uXazBbyOqV1OW6YULRpPzCtZ3qaxCmLrZEeW/DzGfIRCcsXNMyOvIIwQ2bcF7csuNGf61NFGAbvPW0vQyMpx2pYxryLt8DXd1VPRTG4Bbbb6KRZ2owlTVmbhEQRkzWId0ftK8Am8PS4d+FnL+6803/S/SyETlR+6Aa+YDqfiEvyybxjZnOXnrRFMCN6DXgVq53T9Z3CLW0xBIyEAqvazXMZtIew01v67oElpPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Ltkb34xn1l2676USN4kZ+ng0WW2jWxAd1JTkXQJO7zI=;
 b=cTR1+fc3OrisickXG7jSk5j0I0pSpWOySFoiiy0jwr1UaXPsDNyT6XFDGkLH/tO4Jw+Td/kZjMKaoFrOFls099ofjydaeBN2gmPTf/+KbWLd/tyCplko55xHWOzxRwkFDmg+QD+Fp4Ne94A5M58llIn4a1f2dBJcqbc2VpEBWMe/WFN0lR0jHUvr8mJ1sDBr6APugxc4U7tSP+1BaYcJyErDTS2Gv7besdzad6hcUxzv8qw53vF7J5X8tzOdO8uF1wH1wB4+6ZUTdIcPLYQjU9BEthBIBSMgQdj5xwmd21GDvVihZ/JdOOnReSV5esOPRf3BHymEnMImw1jzsr+eRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ltkb34xn1l2676USN4kZ+ng0WW2jWxAd1JTkXQJO7zI=;
 b=k+qliVhOpRyMG1xFuTQWqe5S7JLici5ji+tU1CxnCw0fVpBP1G1hF6tVxhyUxmcZ/8b5pUGM2926Wry9LHiHERnJYU3h4Bsewxw2rcba+fSZD4RD+hfIXcNro66DgEo3kVx0oqNKuOE2g/fklAnVzUFOPHKEkwqQjWwqYq1RkTg=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB3118.namprd11.prod.outlook.com (2603:10b6:805:dc::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Fri, 10 Sep
 2021 16:05:44 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Fri, 10 Sep 2021
 16:05:44 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 06/31] staging: wfx: drop unused argument from hif_scan()
Date:   Fri, 10 Sep 2021 18:04:39 +0200
Message-Id: <20210910160504.1794332-7-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com>
References: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SN4PR0601CA0006.namprd06.prod.outlook.com
 (2603:10b6:803:2f::16) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (2a01:e34:ecb5:66a0:9876:e1d7:65be:d294) by SN4PR0601CA0006.namprd06.prod.outlook.com (2603:10b6:803:2f::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.15 via Frontend Transport; Fri, 10 Sep 2021 16:05:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d1a2caa7-721d-4872-0a4d-08d97474d7e3
X-MS-TrafficTypeDiagnostic: SN6PR11MB3118:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB3118063BE1DE8CCE4120F92A93D69@SN6PR11MB3118.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:854;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hviVh2ntmZ/dg0iWO4aOYdDpTThrQnGQy5cspf4Xhx6izd625n8DopES0ovZrFZrHKq82JkKy4YsjbCpSxJ00GoFhmSZQ93BnnAJVLfNPQmbWdz6tt5D93oCczGvRjU+e+zj0me2YfpOWEeh/26lcaJ69EP5upyR76nshN/HSRveaaqGWEPWx5tUWCwRcrW2OMVRiNuE5CSqLKfRZZ6E+C2xw2xem5C4XljWj9M3wlzdxyq5tag6y1sdKoJ8g2d8X/ylSj0rrkOBgkwOkYGe45mGoE3BVKzVlqE+sfj8pufw8Rgb7VkiMuSgNPeJsN0vnITlcyjMb9v5QZmj0bOzQzSlJ6FjBiNImojiiVgeyOTulZ19mgnwMqW5EDgkJnHuRMYtWv2pXXJC5G3jfLFMcZsW4cdaH8qJyLqbHrIUMD8Ind2uR/rUmX21JZwQxKHEkUJiMHzIRF7KGjJishm6HeIoqYzULPiqYmVSEegmWPLl3UitMXhELRVAIrRU76GfeYYt6mXXJyJJipozrJVgUisIx2i6+EBAAhKrHqVeLTtgNdAV6bVlMIpVKa/lk0PetGiygckNdNtgYw8Ag0lElPUgcD06361I1W5T7cLK2GLdc+93zni4VVlYJViPPhUcpyYXsUlr7lCtaV/v3pLq7A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(376002)(346002)(39850400004)(396003)(4326008)(66476007)(107886003)(36756003)(186003)(316002)(6486002)(66556008)(8676002)(6666004)(86362001)(2906002)(54906003)(38100700002)(83380400001)(8936002)(66574015)(5660300002)(66946007)(1076003)(2616005)(52116002)(7696005)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L0hyYU90SGRBZkZQS2J0b2VxdDJhRkp6YWVPU0R1cU85OEZGcVU2SmhYRk14?=
 =?utf-8?B?dld3dGN3OHd0QlFnNnBTeUFHcXR6K0NGZmRmZlBWb2RaM3djd2VwL1dXL21G?=
 =?utf-8?B?QmNsQXQ5UlNjT3k0YjNtK2xuTHRDNWlHYVVEQ3ExWGwzQk5EVDBkcmhBTTYx?=
 =?utf-8?B?VklTQ1VIU0MrdWtTbllEQWVGeUJYMlJTbWFKNGEvS21IL1dJMWxNNmx5a3pv?=
 =?utf-8?B?OGo5cVNCSUZZMWtTMFcxS0pEOHQwaVlwY1JJWmxCMytUTWpRRi8wNlQxWGdU?=
 =?utf-8?B?NE5wa2NUMFVWQ2VkOGFmNlBXempOcGZMNmIvNWsyejFDbTlwSG1mWEQ1QU9B?=
 =?utf-8?B?UVUzV1JMZHlEaEVIWEYrZ2FpdDN4RFNralZ4dDdXNmUyZURYNldQTTVjVGcw?=
 =?utf-8?B?bWlNcFoxbnhPaEJqWHIvS01lazduS296aFE4MExSWVJNalNSaG1icUdpYWpG?=
 =?utf-8?B?Y24wb2x1dWdDUmRCNzJrM2hFYlkybzU3QnZTZ1pWbEJ5R2VTdmRrUUo0ZHk1?=
 =?utf-8?B?U2pZVktQQWo3SGFYWEQveVV6d21UMmkwVG5IaXNjZG9reHFNR1Nua2Iwc1Bh?=
 =?utf-8?B?TkNkSE9oQmRPdWdiT0kyakdmMnRiVlVnL0YxdGFXNHN1aTZtUStiWEJyL2tM?=
 =?utf-8?B?bmN3aW1rNmdUbENWZTh3aHFaNDNwWS9HVkhHUlFwRFVyQ2VUMjZFaFFETE5P?=
 =?utf-8?B?R1F5VndpM25iZkJmaEw3VUFqUmw2b0ZXdVMyV3NBclVpYXRTOHd6eEkzMG1m?=
 =?utf-8?B?VnQ1NUJSRDgrZFhXNE1RWmYvYzV3Mks5eVFVTnYyaEozS2xCT2gzVXZqQWZK?=
 =?utf-8?B?UGhnUW9DWUtuRTNyQUxUUUJ0ckVNZWNaRU9IUmpnTy8rZGZsRlcxdVpERGU3?=
 =?utf-8?B?MDBqdmw3MGU5T1ZCemxsSEdacDAzRjBNRDNxS2d4eWV2ZkZ5KzhMdndHVnJU?=
 =?utf-8?B?TWVqN09NNjhNYk43WFdJd1NzTlJmQjlsRTRhaVZ6b2dyUXVLMHVsM1YxK0hW?=
 =?utf-8?B?NWtMbDJmODBTTXVSbEFRYTR3d1RGNzBSVkhad0VlcStzRjFITzJjZGFpSlN5?=
 =?utf-8?B?ek1WRmt2UkdBR3NGTjNrOWRnelFLQ1hrU0JPSzVVc2E1OFRraUlDY2hxVU9I?=
 =?utf-8?B?TXR1Q2ZtdXFqZzkzRlRlTDJzNTZkZzN1UndCV3hnblNhVzZ3TXA0cURBT3My?=
 =?utf-8?B?Mnl5aDRRZUFTVWloYWJrLzZBU3BrWUFIRW44aExIeksxZlNGSWU3QWJkVXBt?=
 =?utf-8?B?SHphVWFWSTB1ckxMbUZTNFFXTXlpN051VlJXdlVUMDJ6cWE1MlZmTkQ3OWY1?=
 =?utf-8?B?ejVlZ0NlSGVTQk4rZEdxK2VYWFZWY3Rxc1FEV1RBN0NLUGJPckNwdklFbGVm?=
 =?utf-8?B?WXdoSnk4YVJXdmw5ZUI3cE9COU5SUW5YUHZLazhETjdzelpSNTRmZTR1RjQz?=
 =?utf-8?B?VVJCc1MxMGJVZW9UMzhTQmQrTmZVQ09BUk80OE9VQTVhUVNXZFhUQmYxdVI3?=
 =?utf-8?B?enhnNitRZFZaUUlTTWd6N0UxSCtYWHhrb3NMWDd5dCtsa1JsQytPZlp2SUdr?=
 =?utf-8?B?ZnIybjdHMjI4WHlVdVYveGVEU0Z6bVJWNTFRY3J5QmNxUjVnVFFUZXM5VmVZ?=
 =?utf-8?B?Z3hDRkpiK1lHVms5NEF3bHc4QklVclc2V1kyMS92SWRlSXdBaVMrVjdPVU52?=
 =?utf-8?B?UDY2T2dMV2NaelVSZVZPUGxST2FtdjQ3WlVLc1E3WDcwQmViZk9OQlk4RXRw?=
 =?utf-8?B?eDhXZENETUNQUkRpY1UvUzhaQ2FWWDUxZStZVTlORi9BL3ZOVFdNdDJGSDRN?=
 =?utf-8?B?UXZ5WFNzbVhkY3hCTDV2Y2ZSQzVXYkdySGR0TmUwT3l5ZlB4UUY0YWUxNjFD?=
 =?utf-8?Q?I/m4BgTaPNi2W?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1a2caa7-721d-4872-0a4d-08d97474d7e3
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2021 16:05:43.9983
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uGsgiK2SxAmiMJNQebAOnl+vjuk9/kaoERBLaov9NbOg/0FBrsuuxpYL6TsxWtNFWkNzDNGRJalmsQ5i1thYMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3118
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSXQg
aXMgbm8gbW9yZSBuZWNlc3NhcnkgdG8gY29tcHV0ZSB0aGUgZXhwZWN0ZWQgZHVyYXRpb24gb2Yg
dGhlIHNjYW4KcmVxdWVzdC4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJv
bWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5j
IHwgOSArLS0tLS0tLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4LmggfCAyICstCiBkcml2
ZXJzL3N0YWdpbmcvd2Z4L3NjYW4uYyAgIHwgMiArLQogMyBmaWxlcyBjaGFuZ2VkLCAzIGluc2Vy
dGlvbnMoKyksIDEwIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93
ZngvaGlmX3R4LmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5jCmluZGV4IDYzYjQzNzI2
MWViNy4uMTRiN2UwNDc5MTZlIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90
eC5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4LmMKQEAgLTIyNywxNCArMjI3LDEz
IEBAIGludCBoaWZfd3JpdGVfbWliKHN0cnVjdCB3ZnhfZGV2ICp3ZGV2LCBpbnQgdmlmX2lkLCB1
MTYgbWliX2lkLAogfQogCiBpbnQgaGlmX3NjYW4oc3RydWN0IHdmeF92aWYgKnd2aWYsIHN0cnVj
dCBjZmc4MDIxMV9zY2FuX3JlcXVlc3QgKnJlcSwKLQkgICAgIGludCBjaGFuX3N0YXJ0X2lkeCwg
aW50IGNoYW5fbnVtLCBpbnQgKnRpbWVvdXQpCisJICAgICBpbnQgY2hhbl9zdGFydF9pZHgsIGlu
dCBjaGFuX251bSkKIHsKIAlpbnQgcmV0LCBpOwogCXN0cnVjdCBoaWZfbXNnICpoaWY7CiAJc2l6
ZV90IGJ1Zl9sZW4gPQogCQlzaXplb2Yoc3RydWN0IGhpZl9yZXFfc3RhcnRfc2Nhbl9hbHQpICsg
Y2hhbl9udW0gKiBzaXplb2YodTgpOwogCXN0cnVjdCBoaWZfcmVxX3N0YXJ0X3NjYW5fYWx0ICpi
b2R5ID0gd2Z4X2FsbG9jX2hpZihidWZfbGVuLCAmaGlmKTsKLQlpbnQgdG1vX2NoYW5fZmcsIHRt
b19jaGFuX2JnLCB0bW87CiAKIAlXQVJOKGNoYW5fbnVtID4gSElGX0FQSV9NQVhfTkJfQ0hBTk5F
TFMsICJpbnZhbGlkIHBhcmFtcyIpOwogCVdBUk4ocmVxLT5uX3NzaWRzID4gSElGX0FQSV9NQVhf
TkJfU1NJRFMsICJpbnZhbGlkIHBhcmFtcyIpOwpAQCAtMjY5LDEyICsyNjgsNiBAQCBpbnQgaGlm
X3NjYW4oc3RydWN0IHdmeF92aWYgKnd2aWYsIHN0cnVjdCBjZmc4MDIxMV9zY2FuX3JlcXVlc3Qg
KnJlcSwKIAkJYm9keS0+bnVtX29mX3Byb2JlX3JlcXVlc3RzID0gMjsKIAkJYm9keS0+cHJvYmVf
ZGVsYXkgPSAxMDA7CiAJfQotCXRtb19jaGFuX2JnID0gbGUzMl90b19jcHUoYm9keS0+bWF4X2No
YW5uZWxfdGltZSkgKiBVU0VDX1BFUl9UVTsKLQl0bW9fY2hhbl9mZyA9IDUxMiAqIFVTRUNfUEVS
X1RVICsgYm9keS0+cHJvYmVfZGVsYXk7Ci0JdG1vX2NoYW5fZmcgKj0gYm9keS0+bnVtX29mX3By
b2JlX3JlcXVlc3RzOwotCXRtbyA9IGNoYW5fbnVtICogbWF4KHRtb19jaGFuX2JnLCB0bW9fY2hh
bl9mZykgKyA1MTIgKiBVU0VDX1BFUl9UVTsKLQlpZiAodGltZW91dCkKLQkJKnRpbWVvdXQgPSB1
c2Vjc190b19qaWZmaWVzKHRtbyk7CiAKIAl3ZnhfZmlsbF9oZWFkZXIoaGlmLCB3dmlmLT5pZCwg
SElGX1JFUV9JRF9TVEFSVF9TQ0FOLCBidWZfbGVuKTsKIAlyZXQgPSB3ZnhfY21kX3NlbmQod3Zp
Zi0+d2RldiwgaGlmLCBOVUxMLCAwLCBmYWxzZSk7CmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdp
bmcvd2Z4L2hpZl90eC5oIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHguaAppbmRleCAzNTIx
YzU0NWFlNmIuLjQ2ZWVkNmNmYTI0NyAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9o
aWZfdHguaAorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5oCkBAIC00MCw3ICs0MCw3
IEBAIGludCBoaWZfcmVhZF9taWIoc3RydWN0IHdmeF9kZXYgKndkZXYsIGludCB2aWZfaWQsIHUx
NiBtaWJfaWQsCiBpbnQgaGlmX3dyaXRlX21pYihzdHJ1Y3Qgd2Z4X2RldiAqd2RldiwgaW50IHZp
Zl9pZCwgdTE2IG1pYl9pZCwKIAkJICB2b2lkICpidWYsIHNpemVfdCBidWZfc2l6ZSk7CiBpbnQg
aGlmX3NjYW4oc3RydWN0IHdmeF92aWYgKnd2aWYsIHN0cnVjdCBjZmc4MDIxMV9zY2FuX3JlcXVl
c3QgKnJlcTgwMjExLAotCSAgICAgaW50IGNoYW5fc3RhcnQsIGludCBjaGFuX251bSwgaW50ICp0
aW1lb3V0KTsKKwkgICAgIGludCBjaGFuX3N0YXJ0LCBpbnQgY2hhbl9udW0pOwogaW50IGhpZl9z
dG9wX3NjYW4oc3RydWN0IHdmeF92aWYgKnd2aWYpOwogaW50IGhpZl9qb2luKHN0cnVjdCB3Znhf
dmlmICp3dmlmLCBjb25zdCBzdHJ1Y3QgaWVlZTgwMjExX2Jzc19jb25mICpjb25mLAogCSAgICAg
c3RydWN0IGllZWU4MDIxMV9jaGFubmVsICpjaGFubmVsLCBjb25zdCB1OCAqc3NpZCwgaW50IHNz
aWRsZW4pOwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zY2FuLmMgYi9kcml2ZXJz
L3N0YWdpbmcvd2Z4L3NjYW4uYwppbmRleCA2OTViMDY5NzQxOTQuLjllMmQwODMxN2M5ZSAxMDA2
NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zY2FuLmMKKysrIGIvZHJpdmVycy9zdGFnaW5n
L3dmeC9zY2FuLmMKQEAgLTU2LDcgKzU2LDcgQEAgc3RhdGljIGludCBzZW5kX3NjYW5fcmVxKHN0
cnVjdCB3ZnhfdmlmICp3dmlmLAogCXdmeF90eF9sb2NrX2ZsdXNoKHd2aWYtPndkZXYpOwogCXd2
aWYtPnNjYW5fYWJvcnQgPSBmYWxzZTsKIAlyZWluaXRfY29tcGxldGlvbigmd3ZpZi0+c2Nhbl9j
b21wbGV0ZSk7Ci0JcmV0ID0gaGlmX3NjYW4od3ZpZiwgcmVxLCBzdGFydF9pZHgsIGkgLSBzdGFy
dF9pZHgsIE5VTEwpOworCXJldCA9IGhpZl9zY2FuKHd2aWYsIHJlcSwgc3RhcnRfaWR4LCBpIC0g
c3RhcnRfaWR4KTsKIAlpZiAocmV0KSB7CiAJCXdmeF90eF91bmxvY2sod3ZpZi0+d2Rldik7CiAJ
CXJldHVybiAtRUlPOwotLSAKMi4zMy4wCgo=
