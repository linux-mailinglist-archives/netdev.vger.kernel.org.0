Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF674C63C6
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 08:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233445AbiB1H1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 02:27:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231347AbiB1H1l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 02:27:41 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D058666AC7;
        Sun, 27 Feb 2022 23:27:01 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id y11so10322028pfa.6;
        Sun, 27 Feb 2022 23:27:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Mu4z0K7hpkoqgqdclRigMyBEeZ29kUN9ssnH5fqcZQE=;
        b=ZmrPa37c+Rc73oAqIjoShfBAFOZTvK1o8tQcfNrdcK3m6Ntrd1PM/ajCIG/iwsCVo4
         VxsFqD9qXZNUut3zfAys4mGmJ4WRoKBshMUGhW934z+TE3cNlTfghzRZX8gERnSV5fiB
         dsR/o4OUTz+2OgHlmlz736hFvWSWBTEZEW0X/KcbjMwsz6kwLKjKZfb4HqvEMNYv8awN
         pjZRPxmMosTEW9PDwAWNMrbJXN5zrftksiBENS4UDVHZ/35WiY18uYnYthbsIab7zFEF
         M7gRa6MEGFyVJFEG1U4bllz2EApLdCuWqsDUMtzwJFrc1edd4E3MHfQqPL4ekZM4D2yr
         RbNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Mu4z0K7hpkoqgqdclRigMyBEeZ29kUN9ssnH5fqcZQE=;
        b=5I6ZhO/N4bZ9oDub7gLT2uvxDKjL6Oo5W9NubfMC7wwYO5oB4r1A/Vv6NoTnFbZ7KK
         a+vID2KsQmZrJi3PUEfdRBYuNjn8o1WJgj4R/wuOWg9PaE7XFirKDqohI9CiIC3/OB7o
         qqZYJYdeXIZsRtgN/whHEVZPWJ5sORblFI4XJPUwvjSJXJa3PzPnhlbPSZuHcqkErMo/
         /OrIHGTYD1SBePPHf4Tm7Jbyr7ua2biOaw2a9O0J5Lhi8zSJcG0emja70v+Pf816YM2G
         Lg4Kfv8Hpr8lvqs7Y8EfnVbZYHo3sxtO2gBrvRGqtfEF5yJa9L+3lbNeKYt9vKb7euCD
         M/YA==
X-Gm-Message-State: AOAM533m0+KT8SuyTHRtQKshk+H9wRlGccEjbVrE1sKHeRpp4mrjquRm
        8AtqGjkHZroUaK1zJhxuGHQltdgzj9tD8/Ss6lI=
X-Google-Smtp-Source: ABdhPJxniBBE21IeoTMgoTBrcESN6g7gi+58JU8+E9kbQCJgIPd2apd2/uF2gNG+3Rjymmguill2210cDjiNCSdlvK4=
X-Received: by 2002:a65:6bd4:0:b0:374:1fe3:e18a with SMTP id
 e20-20020a656bd4000000b003741fe3e18amr16132117pgw.621.1646033221378; Sun, 27
 Feb 2022 23:27:01 -0800 (PST)
MIME-Version: 1.0
References: <20220224103852.311369-1-baymaxhuang@gmail.com>
 <20220225090223.636877-1-baymaxhuang@gmail.com> <c687e1d8-e36a-8f23-342a-22b2a1efb372@gmail.com>
 <CACGkMEtTdvbc1rk6sk=KE7J2L0=R2M-FMxK+DfJDUYMTPbPJGA@mail.gmail.com>
 <CANn89iKLhhwGnmEyfZuEKjtt7OwTbVyDYcFUMDYoRpdXjbMwiA@mail.gmail.com> <CACGkMEuWLQ6fGXiew_1WGuLYsxEkT+vFequHpZW1KvH=3wcF-w@mail.gmail.com>
In-Reply-To: <CACGkMEuWLQ6fGXiew_1WGuLYsxEkT+vFequHpZW1KvH=3wcF-w@mail.gmail.com>
From:   Harold Huang <baymaxhuang@gmail.com>
Date:   Mon, 28 Feb 2022 15:26:50 +0800
Message-ID: <CAHJXk3ahNPvniu8MKa2PNqin7ZxwRgrr7TbTftnpxMapxAtvNQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2] tun: support NAPI for packets received from
 batched XDP buffs
To:     Jason Wang <jasowang@redhat.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:XDP (eXpress Data Path)" <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for the suggestions.

On Mon, Feb 28, 2022 at 1:17 PM Jason Wang <jasowang@redhat.com> wrote:
>
> On Mon, Feb 28, 2022 at 12:59 PM Eric Dumazet <edumazet@google.com> wrote:
> >
> >
> >
> > On Sun, Feb 27, 2022 at 8:20 PM Jason Wang <jasowang@redhat.com> wrote:
> >>
> >> On Mon, Feb 28, 2022 at 12:06 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >>
> >> > How big n can be ?
> >> >
> >> > BTW I could not find where m->msg_controllen was checked in tun_sendmsg().
> >> >
> >> > struct tun_msg_ctl *ctl = m->msg_control;
> >> >
> >> > if (ctl && (ctl->type == TUN_MSG_PTR)) {
> >> >
> >> >      int n = ctl->num;  // can be set to values in [0..65535]
> >> >
> >> >      for (i = 0; i < n; i++) {
> >> >
> >> >          xdp = &((struct xdp_buff *)ctl->ptr)[i];
> >> >
> >> >
> >> > I really do not understand how we prevent malicious user space from
> >> > crashing the kernel.
> >>
> >> It looks to me the only user for this is vhost-net which limits it to
> >> 64, userspace can't use sendmsg() directly on tap.
> >>
> >
> > Ah right, thanks for the clarification.
> >
> > (IMO, either remove the "msg.msg_controllen = sizeof(ctl);" from handle_tx_zerocopy(), or add sanity checks in tun_sendmsg())
> >
> >
>
> Right, Harold, want to do that?

I am greatly willing to do that. But  I am not quite sure about this.

If we remove the "msg.msg_controllen = sizeof(ctl);" from
handle_tx_zerocopy(), it seems msg.msg_controllen is always 0. What
does it stands for?

I see tap_sendmsg in drivers/net/tap.c also uses msg_controller to
send batched xdp buffers. Do we need to add similar sanity checks to
tap_sendmsg  as tun_sendmsg?
