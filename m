Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4AC83B82B3
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 15:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234758AbhF3NNf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 09:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234481AbhF3NNe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 09:13:34 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31F68C061756
        for <netdev@vger.kernel.org>; Wed, 30 Jun 2021 06:11:05 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id l18-20020a1ced120000b029014c1adff1edso4378672wmh.4
        for <netdev@vger.kernel.org>; Wed, 30 Jun 2021 06:11:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=bQj0ipO2ItdRh7po6jk5LU+wD6X46gVu43au10FYEgk=;
        b=CWY0cYXyMC145Wy9VDWGWyqjGu7+/nUOTJfcrmORCu8sz9fPQa0s3D7Z9mKXcIzEpd
         OtuH1h68t5pW0qf0v1A+G4hOkz51OLriX4xJJMdgtAXQ2yK7M0PmCpbSDE1HEsceVafA
         vFCHERaCGcxc2MOz0+rWsy3pr8DuzmZOHb3udao3CsbxIGXzOHGCAuQ2q3StcMUOxunw
         wtUdwgeDC6ls+ZuMa6wXvxRuTf0N8+VNrPu64PxweflAssQ2Z4u0nxDCV/jcW/ADbOyB
         8aiYH57c8tuUjvujg/1mkz+E5yhthyRijdVlM16TBTsYMDVn2aF+Ak3MTuwPVeH1jBzZ
         g+fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bQj0ipO2ItdRh7po6jk5LU+wD6X46gVu43au10FYEgk=;
        b=lV2Ti47Vxce8FEmM2BlQD2jwzdDStUnYEnqsSYOal3lBawK4Ws463L3cngr93wHfDk
         F6oudUSqooMxFFlZXN8Cvdgmxhet2vUVS+57ttPyJZ4juuCgCFghhAV9yR9Of94Bh3gM
         MVH/6Ftl+sgrfeLcHqYr8aMbe68zS1IvQp+U9P8gfCUwsBLb7KcwXsbQGif09lhA5NLH
         GlaRdkxNGh1f1p/9fqDiaZZIS7UhhFM1oQuuEpaebyLznzMKBYdurHsqxsbRKyCR/qxB
         Gk0dMQHDpRYUFtMJNck9ziQNAqTHVShCqdJ2oz6N9TdgNBdawcPXZXP/GG5W02H+r3hL
         8p9A==
X-Gm-Message-State: AOAM5332E9FX2wpC08s7jbT1X+/eBHfOd4KUXhbF9w63vp6ujqplAkEs
        2nZYrTA9n4ETK4oNqyJcsDGyMe0qEbI=
X-Google-Smtp-Source: ABdhPJyIyu0kZORXzeARNWA9ef/tJKjSXbgesEGToBWuo9NDe/asd2VaCd9VKvQWRmyqroG7L7Cfrg==
X-Received: by 2002:a05:600c:26d1:: with SMTP id 17mr14148728wmv.1.1625058663301;
        Wed, 30 Jun 2021 06:11:03 -0700 (PDT)
Received: from [192.168.98.98] (80.17.23.93.rev.sfr.net. [93.23.17.80])
        by smtp.gmail.com with ESMTPSA id d24sm1786942wmb.42.2021.06.30.06.11.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jun 2021 06:11:02 -0700 (PDT)
Subject: Re: [ISSUE] EDT will lead ca_rtt to 0 when different tx queue have
 different qdisc
To:     mingkun bian <bianmingkun@gmail.com>, netdev@vger.kernel.org
References: <CAL87dS3zUG65ADXD4E2EnBSO_4FBrB4k=uLc_cT0tr7gbPeMOA@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <c0e3abb4-8f04-84bc-e480-9edbcc652f6b@gmail.com>
Date:   Wed, 30 Jun 2021 15:11:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAL87dS3zUG65ADXD4E2EnBSO_4FBrB4k=uLc_cT0tr7gbPeMOA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/30/21 10:42 AM, mingkun bian wrote:
> Hi,
> 
> I found a problem that ca_rtt have a small chance to become 0 when
> using EDT, then find that it is caused by different tx queue which
> have different qdisc as following:
> 
> The case may be caused by my operation of the network card(ethtool -L
> ethx combined 48)
> 
>     1. Network card original num_tx_queues is 64, real_num_tx_queues
> is 24, so in "mq_init" and "mq_attach", only the first 24 queues are
> set by default qdisc(fq),
> and the last 40 queues are set to  pfifo_fast_ops.
> 
>     2. After the system starts, I exec "ethtool -L ethx combined 48"
> to make the tx/rx queue to 48, but it does not modify qdisc's
> configuration,
> at this time for bbr, bbr will use fq when "
> __dev_queue_xmit->netdev_pick_tx" select  the first 24 queues, and bbr
> will use tcp stack's timer(qdisc is  pfifo_fast_ops) when   "
> __dev_queue_xmit->netdev_pick_tx" select  the last24 queues,
> and in this case, bbr works normally.
> 
>     3. The wrong scenario is:
>     a. tcp select one of  the first 24 tx queues to send, then sch_fq
> change sk->sk_pacing_status from SK_PACING_NEEDED to SK_PACING_FQ,
> then tcp will use fq to send.
>     b. after a while,  not sure for some reason， __dev_queue_xmit->
> netdev_pick_tx select the last  24 queues which qdisc is
> pfifo_fast_ops, then qdisc send this skb immediately(no pacing), then
> ca_rtt = curtime - skb->timestamp_ns, skb->timestamp_ns may be bigger
> than curtime.
> 
> 
> Why does not get_default_qdisc_ops return all queues to the default qdisc?

Some "git blame" can help to point to :

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=1f27cde313d72d6b44a73ba89c8b2c6a99c628cf


1) Some devices have awfully big max TX queues ( @num_tx_queues )

2) Some qdisc are using a lot of memory (for example fq_codel)

pfifo_fast in the other hand uses almost no memory.

We expect admins (or tools) to fully reconfigure qdiscs and all device tuning
(RFS/RPS/XPS... if needed) after a device reconfiguration (especially ethtool -L)

This is especially true as complex qdiscs offer a lot of parameters,
and the 'automatic qdisc selection at queue instantiation' can not change any of them.

SK_PACING_FQ can not be magically unset, so if you are using FQ, you need to make
sure that all queue leaves also use FQ, or alive flows depending on pacing
might misbehave.

Alternatives :
1) You could use "ss -tK" to kill all TCP flows after ethtool -L.
2) Not use FQ, and rely on TCP fallback to 'internal' pacing.

> 
> get_default_qdisc_ops(const struct net_device *dev, int ntx)
> {
> return ntx < dev->real_num_tx_queues ?
> default_qdisc_ops : &pfifo_fast_ops;
> }
> 
> Thanks.
> 
