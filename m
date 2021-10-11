Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E88D842970D
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 20:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232836AbhJKSpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 14:45:54 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:30952 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231281AbhJKSpx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 14:45:53 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19BI7N1K011658;
        Mon, 11 Oct 2021 11:43:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=McnjM+SdcAjw26H5J4eTzHu8PdwUT5sDyU8zOJ2soYs=;
 b=kbYNNbEdF5TDHegSLab506fUZGoeWEuc//k8qQM1u08dTAj0MGG2IiABN5jvF0ZnW+9d
 V/5B6NQSf1AmVN7Wqv2vtDxXwWJFFSNVJARRCbkKGrVKvFItN2UN+KfF/RPvY2biTQy1
 RS1mZJoMOW6Ts5Q6WZFx3xFJaFXXpi3RrJE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3bmhwuky24-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 11 Oct 2021 11:43:39 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Mon, 11 Oct 2021 11:43:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AflrtwGZDhfj9mXuBWi3TrvHLI8581iCav9hk8NUBY97jXsm/dBM/XJ6tr7u3CntkxM7jjnuJUAYeAJnLO1T2/HLq02YnVx+XvgVhpRT/kV+LlLR057SuTSqlT2vSIl/zVFT7Z6aSIaEPfESJzwgcWQdth/z8Ns1Eu12613WfjdaW4w1jltpAqYu/tK+kFqJmblRGuo4qhuBKzR6xNmjWRLk6Nch8+iENwCNyYBA8HWP4xXJ34cWpz1nnvZ0rfKErnPB/Gwd+7FwTURZhko8N2L62oUHi74SkKUG40IG9AjPLqyHuJp/1YTe4fF4jXwnVHTpLbH1waT7prroNHQN3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=74nJyqz2YfMzIOoPiQ1Y8+9t1ot6JqlP+l4OHLIYYeE=;
 b=GvpRqCjA1AE9hr4IDJKwaOHz6f36WuyoTKVjB2Gh9hoZktMPsu51m0mBCs6SiomRheFjMW1eobPeD2tMMgzeOFR7p5bN0cCTFBk3wl+NxvZxmiXvzwlX1tZNaYKNC70+mPkozUV+1XiFCwCLu0FCVzb+GzchE4j7th0vP3xoVt/eD02oGdt7kzLwMp5UqjqX2Hez4foJPnQTbEcpsEVGP4V/ryOqFIR35Z/XYVheloreqMz02GtkQAnRLmkou/1ua9+F7+RYlJMfwfvcdprwcWR0ixfc6hLQZEjtiESAqW9n8+vu4WheC9HppZAWabLs7jAP147tP2CMlHPtJr3a6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SN6PR15MB2398.namprd15.prod.outlook.com (2603:10b6:805:25::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Mon, 11 Oct
 2021 18:43:37 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::6c34:bcb:51af:6160]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::6c34:bcb:51af:6160%8]) with mapi id 15.20.4587.026; Mon, 11 Oct 2021
 18:43:37 +0000
Date:   Mon, 11 Oct 2021 11:43:33 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Joanne Koong <joannekoong@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next v2 0/3] Add XDP support for bpf_load_hdr_opt
Message-ID: <20211011184333.sb7zjdsty7gmtlvl@kafai-mbp>
References: <20211006230543.3928580-1-joannekoong@fb.com>
 <87h7dsnbh5.fsf@toke.dk>
 <9f8c195c-9c03-b398-2803-386c7af99748@fb.com>
 <43bfb0fe-5476-c62c-51f2-a83da9fef659@iogearbox.net>
 <20211007235203.uksujks57djohg3p@kafai-mbp>
 <87lf33jh04.fsf@toke.dk>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87lf33jh04.fsf@toke.dk>
