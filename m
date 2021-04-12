Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6DB35D0D7
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 21:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237076AbhDLTJm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 15:09:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236840AbhDLTJl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 15:09:41 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BA78C061574;
        Mon, 12 Apr 2021 12:09:22 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id k23-20020a17090a5917b02901043e35ad4aso9383479pji.3;
        Mon, 12 Apr 2021 12:09:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sWgLn2JGRyoredsarp01qbq8Mqssjb96ufuWA8XbIcw=;
        b=UpuKH29d1SX5ZDd3xcI0M6TQgIgYgbQigjP2nS9TZ/GhRoMiGO9iF9idM9YfyGpLmk
         jMcYnMtW05u5giRgoramTUTK6WVh3FTBRUBZEIWgnn7H3Q35CRKD+k1TaujV2A7JNkS7
         Kjbect4dhtA9xdsGaF2R6COx4qu/Jv11JPfWBxNA9Cjg+Ow/AjeBZ1TwSt5hyYUW8L+R
         zIKCVFGyMTd6jIUJHRbd2vglNDwFILdNev8KOVmkDGUqxxvfR1e91SluuBI/yFenGhK/
         F1qm9OARSywndXYn9uJL+S05pMp7oxoWCBJaJ1n5aqnCun1rZKQMMnOoFdk37bKPCUBb
         ehqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sWgLn2JGRyoredsarp01qbq8Mqssjb96ufuWA8XbIcw=;
        b=uJOima4tEOM9OMYcB+hyaZM26j3m6hLw1B2sD0eVEJYlnC/v979Ea6SDZH3WWivquf
         LdW39Ew2kbo8Q02HIq0MpxScDJX80eAUkspdVAwrudxOS9ApHx7oAFbEd5DD540b24MA
         JqPGgm37UtPp0PZj1Yh59o5WJcKsbCtXSUKp3kO0UCchLR8rA/nUov1/x/XnC4FC9mp/
         feLnpc1QxWAv00qgyDiL2oKZPdLddhIc5z5PbH84tCeZ0/ahK2jqzuMs8M4JqugPxrqQ
         5Ml8ZxL6HveRibqNuFqBNa+HvVLuT6ufS1qOmpkA+HhsgPOmQArNi52YMpPDVcJVvPRb
         IW0A==
X-Gm-Message-State: AOAM531wx9yqJDHhCmwYy/BNFVXt/6jOr4shAGc7KVJtyh1+YT0/bA1D
        Zcyub8Ytu9Wun/PHBf+6RA99A63BlcBrT6POfII=
X-Google-Smtp-Source: ABdhPJxx/l6NtI3DIslKikjWGnheLGGl+TvdJEB7El584+I7ny9rWB9Ph7TNzONGum1tXK67Ayg9vYoj5gEQihk4qUo=
X-Received: by 2002:a17:90a:2bcd:: with SMTP id n13mr684477pje.145.1618254561857;
 Mon, 12 Apr 2021 12:09:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210410181732.25995-1-xiyou.wangcong@gmail.com> <f273fcd6-05e2-68d4-56e3-31cd228fab23@linux.ibm.com>
In-Reply-To: <f273fcd6-05e2-68d4-56e3-31cd228fab23@linux.ibm.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 12 Apr 2021 12:09:10 -0700
Message-ID: <CAM_iQpVbDm-P6czt+8m_79w78L0czdN-nk5JzvrBpUR=C09Bcw@mail.gmail.com>
Subject: Re: [Patch net] smc: disallow TCP_ULP in smc_setsockopt()
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        linux-s390@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        syzbot <syzbot+b54a1ce86ba4a623b7f0@syzkaller.appspotmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 11, 2021 at 11:52 PM Karsten Graul <kgraul@linux.ibm.com> wrote:
>
>
>
> On 10/04/2021 20:17, Cong Wang wrote:
> > From: Cong Wang <cong.wang@bytedance.com>
> >
> > syzbot is able to setup kTLS on an SMC socket, which coincidentally
> > uses sk_user_data too, later, kTLS treats it as psock so triggers a
> > refcnt warning. The cause is that smc_setsockopt() simply calls
> > TCP setsockopt(). I do not think it makes sense to setup kTLS on
> > top of SMC, so we can just disallow this.
> >
> > Reported-and-tested-by: syzbot+b54a1ce86ba4a623b7f0@syzkaller.appspotmail.com
> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Cc: Karsten Graul <kgraul@linux.ibm.com>
> > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > ---
> >  net/smc/af_smc.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
> > index 47340b3b514f..0d4d6d28f20c 100644
> > --- a/net/smc/af_smc.c
> > +++ b/net/smc/af_smc.c
> > @@ -2162,6 +2162,9 @@ static int smc_setsockopt(struct socket *sock, int level, int optname,
> >       struct smc_sock *smc;
> >       int val, rc;
> >
> > +     if (optname == TCP_ULP)
> > +             return -EOPNOTSUPP;
> > +
> >       smc = smc_sk(sk);
> >
> >       /* generic setsockopts reaching us here always apply to the
> > @@ -2186,7 +2189,6 @@ static int smc_setsockopt(struct socket *sock, int level, int optname,
> >       if (rc || smc->use_fallback)
> >               goto out;
> >       switch (optname) {
> > -     case TCP_ULP:
>
> Should'nt it return -EOPNOTSUPP in that case, too?

I do not think I understand this. In case of TCP_ULP, we will
not even reach this switch case after my patch.

Thanks.
