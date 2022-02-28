Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E893F4C719F
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 17:23:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237611AbiB1QX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 11:23:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232464AbiB1QX5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 11:23:57 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85BFE49682
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 08:23:18 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21SGFcwP030439
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 16:23:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : from : subject :
 message-id : date : content-type : content-transfer-encoding :
 mime-version; s=corp-2021-07-09;
 bh=LJpwTr0GpYD37W+uSj//EcaQPo2ga5XKt2FlNNbpKmE=;
 b=xVO0UiaDTq99U9KomwMra4iapCv+N0mbdATnW/jvZEMByAtHL5ze1PqLOjs4J+g7QgLg
 B2/Wp+weQszULBnUIt1xMCfjUhWXDFqy98l53IoQSNxSxwEHWOL7BDeWJ9R99y/VdF2g
 5LK61uFc7+vHM7olalNzkUcJWC48TnSclF4kYgrtoOTR+PEv/RHhwJijv2/RSib0FhXY
 Yt9917ZkwnM34mTyC+EZ1iz7wmGZyh6RkiJ0Fdlp3i6z5TDAXaddQt1eEk0BfBzgID1f
 iPdmQGdVHhsOnqshzI+N610EN2YOvOPsIzKM4uCwNvESVJNjvmp4Nu1L0u11yVjwGOBV 7g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3efamccqhq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 16:23:17 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21SG7B1Z185923
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 16:23:16 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by aserp3030.oracle.com with ESMTP id 3efa8cqr69-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 16:23:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CqKncmJK5E+mSjoN4TsMSw3yxMk1elqVHmbUOzZkzo2ryR5TegVC8CoXW5aQZACBgIhdGQPtFkIRGdtmgee9mOe/gFhgyyDUCIn7x9W3Q4yJSwDUZaXvi6IdC3rGaOCb/sOt+A7xfZ/wg/a1nj3KIDU/57e8HJDEBNY3682c0nd6GSlG23jK4JTERL19bse2JzBTP2ufR3al8qpNmpVKDP8d6KjxpXKhs0WiNqyh4d5YgKmuuaStJ4HvhGTeO0WY/ROW//nBYQsCemFxwKjDo+S+iNdnGCR1wzSh9IIAeeDoICBAXgmqM8XENdLx2mDuAtX288GnbvK772wVmzZmEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LJpwTr0GpYD37W+uSj//EcaQPo2ga5XKt2FlNNbpKmE=;
 b=S6XdzO2RPERl/3G1H3PFk39NQBOq1smUwwZjwqpAq//QqnUf1vc8WCQIG1VE2frM6tObxsc0hGSC7kWwQNQO88jkfEM+/ULRyETcFs2ldMzlgBka+iVntApYgUnUbjBFl+cBIq+TgYHDO0+QitdJvc7/BNlRJ+PlHphooFlwYJGBBh4GILN5vqYpDn0FcO9VEczindhZIX9BZh5FZyETF4GqW3BT2GlvOccuJk++FhTe6DlI2Im+oDz/7caUh32Qw8wTWyCIWWR/XJIKcTt8beyddj05+QZzisZwN8WVaL12pMdKee6O+kvlQC2sICnXryCav9zdVde9dnIxAySh0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LJpwTr0GpYD37W+uSj//EcaQPo2ga5XKt2FlNNbpKmE=;
 b=vmC5Nkw9/xisrO2j1l5jZ6CfbVHpJxFOeqc066QhnW/i2yks8m01ksWin6XBZad2dPuZK/hZ7I35vEPy6BwyCbZqLVXOrzZRvMj9/AgAt1iK8TJJlB01hY5mFW1HlnUMzuHGRoqb2DAaha2QihjZr0KfsfH7qVPMArxaf/6nayw=
