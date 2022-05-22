Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3A0530680
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 00:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350666AbiEVWWm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 May 2022 18:22:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230175AbiEVWWi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 May 2022 18:22:38 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27ACC240B3;
        Sun, 22 May 2022 15:22:38 -0700 (PDT)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24MFaj3F025929;
        Sun, 22 May 2022 22:22:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=5CkdRqjRscNq/Ois0QptfV9yb1J2HpaTPOg5VbcQ8DM=;
 b=ShFAZ760kNLQYQxjy+FL61em62g/2n0j5me7facf9m9W/gxImVhntSrsQzpfVvo9tJi4
 ff4TtoU6GCnXzPtEi0T20VCw47GgpEEZlvFKiMEBeJEbMdZhkp/C8G0YV94p3rkHYPBB
 P+Sio2DbjRPy4PQVxaI9lpHSd1gaRQ7qgwaHE7ipG6WCk08aUIMM8gXCkns3g+gbcftd
 /zOyCLZA9gZ4a3FWJ9jzAb+6y8oVUZ0KJMFqcAcxEyhvilEceewfCBtUKUfCrAuTSs0l
 UGqLfcpCOeu+ckjL0uhB0nVLkrylE+2F3URtHah0Xtz1/mK8uiXgR8G6J4E1sDOuh86V ag== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g79f4y0m6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 22 May 2022 22:22:21 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24MMKcRX020257;
        Sun, 22 May 2022 22:22:20 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g79f4y0ke-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 22 May 2022 22:22:20 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24MMCtgG010241;
        Sun, 22 May 2022 22:22:18 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma01fra.de.ibm.com with ESMTP id 3g6qq8t2pv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 22 May 2022 22:22:17 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24MMMEQE24052000
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 22 May 2022 22:22:14 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E876AE045;
        Sun, 22 May 2022 22:22:14 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 898D6AE051;
        Sun, 22 May 2022 22:22:13 +0000 (GMT)
Received: from [9.171.72.230] (unknown [9.171.72.230])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sun, 22 May 2022 22:22:13 +0000 (GMT)
Message-ID: <63d07a63565b0f059f5b04dbe294dc4f8d4c91fb.camel@linux.ibm.com>
Subject: Re: [PATCH] s390/bpf: fix typo in comment
From:   Ilya Leoshkevich <iii@linux.ibm.com>
To:     Julia Lawall <Julia.Lawall@inria.fr>
Cc:     kernel-janitors@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 23 May 2022 00:22:13 +0200
In-Reply-To: <20220521111145.81697-84-Julia.Lawall@inria.fr>
References: <20220521111145.81697-84-Julia.Lawall@inria.fr>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 2B8uQRJxfEHvQ1900hIT0sofz4GMyRxR
X-Proofpoint-ORIG-GUID: -ZVWZf9s398XuI8rUJoJfa6A7Zahz82o
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-22_12,2022-05-20_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 impostorscore=0 mlxscore=0 suspectscore=0 clxscore=1011 phishscore=0
 mlxlogscore=999 adultscore=0 priorityscore=1501 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205220140
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2022-05-21 at 13:11 +0200, Julia Lawall wrote:
> Spelling mistake (triple letters) in comment.
> Detected with the help of Coccinelle.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>
> 
> ---
>  arch/s390/net/bpf_jit_comp.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/s390/net/bpf_jit_comp.c
> b/arch/s390/net/bpf_jit_comp.c
> index aede9a3ca3f7..af35052d06ed 100644
> --- a/arch/s390/net/bpf_jit_comp.c
> +++ b/arch/s390/net/bpf_jit_comp.c
> @@ -1809,7 +1809,7 @@ struct bpf_prog *bpf_int_jit_compile(struct
> bpf_prog *fp)
>         /*
>          * Three initial passes:
>          *   - 1/2: Determine clobbered registers
> -        *   - 3:   Calculate program size and addrs arrray
> +        *   - 3:   Calculate program size and addrs array
>          */
>         for (pass = 1; pass <= 3; pass++) {
>                 if (bpf_jit_prog(&jit, fp, extra_pass, stack_depth))
> {
> 

Thanks!

Acked-by: Ilya Leoshkevich <iii@linux.ibm.com>
