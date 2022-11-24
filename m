Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD218637E26
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 18:18:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbiKXRSQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 12:18:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiKXRSQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 12:18:16 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC8CB43ADC;
        Thu, 24 Nov 2022 09:18:14 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id e205so2125797oif.11;
        Thu, 24 Nov 2022 09:18:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hgLyHE2tqX23+BTJ55NRiGZ/YG0sDvdV1xwfXStaIJ0=;
        b=kljnifbX0dNKDo7SLmNpHOLLyKwEGvopwnawG2vWBU04jutgUlcgxS3bst1zmkSHCx
         g5jjBcFKxOewQVU7lo28x0oAaC6M++Ujm24vvw0LjNxJCjniKa09h9xdCSboPmvwPXAE
         iFOCKoNUlDJM1pc8Go4BVcJWCXr80gKIdvzUzXTnlxSdHHBYfBO+lld7FtDdzgcaZwuz
         qfF47q9uQlvANquMn/Mrekmpcob1HSzUO5+tbDUsFl+H+UdYcxxcLhdjmCRTM0X7ln/9
         u+vXLCZDiVHeN6CaC/v31xOvWBH6higA0TOfJ3LSjBIBQcW+kS4wdQvLPUvv4m9cDpX8
         ukEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hgLyHE2tqX23+BTJ55NRiGZ/YG0sDvdV1xwfXStaIJ0=;
        b=FSr1L+F0u9GpQcnijOQq2gMfaiSel3sQGsS6nys9rChBxqmeHl4s8vHI9DoGioGs/Z
         /0ea3iJIvNbmwW6POLbB7Rnhn3ZYERFGS1NIjPQD2PmdjYWYO30Q4LFgDJDx330eUg5z
         FfojpXJTg9KizRmFIJPzBlAgH/FScKNtv+Gl2SF8G5znfisL4kf//mL+8TqN7dl/Hr3T
         n4JQEP8kv0DmiI/Tf4hz2zZ/rXUycb8R5IS8W/DNhQ3HMKOPDm/WkMuj+K+mDHLrH/K2
         8+NAkRxUUDrS2v6aPVei6577hyhKizAAcAEhw/wtY1YHfPCaYz1BiOt9uCvN5GcMeC6Q
         s2Iw==
X-Gm-Message-State: ANoB5pkwU7lwJPOtKMyroXdPXQW0RwyusKB0nbmQCsCKMMUQyqeKhLk3
        40REWFbnBrRdM2Gg+eOnv3Q=
X-Google-Smtp-Source: AA0mqf6P9atw0Z+BkOx5F4gPDDepTWfJGMBQTWND84idi6VftIb9Sv7n0F+GBK6LRMIh1h1a64X4/A==
X-Received: by 2002:a05:6808:14d4:b0:35a:a4f:a95d with SMTP id f20-20020a05680814d400b0035a0a4fa95dmr6635297oiw.86.1669310293923;
        Thu, 24 Nov 2022 09:18:13 -0800 (PST)
Received: from t14s.localdomain ([2001:1284:f013:8471:4ef9:baca:5f1a:c3fc])
        by smtp.gmail.com with ESMTPSA id e23-20020a9d6e17000000b0066101e9dccdsm607760otr.45.2022.11.24.09.18.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 09:18:13 -0800 (PST)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 4AB03467887; Thu, 24 Nov 2022 14:18:11 -0300 (-03)
Date:   Thu, 24 Nov 2022 14:18:11 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        vyasevich@gmail.com, nhorman@tuxdriver.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com, weiyongjun1@huawei.com,
        yuehaibing@huawei.com
Subject: Re: [PATCH net v2] sctp: fix memory leak in
 sctp_stream_outq_migrate()
Message-ID: <Y3+nUwOWejYot+M5@t14s.localdomain>
References: <20221124131100.369106-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221124131100.369106-1-shaozhengchao@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 24, 2022 at 09:11:00PM +0800, Zhengchao Shao wrote:
> When sctp_stream_outq_migrate() is called to release stream out resources,
> the memory pointed to by prio_head in stream out is not released.
> 
> The memory leak information is as follows:
>  unreferenced object 0xffff88801fe79f80 (size 64):
>    comm "sctp_repo", pid 7957, jiffies 4294951704 (age 36.480s)
>    hex dump (first 32 bytes):
>      80 9f e7 1f 80 88 ff ff 80 9f e7 1f 80 88 ff ff  ................
>      90 9f e7 1f 80 88 ff ff 90 9f e7 1f 80 88 ff ff  ................
>    backtrace:
>      [<ffffffff81b215c6>] kmalloc_trace+0x26/0x60
>      [<ffffffff88ae517c>] sctp_sched_prio_set+0x4cc/0x770
>      [<ffffffff88ad64f2>] sctp_stream_init_ext+0xd2/0x1b0
>      [<ffffffff88aa2604>] sctp_sendmsg_to_asoc+0x1614/0x1a30
>      [<ffffffff88ab7ff1>] sctp_sendmsg+0xda1/0x1ef0
>      [<ffffffff87f765ed>] inet_sendmsg+0x9d/0xe0
>      [<ffffffff8754b5b3>] sock_sendmsg+0xd3/0x120
>      [<ffffffff8755446a>] __sys_sendto+0x23a/0x340
>      [<ffffffff87554651>] __x64_sys_sendto+0xe1/0x1b0
>      [<ffffffff89978b49>] do_syscall_64+0x39/0xb0
>      [<ffffffff89a0008b>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> Link: https://syzkaller.appspot.com/bug?exrid=29c402e56c4760763cc0
> Fixes: Fixes: 637784ade221 ("sctp: introduce priority based stream scheduler")
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
> v2: add .free_sid hook function and use it to free a stream

It's missing the change to sctp_stream_free as well. Please lets try
to avoid having multiple paths freeing it differently as much as
possible.

Thanks.
