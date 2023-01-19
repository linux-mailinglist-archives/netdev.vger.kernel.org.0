Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CBFB6741CE
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 20:00:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbjASTAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 14:00:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230504AbjASS7x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 13:59:53 -0500
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0A2E829A9
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 10:59:03 -0800 (PST)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-4b718cab0e4so40654217b3.9
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 10:59:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=cmqFaQs16YU9+SA64z5qfzH94PKkiAkhRX59ckir0A0=;
        b=SltCi6I1q9EDEocfBlrfFgzMz8lV0u80z5HqrHZ76LLynpKHFKjqZpl7NpNBcj4ple
         wP3Cdx7UR8a5MriTpOA3+Pnstv0hYTqFZEQm4dMBIQmIfdTXgu2lfoVG/0C+dowEEfsC
         9OXxVvYX27vkc+o2EFjUhIHwFrwRh1aXF5DBPAD3VyFBg4t+EAajnKtsA5o19bdUBgns
         0N4pYYkKvZpTOkUFwLhX/7SsKHLBPc5GbfPycmWJQ9+viTe2Rw5oEnbRDzChYo6Xq3+e
         A1El9Io3lKFhl13nP4H0LTDFeUxDkoVcznF0EdOwMNJeHgJsC6mTBVIAyztjmnzanbfL
         GEtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cmqFaQs16YU9+SA64z5qfzH94PKkiAkhRX59ckir0A0=;
        b=Idhp0Xh8Wx1EjdEu43S3GLxHdpyXrkGmSDZZLi5UbhCsp1i2u4n4FV1zlFvUg62DWV
         Nuwjbu5Dk4PKWrt3UizndM76bxsrLFCIL3yb1+wrCy0jL8kRQy+HfEWuW39voSvYr2wh
         rF3QB54MuikAyBF3MYKAGnUngkrG/9zVisX3IDKdiAdgo3Z2aVzZVVMT1vEqFV9Try7x
         hK+zUrFk1FuE06yM4c6s0oLaQVqNAVuaAS03yqORCZOsgBcQbEyCWdvmnXtDQC6Qvy99
         Nw8tP3wRKeb3SY5fUWx1jQJvgOlSrPphshHeon0JfTUxIRO0h8fAiGnRE0wOLapOy9oh
         Ravw==
X-Gm-Message-State: AFqh2kpitpX9Jj2JRwKsWhZmgRspeIVGIFyla+S52nQMlmiR/99Mc9xI
        YInun8RLklh5x58GnwGS9W9KchOgy8uGBxyixSk=
X-Google-Smtp-Source: AMrXdXs6GT8Kg1CmmLhhZleFHmU7+Tv63RX7uLiF+ZgxULU4YSo0fyk2vWeZH07rRjUQea8kKBnBGCigpJdeAxdzaa4=
X-Received: by 2002:a0d:d486:0:b0:4f8:a88a:5b5e with SMTP id
 w128-20020a0dd486000000b004f8a88a5b5emr534268ywd.253.1674154742244; Thu, 19
 Jan 2023 10:59:02 -0800 (PST)
MIME-Version: 1.0
References: <cover.1673666803.git.lucien.xin@gmail.com> <de91843a7f59feb065475ca82be22c275bede3df.1673666803.git.lucien.xin@gmail.com>
 <b0a1bebc-7d44-05bc-347c-94da4cf2ef27@gmail.com> <CADvbK_cxQa0=ximH1F2bA-r0Q2+nMGAsSKhbaKzFTHOrcCF11A@mail.gmail.com>
 <CANn89iK4oSgoxJVkXO5rZXLzG1xw-xP31QbGHGvjhXqR2SSsRQ@mail.gmail.com>
 <CADvbK_c+RAFyrwuL+dfU3hc5U+ytOHC=TQ_xrkvXb4bB7XKjEA@mail.gmail.com>
 <CANn89iLtF3dNcMkMGagCSfb+p5zA3Fa-DV9f9xMHHU_TX2CvSw@mail.gmail.com>
 <b73e2dd1-d7bc-e96b-8553-1536a1146f3c@gmail.com> <CANn89iKc9HiswDGVVUBGDUef3V74Cq0pWdAG-zMK79pC6oDyEA@mail.gmail.com>
 <CADvbK_coggEMCELtAejSFzHnqBQp=BERvMJ1uqkF-iy8-kdo7w@mail.gmail.com>
 <CANn89i+OeD6Tmj0eyn=NK8M6syxKEQYLQfv4KUMmMGBh98YKyw@mail.gmail.com>
 <CADvbK_emHO8NjNxJdBueED9pAkoTo1girB5myyt-c1SjYxEtrQ@mail.gmail.com>
 <CADvbK_dQUpDa5oCo-o5DkKNY498gWwsan+RTpb9yTrg7DNRc+g@mail.gmail.com>
 <CANn89i++s3jhHqsyJT50FePT=icx3_FiYGqJNwQ73a1wt2+m+Q@mail.gmail.com>
 <65c32f21-ab74-5863-4d65-b87543f8aa89@gmail.com> <CADvbK_dWBbcN-V19y=2_txUk2pbykrBDp1JP6dh6dC7LSQ5+jQ@mail.gmail.com>
 <CANn89iJzV4jCuTvdE1zNwj5dTor=+ZHuORaWKGhNsavL8v=iDg@mail.gmail.com>
In-Reply-To: <CANn89iJzV4jCuTvdE1zNwj5dTor=+ZHuORaWKGhNsavL8v=iDg@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Thu, 19 Jan 2023 13:57:39 -0500
Message-ID: <CADvbK_f7Hq_uQP0dh6i1O6wAK4MMYx4FGCmGBqEoPWqO2sPpyQ@mail.gmail.com>
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

