Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED01C606A77
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 23:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbiJTVrs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 17:47:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiJTVrs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 17:47:48 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36632226590
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 14:47:47 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id 126so1183811ybw.3
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 14:47:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BduN7ZyT9a7ijSTsAwfm39GrC94tynGJ24nLwvl0qDE=;
        b=EY+XbBFgCXA8CrR7TF4lQqn9fiVSb3PzMVI4j47eL07C6GSLHXu7EGVxBqYlc8c3Dv
         6+NloT+80cKUVlaBa6ir0/zhY3RBUA2qm8BxFETJjRmomRnx9K8EeQmx5uQujB0pYQlb
         dwdh6/7nXvWK1dAgZJNqjokbPfnAT2wIrEmOel/LRuGKPNtsYo/EiNGwYiv1xPUsB5he
         MXH6Q2azsVPpGzZE2SODA53KcDZqWWxnCkPP9GGnWRRBZzV9DuYABBce00rcvT8j1AMw
         zn8nKT+rclJbayEpSwxAYohh1w7RoaHxdtWf2JA/oK381E7lhYjeMJYOaRSLR77BMdf1
         u4aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BduN7ZyT9a7ijSTsAwfm39GrC94tynGJ24nLwvl0qDE=;
        b=3doJGQsXFkdpA4Atl256mhkX08us/Un4+qoAogH9XgjLG6Ay62DLzsBUwzMnc32H9/
         g2sPlMhyZgeRlchBd/yc+fhqVwfbaaXB6XBkZ1rEB5MMvpDUnpg94DvDR+hBnUr+j5UH
         N9TjEfcW8oMDUQgFBbMc3sGznfXSvibahmxM9ijZvBO31el53ugjlzkGudLgNLdkifoV
         3RZ+a50gFn06tGV6LeFDTzvVdmwXIyY/avh/VpuWCTbj4S+eHtEODoehNvxOpPbjXLSd
         1reO/BYmHfUX5HGsF09j7tGr6vJjZ1C2Ykpw4VKUZgmBNykMhOTDYms3Fx1n4wFP5Fl6
         uYpA==
X-Gm-Message-State: ACrzQf2MaUqvcEwoMshDSU+FXrY16tbfCkhkJkDqwPOsTX7EUX/1OydM
        /FZuRxwotGC//QCdgj1C/npZV4NBRFK5D/w03Of5ZA==
X-Google-Smtp-Source: AMsMyM6eSztPIceguaH63LOnJUnB/NIwLQfYKkA1q19JcwgeqwQ6Km0T96PbVCGZDLt9jPRgPGXjo5Hvaoc3NE2LhPQ=
X-Received: by 2002:a25:7a01:0:b0:6b0:820:dd44 with SMTP id
 v1-20020a257a01000000b006b00820dd44mr12358030ybc.387.1666302466145; Thu, 20
 Oct 2022 14:47:46 -0700 (PDT)
MIME-Version: 1.0
References: <20221020182242.503107-1-kamaljit.singh1@wdc.com>
 <20221020182242.503107-3-kamaljit.singh1@wdc.com> <CANn89iLZZAA6N5wzzP_ZR2u-shHLxknobxt+5CixA92rv7udcw@mail.gmail.com>
 <4dbc732f7cfa066bd07eaf7eb653e2b4e4a8de80.camel@wdc.com>
In-Reply-To: <4dbc732f7cfa066bd07eaf7eb653e2b4e4a8de80.camel@wdc.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 20 Oct 2022 14:47:34 -0700
Message-ID: <CANn89iJ2AWUehsEZo+L_G6cdKaEdwdMVfZr6SYnRFun3L2ksSg@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] tcp: Ignore OOO handling for TCP ACKs
To:     Kamaljit Singh <Kamaljit.Singh1@wdc.com>
Cc:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 20, 2022 at 2:25 PM Kamaljit Singh <Kamaljit.Singh1@wdc.com> wrote:
>
> On Thu, 2022-10-20 at 11:57 -0700, Eric Dumazet wrote:
> > CAUTION: This email originated from outside of Western Digital. Do not click
> > on links or open attachments unless you recognize the sender and know that the
> > content is safe.
> >
> >
> > On Thu, Oct 20, 2022 at 11:22 AM Kamaljit Singh <kamaljit.singh1@wdc.com>
> > wrote:
> > > Even with the TCP window fix to tcp_acceptable_seq(), occasional
> > > out-of-order host ACKs were still seen under heavy write workloads thus
> > > Impacting performance.  By removing the OoO optionality for ACKs in
> > > __tcp_transmit_skb() that issue seems to be fixed as well.
> >
> > This is highly suspect/bogus.
> >
> >  Please give which driver is used here.
> The NVMe/TCP Host driver (also mentioned in the cover letter).
>

This is code located on the same linux host ?

So... this is loopback interface ?

Which ndo_start_xmit() is called ?

>
> >
> > > Signed-off-by: Kamaljit Singh <kamaljit.singh1@wdc.com>
> > > ---
> > >  net/ipv4/tcp_output.c | 5 ++++-
> > >  1 file changed, 4 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> > > index 322e061edb72..1cd77493f32c 100644
> > > --- a/net/ipv4/tcp_output.c
> > > +++ b/net/ipv4/tcp_output.c
> > > @@ -1307,7 +1307,10 @@ static int __tcp_transmit_skb(struct sock *sk, struct
> > > sk_buff *skb,
> > >          * TODO: Ideally, in-flight pure ACK packets should not matter here.
> > >          * One way to get this would be to set skb->truesize = 2 on them.
> > >          */
> > > -       skb->ooo_okay = sk_wmem_alloc_get(sk) < SKB_TRUESIZE(1);
> > > +       if (likely(tcb->tcp_flags & TCPHDR_ACK))
> > > +               skb->ooo_okay = 0;
> > > +       else
> > > +               skb->ooo_okay = sk_wmem_alloc_get(sk) < SKB_TRUESIZE(1);
> > >
> >
> > This is absolutely wrong and would impact performance quite a lot.
> >
> > You are basically removing all possibilities for ackets of a TCP flow
> > to be directed to a new queue, say if use thread has migrated to
> > another cpu.
> Are you suggesting that the proposed change not be done at all or done in a
> different way? We did see an observed performance improvement in NVMe/TCP
> traffic with this fix. If you have an alternative idea I'd be happy to try &
> test it out.

Well, you disable a very important feature, just to work around some
problem in another layer.

Let's investigate what can be done in this other layer, once it is identified.


>
>
> >
> > After 3WHS, all packets get ACK set.
> --
> Thanks,
> Kamaljit Singh <kamaljit.singh1@wdc.com>
