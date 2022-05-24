Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC3315329F8
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 14:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237145AbiEXMFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 08:05:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234556AbiEXMFj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 08:05:39 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAE0763BE6;
        Tue, 24 May 2022 05:05:38 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24OAsBtp019002;
        Tue, 24 May 2022 12:05:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=00VjxMXrB6NmRYmO+zKL1gLxXBQoo3e5Z8Ngmf4XXgw=;
 b=I2V+agUu0USmq+xoQF06ma6Nce34cA7ivbzereyIXFVUCAZD1Y4yk49ZEoE9/ulGiOPf
 zAW+hpo4ugc2Wr5/9dnMSTfFJP8wRKZXPY8YurX9XJb0VrbVTZj/P5UM/go/Odwux3Xb
 At7et/4MN3jw/pZjFnX++2raK4+AW/TyyfDovXstNpwk8fjCh+6hzEDQBLcsTb8pIyAs
 0oaBX4OhSAHz71rYWztjiEWzCpOYv4QUjcBZwahtWfBhSWEzPzfXrAaobsOYVXyLDHBY
 UPfrO6eBlUAt9YYRY/BvamlfwZCTajAfdYJTVNkV4tth2HoxVC4QR81uxKjlCgzmoz8w zQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g8x0x1aa1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 12:05:32 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24OBo6Hp011702;
        Tue, 24 May 2022 12:05:32 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g8x0x1a99-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 12:05:31 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24OC30Fv009546;
        Tue, 24 May 2022 12:05:29 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma02fra.de.ibm.com with ESMTP id 3g6qq94tkx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 12:05:29 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24OC4cYn25493960
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 12:04:38 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E46D942047;
        Tue, 24 May 2022 12:05:26 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 60E344203F;
        Tue, 24 May 2022 12:05:26 +0000 (GMT)
Received: from [9.171.67.153] (unknown [9.171.67.153])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 24 May 2022 12:05:26 +0000 (GMT)
Message-ID: <6b79fd16-79dd-450f-7eb7-ba5d6be2be0c@linux.ibm.com>
Date:   Tue, 24 May 2022 14:05:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v2 net] net/smc: postpone sk_refcnt increment in connect()
Content-Language: en-US
To:     liuyacan@corp.netease.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, ubraun@linux.ibm.com
References: <e0b64b80-90e1-5aed-1ca4-f6d20ebac6b7@linux.ibm.com>
 <20220523152119.406443-1-liuyacan@corp.netease.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20220523152119.406443-1-liuyacan@corp.netease.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: UF2_FfbrUzZFREYNuKVv5hJFtNNhY8dm
X-Proofpoint-ORIG-GUID: blvGnHcyhkd8fbD7QfDMVb7C5JgtL9MG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-24_06,2022-05-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 bulkscore=0 adultscore=0 mlxlogscore=845 priorityscore=1501 clxscore=1015
 malwarescore=0 phishscore=0 lowpriorityscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205240063
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/05/2022 17:21, liuyacan@corp.netease.com wrote:
>>>> This is a rather unusual problem that can come up when fallback=true BEFORE smc_connect()
>>>> is called. But nevertheless, it is a problem.
>>>>
>>>> Right now I am not sure if it is okay when we NOT hold a ref to smc->sk during all fallback
>>>> processing. This change also conflicts with a patch that is already on net-next (3aba1030).
>>>
>>> Do you mean put the ref to smc->sk during all fallback processing unconditionally and remove 
>>> the fallback branch sock_put() in __smc_release()?
>>
>> What I had in mind was to eventually call sock_put() in __smc_release() even if sk->sk_state == SMC_INIT
>> (currently the extra check in the if() for sk->sk_state != SMC_INIT prevents the sock_put()), but only
>> when it is sure that we actually reached the sock_hold() in smc_connect() before.
>>
>> But maybe we find out that the sock_hold() is not needed for fallback sockets, I don't know...
> 
> I do think the sock_hold()/sock_put() for smc->sk is a bit complicated, Emm, I'm not sure if it 
> can be simplified..
> 
> In fact, I'm sure there must be another ref count issue in my environment,but I haven't caught it yet.
> 

Can you check my latest mail from a minute ago in thread
"Re: [PATCH net-next v2] net/smc: align the connect behaviour with TCP"
I think this answer also affects our discussion.
