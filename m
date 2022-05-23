Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF93530F34
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 15:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234640AbiEWLT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 07:19:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234824AbiEWLTj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 07:19:39 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7198A4BFC1;
        Mon, 23 May 2022 04:19:17 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24NB02bL018651;
        Mon, 23 May 2022 11:19:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=txdmkUzOiYp+J1OhdbK85d8BeqClBeE6H3qwVAzteo0=;
 b=qeI9Z0EkTcUw0230/ls5KpaHmKpuU+RPbLbx7XHFyBk009pjblEzsIxbDTumER8Dk8D6
 sukM0woKjCFnswgv0Qii9hxOIWu+nThFXtIYmLkjGIr2pVdpopdpDIKzBJ9BZ7tkWGL8
 ABRphc5M78W24KEdVoUQPSDZSgtYTPW6bbWXKOKHnuzQiu5BS0Ba4Q3AOOVJ67J4EpLa
 mysJ5Nw3R/e3oQyXiS3RcJOFgVfWpcKSrglxj+c9F/Asw6xhZ8i25G49GOz1qUz4ygG6
 pxLorbuDgau678jhJXkCON4BAOKhdrxQjhFpT36bXLQIwonPOTklFzRT7wBjcvhoO7Pm 4g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g79ctbkdv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 May 2022 11:19:10 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24NBC9xP010018;
        Mon, 23 May 2022 11:19:10 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g79ctbkd8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 May 2022 11:19:10 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24NAtNtf029515;
        Mon, 23 May 2022 11:19:07 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3g6qbjaqa4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 May 2022 11:19:07 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24NBJ55X52166924
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 May 2022 11:19:05 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2B223A405B;
        Mon, 23 May 2022 11:19:05 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D4247A4054;
        Mon, 23 May 2022 11:19:04 +0000 (GMT)
Received: from [9.152.222.246] (unknown [9.152.222.246])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 23 May 2022 11:19:04 +0000 (GMT)
Message-ID: <76eeb1b0-6e4f-986b-c32f-e7e4de3426a7@linux.ibm.com>
Date:   Mon, 23 May 2022 13:19:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH net] net/smc: fix listen processing for SMC-Rv2
Content-Language: en-US
To:     liuyacan@corp.netease.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ubraun@linux.ibm.com
References: <20220523055056.2078994-1-liuyacan@corp.netease.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20220523055056.2078994-1-liuyacan@corp.netease.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Bk-q3-zXkS3wgpa7rucB5ljCpGHgiNgK
X-Proofpoint-ORIG-GUID: fNFpVf00xDpP7B0p4qsPRk-zhPW_6sSF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-23_04,2022-05-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 adultscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 mlxlogscore=931 impostorscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205230061
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/05/2022 07:50, liuyacan@corp.netease.com wrote:
> From: liuyacan <liuyacan@corp.netease.com>
> 
> In the process of checking whether RDMAv2 is available, the current
> implementation first sets ini->smcrv2.ib_dev_v2, and then allocates
> smc buf desc, but the latter may fail. Unfortunately, the caller
> will only check the former. In this case, a NULL pointer reference
> will occur in smc_clc_send_confirm_accept() when accessing
> conn->rmb_desc.
> 
> This patch does two things:
> 1. Use the return code to determine whether V2 is available.
> 2. If the return code is NODEV, continue to check whether V1 is
> available.
> 
> Fixes: e49300a6bf62 ("net/smc: add listen processing for SMC-Rv2")
> Signed-off-by: liuyacan <liuyacan@corp.netease.com>
> ---

I am not happy with this patch. You are right that this is a problem,
but the fix should be much simpler: set ini->smcrv2.ib_dev_v2 = NULL in
smc_find_rdma_v2_device_serv() after the not_found label, just like it is
done in a similar way for the ISM device in smc_find_ism_v1_device_serv().

Your patch changes many more things, and beside that you eliminated the calls 
to smc_find_ism_store_rc() completely, which is not correct.

Since your patch was already applied (btw. 3:20 hours after you submitted it),
please revert it and resend. Thank you.