X-ClientProxiedBy: BL1PR13CA0418.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::33) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
Received: from kafai-mbp (2620:10d:c091:480::1:6d9d) by BL1PR13CA0418.namprd13.prod.outlook.com (2603:10b6:208:2c2::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.4 via Frontend Transport; Mon, 11 Oct 2021 18:43:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: de065df9-84cf-4334-7ca6-08d98ce7096b
X-MS-TrafficTypeDiagnostic: SN6PR15MB2398:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR15MB239857A1428EA7A22ED38594D5B59@SN6PR15MB2398.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FqBa+1buhic7Jxs4tIYuaG3Ic0aCB7IsnAPnzD3+4lP0jQTR6rWqGF6nEJHFK8rqrbTDdgeYcZh3AoXbelNsdc/z04UUJTtZN339oX2hAHQ4oxOY70SjwXv+Dl7yzu5xQqAy9sHekzuVfzLE52LBkCHhMwj0DO5zYqs52AsqO+dTeFnIHJBU1J3CeeBAqZr94WzlXI7hMB8e3ORavObfO7auv5AmiQbGof7BDHq12jgwJW0rjsjWF625XgLqmjk28l/1v70/Kf2T8vJNuewL/rwNfueRS3esxsZDGJjfq0HOXh56riyAgD733jDT2lmCv16a9kpe4IvSzY1JBumoEWxyAElQpmHCRZYaZ9Luyo5Ql0Grdiyh1IX7qKt5JE9d1RtX3bNIuaLF/nI7xMcsJFkieeE69ImBDMquvyY8W1JwDov+fmCFNWe2qIOyFCmEFYcpBaiGoFxWZb0QidXwTp+zW5m2WaddCxkCx7MrHtQyTwTKrNdXz21xD0SPHDGDgnF5Ohd08qeJkcyJkHUeOyhjnFinh/EXs4IgZwlIq/Rx89tZr2MkWk9aCaQmamO85LEEprD9k4Y3YCvov2/K72qQJ5VMCszno7u+NtpUcCMZfVkso/4P9LPvActBezmasVgJxX6Wg94ellq/TXcbyQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(8936002)(6666004)(186003)(54906003)(86362001)(9686003)(33716001)(55016002)(5660300002)(66946007)(66556008)(52116002)(66476007)(2906002)(1076003)(8676002)(508600001)(6496006)(4326008)(38100700002)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?wWdRe1aLqkBb5MYmd159iRg4k80ecAP1qYK1ReSibGqYlyFCfmxWSN4Zrz?=
 =?iso-8859-1?Q?QfaWRzBqtxxJDPreibzezNtszx2IVgi+ZdyhsFDOFXfCTUyz7j/1DWe09W?=
 =?iso-8859-1?Q?RQgomocnsTrlkrBefVHgsbqNeYHuWMX3nR91EiC2jRuj4bjg3jRd9H4/tF?=
 =?iso-8859-1?Q?/LYSllSJKD4tk2iG/YGnp7hHI/Rt35OddqBLNutgFHI6AaRcnmo+hJ+bkY?=
 =?iso-8859-1?Q?FQxIpCsA1Q7vM5rSMMnmRXQudUUwjFXE9EIlwD/feS8VURWGHf1K3kabWC?=
 =?iso-8859-1?Q?p+TFqHwXQb19giygUqUz3718qquTphesbXZFZarBKsWf1GQ+ru8OG2Lpng?=
 =?iso-8859-1?Q?tujsOq5ls5vO2bACoA0adYyJCaaTL1RG1AdnJgU1TF0G2PPSc0xWaZP1xq?=
 =?iso-8859-1?Q?uBZLsg8ayCoa6zIlfgIjw4Y7VJzGCR5Mcz1N/YiVID7Rs8t69plDueFQxN?=
 =?iso-8859-1?Q?iTLz4Y3gBju70R5+MSMWl+cdLA52bJFq4lS3cXMLQ2CN8HQSSxv+9dpoFg?=
 =?iso-8859-1?Q?J+w120Y1CCQmH5BQvk5z9oGkhkwPDTpw/aefILKWK8Tdkaeq19EAxNLCAu?=
 =?iso-8859-1?Q?9KOMWiSVH2mnRAeTQ8URv7+885p8/0qGQ1hYhrmnLhPQ1kqEbZC7HeJwJZ?=
 =?iso-8859-1?Q?9fRpr8iSDRsse9ra+JKsx3CWHpyJkm640WrBUgxmQzFgDaTSqzxt5CscNP?=
 =?iso-8859-1?Q?B8ofbsHLJrUS7uK2LuYkCC10m1esvUjyQlXMW4gFL+cyykjalmEMntQVAi?=
 =?iso-8859-1?Q?HfAB0zM17XC3pHt2BwdEBdr1fN1040VfyOI5g4fP73TI0zsDxsIILIvirk?=
 =?iso-8859-1?Q?Fgt67CajlC3D9Pa801EmoEaaEjOUKkaaAjIfgejH8kr8vE09UeIuPcne+h?=
 =?iso-8859-1?Q?7av0pEXL03CRs/rNTc9HVGc5ba8lrX4BkkRIiHVbavVA0qxtfVxw6ef+0A?=
 =?iso-8859-1?Q?WeRV7oBjoKk+wVu+XPH/JZUyGiU4dYMW2YcuW1Tu4LIf+g+x6pv+tj1VL4?=
 =?iso-8859-1?Q?JZiGxVE3qTSrHO8EaWO/SMny8fsDFbSLg3WVUBjGxDdsY5puNPX3Tnyy/G?=
 =?iso-8859-1?Q?7aEOGC6NKy3sS4SNOUg3N4SIQ2SUuODh1W4r6lpvbZgzq2gMWiy/r/ccmd?=
 =?iso-8859-1?Q?PRb8eGpLdqQWVJY4Y5SH/77OlXQrGQjmzNMKgASm+JbN+3ztTa1FdtPKoQ?=
 =?iso-8859-1?Q?tGhaR3vl9UJiP6hmvQmR0Y7q8XG6ok4xAe9m5u/igQpC7odT+fjrvG7uKc?=
 =?iso-8859-1?Q?jAcm6iuYVyqYcrdibn6RezJCUuLhR4jAYwKelzdC1xaa7PXke/MgBc7/7a?=
 =?iso-8859-1?Q?hY05tplihjw5U/qKOozwBnSsfQC2NEN4SgjWDMG6F90ceiXK+LBV2arsJn?=
 =?iso-8859-1?Q?uurQ7EMEi9HZZjihAdCTUgaGVOE9fk+A=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: de065df9-84cf-4334-7ca6-08d98ce7096b
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2021 18:43:37.3954
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vy5jhccRQpVTi+GzQmom6jrn8CfzBIx8HDdGyYFjflyWbqF0YPLVIMUWjW/SRSsD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2398
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: c-lQX-xOmTB5jRnYsgqbhVTExT0IB_jF
X-Proofpoint-ORIG-GUID: c-lQX-xOmTB5jRnYsgqbhVTExT0IB_jF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-11_06,2021-10-11_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 lowpriorityscore=0
 mlxlogscore=834 suspectscore=0 impostorscore=0 malwarescore=0 mlxscore=0
 spamscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110110108
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 09, 2021 at 12:20:27AM +0200, Toke Høiland-Jørgensen wrote:
> So if we can't fix the verifier, maybe we could come up with a more
> general helper for packet parsing? Something like:
> 
> bpf_for_each_pkt_chunk(ctx, offset, callback_fn, callback_arg)
> {
>   ptr = ctx->data + offset;
>   while (ptr < ctx->data_end) {
>     offset = callback_fn(ptr, ctx->data_end, callback_arg);
>     if (offset == 0)
>       return 0;
>     ptr += offset;
>   }
>   
>   // out of bounds before callback was done
>   return -EINVAL;
> }
>    
> This would work for parsing any kind of packet header or TLV-style data
> without having to teach the kernel about each header type. It'll have
> quite a bit of overhead if all the callbacks happen via indirect calls,
> but maybe the verifier can inline the calls (or at least turn them into
> direct CALL instructions)?
Direct call different callback_fn?  bpf_for_each_pkt_chunk() is a kernel
function.  It would be nice if the verifier could do that.

This for_each helper had been considered also.  Other than the need
to callback in a loop, the thought was to extend the existing
bpf_load_hdr_opt() because our initial feedback is the same
header handling logic cannot be used in xdp which is confusing.

I don't mind to go with the for_each helper.  However, with another
thought, if it needs to call a function in the loop anyway, I think
it could also be done in bpf by putting a global function in a loop.
Need to try and double check.
