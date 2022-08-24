Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE6659F0A8
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 03:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231663AbiHXBMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 21:12:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231290AbiHXBMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 21:12:50 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABFF5F40;
        Tue, 23 Aug 2022 18:12:49 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27O0K7WQ024747;
        Wed, 24 Aug 2022 01:12:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=FVzB15w+1+q49riujvE4LmJ+MvfUyyDCHv446FZJJbk=;
 b=EDNlCrXN+gNwB86VSfGpgd2d+fjMVHHDDDJeBIh3VO7E+8Va02O+lFCDY8GYdW8pw0NM
 s8tmyti0BaReNRXEpx9sTy6aaJAT49ZZebZOVRIM/AXDv28FBAcyf+tc/9uE9VZKGRps
 FpVQfFgnS2MkxQV2idAA8RHAKrAqLuFCdSltjyRHvZfFntmuOMF3oQ4+LVgTe5Wqbmf8
 ID1l7O7N6yIB3pFJ3MRAM6MueDRPFb+IqfRMDwtcheqlO4K63xxtiXpxI+eG55/1EGSk
 fXHEeYOCW4nweJt4+arViINHxoWV+S5ptDKTBVVAvcav53iIYybS0lsWKCKCctPXwIXM BA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j59bj95nh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Aug 2022 01:12:34 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27O0lBLW004509;
        Wed, 24 Aug 2022 01:12:33 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j59bj95mm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Aug 2022 01:12:33 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27O151MX015000;
        Wed, 24 Aug 2022 01:12:31 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma01fra.de.ibm.com with ESMTP id 3j2q88u905-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Aug 2022 01:12:31 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27O1CSpC34013648
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Aug 2022 01:12:28 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BF4F05204F;
        Wed, 24 Aug 2022 01:12:28 +0000 (GMT)
Received: from [9.197.243.37] (unknown [9.197.243.37])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id A5D795204E;
        Wed, 24 Aug 2022 01:12:26 +0000 (GMT)
Message-ID: <7dbb9eb9-11f4-8b1a-5b57-378efe45b147@linux.vnet.ibm.com>
Date:   Wed, 24 Aug 2022 09:10:21 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.1.1
Subject: Re: [PATCH v1 bpf 0/4] bpf: sysctl: Fix data-races around
 net.core.bpf_XXX.
Content-Language: en-US
To:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Kuniyuki Iwashima <kuni1840@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
References: <20220818042339.82992-1-kuniyu@amazon.com>
From:   dongdwdw <dongdwdw@linux.vnet.ibm.com>
In-Reply-To: <20220818042339.82992-1-kuniyu@amazon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: DaszgB007aQIdP0Dqhz8oGIfssf0Ffyg
X-Proofpoint-ORIG-GUID: qoZtiS04TrNsqKbMcLCo5JhDpu5vVe1l
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-23_10,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 suspectscore=0
 bulkscore=0 mlxlogscore=999 clxscore=1011 adultscore=0 priorityscore=1501
 malwarescore=0 spamscore=0 mlxscore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208240001
X-Spam-Status: No, score=-0.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HK_RANDOM_ENVFROM,HK_RANDOM_FROM,NICE_REPLY_A,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set got my attention because I found some issue about 
bpf_jit_harden.
But after reading your patches, I did not get what the problem you are 
trying resolve and what is improved.
You said there is a data race, what is that? Can you please show how 
does this happen? What is the influence?
Would you please let me know these background info?

On 2022/8/18 12:23, Kuniyuki Iwashima wrote:
> This series split from [0] fixes data-races around 4 bpf knobs
> in net_core_table.
>
> [0]: https://lore.kernel.org/netdev/20220818035227.81567-1-kuniyu@amazon.com/
>
>
> Kuniyuki Iwashima (4):
>    bpf: Fix data-races around bpf_jit_enable.
>    bpf: Fix data-races around bpf_jit_harden.
>    bpf: Fix data-races around bpf_jit_kallsyms.
>    bpf: Fix a data-race around bpf_jit_limit.
>
>   arch/arm/net/bpf_jit_32.c        |  2 +-
>   arch/arm64/net/bpf_jit_comp.c    |  2 +-
>   arch/mips/net/bpf_jit_comp.c     |  2 +-
>   arch/powerpc/net/bpf_jit_comp.c  |  5 +++--
>   arch/riscv/net/bpf_jit_core.c    |  2 +-
>   arch/s390/net/bpf_jit_comp.c     |  2 +-
>   arch/sparc/net/bpf_jit_comp_32.c |  5 +++--
>   arch/sparc/net/bpf_jit_comp_64.c |  5 +++--
>   arch/x86/net/bpf_jit_comp.c      |  2 +-
>   arch/x86/net/bpf_jit_comp32.c    |  2 +-
>   include/linux/filter.h           | 16 ++++++++++------
>   kernel/bpf/core.c                |  2 +-
>   net/core/sysctl_net_core.c       |  4 ++--
>   13 files changed, 29 insertions(+), 22 deletions(-)
>
