Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2B8612379
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 16:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbiJ2OKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Oct 2022 10:10:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbiJ2OKo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Oct 2022 10:10:44 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DC9658152
        for <netdev@vger.kernel.org>; Sat, 29 Oct 2022 07:10:43 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id a27so1806380qtw.10
        for <netdev@vger.kernel.org>; Sat, 29 Oct 2022 07:10:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7FYM+BgkmbhruYY/V8UqhteTynBQpXf0ZAZtRZff80U=;
        b=MRsj1Msseo5Rbc2qU2/wLjdYGh7cRuaamc2XVKNjcGzHYchaMwxDHuJYndD+w0FkeM
         IxS61zH4j/7PJMIBqfk0kN5wQWcfZ5bqtdJUSA+azeIM0vQdU2XCmWSYdjdVoBcc6j+t
         WZlxHlFsE/IbPbtxEEP/iSZ1eYBa6cl6dWkGo8MhWXuF3wD51vYFhueBcyH+xgQzl6Sy
         NJgOe70pnLoZ3IBY8WpqTFT/GKinQzo+0Io6KchHOlvIuMLMu4T1T+4U9k3GdxjCTMKP
         HWg6uRjay3OOtjt64MrbIir5cGy7JKfQnnZ715SdiikHViy3PR7+vB5wuW2Tzh7A+fOJ
         eo0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7FYM+BgkmbhruYY/V8UqhteTynBQpXf0ZAZtRZff80U=;
        b=3aBWgvcw/ziXT6yD/ZPAgKXMy8rYW2xV9DQMzrTczsnybxJnWllICQ/en0XMRKApos
         T+n4sHYdbrUjwjS7ULNF1occKMguiJhU4MsJ3ckWX20912bg1xvfDTYLLrhcB7zqRb32
         1IufoybpnkPwxhV+eD7WMYWdIxnueDLUXZ/tp6vsYeVsd0jHdv42O8mpP8IiSpXnZRrP
         53bEPNva3x3IZrQaxvZ1NkWKHAJa13sfilKed9hdg57E+tJkucQzjvhKvwTOG+5wsAiV
         504mivXSFtBTjRx8HhnD+4rYZ7Lxoy4eyXqSdOfEGQTnUPIo9S5zMut+zw/VwsZymtnr
         OSmg==
X-Gm-Message-State: ACrzQf3uUrW1YYDemDeem9ot5KOFk5cqDhPUmUxEH9W0GQwcmngnV0xd
        NM7wWALZpOEOeXA5Z82RqycMcdEG6Lk=
X-Google-Smtp-Source: AMsMyM5edAfjxUf0uuLSi+PZIpbZwq+6jRcwjqTYHfyNS+FPmQeXNolrYNYqhez8ru/kvYzu9i53tQ==
X-Received: by 2002:ac8:5c83:0:b0:39c:e9b9:9efd with SMTP id r3-20020ac85c83000000b0039ce9b99efdmr3673487qta.481.1667052642132;
        Sat, 29 Oct 2022 07:10:42 -0700 (PDT)
Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com. [209.85.219.178])
        by smtp.gmail.com with ESMTPSA id y24-20020a37f618000000b006cf19068261sm1074489qkj.116.2022.10.29.07.10.41
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Oct 2022 07:10:41 -0700 (PDT)
Received: by mail-yb1-f178.google.com with SMTP id z192so9131811yba.0
        for <netdev@vger.kernel.org>; Sat, 29 Oct 2022 07:10:41 -0700 (PDT)
X-Received: by 2002:a25:e80d:0:b0:6cb:a59c:541b with SMTP id
 k13-20020a25e80d000000b006cba59c541bmr3829706ybd.388.1667052640909; Sat, 29
 Oct 2022 07:10:40 -0700 (PDT)
MIME-Version: 1.0
References: <559cea869928e169240d74c386735f3f95beca32.1666858629.git.jbenc@redhat.com>
 <20221029104131.07fbc6cf@blondie>
In-Reply-To: <20221029104131.07fbc6cf@blondie>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sat, 29 Oct 2022 10:10:03 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdkOMBahoeLsXV8wnGdqNtmUHHDu-9xn9JX6zY3M4VmVw@mail.gmail.com>
Message-ID: <CA+FuTSdkOMBahoeLsXV8wnGdqNtmUHHDu-9xn9JX6zY3M4VmVw@mail.gmail.com>
Subject: Re: [PATCH net] net: gso: fix panic on frag_list with mixed head
 alloc types
To:     Shmulik Ladkani <shmulik.ladkani@gmail.com>
Cc:     Jiri Benc <jbenc@redhat.com>, netdev@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Tomas Hruby <tomas@tigera.io>,
        Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
        alexanderduyck@meta.com, Jakub Kicinski <kuba@kernel.org>
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

On Sat, Oct 29, 2022 at 3:41 AM Shmulik Ladkani
<shmulik.ladkani@gmail.com> wrote:
>
> On Thu, 27 Oct 2022 10:20:56 +0200
> Jiri Benc <jbenc@redhat.com> wrote:
>
> > It turns out this assumption does not hold. We've seen BUG_ON being hit
> > in skb_segment when skbs on the frag_list had differing head_frag. That
> > particular case was with vmxnet3; looking at the driver, it indeed uses
> > different skb allocation strategies based on the packet size. The last
> > packet in frag_list can thus be kmalloced if it is sufficiently small.
> > And there's nothing preventing drivers from mixing things even more
> > freely.
>
> Hi Jiri,
>
> One of my early attempts to fix the original BUG was to also detect:
>
> > - some frag in the frag_list has a linear part that is NOT head_frag,
> >   or length not equal to the requested gso_size
>
> See [0], see skb_is_nonlinear_equal_frags() there
>
> (Note that your current suggestion implements the "some frag in the
>  frag_list has a linear part that is NOT head_frag" condition, but not
>  "length not equal to the requested gso_size")
>
> As a response, Willem suggested:
>
> > My suggestion only tested the first frag_skb length. If a list can be
> > created where the first frag_skb is head_frag but a later one is not,
> > it will fail short. I kind of doubt that.
>
> See [1]
>
> So we eventually concluded testing just
>   !list_skb->head_frag && skb_headlen(list_skb)
> and not every frag in frag_list.
>
> Maybe Willem can elaborate on that.

Clearly I was wrong :)

If a device has different allocation strategies depending on packet
size, and GRO coalesces those using a list, then indeed this does not
have to hold. GRO requires the same packet size and thus allocation
strategy to coalesce -- except for the last segment.

I don't see any allocation in vmxnet3 that uses a head frag, though.
There is a small packet path (rxDataRingUsed), but both small and
large allocate using a kmalloc-backed skb->data as far as I can tell.

In any case, iterating over all frags is more robust. This is an edge
case, fine to incur the cost there.
