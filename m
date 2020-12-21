Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48A9E2DFB07
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 11:28:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbgLUK2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 05:28:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726323AbgLUK2J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 05:28:09 -0500
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C805C0613D6
        for <netdev@vger.kernel.org>; Mon, 21 Dec 2020 02:27:28 -0800 (PST)
Received: by mail-qt1-x82a.google.com with SMTP id a6so6224530qtw.6
        for <netdev@vger.kernel.org>; Mon, 21 Dec 2020 02:27:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fR3Wt3zQ62XwMiqt3UF5i2efJDr9l60XpKqQf448mFA=;
        b=Bvgqy6/ZkHKDo3JYYF6DXAQyflgOB9BjEZW52JpeQYdidkPGXHcWzmkUL00VG61cHN
         t7Eg06MBek5yY84lI96GBWUEFwQBa/oH2d1rpsjf8a6u7ApJAXk90w8IopcyTVjIsyI0
         ey95+8+ZPU+9lTrblAYkH33+RVLY9BwJFMGkWqonBm36A6tdVmu40ZSQvbODJF1SmEqE
         CY5luzA3SqMFGLG+DlePLMaRQCEAkrI8jNxBgSAdH4tGTGXIy5z3nZmlYkCwmiXk9B1z
         fNiobUSz9kIjs/XLq11ZwBJS/RwkXnHSSMeFdFVG4bkGjpHB4dO236wcCp5opuf2kSat
         hamA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fR3Wt3zQ62XwMiqt3UF5i2efJDr9l60XpKqQf448mFA=;
        b=AcWgB3z3+Q7GNKgX1tNlVYrucy2n9NKB0HsxUTAMnHkBhSWCbWzvYji7otKhhDeAG+
         GNYrmD+CXHhMBE1XajaMNEUsO7ocpjttdRLi5Tn57kwtTHMWiXGXu5aYYR+izCaa3wh2
         Hls2iHwWKpaDpyPRu/icFhaSv2SiJzEofJugJ0keV04VV2dWQRYvs2ZAcetysDK095N4
         1gIH6Z8y2KWGprUiEXS7ECj9G+skLBdlYZPrQeyImiRkarOWnjLlGAEUQ9H9UsW/4aJx
         Xa9Ht7kWd69CJvLNhT/l4PuwOX/sdaWS16K7SPmKTp8872uKxSgeAN3weagZ2fncTuGf
         UjWA==
X-Gm-Message-State: AOAM533ZxnUDii1xocJP/jIgraSNzg7XDTemVG/t6XHJyj6VXqYYBq0l
        1vQmAdJgW9inxqFUD6ESLI5HKLYB94ve10sLJX/g22JaK4fVbA==
X-Google-Smtp-Source: ABdhPJw1b/9zgZLNBsp4OrvZk0aD2DbdUOacdbfnS7R4J3TQoKsfZpBO5kf3FG3v32IZHijPxyhzJBxVc6NXvfwTYQM=
X-Received: by 2002:ac8:4986:: with SMTP id f6mr15298599qtq.43.1608542087119;
 Mon, 21 Dec 2020 01:14:47 -0800 (PST)
MIME-Version: 1.0
References: <000000000000e13e2905b6e830bb@google.com> <CAHmME9qwbB7kbD=1sg_81=82vO07XMV7GyqBcCoC=zwM-v47HQ@mail.gmail.com>
In-Reply-To: <CAHmME9qwbB7kbD=1sg_81=82vO07XMV7GyqBcCoC=zwM-v47HQ@mail.gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 21 Dec 2020 10:14:36 +0100
Message-ID: <CACT4Y+ac8oFk1Sink0a6VLUiCENTOXgzqmkuHgQLcS2HhJeq=g@mail.gmail.com>
Subject: Re: UBSAN: object-size-mismatch in wg_xmit
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Kees Cook <keescook@google.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 20, 2020 at 10:11 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> Hmm, on first glance, I'm not sure I'm seeing the bug:
>
> On Sun, Dec 20, 2020 at 5:54 PM syzbot
> <syzbot+8f90d005ab2d22342b6d@syzkaller.appspotmail.com> wrote:
> > UBSAN: object-size-mismatch in ./include/linux/skbuff.h:2021:28
> > member access within address 0000000085889cc2 with insufficient space
> > for an object of type 'struct sk_buff'
> >  __skb_queue_before include/linux/skbuff.h:2021 [inline]
> >  __skb_queue_tail include/linux/skbuff.h:2054 [inline]
> >  wg_xmit+0x45d/0xdf0 drivers/net/wireguard/device.c:182
>
> The code in question is:
>
>         struct sk_buff_head packets;
>         __skb_queue_head_init(&packets);
> ...
>         skb_list_walk_safe(skb, skb, next) {
>                skb_mark_not_on_list(skb);
>
>                skb = skb_share_check(skb, GFP_ATOMIC);
>                if (unlikely(!skb))
>                        continue;
> ...
>                __skb_queue_tail(&packets, skb);
>        }
>
> We're in a netdev's xmit function, so nothing else should have skb at
> that point. Given the warning is about "member access", I assume it's
> the next->prev dereference here:
>
> static inline void __skb_queue_before(struct sk_buff_head *list,
>                                      struct sk_buff *next,
>                                      struct sk_buff *newsk)
> {
>        __skb_insert(newsk, next->prev, next, list);
> }
>
> So where is "next" coming from that UBSAN would complain about
> object-size-mismatch?
>
> static inline void __skb_queue_tail(struct sk_buff_head *list,
>                                   struct sk_buff *newsk)
> {
>        __skb_queue_before(list, (struct sk_buff *)list, newsk);
> }
>
> It comes from casting "list" into an sk_buff. While this might be some
> CFI-violating polymorphism, I can't see why this cast would actually
> be a problem in practice. The top of sk_buff is intentionally the same
> as sk_buff_head:
>
> struct sk_buff_head {
>        struct sk_buff  *next;
>        struct sk_buff  *prev;
> ...
> struct sk_buff {
>        union {
>                struct {
>                        struct sk_buff          *next;
>                        struct sk_buff          *prev;
> ...
>
> I'd suspect, "oh maybe it's just a clang 11 bug", but syzbot says it
> can't reproduce. So that makes me a little more nervous.
>
> Does anybody see something I've missed?

+Kees for UBSAN report questions

Hi Jason,

Thanks for looking into this.

Reading clang docs for ubsan:

https://clang.llvm.org/docs/UndefinedBehaviorSanitizer.html
-fsanitize=object-size: An attempt to potentially use bytes which the
optimizer can determine are not part of the object being accessed.
This will also detect some types of undefined behavior that may not
directly access memory, but are provably incorrect given the size of
the objects involved, such as invalid downcasts and calling methods on
invalid pointers. These checks are made in terms of
__builtin_object_size, and consequently may be able to detect more
problems at higher optimization levels.

From skimming though your description this seems to fall into
"provably incorrect given the size of the objects involved".
I guess it's one of these cases which trigger undefined behavior and
compiler can e.g. remove all of this code assuming it will be never
called at runtime and any branches leading to it will always branch in
other directions, or something.
