Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 678874D57C9
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 02:58:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345514AbiCKB6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 20:58:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345509AbiCKB6a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 20:58:30 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E73C122
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 17:57:29 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id n7so7922615oif.5
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 17:57:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wYmIXqGoP18VRv8GkXhEyrdmBAb5Sj51YjCRhrfnyCU=;
        b=UGR4hg7JGEyj5FStkRpY9WIuMMQwsLO5XjqKrJ1IytrD2WEwb++4ThYnP+bPWy7K3n
         3nId0tS8PoBY1seJ/fDAoaNW5D2HeT5+Em4agfYD+yNRJufAIMxeGLefO1S/OfQTti3q
         GjxxVD+ufIDzBKGHuuwzUoqPMetmNybncnfP02labX0KUJARz/SD4GO5NEbE9R8XC4K5
         DFt4aOlH8LuuCw67BbnkrLm4IqgrJ/fjvILsP2AgW553tjl7Es1IzCIqI7L96LZhOlIE
         pKTErC3wrOLUUk2SNMoZve4WaUha0cCMLh4xhhPe8Qy6c35MYo14OgoBo3AY1Nzat9B7
         GSvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wYmIXqGoP18VRv8GkXhEyrdmBAb5Sj51YjCRhrfnyCU=;
        b=54bJ7BfMXJIN+7lnRkT4bfI8BT20xaKOTpKz5kY3wVgtmC9lt5hzcUKQmxjyI0hBaY
         o7iWgIYDvfMVMWmDDgbwpy3FjoM97AeUNtV+2qV/tbbSONroUxrrN0EbqLh08aa+XHmF
         sKtDOsTy00IY8J76t6y30I20O73VzClmHPkYX4whnwT5jpUCRKisIcqqk4EwMYBZRAQV
         tJd++9neUeElZCEv87cQMqchyaB89lsMPnDrUDAJsxUbNNTdj6Q+Utd7WEVzq79Ifh3p
         dt88gcRQM4J1a/ekvrEsYQPcezzaVopAYpOwK0PBkPY1i2dzwgC74/fQn6yxP7RVQVhz
         ZQDw==
X-Gm-Message-State: AOAM530Oml+I2p7LhAugycHposprgFqDdm+pdN5RA7j93975TBcbt5ZH
        LuY55nbPPNodJ0L91BmY/FPZjwwdLzI=
X-Google-Smtp-Source: ABdhPJwsKQu2H0aWQUl9bhU/wC74wabdlbpOSlODAgG9ggP/wAQd4AeSWFnDr1XAvoyr7kMDJmZpPQ==
X-Received: by 2002:a05:6808:1247:b0:2d3:5181:449a with SMTP id o7-20020a056808124700b002d35181449amr5188674oiv.83.1646963848586;
        Thu, 10 Mar 2022 17:57:28 -0800 (PST)
Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com. [209.85.161.51])
        by smtp.gmail.com with ESMTPSA id 36-20020a9d0ba7000000b005ad59f1f783sm3246556oth.3.2022.03.10.17.57.28
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Mar 2022 17:57:28 -0800 (PST)
Received: by mail-oo1-f51.google.com with SMTP id u30-20020a4a6c5e000000b00320d8dc2438so8978552oof.12
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 17:57:28 -0800 (PST)
X-Received: by 2002:a81:6357:0:b0:2d7:2af4:6e12 with SMTP id
 x84-20020a816357000000b002d72af46e12mr6731354ywb.317.1646963397784; Thu, 10
 Mar 2022 17:49:57 -0800 (PST)
MIME-Version: 1.0
References: <CAF=yD-LrVjvY8wAqZtUTFS8V9ng2AD3jB1DOZvkagPOp3Sbq-g@mail.gmail.com>
 <20220310232538.1044947-1-tadeusz.struk@linaro.org>
In-Reply-To: <20220310232538.1044947-1-tadeusz.struk@linaro.org>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 10 Mar 2022 20:49:21 -0500
X-Gmail-Original-Message-ID: <CA+FuTSdFoTTqqL5CxCbL4gEg4-QvUQzQSM+45G9XL0BtLs7fGA@mail.gmail.com>
Message-ID: <CA+FuTSdFoTTqqL5CxCbL4gEg4-QvUQzQSM+45G9XL0BtLs7fGA@mail.gmail.com>
Subject: Re: [PATCH v3] net: ipv6: fix skb_over_panic in __ip6_append_data
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     kuba@kernel.org,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        syzbot+e223cf47ec8ae183f2a0@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 10, 2022 at 6:26 PM Tadeusz Struk <tadeusz.struk@linaro.org> wrote:
>
> Syzbot found a kernel bug in the ipv6 stack:
> LINK: https://syzkaller.appspot.com/bug?id=205d6f11d72329ab8d62a610c44c5e7e25415580
> The reproducer triggers it by sending a crafted message via sendmmsg()
> call, which triggers skb_over_panic, and crashes the kernel:
>
> skbuff: skb_over_panic: text:ffffffff84647fb4 len:65575 put:65575
> head:ffff888109ff0000 data:ffff888109ff0088 tail:0x100af end:0xfec0
> dev:<NULL>
>
> Update the check that prevents an invalid packet with MTU equall to the
> fregment header size to eat up all the space for payload.
>
> The reproducer can be found here:
> LINK: https://syzkaller.appspot.com/text?tag=ReproC&x=1648c83fb00000
>
> Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Andrii Nakryiko <andrii@kernel.org>
> Cc: Martin KaFai Lau <kafai@fb.com>
> Cc: Song Liu <songliubraving@fb.com>
> Cc: Yonghong Song <yhs@fb.com>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: KP Singh <kpsingh@kernel.org>
> Cc: netdev@vger.kernel.org
> Cc: bpf@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: stable@vger.kernel.org
>
> Reported-by: syzbot+e223cf47ec8ae183f2a0@syzkaller.appspotmail.com
> Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>

Acked-by: Willem de Bruijn <willemb@google.com>

small nit: "equal to the fragment" and all these Cc:s aren't really
needed in the commit message.

I don't think we'll find a commit for a Fixes tag. This goes ways back.
