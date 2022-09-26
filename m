Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 040025EB563
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 01:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbiIZXST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 19:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiIZXSP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 19:18:15 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FD92AFAE8;
        Mon, 26 Sep 2022 16:18:13 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id iw17so7627425plb.0;
        Mon, 26 Sep 2022 16:18:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=MWu9LxeXILkEu35poR1d1OwZHNHpMOguryF4xl+laW8=;
        b=Glx1cG6R4N5AQ3/MsgATR3stiqh8eIgzfxio8GlCBs9AJ/FZHl3TLFOqE4tzMJ2tOJ
         bnVd1Ll17O0PaC1MHMojLyrW8V9R1+sXYzpq0zL0kMj6sSa0DIq+pAWZrk2NxJDT4eNJ
         8HcwuSJacYR3UXC/0JMkIBY2ISIWgMTvNMOOwlXJa9vewsm/Q3WuAouLa/9Of9+sg1we
         RIJODPMZb2M10ue7bR8UpfWMIv5+wEz30UhwwyO2QOiU/IReaMd7nTgfr+ur8FsMyv0E
         UcKHuEZId46uhZL+YewQFw1xnG+t1rGe1N4Hk10Cs/06hSuL/yaf9rtcHVYKTJOySupn
         6sGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=MWu9LxeXILkEu35poR1d1OwZHNHpMOguryF4xl+laW8=;
        b=zFd1XjF7r5rHhyayRUPsjCa88xwWLe8cMwNFSkEynlZsioMQda6f28DeEJ0sOH4yNu
         60YT4W6nVMqgf6QQoIn3Y66MwNmTdVPDBUlnndVvWFLoR2v27MRXRQl6r81wTKBmSm7v
         1rlgnq/QL/Fc9o5ug/RgvOCa/3XNucjkLYwKMQDZ01JLntgWKg2gmgNFptytZNNfKbzN
         B+tC8Y6WmM7SScVmptMq6F/uLkI9X2T0HcTITcjB3AzKwNnj0REt6gUeeyVluo8TWRdK
         Wz+t0+g9jH07ZwgnUb7coQ+Me3Ta/nh1gmfMRR7WmatXdjd+lPgZjil1cFltsCFVSTPt
         Lziw==
X-Gm-Message-State: ACrzQf2wC+AzzgKUF4/CzeLh/FcXV2HTdNu/tlsHlyL5QSQoqDNlBNf7
        SYEL4IockFTxM0g1vF0DS+j/9+OvdEwR4oge
X-Google-Smtp-Source: AMsMyM5q82Z7bvkz8qRPo4gHGKdrlJnYx9cEYZfQswnCyQn9TcluNked7DRcdA6QhHp36esg6e4Zbw==
X-Received: by 2002:a17:90b:17c5:b0:202:596d:6e40 with SMTP id me5-20020a17090b17c500b00202596d6e40mr1201171pjb.53.1664234292263;
        Mon, 26 Sep 2022 16:18:12 -0700 (PDT)
Received: from localhost ([223.104.3.28])
        by smtp.gmail.com with ESMTPSA id g129-20020a625287000000b005375a574846sm52145pfb.125.2022.09.26.16.18.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 16:18:11 -0700 (PDT)
From:   Hawkins Jiawei <yin31149@gmail.com>
To:     edumazet@google.com
Cc:     18801353760@163.com, davem@davemloft.net,
        johannes@sipsolutions.net, keescook@chromium.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzbot+473754e5af963cf014cf@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, yin31149@gmail.com
Subject: Re: [PATCH] wext: use flex array destination for memcpy()
Date:   Tue, 27 Sep 2022 07:17:47 +0800
Message-Id: <20220926231747.4841-1-yin31149@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <CANn89i+vx3MJ8D1zz1jUh2XZbFvPicC1RwzREzYXc_TvAFBVxg@mail.gmail.com>
References: <CANn89i+vx3MJ8D1zz1jUh2XZbFvPicC1RwzREzYXc_TvAFBVxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Sept 2022 at 00:14, Eric Dumazet <edumazet@google.com> wrote:
>
> On Mon, Sep 26, 2022 at 8:09 AM Hawkins Jiawei <yin31149@gmail.com> wrote:
> >
> > Syzkaller reports refcount bug as follows:
>
> This has nothing to do with a refcount bug...
Sorry for my typo error, it should be a "buffer overflow false positive" bug
as Kees Cook points out.

I will correct it in my v2 patch.