On Thu, Jan 19, 2023 at 1:10 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Thu, Jan 19, 2023 at 5:51 PM Xin Long <lucien.xin@gmail.com> wrote:
> >
> > On Thu, Jan 19, 2023 at 10:41 AM David Ahern <dsahern@gmail.com> wrote:
> > >
> > > On 1/18/23 8:13 PM, Eric Dumazet wrote:
> > > > On Thu, Jan 19, 2023 at 2:19 AM Xin Long <lucien.xin@gmail.com> wrote:
> > > >
> > > >> I think that IPv6 BIG TCP has a similar problem, below is the tcpdump in
> > > >> my env (RHEL-8), and it breaks too:
> > > >>
> > > >> 19:43:59.964272 IP6 2001:db8:1::1 > 2001:db8:2::1: [|HBH]
> > > >> 19:43:59.964282 IP6 2001:db8:1::1 > 2001:db8:2::1: [|HBH]
> > > >> 19:43:59.964292 IP6 2001:db8:1::1 > 2001:db8:2::1: [|HBH]
> > > >> 19:43:59.964300 IP6 2001:db8:1::1 > 2001:db8:2::1: [|HBH]
> > > >> 19:43:59.964308 IP6 2001:db8:1::1 > 2001:db8:2::1: [|HBH]
> > > >>
> > > >
> > > > Please make sure to use a not too old tcpdump.
> > > >
> > > >> it doesn't show what we want from the TCP header either.
> > > >>
> > > >> For the latest tcpdump on upstream, it can display headers well for
> > > >> IPv6 BIG TCP. But we can't expect all systems to use the tcpdump
> > > >> that supports HBH parsing.
> > > >
> > > > User error. If an admin wants to diagnose TCP potential issues, it should use
> > > > a correct version.
> > >
> > > Both of those just fall under "if you want a new feature, update your
> > > tools."
> > >
> > >
> > > >
> > > >>
> > > >> For IPv4 BIG TCP, it's just a CFLAGS change to support it in "tcpdump,"
> > > >> and 'tshark' even supports it by default.
> > > >
> > > > Not with privacy _requirements_, where only the headers are captured.
> > > >
> > > > I am keeping a NACK, until you make sure you do not break this
> > > > important feature.
> > >
> > > I think the request here is to keep the snaplen in place (e.g., to make
> > > only headers visible to userspace) while also returning the >64kB packet
> > > length as meta data.
> > >
> > > My last pass on the packet socket code suggests this is possible;
> > > someone (Xin) needs to work through the details.
> > >
> > To be honest, I don't really like such a change in a packet socket,
> > I tried, and the code doesn't look nice.
> >
> > I'm thinking since skb->len is trustable, why don't we use
> > IP_MAX_MTU(0xFFFF) as iph->tot_len for IPv4 BIG TCP?
> > namely, only change these 2 helpers to:
> >
> > static inline unsigned int iph_totlen(const struct sk_buff *skb, const
> > struct iphdr *iph)
> > {
> >         u16 len = ntohs(iph->tot_len);
> >
> >         return (len < IP_MAX_MTU || !skb_is_gso_tcp(skb)) ? len :
> >                 skb->len - skb_network_offset(skb);
> > }
> >
> > static inline void iph_set_totlen(struct iphdr *iph, unsigned int len)
> > {
> >         iph->tot_len = len < IP_MAX_MTU ? htons(len) : htons(IP_MAX_MTU);
> > }
> >
> > What do you think?
>
> I think this is a no go for me.
>
> I think I stated clearly what was the problem.
> If you care about TCP diagnostics, you want the truth, not truncated
> sequence ranges,
> making it impossible to know if a packet was sent.
Sorry Eric if I didn't get you well.

With new helpers, the iph->tot_len will be set to IP_MAX_MTU(65535),
all TCP headers will display well, no truncated sequence ranges:

#  ip net exec router tcpdump -i link1
13:36:46.675522 IP 198.51.100.1.42289 > 203.0.113.1.45103: Flags [P.],
seq 1532642515:1532707998, ack 1, win 504, options [nop,nop,TS val
2975547125 ecr 2379476018], length 65483
13:36:46.675534 IP 198.51.100.1.42289 > 203.0.113.1.45103: Flags [P.],
seq 1532769005:1532834488, ack 1, win 504, options [nop,nop,TS val
2975547125 ecr 2379476018], length 65483
13:36:46.675542 IP 198.51.100.1.42289 > 203.0.113.1.45103: Flags [P.],
seq 1532895495:1532960978, ack 1, win 504, options [nop,nop,TS val
2975547125 ecr 2379476018], length 65483
13:36:46.675550 IP 198.51.100.1.42289 > 203.0.113.1.45103: Flags [P.],
seq 1533021985:1533087468, ack 1, win 504, options [nop,nop,TS val
2975547125 ecr 2379476018], length 65483

I just don't want to modify the iph tot_len in IPv4 header from the
raw data in the packet socket.
We're trying to avoid iph->tot_len too small for IPv4 BIG TCP to
display tcphdr in tcpdump, aren't we?
That's why I think using IP_MAX_MTU will avoid this.

>
> Without headers describing precisely payload length (solution taken in
> IPv6 BI TCP),
> you have to augment AF_PACKET to provide this information in
> additional meta-data.
For this, I agree to provide the >64kB packet into additional meta-data.

Thanks.
