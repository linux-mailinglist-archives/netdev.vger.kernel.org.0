Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF855172D0
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 17:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385839AbiEBPlj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 11:41:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234055AbiEBPlh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 11:41:37 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 276C46569;
        Mon,  2 May 2022 08:38:08 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id i1so6602692plg.7;
        Mon, 02 May 2022 08:38:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=G3glF1N1lkKRH3me6ZqnttV9WJnWFWFCivroWGr8uPw=;
        b=jnlfZk0MfWr19qnX7NNM7gjFbPrAaWIfsyMT/a2rh5ffB/v2pJfbjyvAq97gGIe7rG
         uTUMZLa+nH4Wi+FN1pN2qcbvqHIR7otQfoQlalMkw87IR+nh4GjHlRC2yY+aj07x7Zne
         zGxtELORRMhqCmhbzrZiK6h4L9mSjjEbD0e/BNWv1R3qQVzAWwb6BmkzUoGpIqPCgA0+
         2ObdH2Pg4hawFfFic1Il4G3F/+ejKXGEvbg5eg2rTiwMZw7T8927WOyZTHdoi9Cab9u+
         ja/WP8lvKP5PRcbOA34iZHYDbBB8sQnBVMJ+5O9kafsYw33rMK6sYehTkd+7FNKb5q1e
         OVZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=G3glF1N1lkKRH3me6ZqnttV9WJnWFWFCivroWGr8uPw=;
        b=ggQ+BhhSpV7UcC/hLOGkUd+P217e3yvV6Pckp1U7EPJAAEaK02b/iLypEy5a7Lk8Rs
         lWbYG+0ZVqNhkAdOHoRWbb9Q4rFdBbJRwdCmx1383r/kjg8UOemym4nCVMVynN2BOg68
         1JO2ncOl/vfQMTut9czrWmawF5Bbs1hlGOVQlWcz1nUClE+W9MDTGBkBMG3rsd9cML59
         CfxfDdf/CPakR+GWhbypk9Zh/6zIkSbLrVzxJVkbXE42N3eC4mJWi5FGXENJHuxEgO9C
         8VTmiDAjrXA0GoJf6v7ko2ZzGE3krmM9dyN6N1BWdkmE9c3gIiLrxJrlk8or+7a8B80h
         MMtw==
X-Gm-Message-State: AOAM5315idI4miIGDjidt8gZQmm5F+8zr/gsP0sudzNpnOJJGNibBD9r
        FliLNIsCbzZ9uQQkFIHHNy4=
X-Google-Smtp-Source: ABdhPJz2mcdlrFcmvMvPOd4zB8ruKzEKevBlh0oNjAFvQiI4OOjKtV9AXzvbEK94SOMfNeMR9xysnA==
X-Received: by 2002:a17:903:230f:b0:15e:6e55:3230 with SMTP id d15-20020a170903230f00b0015e6e553230mr12264443plh.35.1651505887371;
        Mon, 02 May 2022 08:38:07 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id ba1-20020a170902720100b0015e8d4eb1e6sm4806927plb.48.2022.05.02.08.38.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 May 2022 08:38:06 -0700 (PDT)
Message-ID: <eaf3a893-00dd-8717-202e-911b395670e1@gmail.com>
Date:   Mon, 2 May 2022 08:38:02 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 15/30] bus: brcmstb_gisb: Clean-up panic/die notifiers
Content-Language: en-US
To:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
        akpm@linux-foundation.org, bhe@redhat.com, pmladek@suse.com,
        kexec@lists.infradead.org
Cc:     linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com, coresight@lists.linaro.org,
        linuxppc-dev@lists.ozlabs.org, linux-alpha@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-um@lists.infradead.org, linux-xtensa@linux-xtensa.org,
        netdev@vger.kernel.org, openipmi-developer@lists.sourceforge.net,
        rcu@vger.kernel.org, sparclinux@vger.kernel.org,
        xen-devel@lists.xenproject.org, x86@kernel.org,
        kernel-dev@igalia.com, kernel@gpiccoli.net, halves@canonical.com,
        fabiomirmar@gmail.com, alejandro.j.jimenez@oracle.com,
        andriy.shevchenko@linux.intel.com, arnd@arndb.de, bp@alien8.de,
        corbet@lwn.net, d.hatayama@jp.fujitsu.com,
        dave.hansen@linux.intel.com, dyoung@redhat.com,
        feng.tang@intel.com, gregkh@linuxfoundation.org,
        mikelley@microsoft.com, hidehiro.kawai.ez@hitachi.com,
        jgross@suse.com, john.ogness@linutronix.de, keescook@chromium.org,
        luto@kernel.org, mhiramat@kernel.org, mingo@redhat.com,
        paulmck@kernel.org, peterz@infradead.org, rostedt@goodmis.org,
        senozhatsky@chromium.org, stern@rowland.harvard.edu,
        tglx@linutronix.de, vgoyal@redhat.com, vkuznets@redhat.com,
        will@kernel.org, Brian Norris <computersforpeace@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
References: <20220427224924.592546-1-gpiccoli@igalia.com>
 <20220427224924.592546-16-gpiccoli@igalia.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220427224924.592546-16-gpiccoli@igalia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/27/2022 3:49 PM, Guilherme G. Piccoli wrote:
> This patch improves the panic/die notifiers in this driver by
> making use of a passed "id" instead of comparing pointer
> address; also, it removes an useless prototype declaration
> and unnecessary header inclusion.
> 
> This is part of a panic notifiers refactor - this notifier in
> the future will be moved to a new list, that encompass the
> information notifiers only.
> 
> Fixes: 9eb60880d9a9 ("bus: brcmstb_gisb: add notifier handling")
> Cc: Brian Norris <computersforpeace@gmail.com>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>

Not sure if the Fixes tag is warranted however as this is a clean up, 
and not really fixing a bug.
-- 
Florian
