Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF1052F667
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 01:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351257AbiETXvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 19:51:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353370AbiETXuu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 19:50:50 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 655FFD46;
        Fri, 20 May 2022 16:50:45 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24KMrt6t023419;
        Fri, 20 May 2022 16:50:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=vagT83AYG1Yjj49z/z51HFxNAKC0bEWeotOX1g9lH9E=;
 b=Pgxm3ubKc4l5qCu0lK+bM/C4TZTQhcX0JjKQaY21CS08OB3vK799GUPFKsRF5C6jdMTA
 jl7D2I45XlJ+JuDSNK+fsQ40Xn+iuaMDoJM2KuAyXFxe/sPPFulvXdqM0puKsBZFO3V2
 G7DwtL6+3ZkfPHVXl6CPbSMXNOLv1oRMpLM= 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g604bq5du-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 May 2022 16:50:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kx5WOQhBb9FqwTZQ+eK7zVXWPv6VLGe7eX2VNGzE43uYI+weRyxdKkiYVCQRM0ePUs5oJi+9EPty+B6rfCrR2uU/D88T1dMGS+USMaXTp5epF+vnRJtL5sF+6fd6yIANRLWIajoosaNN8dQCya3XEL5xt0o50mwHPIUn7EW8vEvpBfc1mvTq5YtV+C95qf4zHJkw8L8u23P5QHMV0KYl3B8Fukh2N+LQaPd/86LICJYy6wb+SdJPj7Q1ZOasbzwvjdaUTQKXsvMSJ1tJQg1nmKpLP+a+KlMxEWLxyYRthKUROR+ftidYhdiZMM+fDFcMV5JjPmqH3d6R3GhVTO801Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vagT83AYG1Yjj49z/z51HFxNAKC0bEWeotOX1g9lH9E=;
 b=kA7Z1zhPP8BnpKthIIUbpVSNk00wdZm8GGEuzF4lmBQOPU3Y5NCuSMpa8qWsVjAcGUqFncXOoz5yuQrllkZ+0hHqX/r1VB2d/RVOlE/KVVsAieEkeqzpCKPV8zG2iiVOpbw7YahVpESvxhgZuEOX9+06cb9wRwXP/Z6ba/Nbn7DfAc48faNPN3678wap5IEjLNUMHgnPOjvV2loPpaGNrxS4BE9kpzX0XesXhb/Dny9wD9GgYxg0tr5y+y4jtLv/4S6W/kMurUEttiYQs78eTTdP6vGLIebo5p+gjeo0VhG6Fd6Yxv162uwYxlFl/CvtefaucLqXM/+d+PfDi1aSIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by DM4PR15MB5456.namprd15.prod.outlook.com (2603:10b6:8:8b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.15; Fri, 20 May
 2022 23:50:23 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53%7]) with mapi id 15.20.5273.017; Fri, 20 May 2022
 23:50:23 +0000
Message-ID: <f9511485-cda4-4e5e-fe1f-60ffe57e27d1@fb.com>
Date:   Fri, 20 May 2022 16:50:21 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH bpf-next 2/4] bpf: verifier: explain opcode check in
 check_ld_imm()
