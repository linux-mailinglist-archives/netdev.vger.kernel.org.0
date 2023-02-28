Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0826A54F3
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 09:58:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbjB1I6o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 03:58:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbjB1I6m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 03:58:42 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7233093F2;
        Tue, 28 Feb 2023 00:58:41 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31S8LoQL003639;
        Tue, 28 Feb 2023 08:58:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=t2P4EUxi876yuUZ8prqHnCoRIWZA9XloTg454sy35eE=;
 b=WwOCZd2TxrC/f4uQRlQ466DYxMPwhEiIPiEZ1BIGRGnkWVYw2vpO/ijbWNS0UPuucxON
 t5ynrMdpVhaXk64PIgLJ4VmpWB35OgnpRx9mCokrfvBd+n4kQT97M+B+nfhn2bJabYVB
 /ZvIrgXWHgH7EnHfPs4DH3eDUg0zob/fslHLQHy/UnbHhb+40Lki7Q4WhCaQm03j+deA
 IZDInNITRKZgIjWJPAXaTop78wleApQD4uPxbLkz6jn3g871fiyrpmNXRaoHeGCDb9x+
 GfE/LVoLJ15IjIVZXHIfI6YfateS3U0TKsTRS9KD0EFhIdiVeOESAMqKYcpZahDeGwlQ Rg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p1e1n8wyb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Feb 2023 08:58:20 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31S8NJ3w012921;
        Tue, 28 Feb 2023 08:58:19 GMT
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p1e1n8wxk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Feb 2023 08:58:19 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31S88K1T005832;
        Tue, 28 Feb 2023 08:58:18 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([9.208.130.97])
        by ppma01wdc.us.ibm.com (PPS) with ESMTPS id 3nybcg01u6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Feb 2023 08:58:18 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
        by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31S8wHQT44499506
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Feb 2023 08:58:17 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E1D3F58043;
        Tue, 28 Feb 2023 08:58:16 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C34B958059;
        Tue, 28 Feb 2023 08:58:14 +0000 (GMT)
Received: from [9.211.152.15] (unknown [9.211.152.15])
        by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 28 Feb 2023 08:58:14 +0000 (GMT)
Message-ID: <fafc5ef1-724f-1831-2d99-ef80a5540faf@linux.ibm.com>
Date:   Tue, 28 Feb 2023 09:58:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [PATCH bpf-next v2 1/2] net/smc: Introduce BPF injection
 capability for SMC
To:     "D. Wythe" <alibuda@linux.alibaba.com>, kgraul@linux.ibm.com,
        jaka@linux.ibm.com, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        bpf@vger.kernel.org
References: <1676981919-64884-1-git-send-email-alibuda@linux.alibaba.com>
 <1676981919-64884-2-git-send-email-alibuda@linux.alibaba.com>
 <2972ad09-291b-0c34-fa35-b7852038b32f@linux.ibm.com>
 <5cef1246-5a84-b6e9-86aa-86a1cb6bd217@linux.alibaba.com>
From:   Wenjia Zhang <wenjia@linux.ibm.com>
In-Reply-To: <5cef1246-5a84-b6e9-86aa-86a1cb6bd217@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rkPXXLgAKMTUG6H8f8FKdhpr2YH2vkUX
X-Proofpoint-ORIG-GUID: -RyTYozpRHq63kZLVlndxXaIl8FF18a1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-28_04,2023-02-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0
 clxscore=1015 suspectscore=0 priorityscore=1501 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302280068
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 28.02.23 09:50, D. Wythe wrote:
> 
> 
> On 2/27/23 3:58 PM, Wenjia Zhang wrote:
>>
>>
>> On 21.02.23 13:18, D. Wythe wrote:
>>> From: "D. Wythe" <alibuda@linux.alibaba.com>
>>>
>>> This PATCH attempts to introduce BPF injection capability for SMC.
>>> As we all know that the SMC protocol is not suitable for all scenarios,
>>> especially for short-lived. However, for most applications, they cannot
>>> guarantee that there are no such scenarios at all. Therefore, apps
>>> may need some specific strategies to decide shall we need to use SMC
>>> or not, for example, apps can limit the scope of the SMC to a specific
>>> IP address or port.
> 
> ...
> 
>>> +static int bpf_smc_passive_sk_ops_check_member(const struct btf_type 
>>> *t,
>>> +                           const struct btf_member *member,
>>> +                           const struct bpf_prog *prog)
>>> +{
>>> +    return 0;
>>> +}
>>
>> Please check the right pointer type of check_member:
>>
>> int (*check_member)(const struct btf_type *t,
>>              const struct btf_member *member);
>>
> 
> Hi Wenjia,
> 
> That's weird. the prototype of check_member on
> latested net-next and bpf-next is:
> 
> struct bpf_struct_ops {
>      const struct bpf_verifier_ops *verifier_ops;
>      int (*init)(struct btf *btf);
>      int (*check_member)(const struct btf_type *t,
>                  const struct btf_member *member,
>                  const struct bpf_prog *prog);
>      int (*init_member)(const struct btf_type *t,
>                 const struct btf_member *member,
>                 void *kdata, const void *udata);
>      int (*reg)(void *kdata);
>      void (*unreg)(void *kdata);
>      const struct btf_type *type;
>      const struct btf_type *value_type;
>      const char *name;
>      struct btf_func_model func_models[BPF_STRUCT_OPS_MAX_NR_MEMBERS];
>      u32 type_id;
>      u32 value_id;
> };
> 
> I wonder if there is any code out of sync?
> 
> And also I found that this patch is too complex and mixed with the code 
> of two modules (smc & bpf).
> I will split them out for easier review today.
> 
> Best wishes
> D. Wythe
> 

Good question, the base I used is the current torvalds tree, maybe some 
code there is still not up-to-date.

But it would be great if you can split them out for better review.

Thanks
Wenjia
