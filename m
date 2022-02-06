Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7D534AB01F
	for <lists+netdev@lfdr.de>; Sun,  6 Feb 2022 16:10:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243352AbiBFPKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Feb 2022 10:10:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231978AbiBFPKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Feb 2022 10:10:05 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DFB8C06173B;
        Sun,  6 Feb 2022 07:10:04 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id h125so9432966pgc.3;
        Sun, 06 Feb 2022 07:10:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=qWFxv+3YuH1CWb5vd6X38rdei5El1reePWd3jR1jQbw=;
        b=LPW4LmWOiHjC4HvsGCbBU/cSBUb0Izy2F+fq6QBbB5/F4mVWFqug7mdcHEwb7H5QjO
         nqqbC1SaxBz2dAawd9A+MC4i9oIJgfR6bSff+9P7xCmzv9eA5nlykcngmUyG5DeYKQEl
         zLkhvs3Np1KLPMK+pdBvIqiHoISxv2W/3Qsq5K+AHcYFeCqunVB+UrFfMmiGm8JCYTnn
         hJCrhfvRW319e+OLSUAXFEYtX+O5nuW2ky4ZH7ngvd5HC0ZQnxuwC4ejw+jkgIUcvCLg
         Yndg6vZKbiuRhX562HwnebHyWjDunRw9mxxBJ7CBCEUh83ISiNoaaq320KTHx+U1IllJ
         NXrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=qWFxv+3YuH1CWb5vd6X38rdei5El1reePWd3jR1jQbw=;
        b=V8+mg2xG5yhMw+0aN4vYRb2fdXxe53nAuvkJrXLBbqhUSyTDrt06aZsU46xZ15GZg7
         gFC2ajm1+ba4CnZQ5xi23+/i3kU45gA9pY7ojRzBo2NCd6xy0d5Cyc8La+x1IrD9siCZ
         Dc9/qZrMNl9DLladbvRHb8mqSZU29hDBxGpf8viOLNdEt13eiELacnnwUANvZegby5zV
         4FNiJNdIIVcE+xLGj8LCG+/OqaYxwuts0fRIWgPGuV4grHvsFZv1oCSJHNMyomhWwnAT
         n8Tqv5BGPeR915UfyLIKv6BkLsxXiZGwLopTSjzGL7aZ1F8pYt6ig1QP8n0HhfNtW+/4
         j3Xg==
X-Gm-Message-State: AOAM533FlqFkUcCrGg9SXa3jlVG6IDUd5sMyq/IJSVj/5btGM5xVc1el
        qQzLRoVao8M8Y1sAWymLnWBgsYJ1Wds6tQ==
X-Google-Smtp-Source: ABdhPJyFRdlxco6/qRn1P0tSn2Yq81j7gBWi9V3lfR7+LvGz5ccN+R+laIC6TD/csX4Q/10audcEUw==
X-Received: by 2002:a63:f650:: with SMTP id u16mr6116231pgj.2.1644160203506;
        Sun, 06 Feb 2022 07:10:03 -0800 (PST)
Received: from [10.59.0.6] ([85.203.23.80])
        by smtp.gmail.com with ESMTPSA id u13sm9609801pfg.151.2022.02.06.07.09.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Feb 2022 07:10:02 -0800 (PST)
Message-ID: <9a27b497-80d7-ec6f-c8f1-69bee340f2e1@gmail.com>
Date:   Sun, 6 Feb 2022 23:09:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [BUG] net: smc: possible deadlock in smc_lgr_free() and
 smc_link_down_work()
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org
References: <11fe65b8-eda4-121e-ec32-378b918d0909@gmail.com>
 <0936d5f3-aef2-0553-408b-07b3bb47e36b@linux.ibm.com>
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
In-Reply-To: <0936d5f3-aef2-0553-408b-07b3bb47e36b@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/2/2 1:06, Karsten Graul wrote:
> On 01/02/2022 08:51, Jia-Ju Bai wrote:
>> Hello,
>>
>> My static analysis tool reports a possible deadlock in the smc module in Linux 5.16:
>>
>> smc_lgr_free()
>>    mutex_lock(&lgr->llc_conf_mutex); --> Line 1289 (Lock A)
>>    smcr_link_clear()
>>      smc_wr_free_link()
>>        wait_event(lnk->wr_tx_wait, ...); --> Line 648 (Wait X)
>>
>> smc_link_down_work()
>>    mutex_lock(&lgr->llc_conf_mutex); --> Line 1683 (Lock A)
>>    smcr_link_down()
>>      smcr_link_clear()
>>        smc_wr_free_link()
>>          smc_wr_wakeup_tx_wait()
>>            wake_up_all(&lnk->wr_tx_wait); --> Line 78 (Wake X)
>>
>> When smc_lgr_free() is executed, "Wait X" is performed by holding "Lock A". If smc_link_down_work() is executed at this time, "Wake X" cannot be performed to wake up "Wait X" in smc_lgr_free(), because "Lock A" has been already hold by smc_lgr_free(), causing a possible deadlock.
>>
>> I am not quite sure whether this possible problem is real and how to fix it if it is real.
>> Any feedback would be appreciated, thanks :)

