Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94EBD57456F
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 09:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233252AbiGNHCd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 03:02:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbiGNHCb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 03:02:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B53202B62E
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 00:02:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657782149;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eS0VUblTyvyPjaGHWwUy449FglqdMS1uxy5l9ypI6Lg=;
        b=chZg0KsL5FYzZoxcDhaYQjIrlYpaw9ID4is1QrqWi0pWnv0MOIRsxIf8LfE/uN4AkDV5EI
        B8XhGkvzi6HX82BQ/13WTkMQtn5UyIYuPZVYCWQxTuE5WPUw3uEAXYYLja+GPxJGn9/Hmr
        Qs4TC4o1fxkX2sGnYgs3L4Jii0f8YV0=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-564-wCWOJ7AxOoC59ie-GY0srg-1; Thu, 14 Jul 2022 03:02:26 -0400
X-MC-Unique: wCWOJ7AxOoC59ie-GY0srg-1
Received: by mail-lj1-f199.google.com with SMTP id r7-20020a2eb607000000b0025d547f19c4so165153ljn.11
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 00:02:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eS0VUblTyvyPjaGHWwUy449FglqdMS1uxy5l9ypI6Lg=;
        b=23zkiyMnQUktzuHR8x8Lmc3rU7fJZLLCQvzp/viQ/iFn5rmgYtUtzK/JnAN+zznVnn
         cclC9OpYcHs2sosn1BHyx1o7ELF9pQx7LzSgxDFrUR3sOo3YgK4C6zTA+P3a+Av5xR5X
         tamG+59430LqxY6cA3LEPpbm6CUjGBoHf7HZf115XS98zTYyW8I9K3qt0dfrhw7u4Mpt
         IOYKUVGvbAH/H+XzB0LIipWLMFPCs2LpT0HATUrGS/ctsul2H8ZxvnCQNtHjRfAuqddH
         MTis+2MkyByQMO7Ly2TQBwvJw8a+uC6a4pP1lujYJLWmLvJ2SzH47dB25MGgk9TUosQ5
         r/VA==
X-Gm-Message-State: AJIora8gkK+VShZCGi+iKOUwlEuSqZX0Zs+uXZso5q7KiQiNJGkZk/Sa
        +fOgjd/ekxmP/wCc3mAha7GGtqwfuZJTadbFCaE8nGR42MP/VsCgYg++NUvdetO3abr2AH1wImx
        CQLXIdxcCUwwsMUmU9dNuTyZjg1zi6e3l
X-Received: by 2002:a2e:2e0d:0:b0:25d:48a6:827d with SMTP id u13-20020a2e2e0d000000b0025d48a6827dmr3810166lju.323.1657782144616;
        Thu, 14 Jul 2022 00:02:24 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vexdEdqSVyxy95vlgi9D2JodNfyO1pHz91P5drUNdW2rin90ALqcpW+1OaCSXq4OCXgxrU4KuVcXBnfNqp6ts=
X-Received: by 2002:a2e:2e0d:0:b0:25d:48a6:827d with SMTP id
 u13-20020a2e2e0d000000b0025d48a6827dmr3810158lju.323.1657782144417; Thu, 14
 Jul 2022 00:02:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220712112210.2852777-1-alvaro.karsz@solid-run.com>
 <20220713200203.4eb3a64e@kernel.org> <55c50d9a-1612-ed2c-55f4-58a5c545b662@redhat.com>
 <CAJs=3_BNvrJo9JCkMhL3G2TBescrLbgeD7eOx=cs+T9YOLTwLg@mail.gmail.com>
In-Reply-To: <CAJs=3_BNvrJo9JCkMhL3G2TBescrLbgeD7eOx=cs+T9YOLTwLg@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 14 Jul 2022 15:02:13 +0800
Message-ID: <CACGkMEtiC1PZTjno3sF8z-_cx=1cb8Kn1kqPvQuurDbKS+UktQ@mail.gmail.com>
Subject: Re: [PATCH v2] net: virtio_net: notifications coalescing support
To:     Alvaro Karsz <alvaro.karsz@solid-run.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev <netdev@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 14, 2022 at 2:54 PM Alvaro Karsz <alvaro.karsz@solid-run.com> wrote:
>
> Thanks Jakub and Jason.
>
> > I think we need to return -EBUSY here regardless whether or not
> > interrupt coalescing is negotiated.
>
>
> The part you are referring to is relevant only if we are going to update NAPI.
> Jakub suggested splitting the function into 2 cases.
>
> If interrupt coalescing is negotiated:
>  Send control commands to the device.
> Otherwise:
>  Update NAPI.
>
> So this is not relevant if interrupt coalescing is negotiated.
> You don't think that we should separate the function into 2 different cases?

So we use sq->napi.weight as a hint to use tx interrupt or not.

We need a safe switching from tx interrupt and skb_orphan(). The
current code guarantees this by only allowing the switching when the
interface is down.

So what I meant for the above "Update NAPI" is, consider that users
want to switch from tx_max_coalesced_frames from 0 to 100. This needs
to be down when the interface is down, since the driver need to enable
tx interrupt mode, otherwise the coalescing is meaningless.

This would be much easier if we only have tx interrupt mode, but this
requires more work.

>
>
> Or maybe I misunderstood you, and you are not referring to the following part:
> > +                             if (!notf_coal)
> > +                                     return -EBUSY;
> > +
> > +                             goto exit;
>
> But you are referring to the whole virtnet_set_coalesce function in general.

See above.

Thanks

>
>
> Alvaro.
>

