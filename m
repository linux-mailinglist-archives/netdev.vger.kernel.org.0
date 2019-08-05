Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1E808184C
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 13:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728518AbfHELjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 07:39:08 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39729 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727259AbfHELjI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 07:39:08 -0400
Received: by mail-wr1-f65.google.com with SMTP id x4so30899211wrt.6
        for <netdev@vger.kernel.org>; Mon, 05 Aug 2019 04:39:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hoO5cgyD2kabqLeuUsjL4GXw4AU/Rdye4N3KRUL+53s=;
        b=1BjGKXF5mBelUzQr2wGXOnFoMYd1D0U/w7J4UA37G+e4CIyK6nkr87gWlO3wqi02Ry
         DRWGPxTdEfhrqz63eiixZzPDJmL9KmSsfYNY0p4M5Y3N9NCW02wR18w/lyFFDnHLBEA+
         IZIjoQzGpSOTPqKIqZHnVmUbUJucnZ5zagNYDlsKKPDLcBQi9CMr5vt1zPW0BhJ2Ya4m
         ImDuBW/WKW9PVNHOn0hYyI/8bNiGsManDM42WKuMPAk+9x9IATQbTtbO16kW1IizOIty
         wNHC+oVgFJ8IGansCwSrImArtYhcfJgtbenOeX0OMZ1l+qjxXlk83LSdhiwT+nZjo1aL
         17EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=hoO5cgyD2kabqLeuUsjL4GXw4AU/Rdye4N3KRUL+53s=;
        b=eCFk+4BfjXw25x3DI58T+UmYqxH1DibkHiT6EtG7PD0KuwCFHk0hBm6Gx9pjnA1Xx6
         bQVcQnKokSbDVo2QJjhtJHaW+W0xv1v+Pk3nEJG93jlOMSTwn+Cq/TU5jaNPnrox4eOM
         ChLbl62QYIUgGDMhzYSZoWgxhUISCEYTsQsOsNN2c9BtGnWEF8AayZkd74dIkYRRHHZc
         UbpZ/Z5o5CLjA9y9oqUL0o95PDfaxVe5zJCGnQm9DwEpmB59mwa+sYURj6GOCX57mYeJ
         1gPUDLT0iwKCnwBxBoQ55f9qQkT9JvKAFhO2tbnSur5LqY9I4JKJ+aNC5T6RiLj0Bxmv
         JQVA==
X-Gm-Message-State: APjAAAX+XLsFcCG/jDix59tH5SDlZNbFeqj8dt6qGpm6W+PQ1imRN2HZ
        ZTDKDXjzJOnbVhwfiG6R7P/bNQ==
X-Google-Smtp-Source: APXvYqylWQUUo3y0VEafJM4Zb3WlkrGhWgvJz/dD8hf9NJKd4tUQUo6j6EcRGc4Tp8jg5+jDpa5Ang==
X-Received: by 2002:adf:ff84:: with SMTP id j4mr56726350wrr.71.1565005146166;
        Mon, 05 Aug 2019 04:39:06 -0700 (PDT)
Received: from ?IPv6:2a00:23a8:4c11:1300:c13:7d44:ebfe:c7a2? ([2a00:23a8:4c11:1300:c13:7d44:ebfe:c7a2])
        by smtp.googlemail.com with ESMTPSA id x24sm79866193wmh.5.2019.08.05.04.39.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 04:39:05 -0700 (PDT)
Subject: Re: [PATCH net 2/2] net: sched: sample: allow accessing psample_group
 with rtnl
To:     Vlad Buslov <vladbu@mellanox.com>, netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net
References: <20190803133619.10574-1-vladbu@mellanox.com>
 <20190803133619.10574-3-vladbu@mellanox.com>
