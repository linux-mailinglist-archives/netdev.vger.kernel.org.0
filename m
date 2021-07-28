Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6A0F3D95BB
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 21:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbhG1TCr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 15:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbhG1TCq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 15:02:46 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2D27C061757;
        Wed, 28 Jul 2021 12:02:43 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id t3so1749938plg.9;
        Wed, 28 Jul 2021 12:02:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gSKT03NA4DEtO6O+YCZKEJGEnVfDEOnGrSXUvzhO/Vg=;
        b=vbIVubwf59X5xiw+LVZwMbImHDgnV4ARyNtA29y2nLJlynRdjXZnkrjvwBQ4oEVsdG
         JwLuGB6cHIwXCS3EsTr8Z4gyr2HaayEATeG3uoSRCT0v+CHyVFkz1HWxzF0B6Exm9l3S
         3M9ySoF3sv7RDp372Ce8wn17uHuPKRHqMa6NSJLU1HHE8M9UpJUfSspOOwIjrj62TDH0
         4dSPK1QbBwf4/LfF+gxu2UqjqE+eOWZmElRWTaRV/wXwEi5SaCuRNIqSD8CK46Bau5ZI
         l9WWOGZCDryZ/SzwAJOm+rxogz5vx2/zimDZ4nN7B8Br1NMmKf7eun54Fb9lgV6fFLs2
         cgaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gSKT03NA4DEtO6O+YCZKEJGEnVfDEOnGrSXUvzhO/Vg=;
        b=TcqstxgDRjjH7DxGomrjo7Gg5vW/0LdFSyj6zENjEwsNCHUqON4VZZbMllyRcL7zVt
         fMw/Of4jn/UKELDgXSVFJA7Ea/vierycEXoEJ8B2V0Njqmn1chQN33ldCm4kr19D5Rrb
         THYhZMz1hjEo0vreRpL+M4OH0lUcKPzZUgla3X4tRU8BI4EEhbE4ipBwI6X5556fFtKT
         bvoP+qlcKMxnkOp34JUneJ9fwqg/CSHA/cZC1MYnq4Zw1HztY6QExc/4kS5MQHZlviSz
         37+2oKvEMwAeVmTorBtzPnQRvkT8/5QwTOdmhoGgMapoT4t2Z6T0V+/ICCP2VMWHWqkF
         bqpA==
X-Gm-Message-State: AOAM531M7AGZtnR53WW8cr2JnDpefO07RIOPo5X8K/WfB5ruDWcbaD5j
        dEZvOkXwlk0bSXaUx3PA+9UJvPHQeoYjPcaO
X-Google-Smtp-Source: ABdhPJyWyprhhRGvM8i8lxjK3qy10fvAQVKSgXo9BiYVrrmfhtyPK5R7lpf4M9kAnkShLrs+9K08RA==
X-Received: by 2002:aa7:8f07:0:b029:332:958b:1513 with SMTP id x7-20020aa78f070000b0290332958b1513mr1311032pfr.4.1627498963069;
        Wed, 28 Jul 2021 12:02:43 -0700 (PDT)
Received: from [192.168.1.10] ([223.236.188.83])
        by smtp.gmail.com with ESMTPSA id x4sm806376pfb.27.2021.07.28.12.02.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jul 2021 12:02:42 -0700 (PDT)
Subject: Re: [PATCH] ath9k_htc: Add a missing spin_lock_init()
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     ath9k-devel@qca.qualcomm.com, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210727214358.466397-1-rajatasthana4@gmail.com>
 <87y29qgbff.fsf@codeaurora.org>
