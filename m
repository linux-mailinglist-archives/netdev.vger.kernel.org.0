Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD88852F6C1
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 02:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235316AbiEUA03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 20:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354203AbiEUA0X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 20:26:23 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AFC058E63;
        Fri, 20 May 2022 17:26:19 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24KMsHPj029476;
        Fri, 20 May 2022 17:25:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=lUQZDpirbqGUX51sgXUNWIBRff0Rzrt0VIkwMtO27qg=;
 b=ncFeVLftJbTI6juNvZ2ONryxLFUm2QtAwB0rJFUXtb7aLfxlfQlvIepgMTurPVs1YHyF
 MPP2ZlyDavXqFrW6IQN3LN1QrAb2efwkS7XOehaS/d9P90nOndHoDBSDPlGxHISIxaoF
 muvemwg8DusVJwvHF8zSsI+kV2WUudYTfZE= 
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2044.outbound.protection.outlook.com [104.47.56.44])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g5xexftwu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 May 2022 17:25:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SEmGxHqdfD45Ot47Li6kUaUuFwPDzniTA6rnUrD3nQuMd+5DCJO0OhshRAvPThY67G2E1j2AYuoBV9Fx+7UPo/TDkvx72STUTmsB5pOOXPSSBMn5+inBXN8U2w/cjK618wKYmZyCf9aevc9fFXq424Ku+mTf7Ea4NDKzqY4WNsh8Ptx9nrPSrSOOOrQaNB0crGzPLZFmguaclQtalgngNJSlPQVEFe7FCCu/+YhndymGyiDhUoUh81JK4QHDeVTcmZhFocTS/yyVLuoJDuvug1PZyAN5sLQETOPWgAW0JIt+ODjLyYmob+Lu/cH7E0lex+8Hf5VD59qohmVvvzvdAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lUQZDpirbqGUX51sgXUNWIBRff0Rzrt0VIkwMtO27qg=;
 b=Z7eyK6janTKUVM2RhhfoZpv219eTS9yuprwvnTTJ6KFJIm/j8v7ak8THYRRHhssvskDjiyqct+rfJR8imvoJDjZ6kWdASAP9sm7bUML2sEdEKJX6TWHHA7/sSQ2TCmjVTtvyfR+VMWLBeSOZXL3b3b9WFDzePbyHB38hfVM7eEhAWHHqsQxQ6dXRYb9yCI8XilF7CVM8/eb3X6FJti/vLMFgIG+V/VGhjMKcnlTBmUjhbBHDJu90ttQ5S9EFw1kAvjMQI7Zujt4eGjUMuKhaQ0BQApafMYeM6RmQ8TeJPMzM9nWJKX+7RBeWC7s8V2r81CMEwfgaQwfTTOqY6Qur4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by DM5PR15MB1898.namprd15.prod.outlook.com (2603:10b6:4:4e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.17; Sat, 21 May
 2022 00:25:38 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53%7]) with mapi id 15.20.5273.017; Sat, 21 May 2022
 00:25:38 +0000
Message-ID: <0cf50c32-ab67-ef23-7b84-ef1d4e007c33@fb.com>
Date:   Fri, 20 May 2022 17:25:36 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH bpf-next 2/4] bpf: verifier: explain opcode check in
 check_ld_imm()
Content-Language: en-US
From:   Yonghong Song <yhs@fb.com>
To:     Shung-Hsi Yu <shung-hsi.yu@suse.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
References: <20220520113728.12708-1-shung-hsi.yu@suse.com>
 <20220520113728.12708-3-shung-hsi.yu@suse.com>
 <f9511485-cda4-4e5e-fe1f-60ffe57e27d1@fb.com>