From:   Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
Organization: Netronome
Message-ID: <2f112b31-a1f5-6e4f-9c48-ebc5c4dac0a9@netronome.com>
Date:   Mon, 5 Aug 2019 12:39:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190803133619.10574-3-vladbu@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/08/03 14:36, Vlad Buslov wrote:
> Recently implemented support for sample action in flow_offload infra leads
> to following rcu usage warning:
> 
> [ 1938.234856] =============================
> [ 1938.234858] WARNING: suspicious RCU usage
> [ 1938.234863] 5.3.0-rc1+ #574 Not tainted
> [ 1938.234866] -----------------------------
> [ 1938.234869] include/net/tc_act/tc_sample.h:47 suspicious rcu_dereference_check() usage!
> [ 1938.234872]
>                other info that might help us debug this:
> 
> [ 1938.234875]
>                rcu_scheduler_active = 2, debug_locks = 1
> [ 1938.234879] 1 lock held by tc/19540:
> [ 1938.234881]  #0: 00000000b03cb918 (rtnl_mutex){+.+.}, at: tc_new_tfilter+0x47c/0x970
> [ 1938.234900]
>                stack backtrace:
> [ 1938.234905] CPU: 2 PID: 19540 Comm: tc Not tainted 5.3.0-rc1+ #574
> [ 1938.234908] Hardware name: Supermicro SYS-2028TP-DECR/X10DRT-P, BIOS 2.0b 03/30/2017
> [ 1938.234911] Call Trace:
> [ 1938.234922]  dump_stack+0x85/0xc0
> [ 1938.234930]  tc_setup_flow_action+0xed5/0x2040
> [ 1938.234944]  fl_hw_replace_filter+0x11f/0x2e0 [cls_flower]
> [ 1938.234965]  fl_change+0xd24/0x1b30 [cls_flower]
> [ 1938.234990]  tc_new_tfilter+0x3e0/0x970
> [ 1938.235021]  ? tc_del_tfilter+0x720/0x720
> [ 1938.235028]  rtnetlink_rcv_msg+0x389/0x4b0
> [ 1938.235038]  ? netlink_deliver_tap+0x95/0x400
> [ 1938.235044]  ? rtnl_dellink+0x2d0/0x2d0
> [ 1938.235053]  netlink_rcv_skb+0x49/0x110
> [ 1938.235063]  netlink_unicast+0x171/0x200
> [ 1938.235073]  netlink_sendmsg+0x224/0x3f0
> [ 1938.235091]  sock_sendmsg+0x5e/0x60
> [ 1938.235097]  ___sys_sendmsg+0x2ae/0x330
> [ 1938.235111]  ? __handle_mm_fault+0x12cd/0x19e0
> [ 1938.235125]  ? __handle_mm_fault+0x12cd/0x19e0
> [ 1938.235138]  ? find_held_lock+0x2b/0x80
> [ 1938.235147]  ? do_user_addr_fault+0x22d/0x490
> [ 1938.235160]  __sys_sendmsg+0x59/0xa0
> [ 1938.235178]  do_syscall_64+0x5c/0xb0
> [ 1938.235187]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> [ 1938.235192] RIP: 0033:0x7ff9a4d597b8
> [ 1938.235197] Code: 89 02 48 c7 c0 ff ff ff ff eb bb 0f 1f 80 00 00 00 00 f3 0f 1e fa 48 8d 05 65 8f 0c 00 8b 00 85 c0 75 17 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 58 c3 0f 1f 80 00 00 00 00 48 83
>  ec 28 89 54
> [ 1938.235200] RSP: 002b:00007ffcfe381c48 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> [ 1938.235205] RAX: ffffffffffffffda RBX: 000000005d4497f9 RCX: 00007ff9a4d597b8
> [ 1938.235208] RDX: 0000000000000000 RSI: 00007ffcfe381cb0 RDI: 0000000000000003
> [ 1938.235211] RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000006
> [ 1938.235214] R10: 0000000000404ec2 R11: 0000000000000246 R12: 0000000000000001
> [ 1938.235217] R13: 0000000000480640 R14: 0000000000000012 R15: 0000000000000001
> 
> Change tcf_sample_psample_group() helper to allow using it from both rtnl
> and rcu protected contexts.
> 
> Fixes: a7a7be6087b0 ("net/sched: add sample action to the hardware intermediate representation")
> Signed-off-by: Vlad Buslov <vladbu@mellanox.com>

Thanks
Reviewed-by: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
