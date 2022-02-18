Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B90E24BAFD7
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 03:47:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbiBRCr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 21:47:59 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:56194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231656AbiBRCr6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 21:47:58 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D830A8C4A7;
        Thu, 17 Feb 2022 18:47:42 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id z22so13020501edd.1;
        Thu, 17 Feb 2022 18:47:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y+eglLVKvKLb5vbfZyFXqBl8wTaLxqW6mXZi4E/J4jQ=;
        b=i8q7FbaPNB2NsnqfkxHkTkqF/mEwdeY8N6woUAoNdQ42GIRfHEsJSEq2f5wc/15/Xf
         n5bae1GGXme0nvGkhf/WSIBCKsL+SJltMubfeRdJqKom/UjStl1wAc0MU7G/jxQacdAm
         57rsd36Iz2E1QJT9gXHTY4yPRM9vcvlC/LegFjwVGVlxab23W3msksTCqodg8vDTmpP8
         H6RPHyp9w8VFI+oaTVMXfFaxUy2oacLutIPNdYb5ir8XUi6f5MFy5B2psn+dtUBQ+Dof
         Pp27Cb3uMb3iIw2v80rv29VcajWlZ50mlQp9A1DdG/FX2Z4PZCPCCU3TD+AkyTv9C0ra
         /gwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y+eglLVKvKLb5vbfZyFXqBl8wTaLxqW6mXZi4E/J4jQ=;
        b=oz0rziia6R9vqa1bK3VrPF37uJhjwYrAP5poLbtU7jE6zQBVhxtQJL8BpXVn2aJhnL
         e0pVflKm9IElRZrGXJkcLuwsDzYs+9EvGnKN5EIm8JzhbKDIXDt4LuLvijssIlIEo0F5
         M+7AmOz0ITfz5anHRgRXr/vIZsQpYh5v6xSyQIkiszCds67zVzTaOFH3LCpczOpFQUNs
         c3ky8izw2de1iItgCoyRh6gmTzWljBUqtiZGxEuNdVrkCfM6LxqreGj97wBIrStcAWSF
         6i8zpdzwCCQPW3MD4MbXw5ybki/eA4jfP5Nb3aUkM7lsIvg1QcyRLLX7L5aCYRa4u10M
         vytQ==
X-Gm-Message-State: AOAM531W3BQk7BI6lDz7SP2kM4A54zFJk9gEw/B6eKqBhhf4zs3BCsY6
        uVitpN3RH8PEK/tDD8FOjAXBuc6EK8naHlr4r8M=
X-Google-Smtp-Source: ABdhPJxk0CUtY6z+ZmPVXhx9zgi6FvKxdgQTNU7/h4QPNsuCmHrtfU/MH1HgzeubfrN1sOKIn6Qos1RAdBKjk0yGtOU=
X-Received: by 2002:aa7:d7c8:0:b0:3f9:3b65:f2b3 with SMTP id
 e8-20020aa7d7c8000000b003f93b65f2b3mr5758027eds.389.1645152461319; Thu, 17
 Feb 2022 18:47:41 -0800 (PST)
MIME-Version: 1.0
References: <20220216035426.2233808-1-imagedong@tencent.com> <CANn89i+gBxse3zf2gSvm5AU3D_2MSztGArKQxF4B2rTpWNUSwA@mail.gmail.com>
In-Reply-To: <CANn89i+gBxse3zf2gSvm5AU3D_2MSztGArKQxF4B2rTpWNUSwA@mail.gmail.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Fri, 18 Feb 2022 10:42:27 +0800
Message-ID: <CADxym3Y-AV6HVyqD0jGj9va-mqDuFK5wDurAeQQXN8tv2C81+g@mail.gmail.com>
Subject: Re: [PATCH net-next 0/9] net: add skb drop reasons to TCP packet receive
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Menglong Dong <imagedong@tencent.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kees Cook <keescook@chromium.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Antoine Tenart <atenart@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Yajun Deng <yajun.deng@linux.dev>,
        Roopa Prabhu <roopa@nvidia.com>,
        Willem de Bruijn <willemb@google.com>,
        Vasily Averin <vvs@virtuozzo.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        flyingpeng@tencent.com
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

On Thu, Feb 17, 2022 at 1:05 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Tue, Feb 15, 2022 at 7:54 PM <menglong8.dong@gmail.com> wrote:
> >
> > From: Menglong Dong <imagedong@tencent.com>
> >
> > In this series patches, reasons for skb drops are added to TCP layer, and
> > both TCPv4 and TCPv6 are considered.
> >
> > in this series patches, the process of packet ingress in TCP layer is
> > considered, as skb drops hardly happens in the egress path.
> >
> > However, it's a little complex for TCP state processing, as I find that
> > it's hard to report skb drop reasons to where it is freed. For example,
> > when skb is dropped in tcp_rcv_state_process(), the reason can be caused
> > by the call of tcp_v4_conn_request(), and it's hard to return a drop
> > reason from tcp_v4_conn_request(). So I just skip such case for this
> > moment.
> >
>
> I think you should add at least in this cover letter, or better in a
> document that can be amended,
> how this can be used on a typical TCP session.
> For someone who is having issues with TCP flows, what would they need to do.
> Think of something that we (kernel dev) could copy paste to future
> email replies.
> It might be mostly clear for some of us reviewing patches at this
> moment, but in one year we will all forget about the details.
>

Yeah, this cover letter seems too simple to explain what we
are doing.

I'll describe in detail what this series patches do and how
they can be used in the cover letter, and give some examples.


Thanks!
Menglong Dong
>
> >
> > Menglong Dong (9):
> >   net: tcp: introduce tcp_drop_reason()
> >   net: tcp: add skb drop reasons to tcp_v4_rcv()
> >   net: tcp: use kfree_skb_reason() for tcp_v6_rcv()
> >   net: tcp: add skb drop reasons to tcp_v{4,6}_inbound_md5_hash()
> >   net: tcp: add skb drop reasons to tcp_add_backlog()
> >   net: tcp: use kfree_skb_reason() for tcp_v{4,6}_do_rcv()
> >   net: tcp: use tcp_drop_reason() for tcp_rcv_established()
> >   net: tcp: use tcp_drop_reason() for tcp_data_queue()
> >   net: tcp: use tcp_drop_reason() for tcp_data_queue_ofo()
> >
> >  include/linux/skbuff.h     | 28 +++++++++++++++++++++++++
> >  include/net/tcp.h          |  3 ++-
> >  include/trace/events/skb.h | 10 +++++++++
> >  net/ipv4/tcp_input.c       | 42 +++++++++++++++++++++++++++++---------
> >  net/ipv4/tcp_ipv4.c        | 36 ++++++++++++++++++++++++--------
> >  net/ipv6/tcp_ipv6.c        | 42 +++++++++++++++++++++++++++++---------
> >  6 files changed, 131 insertions(+), 30 deletions(-)
> >
> > --
> > 2.34.1
> >
