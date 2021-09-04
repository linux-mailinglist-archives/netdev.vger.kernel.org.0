Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB1FB4008F8
	for <lists+netdev@lfdr.de>; Sat,  4 Sep 2021 03:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350793AbhIDBb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 21:31:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233140AbhIDBb4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 21:31:56 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA647C061575;
        Fri,  3 Sep 2021 18:30:55 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id j16so851440pfc.2;
        Fri, 03 Sep 2021 18:30:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=T9nVqnPH4oqlBYTSA1YI/mumrnp4x2ABC9Aj2V1+NSI=;
        b=Qw54c3OBanCmKxFIqur2nfa8P3UHNoeHXSjsS1nuX4rOTVPFPZfvDrP7fOLKI/at2+
         F8DAvxRO6ycNmXDyg2TSu/J96yD5sWTRxBSMHmURrEPKXmAeC6/femrKgf2a+SxnnQOm
         P6NyNXg3Wps86Pf1dzijAfwoaKNQLs5AKBG+MTRiJryS954f8Whc1rz436vM/L3Dfew3
         0/ztD66CVbvdlpVAwOhK9oVT0/zqDsH8xsOTTH+To0ynNsBTp1RKoFQ9XLl6qdBr4KoQ
         acEzsurQ86BICM18HJrpu3jeo0x5AhGmctP5hMiFtbFr8gFJbqVdfpWFSaTWwLYH1yna
         g6rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=T9nVqnPH4oqlBYTSA1YI/mumrnp4x2ABC9Aj2V1+NSI=;
        b=taJJccF++AjcE/OGNr6T2hrtmjlpk/jB0jxT35pVw3IWrgmdAVtEIqmtA1yof7tGgg
         hKP3KPKcrFZdrvCjuAOuRVVld+aEnoWChhr6obf9rQJCP4TybO1NH60dyq/lqeiv7+vU
         4rBHTPYhCgCXItP4ZV2Q/sB6OecyGSlTekoySWhe/eewYyi1j6lqdVeI9yYLTvKmKgdq
         B+kRRph+5y4jdGapoitd09zIrR2TxwBgJ9rcRgEGa98x3t6yg1pPTrU1xokvO8F/RM7h
         EFWKRVVbGEfiwZXs4Ee8PVCOs6tQs3ztIuXOEJHZvol4KJsGW6AKtVG38QVcSz5BIblj
         5cNg==
X-Gm-Message-State: AOAM53146XXai6Fx60Nrjwth//OpOKTviI3P5pzC5yElL03JTOumWuSY
        99+3LRAscSvJcEtq88gVivMNYMKPsSEFBCpWxc4=
X-Google-Smtp-Source: ABdhPJwaeAyxwm5z6cX7uj8cBeTabx7xO0NGPpZg1xkywQxXAD0Dbfm9A4EPYy4mZ3IeTUEdDxCxCLrM+XpIwLu51d0=
X-Received: by 2002:a63:4458:: with SMTP id t24mr1572431pgk.218.1630719055338;
 Fri, 03 Sep 2021 18:30:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210821010240.10373-1-xiyou.wangcong@gmail.com>
 <20210824234700.qlteie6al3cldcu5@kafai-mbp> <CAM_iQpWP_kvE58Z+363n+miTQYPYLn6U4sxMKVaDvuRvjJo_Tg@mail.gmail.com>
 <612f137f4dc5c_152fe20891@john-XPS-13-9370.notmuch> <871r68vapw.fsf@toke.dk>
In-Reply-To: <871r68vapw.fsf@toke.dk>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 3 Sep 2021 18:30:44 -0700
Message-ID: <CAM_iQpUhmYBvu7p_jdiYxxPLqMmo3EFfRPfEsciCypUpM58UnQ@mail.gmail.com>
Subject: Re: [RFC Patch net-next] net_sched: introduce eBPF based Qdisc
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 1, 2021 at 3:42 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> John Fastabend <john.fastabend@gmail.com> writes:
>
> > Cong Wang wrote:
> >> On Tue, Aug 24, 2021 at 4:47 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >> > Please explain more on this.  What is currently missing
> >> > to make qdisc in struct_ops possible?
> >>
> >> I think you misunderstand this point. The reason why I avoid it is
> >> _not_ anything is missing, quite oppositely, it is because it requires
> >> a lot of work to implement a Qdisc with struct_ops approach, literally
> >> all those struct Qdisc_ops (not to mention struct Qdisc_class_ops).
> >> WIth current approach, programmers only need to implement two
> >> eBPF programs (enqueue and dequeue).
> >>
> >> Thanks.
> >
> > Another idea. Rather than work with qdisc objects which creates all
> > these issues with how to work with existing interfaces, filters, etc.
> > Why not create an sk_buff map? Then this can be used from the existing
> > egress/ingress hooks independent of the actual qdisc being used.
>
> I agree. In fact, I'm working on doing just this for XDP, and I see no
> reason why the map type couldn't be reused for skbs as well. Doing it
> this way has a couple of benefits:

I do see a lot of reasons, for starters, struct skb_buff is very different
from struct xdp_buff, any specialized map can not be reused. I guess you
are using a generic one, how do you handle the refcnt at least for skb?

>
> - It leaves more flexibility to BPF: want a simple FIFO queue? just
>   implement that with a single queue map. Or do you want to build a full
>   hierarchical queueing structure? Just instantiate as many queue maps
>   as you need to achieve this. Etc.

Please give an example without a queue. ;) Queue is too simple, show us
something more useful please. How do you plan to re-implement EDT with
just queues?

>
> - The behaviour is defined entirely by BPF program behaviour, and does
>   not require setting up a qdisc hierarchy in addition to writing BPF
>   code.

I have no idea why you call this a benefit, because my goal is to replace
Qdisc's, not to replace any other things. You know there are plenty of Qdis=
c's
which are not implemented in Linux kernel.

>
> - It should be possible to structure the hooks in a way that allows
>   reusing queueing algorithm implementations between the qdisc and XDP
>   layers.

XDP has no skb but xdp_buff, no? And again, why only queues?

Thanks.
