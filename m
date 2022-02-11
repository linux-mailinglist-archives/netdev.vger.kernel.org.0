Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67AD24B2A40
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 17:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351485AbiBKQ1e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 11:27:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244754AbiBKQ1b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 11:27:31 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2061.outbound.protection.outlook.com [40.107.93.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E81673AD;
        Fri, 11 Feb 2022 08:27:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XuWw+/G/4GRpJqsdnzqDYNq/8Xtb5VV6/KbBccK4Fo/UwaJPWmSDNtYSoN2MQDcEb9cdu8WO9hf/lOn+6X2vFNIvgyXkvpC1BYEZphp6Gu0fzNu2feuDYAcPydwDARP9je2r86xXkB6BWTTs5pXm4lf58ISS+iuwBwdb+GpCPizz6sk4xL785IjQ2lsniCVclJIrQMcJh1ct7Q3F+GjprRdzDrPKB6NaR/qD9zUZO8KHVrmVCwCwnKp7ToILC/kgr04MbM9TgVZ0cRJW3dCNAkQ1d6f+dhCIeDhJbdV4XuD7ghWXaYb/v5PaTDnCxL6kEkdYj2pQ0RZq4RHO81T5xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ibk/kM2hv1xuMO3ECky+UxpNOgQUtmLFvrvHG3f0dCg=;
 b=OHhKuCenpvoqsqzttOpL6zmdYbrVfhCjxG82oECW7+5f5QJK2kF2oa32z3mhjhYNDdDYPqrCb246/3Ttm1mXPTgIEzYnWg+edFkxJuVW42Juey85WmoUD0QOnpjSN4slkcViZ5u8D78KrsAIGvulS7yuAK7jdiL7yAOm5wgpAoJrwIItvxZbUDK7+NtOOaG2aDJMOhs+v+b+mA1S3kUXNuyvA6kakANvltuHNNPsa+hjtlAr+Hl9ILhNAmgZvCVUcD4m9JZGPcaJeY/1On6aa9XncVhnm2uWEdDrFMLAS/FPDCJT3cOiwwnVIqIogGgZgfB0xOqc/+fZR0YDlItrAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ibk/kM2hv1xuMO3ECky+UxpNOgQUtmLFvrvHG3f0dCg=;
 b=fw4R1OMoPJn/2m4XCidfRhzAcgq2l+eEnsbLiGOctJxZVANrTSiBRkc8G2u2ZhzUN/cu1OEg5Ul4tKoVglqa+B7Tr7vrXDDQ0C8yw9ZzCKYnxC/ZyaMrBFakAeJsWMBx1g9VI2Ki4mQGJU89ego6+SEWTZXEyZJmeilHbyYvwf8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by BN6PR1101MB2196.namprd11.prod.outlook.com (2603:10b6:405:52::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Fri, 11 Feb
 2022 16:27:28 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::1b3:e483:7396:1f98]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::1b3:e483:7396:1f98%3]) with mapi id 15.20.4975.014; Fri, 11 Feb 2022
 16:27:28 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 2/2] staging: wfx: remove support for legacy PDS format
