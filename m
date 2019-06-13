Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC02445D6
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 18:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404119AbfFMQrD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 12:47:03 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43292 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730270AbfFMFG2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 01:06:28 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5D53QBm061013
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 01:06:27 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2t3euy28cu-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 01:06:27 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <sandipan@linux.ibm.com>;
        Thu, 13 Jun 2019 06:06:25 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 13 Jun 2019 06:06:22 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5D56EsZ28442890
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jun 2019 05:06:14 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AEED95204F;
        Thu, 13 Jun 2019 05:06:21 +0000 (GMT)
Received: from [9.85.72.231] (unknown [9.85.72.231])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 10F5B52051;
        Thu, 13 Jun 2019 05:06:19 +0000 (GMT)
Subject: Re: [PATCH 0/2] powerpc/bpf: DIV64 instruction fix
To:     "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
References: <cover.1560364574.git.naveen.n.rao@linux.vnet.ibm.com>
From:   Sandipan Das <sandipan@linux.ibm.com>
Date:   Thu, 13 Jun 2019 10:36:17 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <cover.1560364574.git.naveen.n.rao@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19061305-0008-0000-0000-000002F3521F
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19061305-0009-0000-0000-000022605641
Message-Id: <9420d355-94d3-4ab0-78d3-01596774676d@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-13_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=669 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906130040
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 13/06/19 12:21 AM, Naveen N. Rao wrote:
> The first patch updates DIV64 overflow tests to properly detect error 
> conditions. The second patch fixes powerpc64 JIT to generate the proper 
> unsigned division instruction for BPF_ALU64.
> 
> - Naveen
> 
> Naveen N. Rao (2):
>   bpf: fix div64 overflow tests to properly detect errors
>   powerpc/bpf: use unsigned division instruction for 64-bit operations
> 
>  arch/powerpc/include/asm/ppc-opcode.h              |  1 +
>  arch/powerpc/net/bpf_jit.h                         |  2 +-
>  arch/powerpc/net/bpf_jit_comp64.c                  |  8 ++++----
>  .../testing/selftests/bpf/verifier/div_overflow.c  | 14 ++++++++++----
>  4 files changed, 16 insertions(+), 9 deletions(-)
> 

For the series

Acked-by: Sandipan Das <sandipan@linux.ibm.com>