Content-Language: en-US
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
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220520113728.12708-3-shung-hsi.yu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR02CA0024.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::37) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e37ed88f-a9d0-4405-97e7-08da3abb81af
X-MS-TrafficTypeDiagnostic: DM4PR15MB5456:EE_
X-Microsoft-Antispam-PRVS: <DM4PR15MB545692CE6A2D1E0AA15E4DE6D3D39@DM4PR15MB5456.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pjnojBT9nLOfijBcR4WiWmU03vJi8THRWsbfOTOM2DEuV/Je249Hmf8elYRLetqO3CbCRfM1DuEYWQFpc8J87MLx9PIERoEDLmbzm5MVvfIqvVXDWdH0Jj5x5k8UnoDBC2pdU9edj6LHry11lv0eMRiphkFOeWj4paOehtWDTiMaznFJKhDo3iEk06TXV1zmuQZBzsO5DM37A5f+KejM9QljrBE0FXaAyHp7NlK6KnnjEiE0CX32/BsV/COVIWL7P4cBC+JCjfabvgOvlkgn8ZmQ+fgnP4ib1Oy0r54mo0I4xY1f51kBcJ2xdEyZGul/ub2T9knUFnHiCFHwCYMzI+QAgFHaQVVPEcCjIYrkJ044Ya56JgBw51pyl/c0Njaf1+l337CklcGtW4S81lYVaOI6I9F+z19y7Rih7ynsWGKRDuwf0YBOaYLjCSgMlNBhI8H90115HvTbWyqbw0+b/37jMozZXLBZbihK3adgwPkiGAebevdDNxEYTmSh/cgSdSApbdmFaa+CNkAAVRKikEINZCaap9U63McuEMwuWnvxAW9IZVt9ze6j+Ubud80Fomr1mKj2wZ9iGJA7b6wM7kD4ivKbYVgAmc3W2EuMTMkXcXii6B32H7OiQlRKd8PR/R1NVd0HfO8pCPkRYOhY4fCPR0r4wovuV0INuvqx1Dv0OCBGxnW0hI/msPh9uL8r4n1t7I5P8n6LIkpOqZhpBtWOdL4QdgAHy0n3tyVkwMNLqXg/H9gnVXqLM/+cBP0B
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(54906003)(2616005)(316002)(508600001)(6486002)(6506007)(52116002)(38100700002)(186003)(86362001)(8936002)(8676002)(2906002)(4326008)(31686004)(66476007)(66556008)(66946007)(5660300002)(53546011)(31696002)(6512007)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?emdURE5vNUVVYTR4Y2J1dGwveUI0NHJaMk5ncGVsS2FhamM1b3JhS0VwTURo?=
 =?utf-8?B?MmdmS01tdTZmdjRUNTlSeEMyeVdlTWZaRDlPdklWNTZXRUlIbnBXWm1QTHgx?=
 =?utf-8?B?aWU4dE01dmtEbjRYUTRjZVJHMGhJUUZtMDdLSFE1OXBNS3VhK2hUaEFTcnN3?=
 =?utf-8?B?UUsrREFKWFVWOG90NC9JQUdlWFlROTFhT2FtaVkzdmYvWjRZT3pnRVBxWjJN?=
 =?utf-8?B?aEQra0srUjdwTzFDb2NkQk5HUzIzZjl2Vklva1AwNFZsLzFXbFFFNmFLWDdJ?=
 =?utf-8?B?amtReldIQlQvdFNzTEFUNEk3TU5wekJ6cFNUdjFZaHA4UWRxRmN0TWx0SGJU?=
 =?utf-8?B?Q2pnT0JRc1RQeTRoZ2tqMmJ4R3hKZlFIOUc1UjlvU1lDZi9nYW1xRW5XYkZz?=
 =?utf-8?B?SEhYYzdUUmVvdExUNUN6bVlqTFYxV04xNFVmUm5WZkpPOGdJcWc1dVVUYjhC?=
 =?utf-8?B?WCt5bVZPR09MajR2ajg1Z2wyQXVSQTZFck1qVkhPY2doaDlOeWpBYmt1T25y?=
 =?utf-8?B?SlBBZjE5K2JDeWNCMXRYOWVzQzUyNnVNQUkycGtUUHhVb3pEaXJVdUF0Q0Zv?=
 =?utf-8?B?ZXFycVVMN2NycjRlMjF0WmxSa0grUldqVEJDZlIxbzlJREdXT0FBRlZRYUFU?=
 =?utf-8?B?MGRpbTl5Ly9EMUkyS3BweG83M0pMMkE1OFlMcGdjUHBBVDdLNFYwV05mVklS?=
 =?utf-8?B?eUZNK1Azc0ppMGVpZVlGdXhUbkxUSFVIcEE4bGRoVkx0SFFhc296WXhjR1d3?=
 =?utf-8?B?ZitVeENEUjQ2ZjBOVnJ6VVdTSTdXVjZGVGk5WkJpclY0OHU3YUNuOGxpdzcy?=
 =?utf-8?B?RXRXd3IyZEp4cm1RT1pLUkpMcTNXeVFHaEhnWHJwRUdtRTI0TGlGMnJaOXgz?=
 =?utf-8?B?N296dTNwVUUzdXppNGhSUHhMcWpIT0ZlR1oyTXFiQ04wODNqWU9aTTY0NGNP?=
 =?utf-8?B?bVNsaHVaQit1VC90c2VNNnFXQjBYc3REUTJKeHdCVlU1YjlxKzRYRUE3aGpR?=
 =?utf-8?B?dTExdFpKVkxQbVRSN3B1a3p5T0srejhRQkh1dC9wM2JwelVVVXE5WWdIS05z?=
 =?utf-8?B?TXVmS1BhU2l0Nm12bnMvdWJub0JjT1BHVWR6NDVxRXZkVWU3ZXdsZFdzYmh4?=
 =?utf-8?B?endHMWJYYXRKZzdvem5lM2MyQ21WZHZSNlFSRlZIb09kMlhMU3hvRGNpbXNz?=
 =?utf-8?B?dnhSUHp0NitNeE9tcG10bzNLYi9OQy8xQlNLZ0IzSzZyZ1RQc1lwRFpQZjVY?=
 =?utf-8?B?ZTUwcDg4cmVkNFovKzZ1S0gxVGRQeEZYNFN1WUorMXUzQUgzaDd3eXFkblhF?=
 =?utf-8?B?OGFLY0FramFlbnNzUDJrcDBGbU43UGJxMk5SNEJibFUrdWpCc2F2V1RxVlc3?=
 =?utf-8?B?bEs2aVJ2Z3Y5YllJMTkzNHB0VWZSUnlzTk1kYWhUTWc0eGF5cDNqTHJFQkxz?=
 =?utf-8?B?SzhlT1p0ZnkvOGFYTTdrU1JBamdKZGNrdDk3K0duZVhiRFg1ZXN2Nm81WTZO?=
 =?utf-8?B?SDd6aUNFYXdYQk9YVzZqV0Y3TEx5U3pPQ1Urbmx2bGVEU3Z4N1pJZytJeGRa?=
 =?utf-8?B?TGFzRHM2dDExM2FmN21VUG1TOWVacTUrOXpqaE1zK29PZWxySE9CR0pOWmRF?=
 =?utf-8?B?TVRXSVE2bjk0eFZXUk5rckR2M2IyVW5mY1o3STVMUHZpcks0cTFYRFlrMDgz?=
 =?utf-8?B?NGFYQmlsdFhadXRSVG50cUVFQml4LzdJdzQzQWhsQWRyMEVVUGZ1UWh3cFBY?=
 =?utf-8?B?T3QzWXE2Wnh4S29oZW9rZ2JMWVZoZDlOV3NhWlhGZkxJRXNjZ0VDbFlFOGlj?=
 =?utf-8?B?ckdSdjlsVDY4MXhqK2RtU1RqNzZBNlo3UTFqVlBQQ1hqbTJrcGZjeTRQYzQz?=
 =?utf-8?B?Y3JBZVdzb28vTE9iT1RlQWliWXAvZHQ3WGpkdWtLNHhGQ1VEa29WNXhleXFR?=
 =?utf-8?B?VGkySWtBR2RJa04renVFZkNxd2hiZW1YU0xDYndTUThOcmlCYk81aFFaZ2Zw?=
 =?utf-8?B?Z1Y3Yi9HeXkyQzlBbGQ0WEZ3bjdTTkFqR3ptNTlSUkFmQWh0UHNYSXhBaFJP?=
 =?utf-8?B?N1hFa3VkV042UkkyZXdEVmtraVpLaXBoc1R1WXo2QTh1cElEL0I1TGpBRmlw?=
 =?utf-8?B?NEdPa3lVK1ltS2VNejFLblpqY3k2T1JWRC9xZkRtZTJ0a2JUMjU1TEJwRUp5?=
 =?utf-8?B?WGRIZmxkZlFWSTBpLzkxQk1ZQmZtY3lNNWRTT3pSOWJDV1lhMVlXUUN0TnEr?=
 =?utf-8?B?Z3NpSzBQaDRXSVlDMVhOOVVFaTg3MHp0TGpLbWF1R0x1OUdNTUlac1Avem1i?=
 =?utf-8?B?Wmk5dnptS1J2K0NxUEhEdmhUV3FpU1RXVENkM01SS3FnMnk4SmpBNnhTcTU2?=
 =?utf-8?Q?GPSHTGEX4kJcaecQ=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e37ed88f-a9d0-4405-97e7-08da3abb81af
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2022 23:50:23.6972
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4x0n6DTSQWo4kymcrBXN9Rq2YtLPATo2m98d9mcH6ncgoZPM7PlekWFChx71Xczg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR15MB5456
X-Proofpoint-ORIG-GUID: CPN3rCs-_56Ca3fr_BaFq6T0SK2gyABl
X-Proofpoint-GUID: CPN3rCs-_56Ca3fr_BaFq6T0SK2gyABl
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
> The BPF_SIZE check in the beginning of check_ld_imm() actually guard
> against program with JMP instructions that goes to the second
> instruction of BPF_LD_IMM64, but may be easily dismissed as an simple
> opcode check that's duplicating the effort of bpf_opcode_in_insntable().
> 
> Add comment to better reflect the importance of the check.
> 
> Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
> ---
>   kernel/bpf/verifier.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 79a2695ee2e2..133929751f80 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -9921,6 +9921,10 @@ static int check_ld_imm(struct bpf_verifier_env *env, struct bpf_insn *insn)
>   	struct bpf_map *map;
>   	int err;
>   
> +	/* checks that this is not the second part of BPF_LD_IMM64, which is
> +	 * skipped over during opcode check, but a JMP with invalid offset may
> +	 * cause check_ld_imm() to be called upon it.
> +	 */

The check_ld_imm() call context is:

                 } else if (class == BPF_LD) {
                         u8 mode = BPF_MODE(insn->code);

                         if (mode == BPF_ABS || mode == BPF_IND) {
                                 err = check_ld_abs(env, insn);
                                 if (err)
                                         return err;

                         } else if (mode == BPF_IMM) {
                                 err = check_ld_imm(env, insn);
                                 if (err)
                                         return err;

                                 env->insn_idx++;
                                 sanitize_mark_insn_seen(env);
                         } else {
                                 verbose(env, "invalid BPF_LD mode\n");
                                 return -EINVAL;
                         }
                 }

which is a normal checking of LD_imm64 insn.

I think the to-be-added comment is incorrect and unnecessary.

>   	if (BPF_SIZE(insn->code) != BPF_DW) {
>   		verbose(env, "invalid BPF_LD_IMM insn\n");
>   		return -EINVAL;