Date:   Fri, 11 Feb 2022 17:26:59 +0100
Message-Id: <20220211162659.528333-3-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220211162659.528333-1-Jerome.Pouiller@silabs.com>
References: <20220211162659.528333-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR1P264CA0011.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:19e::16) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9038d393-6fb5-46a9-6538-08d9ed7b6525
X-MS-TrafficTypeDiagnostic: BN6PR1101MB2196:EE_
X-Microsoft-Antispam-PRVS: <BN6PR1101MB21960FC9F37750220D40F53193309@BN6PR1101MB2196.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xwuPgnub1sbs/eSyF2/8lPk1N0GARHJwAxpQaWk32uU0T19WHU6thjFxO2nmd6ZAq4Th4Onq4yYYrnEfwgBZ6vUMUzByCJ8tx6VSMzai6lz1Dt2hTEKqmzXi6Ysd/8WyYzDQ5H5kBu+PEyoBDquPSicTTlTuRPg8xswytnhIe3bbCOfsvdYCts4ucXaQSqU9dOymehvb5up5qYprZac62KCzdJMSTCl+hieansbt0xhctkRDXN8vaqliEup+0a0ZCMe8Ejeor7ph4SRdu8d37BYHmrWO4nSINX/WKb+YRxyeYBQzb82OjsaF4BveODAt2YTy9qR7/mUoiZbHSDH+MWOyMMeb4aVN0YIhlTb8SZGC9QSuqqjXqGCSsZlUFpGmCJH4YnzOH372w+NrLR4RE4FN23C/a/ntoCTgbgT7i9MKp8m9KhUho6XXRU+544uodaq8Y2pCVN0YIvFQIVUgqn37EsH4D0XeXZdb84ifsADo1x4ruKsj61MFU64UWt36n7qVGTJ4Wp3ahGDU6ywWODREy9m3quYVeUKRI4WKAeEdrDhKZwNB4AqZDk83siNDFFLELyrgawrWBxjennUxN8vhIZHWqq+cBL2F9Hmu8aRr0/ryrSEzTzdQkox2PkMKxtZaGJmLtTLVqdEgiKtBvGVY7Nov1dcDBVUGTyzkXdrJlBqoR7tEOPaYcjkQj62sVNOCaeoy+09NzxMnsJdseA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(26005)(86362001)(4326008)(36756003)(66476007)(83380400001)(508600001)(8936002)(66946007)(8676002)(66556008)(1076003)(2616005)(38100700002)(54906003)(38350700002)(6512007)(316002)(5660300002)(66574015)(52116002)(2906002)(6666004)(6506007)(6486002)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MDBnNFBCUEpEL0JGU0E0OEw5OEFhc3Noc3pOVmNsZE00S2poRmo4Zys5L2hu?=
 =?utf-8?B?Um52c3pibW9UZm15MTNwWCt0U05sMzFRWThTWXNFR2NkbzU0YmloNGRtQ2Jk?=
 =?utf-8?B?YjlpZG1pTzJPMVhKeTJaUk91L055WkU0NFcyZ3lkM2NVcG13eWhybWEycmpy?=
 =?utf-8?B?YXdkUmdIQVF5cTdReFoza0tnTkNaQkhsd3QzQW9YNnBvUnlHR2s5RFh6aEF3?=
 =?utf-8?B?a2wyRGFLVHJVdGZ3VHd4UkErRGhadVBKT2tTVzRIZjFjYUFtQk5JWThSSzAv?=
 =?utf-8?B?T0FyZXU1clF6K3JUMXkzcHMyNW1ZZVUzb3gvMTJGYzBaMk5rdjVmejRtN3px?=
 =?utf-8?B?dTVhRlU2TmJpVTNSM2RPcHE3TTBOS3ZOUXdWWDJoWGNBekRWcEovRlZ0NHE0?=
 =?utf-8?B?aW1HVkVNT1ViZ3diNWJINWlkWW9TR3dqaTFESGREL0hLMmNxQUU0OUg4cUVl?=
 =?utf-8?B?OWdVOER3c09wUlA2V0JjQmljNkJwYUk0ckZyMGs0Y2tNbWthQngvZ1hWbXlF?=
 =?utf-8?B?UUF3ZS9kNVR2U213Vjhhb2lqckdUZExDNVJZNHY0MS9zNitESE1odzV4QzYv?=
 =?utf-8?B?bTkxVUVLOW50OVdBOEd2ajZUbHI5Mkk3OUZIZjlvdVgwZTRDV0FkMDNDY3Rp?=
 =?utf-8?B?S3NXaDZzNnNQbWNGVWwrbGM1VnpTcE5BdS9TOEwrSTFUUkRXck9mN3NVWTJq?=
 =?utf-8?B?Tm9wWStFaGRMRkZIcldzZ3N3QmpCWTFPS2NQcnpvZkdEeDdWMGdxNXFhN3Bi?=
 =?utf-8?B?UGMraUVVMGdZVG0zZENxTEpYSFZkdTlHaTd0OUNVRkFLQk50VXJsdkYyMW9n?=
 =?utf-8?B?cUZrSUN4Y3pVTTJrSjFXZk84ZTcvRVJlb3JFU0MzR2hKbEdnS0hLYmlkTE5l?=
 =?utf-8?B?Y1NPNnV4RDl0UUlSeGwrVnpicFVuWVJtM2dhT3d0L0gxM2lRMnhkZUlyaTJk?=
 =?utf-8?B?emRsSkNFZERtQ0kwUG52MW5jN2ZFWk9uc2pEemtOTTFtSGlOa0pMdVduTDJV?=
 =?utf-8?B?T2JXeGNWNXRQWEVoQlNWRVNWekNQcEwxS1VoV04rT2NKSnNlZEt4YlBFbWFa?=
 =?utf-8?B?SzFNem1KcWZYcDRXcUJuRlRDUmduY0JDZlNmUlM4VlpPRENNMmUwc0FUVUlB?=
 =?utf-8?B?Rm42Wk1iL3pCb1Y3T1pwZTlETkY5OFhka3VmaXc1Uy9ONzhUMkZRdENIeXRS?=
 =?utf-8?B?L0VIYlV5R3pMTWd3Y2d4aXRLVmZYQk5kcGxRbmYrSXl3ZUJTUVY3L0RTZUF1?=
 =?utf-8?B?bm1MUnJxMDY5dkRwOHp2dGxpb3FPR08xU0E2M0JrdEtEL0NxQ2RwUHVvbHZC?=
 =?utf-8?B?a2pkemM1dlAyTm0zS1FXWFlBcXFxTUlNNStzZEN6UTlSUGxIZzk0bW1RTjQ3?=
 =?utf-8?B?d0p0dkoyWm5zblhaT0lmNTBLc1FJdUp6WHBqa0FjTWxWQW9NUDREb0dlNXU5?=
 =?utf-8?B?TEo0MU5ZWG1rek5tNjZ6dU9jb1Bkb2trNnBnUWplQXFrRlN3b1lQWFV4eE5a?=
 =?utf-8?B?OHM5YWU4d3YvZ3d4Q1RkZFVSS0NJUjRobCszZTQrZVFsME1icVJWbmhoYjhG?=
 =?utf-8?B?NXR0aEtGN2I1S0ROWHRvUDdVNHkrZXZadWxSWmJMZ2tFZzlIajE2TGpYSFkx?=
 =?utf-8?B?YnNiVFVFdnFhY1JEWjQ5UFNCaUpmVnZUSG1FeDVIa3R3dnA2cGhZVk1NRy9p?=
 =?utf-8?B?Ykc5eWpCRzFhNG4zR2JzR1ljeVA3RHFqWEtDR3NPNWFGZTEzVlhPY2srVm5U?=
 =?utf-8?B?YmUvQWRUeVNkR0ZhbE9uVCs5KzhZOUd4WnN1aHJ3ZzdMU29nZkw0R2NwNkFx?=
 =?utf-8?B?Kzl5VkhYL3FMK0xGOXBQRHFFdi9nOFh5UFB0SjlnUE5BdVlvRjg4TlhENzM5?=
 =?utf-8?B?REhGL2J0MGY1bFFxbmRVWjhmOTJxL3hsRnBqUGpLSE0yekZNOXVOcDBGbThh?=
 =?utf-8?B?ZDVSckcyWUJML1Njc2p4Sy9tVnE1S1RjYURPSDZacVpmcWwvSWd2SGFvMm8x?=
 =?utf-8?B?V3c3TVg3UFQ4M2RLZ3NpMFFkZFk1V1d5dVpvVlpqaHNWRWdLN3p3L3pqUWtV?=
 =?utf-8?B?ZzJrRGJvQXZibUs1eDdPaUNnNXk5UnlMTkFZT2J3UHJ3aURTb1ZMams3YTFL?=
 =?utf-8?B?MzA3SHdvQk96dzdIR08zeklubHNjYTI2aXZRMlBSMmZjOFVlR1d1Z1AxYWo3?=
 =?utf-8?Q?DXEfvjE4KXzmzMtIyaKvN6o=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9038d393-6fb5-46a9-6538-08d9ed7b6525
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2022 16:27:28.4751
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gKhEV0/cV+66CfpABHmU1cGhzInqhpzZrAMVEaUspZVzJ/Hr+UfMBpoBscH4qe5DsQxD0Ckjzgsa1cq81Esscg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2196
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKV2Ug
ZG9uJ3Qgd2FudCB0byBzdXBwb3J0IGxlZ2FjeSBQRFMgZm9ybWF0LgoKU2lnbmVkLW9mZi1ieTog
SsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZl
cnMvc3RhZ2luZy93ZngvbWFpbi5jIHwgNTUgKysrLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDUxIGRlbGV0aW9ucygt
KQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvbWFpbi5jIGIvZHJpdmVycy9zdGFn
aW5nL3dmeC9tYWluLmMKaW5kZXggYTBmNWUwOWMzYzNmLi4wZGRjNjdiNTY1ODkgMTAwNjQ0Ci0t
LSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvbWFpbi5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngv
bWFpbi5jCkBAIC0xNjMsNTUgKzE2Myw2IEBAIGJvb2wgd2Z4X2FwaV9vbGRlcl90aGFuKHN0cnVj
dCB3ZnhfZGV2ICp3ZGV2LCBpbnQgbWFqb3IsIGludCBtaW5vcikKIAlyZXR1cm4gZmFsc2U7CiB9
CiAKLS8qIEluIGxlZ2FjeSBmb3JtYXQsIHRoZSBQRFMgZmlsZSBpcyBvZnRlbiBiaWdnZXIgdGhh
biBSeCBidWZmZXJzIG9mIHRoZSBjaGlwLCBzbyBpdCBoYXMgdG8gYmUgc2VudAotICogaW4gbXVs
dGlwbGUgcGFydHMuCi0gKgotICogSW4gYWRkLCB0aGUgUERTIGRhdGEgY2Fubm90IGJlIHNwbGl0
IGFueXdoZXJlLiBUaGUgUERTIGZpbGVzIGNvbnRhaW5zIHRyZWUgc3RydWN0dXJlcy4gQnJhY2Vz
IGFyZQotICogdXNlZCB0byBlbnRlci9sZWF2ZSBhIGxldmVsIG9mIHRoZSB0cmVlIChpbiBhIEpT
T04gZmFzaGlvbikuIFBEUyBmaWxlcyBjYW4gb25seSBiZWVuIHNwbGl0Ci0gKiBiZXR3ZWVuIHJv
b3Qgbm9kZXMuCi0gKi8KLWludCB3Znhfc2VuZF9wZHNfbGVnYWN5KHN0cnVjdCB3ZnhfZGV2ICp3
ZGV2LCB1OCAqYnVmLCBzaXplX3QgbGVuKQotewotCWludCByZXQ7Ci0JaW50IHN0YXJ0ID0gMCwg
YnJhY2VfbGV2ZWwgPSAwLCBpOwotCi0JZm9yIChpID0gMTsgaSA8IGxlbiAtIDE7IGkrKykgewot
CQlpZiAoYnVmW2ldID09ICd7JykKLQkJCWJyYWNlX2xldmVsKys7Ci0JCWlmIChidWZbaV0gPT0g
J30nKQotCQkJYnJhY2VfbGV2ZWwtLTsKLQkJaWYgKGJ1ZltpXSA9PSAnfScgJiYgIWJyYWNlX2xl
dmVsKSB7Ci0JCQlpKys7Ci0JCQlpZiAoaSAtIHN0YXJ0ICsgMSA+IFdGWF9QRFNfTUFYX0NIVU5L
X1NJWkUpCi0JCQkJcmV0dXJuIC1FRkJJRzsKLQkJCWJ1ZltzdGFydF0gPSAneyc7Ci0JCQlidWZb
aV0gPSAwOwotCQkJZGV2X2RiZyh3ZGV2LT5kZXYsICJzZW5kIFBEUyAnJXN9J1xuIiwgYnVmICsg
c3RhcnQpOwotCQkJYnVmW2ldID0gJ30nOwotCQkJcmV0ID0gd2Z4X2hpZl9jb25maWd1cmF0aW9u
KHdkZXYsIGJ1ZiArIHN0YXJ0LAotCQkJCQkJICAgIGkgLSBzdGFydCArIDEpOwotCQkJaWYgKHJl
dCA+IDApIHsKLQkJCQlkZXZfZXJyKHdkZXYtPmRldiwgIlBEUyBieXRlcyAlZCB0byAlZDogaW52
YWxpZCBkYXRhICh1bnN1cHBvcnRlZCBvcHRpb25zPylcbiIsCi0JCQkJCXN0YXJ0LCBpKTsKLQkJ
CQlyZXR1cm4gLUVJTlZBTDsKLQkJCX0KLQkJCWlmIChyZXQgPT0gLUVUSU1FRE9VVCkgewotCQkJ
CWRldl9lcnIod2Rldi0+ZGV2LCAiUERTIGJ5dGVzICVkIHRvICVkOiBjaGlwIGRpZG4ndCByZXBs
eSAoY29ycnVwdGVkIGZpbGU/KVxuIiwKLQkJCQkJc3RhcnQsIGkpOwotCQkJCXJldHVybiByZXQ7
Ci0JCQl9Ci0JCQlpZiAocmV0KSB7Ci0JCQkJZGV2X2Vycih3ZGV2LT5kZXYsICJQRFMgYnl0ZXMg
JWQgdG8gJWQ6IGNoaXAgcmV0dXJuZWQgYW4gdW5rbm93biBlcnJvclxuIiwKLQkJCQkJc3RhcnQs
IGkpOwotCQkJCXJldHVybiAtRUlPOwotCQkJfQotCQkJYnVmW2ldID0gJywnOwotCQkJc3RhcnQg
PSBpOwotCQl9Ci0JfQotCXJldHVybiAwOwotfQotCiAvKiBUaGUgZGV2aWNlIG5lZWRzIGRhdGEg
YWJvdXQgdGhlIGFudGVubmEgY29uZmlndXJhdGlvbi4gVGhpcyBpbmZvcm1hdGlvbiBpbiBwcm92
aWRlZCBieSBQRFMKICAqIChQbGF0Zm9ybSBEYXRhIFNldCwgdGhpcyBpcyB0aGUgd29yZGluZyB1
c2VkIGluIFdGMjAwIGRvY3VtZW50YXRpb24pIGZpbGVzLiBGb3IgaGFyZHdhcmUKICAqIGludGVn
cmF0b3JzLCB0aGUgZnVsbCBwcm9jZXNzIHRvIGNyZWF0ZSBQRFMgZmlsZXMgaXMgZGVzY3JpYmVk
IGhlcmU6CkBAIC0yMjMsOCArMTc0LDEwIEBAIGludCB3Znhfc2VuZF9wZHNfbGVnYWN5KHN0cnVj
dCB3ZnhfZGV2ICp3ZGV2LCB1OCAqYnVmLCBzaXplX3QgbGVuKQogewogCWludCByZXQsIGNodW5r
X3R5cGUsIGNodW5rX2xlbiwgY2h1bmtfbnVtID0gMDsKIAotCWlmICgqYnVmID09ICd7JykKLQkJ
cmV0dXJuIHdmeF9zZW5kX3Bkc19sZWdhY3kod2RldiwgYnVmLCBsZW4pOworCWlmICgqYnVmID09
ICd7JykgeworCQlkZXZfZXJyKHdkZXYtPmRldiwgIlBEUzogbWFsZm9ybWVkIGZpbGUgKGxlZ2Fj
eSBmb3JtYXQ/KVxuIik7CisJCXJldHVybiAtRUlOVkFMOworCX0KIAl3aGlsZSAobGVuID4gMCkg
ewogCQljaHVua190eXBlID0gZ2V0X3VuYWxpZ25lZF9sZTE2KGJ1ZiArIDApOwogCQljaHVua19s
ZW4gPSBnZXRfdW5hbGlnbmVkX2xlMTYoYnVmICsgMik7Ci0tIAoyLjM0LjEKCg==
