Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB6C428685
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 07:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231519AbhJKF6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 01:58:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230331AbhJKF6S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 01:58:18 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B81CC061570
        for <netdev@vger.kernel.org>; Sun, 10 Oct 2021 22:56:19 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id w10-20020a056830280a00b0054e4e6c85a6so11326246otu.5
        for <netdev@vger.kernel.org>; Sun, 10 Oct 2021 22:56:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MCMZjprOoTO3FY4Nz8fWbXma5aFkRInKRgNzdjqncZA=;
        b=H2DkxHxjCwHTlWNcj7RtGx/DxRPxzHwZghfAeje3xwNMr2IfztQNWaSbHta7p1E/1i
         KhmCsa5FwUQYfWC7RBbeSuQZWO62DGXrYPiazxqpUXwkzA1P3cyyJ/VEdNDRtyRVPZ4D
         uiiHRYcvyIsX254t3/TpRkEwqzFgYeY3Du5uizYwt7Q++SiuaQimcXxecPQ5vb3WWV1P
         QOVtboB1pjaKaXfW+yUWGSZw1PL2lRfM/IphFOwHIBbXB8g2C0LUOFMDGJ6k/aq+gQbc
         ygRWuKxaavYRLg6NvKNe860DMSccJZ4qBWq8X77EVjoYsztpIwyson1ZqHpx6hGMjpLS
         8KVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MCMZjprOoTO3FY4Nz8fWbXma5aFkRInKRgNzdjqncZA=;
        b=KnERFBZVIcANV+SzknyxgBrnUr7nGmrslnlZx1xCMhno+V5FRU2gogHr+t8yqak9Oz
         hHMKAUS96g4vJlK7s63uG73BCcCbuhlD3XioYDfrO7GVxrmzf9YChSXosfu5gR3Ig+DC
         GmcYq0JECym1lkeSnszr8Q8NTnstS2r0738gu7DA7FPZ2m1JB1hJOmgOHolMzdP41dZR
         UODPU1PdZTJf51/6IwAdv7D/HQB7um0AIjfkLo5BxaYhh+3fUytufTY0clhuU/qCOF54
         n+MGCIWqCIw+sWJh0/KVUER0m6NY8XlJD0aKfW4ZzTbTMkEZs8O2AqveNDwoCQ8c1/KZ
         cTMg==
X-Gm-Message-State: AOAM5324YNbUjbTTTsTaqxWtEDuweeZrAH/pTeytVC8orqBdOBmv6MrZ
        zvDNLuCRqRw8PxepksrlwhZZZbWnS1aveBMi3O4ICw==
X-Google-Smtp-Source: ABdhPJylB5lDjs9TmS+U3sBCJ7MOpvTx1gdWY4wcOlXdElGccgyFt0pFSmgzEYoH3F20+7YJZV4ucGOZTZ8aK2M6HyE=
X-Received: by 2002:a05:6830:402c:: with SMTP id i12mr5601347ots.319.1633931777032;
 Sun, 10 Oct 2021 22:56:17 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000baddc805cdf928c3@google.com> <YWKmBWfBS3oshQ/z@codewreck.org>
In-Reply-To: <YWKmBWfBS3oshQ/z@codewreck.org>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 11 Oct 2021 07:56:05 +0200
Message-ID: <CACT4Y+bqD=EkkQB6hm+FVWVraDBChnRgqViLTqvmVrVM=1gH+w@mail.gmail.com>
Subject: Re: [syzbot] KMSAN: uninit-value in p9pdu_readf
To:     asmadeus@codewreck.org
Cc:     syzbot <syzbot+06472778c97ed94af66d@syzkaller.appspotmail.com>,
        davem@davemloft.net, ericvh@gmail.com, glider@google.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org, lucho@ionkov.net,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        v9fs-developer@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 10 Oct 2021 at 10:36, <asmadeus@codewreck.org> wrote:
>
> Question for people who know about KMSAN: which of the backtrace or the
> 'Local variable' message should I trust?

Hi Dominique,

Both.
The first is the use of the unit, the second is the origin of the uninit.


> syzbot wrote on Sat, Oct 09, 2021 at 10:48:17PM -0700:
> > =====================================================
> > BUG: KMSAN: uninit-value in p9pdu_vreadf net/9p/protocol.c:147 [inline]
> > BUG: KMSAN: uninit-value in p9pdu_readf+0x46cf/0x4fc0 net/9p/protocol.c:526
> >  p9pdu_vreadf net/9p/protocol.c:147 [inline]
> >  p9pdu_readf+0x46cf/0x4fc0 net/9p/protocol.c:526
> >  p9pdu_vreadf net/9p/protocol.c:198 [inline]
> >  p9pdu_readf+0x2080/0x4fc0 net/9p/protocol.c:526
> >  p9_client_stat+0x2b3/0x710 net/9p/client.c:1724
> >  v9fs_mount+0xc14/0x12c0 fs/9p/vfs_super.c:170
>
> would be 'len' in p9pdu_vreadf, which has to be set as far as I can understand:
> > uint16_t len;
> >
> > errcode = p9pdu_readf(pdu, proto_version,
> >                                 "w", &len);
> > if (errcode)
> >         break;
> >
> > *sptr = kmalloc(len + 1, GFP_NOFS);
>
> with relevant part of p9pdu_readf being:
> > case 'w':{
> >                int16_t *val = va_arg(ap, int16_t *);
> >                __le16 le_val;
> >                if (pdu_read(pdu, &le_val, sizeof(le_val))) {
> >                        errcode = -EFAULT;
> >                        break;
> >                }
> >                *val = le16_to_cpu(le_val);
> >        }
> > ...
> > return errcode;
>
> e.g. either len or errcode should be set...
>
> But:
> > Local variable ----ecode@p9_check_errors created at:
> >  p9_check_errors+0x68/0xb90 net/9p/client.c:506
> >  p9_client_rpc+0xd90/0x1410 net/9p/client.c:801
>
> is something totally different, p9_client_rpc happens before the
> p9pdu_readf call in p9_client_stat, and ecode is local to
> p9_check_errors, I don't see how it could get that far.
>
> Note that inspecting p9_check_errors manually, there is a case where
> ecode is returned (indirectly through err = -ecode) without being
> initialized,

Does this connect both stacks? So the uinit is ecode, is it used in
p9pdu_vreadf? If yes, then that's what KMSAN reported.


> so I will send a patch for that at least, but I have no
> idea if that is what has been reported and it should be trivial to
> reproduce so I do not see why syzbot does not have a reproducer -- it
> retries running the last program that triggered the error before sending
> the report, right?

Yes.

>
> --
> Dominique Martinet | Asmadeus
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/YWKmBWfBS3oshQ/z%40codewreck.org.
