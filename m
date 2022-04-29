Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55A315157DA
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 00:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238567AbiD2WI7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 18:08:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359568AbiD2WI4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 18:08:56 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D36EC83008
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 15:05:35 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id g28so16746105ybj.10
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 15:05:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GAXmCRc3lSOVYcNpy8O/6UhikW8W0LY8j/c9X7o57N8=;
        b=RwIlF7TtzMr9ei1gzjHEl+WsjKakPNiUJPxtsgL+xc/vfErFq25Bw2KBkF47qccKq1
         lTGAgrmK2WASE4V8K9ZeW/mmDa90vzKIVXGTrrGjOiis10w/zGKjH3NSMttZkGR0DsEY
         CiKQHhKqMX4fa+FHrgvbC+YJrAjiULjAlydSoQnaRqvq/2dKRcMyRygxrJ1OyjYmYCHF
         A7ZclJQtIUf/xjn3Gkfhm/bO6HtHRCRfLc4IfG3yNwQiz4606aJ37B+r2E9kOKin+s0u
         vtBW+RTfulW6LmArTh5URV7MeTjhjT4XpfAugIZwf0c6S1xO7ZrgqUuI2+DH1Z5Pijb1
         guIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GAXmCRc3lSOVYcNpy8O/6UhikW8W0LY8j/c9X7o57N8=;
        b=vlOIaWAI9imRIu4jw0Z3G+dDbzLmBkxtv9Q8IQEJAiDp96JmIE+10kdRhKcw/B0PgH
         3EQLN1tpkqd9OqFWLw6yRwCYmpoHtaxlYJ/oFIaj8uRLb1CzI8R6rIuvWTbAueiryNL4
         CeVHMkpUp6s8XyqemASyu9eEDPfMI7aliRaSU40XS81yxDxHd+g3JsfuyP/WnTzu87xA
         pfKdbiylfvKPUZrQiwKCkyfGbRhV9IxrXs0fF7RBCUTOFQ2bKDTJT+HIGGRx6wKftt0X
         YLAlNgNk2TTrTKlKQHhJljcaOMexWJEig0jY6zUl6YVGDzIg+MAFM9T/L69AAdJ/2RXV
         j5UQ==
X-Gm-Message-State: AOAM530pujkNcE0vBoMSDAezTOfBX+iYH9ls2CMoM2B4eBIhsvrbb8uH
        FnYytCiy8FeNhbcyUCUGP/Ao7IyFzZGTK8lYgdcK61sMf9f89JOg
X-Google-Smtp-Source: ABdhPJx8W/f0rIOxwSLCAUKHFdwYsYsmP6YReafF6bxvy28/9zbpMt+wREZ2Hk6CzroVnhUZa8a5ZIZGRCePs7y/hVc=
X-Received: by 2002:a25:ea48:0:b0:644:e2e5:309 with SMTP id
 o8-20020a25ea48000000b00644e2e50309mr1559161ybe.407.1651269934754; Fri, 29
 Apr 2022 15:05:34 -0700 (PDT)
MIME-Version: 1.0
References: <CAHmME9r_DbZWe4FsfebHSSf_iPctSe5S-w9bU3o8BN43raeURg@mail.gmail.com>
 <20151116203709.GA27178@oracle.com> <CAHmME9pNCqbcoqbOnx6p8poehAntyyy1jQhy=0_HjkJ8nvMQdw@mail.gmail.com>
 <1447712932.22599.77.camel@edumazet-glaptop2.roam.corp.google.com>
 <CAHmME9oTU7HwP5=qo=aFWe0YXv5EPGoREpF2k-QY7qTmkDeXEA@mail.gmail.com>
 <YmszSXueTxYOC41G@zx2c4.com> <04f72c85-557f-d67c-c751-85be65cb015a@gmail.com>
 <YmxTo2hVwcwhdvjO@zx2c4.com> <d9854c74-c209-9ea5-6c76-8390e867521b@gmail.com> <CAHmME9qXC-4OPc5xRbC6CQJcpzb96EXzNWAist5A8momYxvVUA@mail.gmail.com>
In-Reply-To: <CAHmME9qXC-4OPc5xRbC6CQJcpzb96EXzNWAist5A8momYxvVUA@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 29 Apr 2022 15:05:23 -0700
Message-ID: <CANn89iLyNoCRrp6YYdy6kGhM7X2JQ9J4-LfEJCBvhYAv4N+FPA@mail.gmail.com>
Subject: Re: Routing loops & TTL tracking with tunnel devices
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 29, 2022 at 2:54 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Hi Eric,
>
> On Fri, Apr 29, 2022 at 11:14 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >
> >
> > On 4/29/22 14:07, Jason A. Donenfeld wrote:
> >
> > Hi Eric,
> >
> > On Fri, Apr 29, 2022 at 01:54:27PM -0700, Eric Dumazet wrote:
> >
> > Anyway, it'd be nice if there were a free u8 somewhere in sk_buff that I
> > could use for tracking times through the stack. Other kernels have this
> > but afaict Linux still does not. I looked into trying to overload some
> > existing fields -- tstamp/skb_mstamp_ns or queue_mapping -- which I was
> > thinking might be totally unused on TX?
> >
> > if skbs are stored in some internal wireguard queue, can not you use
> > skb->cb[],
> >
> > like many other layers do ?
> >
> > This isn't for some internal wireguard queue. The packets get sent out
> > of udp_tunnel_xmit_skb(), so they leave wireguard's queues.
> >
> >
> > OK, where is the queue then ?
> >
> > dev_xmit_recursion() is supposed to catch long chains of virtual devices.
>
> This is the long-chain-of-virtual-devices case indeed. But
> dev_xmit_recursion() does not help here, since that's just a per-cpu
> increment, assuming that the packet actually gets xmit'd in its
> ndo_start_xmit function. But in reality, wireguard queues up the
> packet, encrypts it in some worker later, and eventually transmits it
> with udp_tunnel_xmit_skb(). All the while ndo_start_xmit() has long
> returned. So no help from dev_xmit_recursion().
>

I assume you add encap headers to the skb ?

You could check if the wireguard header is there already, or if the
amount of headers is crazy.

net/core/flow_dissector.c might help.

You also can take a look at CONFIG_SKB_EXTENSIONS infrastructure.
