Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08CE252F6C4
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 02:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354216AbiEUA1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 20:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354213AbiEUA1f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 20:27:35 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97E765C764;
        Fri, 20 May 2022 17:27:34 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24KMsIsY029589;
        Fri, 20 May 2022 17:27:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=/YrFbGWlTtFYGJYwcyTxZL38ZaqYFyH5yms5HbiLqpk=;
 b=RGIa0mqeiwpVW2CBjbSIFF+4g48vAcKo+ZtLYZGbh3R42sn3oZ5A8V1fLeRgjKxte+26
 cYsGwY9ZNc8fI4/xSoLjMh0+rmV4+Mw0YqSEgP9BQhntGJZk+6/o3kMAz/p264D0a7QM
 je6mbPPHAFPLjY4Bh6uWfoxawEMGLUoTisw= 
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2045.outbound.protection.outlook.com [104.47.56.45])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g5xexfu4s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 May 2022 17:27:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PJyL2w8VznkPvBEABHdUozgqqpyud/AdGxNJDWd5UCwrwTqBeMCusKBVmzzbphaf8H+7dveSIHcj7Kv7LnZbphUg3HxKoboppWsg7UUEoYV0CstrpEDlsimrm8L/LImjLvDiDtvWyuwFYcXrB36j1uqP+pMZo0rd4czypfx9ycNj9FdDJKBmCEBrlJKO6z9hSxQL9zkSPZu4iHl2sCLT7PcNn2o4TUkuqCNlx86inhiVCt1i2EbJcWkeTHT2LMFL4uzNfutraqYcYPwFwDSLi2QgCVXiqhya/04cDl9YAu1DSpeGV3TcuR4w4g3+MYsOPSyrcI9YLQcGnkJVoi/YbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/YrFbGWlTtFYGJYwcyTxZL38ZaqYFyH5yms5HbiLqpk=;
 b=XNSuKNIHWOfpBqHOa+x3b3j7nu2DxArBEvQrlSe8STi0RZSbLukPxGS9m7kVR4RKjof5v59b34d1zLl1HkV3pjhwuGJNo6uBrS/1P4t9t4WAe/haW8T5qC4oJ+VPfnWJE1c+rZWQDJU+tpy8GABDFoRTPmrBhgnhFz5ZqfxXv7/s8/je3ivWBJMqAThlTlSL9hfDu9iyKysMLEQ155jvKLUGN/X6h9BpxGEM8j+4ENeJfncjALE1KtW0i5QHC7s7vDQZVi4v6jjQxCZIbKbcKMqnGq0Y7P5X5G5yyS67yCxop6LrcHmbl1nviuupcUvnLAMRpJztRYacdfF9hABMjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by DM5PR15MB1898.namprd15.prod.outlook.com (2603:10b6:4:4e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.17; Sat, 21 May
 2022 00:27:15 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53%7]) with mapi id 15.20.5273.017; Sat, 21 May 2022
 00:27:15 +0000
Message-ID: <7301b9cc-fdb1-cd4c-2dda-eb97018546a6@fb.com>
Date:   Fri, 20 May 2022 17:27:12 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH bpf-next 4/4] selftests/bpf: add reason of rejection in
 ld_imm64
Content-Language: en-US
To:     Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
References: <20220520113728.12708-1-shung-hsi.yu@suse.com>
 <20220520113728.12708-5-shung-hsi.yu@suse.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220520113728.12708-5-shung-hsi.yu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0005.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::18) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 00a5780e-a54c-43b6-ca8c-08da3ac0a80d
