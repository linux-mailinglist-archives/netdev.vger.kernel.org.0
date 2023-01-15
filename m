Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8C266B338
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 18:35:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbjAORfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 12:35:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231213AbjAORfH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 12:35:07 -0500
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21E48CC2D
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 09:35:07 -0800 (PST)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-4d59d518505so184207427b3.1
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 09:35:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NuJoryL383uO6k5eiG0JSyVCLOGubfiyW3tqGSoQqEk=;
        b=nF/Yaaq3t5Jw5PpzLEdA/B614/0hEJ807HO5mTHuPPloAD9gfPqA0v06Yw0F5ZRt66
         NypJ3PKhRClBectPE1PkYovH6GTYJC2YLcCQg39IBS3DuQ2lePNj/ATAPW9gmdq1e/ft
         or7lSxu7s5EGauWQ6N8xZ2/XRvvWUHIY5o8llDv4hmO1eC2z60UAfpN9O518PIGXuh6A
         PgWeKbxFnOdYznYTlqoDdu0/R4W6m2mMC+BxIxcx/7HOCZu2bMo93UQaJNlfBFWsObam
         7zw8qPZiYpIma/xDKIbzFdiYR0Bc0GV+5qx62jamtdzZ+SrktIrVSVEq5S4wZ+ZZfcSb
         x03A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NuJoryL383uO6k5eiG0JSyVCLOGubfiyW3tqGSoQqEk=;
        b=sCt7aH68zpUFO/R11iMs/qaOS9ae9aDPoY06ApnHGKFsaYnD7GwJEvAt3ox4i+FUoS
         BYjIJxKWU8pwtnPVBCne+bFmHobc6SC5HTlkMm5e81ddykG+HCkHK25PIKXzloCfR+Or
         Wsyrm+LNjVR0NlIQhDqrBgkw+di+f9CmLe8X8qKggs94I3OWZ72/87a8Ga9D/OAh6rje
         xGF8SgTjLcg3Pe0I5ggtvkvdGeDFdvlZQ8jjKhTIEcmeLQub1ZSxCxgBAXgY+Apd+L/S
         6a4jc1KdesYXAVDd3S7x3dAYdY0As7St9nz7qGHQpp0SFTAjo7uSqSdOXLhGnphwToa1
         GTiw==
X-Gm-Message-State: AFqh2kq7UVi7pdSN77wymnGlaEncDQuE4haRt1B0W3FiTHidI90f55UX
        Vc8fPBZuvHYJtBXJYLrtGwwnqbmsl8WFHnEJUvY=
X-Google-Smtp-Source: AMrXdXtpNNEQv5bJUANCxLBpsuTwF+UdKfoGXjZX9NQoQU/+ZjP3LluHAUL9gZKisd6m7JoSq80PSoUOQDYtOZsgldE=
X-Received: by 2002:a05:690c:78a:b0:3c7:ef88:b857 with SMTP id
 bw10-20020a05690c078a00b003c7ef88b857mr3377920ywb.253.1673804106308; Sun, 15
 Jan 2023 09:35:06 -0800 (PST)
MIME-Version: 1.0
References: <cover.1673666803.git.lucien.xin@gmail.com> <CANn89i+Zovpi6rO9755zrCd6R=2a7Wm86n_=xdnhrtjrnapR_g@mail.gmail.com>
In-Reply-To: <CANn89i+Zovpi6rO9755zrCd6R=2a7Wm86n_=xdnhrtjrnapR_g@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Sun, 15 Jan 2023 12:33:47 -0500
Message-ID: <CADvbK_c1dZsvSXvMqizGxd7K_4_O5N_Yzs8EJqDzUgZ7R=4C2w@mail.gmail.com>
Subject: Re: [PATCH net-next 00/10] net: support ipv4 big tcp
To:     Eric Dumazet <edumazet@google.com>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Aaron Conole <aconole@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Mahesh Bandewar <maheshb@google.com>,
        Paul Moore <paul@paul-moore.com>,
        Guillaume Nault <gnault@redhat.com>
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

On Sun, Jan 15, 2023 at 11:05 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Sat, Jan 14, 2023 at 4:31 AM Xin Long <lucien.xin@gmail.com> wrote:
> >
> > This is similar to the BIG TCP patchset added by Eric for IPv6:
> >
> >   https://lwn.net/Articles/895398/
> >
> > Different from IPv6, IPv4 tot_len is 16-bit long only, and IPv4 header
> > doesn't have exthdrs(options) for the BIG TCP packets' length. To make
> > it simple, as David and Paolo suggested, we set IPv4 tot_len to 0 to
> > indicate this might be a BIG TCP packet and use skb->len as the real
> > IPv4 total length.
> >
> > This will work safely, as all BIG TCP packets are GSO/GRO packets and
> > processed on the same host as they were created; There is no padding
> > in GSO/GRO packets, and skb->len - network_offset is exactly the IPv4
> > packet total length; Also, before implementing the feature, all those
> > places that may get iph tot_len from BIG TCP packets are taken care
> > with some new APIs:
> >
> > Patch 1 adds some APIs for iph tot_len setting and getting, which are
> > used in all these places where IPv4 BIG TCP packets may reach in Patch
> > 2-7, and Patch 8 implements this feature and Patch 10 adds a selftest
> > for it. Patch 9 is a fix in netfilter length_mt6 so that the selftest
> > can also cover IPv6 BIG TCP.
> >
> > Note that the similar change as in Patch 2-7 are also needed for IPv6
> > BIG TCP packets, and will be addressed in another patchset.
> >
> > The similar performance test is done for IPv4 BIG TCP with 25Gbit NIC
> > and 1.5K MTU:
> >
>
> This is broken, sorry.
>
> There are reasons BIG TCP was implemented for IPv6 only, it seems you
> missed a lot of them.
>
> Networking needs observability and diagnostic tools.
>
> Until you come back with a proper way for tcpdump to not mess things,
> there is no way I can ACK these changes.
For the installed tcpdump, it's just parsing iph->tot_len from the raw pkt,
and I'm not sure how to make it without any change in tcpdump. But,

https://github.com/the-tcpdump-group/tcpdump/commit/c8623960f050cb81c12b31107070021f27f14b18

As this is already in tcpdump, we can build tcpdump with "-DGUESS_TSO":

# ./configure CFLAGS=-DGUESS_TSO

It seems someone had met such problems even without IPv4 BIG TCP, not
sure in Linux or other OS.
Now it's time to enable this CFLAG. :-)

Thanks.