Received: from BN7PR10MB2659.namprd10.prod.outlook.com (2603:10b6:406:c5::18)
 by CH0PR10MB5322.namprd10.prod.outlook.com (2603:10b6:610:c1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Mon, 28 Feb
 2022 16:23:14 +0000
Received: from BN7PR10MB2659.namprd10.prod.outlook.com
 ([fe80::958f:68db:1cae:aea9]) by BN7PR10MB2659.namprd10.prod.outlook.com
 ([fe80::958f:68db:1cae:aea9%4]) with mapi id 15.20.5017.027; Mon, 28 Feb 2022
 16:23:14 +0000
To:     netdev <netdev@vger.kernel.org>
From:   Dongli Zhang <dongli.zhang@oracle.com>
Subject: Question on dev_kfree_skb(): why it is consume_skb()?
Message-ID: <9ad567f1-b2b1-5d2c-5b51-eca7d61c49f4@oracle.com>
Date:   Mon, 28 Feb 2022 08:23:09 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR13CA0003.namprd13.prod.outlook.com
 (2603:10b6:5:bc::16) To BN7PR10MB2659.namprd10.prod.outlook.com
 (2603:10b6:406:c5::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 63bf52c7-f35b-4b08-f745-08d9fad69e2a
X-MS-TrafficTypeDiagnostic: CH0PR10MB5322:EE_
X-Microsoft-Antispam-PRVS: <CH0PR10MB53227F4A8AD6D0638FF04C99F0019@CH0PR10MB5322.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z3gy4560aWPTvgn9hhdM/TtzGNDqv2Nn282KZn2JaVIeDMhN6W4mshYH0ipHqA2qMJUorWV0eDwFRhZg+52kiDiDfPapostDNwimbPCNpD0PeVDgHdPl/E1ow3yOASz3EcwEeNEwM9PrR4Cs6IjHoVaCiIBB5ZkOCrZjMO+zNnnMO0G2lZjIAv+OF5vbloCRoSjM/fKVl84rO33SwkEK359Q/DpZMf+46KBgyIkdoyzPmAOoOcQee13LbFD7XXHMleBv+7qyWSQV135bGw5R21D/3BCZ8m/aeMFJRA9ahZ1toqMZr1Er9kIterJuUwpvKFvi++DYxC9Kgb3EbwgfB1vrYe9uPfGhhAi4fvKU+s3I2CZ1KKnV5UkIjjInHf1r0j0nQBD6EpH24x/ctt9D7C9oDLZiBbYMUZ6rWT51JenFXYbHK0CNOFCF+1+RcydoDRruQTVS0dBSrCoHhGhJA/AXGdtayge2tVjubjCycm+cxukaRbbPKF4E9KMjDbOSE8eqi9c+fIKbtOpVjLUAeyM0uI/lfx4fGcBCL0xziTd7OnHklhCxaEjlQkmISg38m8G2Ny4bs3mg3++ZU/KTX+rn/HgqFa9rkvrZ0ECxalkmQhEJXafZrdF84lpk1sB/q/XrMhVCCOx0AVprH9Q3dqzSI3uVs32LJ78jlAzaK2QtkmQLOA7z4RGEsEv2abraJNjlyxxSF85r/jVddB6KtTJGa06daWXzps44sl6FUzY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR10MB2659.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(31696002)(38100700002)(86362001)(6512007)(6666004)(6506007)(186003)(2616005)(8936002)(66476007)(8676002)(5660300002)(66946007)(66556008)(31686004)(36756003)(44832011)(508600001)(6916009)(2906002)(6486002)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RTZHeVBnTExpZEZ2RUliY2wyQjRkcXpyOXV6bUU5eXVXbndBZ3BkRGJBK3hL?=
 =?utf-8?B?OTM3cWMvZldzWVQ3U0Vtc0JGUjVweGtnL2w3anFVNUUyL0FGeFBlSVU2V2R6?=
 =?utf-8?B?TmVBZWNiNm5GMDFBWk5HdzUwVno2c2M2YXhTN0lCSkEwNW1iN1RnNEFEaTI5?=
 =?utf-8?B?Q2RjdDdOQ2tjSlBrdjJESGhJbXBFbDVIUzAyanlEYzNzS0FOcGh5V1NsOHpa?=
 =?utf-8?B?TTB0Q1ZBSVYzcXQ5bXVJVE52OHZOY3RPMGI0U1FhR1ZtOVpXOW1kUTJ4VUlW?=
 =?utf-8?B?enJsYmx3K2pGSlZ1SnBHaXlrYTZSbDNYalNObnJmRTQ5SDBzOG8rdThkRjhR?=
 =?utf-8?B?OEllMkNGSWx2NitUNzhTa3VYUDBZOGlwRXNRNHhNYTdremJQbXVVclhyVmQv?=
 =?utf-8?B?YW5sMHFqVDNicU5HeEVxbGE2dXBLcHpIVWtaMjQxTVFlNHdlWWRIQW01ZFZY?=
 =?utf-8?B?allHL09hU1E3WXJXM2ZUSjYyNTljcUpPUnhoOWdlcFpqTkZoYWZ4Qm1RajR2?=
 =?utf-8?B?ZGQ2b2RwNS9kcmNCVjlKelJNaVowdVJkSVk4anJnTGhGYTRxVDgvS2ZuZmxM?=
 =?utf-8?B?dzV5cXVKVzJEQ0dodExKZ1FiUmxjRHNld0xQQjgrUkdtc01SOHp2amJKOTJP?=
 =?utf-8?B?eDlDSU5KakNMZUlWT0llZHh4c3ZManYwdGtjNmhaRFYwYVgzeU9HS1Vwb280?=
 =?utf-8?B?UTNnOXBQNUZFS3VSVE5ibktqR2pkTFpoNDVabGxjamNMMllYZ0c3ZFl6RXAx?=
 =?utf-8?B?N0xaUUxWNkcvc0Y3b1Z0N1V3U2JxY2l3WGdoTjh3NGUxWVFHMEoxQjlDdEt3?=
 =?utf-8?B?QkNmS1d0NGRvZFQ1YmhrNHoyWkFJVnM1MmJwWmc0dlZjUmpQYkZhaXEvTUpT?=
 =?utf-8?B?OTlCYWFKWEladlR5WjAyTENnTE92VU5TSE9ORTFCL05QTXZHblFWRzYxR1NY?=
 =?utf-8?B?aFhrVkhwZ29PTHZOdkZNNzNvcTdrWU5rcG1RODJ4aDJXclZpQTNkUGo3VzF3?=
 =?utf-8?B?SUlEeUtjS1NCMlJKNVVraFZRYWxnUFBsN1kxOFB3WWpKL1FRM09SK0tLdUJh?=
 =?utf-8?B?SDJreVcvNFFrenI2bmhrRzV1SDlGM3dZSVNQbzhISlNtYTNYUXZ4MEczRWRG?=
 =?utf-8?B?ZVVHcHN0SnZtTWF4MFdXaTZmdmZ3MEdybmJhMHRJVG12b0pta0ZaNDhLakx2?=
 =?utf-8?B?cFZnVEpnWDZaR3hHdlphZFNLYjJCS0xjU29wMWdNSzFXNEpDM2VvYld3OVpX?=
 =?utf-8?B?VS9WR05TNlVrZUJyNnNJSXJObHRoTmFwa0ZuWTZjSjhQVDJTVE9Yc1VFTEll?=
 =?utf-8?B?bFE1di9pSWpXaUpKcy8wSjZ5S1pucERxK3lKMXdiNmY3UkJSeUVDTVB0Y0xm?=
 =?utf-8?B?Ny9ZWm1WelZjNlFPRjRNUlFiNTlLYnhveXZVRkRDU01tVzRNbGxJdnVVZlNX?=
 =?utf-8?B?b05VdEpTdk9Nb29TMmdOMWk2TWxiZDJyWFFXWFdRekRjMUFZY1FMelF0R245?=
 =?utf-8?B?ckpNdExPNlB4WXh5N2FjdFpNYUpTT3ZrbmczbHRneXR1NXR2WXpEWVk4Z2NV?=
 =?utf-8?B?ekJhczZFWVdGTFNadFRVd1JYZVpTNVRnWCtHU0F0MlExbnBRWmk3V3Faa1Y1?=
 =?utf-8?B?WG9Id3lSZnQyNC9xZnd5ejNTeitTQ21BQTl5N3BiL21nakhNYzdTQ05icTJt?=
 =?utf-8?B?OGY0amhiQVdhbEtSWnBleGdUUWMxcW5iK0sxZnJ4VXF4allzejA0Q0d0dzlv?=
 =?utf-8?B?SWt4cUdzTTRwSkNUR1VSRUwxU0pvNGNwR0ZtZE1VVGIzNHd4NWprWVFnUklu?=
 =?utf-8?B?WFhDVEJHS3FRUjg3UW0rdzVQOVV0SzlOOGlLMlpsTzNLbm5GSGVoclZGY0Ji?=
 =?utf-8?B?T2MyWUlVTWJMNU5uTytIYy9DQlhOdC9sYTV5R0xKcDBuMW1xdFlrblZYR3Qy?=
 =?utf-8?B?ampZUVFTY25kWmhuM1JDaVhxd0tFSVR6MitSQVJSbHlpK0VlS04zTkZXeU1H?=
 =?utf-8?B?TzRFRCtuNTNocWNjeGFRWjRCT0FpcS9JKzl2ZnJVYXIvYXcxQ2hDWWpGaGtC?=
 =?utf-8?B?SWMxRm9VSy9pYzQ0Z2F6K1UrREVDSFpLRjNkM1pQMFhqRGY1M1cwRXRXaTg0?=
 =?utf-8?B?V2hvei9HUFpSaVZWNU1TQ3pUQUtCaGQvbWppb3JFNXVYN1ZtN2ZWQ0RYei9h?=
 =?utf-8?Q?un78RvNkN/L9c81w22Ty8xmKQgL6h8OpHWAf3S9W+LUJ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63bf52c7-f35b-4b08-f745-08d9fad69e2a
X-MS-Exchange-CrossTenant-AuthSource: BN7PR10MB2659.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2022 16:23:13.9134
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sfm6Ibu2VBsU7L0JFYkkD1QiAFZMaRHkiEVCpOtnto5A5xNQRIQEbMx6q0Ir+2gflon9mejFxmQhyJRoHdJvFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5322
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10272 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 spamscore=0 mlxlogscore=953
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202280086
X-Proofpoint-ORIG-GUID: _t_sFEtCmtUomEwcIPa8o6R6pMxjMj4t
X-Proofpoint-GUID: _t_sFEtCmtUomEwcIPa8o6R6pMxjMj4t
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

While the dev_kfree_skb() is used to track the dropped sk_buff, is there any
reason that it is consume_skb() ...

1328 #define dev_kfree_skb(a)        consume_skb(a)

890 void consume_skb(struct sk_buff *skb)
891 {
892         if (!skb_unref(skb))
893                 return;
894
895         trace_consume_skb(skb);
896         __kfree_skb(skb);
897 }

... but not kfree_skb()?

752 void kfree_skb(struct sk_buff *skb)
753 {
754         if (!skb_unref(skb))
755                 return;
756
757         trace_kfree_skb(skb, __builtin_return_address(0));
758         __kfree_skb(skb);
759 }
760 EXPORT_SYMBOL(kfree_skb);

I assume we may need kfree_skb() to track the dropped sk_buff.


In addition, there are places like __dev_kfree_skb_any() that may not capture
'SKB_REASON_DROPPED', if dev_kfree_skb() is equivalent to consume_skb().

3053 void __dev_kfree_skb_any(struct sk_buff *skb, enum skb_free_reason reason)
3054 {
3055         if (in_hardirq() || irqs_disabled())
3056                 __dev_kfree_skb_irq(skb, reason);
3057         else
3058                 dev_kfree_skb(skb);
3059 }
3060 EXPORT_SYMBOL(__dev_kfree_skb_any);


We may change like below?

diff --git a/net/core/dev.c b/net/core/dev.c
index 2d6771075720..0800e1c4b514 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3054,8 +3054,10 @@ void __dev_kfree_skb_any(struct sk_buff *skb, enum
skb_free_reason reason)
 {
 	if (in_hardirq() || irqs_disabled())
 		__dev_kfree_skb_irq(skb, reason);
-	else
+	else if (reason == SKB_REASON_CONSUMED)
 		dev_kfree_skb(skb);
+	else if (reason == SKB_REASON_DROPPED)
+		kfree_skb(skb);
 }
 EXPORT_SYMBOL(__dev_kfree_skb_any);


Thank you very much!

Dongli Zhang
