Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21FE44C6263
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 06:17:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233040AbiB1FSQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 00:18:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbiB1FSP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 00:18:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 096D12982B
        for <netdev@vger.kernel.org>; Sun, 27 Feb 2022 21:17:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646025457;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qsxc2s292NsRQ4hzwanA8m9ycoHJFMMtSw79mLbnNdE=;
        b=UObONYEQYdCVxKHA11OaBuo5CFL6IpX0AW0kcT2RJcfpvyOAolx9fCGshmUQkKTrjsovM+
        mTyalHtmtm89fXcSUcOyosoF53MlLOPfgDekv0n0iCvIQGJcPcDMC+iTRnPGy6gYfsVurx
        k9sH/0XUEQBrIu6oUoS7PLuE+aLuCX4=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-240-YTC4_tK-OKmgRVLL6-nupQ-1; Mon, 28 Feb 2022 00:17:35 -0500
X-MC-Unique: YTC4_tK-OKmgRVLL6-nupQ-1
Received: by mail-lf1-f70.google.com with SMTP id a5-20020ac25205000000b00443a34a9472so1475625lfl.15
        for <netdev@vger.kernel.org>; Sun, 27 Feb 2022 21:17:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qsxc2s292NsRQ4hzwanA8m9ycoHJFMMtSw79mLbnNdE=;
        b=2MiSe1B1lv2UnivU0vvCxdov8Ekz8qj2tInskaKL/wz44IgCKncG/peluobiS8Ni0r
         oadTrgr6bd5pLiKLiJ5D5kWcV+/kFV6lTXlcEnO6URDDVJ0qLVjPuvQgKPTTmaFZDM6Z
         bxIE6yZSvtxnbQg5rXv6dKIzZN/9b66X9V1TE2ptcT2s1dVn69KpTCJOCkDhmEw9pwaC
         yeIgXwMUx8vlZRRKPs65KHB+cjJhavhS3k0opQqHCkGMDMsOIqNdFAibB5JSYtHA38eC
         s8kDkAi0w/UXboHzRbZxrPKQzibe9/4vp3TpNOSsNXMYFjMN7tDTAe3SQiKL2PaYJYuG
         k2yg==
X-Gm-Message-State: AOAM530RlutRdGV5x63q1PKehA7N43FezNzLyXb5oVFeBIeH3JSJh6Oi
        kcaVoiAO92UZRKDx08CIfBDg1UNJyzXkqyNKxMPX9WTJQVIbGCcbb6mTwKfqSOt7nP6FRMaG9Tq
        1inOFDpDjslmxoImRkH1QLmrQLkyA9D/C
X-Received: by 2002:ac2:4da1:0:b0:438:74be:5a88 with SMTP id h1-20020ac24da1000000b0043874be5a88mr11252855lfe.210.1646025453509;
        Sun, 27 Feb 2022 21:17:33 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwtKdDAsYdevYlXM4KkIBT28shP4GL11Q2MrukJc3at1rmEfn7iLM6V1nQQyjtFS2b6NVGWoHh9y1pwXlQ0pNA=
X-Received: by 2002:ac2:4da1:0:b0:438:74be:5a88 with SMTP id
 h1-20020ac24da1000000b0043874be5a88mr11252849lfe.210.1646025453345; Sun, 27
 Feb 2022 21:17:33 -0800 (PST)
MIME-Version: 1.0
References: <20220224103852.311369-1-baymaxhuang@gmail.com>
 <20220225090223.636877-1-baymaxhuang@gmail.com> <c687e1d8-e36a-8f23-342a-22b2a1efb372@gmail.com>
 <CACGkMEtTdvbc1rk6sk=KE7J2L0=R2M-FMxK+DfJDUYMTPbPJGA@mail.gmail.com> <CANn89iKLhhwGnmEyfZuEKjtt7OwTbVyDYcFUMDYoRpdXjbMwiA@mail.gmail.com>
In-Reply-To: <CANn89iKLhhwGnmEyfZuEKjtt7OwTbVyDYcFUMDYoRpdXjbMwiA@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 28 Feb 2022 13:17:22 +0800
Message-ID: <CACGkMEuWLQ6fGXiew_1WGuLYsxEkT+vFequHpZW1KvH=3wcF-w@mail.gmail.com>
Subject: Re: [PATCH net-next v2] tun: support NAPI for packets received from
 batched XDP buffs
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Harold Huang <baymaxhuang@gmail.com>,
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
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 28, 2022 at 12:59 PM Eric Dumazet <edumazet@google.com> wrote:
>
>
>
> On Sun, Feb 27, 2022 at 8:20 PM Jason Wang <jasowang@redhat.com> wrote:
>>
>> On Mon, Feb 28, 2022 at 12:06 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>
>> > How big n can be ?
>> >
>> > BTW I could not find where m->msg_controllen was checked in tun_sendmsg().
>> >
>> > struct tun_msg_ctl *ctl = m->msg_control;
>> >
>> > if (ctl && (ctl->type == TUN_MSG_PTR)) {
>> >
>> >      int n = ctl->num;  // can be set to values in [0..65535]
>> >
>> >      for (i = 0; i < n; i++) {
>> >
>> >          xdp = &((struct xdp_buff *)ctl->ptr)[i];
>> >
>> >
>> > I really do not understand how we prevent malicious user space from
>> > crashing the kernel.
>>
>> It looks to me the only user for this is vhost-net which limits it to
>> 64, userspace can't use sendmsg() directly on tap.
>>
>
> Ah right, thanks for the clarification.
>
> (IMO, either remove the "msg.msg_controllen = sizeof(ctl);" from handle_tx_zerocopy(), or add sanity checks in tun_sendmsg())
>
>

Right, Harold, want to do that?

Thanks

