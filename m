Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 243AA4C6427
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 08:56:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233757AbiB1H5a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 02:57:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233741AbiB1H53 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 02:57:29 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E39974614D
        for <netdev@vger.kernel.org>; Sun, 27 Feb 2022 23:56:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646035010;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WpShLimVwkmYIyb4Sx/D5oN6uinq/tsyvea/tNkwado=;
        b=Rj5PlJ5bD84sN5MQNxdKIvElKamnWFEZzZbHZ8Di8zzPzFgooWIfibo8XLd527E4QPp+W1
        MziLl74llJGlRdic1e4BBKofVVwY0kX+obI/uhWpQh7N+BjxHtwy58s4XEGtbPUoFcVnpp
        2asn5IazB/UxMLXQY5J1RmDOsdyHyrg=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-278-M_aUAvBoOYGJzVU07YSSSA-1; Mon, 28 Feb 2022 02:56:48 -0500
X-MC-Unique: M_aUAvBoOYGJzVU07YSSSA-1
Received: by mail-lf1-f69.google.com with SMTP id r14-20020ac252ae000000b00443987dc996so1532422lfm.19
        for <netdev@vger.kernel.org>; Sun, 27 Feb 2022 23:56:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WpShLimVwkmYIyb4Sx/D5oN6uinq/tsyvea/tNkwado=;
        b=11eeve7Bz5Q+YSlhV2IESv3QFLqLQhqLfwQHKYdYDuovd7xngJqWp7l/OKwSc+mlHr
         ODDYwNB8wbq4DHRrJB2qPF3z95n0WZLUFH8jL86KjoDGm9+k6jNvQ4fCPq3oP9WpoEMZ
         AkgptDfoAXuDvffQtF16mG8PGDNMInsa3cktWC5uOE5SQtYW2o3OAB3ck8B5pIuwS33D
         ihZb+/Wggoi7gjMJc3tYmNHtXy1eghtzws2xmor/x7hl5svicL0tf8D7pNv0Ef/RS46G
         TBUaxTk1TDvdc4RBoop9xzPtQbL1zZBIwtH1FxKU/nytHWhqNS+5dtSc9uVw64owXe89
         Fngg==
X-Gm-Message-State: AOAM5313T0ueKEPhL4Jjy9Ha/H/gSujb34yrHq0NzDhvMf1bJ3v7CUxo
        tPz2yZcLpRjlv76XEPE7T7uwPmA28CifLeItkID69Se2e71/hJwHWSw3QkPaT7XqgIWJfKPINHc
        4ZNc5v5mDsQgNgMsO8ASpaJKcpwKevRTE
X-Received: by 2002:a05:6512:3d08:b0:43f:8f45:d670 with SMTP id d8-20020a0565123d0800b0043f8f45d670mr12347895lfv.587.1646035007130;
        Sun, 27 Feb 2022 23:56:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzfhHYpKm5FgVHu1Kj0ut0Y1DimEmo470n7GHsQ68BLqiZLCnk3GS34aG6ImJhNzneAlmJSl+Y11Q6OzZguBG8=
X-Received: by 2002:a05:6512:3d08:b0:43f:8f45:d670 with SMTP id
 d8-20020a0565123d0800b0043f8f45d670mr12347870lfv.587.1646035006582; Sun, 27
 Feb 2022 23:56:46 -0800 (PST)
MIME-Version: 1.0
References: <20220224103852.311369-1-baymaxhuang@gmail.com>
 <20220225090223.636877-1-baymaxhuang@gmail.com> <c687e1d8-e36a-8f23-342a-22b2a1efb372@gmail.com>
 <CACGkMEtTdvbc1rk6sk=KE7J2L0=R2M-FMxK+DfJDUYMTPbPJGA@mail.gmail.com>
 <CANn89iKLhhwGnmEyfZuEKjtt7OwTbVyDYcFUMDYoRpdXjbMwiA@mail.gmail.com>
 <CACGkMEuWLQ6fGXiew_1WGuLYsxEkT+vFequHpZW1KvH=3wcF-w@mail.gmail.com> <CAHJXk3ahNPvniu8MKa2PNqin7ZxwRgrr7TbTftnpxMapxAtvNQ@mail.gmail.com>
In-Reply-To: <CAHJXk3ahNPvniu8MKa2PNqin7ZxwRgrr7TbTftnpxMapxAtvNQ@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 28 Feb 2022 15:56:35 +0800
Message-ID: <CACGkMEt_L8-4JasP3dNTEV7mafXc+W0vkr35cAUohz48-ND42g@mail.gmail.com>
Subject: Re: [PATCH net-next v2] tun: support NAPI for packets received from
 batched XDP buffs
To:     Harold Huang <baymaxhuang@gmail.com>
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
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 28, 2022 at 3:27 PM Harold Huang <baymaxhuang@gmail.com> wrote:
>
> Thanks for the suggestions.
>
> On Mon, Feb 28, 2022 at 1:17 PM Jason Wang <jasowang@redhat.com> wrote:
> >
> > On Mon, Feb 28, 2022 at 12:59 PM Eric Dumazet <edumazet@google.com> wrote:
> > >
> > >
> > >
> > > On Sun, Feb 27, 2022 at 8:20 PM Jason Wang <jasowang@redhat.com> wrote:
> > >>
> > >> On Mon, Feb 28, 2022 at 12:06 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > >>
> > >> > How big n can be ?
> > >> >
> > >> > BTW I could not find where m->msg_controllen was checked in tun_sendmsg().
> > >> >
> > >> > struct tun_msg_ctl *ctl = m->msg_control;
> > >> >
> > >> > if (ctl && (ctl->type == TUN_MSG_PTR)) {
> > >> >
> > >> >      int n = ctl->num;  // can be set to values in [0..65535]
> > >> >
> > >> >      for (i = 0; i < n; i++) {
> > >> >
> > >> >          xdp = &((struct xdp_buff *)ctl->ptr)[i];
> > >> >
> > >> >
> > >> > I really do not understand how we prevent malicious user space from
> > >> > crashing the kernel.
> > >>
> > >> It looks to me the only user for this is vhost-net which limits it to
> > >> 64, userspace can't use sendmsg() directly on tap.
> > >>
> > >
> > > Ah right, thanks for the clarification.
> > >
> > > (IMO, either remove the "msg.msg_controllen = sizeof(ctl);" from handle_tx_zerocopy(), or add sanity checks in tun_sendmsg())
> > >
> > >
> >
> > Right, Harold, want to do that?
>
> I am greatly willing to do that. But  I am not quite sure about this.
>
> If we remove the "msg.msg_controllen = sizeof(ctl);" from
> handle_tx_zerocopy(), it seems msg.msg_controllen is always 0. What
> does it stands for?

It means msg_controllen is not used. But see below (adding sanity
check seems to be better).

>
> I see tap_sendmsg in drivers/net/tap.c also uses msg_controller to
> send batched xdp buffers. Do we need to add similar sanity checks to
> tap_sendmsg  as tun_sendmsg?
>

I think the point is to make sure the caller doesn't send us too short
msg_control. E.g the msg_controllen should be sizeof(tun_msg_ctl).

So we probably need to check in both places. (And initialize
msg_controllen is vhost_tx_batch())

Thanks

