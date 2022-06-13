Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85EEE549EF2
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 22:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351145AbiFMUW1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 16:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351116AbiFMUWQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 16:22:16 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D32FD19C6;
        Mon, 13 Jun 2022 12:01:24 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25DIRDHL030274;
        Mon, 13 Jun 2022 19:00:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=5ap8HL0G9VhCgkVy6oAErMPNMFe4/WS8AvfHOq+rnaU=;
 b=mirL1/qVSrnkFlbEIbjk2d+uRprK+dJCs/OvxVZpD9GhLTN5aQtAqw0ux01Z4qV29+Ot
 4YByUXGwF5gShD5mG2Xs45gTHRyRCYqVegYqsTME76tvCOMzH2qr3WZpFHg3wdK3x9ly
 MpqZh0ASWgDz+vTBkG6Vh6nGYl0uqNra/OmQY4+kwXV0vf8kDgQKylpxfSAJvJU5ppay
 c/4P3j4xqaBfIlsRjyWuu+XJeeIebiNx+aP6FlLcDVBO42vl39eDvB3AJ6xJVqqLaUX4
 +Zc6CGthzO5LuLkZbsbo1kF3hK+UN86YDO602UKCXs5I9CzpQesRb3AsTVixqs7iRdfq TQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gpahf0jqc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Jun 2022 19:00:52 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25DInftS037745;
        Mon, 13 Jun 2022 19:00:52 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gpahf0jp9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Jun 2022 19:00:52 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25DIw56e029925;
        Mon, 13 Jun 2022 19:00:48 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma02fra.de.ibm.com with ESMTP id 3gmjp92f9c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Jun 2022 19:00:48 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25DJ0khd20906428
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Jun 2022 19:00:46 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0AF8142042;
        Mon, 13 Jun 2022 19:00:46 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5DEF94203F;
        Mon, 13 Jun 2022 19:00:39 +0000 (GMT)
Received: from [9.211.149.2] (unknown [9.211.149.2])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 13 Jun 2022 19:00:38 +0000 (GMT)
Message-ID: <6a991140-f0f8-dbfc-d596-ce1473251034@linux.ibm.com>
Date:   Tue, 14 Jun 2022 00:30:36 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v2 4/5] bpf ppc32: add support for BPF_ATOMIC bitwise
 operations
Content-Language: en-US
To:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Cc:     Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Yonghong Song <yhs@fb.com>, KP Singh <kpsingh@kernel.org>,
        Jordan Niethe <jniethe5@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>
References: <20220610155552.25892-1-hbathini@linux.ibm.com>
 <20220610155552.25892-5-hbathini@linux.ibm.com>
 <0f41cc76-a214-03c5-8764-808e5001b906@csgroup.eu>
From:   Hari Bathini <hbathini@linux.ibm.com>
In-Reply-To: <0f41cc76-a214-03c5-8764-808e5001b906@csgroup.eu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: EvrEYdyXObGWiaTpsAFZ-BVqtCq5SoR7
X-Proofpoint-ORIG-GUID: UDiTIEQnAuvdu_9pwmNEw6lQWXqXwFpr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-13_08,2022-06-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 suspectscore=0
 spamscore=0 clxscore=1015 mlxlogscore=862 phishscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206130078
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/06/22 10:44 pm, Christophe Leroy wrote:
> 
> 
> Le 10/06/2022 à 17:55, Hari Bathini a écrit :
>> Adding instructions for ppc32 for
>>
>> atomic_and
>> atomic_or
>> atomic_xor
>> atomic_fetch_add
>> atomic_fetch_and
>> atomic_fetch_or
>> atomic_fetch_xor
>>
>> Signed-off-by: Hari Bathini <hbathini@linux.ibm.com>
>> ---
>>
>> Changes in v2:
>> * Used an additional register (BPF_REG_AX)
>>       - to avoid clobbering src_reg.
>>       - to keep the lwarx reservation as intended.
>>       - to avoid the odd switch/goto construct.
> 
> Might be a stupid question as I don't know the internals of BPF: Are we
> sure BPF_REG_AX cannot be the src reg or the dst reg ?
> 

AFAICS, BPF_REG_AX wouldn't be used as src_reg or dst_reg unless this
code is reused internally, by arch-specific code, for JIT'ing some other
instruction(s) using BPF_REG_AX as either src or dst reg..

Thanks
Hari