From:   Rajat Asthana <rajatasthana4@gmail.com>
Message-ID: <738fa8cc-c9c4-66c1-e2ee-fe02caa7ef63@gmail.com>
Date:   Thu, 29 Jul 2021 00:32:38 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <87y29qgbff.fsf@codeaurora.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 28/07/21 12:41 pm, Kalle Valo wrote:
> Rajat Asthana <rajatasthana4@gmail.com> writes:
> 
>> Syzkaller reported a lockdep warning on non-initialized spinlock:
>>
>> INFO: trying to register non-static key.
>> The code is fine but needs lockdep annotation, or maybe
>> you didn't initialize this object before use?
>> turning off the locking correctness validator.
>> CPU: 0 PID: 10 Comm: ksoftirqd/0 Not tainted 5.13.0-rc4-syzkaller #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>> Call Trace:
>>   __dump_stack lib/dump_stack.c:79 [inline]
>>   dump_stack+0x143/0x1db lib/dump_stack.c:120
>>   assign_lock_key kernel/locking/lockdep.c:937 [inline]
>>   register_lock_class+0x1077/0x1180 kernel/locking/lockdep.c:1249
>>   __lock_acquire+0x102/0x5230 kernel/locking/lockdep.c:4781
>>   lock_acquire kernel/locking/lockdep.c:5512 [inline]
>>   lock_acquire+0x19d/0x700 kernel/locking/lockdep.c:5477
>>   __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
>>   _raw_spin_lock_bh+0x2f/0x40 kernel/locking/spinlock.c:175
>>   spin_lock_bh include/linux/spinlock.h:359 [inline]
>>   ath9k_wmi_event_tasklet+0x231/0x3f0 drivers/net/wireless/ath/ath9k/wmi.c:172
>>   tasklet_action_common.constprop.0+0x201/0x2e0 kernel/softirq.c:784
>>   __do_softirq+0x1b0/0x944 kernel/softirq.c:559
>>   run_ksoftirqd kernel/softirq.c:921 [inline]
>>   run_ksoftirqd+0x21/0x50 kernel/softirq.c:913
>>   smpboot_thread_fn+0x3ec/0x870 kernel/smpboot.c:165
>>   kthread+0x38c/0x460 kernel/kthread.c:313
>>   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
>>
>> We missed a spin_lock_init() in ath9k_wmi_event_tasklet() when the wmi
>> event is WMI_TXSTATUS_EVENTID. Placing this init here instead of
>> ath9k_init_wmi() is fine mainly because we need this spinlock when the
>> event is WMI_TXSTATUS_EVENTID and hence it should be initialized when it
>> is needed.
>>
>> Signed-off-by: Rajat Asthana <rajatasthana4@gmail.com>
>> ---
>>   drivers/net/wireless/ath/ath9k/wmi.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
>> index fe29ad4b9023..446b7ca459df 100644
>> --- a/drivers/net/wireless/ath/ath9k/wmi.c
>> +++ b/drivers/net/wireless/ath/ath9k/wmi.c
>> @@ -169,6 +169,7 @@ void ath9k_wmi_event_tasklet(struct tasklet_struct *t)
>>   					     &wmi->drv_priv->fatal_work);
>>   			break;
>>   		case WMI_TXSTATUS_EVENTID:
>> +			spin_lock_init(&priv->tx.tx_lock);
>>   			spin_lock_bh(&priv->tx.tx_lock);
>>   			if (priv->tx.flags & ATH9K_HTC_OP_TX_DRAIN) {
>>   				spin_unlock_bh(&priv->tx.tx_lock);
> 
> This is not making sense to me. You need to elaborate in the commit log
> a lot more why this is "fine". For example, what happens when there are
> multiple WMI_TXSTATUS_EVENTID events?
> 
Thanks for the review!
Now that you mentioned the case when there are multiple 
WMI_TXSTATUS_EVENTID events, this doesn't make sense, as that will cause 
a race condition. This instead should be done in ath9k_init_wmi(). I 
will make this change in the v2 patch.

> Did you test this on a real device?
> 
No, I didn't test this on a real device. Syzkaller has a reproducer for 
this and I just relied on the fact that the reproducer did not reproduce 
the warning with this patch.