In-Reply-To: <f9511485-cda4-4e5e-fe1f-60ffe57e27d1@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR07CA0004.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::17) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 157a102f-cebf-459e-fa0c-08da3ac06e38
X-MS-TrafficTypeDiagnostic: DM5PR15MB1898:EE_
X-Microsoft-Antispam-PRVS: <DM5PR15MB189806E72023B179BC05E5BAD3D29@DM5PR15MB1898.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 30NObPz7DzMz9+jm31lPqLel0phaklOwMrsyg53D4fwzubsAfJOIJ7UdI2xeQ0jqCqnSwsFWG0W1BK1eL75oTyXa7MKmoNYKNgr/1XYMDETElt/aEd4FiXkbJYxyfaA2O18fSFoQfe+pmWZKrtEznneLK4oxdf4flmqk8e8nFyd0PCdRSkEzJ+1+Gb8yTMOS5pEeFuDROVxx56DuSAjJV8+FcmMT2VgrRSkB40T+LNRQ4RtAJE83yGHDbR9wRl3vs5b9Yqv+pZkJWjJ/T1bNeUmxML93lh7B5u9urmfYU1yJAgjnfEwrueAuLIsCzWSkhWuYSMGNyitUlgKxGgkmchuGAQmdEb60WZ46AwTG1qep+2EnfWIcDjx1EUnQr7F+kDC889GCrKL5gSXv0b8oDFStPVOkC6qzFsqi/GfEtC57eC00tLK+QCafw75elNMg+D2enHXsmOO2YYVP0Irin9zLNMR0JzKiJhwmDWMGRr9QUi31uqvbC9baNcNKY77G4tnwqx3JupxFhgtovqC0/zbUmRuD7Yhb+Dpn7hWWBxtna7Md3aIXO2ks4xD0l4+jvDOt0mh0jMYoPN/Tetnj1K6IFT9nqmP3cNr52CAULlKnYUIA/xWIzCdgAgj5KD96/7t4E03w7H7NfR2ykuE+GCyEFJRDT92xkHukP/STD5z8Y/5oHP+7V/QO5U8wyuRxrs9wlKAhynt8vxhbAfH3KpBSv3vKfHW1hAqE8Gw1AG+aPreoD550IPLoZGEfelK6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(83380400001)(508600001)(36756003)(6486002)(4326008)(38100700002)(54906003)(5660300002)(6506007)(6512007)(2616005)(31686004)(31696002)(66946007)(66476007)(186003)(8676002)(316002)(2906002)(53546011)(86362001)(66556008)(52116002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eUNpeDhxNVhFNmkxNS9oMU5MTGV6eW9ORTZ2QlNIcmhYWm83aFF6TFdKb21V?=
 =?utf-8?B?dTFmcDdxOS9DWkFRWWVkS2Zmd1dkQUE3TUFDbDNEVFVob3M2dEo3a3J4K1Fw?=
 =?utf-8?B?TTgzN0U2UnZFbWcxWDk0NFovYnphcm9ueStQWWRxcjhSQy9pckFsZm1hS2ZG?=
 =?utf-8?B?Qzg1N2JXb0FYSm5EWmJZempsVkRCU0I5azJFY0FLNFBPRlFXRTFNVHlmWDB0?=
 =?utf-8?B?TnAwK3FMSGhwa2ZkS1FCNnNVUHAva2pGTy81Qk1NZEUxZ3hFaTVYaDRsZGNR?=
 =?utf-8?B?V25Cc1hySC9GVDZGcUd2azA1RDJzTzI5YXJxR1B3b0NkZWZJcUtQVmxScWtX?=
 =?utf-8?B?YkhDU3lkYXhhTHhuS0NsQm1mM3lxSFI5cnNmUzNsUkJPcTB1cnBNTW9wVENN?=
 =?utf-8?B?TWRQOXp6VEppRTE5ZE0zeTA3bUpTMUNVajNMemdvQldaNENscHlySkcyOUEr?=
 =?utf-8?B?V1orZUF0NjBJbXcxVndoZE1WZEpFSTJvbkN6ZEd0bUFuOG1jZGQvWE1IVDE3?=
 =?utf-8?B?bWR3cEJDaTJ6RTJ1enZacEo1MTB4bzJXTXNXdkVqTDEwem16VWRyOW1lL1Fu?=
 =?utf-8?B?RlcwOXlQK3ZxNlBTMGhkMVZudHcySTU3NnZ1S3JPUW1BbWtGcUVFcFBLOG95?=
 =?utf-8?B?dEh0VFFmQ2Q2a0ZHcUIxRlBFT0NHZDFFZkJNMmxrVkgvZnM5dDVVcHVUMGlF?=
 =?utf-8?B?SXdXVGk4dUYvOU9sc21XR3VVZjVGOHkzQ0s1OUYvRVo1NGhXR0Vycjc0aFRn?=
 =?utf-8?B?T2d0dE9nbXVDS1pqek5FSDNXWm9EMjg0RFVZdWxBTnFFOVJOWnB2VU5vWUNp?=
 =?utf-8?B?aXI2WHhRVEtoWFd5RzZ0Yk40bTF6Z3RTSE15MEg1dk1zT3hER0swclFXcktm?=
 =?utf-8?B?MDFVWmpSS3d3TzQ4VERtR29pSHpwS2ZZVnFTS3hyQW1zN3FndHhod2x0RGxo?=
 =?utf-8?B?NDllNVVocmpUcGJZTURNU1MwMWhidDZidVg5b2tia3hLZUJCTjFSTDJEUzZs?=
 =?utf-8?B?UVJta0haQnR2TWNUOXY2WkxLeXR3NmZoaDhmSHkralBoaHhFWVYvUnJMbTlN?=
 =?utf-8?B?WG5VZ1dkSmFZa09XaTl6UWlCc3h0UXBvTjJMdk9tdStsb0IxaS9jVm9oTUdv?=
 =?utf-8?B?Z25uMDNFQ25sYjM5T1dHcE5DRWhlSER4c3JQMlFPMDRyWjBPUytuQVIwVG56?=
 =?utf-8?B?RFA3TEdkZFZNYVhJa21nNCtQdyt5MHNSZElUeUhPUUxRK3psTCt3QmNUSG5K?=
 =?utf-8?B?ZXFaVWNRbE1pdlg1bFliSUsrK2sydDBJaWdvbTFhWXYyWWRkeXpIVGliK25o?=
 =?utf-8?B?VUxjUmdwaE9OUFdZOGk2U2pMKzErMkRubXV0RTNzT2RrOWdicEFPY3hlbHJP?=
 =?utf-8?B?bUNSRFdEUHNRNWdvVGoraldBY3hnZk5BRmRYdEtQNVVCSGNnbUp4VnNpQTZB?=
 =?utf-8?B?TGVpc2NhclhMd0FXMUtGMHRRTm16cys5V24wUjN5bWxXaEJyVW5JSkJBd0Zt?=
 =?utf-8?B?Qk5PYUllMmlmWFIrWUdNNlp6SzVSWUhTT1VJZTJ2d051RSt0WnVzY3JwYWcw?=
 =?utf-8?B?NDRnOWRabkJHa0dpV2ZCWXZtVWJPNmpjM0Jkb01aaXZVeUV1N2x0SGtVOUJ5?=
 =?utf-8?B?aml4dW1hVXJzaVVsbHBiajlhY0VnZ1Z4VWpHa3hiTEtONHdWTUswbmJUd1F6?=
 =?utf-8?B?Mjc2YkJRRmQ3SXVCSm1iT29FOVVwZGNEeW9ZbnNsTWhFTk5vcnZ0OVFjNW5l?=
 =?utf-8?B?aGw5R0ROMk9kV1ptNjFmVWdsMTNBdFhGaW9vSitxY2JQNGFSdlU2YUx1cHRO?=
 =?utf-8?B?bVRTRkZLbUVmMEJ2aHJEeERlS3kybk1JMkY2MVJUR00xUEZaaGlKM2NveUhv?=
 =?utf-8?B?VXhIL0hHaXQ4ZnlQQUF5bEg3b1VIeUlySDhGUU96ZU12U1ZJbWNYU2NKMU12?=
 =?utf-8?B?d0o0cFAzWlA2eVhxMmpyNlliUU5MNWtvd1dPclkvU0RTTXlsM2VCeTFrdVFy?=
 =?utf-8?B?R3lRVUFENlI2SlpBYll4Rm4wU1JLQzljWVZ3OFUzb3lZbTlBaDFlK282SFd2?=
 =?utf-8?B?Y2pCR01YSGxqRm9rR1Y2c1l1QnFaQ05ESXFXVy96dkhpS1JJSWpKU3hXanl1?=
 =?utf-8?B?ekRoVXV6RFlrYzFjRVAxQzFYcnN2VHJkZHprQkN4dWx3RDBUKzBPcmFiOE1U?=
 =?utf-8?B?TTdRSmtQRGJPMnFYNTh5YlJRUGpzM3JNNmJBUlBpaEMyNWNwZ2ZndVF2U2h6?=
 =?utf-8?B?N1F6VGEzcStRUmVYd1lFSVdCS3ZzMllEem5IVjRoY3BuZlcveWxYd05Oajdz?=
 =?utf-8?B?ZzBYdDIyRkpJMDV2SWZFNTJ2NkdjTWNYSktpcHJDUTBpempYd2NvYXE0ZDFL?=
 =?utf-8?Q?JceA275BEgLUm3+g=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 157a102f-cebf-459e-fa0c-08da3ac06e38
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2022 00:25:38.5268
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ry5r6tel94UwBgDH9W5Fte7EIiv6bgckNtG5hqzNc3suTmIzKBaCjWQH3QW3OTET
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1898
X-Proofpoint-ORIG-GUID: MC0rCGygHAnDa7l9PqwRTX2V7VDEkloo
X-Proofpoint-GUID: MC0rCGygHAnDa7l9PqwRTX2V7VDEkloo
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



On 5/20/22 4:50 PM, Yonghong Song wrote:
> 
> 
> On 5/20/22 4:37 AM, Shung-Hsi Yu wrote:
>> The BPF_SIZE check in the beginning of check_ld_imm() actually guard
>> against program with JMP instructions that goes to the second
>> instruction of BPF_LD_IMM64, but may be easily dismissed as an simple
>> opcode check that's duplicating the effort of bpf_opcode_in_insntable().
>>
>> Add comment to better reflect the importance of the check.
>>
>> Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
>> ---
>>   kernel/bpf/verifier.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>> index 79a2695ee2e2..133929751f80 100644
>> --- a/kernel/bpf/verifier.c
>> +++ b/kernel/bpf/verifier.c
>> @@ -9921,6 +9921,10 @@ static int check_ld_imm(struct bpf_verifier_env 
>> *env, struct bpf_insn *insn)
>>       struct bpf_map *map;
>>       int err;
>> +    /* checks that this is not the second part of BPF_LD_IMM64, which is
>> +     * skipped over during opcode check, but a JMP with invalid 
>> offset may
>> +     * cause check_ld_imm() to be called upon it.
>> +     */
> 
> The check_ld_imm() call context is:
> 
>                  } else if (class == BPF_LD) {
>                          u8 mode = BPF_MODE(insn->code);
> 
>                          if (mode == BPF_ABS || mode == BPF_IND) {
>                                  err = check_ld_abs(env, insn);
>                                  if (err)
>                                          return err;
> 
>                          } else if (mode == BPF_IMM) {
>                                  err = check_ld_imm(env, insn);
>                                  if (err)
>                                          return err;
> 
>                                  env->insn_idx++;
>                                  sanitize_mark_insn_seen(env);
>                          } else {
>                                  verbose(env, "invalid BPF_LD mode\n");
>                                  return -EINVAL;
>                          }
>                  }
> 
> which is a normal checking of LD_imm64 insn.
> 
> I think the to-be-added comment is incorrect and unnecessary.

Okay, double check again and now I understand what happens
when hitting the second insn of ldimm64 with a branch target.
Here we have BPF_LD = 0 and BPF_IMM = 0, so for a branch
target to the 2nd part of ldimm64, it will come to
check_ld_imm() and have error "invalid BPF_LD_IMM insn"

So check_ld_imm() is to check whether the insn is a
*legal* insn for the first part of ldimm64.

So the comment may be rewritten as below.

This is to verify whether an insn is a BPF_LD_IMM64
or not. But since BPF_LD = 0 and BPF_IMM = 0, if the branch
target comes to the second part of BPF_LD_IMM64,
the control may come here as well.

> 
>>       if (BPF_SIZE(insn->code) != BPF_DW) {
>>           verbose(env, "invalid BPF_LD_IMM insn\n");
>>           return -EINVAL;