X-MS-TrafficTypeDiagnostic: DM5PR15MB1898:EE_
X-Microsoft-Antispam-PRVS: <DM5PR15MB1898E5A6ECF191DE5731180BD3D29@DM5PR15MB1898.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TzoXCQ7sMMvTATzdgaXHOPpXi9Q4WtsXgPIRuSItXe/Dz1xqOwVS9t9X+klnX28/BjxZshk/iuG96BybXrPnh2REq9QuFF5jbpz1M7nF2YLD1dUu4iUMuBvD99zjLeH+RN7ONKnLZ/jeF2h5cbq3rww+FCV1P0YeIEHwsaLjsPneoS05MyersK6VcJOtmFMOFfYTe43VQ906JORYRL8CD/2bX1K8U2vG54FaMteV6z9+wJ4OAqQUkLUUBJSYhRF6tEPnuKvQ+pGqVdWTqW8/s9+XhyuB7j835Qq6uZFY4yBZq0RMYbsPramSHqNTiNPVXzOLm80z+WKY9BnQaaQGWw5QmnsXdvyI+zyK4683FZxiK6sUzfv7T5+3cWQhGQjrl6HrdIzZNS6euGSJFBbWtj611mkWGk17f4zyrklHymNaJw5TDWsp7ohLBRbkixA1jmsyUa/ZMxx0gmJ6FEObj/WdyNcFRVEAsHecVDZrBPdwg2YZhY63YW95HUwLVEycP4XW3xcHetS478ipPfIHSDQ8YPkhyr13sucKCoSDXqCGf6ddbdaGx843asB8cVabL/KGEq8BmLiU7mCDzWAsTn6PPWyrqyKWY0E7NcfSbWgr5yu/7WwT3NZReXaizjYPzPyj35o3yUNbIG+B0ncwKBBlDu+vo/1j/Ql+3uMZlVpxPgzxPTuZIRF0zcfGd5C3mb5sPauY83OCv4usSq5zxy/ezBtyMwjUR4q0fYu8dZ0a0hLPYZVHOoc2FIAJYDQW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(83380400001)(508600001)(36756003)(6486002)(4326008)(7416002)(38100700002)(54906003)(5660300002)(6506007)(6512007)(2616005)(31686004)(31696002)(66946007)(66476007)(186003)(8676002)(316002)(2906002)(53546011)(86362001)(66556008)(52116002)(6666004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YzBKam4wTUZjQm1INkZxK2twaUVValB2aGk3S3dhN05RU0x2VzJjeG16UWh0?=
 =?utf-8?B?Zmw1ZjFrR09BTGwvYmpVVE8yTDZJMHhucmJ6SXpURFVDNVYwTm1vRmwxYUQx?=
 =?utf-8?B?bmhBaWxWM0hocUEvSDdzRVozeFpCYXBNTis0aVhmVXRHYm42WDZnSHF3VE90?=
 =?utf-8?B?S1N3VkduYXQ2NXJWaXRCelVJaVZ5NW1lSldUdzZPbUN3Qlg3VEtSWVJ0MzJt?=
 =?utf-8?B?Yi9BT1JhU1RLVnBxalFzWUllS3F4d0lyN3h6Z21Rd3VMTFA1SDhLN1F6OGls?=
 =?utf-8?B?a2dnNS9PdXBYcUk0dGNnNVhldEhjNlprNytxVmVYU0E3Z2lMbFRaVFcyOUhx?=
 =?utf-8?B?VXQ2d1ZvWDBoODlmZWdzazRtRXVKN0J3SUxPcFExMzl6TThYRDhrTkozVHdR?=
 =?utf-8?B?VDRNMm5UcEsyN3ljZDM5YlNVNDEvckJqUFNzZm1ja2ppb2FXZ1VjZExlZXBq?=
 =?utf-8?B?TmRnVjlqN3dBSVNLTXRoSnRNRXJvdGdCSGFkM1JlazJTOS9uMFlYSmRybUFL?=
 =?utf-8?B?Rm9sbW9rK1dxaGp5c0JwNmo5UjMzT2xSZ0kwNzhaRVQwdEZwdWJZQVZOa0Nl?=
 =?utf-8?B?TzNsdStMaGZMRnR3OXNQUlNjcDd3WDJscnhzUXdJMWNrb2toM2VNM0JhU3Ju?=
 =?utf-8?B?ZEQ3clp4SitiQ1ZQNnV6anRpVlJsd2xVRWNheU92ZG43bTI5MW5xMUttY2Qv?=
 =?utf-8?B?N1Z2R3Boc0IrbThtU050eE84ODY1UXZ5TnVWNmxYNkp4UDAwZE1CNkNmMU15?=
 =?utf-8?B?M3h0TjVaZVZXVWRkSTJTcUlQTkhnVzRLMHpvR1VhL2ZIQmFrV1hqUDRYODVS?=
 =?utf-8?B?VDBGMEx2dEdWTmo4ZWlyWUQreldDU1R0dDVycFFiOUpJQldsUkVQNkRwK0Z3?=
 =?utf-8?B?aWl6anpRVHNaQ1FDWTM2aGp0UXVydHl3M21DTjVTNTRTTHB1ZjJ6TEcrVjJ5?=
 =?utf-8?B?bkUybHpEZlFCSnJkc1pBbkRCV0xpSXJRVUlpbXhXaEFtRDRpOXp1b0FlanpG?=
 =?utf-8?B?Rm82eXJVdEZNM09EeDN4ZC9ydGo4NmhvdngxTnl0aWdwcU8ydjBmR0Y1Mll0?=
 =?utf-8?B?Ky9aekNQMy90Ujc1aG1WTHo2UnU2ZDRBSE53blp2MEhZQVZaQkhXNENkQ3da?=
 =?utf-8?B?VWJiU1l4d2JkejhyeFNUTUR0a3JZU2lyNEpCd1BHdWh6cFNZSnNRZHIwYzhq?=
 =?utf-8?B?RFBMMkJObUJkTGVjQmxrNmxtRkx1MFhOQTlYOHkyVkZQUndpak54dGFOSU4r?=
 =?utf-8?B?Nlgzd00vTC9OcTVodEZqbXloVVNubUU1emQ1elMxL3NWY2QxZEloSE5JWFNz?=
 =?utf-8?B?M2RuRXhFQkdYN3FXbVgwN1RTL2tHQVpkQzM3ZjJoZGVvUkp5NFBlWVkrOEVk?=
 =?utf-8?B?NDhHazV1U1VuZGN0UGFFMGZkQWJVenlieDdOT2YxMktIbzNEdUIrclVtUVFF?=
 =?utf-8?B?bytvLzR5UzlQRE5uTVBpZU1ZMFcyWTJyVlA3NjhBajNHOWNtR2lWT0llSlBL?=
 =?utf-8?B?Q2w0MG5oRDRCSmpGbUNmS3JtM2R4bFRQMnh3TjZ0U01xQVJZS3BwYUwvN0l2?=
 =?utf-8?B?THhncUtnK3A1ckdXTGo4dEtKN0lGWHo0MFVQOWw5WnVia0szbkhtbGszQTBr?=
 =?utf-8?B?L05vWTJ5RC9UQ0xrS01DQjFvbTFYZmZIWlpRa0FhS0M1NHBjbEQ1bFpLaXY4?=
 =?utf-8?B?YnVaZ1dzTkNRN0xCbkI0R0xYa0c3UzBkeWdKS2RGT2szMWx1V3dpdmg2eWpG?=
 =?utf-8?B?YXhpNnVTb2hlNlpBWjd5a0F0ZDZ0WlF5ckZNeWlFTm1XQ202OXZtZzk4S3Nw?=
 =?utf-8?B?azRSUkxtNThzN1NYYmpNN3RnQkN2S3YrVVBKM1FHVzVFbXVyOVlFbVVCSE5m?=
 =?utf-8?B?di9vckJ2a3pKM2NPZ2RNVm9tTXFYMzlDVkNRQlMvTWlOanJJNGMxMWp4TXdC?=
 =?utf-8?B?b2oyVHlUQ2xFZlI3cU40eTM2aCtNdmpWY1I2N3RCZlBYbmJIK2VFUWNuMWhW?=
 =?utf-8?B?TDBzNFBDZUNGRWxMQjRiMHYzUnJYMXRFRmhNQVYxS05JNm9RanpsVVpEODRr?=
 =?utf-8?B?bVB5WVl2NnV2dGxGSHB3REoveHpZSVNteW5oa29qc3hKZGJ0N09xSTNoL29z?=
 =?utf-8?B?eU5lbE4wZVhlLzIrdlRjZWhJajJ5K0RrNjcxMFE4L2c4ajFVQUNtVzBMdlhZ?=
 =?utf-8?B?dkJjb2d3aHg0YVFhS3dYTHRxMU51dzNvRlJ2bjUvdnRZTjhTNENhb2VVQjhC?=
 =?utf-8?B?MGNweWlERmM1UFc2NDZVZ0JpbFpDMzlxcmM3dVlOLy91TkFESHVhWnNXa1Fy?=
 =?utf-8?B?S2U0dS9sUS9qczZQQjhtNzAxYm4zMlFiTkkzOENmeHlFcldCYW9hS0lDZXVH?=
 =?utf-8?Q?IwIapbmtI47qe/ew=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00a5780e-a54c-43b6-ca8c-08da3ac0a80d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2022 00:27:15.5360
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +/sLpPdzLtqJ4aL7Jvq4z71DIFST15eP/oWjWeShQpwNt70pjbElz16v6d3l2Kk3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1898
X-Proofpoint-ORIG-GUID: EiDGoR0ygz14r71ybi9UXl4W0WLuni-Y
X-Proofpoint-GUID: EiDGoR0ygz14r71ybi9UXl4W0WLuni-Y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-20_08,2022-05-20_02,2022-02-23_01
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/20/22 4:37 AM, Shung-Hsi Yu wrote:
> It may not be immediately clear why that ld_imm64 test cases are
> rejected, especially for test1 and test2 where JMP to the 2nd
> instruction of BPF_LD_IMM64 is performed.
> 
> Add brief explaination of why each test case in verifier/ld_imm64.c
> should be rejected.
> 
> Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
> ---
>   .../testing/selftests/bpf/verifier/ld_imm64.c | 20 ++++++++++---------
>   1 file changed, 11 insertions(+), 9 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/verifier/ld_imm64.c b/tools/testing/selftests/bpf/verifier/ld_imm64.c
> index f9297900cea6..021312641aaf 100644
> --- a/tools/testing/selftests/bpf/verifier/ld_imm64.c
> +++ b/tools/testing/selftests/bpf/verifier/ld_imm64.c
> @@ -1,5 +1,6 @@
> +/* Note: BPF_LD_IMM64 is composed of two instructions of class BPF_LD */

> [...]LD | BPF_IMM | BPF_DW, 0, 0, 0, 0),
> @@ -42,7 +43,7 @@
>   	.result = REJECT,
>   },
>   {
> -	"test4 ld_imm64",
> +	"test4 ld_imm64: reject incomplete BPF_LD_IMM64 instruction",
>   	.insns = {
>   	BPF_RAW_INSN(BPF_LD | BPF_IMM | BPF_DW, 0, 0, 0, 0),
>   	BPF_EXIT_INSN(),
> @@ -70,7 +71,7 @@
>   	.retval = 1,
>   },
>   {
> -	"test8 ld_imm64",
> +	"test8 ld_imm64: reject 1st off!=0",

Let add some space like 'off != 0'. The same for
some of later test names.

>   	.insns = {
>   	BPF_RAW_INSN(BPF_LD | BPF_IMM | BPF_DW, 0, 0, 1, 1),
>   	BPF_RAW_INSN(0, 0, 0, 0, 1),
> @@ -80,7 +81,7 @@
>   	.result = REJECT,
>   },
>   {
> -	"test9 ld_imm64",
> +	"test9 ld_imm64: reject 2nd off!=0",
>   	.insns = {
>   	BPF_RAW_INSN(BPF_LD | BPF_IMM | BPF_DW, 0, 0, 0, 1),
>   	BPF_RAW_INSN(0, 0, 0, 1, 1),
> @@ -90,7 +91,7 @@
>   	.result = REJECT,
>   },
>   {
> -	"test10 ld_imm64",
> +	"test10 ld_imm64: reject 2nd dst_reg!=0",
>   	.insns = {
>   	BPF_RAW_INSN(BPF_LD | BPF_IMM | BPF_DW, 0, 0, 0, 1),
>   	BPF_RAW_INSN(0, BPF_REG_1, 0, 0, 1),
> @@ -100,7 +101,7 @@
>   	.result = REJECT,
>   },
>   {
> -	"test11 ld_imm64",
> +	"test11 ld_imm64: reject 2nd src_reg!=0",
>   	.insns = {
>   	BPF_RAW_INSN(BPF_LD | BPF_IMM | BPF_DW, 0, 0, 0, 1),
>   	BPF_RAW_INSN(0, 0, BPF_REG_1, 0, 1),
> @@ -113,6 +114,7 @@
>   	"test12 ld_imm64",
>   	.insns = {
>   	BPF_MOV64_IMM(BPF_REG_1, 0),
> +	/* BPF_REG_1 is interpreted as BPF_PSEUDO_MAP_FD */
>   	BPF_RAW_INSN(BPF_LD | BPF_IMM | BPF_DW, 0, BPF_REG_1, 0, 1),
>   	BPF_RAW_INSN(0, 0, 0, 0, 0),
>   	BPF_EXIT_INSN(),
> @@ -121,7 +123,7 @@
>   	.result = REJECT,
>   },
>   {
> -	"test13 ld_imm64",
> +	"test13 ld_imm64: 2nd src_reg!=0",
>   	.insns = {
>   	BPF_MOV64_IMM(BPF_REG_1, 0),
>   	BPF_RAW_INSN(BPF_LD | BPF_IMM | BPF_DW, 0, BPF_REG_1, 0, 1),
