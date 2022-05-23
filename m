Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF585313D6
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 18:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237278AbiEWOpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 10:45:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237143AbiEWOpO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 10:45:14 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1704E2981A;
        Mon, 23 May 2022 07:45:12 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24NEh7Zu007499;
        Mon, 23 May 2022 14:45:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=6cGHlwlrnJy/ZsxuQfgFcfPK1pFXQCxiI7jNqHSM/2o=;
 b=p6ubl54P8qTCYr39of8lRGkgqnt/vOwtr524RUaCvRubz4/m4vtONmTiI1BSqahxqyqk
 MDIbxnkcK+17cTgSNcWAuj0ifjCXhBsn8cjZDFEYAXs5JrDCggOo5cFu5qLtmuO/PpCD
 hCejjWqBjbinfn7hOLuEqdb+hX3I19CdUva+ETsHAuLaSoOQdZVuWFmKBQAFc9nHJOw1
 7izectOvyxL9dgNtPQ+QAajWdggTJtX5yCuNipmD7W5I70xSEEadUexesTt3Y88R7fIg
 IM57Hr5+OstJo3tUgUS3wfLNn7xcW6y94yWGHrbU8DG0NyiwPLxbLw2fYUpV4S2sGRPb Xg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g8c9cg113-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 May 2022 14:45:03 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24NEiGTo011957;
        Mon, 23 May 2022 14:45:02 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g8c9cg0yw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 May 2022 14:45:02 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24NEd64i004356;
        Mon, 23 May 2022 14:45:00 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 3g6qq8ub1k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 May 2022 14:45:00 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24NEiwNd38470142
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 May 2022 14:44:58 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 185FFA4060;
        Mon, 23 May 2022 14:44:58 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C1CB4A405C;
        Mon, 23 May 2022 14:44:57 +0000 (GMT)
Received: from [9.152.222.246] (unknown [9.152.222.246])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 23 May 2022 14:44:57 +0000 (GMT)
Message-ID: <e0b64b80-90e1-5aed-1ca4-f6d20ebac6b7@linux.ibm.com>
Date:   Mon, 23 May 2022 16:44:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v2 net] net/smc: postpone sk_refcnt increment in connect()
Content-Language: en-US
To:     liuyacan@corp.netease.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, ubraun@linux.ibm.com
References: <5ce801b7-d446-ee28-86ec-968b7c172a80@linux.ibm.com>
 <20220523141905.2791310-1-liuyacan@corp.netease.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20220523141905.2791310-1-liuyacan@corp.netease.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jmcfSzowpcL_SaOEd9NjJpJxo70dlrIL
X-Proofpoint-ORIG-GUID: qpf_3J9lSgJDrxhBB6hmz2bMj0ObisEk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-23_06,2022-05-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 malwarescore=0 adultscore=0 phishscore=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=651 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205230081
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/05/2022 16:19, liuyacan@corp.netease.com wrote:
>> This is a rather unusual problem that can come up when fallback=true BEFORE smc_connect()
>> is called. But nevertheless, it is a problem.
>>
>> Right now I am not sure if it is okay when we NOT hold a ref to smc->sk during all fallback
>> processing. This change also conflicts with a patch that is already on net-next (3aba1030).
> 
> Do you mean put the ref to smc->sk during all fallback processing unconditionally and remove 
> the fallback branch sock_put() in __smc_release()?

What I had in mind was to eventually call sock_put() in __smc_release() even if sk->sk_state == SMC_INIT
(currently the extra check in the if() for sk->sk_state != SMC_INIT prevents the sock_put()), but only
when it is sure that we actually reached the sock_hold() in smc_connect() before.

But maybe we find out that the sock_hold() is not needed for fallback sockets, I don't know...
