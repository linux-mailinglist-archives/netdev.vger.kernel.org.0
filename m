Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 688EB4ADF6B
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 18:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384204AbiBHRWX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 12:22:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384195AbiBHRWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 12:22:20 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B718CC0613C9;
        Tue,  8 Feb 2022 09:22:18 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 218GqPD1022763;
        Tue, 8 Feb 2022 17:22:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=5u5/fqZd6VZeY+yASRLeyY+z+vX4LQ+GCflHnSEGOfk=;
 b=ax0UynyOJyphOHV31hieVXDhowTvUwlJIYFW0Xr9QLqYo4n8rQxIU4ghw3dS+h6zpc57
 7Kyeivk8rvrsCcTd0sAHDWKaqcOQGHJrdiACBh5HwFL3AlSDWAsYWRt38xZKCf7Q8BBI
 6Ajcd82FB1QU8anXTMaH4X81jAgCHIyj6Zhy39Qe6S2XvQsBEzQvB8in9cnYX0VOimqa
 tddcV6OvPQmqOHASUz2zcZBwGyGatX0vhK5GeSh8iI8sCXOQXysrjyKnfjyiWbFLOrmz
 dq3a4yhcj4t2ZdYEwrNCi8zHTCxiQLz2GEYETcnzUrDfN7wL+5Zm+cdboR6jI2g1QrQW Sw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e231a6nes-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 17:22:14 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 218Gtqtr004314;
        Tue, 8 Feb 2022 17:22:14 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e231a6ndx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 17:22:14 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 218HIpqY024921;
        Tue, 8 Feb 2022 17:22:12 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 3e2ygq5tur-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 17:22:12 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 218HMAW243778550
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Feb 2022 17:22:10 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0DB5FA4053;
        Tue,  8 Feb 2022 17:22:10 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A5EF1A4051;
        Tue,  8 Feb 2022 17:22:09 +0000 (GMT)
Received: from [9.145.157.102] (unknown [9.145.157.102])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  8 Feb 2022 17:22:09 +0000 (GMT)
Message-ID: <ab98ad0a-4c37-0ab7-02e2-a9bb439646f3@linux.ibm.com>
Date:   Tue, 8 Feb 2022 18:22:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [BUG] net: smc: possible deadlock in smc_lgr_free() and
 smc_link_down_work()
Content-Language: en-US
To:     Jia-Ju Bai <baijiaju1990@gmail.com>
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org
References: <11fe65b8-eda4-121e-ec32-378b918d0909@gmail.com>
 <0936d5f3-aef2-0553-408b-07b3bb47e36b@linux.ibm.com>
 <9a27b497-80d7-ec6f-c8f1-69bee340f2e1@gmail.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <9a27b497-80d7-ec6f-c8f1-69bee340f2e1@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: XlLh24rejcyL6ndLdX-53BXHdS8CP7kw
X-Proofpoint-GUID: 8DrBZJo71Y4TSMRvil0BF1oLr35lD110
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-08_06,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 malwarescore=0 impostorscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 bulkscore=0 mlxscore=0
 phishscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202080103
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/02/2022 16:09, Jia-Ju Bai wrote:
> 
> 
> On 2022/2/2 1:06, Karsten Graul wrote:
>> On 01/02/2022 08:51, Jia-Ju Bai wrote:
>>> Hello,
>>>
>>> My static analysis tool reports a possible deadlock in the smc module in Linux 5.16:
>>>
>>> smc_lgr_free()
>>>    mutex_lock(&lgr->llc_conf_mutex); --> Line 1289 (Lock A)
>>>    smcr_link_clear()
>>>      smc_wr_free_link()
>>>        wait_event(lnk->wr_tx_wait, ...); --> Line 648 (Wait X)
>>>
>>> smc_link_down_work()
>>>    mutex_lock(&lgr->llc_conf_mutex); --> Line 1683 (Lock A)
>>>    smcr_link_down()
>>>      smcr_link_clear()
>>>        smc_wr_free_link()
>>>          smc_wr_wakeup_tx_wait()
>>>            wake_up_all(&lnk->wr_tx_wait); --> Line 78 (Wake X)
>>>
>>> When smc_lgr_free() is executed, "Wait X" is performed by holding "Lock A". If smc_link_down_work() is executed at this time, "Wake X" cannot be performed to wake up "Wait X" in smc_lgr_free(), because "Lock A" has been already hold by smc_lgr_free(), causing a possible deadlock.
>>>
>>> I am not quite sure whether this possible problem is real and how to fix it if it is real.
>>> Any feedback would be appreciated, thanks :)
> 
> Hi Karsten,
> 
> Thanks for the reply and explanation :)
> 
>> A deeper analysis showed up that this reported possible deadlock is actually not a problem.
>>
>> The wait on line 648 in smc_wr.c
>>     wait_event(lnk->wr_tx_wait, (!atomic_read(&lnk->wr_tx_refcnt)));
>> waits as long as the refcount wr_tx_refcnt is not zero.
>>
>> Every time when a caller stops using a link wr_tx_refcnt is decreased, and when it reaches
>> zero the wr_tx_wait is woken up in smc_wr_tx_link_put() in smc_wr.h, line 70:
>>         if (atomic_dec_and_test(&link->wr_tx_refcnt))
>>             wake_up_all(&link->wr_tx_wait);
> 
> Okay, you mean that wake_up_all(&link->wr_tx_wait) in smc_wr_tx_link_put() is used to wake up wait_event() in smc_wr_free_link().
> But I wonder whether wake_up_all(&lnk->wr_tx_wait) in smc_wr_wakeup_tx_wait() can wake up this wait_event()?
> If so, my report is in this case.
> 

