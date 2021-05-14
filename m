Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8F86380C10
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 16:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234523AbhENOnc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 10:43:32 -0400
Received: from mx0a-002c1b01.pphosted.com ([148.163.151.68]:50684 "EHLO
        mx0a-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231792AbhENOnb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 10:43:31 -0400
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14EEfn7a029973;
        Fri, 14 May 2021 07:42:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=proofpoint20171006; bh=uqNIZ8H22c5cpHy94t6pRtSNxvOyiSk1Iy1l60Q+f/w=;
 b=IJvu8EzUMisEsl6qSQj4csHvsBKYOm+eK/WGP+seh24HTDtgi3GhkLqItT4ybz6DIIDq
 RO0z3VNG1rrcTFw1iwHcjoLkaQZ+PgWxL7kbtZPb/kN2qpwP9rVptzxRT4kJ/YA4/tjE
 qpci+JlpqZCbDmlmNummcJAkLdTOKffB+UNo3jFP3OiEQpiDDyAuXJlxFyiUeQLtbrEC
 hWzXnS8B0i9q0MADEoLRBGvRxnXdU/SKjF1bOOEWtRVpJEKbtzVYsb8c7lwvgIYRHy50
 XPtbtmph1qtO//XAsTL/K1XWE5IS++iB7NvZCuFIesngGn9S59T3fN8otSLWKE4l6RTd nA== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by mx0a-002c1b01.pphosted.com with ESMTP id 38hrddg9e7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 May 2021 07:42:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VeV3l4uxojtYcCSvUFHq1MgQXZWLFbCHLhjndccYu4aM1R8kGWKeoZW1UdrUzx9m4mWmJgpgg7mFmaQI24RZUwjbECPiXmMHUKMM5cQ9qRVGKP7O/qs4N1UMDHhhP/mlwQs1CvRjUStoLa5RAisDiw4VK2WxUChKYzKhc+ANOxl+mmSzd5mNF6b2OHaJM6nfr/kjSuDXjRsznNCh9nZ8JlcMwI2wgLD02aULo+gQGCsoVZG2XCtyLNGlbc7cRqlP/9TH8tJkhWLN/0CdyL+PTvxe3kij0xYsxc/1QZSzKCZ05YsjaZt458h/9GB2rz+3VlfKrcROXUL5phijF3zELg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uqNIZ8H22c5cpHy94t6pRtSNxvOyiSk1Iy1l60Q+f/w=;
 b=Vg1NeQ5LM9IE4i5sUbVN0XPo9768ZZMpVEuRCB2P301LReJRW7voADlzGYFukAYlNcWd9JQ+/jUKCmNgJ5ehFpXxTzHWrRPDQAYjCd9xMsBp+sNpixjmDjcSMgljVlaQxl8ZehwI+Rm41Op2CzInkHSKaQBxUz9Qqi8sBcEu0q4HmkrDczG0GxNWH43AwC1JUeEylv276HR2jnCrK/N9vxdQ7IWfFyrL2uHTm6Y4nhncuEOh7HZAzziZZezsh/uSx1tLWRlO6Y2sfV/G33iHHJDCiYfHtUMxRuWlbHgbfGvJWZ4V1RN7MEvtYvwg1NOLYnFDzieDf19t8B2Cfqsasw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Authentication-Results: neukum.org; dkim=none (message not signed)
 header.d=none;neukum.org; dmarc=none action=none header.from=nutanix.com;
Received: from CO6PR02MB7716.namprd02.prod.outlook.com (2603:10b6:303:b2::23)
 by MW4PR02MB7378.namprd02.prod.outlook.com (2603:10b6:303:75::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Fri, 14 May
 2021 14:42:12 +0000
Received: from CO6PR02MB7716.namprd02.prod.outlook.com
 ([fe80::b85b:11cb:30e1:3b32]) by CO6PR02MB7716.namprd02.prod.outlook.com
 ([fe80::b85b:11cb:30e1:3b32%7]) with mapi id 15.20.4129.026; Fri, 14 May 2021
 14:42:12 +0000
From:   Jonathan Davies <jonathan.davies@nutanix.com>
To:     Oliver Neukum <oliver@neukum.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, trivial@kernel.org,
        Jonathan Davies <jonathan.davies@nutanix.com>
Subject: [PATCH] net: cdc_eem: fix URL to CDC EEM 1.0 spec
Date:   Fri, 14 May 2021 14:41:01 +0000
Message-Id: <20210514144101.78912-1-jonathan.davies@nutanix.com>
X-Mailer: git-send-email 2.9.3
Content-Type: text/plain
X-Originating-IP: [192.146.154.247]
X-ClientProxiedBy: BY5PR17CA0035.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::48) To CO6PR02MB7716.namprd02.prod.outlook.com
 (2603:10b6:303:b2::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from nutanix.com (192.146.154.247) by BY5PR17CA0035.namprd17.prod.outlook.com (2603:10b6:a03:1b8::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Fri, 14 May 2021 14:42:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 78b3b934-ada4-4535-7159-08d916e67552
X-MS-TrafficTypeDiagnostic: MW4PR02MB7378:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW4PR02MB7378DF3D3A511FD80261971DCB509@MW4PR02MB7378.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: blwrb+WW9Z6UhRgO2xbPoMdfKjmKJkpn66U8OLa2hp/yGShVEnDaUjzhmc+Wzs/0/J0LgNxT9nZiWR+eitv+diPYdTBbeJGBAUWIe11uKdybp2vcYZHT0VwzfctS+NsMcKdB/fiCF0jk7Yysbw4odX9n/RpdRievCa0Wmmvvz/GCMB0lqRNudkrIv+wiJFBBGQw9XcP+wXXdlbXudBq5Aj1pQQR1jxyQZ+hdTSgxZz4xd1eDDRmWGre79779hALp6g24nq9Bqn4M1j0SdTDcesUsYewtpCl7GgHfkVevMFq9BJzJHZpufIe6yPzj9mY4HSi9EbIv0uCg+ifNolYMQ1mapzBtty08lMZViqIalPGwu5vDjOJq2X70qabLOF/NizQ1TL3kN49V5VBti6XT38QHK0MoXnrzSTPXLo/0IXDbzPL4qIE5ctBoompsg7aBHfA8lDLORzD20euwlDlzx69Cfw6lha0261c+1p0Jzt9UvpnVx1fjOvXQ4fVa19LK/MW46au3ydZFSNRU+metdKGVuuB4R4THJPEaZJ8BhU9cnTlBMrmr5DjR4JYTafxnORxus3Wv1z1xDfaQGxV7+HGhbQ1T9qD7J5A+I2BocMtHR4JZ/cZuwxbSGariDU8bi+0YMsbD8ZV2GuBv6tczNx3Mwpr/gGatsBiCp4R9VoT61UoIkyk1YsBuLHZMJySCgNC6AamRW8FbjZZoOdl2pbklv2+WldUkiKG738JfPBM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7716.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(39850400004)(396003)(136003)(376002)(44832011)(4744005)(956004)(2616005)(5660300002)(36756003)(8676002)(478600001)(966005)(110136005)(107886003)(55016002)(316002)(8936002)(7696005)(83380400001)(66476007)(38100700002)(38350700002)(4326008)(26005)(15974865002)(6666004)(66556008)(66946007)(52116002)(2906002)(186003)(1076003)(16526019)(8886007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Z/oxneN+0QtaxjEivo1K7oXGrFEgAxp0y32HHJ+RQOsv9AkoQw5htq91cXaS?=
 =?us-ascii?Q?O0zGxYSSAJRdyoCjl37FWTQiBZduNGfBPXX5VrUnOEGTgFEdXoxLo7LUhZAo?=
 =?us-ascii?Q?ERKoMs4t0YMfV0A3YWK8YbpzV7vYLjJjM6H7w5cp9liLwcmMrCREywm6XhNc?=
 =?us-ascii?Q?g4X9AiLsOizw6VBWeEQWW6Es481DkSpfjFRTY2c7rCNRlbj44bdWziJ/9rvJ?=
 =?us-ascii?Q?4MzD6kWfzBNNLTpyqE9iGQ5NYMBk5lx9C4kXskdv4F5COdFXJ7Yb9w4XQLXd?=
 =?us-ascii?Q?B0Teg8OT6BA8G2KrmTJQObCytMdaiTSFvhhvLbE78AAuAPFX8eBIBe7cb9xg?=
 =?us-ascii?Q?zWhu4O5R0ytBW+u4ngUu1FNF0sPe3IJqa7pNq6CyPQFn1Aq6LymC0h0OYrtI?=
 =?us-ascii?Q?Oql3JxepS1Wy6quBWOXGrE7A9L5yrBq+e6LuN4JdcQhXI2AEt9PErDiVbaBN?=
 =?us-ascii?Q?BgcWQk8Q+Lj6DuDxfaId0J7ALZWu7kHrUymCf9JjfqVX8h3AVZ7O7s3WvOYo?=
 =?us-ascii?Q?Bn58A0Sq1jaGl/M6Hntd75Jk4fzSEqRhG4YIfrH4pCbvFgQOblnSr2FmUZk2?=
 =?us-ascii?Q?ZXtgnb1AX97x2rY5gJ5E5hOM3Sqfx4DR7YVH5qkgTAajN2kRZ145x1rnHiew?=
 =?us-ascii?Q?YV1FsHzRAcd3KRjARepa0zlp4+NY+Qh0nxAd9WdzrkE7KmZPXViHqo/V3PB7?=
 =?us-ascii?Q?Js2bhCtqBbi187z5foC47/hLXqWkAUlCKOlefs/PaCcqUDeDZOpcU6AY4SXM?=
 =?us-ascii?Q?rrgkDBmcJWLiORekdM0BgPimzqpV8mZOgH+5QhR0L8JXceG0J56cLNlZI61F?=
 =?us-ascii?Q?mm/g2cDJ8UdpMPjA0ycyfvd4XhOxwEDgiX4U5UgKThIcg3l+fPjyLlvPoZjY?=
 =?us-ascii?Q?PfYCuktVAc2/YcZrw4Khh3fs9Tpi8oIom4bSKQG/5IWUDZQEyKft7qCDonSk?=
 =?us-ascii?Q?JHEo82B0rX4beYtcfZyP6HgcMnTQSuz9ZLlGj+TygcuGOcuCbNi2rkO6fpht?=
 =?us-ascii?Q?HX8AGePqR6HgMgAJoh7615vxoKzN3fqj5oSkzxubTZ3R8Idf+ayElkg/HOXs?=
 =?us-ascii?Q?mEvbNz02eRGemO0PBBD9MAfqGutvoFf6Kty1flJFbNVH6Rin9vL4IJ3CP1gq?=
 =?us-ascii?Q?+cm+GckKVs5ZEjpZvhOfefuzQESUs6+nZkK0aQ7Z/YrhKXsT9+j2o4EJip2F?=
 =?us-ascii?Q?ZRwChmu3f2qLd4lw2JzxUSayf5XGByhgcCcz38k9B6xU8Ae2i3CTYQ55xhay?=
 =?us-ascii?Q?7M6CNwSVtsH9RygLaR0RBv1LY7FoeQL9eZ//9lbI+oA796da6BmGrEHP7xye?=
 =?us-ascii?Q?qoJPuvqSy7Dg68dLxRyS83dk?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78b3b934-ada4-4535-7159-08d916e67552
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7716.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2021 14:42:11.8492
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eYSBWc9jo6IfP1e5o+7yRv4uZq17Q0bm41KnwW+hTyhUYWSwceM6pcl8E+RVVtyIeRxcuzqJRYxaxx6kxwHylWIK7Bk5V86iVudeTRBdiPI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR02MB7378
X-Proofpoint-ORIG-GUID: AQGjAY8DEpRqCeN3dhpB28xUnrSBgJ8b
X-Proofpoint-GUID: AQGjAY8DEpRqCeN3dhpB28xUnrSBgJ8b
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-14_06:2021-05-12,2021-05-14 signatures=0
X-Proofpoint-Spam-Reason: safe
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The old URL is no longer accessible.

Signed-off-by: Jonathan Davies <jonathan.davies@nutanix.com>
---
 drivers/net/usb/cdc_eem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/cdc_eem.c b/drivers/net/usb/cdc_eem.c
index 0eeec80..2e60bc1 100644
--- a/drivers/net/usb/cdc_eem.c
+++ b/drivers/net/usb/cdc_eem.c
@@ -26,7 +26,7 @@
  * for transport over USB using a simpler USB device model than the
  * previous CDC "Ethernet Control Model" (ECM, or "CDC Ethernet").
  *
- * For details, see www.usb.org/developers/devclass_docs/CDC_EEM10.pdf
+ * For details, see https://usb.org/sites/default/files/CDC_EEM10.pdf
  *
  * This version has been tested with GIGAntIC WuaoW SIM Smart Card on 2.6.24,
  * 2.6.27 and 2.6.30rc2 kernel.
-- 
2.9.3

