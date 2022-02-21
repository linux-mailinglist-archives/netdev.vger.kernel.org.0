Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2DEC4BECB7
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 22:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234952AbiBUVkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 16:40:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234266AbiBUVkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 16:40:13 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AC6422BC6;
        Mon, 21 Feb 2022 13:39:49 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21LKGa2L029930;
        Mon, 21 Feb 2022 21:39:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=nyPp6LcjRQdl+jD8YL3NMkoQ320FDZBF1gGagRw/u1E=;
 b=i5VuHrP1uD1UwFD8Py62DgNm6DBB2RfVgFCEV3qrA42RzkcZixROQv6mdkXaUjHZi2e7
 Uc+XC3rS135kgAB65t6tHVjqE1XgyiYiOEk7T74eox5XkMtsfFKbMit+VFm6n+w2b4Uq
 SyBj+fWuS4tUR1tqn5Y+M6dRpTIowH6sSisPKzQ9lWXCQKiOCtsLBzsKvY7Zr02Co7Io
 Os1b00whZhoz4N5ArAFT9KWzp519nYQ3VqGKs0628MkhDSONpNzVtBKz9O2JciNgIM+9
 rxlnAh9478mR0Y2KixrIQbEdvfaKrAEStEDuQsIbsakBOQKPavGP86QdMrD1wOqHaP3E EA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3echmrhfen-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Feb 2022 21:39:35 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21LLKOt8008854;
        Mon, 21 Feb 2022 21:39:35 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3echmrhfdr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Feb 2022 21:39:35 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21LLd6Se021813;
        Mon, 21 Feb 2022 21:39:32 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 3ear694ssx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Feb 2022 21:39:32 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21LLdTYK44630420
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Feb 2022 21:39:29 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2A7D552054;
        Mon, 21 Feb 2022 21:39:29 +0000 (GMT)
Received: from [9.171.78.41] (unknown [9.171.78.41])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id BA5E25204F;
        Mon, 21 Feb 2022 21:39:28 +0000 (GMT)
Message-ID: <8ff3f2ff692acaffe9494007a3431c269372f822.camel@linux.ibm.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: Fix implementation-defined
 behavior in sk_lookup test
From:   Ilya Leoshkevich <iii@linux.ibm.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        kernel-team@cloudflare.com,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 21 Feb 2022 22:39:28 +0100
In-Reply-To: <20220221180358.169101-1-jakub@cloudflare.com>
References: <20220221180358.169101-1-jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.2 (3.42.2-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 2qFLf_SzKwoVRu9IB5u527-CyEW-WMS9
X-Proofpoint-GUID: jkyR7W9S7IasmCUnBeZXUXEU8wpYP7RD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-21_10,2022-02-21_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 suspectscore=0 lowpriorityscore=0 mlxlogscore=999 spamscore=0
 malwarescore=0 mlxscore=0 phishscore=0 bulkscore=0 priorityscore=1501
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202210128
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-02-21 at 19:03 +0100, Jakub Sitnicki wrote:
> Shifting 16-bit type by 16 bits is implementation-defined for BPF
> programs.
> Don't rely on it in case it is causing the test failures we are
> seeing on
> s390x z15 target.
> 
> Fixes: 2ed0dc5937d3 ("selftests/bpf: Cover 4-byte load from
> remote_port in bpf_sk_lookup")
> Reported-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
> 
> I don't have a dev env for s390x/z15 set up yet, so can't definitely
> confirm the fix.
> That said, it seems worth fixing either way.
> 
>  tools/testing/selftests/bpf/progs/test_sk_lookup.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/bpf/progs/test_sk_lookup.c
> b/tools/testing/selftests/bpf/progs/test_sk_lookup.c
> index bf5b7caefdd0..7d47276a8964 100644
> --- a/tools/testing/selftests/bpf/progs/test_sk_lookup.c
> +++ b/tools/testing/selftests/bpf/progs/test_sk_lookup.c
> @@ -65,6 +65,7 @@ static const __u32 KEY_SERVER_A = SERVER_A;
>  static const __u32 KEY_SERVER_B = SERVER_B;
>  
>  static const __u16 SRC_PORT = bpf_htons(8008);
> +static const __u32 SRC_PORT_U32 = bpf_htonl(8008U << 16);
>  static const __u32 SRC_IP4 = IP4(127, 0, 0, 2);
>  static const __u32 SRC_IP6[] = IP6(0xfd000000, 0x0, 0x0,
> 0x00000002);
>  
> @@ -421,7 +422,7 @@ int ctx_narrow_access(struct bpf_sk_lookup *ctx)
>  
>         /* Load from remote_port field with zero padding (backward
> compatibility) */
>         val_u32 = *(__u32 *)&ctx->remote_port;
> -       if (val_u32 != bpf_htonl(bpf_ntohs(SRC_PORT) << 16))
> +       if (val_u32 != SRC_PORT_U32)
>                 return SK_DROP;
>  
>         /* Narrow loads from local_port field. Expect DST_PORT. */

Unfortunately this doesn't help with the s390 problem.
I'll try to debug this.
