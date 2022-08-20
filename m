Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA5E59AFF4
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 21:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbiHTTjq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Aug 2022 15:39:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbiHTTjo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Aug 2022 15:39:44 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2AE527CDF;
        Sat, 20 Aug 2022 12:39:42 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27KIxsGA030280;
        Sat, 20 Aug 2022 19:39:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=U6AxeHLuKhiRBl2xXJxb2pN7DEuq0VB1RBd4hK0juT8=;
 b=ol/IEe7SZh/5WavIB5MKuBv8Gjo/3tgzn8kHJIAEQOFgJMmJCWrOjitLQ2RT7dHmSvsc
 8iLKoqkJoR3LIyqETfcxq3ztXGq1yD1eg9FiANFEbRFWm4s1tubIlVTVFSaK+xshd8pN
 oXDJQi2aTrex5Uu8Xa0uzutpOqtNU2/bdYN4IIqbkWLo4872PP+tyiJK2rgsohDFaWJw
 qKxnyT96WmG6N1mDjmu4kbdhjep6UaGevMJQbYBcvogtk4qh7lwR+5ffH6yXcoNZ3HNb
 XR5Vos8WOprRji4gaN+fPoB4Fj82j3eCNn0VoIA8j2/rKsz6M+e3J4/31siZQQXUkYQu Jw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j35ck00tg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 20 Aug 2022 19:39:27 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27KHU9mR017498;
        Sat, 20 Aug 2022 19:21:12 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3j2p26kqby-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 20 Aug 2022 19:21:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=no1s5EXzN8Gm55586LYtQacMdfZaaOsFeu5lZ2nM+hcSWl+V0LOI3uQobub4e8xyBe6N1LEIMVpaEzkz5e/13bIqTdkiaX+XEKiNgLruYlr1jleq3Kznw8imecF3cfKZIZpC65eIJlCnQwgXFRSrBRg9Um9pt8nxRF6Wq4HBzCfGcYbsX/Z/Nnu2y6PiQ01FJObrir7zmnAD0yqZx9kelK4rKp+/n4ZR2pUttUtcBOfHoybs6GJHZ8LmmTSVKTyXwXFRklObhQaTgvtviWKsv5rhPtQq/GnMxDisusGgXWRjqSwOw0SdMKvGj6aweafZ5NpGk53z0VMZ6lDaf7V8Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U6AxeHLuKhiRBl2xXJxb2pN7DEuq0VB1RBd4hK0juT8=;
 b=NGcFM+OA3GMS/hMy2FNuvWDT62/bV8+q+ikaGyKE+9epSUhmklWF0YFU/IByG4qPwH/JeowBWXcWTdpi0NlkpAQPeQijNqxJIm0YM4PbZYfrxquQjDf+d2k33XohVXI/vkbgT64b+eFFpXFPBM+BRFK+MGBnS0H8r/JBLgMdRBPgvCNk+l4Ul4jPNoOIWKf7FAiVYR4J/9sFIQ2FUbU6lRZA5hGX3Ty2gqXeYWUy/V0JeYX9NhfcwBW8G7nvYGrKoUH8hZNKLskRXheAH/7IderYGWd/VpFLGAL8mTTgiulbVE5IEPluDS7Wyt3nswacf+hVHibqdLUMlMxLBizPiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U6AxeHLuKhiRBl2xXJxb2pN7DEuq0VB1RBd4hK0juT8=;
 b=TMntIjRhctnc9HylLPC1vPDMUNmRmdZEYDtEx2RsEQFkG2PMwz61M6M+/gFGkUKDn3F2uJbw70QYBM7ypGCFHDF9VDAOV2jjdQ+B7x2O6sBe0BOer/fpSY8XNqKYCybwuAWNjeQBnnucBlkbVtVVFdnKyDwFub0isG4DAlDdhPY=
