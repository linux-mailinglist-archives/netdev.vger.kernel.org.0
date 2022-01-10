Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6156D489063
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 07:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235023AbiAJGww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 01:52:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231477AbiAJGwt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 01:52:49 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 426FAC06173F
        for <netdev@vger.kernel.org>; Sun,  9 Jan 2022 22:52:48 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id ie23-20020a17090b401700b001b38a5318easo5749045pjb.2
        for <netdev@vger.kernel.org>; Sun, 09 Jan 2022 22:52:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Np0rGjIOmaq1phRFtaxcGEwErJHPpanrz+2k3jxg5N0=;
        b=MLVKar5HL87vyqlzYFRUhuTR1AsrnmiN9TI8yyOKx7pfaNeCAQweXJqsy7pvKSsn7v
         haW4Hq+4tMBZ8cRC9sM4A82ZrIdg7oo9TKSTUYRJVtTW8maaN6Ae+mg6rhvzjWvJFmOX
         a9XsaYXo45Nkb5bWQPASzi8WQv7E9CwkXvgHix8pRD1Q9dzZZclKiNWkkxG2KEXwfRhd
         6KRmj5Heu7fOKmgTkVTN6czmdigTsFcLyKOyixTb37syVnuhjF4M+tB83HNvHjBUJhY3
         fTAC5kX3WOqY+V6zALxb8o7gzfh8QiKRAxndjQjmElFF+hW4OCd6GZ/WuRTiPx060d45
         OTOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Np0rGjIOmaq1phRFtaxcGEwErJHPpanrz+2k3jxg5N0=;
        b=AT7nJDiNuwjjHtNhkxWU5WGU2sUku5QdOk3AHA+W1bLH3R8/qhUEMnpP/duXBsxq7N
         KkFVtnDRrxWHXVRtIGekNq64BDO+tuXpIem3y/QAwuT9djd5Ge24nXplHv30Sd8WrfxE
         clD834QSEtzpmMgKNj+YojfOY+XHhqOT1TtTxkVAUDvM5+lKb5rSHXbf52S6sXtdwKcE
         6XbYF/3xBULL/zo+ulfb4H7PGdoH0bMZBmBufnSJQzAUUR9amK9O4y6+8YKHvRFa1BgH
         w7hABkHMDa+zqitx1xLuXLp/vitxiy8MtnttBNrngThBUa0paXDdkacykytyc2jYnDzr
         /q2g==
X-Gm-Message-State: AOAM531DNtyuLVU3fWXYNUVCt1VH2RJOISZXn4pBSz6a9GYKQD5Sz/Wd
        AQt5P5CbV18pvGKblmBtU1A=
X-Google-Smtp-Source: ABdhPJxk6IeRG093P1yjbmBQyLyCUjiBUkLoUDk6i/2kKl65VP6SahmCcNe3sgdoAtFT1v1nJthRFg==
X-Received: by 2002:a17:90a:294f:: with SMTP id x15mr24012457pjf.136.1641797567818;
        Sun, 09 Jan 2022 22:52:47 -0800 (PST)
Received: from [192.168.99.7] (i220-99-138-239.s42.a013.ap.plala.or.jp. [220.99.138.239])
        by smtp.googlemail.com with ESMTPSA id l2sm5226611pfe.189.2022.01.09.22.52.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Jan 2022 22:52:47 -0800 (PST)
Message-ID: <cd9631c7-ad91-b232-8c98-6d163582288a@gmail.com>
Date:   Mon, 10 Jan 2022 15:52:41 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH net-next] veth: Do not record rx queue hint in veth_xmit
Content-Language: en-US
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, laurent.bernaille@datadoghq.com,
        maciej.fijalkowski@intel.com, eric.dumazet@gmail.com,
        pabeni@redhat.com, john.fastabend@gmail.com, willemb@google.com,
        davem@davemloft.net, kuba@kernel.org, magnus.karlsson@gmail.com
References: <ef4cf3168907944502c81d8bf45e24eea1061e47.1641427152.git.daniel@iogearbox.net>
 <f1d8f965-d369-3438-38f8-b65fb79c9f91@gmail.com>
 <3927bf4a-0034-a985-6899-d50b7eb8a8a5@iogearbox.net>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
In-Reply-To: <3927bf4a-0034-a985-6899-d50b7eb8a8a5@iogearbox.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/01/07 22:56, Daniel Borkmann wrote:
> On 1/6/22 1:57 PM, Toshiaki Makita wrote:
>> On 2022/01/06 9:46, Daniel Borkmann wrote:
>>
>> Thank you for the fix.
>>
>>> (unless configured in non-default manner).
>>
>> Just curious, is there any special configuration to record rx queue index on veth 
>> after your patch?
> 
> Right now skb->queue_mapping represents the tx queue number. So assuming
> dev->real_num_tx_queues == dev->real_num_rx_queues for the veth creation,
> then veth_xmit() picks the rx queue via rcv_priv->rq[rxq] based on tx queue
> number. So, by default veth is created with dev->real_num_tx_queues ==
> dev->real_num_rx_queues == 1, in which case the queue_mapping stays 0.
> Checking with e.g. ...
> 
>    ip link add foo numtxqueues 64 numrxqueues 64 type veth peer numtxqueues 64 
> numrxqueues 64
> 
> ... then stack inside the netns on the veth dev picks a TX queue via
> netdev_core_pick_tx(). Due to the skb_record_rx_queue() / skb_get_rx_queue()
> it is off by one in generic XDP [in hostns] at bpf_prog_run_generic_xdp() for
> the case where veth has more than single queue (Single queue case netif_get_rxqueue()
> will see that skb_rx_queue_recorded() is false and just pick the first queue
> so at least there it's correct).
> 
> Not sure if there is a good way to detect inside bpf_prog_run_generic_xdp()
> that skb was looped to host from netns and then fix up the offset .. other
> option could potentially be an extra device parameter and when enabled only
> then do the skb_record_rx_queue() so it's an explicit opt-in where admin needs
> to be aware of potential implications.
> 
> My worry is that if the skb ends up being pushed out the phys dev, then 1)
> if veth was provisioned with >1 TX queues the admin must also take into
> account the TX queues e.g. on phys devices like ena, so that we're not under-
> utilizing it (or have something like BPF clear the queue mapping before
> it's forwarded). And if we do skb_record_rx_queue() and, say, TX queue numbers
> of veth and phys dev are provisioned to be the same, then we jump +1 on the
> phys dev with a skb_record_rx_queue() which may be unintentional. Hence maybe
> explicit opt-in could be better option?

Thank you for the detailed explanation!
I agree with you on that an opt-in would be better.
I thought you might mean there is already some way to do that by "configured in
non-default manner", so I asked it. Now I understand we need an additional knob
if we really want to extract the veth rx queue number from bpf.

Toshiaki Makita
