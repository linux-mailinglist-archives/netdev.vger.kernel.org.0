Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0029B35768B
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 23:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232017AbhDGVRM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 17:17:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbhDGVRI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 17:17:08 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73030C061760;
        Wed,  7 Apr 2021 14:16:58 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id n12so250114ybf.8;
        Wed, 07 Apr 2021 14:16:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3O1UY45/jWO/BQZWJoj52TQjaRoRPI7XxTD27HudHmQ=;
        b=icwGjw1OD0LnP09NN6vVmx5HYkxTM8IMdOPHZYcxyyuC9bb3I0N20RzdBPnsbptuwZ
         TjTR8JuUZQI1Z7t5flMqu1FF8SZJbdoj3dnP4fDLG2sCzncQNczlmugjiwG3NjsAzP5c
         On4NWF85O2j0vUH3cwmOZYYyp5GI5x67AY6VaD5b3p6npgFTv8Xh5nV6ivf62VS7E4dp
         FMrhsWu0ZDc/nimY783MvtkuS/yiXWIrPYgiMQ2hGfX6pmRJz4QW0z0z1fhqethpjQ/X
         DeTXJQ5fSEoLyICs7W69FI3J/L+i4GJEE3+oZdgTLeo8ljButapPk3a2zNIindfXbf5s
         onww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3O1UY45/jWO/BQZWJoj52TQjaRoRPI7XxTD27HudHmQ=;
        b=Y6vIuOs6CLXYFQikup3vZRuHfwkc9nOtByRu+0hCj4Hk1XPmhKZoQFRWGDnhl4MSbB
         TnoXhuUolERF+1piBjIV3/e6RYqH5sOmuvPpIxcx/xkcOV3dQfRGabi8bYk1+dgcjiL5
         /ZP1QVke+wlz7Q2lc3cH6eemR3hSx7IzldIFsS/jfzSwYbXEEIdxbjCwIqUgyWKMcTNe
         jo4v1Mo6TkGataDC1uiIdF385eQGwr2DDW1ME64uV4Zog2JQ3VAOcsVc2nl/dZT0D+Vb
         fDgJ8UFIF8GLSnDTtekcjWJu643kAX2xBQel+9jCwZGvAn8lc8nO4EyPQqGNoRh3qz8g
         tJvQ==
X-Gm-Message-State: AOAM530ihiddrIkcUIuSokXGizUUPZUL+z00dFPPN1agWyC6FKjPe2oq
        N6Zy6zX2HZus/LIw+66cnBH2YaGDClPTtKbxvFs=
X-Google-Smtp-Source: ABdhPJxXO4Mu/o54Xpk7t60PBmspEOIMbelwxz0OhBrLE+ZvykEXC5MwQM5SwiXs8eDRg5TziHNyjKk11lcsWYPOagI=
X-Received: by 2002:a25:d87:: with SMTP id 129mr7291662ybn.260.1617830217744;
 Wed, 07 Apr 2021 14:16:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210406185806.377576-1-pctammela@mojatatu.com>
 <CAOftzPgmZSB7oWDLLoO-NEDq3s8LdLxSXdhoaB2feScuTP-JSA@mail.gmail.com>
 <CAEf4BzaBJH-=iO-P6ZTj3zmycz0VESzBzpZkbVOVTvPaZ9OEaA@mail.gmail.com> <CAKY_9u0KV0dW2_xW9g67r9YWAh9UjVpTAsEVWs3xF2htzzVAYQ@mail.gmail.com>
In-Reply-To: <CAKY_9u0KV0dW2_xW9g67r9YWAh9UjVpTAsEVWs3xF2htzzVAYQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 7 Apr 2021 14:16:46 -0700
Message-ID: <CAEf4BzbUC9JxhD9cpRX6C0oY2GgkEQMQsniv=AixF63TgNcSsQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: clarify flags in ringbuf helpers
To:     Pedro Tammela <pctammela@gmail.com>
Cc:     Joe Stringer <joe@cilium.io>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>,
        Pedro Tammela <pctammela@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 7, 2021 at 1:10 PM Pedro Tammela <pctammela@gmail.com> wrote:
>
> Em qua., 7 de abr. de 2021 =C3=A0s 16:58, Andrii Nakryiko
> <andrii.nakryiko@gmail.com> escreveu:
> >
> > On Wed, Apr 7, 2021 at 11:43 AM Joe Stringer <joe@cilium.io> wrote:
> > >
> > > Hi Pedro,
> > >
> > > On Tue, Apr 6, 2021 at 11:58 AM Pedro Tammela <pctammela@gmail.com> w=
rote:
> > > >
> > > > In 'bpf_ringbuf_reserve()' we require the flag to '0' at the moment=
.
> > > >
> > > > For 'bpf_ringbuf_{discard,submit,output}' a flag of '0' might send =
a
> > > > notification to the process if needed.
> > > >
> > > > Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> > > > ---
> > > >  include/uapi/linux/bpf.h       | 7 +++++++
> > > >  tools/include/uapi/linux/bpf.h | 7 +++++++
> > > >  2 files changed, 14 insertions(+)
> > > >
> > > > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > > > index 49371eba98ba..8c5c7a893b87 100644
> > > > --- a/include/uapi/linux/bpf.h
> > > > +++ b/include/uapi/linux/bpf.h
> > > > @@ -4061,12 +4061,15 @@ union bpf_attr {
> > > >   *             of new data availability is sent.
> > > >   *             If **BPF_RB_FORCE_WAKEUP** is specified in *flags*,=
 notification
> > > >   *             of new data availability is sent unconditionally.
> > > > + *             If **0** is specified in *flags*, notification
> > > > + *             of new data availability is sent if needed.
> > >
> > > Maybe a trivial question, but what does "if needed" mean? Does that
> > > mean "when the buffer is full"?
> >
> > I used to call it ns "adaptive notification", so maybe let's use that
> > term instead of "if needed"? It means that in kernel BPF ringbuf code
> > will check if the user-space consumer has caught up and consumed all
> > the available data. In that case user-space might be waiting
> > (sleeping) in epoll_wait() already and not processing samples
> > actively. That means that we have to send notification, otherwise
> > user-space might never wake up. But if the kernel sees that user-space
> > is still processing previous record (consumer position < producer
> > position), then we can bypass sending another notification, because
> > user-space consumer protocol dictates that it needs to consume all the
> > record until consumer position =3D=3D producer position. So no
> > notification is necessary for the newly submitted sample, as
> > user-space will eventually see it without notification.
> >
> > Of course there is careful writes and memory ordering involved to make
> > sure that we never miss notification.
> >
> > Does someone want to try to condense it into a succinct description? ;)
>
> OK.
>
> I can try to condense this and perhaps add it as code in the comment?

Sure, though there is already a brief comment to that effect. But
having high-level explanation in uapi/linux/bpf.h would be great for
users, though.