Nope, due to the link state handling there is no current caller of smc_wr_wakeup_tx_wait() when 
smc_wr_free_link() starts to wait for the link to become free. First the link state is set to DOWN, 
then all waiters are woken up (and no one will start a new wait) and finally smc_wr_free_link()
"re-uses" the wait queue entry to wait for the link to become free.

I think its that reusing of the wait queue entry that confuses the tool.

>> Multiple callers of smc_wr_tx_link_put() do not run under the llc_conf_mutex lock, and those
>> who run under this mutex are saved against the wait_event() in smc_wr_free_link().
> 
> In fact, my tool also reports some other possible deadlocks invovling smc_wr_tx_link_put(), which can be called by holding llc_conf_mutex.
> There are three examples:
> 
> #BUG 1
> smc_lgr_free()
>   mutex_lock(&lgr->llc_conf_mutex); --> Line 1289 (Lock A)
>   smcr_link_clear()
>     smc_wr_free_link()
>       wait_event(lnk->wr_tx_wait, ...); --> Line 648 (Wait X)
> 
> smcr_buf_unuse()
>   mutex_lock(&lgr->llc_conf_mutex); --> Line 1087 (Lock A)
>   smc_llc_do_delete_rkey()
>     smc_llc_send_delete_rkey()
>       smc_wr_tx_link_put()
>         wake_up_all(&link->wr_tx_wait); --> Line 73 (Wake X)
> 
> #BUG 2
> smc_lgr_free()
>   mutex_lock(&lgr->llc_conf_mutex); --> Line 1289 (Lock A)
>   smcr_link_clear()
>     smc_wr_free_link()
>       wait_event(lnk->wr_tx_wait, ...); --> Line 648 (Wait X)
> 
> smc_link_down_work()
>   mutex_lock(&lgr->llc_conf_mutex); --> Line 1683 (Lock A)
>   smcr_link_down()
>     smc_llc_send_delete_link()
>       smc_wr_tx_link_put()
>         wake_up_all(&link->wr_tx_wait); --> Line 73 (Wake X)
> 
> #BUG 3
> smc_llc_process_cli_delete_link()
>   mutex_lock(&lgr->llc_conf_mutex); --> Line 1578 (Lock A)
>   smc_llc_send_message()
>     smc_llc_add_pending_send()
>       smc_wr_tx_get_free_slot()
>         wait_event_interruptible_timeout(link->wr_tx_wait, ...); --> Line 219 (Wake X)
> 
> smc_llc_process_cli_add_link()
>   mutex_lock(&lgr->llc_conf_mutex); --> Line 1198 (Lock A)
>   smc_llc_cli_add_link_invite()
>     smc_llc_send_add_link()
>       smc_wr_tx_link_put()
>         wake_up_all(&link->wr_tx_wait); --> Line 73 (Wake X)
> 
> I am not quite sure whether these possible problems are real.
> Any feedback would be appreciated, thanks :)

Same here, because the wait queue entry is used in two scenarios and some processing separates
those scenarios, the code checker finds problems that 'should' never happen.

I wonder if it would be acceptable to introduce an extra wait queue entry only for the processing in
smc_wr_free_link(), I reused an existing one to save some memory... but a cleaner code also counts.
Not sure what to prefer.

> 
>>
>> Thank you for reporting this finding! Which tool did you use for this analysis?
> 
> Thanks for your interest :)
> I have implemented a static analysis tool based on LLVM, to detect deadlocks caused by locking cycles and improper waiting/waking operations.
> However, this tool still reports some false positives, and thus I am still improving the accuracy of this tool.
> Suggestions on deadlock detection (especially new/infrequent patterns causing deadlocks) or the tool are welcome ;)
> 
> 
> Best wishes,
> Jia-Ju Bai
> 

-- 
Karsten
