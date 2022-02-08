Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78CDE4ADDC7
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 16:58:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381677AbiBHP6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 10:58:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382111AbiBHP6L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 10:58:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 20A4CC061578
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 07:58:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644335887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v2XTp5ltDkKS5HThWNpnr/dpYOjbYUZH4RdxvIVfs6A=;
        b=DDLsVEzqkwSr14MI6tzUcXXbvJMNbjBqrm+pAGxrgzbpRAKwB0Zc8XXsKaSf83lOmo4vAv
        1Ah75FG37LON+N4iVl3NRlWYQWLb+q6SZetWhzRe+ZJ/Akzrku/fy9GY5yMEO8PKDthX8B
        nJe3q5qlfnKR2dq1TQ2IUl+PIbpj5aQ=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-526--SiX3ns4NDqmuOrRiYd8Tg-1; Tue, 08 Feb 2022 10:58:06 -0500
X-MC-Unique: -SiX3ns4NDqmuOrRiYd8Tg-1
Received: by mail-qv1-f69.google.com with SMTP id 3-20020ad45b83000000b00423e8603906so11302807qvp.1
        for <netdev@vger.kernel.org>; Tue, 08 Feb 2022 07:58:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=v2XTp5ltDkKS5HThWNpnr/dpYOjbYUZH4RdxvIVfs6A=;
        b=6djMkfYi5lbp0GkJYUHc0uAmy28RTn71yVAG9EL8Gz5pFLOu1lENUaCHAUzLCaGgNM
         8rl6/8mmXXREYJMntian0H9ssomgkx+VqUC7MMKLgHLSpHsPRWX8zQMdwjadzfIKb64d
         Rum50w9RDJA2SOnuOSLdQxgWcv7PZ4VJLKZp74NwIfSrqAb77EhVHj6Q0iFMW+mDTBh0
         ST+Tk/gstdHJdaVd5FS0OEfQYA0U6KNnZsMxaapPimgDZtFNGjACkFIxbFPZrY9mmFif
         OKGiBQb2ZxsJLNkctK6wh6dNb7ii5+u/sKkMxa1hNOUho11+Ef+mX0RzcieDeqiSJE/C
         NkDg==
X-Gm-Message-State: AOAM530e8hNYMyiK903DP/aiBdxofpq2vyZCxo8DBa7R23J3yCV+5EWs
        vZZfoNJYEeGtGJ8ZZT8TqWJOZ8m0nRRxCbd5WSqRwlBTUapxnhp9tJmgq23CtoDH/6kIqcLSa3R
        oowHSq8UpkJ8fPHlW
X-Received: by 2002:a05:620a:19a8:: with SMTP id bm40mr2689439qkb.488.1644335885687;
        Tue, 08 Feb 2022 07:58:05 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyGXX1dQgvmD7vbGth5idh4az89D6CQp1kX9VsfPE0azos/0T4AYkC2Woj8/1mdp2lYOzsCog==
X-Received: by 2002:a05:620a:19a8:: with SMTP id bm40mr2689412qkb.488.1644335885374;
        Tue, 08 Feb 2022 07:58:05 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-96-254.dyn.eolo.it. [146.241.96.254])
        by smtp.gmail.com with ESMTPSA id d11sm7529028qtd.63.2022.02.08.07.58.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 07:58:04 -0800 (PST)
Message-ID: <8b5010f2e6730ad0af0b9d8949cf34bc17681b12.camel@redhat.com>
Subject: Re: [PATCH net-next 1/2] net: napi: wake up ksoftirqd if needed
 after scheduling NAPI
From:   Paolo Abeni <pabeni@redhat.com>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Yannick Vignon <yannick.vignon@oss.nxp.com>,
        Eric Dumazet <edumazet@google.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Antoine Tenart <atenart@kernel.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Wei Wang <weiwan@google.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev <netdev@vger.kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>, mingkai.hu@nxp.com,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        sebastien.laveze@nxp.com, Yannick Vignon <yannick.vignon@nxp.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date:   Tue, 08 Feb 2022 16:57:59 +0100