>
> > ------------[ cut here ]------------
>
>
> > memcpy: detected field-spanning write (size 8) of single field
> >         "&compat_event->pointer" at net/wireless/wext-core.c:623 (size 4)
> > WARNING: CPU: 0 PID: 3607 at net/wireless/wext-core.c:623
> >         wireless_send_event+0xab5/0xca0 net/wireless/wext-core.c:623
> > Modules linked in:
> > CPU: 1 PID: 3607 Comm: syz-executor659 Not tainted
> >         6.0.0-rc6-next-20220921-syzkaller #0
> > [...]
> > Call Trace:
> >  <TASK>
> >  ioctl_standard_call+0x155/0x1f0 net/wireless/wext-core.c:1022
> >  wireless_process_ioctl+0xc8/0x4c0 net/wireless/wext-core.c:955
> >  wext_ioctl_dispatch net/wireless/wext-core.c:988 [inline]
> >  wext_ioctl_dispatch net/wireless/wext-core.c:976 [inline]
> >  wext_handle_ioctl+0x26b/0x280 net/wireless/wext-core.c:1049
> >  sock_ioctl+0x285/0x640 net/socket.c:1220
> >  vfs_ioctl fs/ioctl.c:51 [inline]
> >  __do_sys_ioctl fs/ioctl.c:870 [inline]
> >  __se_sys_ioctl fs/ioctl.c:856 [inline]
> >  __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:856
> >  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
> >  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> >  [...]
> >  </TASK>
> >
> > Wireless events will be sent on the appropriate channels in
> > wireless_send_event(). Different wireless events may have different
> > payload structure and size, so kernel uses **len** and **cmd** field
> > in struct __compat_iw_event as wireless event common LCP part, uses
> > **pointer** as a label to mark the position of remaining different part.
> >
> > Yet the problem is that, **pointer** is a compat_caddr_t type, which may
> > be smaller than the relative structure at the same position. So during
> > wireless_send_event() tries to parse the wireless events payload, it may
> > trigger the memcpy() run-time destination buffer bounds checking when the
> > relative structure's data is copied to the position marked by **pointer**.
> >
> > This patch solves it by introducing flexible-array field **ptr_bytes**,
> > to mark the position of the wireless events remaining part next to
> > LCP part. What's more, this patch also adds **ptr_len** variable in
> > wireless_send_event() to improve its maintainability.
> >
> > Reported-and-tested-by: syzbot+473754e5af963cf014cf@syzkaller.appspotmail.com
> > Link: https://lore.kernel.org/all/00000000000070db2005e95a5984@google.com/
> > Suggested-by: Kees Cook <keescook@chromium.org>
> > Signed-off-by: Hawkins Jiawei <yin31149@gmail.com>
> > ---
> >  include/linux/wireless.h | 10 +++++++++-
> >  net/wireless/wext-core.c | 17 ++++++++++-------
> >  2 files changed, 19 insertions(+), 8 deletions(-)
> >
> > diff --git a/include/linux/wireless.h b/include/linux/wireless.h
> > index 2d1b54556eff..e6e34d74dda0 100644
> > --- a/include/linux/wireless.h
> > +++ b/include/linux/wireless.h
> > @@ -26,7 +26,15 @@ struct compat_iw_point {
> >  struct __compat_iw_event {
> >         __u16           len;                    /* Real length of this stuff */
> >         __u16           cmd;                    /* Wireless IOCTL */
> > -       compat_caddr_t  pointer;
> > +
> > +       union {
> > +               compat_caddr_t  pointer;
> > +
> > +               /* we need ptr_bytes to make memcpy() run-time destination
> > +                * buffer bounds checking happy, nothing special
> > +                */
> > +               DECLARE_FLEX_ARRAY(__u8, ptr_bytes);
> > +       };
> >  };
> >  #define IW_EV_COMPAT_LCP_LEN offsetof(struct __compat_iw_event, pointer)
> >  #define IW_EV_COMPAT_POINT_OFF offsetof(struct compat_iw_point, length)
> > diff --git a/net/wireless/wext-core.c b/net/wireless/wext-core.c
> > index 76a80a41615b..fe8765c4075d 100644
> > --- a/net/wireless/wext-core.c
> > +++ b/net/wireless/wext-core.c
> > @@ -468,6 +468,7 @@ void wireless_send_event(struct net_device *        dev,
> >         struct __compat_iw_event *compat_event;
> >         struct compat_iw_point compat_wrqu;
> >         struct sk_buff *compskb;
> > +       int ptr_len;
> >  #endif
> >
> >         /*
> > @@ -582,6 +583,9 @@ void wireless_send_event(struct net_device *        dev,
> >         nlmsg_end(skb, nlh);
> >  #ifdef CONFIG_COMPAT
> >         hdr_len = compat_event_type_size[descr->header_type];
> > +
> > +       /* ptr_len is remaining size in event header apart from LCP */
> > +       ptr_len = hdr_len - IW_EV_COMPAT_LCP_LEN;
> >         event_len = hdr_len + extra_len;
> >
> >         compskb = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_ATOMIC);
> > @@ -612,16 +616,15 @@ void wireless_send_event(struct net_device *      dev,
> >         if (descr->header_type == IW_HEADER_TYPE_POINT) {
> >                 compat_wrqu.length = wrqu->data.length;
> >                 compat_wrqu.flags = wrqu->data.flags;
> > -               memcpy(&compat_event->pointer,
> > -                       ((char *) &compat_wrqu) + IW_EV_COMPAT_POINT_OFF,
> > -                       hdr_len - IW_EV_COMPAT_LCP_LEN);
> > +               memcpy(compat_event->ptr_bytes,
> > +                      ((char *)&compat_wrqu) + IW_EV_COMPAT_POINT_OFF,
> > +                       ptr_len);
> >                 if (extra_len)
> > -                       memcpy(((char *) compat_event) + hdr_len,
> > -                               extra, extra_len);
> > +                       memcpy(&compat_event->ptr_bytes[ptr_len],
> > +                              extra, extra_len);
> >         } else {
> >                 /* extra_len must be zero, so no if (extra) needed */
> > -               memcpy(&compat_event->pointer, wrqu,
> > -                       hdr_len - IW_EV_COMPAT_LCP_LEN);
> > +               memcpy(compat_event->ptr_bytes, wrqu, ptr_len);
> >         }
> >
> >         nlmsg_end(compskb, nlh);
> > --
> > 2.25.1
> >

