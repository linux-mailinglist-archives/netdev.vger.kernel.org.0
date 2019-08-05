Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9DCD8184A
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 13:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728571AbfHELie (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 07:38:34 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46635 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728518AbfHELie (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 07:38:34 -0400
Received: by mail-wr1-f68.google.com with SMTP id z1so84065012wru.13
        for <netdev@vger.kernel.org>; Mon, 05 Aug 2019 04:38:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3VwSrqTG74vw/OBfhq+zHVhpsEd7efURCTG1Bz2D1O0=;
        b=RkzaPEz5gxVH6Pcz1fy1UCrVzUIHfSYRmYu/K6TUf10VfMtvqtRNAco9Dn7Nn4H5H7
         M20h1tX+mwT6VTKUSIjRllVaO3XoVz2FJV79wUkR+toVYDkauQrVFe5aLAi8xs0CBNTz
         HSqlXs+J2W+xcn0UbLA2LIMBTMFqo6xZ+6zBDadz37+lN4rpmY0oW5diA77P2G6zJepF
         Xeqwj+iD/cGT6qQGw6cuY0BmbWBfaB/K+w5SDa/kd15EJ4XYF2hQLnIns878KHR7rcjc
         EKXNNd0MwfurVpf2vp1eGwL4Mi2TFZy+TjVxKZA5iWBBbEvCof5Pd6DfUiHYhiYhEntj
         EuWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=3VwSrqTG74vw/OBfhq+zHVhpsEd7efURCTG1Bz2D1O0=;
        b=oLGQwvTJofwSsdF0UNVkjt3MmB3uhMxL4aLsB0ne/+/BY9u7rtfRjWFFZYtQWsklLD
         S/SUf8F0ouLFBM7S76YlmEJYCRwYetcLfht+WaEP0IfqKuyxojdUKmnb21iiQkhOtRYB
         BbJbjI8PWGur8f8AVx1zdTz2qAz1WVEEEhYbNz8xfii5nMfok73Qo1AGeKNCvIkvr4WH
         n2rBOV3KRLtEhF2Pcftn6fuwBkOwCdFB9n4lE2mnjGdBCHPck2oEH3r2doHb82CroIly
         ygoHz4gqrl+D6TN4CGGrUsVfhugQyY84OJBRihSDEAtzGaYbW+IEjGnFhDInrBiNqxRL
         xbJg==
X-Gm-Message-State: APjAAAX4+v5mXg8vQ6F4bZnTyQBhNYHBAa0xC8YX+VX0PNOoDZL2sqq7
        hPPAXGl7JHWpjT2y4G3RqoMraQ7JS0A=
X-Google-Smtp-Source: APXvYqz5/1ST10VxUkbXnsjXW7vm7t0pwzwPZN3TVvay/DPfa2qjlK4bBXP2apcB1Ot3DT+axErB1Q==
X-Received: by 2002:a05:6000:1186:: with SMTP id g6mr13958482wrx.17.1565005112159;
        Mon, 05 Aug 2019 04:38:32 -0700 (PDT)
Received: from ?IPv6:2a00:23a8:4c11:1300:c13:7d44:ebfe:c7a2? ([2a00:23a8:4c11:1300:c13:7d44:ebfe:c7a2])
        by smtp.googlemail.com with ESMTPSA id p13sm3686411wrw.90.2019.08.05.04.38.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 04:38:31 -0700 (PDT)
Subject: Re: [PATCH net 1/2] net: sched: police: allow accessing
 police->params with rtnl
To:     Vlad Buslov <vladbu@mellanox.com>, netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net
References: <20190803133619.10574-1-vladbu@mellanox.com>
 <20190803133619.10574-2-vladbu@mellanox.com>
From:   Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
Organization: Netronome
Message-ID: <216113f4-71b4-f149-248c-3d890f3290cf@netronome.com>
Date:   Mon, 5 Aug 2019 12:38:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190803133619.10574-2-vladbu@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/08/03 14:36, Vlad Buslov wrote:
> Recently implemented support for police action in flow_offload infra leads
> to following rcu usage warning:
> 
> [ 1925.881092] =============================
> [ 1925.881094] WARNING: suspicious RCU usage
> [ 1925.881098] 5.3.0-rc1+ #574 Not tainted
> [ 1925.881100] -----------------------------
> [ 1925.881104] include/net/tc_act/tc_police.h:57 suspicious rcu_dereference_check() usage!
> [ 1925.881106]
>                other info that might help us debug this:
> 
> [ 1925.881109]
>                rcu_scheduler_active = 2, debug_locks = 1
> [ 1925.881112] 1 lock held by tc/18591:
> [ 1925.881115]  #0: 00000000b03cb918 (rtnl_mutex){+.+.}, at: tc_new_tfilter+0x47c/0x970
> [ 1925.881124]
>                stack backtrace:
> [ 1925.881127] CPU: 2 PID: 18591 Comm: tc Not tainted 5.3.0-rc1+ #574
> [ 1925.881130] Hardware name: Supermicro SYS-2028TP-DECR/X10DRT-P, BIOS 2.0b 03/30/2017
> [ 1925.881132] Call Trace:
> [ 1925.881138]  dump_stack+0x85/0xc0
> [ 1925.881145]  tc_setup_flow_action+0x1771/0x2040
> [ 1925.881155]  fl_hw_replace_filter+0x11f/0x2e0 [cls_flower]
> [ 1925.881175]  fl_change+0xd24/0x1b30 [cls_flower]
> [ 1925.881200]  tc_new_tfilter+0x3e0/0x970
> [ 1925.881231]  ? tc_del_tfilter+0x720/0x720
> [ 1925.881243]  rtnetlink_rcv_msg+0x389/0x4b0
> [ 1925.881250]  ? netlink_deliver_tap+0x95/0x400
> [ 1925.881257]  ? rtnl_dellink+0x2d0/0x2d0
> [ 1925.881264]  netlink_rcv_skb+0x49/0x110
> [ 1925.881275]  netlink_unicast+0x171/0x200
> [ 1925.881284]  netlink_sendmsg+0x224/0x3f0
> [ 1925.881299]  sock_sendmsg+0x5e/0x60
> [ 1925.881305]  ___sys_sendmsg+0x2ae/0x330
> [ 1925.881309]  ? task_work_add+0x43/0x50
> [ 1925.881314]  ? fput_many+0x45/0x80
> [ 1925.881329]  ? __lock_acquire+0x248/0x1930
> [ 1925.881342]  ? find_held_lock+0x2b/0x80
> [ 1925.881347]  ? task_work_run+0x7b/0xd0
> [ 1925.881359]  __sys_sendmsg+0x59/0xa0
> [ 1925.881375]  do_syscall_64+0x5c/0xb0
> [ 1925.881381]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> [ 1925.881384] RIP: 0033:0x7feb245047b8
> [ 1925.881388] Code: 89 02 48 c7 c0 ff ff ff ff eb bb 0f 1f 80 00 00 00 00 f3 0f 1e fa 48 8d 05 65 8f 0c 00 8b 00 85 c0 75 17 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 58 c3 0f 1f 80 00 00 00 00 48 83
>  ec 28 89 54
> [ 1925.881391] RSP: 002b:00007ffc2d2a5788 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> [ 1925.881395] RAX: ffffffffffffffda RBX: 000000005d4497ed RCX: 00007feb245047b8
> [ 1925.881398] RDX: 0000000000000000 RSI: 00007ffc2d2a57f0 RDI: 0000000000000003
> [ 1925.881400] RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000006
> [ 1925.881403] R10: 0000000000404ec2 R11: 0000000000000246 R12: 0000000000000001
> [ 1925.881406] R13: 0000000000480640 R14: 0000000000000012 R15: 0000000000000001
> 
> Change tcf_police_rate_bytes_ps() and tcf_police_tcfp_burst() helpers to
> allow using them from both rtnl and rcu protected contexts.
> 
> Fixes: 8c8cfc6ed274 ("net/sched: add police action to the hardware intermediate representation")
> Signed-off-by: Vlad Buslov <vladbu@mellanox.com>

Thank you Vlad.
Reviewed-by: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
