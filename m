Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95A6066E2C1
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 16:51:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232329AbjAQPv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 10:51:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232592AbjAQPvF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 10:51:05 -0500
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 166BF8A5F
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 07:48:56 -0800 (PST)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-4e9adf3673aso91584707b3.10
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 07:48:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZZN21AC8IIikUVmyR8NSwmZxB9RFdkgUIaPDejopYDU=;
        b=L6+9uUYzlJRVal/oxqMpjkjy2wYmzCTnivmDGyVcr15rXEAto/1djhXmBy0dyyqPIh
         0pi04kBsbERDJd6X5Og2WKcm1VJWJ4tZhA3j34Wx7Ou9i3DDZwpH+0QZnwxZMVliMVgI
         BHKGwUEeQw9/3neugKZxuppK7DPpiLrsYgcIaOWM39oblgtG3AIHHHe/+27eVha74fZI
         VURFBjzbKiKpe2DMtivDbVXknyawyvls8RqLzmyUUU0K8PSJu1X6vA3bOfsaoW9+Fpp5
         HlFTNb+q4rKNSlOr1Y3ZN2ifNPlzT/p2ZuXSQvln15+hDXtGmNfQQnCXmwhXcpw7s963
         uNhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZZN21AC8IIikUVmyR8NSwmZxB9RFdkgUIaPDejopYDU=;
        b=VTlEXNe4UOIGbMpYBWGl++TkZtuyYPv+Hv2ZqGtCqYPez6GtYAVpH8L5yh8QbTBiVu
         VHAZ8KB0zsDUFFbF7h4CGYAXD28YfQVPR91Tu2PBP9ghzak7HvXZDIpgtph9xeHGbj4O
         X8eYdV9HXoIDESAxvHyj4fbDBBGvErxCTjbU6eTIluuftxGfcqOAliBVDGISj8wH931V
         bsKfuA49xlpDmwVbOcD2P+gkwfe0Bd1d/PQOnLjM+oJ6ibc/tckQ7saDE4Xkcz/Nx6a6
         WwXNeqp/4BZDv6adlDFarbtiPsnAvS4Y5KTrHPZjRTTVojzcHIIQc3lrPv/992FLpn0l
         +Mhg==
X-Gm-Message-State: AFqh2krLTYu34xsNHEsW363tae/RiVf2hfb/IQ+O57JeY5NA3A6DS32g
        ApB2h3l51yaocO3cdw2pOIOViEZkEDTAfrQP2vzzzpz0PYOu8w==
X-Google-Smtp-Source: AMrXdXuvqfc8QgccT0DUKk6pAVGlhnLQxOHijibH3/B3WU5NvSE0aHronGJemaEfw4gLG33AjMqsdaXaI4+ub+clmpo=
X-Received: by 2002:a81:1252:0:b0:4db:1b7:54b8 with SMTP id
 79-20020a811252000000b004db01b754b8mr452686yws.449.1673970535247; Tue, 17 Jan
 2023 07:48:55 -0800 (PST)
MIME-Version: 1.0
References: <cover.1673666803.git.lucien.xin@gmail.com> <de91843a7f59feb065475ca82be22c275bede3df.1673666803.git.lucien.xin@gmail.com>
 <b0a1bebc-7d44-05bc-347c-94da4cf2ef27@gmail.com> <CADvbK_cxQa0=ximH1F2bA-r0Q2+nMGAsSKhbaKzFTHOrcCF11A@mail.gmail.com>
 <CANn89iK4oSgoxJVkXO5rZXLzG1xw-xP31QbGHGvjhXqR2SSsRQ@mail.gmail.com>
 <CADvbK_c+RAFyrwuL+dfU3hc5U+ytOHC=TQ_xrkvXb4bB7XKjEA@mail.gmail.com>
 <CANn89iLtF3dNcMkMGagCSfb+p5zA3Fa-DV9f9xMHHU_TX2CvSw@mail.gmail.com>
 <b73e2dd1-d7bc-e96b-8553-1536a1146f3c@gmail.com> <CANn89iKc9HiswDGVVUBGDUef3V74Cq0pWdAG-zMK79pC6oDyEA@mail.gmail.com>
 <CADvbK_coggEMCELtAejSFzHnqBQp=BERvMJ1uqkF-iy8-kdo7w@mail.gmail.com> <CANn89i+OeD6Tmj0eyn=NK8M6syxKEQYLQfv4KUMmMGBh98YKyw@mail.gmail.com>
In-Reply-To: <CANn89i+OeD6Tmj0eyn=NK8M6syxKEQYLQfv4KUMmMGBh98YKyw@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 17 Jan 2023 10:47:34 -0500
Message-ID: <CADvbK_emHO8NjNxJdBueED9pAkoTo1girB5myyt-c1SjYxEtrQ@mail.gmail.com>
Subject: Re: [PATCH net-next 09/10] netfilter: get ipv6 pktlen properly in length_mt6
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Ahern <dsahern@gmail.com>,
        network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, Paolo Abeni <pabeni@redhat.com>,
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

On Mon, Jan 16, 2023 at 3:37 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Mon, Jan 16, 2023 at 8:10 PM Xin Long <lucien.xin@gmail.com> wrote:
> >
> > On Mon, Jan 16, 2023 at 11:02 AM Eric Dumazet <edumazet@google.com> wrote:
> > >
> > > On Mon, Jan 16, 2023 at 4:08 PM David Ahern <dsahern@gmail.com> wrote:
> > > >
> > >
> > > > not sure why you think it would not be detected. Today's model for gro
> > > > sets tot_len based on skb->len. There is an inherent trust that the
> > > > user's of the gro API set the length correctly. If it is not, the
> > > > payload to userspace would ultimately be non-sense and hence detectable.
> > >
> > > Only if you use some kind of upper protocol adding message integrity
> > > verification.
> > >
> > > > >
> > > > > As you said, user space sniffing packets now have to guess what is the
> > > > > intent, instead of headers carrying all the needed information
> > > > > that can be fully validated by parsers.
> > > >
> > > > This is a solveable problem within the packet socket API, and the entire
> > > > thing is opt-in. If a user's tcpdump / packet capture program is out of
> > > > date and does not support the new API for large packets, then that user
> > > > does not have to enable large GRO/TSO.
> > >
> > > I do not see this being solved yet.
> > I think it's common that we add a feature that is disabled by
> > default in the kernel if the userspace might not support it.
>
> One critical feature for us is the ability to restrict packet capture
> to the headers only.
>
> Privacy is a key requirement.
>
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=3e5289d5e3f98b7b5b8cac32e9e5a7004c067436
>
> So please make sure that packet captures truncated to headers will
> still be understood by tcpdump
IIUC we can try to adjust iph->tot_len to 65535 or at least the length
of all headers for IPv4 BIG TCP packets on the PACKET socket rcv
path? (or even truncate the ipv4 BIG TCP packets there.). This way
tcpdump will be able to parse all the headers.

But what if some applications want all the raw data via PACKET sockets?
Maybe adjust iph->tot_len only, not truncate the packet?

Thanks.
