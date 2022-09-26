Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 337735EAEFC
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 20:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbiIZSDW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 14:03:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbiIZSCs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 14:02:48 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58B683C16E
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 10:43:34 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id g1-20020a17090a708100b00203c1c66ae3so7652860pjk.2
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 10:43:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=j1xNXDgfZo4rQCUloSX2OISyyGpj+/52xFO6m1QKoSg=;
        b=UzOwPftrjvmrZArl4bMMTI91OL+fLzFDzN5udnDK3S6fSIjemJ+l4ZBfgS/EzpOFKe
         igF64i+JoXrdgCt+MrQ3aVb1pUCu2ZS/nDP+xk8hiCCeqUh7r04yZtVF9xO3CmeVygdU
         uEEhHPMFUQANOiyvGh+n7RgFbgUV2jMJuNv5o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=j1xNXDgfZo4rQCUloSX2OISyyGpj+/52xFO6m1QKoSg=;
        b=k9xil6AFPh8iiibc2pZnjk+4xhS31iL5sgNzxpglBdB0WFhrpu43pvzIUklQxWvRd8
         XAKcxkoD6ytpOs720dlkQj4q6rkKXOMmjRVIHS2qDWnzfq3zt+dLOigkDKFtz8rHJFG8
         o8d0gJbyGut455aCwFU56Q0ewgCjQFkd06FohedgSxhF4mgXW73zm1PL7EeYTLjnLlfB
         +tcLWPmnMBGFoKw8KkIMOo7asubp1yxlFlv/NXv8iuaK5eK6QV4F1W6Bo5qCxolqPyiG
         0cWaYqiVl4T3IhXzoM12DlvM8io2M4LExvmlOmdeRmbQu6GYvmpEaThUdGzG90au/MXW
         XZWA==
X-Gm-Message-State: ACrzQf1pZsynXdzLp1WIJkzqX+qTIm7yr/KcSetbnAE3FdLb5gIwN+MR
        iRxGNNx9HaXeXKiZSw2+ULw5FQ==
X-Google-Smtp-Source: AMsMyM5xWLaacP0gCWXU6Vb8l28VC2vEVwQVZZ9/J+o8DtAsSYddgLDFcn/434F8xIdqzAY64Upd4g==
X-Received: by 2002:a17:90b:384f:b0:202:e1b9:5921 with SMTP id nl15-20020a17090b384f00b00202e1b95921mr38270671pjb.130.1664214213094;
        Mon, 26 Sep 2022 10:43:33 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id ij14-20020a170902ab4e00b0016c4546fbf9sm11612903plb.128.2022.09.26.10.43.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 10:43:32 -0700 (PDT)
Date:   Mon, 26 Sep 2022 10:43:31 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Hawkins Jiawei <yin31149@gmail.com>
Cc:     syzbot+473754e5af963cf014cf@syzkaller.appspotmail.com,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, 18801353760@163.com
Subject: Re: [PATCH] wext: use flex array destination for memcpy()
Message-ID: <202209261042.9B401F8D6@keescook>
References: <00000000000070db2005e95a5984@google.com>
 <20220926150907.8551-1-yin31149@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220926150907.8551-1-yin31149@gmail.com>
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 26, 2022 at 11:09:06PM +0800, Hawkins Jiawei wrote:
> Syzkaller reports refcount bug as follows:

"buffer overflow false positive" instead of "refcount bug"

> ------------[ cut here ]------------
> memcpy: detected field-spanning write (size 8) of single field
> 	"&compat_event->pointer" at net/wireless/wext-core.c:623 (size 4)
> WARNING: CPU: 0 PID: 3607 at net/wireless/wext-core.c:623
> 	wireless_send_event+0xab5/0xca0 net/wireless/wext-core.c:623
> Modules linked in:
> CPU: 1 PID: 3607 Comm: syz-executor659 Not tainted
> 	6.0.0-rc6-next-20220921-syzkaller #0
> [...]
> Call Trace:
>  <TASK>
>  ioctl_standard_call+0x155/0x1f0 net/wireless/wext-core.c:1022
>  wireless_process_ioctl+0xc8/0x4c0 net/wireless/wext-core.c:955
>  wext_ioctl_dispatch net/wireless/wext-core.c:988 [inline]
>  wext_ioctl_dispatch net/wireless/wext-core.c:976 [inline]
>  wext_handle_ioctl+0x26b/0x280 net/wireless/wext-core.c:1049
>  sock_ioctl+0x285/0x640 net/socket.c:1220
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:870 [inline]
>  __se_sys_ioctl fs/ioctl.c:856 [inline]
>  __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:856
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
>  [...]
>  </TASK>
> 
> Wireless events will be sent on the appropriate channels in
> wireless_send_event(). Different wireless events may have different
> payload structure and size, so kernel uses **len** and **cmd** field
> in struct __compat_iw_event as wireless event common LCP part, uses
> **pointer** as a label to mark the position of remaining different part.
> 
> Yet the problem is that, **pointer** is a compat_caddr_t type, which may
> be smaller than the relative structure at the same position. So during
> wireless_send_event() tries to parse the wireless events payload, it may
> trigger the memcpy() run-time destination buffer bounds checking when the
> relative structure's data is copied to the position marked by **pointer**.
> 
> This patch solves it by introducing flexible-array field **ptr_bytes**,
> to mark the position of the wireless events remaining part next to
> LCP part. What's more, this patch also adds **ptr_len** variable in
> wireless_send_event() to improve its maintainability.
> 
> Reported-and-tested-by: syzbot+473754e5af963cf014cf@syzkaller.appspotmail.com
> Link: https://lore.kernel.org/all/00000000000070db2005e95a5984@google.com/
> Suggested-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Hawkins Jiawei <yin31149@gmail.com>

Thanks for spinning this and getting it tested!

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
