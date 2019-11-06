Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB5E5F2125
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 22:55:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727638AbfKFVza (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 16:55:30 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:33288 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726779AbfKFVza (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 16:55:30 -0500
Received: by mail-pl1-f194.google.com with SMTP id ay6so5109128plb.0
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 13:55:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=drwCbpjqfeSvDATdf4ky/J/OiUdpYP9Ec0Ek6iX3eW0=;
        b=gQmTWsxhterPaAZmiEhMc+NlWKLUiGHXHZ75pkJauHp5ow1TvjIRy4bNeCzoZ2XffD
         l9+CHUSMXa/xgFcHzWKAeEyv/KQhsRnkYPQeDsWaRkpCo+DJwhr6s4JMuYmbAacw5JzF
         7ImkYURQqzadc7Xk4OfhecQtc+q/sKEqK0HcNbWI7x0/HlfM8IWveuuSRzgOSX+2pyVa
         0yOqy1P2B9otEaY3atsJJ5v2rSdMZf3iXODjLrnVLemCWtWT87ESHn7wxdBSJRsCCZUK
         m8PkW8LjiVyT/Kp5nHAeX8VTuSqWPlA6DOJzjAZr86h6PNsiL1WDtebcPAX11zRzCMs/
         Y8lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=drwCbpjqfeSvDATdf4ky/J/OiUdpYP9Ec0Ek6iX3eW0=;
        b=djNtLxcxxbr7c7kvkbw4ys7ayf8GjPmb23PROdgTZxd0KPl9D9wJe+xZlZ/i8GErwt
         0nrDI2pI4161wFDE658v5xMddIjTclIh+fA3J4ZHRMKBOroozW2eQYIAE+Y41J0ooWFc
         8qSlmoXFuTQe/dpG5Sri3sGJFS+pjOTjC4DrgfdWgA0QblBnFWNQ5T/eFnnaEcjUfAPM
         sPVbg96X6GV9ogY014gSpziSZtZO0dzL1m3O/8+v1Np0eGnunuGGWuKYynnc71seKJt5
         4Iwhk8e28Q8dGCxc56m3mOc7ERZNAciDYyeYr8EuVoy0DKpflvouz8pyB8oqXTylbn6g
         VZvA==
X-Gm-Message-State: APjAAAVmfrlq2xTN3Tz5S5aRIkoe8dQE3u8ZCivo3B2xmKGjIAi4kFW9
        6e8ibzg/8Th4UCLBwjdvf+M=
X-Google-Smtp-Source: APXvYqxuiVhlubGl0Mtpt59S7Vu/+In13yQyDK7ZB9PX/QrmOO1qudEkjMM9WrL8DjDGZCLkXbz4lA==
X-Received: by 2002:a17:902:9f83:: with SMTP id g3mr4936124plq.161.1573077329719;
        Wed, 06 Nov 2019 13:55:29 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id 65sm17357635pff.2.2019.11.06.13.55.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Nov 2019 13:55:28 -0800 (PST)
Subject: Re: [PATCH net-next] net: disable preempt for processed counter
To:     Shannon Nelson <snelson@pensando.io>, netdev@vger.kernel.org,
        davem@davemloft.net
References: <20191106214106.41237-1-snelson@pensando.io>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <09f9f0ce-7f48-9af3-49f3-9599e802fddd@gmail.com>
Date:   Wed, 6 Nov 2019 13:55:27 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191106214106.41237-1-snelson@pensando.io>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/6/19 1:41 PM, Shannon Nelson wrote:
> When a kernel is built with CONFIG_PREEMPT and CONFIG_DEBUG_PREEMPT,
> and a network driver is processing inbound data, we see
> 
>  BUG: using __this_cpu_add() in preemptible [00000000] code: nmd/4170
>  caller is __this_cpu_preempt_check+0x18/0x20
>  CPU: 1 PID: 4170 Comm: nmd Tainted: G           O    4.14.18 #1
>  Hardware name: (xxxxx)
>  Call trace:
>  [<ffff0000080895d0>] dump_backtrace+0x0/0x2a0
>  [<ffff000008089894>] show_stack+0x24/0x30
>  [<ffff0000085ed64c>] dump_stack+0xac/0xf0
>  [<ffff0000083bd538>] check_preemption_disabled+0xf8/0x100
>  [<ffff0000083bd588>] __this_cpu_preempt_check+0x18/0x20
>  [<ffff000008510f64>] __netif_receive_skb_core+0xa4/0xa10
>  [<ffff000008514258>] __netif_receive_skb+0x28/0x80
>  [<ffff0000085183b0>] netif_receive_skb_internal+0x30/0x120
> 
> We found that this gets hit inside of check_preemption_disabled(),
> which is called by __netif_receive_skb_core() wanting to do a safe
> per-cpu statistic increment with __this_cpu_inc(softnet_data.processed).
> In order to be a safe increment, preemption needs to be disabled, but
> in this case there are no calls to preempt_disable()/preempt_enable().
> Note that a few lines later preempt_disable/preempt_enable() are used
> around the call into do_xdp_generic().

Interesting note, but this is not a good reason.

> 
> This patch adds the preempt_disable()/preempt_enable() around
> the call to __this_cpu_inc() as has been done in a few other
> cases in the kernel.
> 
> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> ---
>  net/core/dev.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index bb15800c8cb5..ffda48def391 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4976,7 +4976,9 @@ static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
>  another_round:
>  	skb->skb_iif = skb->dev->ifindex;
>  
> +	preempt_disable();
>  	__this_cpu_inc(softnet_data.processed);
> +	preempt_enable();
>  
>  	if (static_branch_unlikely(&generic_xdp_needed_key)) {
>  		int ret2;
> 

The stack trace does not show which driver fed this packet.

Please tell us more about the driver, or give us the complete stack trace.

