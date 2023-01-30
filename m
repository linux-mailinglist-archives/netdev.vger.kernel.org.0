Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C296D681631
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 17:18:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236112AbjA3QS0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 11:18:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236783AbjA3QSS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 11:18:18 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62EA61D90C;
        Mon, 30 Jan 2023 08:18:11 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id 7so7978775pga.1;
        Mon, 30 Jan 2023 08:18:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bZKTm1Tzj27L3hS8NppCLb/m/+R50S5HSNpr2qtjPLI=;
        b=iN1M2b4dVXrO2mpm5RLA5O8ECHYQxN6uAVkk6o2CKHceF2LxsU+zEMjY25XYfuSdtM
         +FOI1p5QFjok2PBoGk+3k9H0zBNvQ+EtnaX4M+2inuTKmPfcnbl7aDIDPp9s99sMQioe
         Vaff49cFzec1aGC2b2Vsu05xPdWj65t9i0REBAoW3oJmLc3d+4mdxPeQkROAq6JLKoBL
         eu+XR9E9haPAeCohqMzxBZ5GSn/M0AHEVCE0YEOASqvMzTrF3Z9UiPwXl1Fdk7fOZkyv
         0BzTsUHTqlSjQQbItfZbMoRboc5VEZp/IuiIgwVo/n8PZVdmvYLBk+Aqdo/phybUNkAA
         KMcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bZKTm1Tzj27L3hS8NppCLb/m/+R50S5HSNpr2qtjPLI=;
        b=nUhR9I+vhOYxw6sTuqxUDlmUmQkLl7hDvtRWEU1+6WNvceAUuP8wKbxp/Dh/gYAbMk
         K7QZpQXiJksFBZGXLF2aDqJXX0TGgMYIVMsBexafbNkA4h4b0JOAo4w/skjbZaumC6bK
         ZtpCuoYw1huI5hoys0vdE2S2m7x4ZzyZPixCMxQB+j3hQQ6nn8uCuT5XTc4s9gedDftf
         oCXz/IWxYNdoPnLC6l1967US43vMvuayHBnnJ1YRlVbEIaBvecUpz/kI7cRvy7T/LWCi
         wzisfQi/0BJUdPsPjfJZXhVPLKHooxC1bQ858KkfDG/yt9MuuxFHgUqN+HGESM9bZObu
         Q+Rw==
X-Gm-Message-State: AO0yUKWI+WHI6z4aHglO3RVE3P/HjGcQ10gZtWQF69JkjdGI9zYOCaSA
        U8MKtsnhs7LlV/tlMC59K66EDXJM2Zz51ZeOe3yG7PqL
X-Google-Smtp-Source: AK7set8X/O9viI2jsP+l4chl6RihdbxH/dJjUTf2DKoaVq88gsv3M14MIRTg8aMOblyyA2Omynh0M9bjhlaKr+r9r/k=
X-Received: by 2002:a62:830d:0:b0:592:7c9a:1236 with SMTP id
 h13-20020a62830d000000b005927c9a1236mr2099629pfe.26.1675095490680; Mon, 30
 Jan 2023 08:18:10 -0800 (PST)
MIME-Version: 1.0
References: <04e27096-9ace-07eb-aa51-1663714a586d@nbd.name>
 <167475990764.1934330.11960904198087757911.stgit@localhost.localdomain>
 <cde24ed8-1852-ce93-69f3-ff378731f52c@huawei.com> <20230127212646.4cfeb475@kernel.org>
 <CANn89iKgZU4Q+THXupzZi4hETuKuCOvOB=iHpp5JzQTNv_Fg_A@mail.gmail.com> <ec534eacabf5c859930eb5ca7f417f7f01197d24.camel@redhat.com>
In-Reply-To: <ec534eacabf5c859930eb5ca7f417f7f01197d24.camel@redhat.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 30 Jan 2023 08:17:58 -0800
Message-ID: <CAKgT0UcwrQ21F2mgaLK2ruWUsRbiuSd=T=V=e1P4GUpAfbxPgQ@mail.gmail.com>
Subject: Re: [net PATCH] skb: Do mix page pool and page referenced frags in GRO
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Yunsheng Lin <linyunsheng@huawei.com>, nbd@nbd.name,
        davem@davemloft.net, hawk@kernel.org, ilias.apalodimas@linaro.org,
        linux-kernel@vger.kernel.org, lorenzo@kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 12:50 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Sat, 2023-01-28 at 08:08 +0100, Eric Dumazet wrote:
> > On Sat, Jan 28, 2023 at 6:26 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > >
> > > On Sat, 28 Jan 2023 10:37:47 +0800 Yunsheng Lin wrote:
> > > > If we are not allowing gro for the above case, setting NAPI_GRO_CB(p)->flush
> > > > to 1 in gro_list_prepare() seems to be making more sense so that the above
> > > > case has the same handling as skb_has_frag_list() handling?
> > > > https://elixir.bootlin.com/linux/v6.2-rc4/source/net/core/gro.c#L503
> > > >
> > > > As it seems to avoid some unnecessary operation according to comment
> > > > in tcp4_gro_receive():
> > > > https://elixir.bootlin.com/linux/v6.2-rc4/source/net/ipv4/tcp_offload.c#L322
> > >
> > > The frag_list case can be determined with just the input skb.
> > > For pp_recycle we need to compare input skb's pp_recycle with
> > > the pp_recycle of the skb already held by GRO.
> > >
> > > I'll hold off with applying a bit longer tho, in case Eric
> > > wants to chime in with an ack or opinion.
> >
> > We can say that we are adding in the fast path an expensive check
> > about an unlikely condition.
> >
> > GRO is by far the most expensive component in our stack.
>
> Slightly related to the above: currently the GRO engine performs the
> skb metadata check for every packet. My understanding is that even with
> XDP enabled and ebpf running on the given packet, the skb should
> usually have meta_len == 0.
>
> What about setting 'skb->slow_gro' together with meta_len and moving
> the skb_metadata_differs() check under the slow_gro guard?

Makes sense to me, especially since we have to do a pointer chase to
get the metadata length out of the shared info.

Looking at the code one thing I was wondering about is if we should be
flagging frames where one is slow_gro and one is not as having a diff
and just skipping the checks since we know the slow_gro checks are
expensive and if they differ based on that flag odds are one will have
a field present that the other doesn't.
