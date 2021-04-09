Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12DD435A21A
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 17:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233019AbhDIPfq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 11:35:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231402AbhDIPfo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 11:35:44 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A8F4C061760
        for <netdev@vger.kernel.org>; Fri,  9 Apr 2021 08:35:31 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id x7so6035106wrw.10
        for <netdev@vger.kernel.org>; Fri, 09 Apr 2021 08:35:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yvSGkpKiZJeLkUs39HAicZpxn9NDgLX3/cbE7DBFyNQ=;
        b=SFIUa4VeQ3mqQPRnsexbgqIRz58fblNE2FuPlD4tc0wEBa1xLayD8yQzWL5lvCpQ76
         3MkLOdqYhjPDJH1e1825AEqIC9qinEgoaHf0bkYSt5fqJoISIVuBqIKOgrm2dKJzzL8X
         ve2hheOV2lgp2cUCUIz6QCC3w8gnx0qYGp4XmlzRUNoGZZE4XkxmTtUZSvSq2pLEFAbL
         Etbt7VirjPpajjS/wMhyYiOKRrflgaeN0RHJeCI/f/3ydub4Ls+KTYiUi1a63QU/5Qne
         GYSW4AYwRYWDpORRnYW88GhiZj9RKtQbnHeMys+Z1a2SlL/CAW4Qy4xSd0csv0EOF9lj
         6jSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yvSGkpKiZJeLkUs39HAicZpxn9NDgLX3/cbE7DBFyNQ=;
        b=pX+q0rZG1iHLA81boPTOK2EjMc+QOMQi/C855mhUvkM39x+MgbxXpmnrpogUb2xfIZ
         MmYturlfxPxQWTtJg0IQTyCCd8xB82HmrGs359F5J9fwGjbrzWorAcJZulmzxwT/WH50
         Q6RCGEPU1Clpwc2DNsMEXQCfdzw2AnETbW10hQiwvijx0eoYfJehT7ijEbs5WaQUBoUK
         FZuV/vnOorr0YXx9IwiyjViHeo7JKGSZS3+quo8NHtTGECWmDuFkG/bJrm8VPoo3rAlS
         AlMA0n7ANSLEByZwwTULuwqoxJNAiPs4gsTgNCI07vEwP59lnGUBLjmxJk9t+Q+QOW6g
         rQdg==
X-Gm-Message-State: AOAM533Dk0HacbQJXEDmd7MdBZ9HwCZxKoxAHIfkcnFFgeZHlFLF6NBt
        nufREH+V18FQMhZ7u/cI7QePoHwWmYf5UQ==
X-Google-Smtp-Source: ABdhPJx20NhJ5fdlc0k91tY7vu88Qy30EPGNzKM8M7lnXST+PM/R5wevE0s6ef2rTqsyuJVI26UV/A==
X-Received: by 2002:a5d:58e4:: with SMTP id f4mr16627517wrd.130.1617982530141;
        Fri, 09 Apr 2021 08:35:30 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f38:4600:61aa:4c4d:8bbf:6852? (p200300ea8f38460061aa4c4d8bbf6852.dip0.t-ipconnect.de. [2003:ea:8f38:4600:61aa:4c4d:8bbf:6852])
        by smtp.googlemail.com with ESMTPSA id j123sm4416116wmb.1.2021.04.09.08.35.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Apr 2021 08:35:29 -0700 (PDT)
Subject: Re: [PATCH net v2] net: fix hangup on napi_disable for threaded napi
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>
References: <883923fa22745a9589e8610962b7dc59df09fb1f.1617981844.git.pabeni@redhat.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <385f1818-911e-4c7d-1501-8710691d609a@gmail.com>
Date:   Fri, 9 Apr 2021 17:35:23 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <883923fa22745a9589e8610962b7dc59df09fb1f.1617981844.git.pabeni@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09.04.2021 17:24, Paolo Abeni wrote:
> napi_disable() is subject to an hangup, when the threaded
> mode is enabled and the napi is under heavy traffic.
> 
> If the relevant napi has been scheduled and the napi_disable()
> kicks in before the next napi_threaded_wait() completes - so
> that the latter quits due to the napi_disable_pending() condition,
> the existing code leaves the NAPI_STATE_SCHED bit set and the
> napi_disable() loop waiting for such bit will hang.
> 
> This patch addresses the issue by dropping the NAPI_STATE_DISABLE
> bit test in napi_thread_wait(). The later napi_threaded_poll()
> iteration will take care of clearing the NAPI_STATE_SCHED.
> 
> This also addresses a related problem reported by Jakub:
> before this patch a napi_disable()/napi_enable() pair killed
> the napi thread, effectively disabling the threaded mode.
> On the patched kernel napi_disable() simply stops scheduling
> the relevant thread.
> 
> v1 -> v2:
>   - let the main napi_thread_poll() loop clear the SCHED bit
> 
> Reported-by: Jakub Kicinski <kuba@kernel.org>
> Fixes: 29863d41bb6e ("net: implement threaded-able napi poll loop support")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
>  net/core/dev.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 0f72ff5d34ba..af8c1ea040b9 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -6992,7 +6992,7 @@ static int napi_thread_wait(struct napi_struct *napi)
>  
>  	set_current_state(TASK_INTERRUPTIBLE);
>  
> -	while (!kthread_should_stop() && !napi_disable_pending(napi)) {
> +	while (!kthread_should_stop()) {
>  		/* Testing SCHED_THREADED bit here to make sure the current
>  		 * kthread owns this napi and could poll on this napi.
>  		 * Testing SCHED bit is not enough because SCHED bit might be
> @@ -7010,6 +7010,7 @@ static int napi_thread_wait(struct napi_struct *napi)
>  		set_current_state(TASK_INTERRUPTIBLE);
>  	}
>  	__set_current_state(TASK_RUNNING);
> +
>  	return -1;
>  }
>  
> 

Unrelated to the actual issue:
I wonder why -1 is returned, that's unusual in kernel. The return value
is used as bool, so why not return a bool?
