Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79FC927B5B8
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 21:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbgI1TvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 15:51:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726794AbgI1TvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 15:51:18 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32CC2C0613D0
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 12:51:18 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id x123so2084105pfc.7
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 12:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=BqQM2i0VFoVIUWIR0YuEpa6Ai1/97mzRDr35j7tf8L4=;
        b=C9EUv+2wwyyFn6FJiu/VVbLVblSjg9av85L/szVbIz0Rpy3mJiykJyAX94048whYfv
         xgNsRhYsRnuF4WvxMHmC9mBSXCorfrwc5rM6jE7aNlWsJU5zF/D9ezZV/MKvR4Kgxn6c
         hGEIm89YQAmjo7R5FqdFlWCeu3xCILdpu1ABFzulST9FvrmJr9AM3bKwkoul2jbE2Un7
         e3TukRt5VX493lR24AiqxiiLA1dpjeS95yta+Vm7vPIS2bjbuAUl5C/urY6sQbqC8ysH
         Cu3NWy/mFVXd6hnN7gFAnlpYSxpFbhWjRgd6e+vMhcaM1GIbrcFd+iyfRje2wvH3zLz7
         YP7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=BqQM2i0VFoVIUWIR0YuEpa6Ai1/97mzRDr35j7tf8L4=;
        b=KK4tbSH4LSKuMx67JWyKaRD94l2dDKbM8kUvkO70zcjL5/Q+iGPAYaq38Vn1Nnd0Zi
         8M6mnaMnnn0Aum2OrtTSn6qjK8RVNJMDnTPPUdK6m1wZ3udvrk/h0Awth9pBUwbnNTCf
         AZr6xOqIdH9hpdBiAbbK6k0/MCmwyB02k/T1xsxa2DIHZmxjGYOYYBnVrs4e/lBjDjtP
         eaP2KbjFXQ+YZRcPATG1YchazGjvyxdUeAstZ3iIgo1YOi9fuQtzEK5HMDRn6SfExcJc
         kTTmRX945vW9eKEtc2L7eQDPm+hrwzpGxbuUud3zF6DZYuNnsrWttbUcUrhhZmCtr/Ug
         rlCw==
X-Gm-Message-State: AOAM530jkblw1EM3XVWzY0y4q25uhJm19PfeJIYvtGTKEbtI/c5FOUfG
        bLyNi5SOk5l9KJPlT2ED97fHhA==
X-Google-Smtp-Source: ABdhPJzckG5HDk1GrXpcpaQSCKZRP7ZefiC9sUCSVPJwppJZTnuH436/cYjoi7KCfletdPnr9Qi8DQ==
X-Received: by 2002:aa7:9427:0:b029:142:2501:35df with SMTP id y7-20020aa794270000b0290142250135dfmr818795pfo.63.1601322677478;
        Mon, 28 Sep 2020 12:51:17 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id j26sm2608117pfa.160.2020.09.28.12.51.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Sep 2020 12:51:16 -0700 (PDT)
Subject: Re: [patch 11/35] net: ionic: Replace in_interrupt() usage.
From:   Shannon Nelson <snelson@pensando.io>
To:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Paul McKenney <paulmck@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Pensando Drivers <drivers@pensando.io>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Christian Benvenuti <benve@cisco.com>,
        Govindarajulu Varadarajan <_govind@gmx.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-doc@vger.kernel.org,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        Vishal Kulkarni <vishal@chelsio.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        intel-wired-lan@lists.osuosl.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        Edward Cree <ecree@solarflare.com>,
        Martin Habets <mhabets@solarflare.com>,
        Jon Mason <jdmason@kudzu.us>, Daniel Drake <dsd@gentoo.org>,
        Ulrich Kunitz <kune@deine-taler.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Jouni Malinen <j@w1.fi>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        libertas-dev@lists.infradead.org,
        Pascal Terjan <pterjan@google.com>,
        Ping-Ke Shih <pkshih@realtek.com>
References: <20200927194846.045411263@linutronix.de>
 <20200927194920.918550822@linutronix.de>
 <5e4c3201-9d90-65b1-5c13-e2381445be1d@pensando.io>
Message-ID: <1d0950f8-cab4-9ef2-6cf7-73b71b750a8d@pensando.io>
Date:   Mon, 28 Sep 2020 12:51:14 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <5e4c3201-9d90-65b1-5c13-e2381445be1d@pensando.io>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/28/20 10:24 AM, Shannon Nelson wrote:
> On 9/27/20 12:48 PM, Thomas Gleixner wrote:
>> From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>>
>> The in_interrupt() usage in this driver tries to figure out which 
>> context
>> may sleep and which context may not sleep. in_interrupt() is not really
>> suitable as it misses both preemption disabled and interrupt disabled
>> invocations from task context.
>>
>> Conditionals like that in driver code are frowned upon in general 
>> because
>> invocations of functions from invalid contexts might not be detected
>> as the conditional papers over it.
>>
>> ionic_lif_addr() can be called from:
>>
>>   1) ->ndo_set_rx_mode() which is under netif_addr_lock_bh()) so it 
>> must not
>>      sleep.
>>
>>   2) Init and setup functions which are in fully preemptible task 
>> context.
>>
>> _ionic_lif_rx_mode() has only one call path with BH disabled.

Now that I've had my coffee, let's look at this again - there are 
multiple paths that get us to _ionic_lif_rx_mode():

.ndo_set_rx_mode
   ionic_set_rx_mode,
     _ionic_lif_rx_mode

{ ionic_open, ionic_lif_handle_fw_up, ionic_start_queues_reconfig }
     ionic_txrx_init
       ionic_set_rx_mode
         _ionic_lif_rx_mode

We may not want to change this one.

sln



>>
>> ionic_link_status_check_request() has two call paths:
>>
>>   1) NAPI which obviously cannot sleep
>>
>>   2) Setup which is again fully preemptible task context
>>
>> Add 'can_sleep' arguments to the affected functions and let the callers
>> provide the context instead of letting the functions deduce it.
>>
>> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Shannon Nelson <snelson@pensando.io>
>> Cc: Pensando Drivers <drivers@pensando.io>
>> Cc: "David S. Miller" <davem@davemloft.net>
>> Cc: Jakub Kicinski <kuba@kernel.org>
>> Cc: netdev@vger.kernel.org
>
> Acked-by: Shannon Nelson <snelson@pensando.io>
>
>> ---
>>
>> While reviewing the callpaths, a couple of things were observed which 
>> could
>> be improved:
>>
>> - ionic_lif_deferred_work() can iterate over the list. There is no need
>>    to schedule the work item after each iteration
>
> I think the original writer's intent was to avoid monopolizing the 
> work thread for very long on any one cycle, with the thought that we'd 
> be making more use of this than we currently are.  I'll address this.
>
>>
>> - ionic_link_status_check_request() could have ionic_deferred_work 
>> within
>>    ionic_lif(). This would avoid memory allocation from NAPI. More
>>    important, once IONIC_LIF_F_LINK_CHECK_REQUESTED is set and that 
>> alloc
>>    fails, the link check never happens.
>
> Thanks, I'll fix up that error condition.
>
>>
>> - ionic_lif_handle_fw_down() sets IONIC_LIF_F_FW_RESET. Invokes then
>>    ionic_lif_deinit() which only invokes cancel_work_sync() if
>>    IONIC_LIF_F_FW_RESET is not set. I think the logic is wrong here as
>>    the work must always be cancled. Also the list with ionic_deferred
>>    work items needs a clean up.
>
> I'll look at that, thanks.
>
> sln
>
>

