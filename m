Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA1A530D02
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 12:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233453AbiEWJjc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 05:39:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233443AbiEWJj2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 05:39:28 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D026A1D332;
        Mon, 23 May 2022 02:39:23 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24N8Djrk009170;
        Mon, 23 May 2022 09:39:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=pp1;
 bh=BrJWcXd4AnQ8MglkfSsy6FB0RoKeRvUFF/0x6HurJb8=;
 b=NnKIxAFlNa1KSGVIPHDp+F4mfHcyleO7jHThVplTfPTr517uJNTc100kEfqbpuPkfhkn
 K+BEzIpxP182iYAkcVrhhMlgHgvzXtmJze5wO7h4BMNGPR0IXlDvqCfouL2w9PgrEdkB
 dQT4SlTeTJzZ/t1Aes+B61EiTsLSvr9taMkKWKMosdo8ZkCrxNgTpIJi/mxA4H1OIxAo
 CMMLN8fHhx2TByLwpswfgFN98xZ5eUgTWOYPYvXsozJnWxuzVGto92kR275ir0O5ghWC
 n/KISv0hWKx+SCz6bFPBBhwgwIa2Uu7N5SQpSc3Wwi+/Wf+ynxqI2pi6etXDA4ft6v7p /w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g79vrgvgd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 May 2022 09:39:06 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24N9VmOq017090;
        Mon, 23 May 2022 09:39:06 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g79vrgvf2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 May 2022 09:39:05 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24N9bHk7017993;
        Mon, 23 May 2022 09:39:03 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3g6qq92j53-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 May 2022 09:39:02 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24N9cDuC32964962
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 May 2022 09:38:13 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A5F44A4040;
        Mon, 23 May 2022 09:38:59 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ED8B5A404D;
        Mon, 23 May 2022 09:38:58 +0000 (GMT)
Received: from osiris (unknown [9.145.75.188])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 23 May 2022 09:38:58 +0000 (GMT)
Date:   Mon, 23 May 2022 11:38:57 +0200
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Ilya Leoshkevich <iii@linux.ibm.com>
Cc:     Julia Lawall <Julia.Lawall@inria.fr>,
        kernel-janitors@vger.kernel.org, Vasily Gorbik <gor@linux.ibm.com>,
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
Subject: Re: [PATCH] s390/bpf: fix typo in comment
Message-ID: <YotWMfctHQB7bUwZ@osiris>
References: <20220521111145.81697-84-Julia.Lawall@inria.fr>
 <63d07a63565b0f059f5b04dbe294dc4f8d4c91fb.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <63d07a63565b0f059f5b04dbe294dc4f8d4c91fb.camel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: wg-0PpoGB-_-fI3urHqbj3fN6m6fnZjJ
X-Proofpoint-GUID: _JVOHFDckDX_VizYDiOfBENcsu1g21R1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-23_03,2022-05-20_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 malwarescore=0 spamscore=0 clxscore=1011 priorityscore=1501
 impostorscore=0 suspectscore=0 lowpriorityscore=0 bulkscore=0 phishscore=0
 mlxlogscore=953 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205230051
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 23, 2022 at 12:22:13AM +0200, Ilya Leoshkevich wrote:
> On Sat, 2022-05-21 at 13:11 +0200, Julia Lawall wrote:
> > Spelling mistake (triple letters) in comment.
> > Detected with the help of Coccinelle.
> > 
> > Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>
> > 
> > ---
> >  arch/s390/net/bpf_jit_comp.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
...
> 
> Thanks!
> 
> Acked-by: Ilya Leoshkevich <iii@linux.ibm.com>

Applied, thanks!