Received: from MN2PR10MB4191.namprd10.prod.outlook.com (2603:10b6:208:1d1::14)
 by CY4PR10MB1543.namprd10.prod.outlook.com (2603:10b6:903:2e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Sat, 20 Aug
 2022 19:21:09 +0000
Received: from MN2PR10MB4191.namprd10.prod.outlook.com
 ([fe80::c4b7:bba8:dbd2:e95f]) by MN2PR10MB4191.namprd10.prod.outlook.com
 ([fe80::c4b7:bba8:dbd2:e95f%3]) with mapi id 15.20.5546.018; Sat, 20 Aug 2022
 19:21:09 +0000
Message-ID: <9b41e3b1-119a-4180-3f11-14ef36592dd6@oracle.com>
Date:   Sun, 21 Aug 2022 00:50:58 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [External] : [PATCH nf] netfilter: ebtables: reject blobs that
 don't provide all entry points
Content-Language: en-US
To:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Cc:     syzkaller@googlegroups.com, george.kennedy@oracle.com,
        vegard.nossum@oracle.com, john.p.donnelly@oracle.com,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220820070331.48817-1-harshit.m.mogalapalli@oracle.com>
 <20220820173555.131326-1-fw@strlen.de>
From:   Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20220820173555.131326-1-fw@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TY1PR01CA0185.jpnprd01.prod.outlook.com (2603:1096:403::15)
 To MN2PR10MB4191.namprd10.prod.outlook.com (2603:10b6:208:1d1::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c00c4913-b0a8-4dd3-83af-08da82e122e5
X-MS-TrafficTypeDiagnostic: CY4PR10MB1543:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DI4UQvx/JBCK4Q9lOo3ysy2TWJHc5QvtuJykmuke+Cm/wtGu8vIZiodZbz7RPuOPtDCQEpWMAu3j1E+NKeAyJ1xXfsP+EOHrqBYSVL+TcEwt5yB8vKCBQGukLHgfOCctF4utKpQj50OzussKFbMF860iyIlrRy98uKCaTZv8SyX2brh4lv+h2izjA3qoxIxg3JYEgyW9vN0vIgChanTnBRl7WsELwwJnc6hrpY/WMga4KmDfAazopC987N0L6PokhpsU+SyBJG1UF1Gib3dnGQrkqBa2KKcN6xwz3aWzEzG324sEXDhFlVWTP7CbBRm5PTZGYxMAm6DXYTheCuLcHGCc7vjwwUbiatfTfWreDsHM+RjmArpYH4KVx31DSAtbhX7mNKsuZT5aYBbek/bbuNfSxlp5hlCjQX+LnRzTfr8mCNzHLOV1jDlMI/jbOy5R7kdnChE3GsJeeI9PRUK5wo90tdgqKbads5pvRqq0zTC5DU62FlxvEPBeWnRsOQ33WObP5+DfQQP7zbnjYFNZLw+kzt7ebx/KFi2qEP5FtmWT/n8ytYP6rA3ysaR55aif9IoMeV88rEJ6qmLeaS2yD0BveVL3mz10c7O9MtsZ9TnpHzPvunoFdkM0iOHGrOqDFkhsDemtOMhQY8PBcGbPzkCC9K1F5v9++Ra2/WD0721ydZoMScfOdRdxdcEhwaMUtI3KGRxW8Gm8DsPgVkkeTg3a8LXAWEEUZ4bsH/lvPfts7EtJDKAqjucG1DIZZOHMg05PaYQMqiBa38pJBBkZkSgQrxcQjYSRuZPlLEF+5H0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4191.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(396003)(376002)(39860400002)(366004)(53546011)(31696002)(86362001)(66946007)(478600001)(6486002)(8676002)(66476007)(26005)(6666004)(41300700001)(2906002)(186003)(4326008)(2616005)(5660300002)(6512007)(36756003)(8936002)(6506007)(31686004)(316002)(66556008)(83380400001)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V3NFSFdPR2RVSVdGamQ2VFlQcHpqVFpXNDc2QnhKNkx6OVNQd2JyMHRvTkdJ?=
 =?utf-8?B?dXhhWk1kMnpVd0hLazBpaDBWTk1zUDJVNmx5bzdTQ2toZk1vdkVhQnRIVWlK?=
 =?utf-8?B?d09LcjVXTVoyazNHV0gwckRzd1p6dG1yM1IwMHFGeW1ENnlpMmdrdm5mbmdE?=
 =?utf-8?B?WkhBYzc5YmVuMTNuamp6T1Y4NFllQUhlVisrNG5acGljd2xPMDZGeFhhV3hk?=
 =?utf-8?B?OGxCOGVJRWV1OHNFczl4U2p6a3Y5ZURGRGZucXY4RFdBSk1KTmkvdmFuc1dt?=
 =?utf-8?B?NjB2YnVkelA1azNjMnlDZHZ4Q244eHNsaTlBekRsLzFxZjd5NHJqd0pKWnAx?=
 =?utf-8?B?QTU0MFF0NlAvUm9GRkRxOTZvRXFUejdaSGU4MmxobUd4R29GUTFubXVSYm93?=
 =?utf-8?B?RnJSTXFHKzlNaXIyMWQwQmZ2TkE4OE00enJtb3dqS2hZWlBvUXFJRk1zTGsz?=
 =?utf-8?B?WHJtdjEvUDZTbjMzS2tleDFta2llK0lrVG1JU2EybFFVRk1wdEROYkE2UnpX?=
 =?utf-8?B?NThqallFM0JtNjZERjBOU0dMSldiNDhoc1ZGdFhYT1UvWDJ5OWIyRHJ5M0Ix?=
 =?utf-8?B?ZmhmYzlGZmt4MW0vdjNJcmFBZnBHOG5DTmx1UXVhdzlTRnB3RzI1aWxnOG9R?=
 =?utf-8?B?Um1XWmE0d0lENm43Q1U4WHRuVmVnb2E2Nmtwc2I2QXg2V3lwRWZ5ZXJGV09U?=
 =?utf-8?B?eFJ3MTRlcDEyK3ZkaU9ZL3lVczRlL1p3aTZOVmE3aytpamc0SmZtNFNwM2RB?=
 =?utf-8?B?ZER5Z3phaDRGM3ZuWTNoQm85Y0hnbWFJYnlHYWx3VFZrMmZ4c3VsUyt6aHl1?=
 =?utf-8?B?cVFuUmdhODF3MzlzTGM2ejB0ODkrcE1meHpmU21Zb1ZUZHpRZDhnK3c0YVdn?=
 =?utf-8?B?amlmMk9XV2RlZ2kvN0tveDhyblVwVG9BZjZLVng3a0RhREQrak4rZ0U4WHJT?=
 =?utf-8?B?L3dlMUF5aTNnSmhlanBYL3p3ZldKSUsxWWFPZDZsNVZtOFpoM0hzV0ZvbHIx?=
 =?utf-8?B?bjYvTUdCU3dFNTZXN3RrZlE3eEFZNndtTURyRlN4WVRCanNDTW1mcmU3bVRk?=
 =?utf-8?B?bit0N1F0Vm5OdEVHTzVNZmNjTmtoNVZCaHN4aS9PT0grY1NqOFAzT2orMmhm?=
 =?utf-8?B?ZXJTZ3FYVlNtUnZyRWNwWW5ueUJwVVJRRllLTVFoODBiQ2IrNzNaNis0Y25w?=
 =?utf-8?B?bUoxQmUya3ZtMWNtc1Q5OU5VMzhNUnRzTDRlbG1HODY1UWljaDVxT21aS0cv?=
 =?utf-8?B?VWFlR2txMUR6eW9KNjJjTVBlRG5TSE5DVUVlTEkvM1dDakd6aXo3RnlhSXBV?=
 =?utf-8?B?WXVCRmtUTzRRckJXUnFSN3BiYnlLVS8xOEtXTHZ6Y29sdUJHbm5iNEVVY2FM?=
 =?utf-8?B?TzIxTXkzakQ3N1NKNTMwdUFwTU91dXB5QUN4ck5nUUMyNHc4a1B2b01acWI3?=
 =?utf-8?B?bmVJMjltdFlyeERmdXAzZkg4b0F1SjRNdU5Pc3hKRnpzQ0FPRzJwUXlTclJV?=
 =?utf-8?B?WE56YUNYZU56ditPeSswREd5bU5JcVdwL2lXZU5NTk9WaS9ZKzUxaDR3WGkv?=
 =?utf-8?B?QnRSdkU0R2lGNkVDa2Y4UUlhc1dpaW1hRTY5eUxVVU9yMkZMUmJreDBiSVpr?=
 =?utf-8?B?c004WFlDUDlVeWI5VnhGL2krdThWOGwzT3NXT1R6U0JBd2hJWnY0SWg5bVZM?=
 =?utf-8?B?Tm9FZlNibVNYdjdyT3VuQ0pCK3ZMaU9VWmU1eTlld0JDL0VMaEY4UXk4UCtO?=
 =?utf-8?B?ZzEvQmF1WUN6Y2IzVmtjMlRjVklTTkw4UWpvbFdoNDdlQ0FMYmpHNFNFazZI?=
 =?utf-8?B?ZU94VVRzMEdlY1BEUUc1U2VuclpmV1JXcEdpL2FqYU1sVHNiNGlId3pnaEJv?=
 =?utf-8?B?dElBYnI5WW9FcFNOUWhiR09CR3I5S1g1aFVOS3lHU2J3UnpndXdubExCYWtV?=
 =?utf-8?B?NUErNDdGZ05qaFg5ZmpmdlpWeFQxNUJiUmJzRFF1TU95bmpmVy9wN0t3aHMy?=
 =?utf-8?B?VlJMRlVkZ3ZITUtsbE1vd2JRN002QzIxejhqWHI1MVN1VklsWE5pRnNtSmk1?=
 =?utf-8?B?TTJ0MmRvWHZBb1gxR1g3cG5TV2JlWWVkVmlLMzZCaGYvaWVOSDIxOEVzbVF6?=
 =?utf-8?B?OVNqV291RDZWY2hBU2taUFhWUGhNZEpaYWY3RUZUc2xBNzBVQmhDdkxkWGk3?=
 =?utf-8?Q?lQlkfJSuyQYw6OqMht/aSWc=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c00c4913-b0a8-4dd3-83af-08da82e122e5
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4191.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2022 19:21:09.3252
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YBfhNsPX+fZQnXAGy2aE3uxbCcWg2pZEgShpvjWl0tZ3woCVjx8MXVr/syqIGfZiyAuNJN5wQIh5EQZT1UgT48SL06v6DddaROIMUmVmJ7wJ0ZGViQ2sC5dyi0xOuvHf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1543
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-20_08,2022-08-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 spamscore=0 bulkscore=0 suspectscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208200083
X-Proofpoint-ORIG-GUID: _cNUBLlxi7VpTvi5zGkgZzX5J458dZGt
X-Proofpoint-GUID: _cNUBLlxi7VpTvi5zGkgZzX5J458dZGt
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On 20/08/22 11:05 pm, Florian Westphal wrote:
> For some reason ebtables reject blobs that provide entry points that are
> not supported by the table.
> 
> What it should instead reject is the opposite, i.e. rulesets that
> DO NOT provide an entry point that is supported by the table.
> 
> t->valid_hooks is the bitmask of hooks (input, forward ...) that will
> see packets.  So, providing an entry point that is not support is
> harmless (never called/used), but the reverse is NOT, this will cause
> crash because the ebtables traverser doesn't expect a NULL blob for
> a location its receiving packets for.
> 
> Instead of fixing all the individual checks, do what iptables is doing and
> reject all blobs that doesn't provide the expected hooks.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reported-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>   Harshit, can you check if this also silences your reproducer?
> 

Thanks for the patch, I have run the reproducer on patched kernel(this 
patch) multiple times and the problem is not seen. So it silences the 
reproducer.

Regards,
Harshit

>   Thanks!
> 
>   include/linux/netfilter_bridge/ebtables.h | 4 ----
>   net/bridge/netfilter/ebtable_broute.c     | 8 --------
>   net/bridge/netfilter/ebtable_filter.c     | 8 --------
>   net/bridge/netfilter/ebtable_nat.c        | 8 --------
>   net/bridge/netfilter/ebtables.c           | 8 +-------
>   5 files changed, 1 insertion(+), 35 deletions(-)
> 
> diff --git a/include/linux/netfilter_bridge/ebtables.h b/include/linux/netfilter_bridge/ebtables.h
> index a13296d6c7ce..fd533552a062 100644
> --- a/include/linux/netfilter_bridge/ebtables.h
> +++ b/include/linux/netfilter_bridge/ebtables.h
> @@ -94,10 +94,6 @@ struct ebt_table {
>   	struct ebt_replace_kernel *table;
>   	unsigned int valid_hooks;
>   	rwlock_t lock;
> -	/* e.g. could be the table explicitly only allows certain
> -	 * matches, targets, ... 0 == let it in */
> -	int (*check)(const struct ebt_table_info *info,
> -	   unsigned int valid_hooks);
>   	/* the data used by the kernel */
>   	struct ebt_table_info *private;
>   	struct nf_hook_ops *ops;
> diff --git a/net/bridge/netfilter/ebtable_broute.c b/net/bridge/netfilter/ebtable_broute.c
> index 1a11064f9990..8f19253024b0 100644
> --- a/net/bridge/netfilter/ebtable_broute.c
> +++ b/net/bridge/netfilter/ebtable_broute.c
> @@ -36,18 +36,10 @@ static struct ebt_replace_kernel initial_table = {
>   	.entries	= (char *)&initial_chain,
>   };
>   
> -static int check(const struct ebt_table_info *info, unsigned int valid_hooks)
> -{
> -	if (valid_hooks & ~(1 << NF_BR_BROUTING))
> -		return -EINVAL;
> -	return 0;
> -}
> -
>   static const struct ebt_table broute_table = {
>   	.name		= "broute",
>   	.table		= &initial_table,
>   	.valid_hooks	= 1 << NF_BR_BROUTING,
> -	.check		= check,
>   	.me		= THIS_MODULE,
>   };
>   
> diff --git a/net/bridge/netfilter/ebtable_filter.c b/net/bridge/netfilter/ebtable_filter.c
> index cb949436bc0e..278f324e6752 100644
> --- a/net/bridge/netfilter/ebtable_filter.c
> +++ b/net/bridge/netfilter/ebtable_filter.c
> @@ -43,18 +43,10 @@ static struct ebt_replace_kernel initial_table = {
>   	.entries	= (char *)initial_chains,
>   };
>   
> -static int check(const struct ebt_table_info *info, unsigned int valid_hooks)
> -{
> -	if (valid_hooks & ~FILTER_VALID_HOOKS)
> -		return -EINVAL;
> -	return 0;
> -}
> -
>   static const struct ebt_table frame_filter = {
>   	.name		= "filter",
>   	.table		= &initial_table,
>   	.valid_hooks	= FILTER_VALID_HOOKS,
> -	.check		= check,
>   	.me		= THIS_MODULE,
>   };
>   
> diff --git a/net/bridge/netfilter/ebtable_nat.c b/net/bridge/netfilter/ebtable_nat.c
> index 5ee0531ae506..9066f7f376d5 100644
> --- a/net/bridge/netfilter/ebtable_nat.c
> +++ b/net/bridge/netfilter/ebtable_nat.c
> @@ -43,18 +43,10 @@ static struct ebt_replace_kernel initial_table = {
>   	.entries	= (char *)initial_chains,
>   };
>   
> -static int check(const struct ebt_table_info *info, unsigned int valid_hooks)
> -{
> -	if (valid_hooks & ~NAT_VALID_HOOKS)
> -		return -EINVAL;
> -	return 0;
> -}
> -
>   static const struct ebt_table frame_nat = {
>   	.name		= "nat",
>   	.table		= &initial_table,
>   	.valid_hooks	= NAT_VALID_HOOKS,
> -	.check		= check,
>   	.me		= THIS_MODULE,
>   };
>   
> diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
> index f2dbefb61ce8..9a0ae59cdc50 100644
> --- a/net/bridge/netfilter/ebtables.c
> +++ b/net/bridge/netfilter/ebtables.c
> @@ -1040,8 +1040,7 @@ static int do_replace_finish(struct net *net, struct ebt_replace *repl,
>   		goto free_iterate;
>   	}
>   
> -	/* the table doesn't like it */
> -	if (t->check && (ret = t->check(newinfo, repl->valid_hooks)))
> +	if (repl->valid_hooks != t->valid_hooks)
>   		goto free_unlock;
>   
>   	if (repl->num_counters && repl->num_counters != t->private->nentries) {
> @@ -1231,11 +1230,6 @@ int ebt_register_table(struct net *net, const struct ebt_table *input_table,
>   	if (ret != 0)
>   		goto free_chainstack;
>   
> -	if (table->check && table->check(newinfo, table->valid_hooks)) {
> -		ret = -EINVAL;
> -		goto free_chainstack;
> -	}
> -
>   	table->private = newinfo;
>   	rwlock_init(&table->lock);
>   	mutex_lock(&ebt_mutex);

