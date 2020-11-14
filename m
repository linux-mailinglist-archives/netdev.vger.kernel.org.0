Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEADC2B2DB8
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 15:55:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbgKNOzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 09:55:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbgKNOzI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 09:55:08 -0500
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D3AAC0613D1
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 06:55:08 -0800 (PST)
Received: by mail-qt1-x842.google.com with SMTP id i12so9469666qtj.0
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 06:55:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mojPSKd+mwydD8B35CVQ3jdtsJXmDqUHodO/gE9fqTA=;
        b=lN2sD/tggQ3LcVq+ufRezUdWO0UrllcFjYQqlLPFJN8zQ8wP4sEfdZCBCCihDNZUNv
         apzhvNK2DhbtfqeODcB3YB9p6xl/+8xtHuxHpzocdjskgkcr/jvEupW+ODY/oOc6xJfm
         167Sh6KjPAMLdnjAKulh9oaHyiE6sRQsX8RiuBMXVHqwd6BpcYkVflkOD0MERtlbQyUl
         wkRSkm1Z3aww96QpkJwiWeTzZFtObjFF+U7EEBnj55rC0YxVEqog40rThkpCvaMUGakg
         nzsTPqFSsbrQkvNtmiKWC7HOvGxtpzZ0mvM5NONb/tlkiGzJN7Qr6OSWpWOgWCNcXfyr
         tFcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mojPSKd+mwydD8B35CVQ3jdtsJXmDqUHodO/gE9fqTA=;
        b=IvowaPSz3R2Gc8twOhRO8pfDzc2wdn8d42xspxjWVVLe9NimjoticCDEC6ZIwYJzYR
         s8aOwgoAtC55Pva217ngY5VlymLNSDK1fi+m08IOzUkY8KY4Q32+dU6dDzzMxOytMkNz
         gy7OSsC9d9fV2Qdt0xvGUm04QMTDI8yeBKergDzd9uoIoM9dWi62ahEWwKhz8L0ylrj/
         8byzBi1bxZ0J/7S23dfMHReiyHk2NrhZvIIXAF+bCsT0dKfWA2NzJ7LcfANosEnhmrqU
         acIogAzkCfo9APAmtKjPEWQtp4K7+7NsZ7Fj6GaZFkIAwtvrpm63BPKbu/dreogfWBQZ
         IoHw==
X-Gm-Message-State: AOAM530Fbt9Y5cfKGI3muPYYM43faeY1IqTJzyWZp94AeYvbUqpQdqed
        dO7A9jF/+Xel1myiVUbPMSKc7ut9xmXR1w==
X-Google-Smtp-Source: ABdhPJxi/VnnAKKV9p0lYtWFxVl+d7slWBrry5jndr1J6IHIfjBqV6htDVu60zmPDIDQ7eR9kkqExA==
X-Received: by 2002:ac8:6651:: with SMTP id j17mr6685436qtp.176.1605365707159;
        Sat, 14 Nov 2020 06:55:07 -0800 (PST)
Received: from [192.168.2.28] (bras-base-kntaon1617w-grc-10-184-147-165-106.dsl.bell.ca. [184.147.165.106])
        by smtp.googlemail.com with ESMTPSA id m16sm8302101qta.57.2020.11.14.06.55.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Nov 2020 06:55:06 -0800 (PST)
Subject: Re: [PATCH v11 net-next 0/3] net/sched: fix over mtu packet of defrag
 in
To:     wenxu@ucloud.cn, kuba@kernel.org, marcelo.leitner@gmail.com,
        vladbu@nvidia.com
Cc:     netdev@vger.kernel.org
References: <1605174212-610-1-git-send-email-wenxu@ucloud.cn>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <96f537a0-f911-e5a2-13d7-20db3036f8d1@mojatatu.com>
Date:   Sat, 14 Nov 2020 09:54:56 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <1605174212-610-1-git-send-email-wenxu@ucloud.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

FWIW, I see the pragmatic need for this and so; cant think
of a better way to do this. Patch one could probably go in its
own merit.
Wenxu, please Cc maintainers in the future - makes it easier
to get feedback.

Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal

On 2020-11-12 4:43 a.m., wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> Currently kernel tc subsystem can do conntrack in act_ct. But when several
> fragment packets go through the act_ct, function tcf_ct_handle_fragments
> will defrag the packets to a big one. But the last action will redirect
> mirred to a device which maybe lead the reassembly big packet over the mtu
> of target device.
> 
> The first patch fix miss init the qdisc_skb_cb->mru
> The send one refactor the hanle of xmit in act_mirred and prepare for the
> third one
> The last one add implict packet fragment support to fix the over mtu for
> defrag in act_ct.
> 
> wenxu (3):
>    net/sched: fix miss init the mru in qdisc_skb_cb
>    net/sched: act_mirred: refactor the handle of xmit
>    net/sched: act_frag: add implict packet fragment support.
> 
>   include/net/act_api.h     |  18 +++++
>   include/net/sch_generic.h |   5 --
>   net/core/dev.c            |   2 +
>   net/sched/Kconfig         |  13 ++++
>   net/sched/Makefile        |   1 +
>   net/sched/act_api.c       |  44 +++++++++++++
>   net/sched/act_ct.c        |   7 ++
>   net/sched/act_frag.c      | 164 ++++++++++++++++++++++++++++++++++++++++++++++
>   net/sched/act_mirred.c    |  21 ++++--
>   9 files changed, 264 insertions(+), 11 deletions(-)
>   create mode 100644 net/sched/act_frag.c
> 

