Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3CB71C2C7A
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 14:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728503AbgECMul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 08:50:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728115AbgECMuk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 May 2020 08:50:40 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72891C061A0C
        for <netdev@vger.kernel.org>; Sun,  3 May 2020 05:50:40 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id u189so8756016ilc.4
        for <netdev@vger.kernel.org>; Sun, 03 May 2020 05:50:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GiUSG5GkP26HALIdlrItQY2NYBaW76ZGmrfqbfScIHI=;
        b=Qm9HlHOvNZJINCQsATxbGlePr+fVJ25NLUWrDUR6wOWsMT1n6D6a52Qo5fKBWBwaIg
         44BYTxJrfwg7ZUyF/9fgZrgSjzzjeZe9oqo8ujMQzm89quXPE+ehzxS+pSzPP9yMjB2r
         ayNOG2OGgasFnbBIP9NtZx4nIvP2K2O3SaK4oFEPA9DMpIY5ZFdgOgT3Rt+MqK/I9hm9
         yMy8ibQACv0zu7rlhLI16AT0jk3nW/lksonLaQcBu1csEaFaH7e5g+q08k2d7oX9T414
         kQFv+kSrJWdiMpPs17B/ahf9vLT5+9fJ2LT8b8anqqVGJKbbxaVqHrtkcLDQV0ISR5S+
         3VSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GiUSG5GkP26HALIdlrItQY2NYBaW76ZGmrfqbfScIHI=;
        b=IyelAcW6/5f0BamuUM2JcZ0Ch5b1hO1G/W5RVuyXEav80AuLqjFQZsz57tuCGsLXBB
         FiTob21vntWaPppZp9urHGc70R5AHRzrfu+zi81Jwz+a7oiPjBlKD1qwCkmgYP4x2tWm
         u8rvyG2s13IBad0thCiKNOfbnMD91oV/eRobnFqznCDPYW5BlmBGcfbmqC/L2Fuk1kLZ
         glOWuFZBPoVbK8KhU6rv/rx4LbU3mv7Rn0zUeYWjm5MO+MzXzbTNTQcRocNtEUZa2skn
         mDsyeDa6IV9YGrL95s5rN4nCLmhR5pVlp8BMx46oCrDC1FSyzRtQRwexE8BqbXt4ZzGW
         +9/w==
X-Gm-Message-State: AGi0Pubikriqz8vHqPTnKP+XUkYmPBPx0k67MXL745oyYPJTsJNRLA0a
        S0QplgoNLeXa+EI2Q+dGdHLiew==
X-Google-Smtp-Source: APiQypJgeDO+YC0PJ1xJG9ie35485zK8mfXPpqh8/T38QBoyYOR3tSE/X/EO3MrIAmCc7g1g6/V7Pg==
X-Received: by 2002:a05:6e02:d09:: with SMTP id g9mr12196051ilj.230.1588510239726;
        Sun, 03 May 2020 05:50:39 -0700 (PDT)
Received: from [10.0.0.125] (23-233-27-60.cpe.pppoe.ca. [23.233.27.60])
        by smtp.googlemail.com with ESMTPSA id u128sm2708233ioe.23.2020.05.03.05.50.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 May 2020 05:50:39 -0700 (PDT)
Subject: Re: [Patch net v2] net_sched: fix tcm_parent in tc filter dump
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@resnulli.us>
References: <20200501035349.31244-1-xiyou.wangcong@gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <82f9f756-a49b-9aa9-5b1c-52cddf9997a5@mojatatu.com>
Date:   Sun, 3 May 2020 08:50:38 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200501035349.31244-1-xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-04-30 11:53 p.m., Cong Wang wrote:
> When we tell kernel to dump filters from root (ffff:ffff),
> those filters on ingress (ffff:0000) are matched, but their
> true parents must be dumped as they are. However, kernel
> dumps just whatever we tell it, that is either ffff:ffff
> or ffff:0000:
> 
>   $ nl-cls-list --dev=dummy0 --parent=root
>   cls basic dev dummy0 id none parent root prio 49152 protocol ip match-all
>   cls basic dev dummy0 id :1 parent root prio 49152 protocol ip match-all
>   $ nl-cls-list --dev=dummy0 --parent=ffff:
>   cls basic dev dummy0 id none parent ffff: prio 49152 protocol ip match-all
>   cls basic dev dummy0 id :1 parent ffff: prio 49152 protocol ip match-all
> 
> This is confusing and misleading, more importantly this is
> a regression since 4.15, so the old behavior must be restored.
> 
> And, when tc filters are installed on a tc class, the parent
> should be the classid, rather than the qdisc handle. Commit
> edf6711c9840 ("net: sched: remove classid and q fields from tcf_proto")
> removed the classid we save for filters, we can just restore
> this classid in tcf_block.
> 
> Steps to reproduce this:
>   ip li set dev dummy0 up
>   tc qd add dev dummy0 ingress
>   tc filter add dev dummy0 parent ffff: protocol arp basic action pass
>   tc filter show dev dummy0 root
> 
> Before this patch:
>   filter protocol arp pref 49152 basic
>   filter protocol arp pref 49152 basic handle 0x1
> 	action order 1: gact action pass
> 	 random type none pass val 0
> 	 index 1 ref 1 bind 1
> 
> After this patch:
>   filter parent ffff: protocol arp pref 49152 basic
>   filter parent ffff: protocol arp pref 49152 basic handle 0x1
>   	action order 1: gact action pass
>   	 random type none pass val 0
> 	 index 1 ref 1 bind 1
> 
> Fixes: a10fa20101ae ("net: sched: propagate q and parent from caller down to tcf_fill_node")
> Fixes: edf6711c9840 ("net: sched: remove classid and q fields from tcf_proto")
> Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> Cc: Jiri Pirko <jiri@resnulli.us>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>


cheers,
jamal