Hi Karsten,

Thanks for the reply and explanation :)

> A deeper analysis showed up that this reported possible deadlock is actually not a problem.
>
> The wait on line 648 in smc_wr.c
> 	wait_event(lnk->wr_tx_wait, (!atomic_read(&lnk->wr_tx_refcnt)));
> waits as long as the refcount wr_tx_refcnt is not zero.
>
> Every time when a caller stops using a link wr_tx_refcnt is decreased, and when it reaches
> zero the wr_tx_wait is woken up in smc_wr_tx_link_put() in smc_wr.h, line 70:
> 		if (atomic_dec_and_test(&link->wr_tx_refcnt))
> 			wake_up_all(&link->wr_tx_wait);

Okay, you mean that wake_up_all(&link->wr_tx_wait) in 
smc_wr_tx_link_put() is used to wake up wait_event() in smc_wr_free_link().
But I wonder whether wake_up_all(&lnk->wr_tx_wait) in 
smc_wr_wakeup_tx_wait() can wake up this wait_event()?
If so, my report is in this case.

> Multiple callers of smc_wr_tx_link_put() do not run under the llc_conf_mutex lock, and those
> who run under this mutex are saved against the wait_event() in smc_wr_free_link().

In fact, my tool also reports some other possible deadlocks invovling 
smc_wr_tx_link_put(), which can be called by holding llc_conf_mutex.
There are three examples:

#BUG 1
smc_lgr_free()
   mutex_lock(&lgr->llc_conf_mutex); --> Line 1289 (Lock A)
   smcr_link_clear()
     smc_wr_free_link()
       wait_event(lnk->wr_tx_wait, ...); --> Line 648 (Wait X)

smcr_buf_unuse()
   mutex_lock(&lgr->llc_conf_mutex); --> Line 1087 (Lock A)
   smc_llc_do_delete_rkey()
     smc_llc_send_delete_rkey()
       smc_wr_tx_link_put()
         wake_up_all(&link->wr_tx_wait); --> Line 73 (Wake X)

#BUG 2
smc_lgr_free()
   mutex_lock(&lgr->llc_conf_mutex); --> Line 1289 (Lock A)
   smcr_link_clear()
     smc_wr_free_link()
       wait_event(lnk->wr_tx_wait, ...); --> Line 648 (Wait X)

smc_link_down_work()
   mutex_lock(&lgr->llc_conf_mutex); --> Line 1683 (Lock A)
   smcr_link_down()
     smc_llc_send_delete_link()
       smc_wr_tx_link_put()
         wake_up_all(&link->wr_tx_wait); --> Line 73 (Wake X)

#BUG 3
smc_llc_process_cli_delete_link()
   mutex_lock(&lgr->llc_conf_mutex); --> Line 1578 (Lock A)
   smc_llc_send_message()
     smc_llc_add_pending_send()
       smc_wr_tx_get_free_slot()
         wait_event_interruptible_timeout(link->wr_tx_wait, ...); --> 
Line 219 (Wake X)

smc_llc_process_cli_add_link()
   mutex_lock(&lgr->llc_conf_mutex); --> Line 1198 (Lock A)
   smc_llc_cli_add_link_invite()
     smc_llc_send_add_link()
       smc_wr_tx_link_put()
         wake_up_all(&link->wr_tx_wait); --> Line 73 (Wake X)

I am not quite sure whether these possible problems are real.
Any feedback would be appreciated, thanks :)

>
> Thank you for reporting this finding! Which tool did you use for this analysis?

Thanks for your interest :)
I have implemented a static analysis tool based on LLVM, to detect 
deadlocks caused by locking cycles and improper waiting/waking operations.
However, this tool still reports some false positives, and thus I am 
still improving the accuracy of this tool.
Suggestions on deadlock detection (especially new/infrequent patterns 
causing deadlocks) or the tool are welcome ;)


Best wishes,
Jia-Ju Bai