In-Reply-To: <YgJZK42urDmKQfgf@linutronix.de>
References: <20220203184031.1074008-1-yannick.vignon@oss.nxp.com>
         <CANn89iKn20yuortKnqKV99s=Pb9HHXbX8e0=58f_szkTWnQbCQ@mail.gmail.com>
         <0ad1a438-8e29-4613-df46-f913e76a1770@oss.nxp.com>
         <20220203170901.52ccfd09@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <YfzhioY0Mj3M1v4S@linutronix.de>
         <20220204074317.4a8be6d8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <078bffa8-6feb-9637-e874-254b6d4b188e@oss.nxp.com>
         <20220204094522.4a233a2b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <Yf1qc7R5rFoALsCo@linutronix.de>
         <20220204105035.4e207e9c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <YgJZK42urDmKQfgf@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-02-08 at 12:51 +0100, Sebastian Andrzej Siewior wrote:
> On 2022-02-04 10:50:35 [-0800], Jakub Kicinski wrote:
> > On Fri, 4 Feb 2022 19:03:31 +0100 Sebastian Andrzej Siewior wrote:
> > > On 2022-02-04 09:45:22 [-0800], Jakub Kicinski wrote:
> > > > Coincidentally, I believe the threaded NAPI wake up is buggy - 
> > > > we assume the thread is only woken up when NAPI gets scheduled,
> > > > but IIUC signal delivery and other rare paths may wake up kthreads,
> > > > randomly.  
> > > 
> > > I had to look into NAPI-threads for some reason.
> > > What I dislike is that after enabling it via sysfs I have to:
> > > - adjust task priority manual so it is preferred over other threads.
> > >   This is usually important on RT. But then there is no overload
> > >   protection.
> > > 
> > > - set an affinity-mask for the thread so it does not migrate from one
> > >   CPU to the other. This is worse for a RT task where the scheduler
> > >   tries to keep the task running.
> > > 
> > > Wouldn't it work to utilize the threaded-IRQ API and use that instead
> > > the custom thread? Basically the primary handler would what it already
> > > does (disable the interrupt) and the threaded handler would feed packets
> > > into the stack. In the overload case one would need to lower the
> > > thread-priority.
> > 
> > Sounds like an interesting direction if you ask me! That said I have
> > not been able to make threaded NAPI useful in my experiments / with my
> > workloads so I'd defer to Wei for confirmation.
> > 
> > To be clear -- are you suggesting that drivers just switch to threaded
> > NAPI, or a more dynamic approach where echo 1 > /proc/irq/$n/threaded
> > dynamically engages a thread in a generic fashion?
> 
> Uhm, kind of, yes.
> 
> Now you have
> 	request_irq(, handler_irq);
> 	netif_napi_add(, , handler_napi);
> 
> The handler_irq() disables the interrupt line and schedules the softirq
> to process handler_napi(). Once handler_napi() is it re-enables the
> interrupt line otherwise it will be processed again on the next tick.
> 
> If you enable threaded NAPI then you end up with a thread and the
> softirq is no longer used. I don't know what the next action is but I
> guess you search for that thread and pin it manually to CPU and assign a
> RT priority (probably, otherwise it will compete with other tasks for
> CPU resources).
> 
> Instead we could have
> 	request_threaded_irq(, handler_irq, handler_napi);
> 
> And we would have basically the same outcome. Except that handler_napi()
> runs that SCHED_FIFO/50 and has the same CPU affinity as the IRQ (and
> the CPU affinity is adjusted if the IRQ-affinity is changed).
> We would still have to work out the details what handler_irq() is
> allowed to do and how to handle one IRQ and multiple handler_napi().
> 
> If you wrap request_threaded_irq() in something like request_napi_irq()
> the you could switch between the former (softirq) and later (thread)
> based NAPI handling (since you have all the needed details).

just for historic reference:

https://lkml.org/lkml/2016/6/15/460

I think that running the thread performing the NAPI loop with
SCHED_FIFO would be dangerous WRT DDOS. Even the affinity setting can
give mixed results depending on the workload - unless you do good
static CPUs allocation pinning each process manually, not really a
generic setup.

Cheers,

Paolo

