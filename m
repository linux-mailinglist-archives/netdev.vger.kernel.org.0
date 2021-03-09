Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90C883322B2
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 11:13:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbhCIKMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 05:12:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbhCIKMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 05:12:38 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F02E3C06174A
        for <netdev@vger.kernel.org>; Tue,  9 Mar 2021 02:12:37 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id j2so14549030wrx.9
        for <netdev@vger.kernel.org>; Tue, 09 Mar 2021 02:12:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0D+9zqeNrqlWIqYAh7ERhGnrGiPv8RpwEs6JQMaWiwE=;
        b=cx4xnCV/Sg2urjc/qAPaCsLQ5F314hhOu9ktSKkQyiZoyLs+45obKiO0bF/c7uFqoJ
         zvjWiZzl4jac3aRYiBczmBADV6CoDh8axuWlz/wTqRt5ze0LgDB9WW/pTqgkWLzFd7n0
         ay3N71rjOWOSX7Eqj/e0yjtQNWU2TOjBMFB2S1fs5mCYotRXvRZaGifdzkwDthnz3Uou
         G7pQC/3fNa6m7Us2ACSdRrz70DcN4s2tRACLepz2dlB64xoVkOoeDfMkh8teCJEjvab2
         fTBllETCHFIGXjJIrEDnm0emaHsNLyB+TmHePc2f7yezlf2b2+ec36aXZwjl+nBLgNp7
         epdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0D+9zqeNrqlWIqYAh7ERhGnrGiPv8RpwEs6JQMaWiwE=;
        b=Jk8Yts3Kj11WzwPk4y8HmiEpJGSSuRHiMXXY0yljSIC+eFtWxr9y1oNFr1mMV6zGd0
         fmJdkFE5zU7+ma4k024yxGxcHJYF8YCbQ4WH9WwwZ2P2PoVLOo1d0XAbM9eTmwasUIbm
         8990D7eJJfgFWIRfFugPIzOW4qZyj4L+0vCbafnDNZrm0dfZzW6ahu0WSDZNFXZXDo1x
         fPDo+6zMSEdbJ8n2lY46i31snOrYHh6Xd5lROHMrXXBMYAnOw6hHe355kdDkZhuKmFor
         BMckMUi/Oqg/ejX23/ZI6j1l9DLDDNAnVZ1YzSQt4FVJC+IW8qn1Hd9mMd3W1HPq4/xS
         1yRA==
X-Gm-Message-State: AOAM533uIB1Fe/++0x2HUfj+9GXBd16XIkL3xGp0qxil93TnRE2uVhtO
        Bgf1sB9kRZoMpvMusQcuoYQwPyNbXAc=
X-Google-Smtp-Source: ABdhPJxH/ovdTUrQUrLVCWQ+D45B3x0MyeQzMazU1K6DU/fefNW3sA8l38nOxsqtymKkWv4CAaWQjg==
X-Received: by 2002:a5d:6312:: with SMTP id i18mr27706587wru.149.1615284756749;
        Tue, 09 Mar 2021 02:12:36 -0800 (PST)
Received: from [192.168.1.101] ([37.173.43.42])
        by smtp.gmail.com with ESMTPSA id v18sm3736526wru.85.2021.03.09.02.12.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Mar 2021 02:12:36 -0800 (PST)
Subject: Re: seqlock lockdep false positives?
To:     Peter Zijlstra <peterz@infradead.org>,
        "Erhard F." <erhard_f@mailbox.org>
Cc:     "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
References: <20210303164035.1b9a1d07@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YESayEskbtjEWjFd@lx-t490> <YEXicy6+9MksdLZh@hirez.programming.kicks-ass.net>
 <20210308214208.42a5577f@yea>
 <YEcpqwhQFMimu6Ml@hirez.programming.kicks-ass.net>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <e745809b-b6c7-7b6a-b598-4e3bbd3e48d7@gmail.com>
Date:   Tue, 9 Mar 2021 11:12:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YEcpqwhQFMimu6Ml@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/9/21 8:54 AM, Peter Zijlstra wrote:
> On Mon, Mar 08, 2021 at 09:42:08PM +0100, Erhard F. wrote:
> 
>> I can confirm that your patch on top of 5.12-rc2 makes the lockdep
>> splat disappear (Ahmeds' 1st patch not installed).
> 
> Excellent, I'll queue the below in locking/urgent then.
> 
> 
> ---
> Subject: u64_stats,lockdep: Fix u64_stats_init() vs lockdep
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Mon, 8 Mar 2021 09:38:12 +0100
> 
> Jakub reported that:
> 
>     static struct net_device *rtl8139_init_board(struct pci_dev *pdev)
>     {
> 	    ...
> 	    u64_stats_init(&tp->rx_stats.syncp);
> 	    u64_stats_init(&tp->tx_stats.syncp);
> 	    ...
>     }
> 
> results in lockdep getting confused between the RX and TX stats lock.
> This is because u64_stats_init() is an inline calling seqcount_init(),
> which is a macro using a static variable to generate a lockdep class.
> 
> By wrapping that in an inline, we negate the effect of the macro and
> fold the static key variable, hence the confusion.
> 
> Fix by also making u64_stats_init() a macro for the case where it
> matters, leaving the other case an inline for argument validation
> etc.
> 
> Reported-by: Jakub Kicinski <kuba@kernel.org>
> Debugged-by: "Ahmed S. Darwish" <a.darwish@linutronix.de>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Tested-by: "Erhard F." <erhard_f@mailbox.org>
> Link: https://lkml.kernel.org/r/YEXicy6+9MksdLZh@hirez.programming.kicks-ass.net
> ---
>  include/linux/u64_stats_sync.h |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> --- a/include/linux/u64_stats_sync.h
> +++ b/include/linux/u64_stats_sync.h
> @@ -115,12 +115,13 @@ static inline void u64_stats_inc(u64_sta
>  }
>  #endif
>  
> +#if BITS_PER_LONG == 32 && defined(CONFIG_SMP)
> +#define u64_stats_init(syncp)	seqcount_init(&(syncp)->seq)
> +#else
>  static inline void u64_stats_init(struct u64_stats_sync *syncp)
>  {
> -#if BITS_PER_LONG == 32 && defined(CONFIG_SMP)
> -	seqcount_init(&syncp->seq);
> -#endif
>  }
> +#endif
>  
>  static inline void u64_stats_update_begin(struct u64_stats_sync *syncp)
>  {
> 

Interesting !

It seems seqcount_latch_init() might benefit from something similar.


