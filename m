Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8421748B184
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 17:03:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349771AbiAKQDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 11:03:00 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:4044 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240042AbiAKQC7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 11:02:59 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20BEUe2m035994;
        Tue, 11 Jan 2022 16:02:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=dMRAPPyuMvF9myQdsG2sQNq5e8o8ZFFCRM9aoVDt6Ew=;
 b=L4q3jur4wwQMEYRepCd2MrQwBoYDzJFm2hZEgeVs7+6wSM+4aSzSdYWZIJQgvMe2Vl6v
 KSbEQNx1AN8Kyy61kBTEjafX3kLiLijQgCAn0wChBlZ6a5oS6QdrrgIlAdYX/tsCq49M
 RmdbzFNTxaBozODDww3AJolpT0Br8CPZ/ErU70C//7vsQMgxSIT6SI+oFLI+FVBtn0xB
 vTRrHq/nxYtws5dBT+BmYkQddN0ghm4NfeEJpi96zL5qCthkA6rYro3TXsvd2XA9z3ds
 eU6rcZM7Wz+7+8j5xXKBm7Lrs8wOQh5GB+rMerLXYFg6Yx0ONrI+BVFXakiGtfUCSsI7 uA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dfmjf1j4c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 16:02:56 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20BFmAZB009888;
        Tue, 11 Jan 2022 16:02:55 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dfmjf1j3j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 16:02:55 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20BFmAAm029495;
        Tue, 11 Jan 2022 16:02:53 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma02fra.de.ibm.com with ESMTP id 3df289yngt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 16:02:53 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20BG2pFw39715102
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jan 2022 16:02:51 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1FF954C05E;
        Tue, 11 Jan 2022 16:02:51 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C650D4C052;
        Tue, 11 Jan 2022 16:02:50 +0000 (GMT)
Received: from [9.145.30.70] (unknown [9.145.30.70])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 11 Jan 2022 16:02:50 +0000 (GMT)
Message-ID: <b1882268-d8bb-eee9-8238-e30962928034@linux.ibm.com>
Date:   Tue, 11 Jan 2022 17:02:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH net 3/3] net/smc: Resolve the race between SMC-R link
 access and clear
Content-Language: en-US
To:     Wen Gu <guwen@linux.alibaba.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1641806784-93141-1-git-send-email-guwen@linux.alibaba.com>
 <1641806784-93141-4-git-send-email-guwen@linux.alibaba.com>
 <8f13aa62-6360-8038-3041-86fd51b40a3e@linux.ibm.com>
 <fa057e34-7626-2b19-2c2e-acd4999e7fe5@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <fa057e34-7626-2b19-2c2e-acd4999e7fe5@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: CJDdKF2Pw4wYIPPP1_oN8N7Alr7CQzli
X-Proofpoint-ORIG-GUID: emefwc9y2-8gEEFrZAKVMPb_lGlEVoLj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-11_04,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 spamscore=0 bulkscore=0 suspectscore=0 phishscore=0
 impostorscore=0 mlxscore=0 priorityscore=1501 clxscore=1015
 mlxlogscore=999 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2201110091
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/01/2022 16:49, Wen Gu wrote:
> Thanks for your review.
> 
> On 2022/1/11 4:40 pm, Karsten Graul wrote:
>> On 10/01/2022 10:26, Wen Gu wrote:
>>> @@ -1226,15 +1245,23 @@ void smcr_link_clear(struct smc_link *lnk, bool log)
>>>       smc_wr_free_link(lnk);
>>>       smc_ib_destroy_queue_pair(lnk);
>>>       smc_ib_dealloc_protection_domain(lnk);
>>> -    smc_wr_free_link_mem(lnk);
>>> -    smc_lgr_put(lnk->lgr); /* lgr_hold in smcr_link_init() */
>>>       smc_ibdev_cnt_dec(lnk);
>>>       put_device(&lnk->smcibdev->ibdev->dev);
>>>       smcibdev = lnk->smcibdev;
>>> -    memset(lnk, 0, sizeof(struct smc_link));
>>> -    lnk->state = SMC_LNK_UNUSED;
>>>       if (!atomic_dec_return(&smcibdev->lnk_cnt))
>>>           wake_up(&smcibdev->lnks_deleted);
>>
>> Same here, waiter should not be woken up until the link memory is actually freed.
>>
> 
> OK, I will correct this as well.
> 
> And similarly I want to move smc_ibdev_cnt_dec() and put_device() to
> __smcr_link_clear() as well to ensure that put link related resources
> only when link is actually cleared. What do you think?

I think that's a good idea, yes.
