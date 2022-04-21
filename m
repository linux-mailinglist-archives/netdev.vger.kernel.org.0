Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21EC7509E25
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 13:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356204AbiDULDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 07:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242691AbiDULDG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 07:03:06 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 063E2BE1A
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 04:00:16 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id u5so1539837pjr.5
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 04:00:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=y77+G0X/t/50ifRI/DHQMV/ZvaxHOI7gSD0fQ5jR/OU=;
        b=mbQTvBIp5wgcWZ3EKW/ezSz60E/hmA02kEJX7Vc6ft8wDMx1Y5OlS31xHbu/M6nHwH
         1Z9LUgKur7Vibs0yO9Z/+14haPHpY2rrnO/PUzwCjFeMZpMGK2Jg7HnIa/J4aQ/UJVsH
         pkTIuqX2vsLZiMpfif0xQJ0pmKklcUsnGf0DRoxugCaxVBkYxhUoxCwWlNsV1eEDjjyS
         +Y3kCsjdgMfGOYtPkBrji/wPAcYeCPfR9D1Tg7VuLLXzb2n6GVJ1DNCjXOeTF5eZT7xX
         9ClaXD43CulKP3Kszy0PvKFNNajOm+TOK7XSoFr9hKTK6rimLLViERfl5gK2SZH+7HAH
         ONUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=y77+G0X/t/50ifRI/DHQMV/ZvaxHOI7gSD0fQ5jR/OU=;
        b=nuOM1t1DnceppVs71USyImTvQKY5vbDlivnMlcOeA1x3ntQf8jxOPOUcdMgz0QSjaq
         A7DAIzeuiRU5jy3EitCOhjCkDOIFESIN/I3c7VFVJeRk5YJ01A9e5d127EJWzQT+WbZW
         Ewp89cebPUHDRkEGyZcGOAhBr/Cf/sfvJanhKP88nlKTt7T9GBID4QQO1XaHvUUZQ18b
         QpSZS2hZkJJHwemH3W/7jxQnBE8PioAYCi42USjz7AND8E9tR8wN4e/DB5KNaVeHW2w0
         1Qv6Js50Z0C6PJTNiE4gbcDpCScXKHKA9VGOReqD3P5U0IrKSQkc90XRgiPWbVh3TIgx
         ALiQ==
X-Gm-Message-State: AOAM532qNTTR/HX4vAzSHxB0/Re/4cZtdjoCIY4QtedUORD15/u0XRiC
        bJB8WutwEw/kQiHVD6en7PA=
X-Google-Smtp-Source: ABdhPJwtbXZ6DFDemeDkh5ygC2XzbwCZqA/paedqzxwjZWzmT2DlYpeUIi66FgL1b9jMQTQ9iBgwqQ==
X-Received: by 2002:a17:90a:f2c9:b0:1cd:33d3:31be with SMTP id gt9-20020a17090af2c900b001cd33d331bemr9670834pjb.92.1650538815475;
        Thu, 21 Apr 2022 04:00:15 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f1-20020a17090a664100b001cd4989fee9sm2421992pjm.53.2022.04.21.04.00.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 04:00:14 -0700 (PDT)
Date:   Thu, 21 Apr 2022 19:00:07 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Eyal Birger <eyal.birger@gmail.com>
Cc:     Marcelo Ricardo Leitner <mleitner@redhat.com>,
        netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, kuba@kernel.org,
        ahleihel@redhat.com, dcaratti@redhat.com, aconole@redhat.com,
        roid@nvidia.com, Shmulik Ladkani <shmulik.ladkani@gmail.com>
Subject: Re: [PATCH net] net: sched: act_mirred: Reset ct info when
 mirror/redirect skb
Message-ID: <YmE5N0aNisKVLAyt@Laptop-X1>
References: <20210809070455.21051-1-liuhangbin@gmail.com>
 <162850320655.31628.17692584840907169170.git-patchwork-notify@kernel.org>
 <CAHsH6GuZciVLrn7J-DR4S+QU7Xrv422t1kfMyA7r=jADssNw+A@mail.gmail.com>
 <CALnP8ZackbaUGJ_31LXyZpk3_AVi2Z-cDhexH8WKYZjjKTLGfw@mail.gmail.com>
 <CAHsH6GvoDr5qOKsvvuShfHFi4CsCfaC-pUbxTE6OfYWhgTf9bg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHsH6GvoDr5qOKsvvuShfHFi4CsCfaC-pUbxTE6OfYWhgTf9bg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eyal,
On Tue, Apr 19, 2022 at 09:14:38PM +0300, Eyal Birger wrote:
> > > > On Mon,  9 Aug 2021 15:04:55 +0800 you wrote:
> > > > > When mirror/redirect a skb to a different port, the ct info should be reset
> > > > > for reclassification. Or the pkts will match unexpected rules. For example,
> > > > > with following topology and commands:
> > > > >
> > > > >     -----------
> > > > >               |
> > > > >        veth0 -+-------
> > > > >               |
> > > > >        veth1 -+-------
> > > > >               |
> > > > >
> > > > > [...]
> > > >
> > > > Here is the summary with links:
> > > >   - [net] net: sched: act_mirred: Reset ct info when mirror/redirect skb
> > > >     https://git.kernel.org/netdev/net/c/d09c548dbf3b
> > >
> > > Unfortunately this commit breaks DNAT when performed before going via mirred
> > > egress->ingress.
> > >
> > > The reason is that connection tracking is lost and therefore a new state
> > > is created on ingress.
> > >
> > > This breaks existing setups.
> > >
> > > See below a simplified script reproducing this issue.

I think we come in to a paradox state. Some user don't want to have previous
ct info after mirror, while others would like to keep. In my understanding,
when we receive a pkt from a interface, the skb should be clean and no ct info
at first. But I may wrong.

Jamal, Wang Cong, Jiri, do you have any comments?

> >
> > I guess I can understand why the reproducer triggers it, but I fail to
> > see the actual use case you have behind it. Can you please elaborate
> > on it?
> 
> One use case we use mirred egress->ingress redirect for is when we want to
> reroute a packet after applying some change to the packet which would affect
> its routing. for example consider a bpf program running on tc ingress (after
> mirred) setting the skb->mark based on some criteria.
> 
> So you have something like:
> 
> packet routed to dummy device based on some criteria ->
>   mirred redirect to ingress ->
>     classification by ebpf logic at tc ingress ->
>        packet routed again
> 
> We have a setup where DNAT is performed before this flow in that case the
> ebpf logic needs to see the packet after the NAT.

Is it possible to check whether it's need to set the skb->mark before DNAT?
So we can update it before egress and no need to re-route.

Thanks
Hangbin
