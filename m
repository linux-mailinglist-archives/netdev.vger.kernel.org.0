Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A316679ECC
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 17:35:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234377AbjAXQfk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 11:35:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234442AbjAXQfh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 11:35:37 -0500
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11B4D4C0E2
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 08:35:11 -0800 (PST)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-4c131bede4bso226106777b3.5
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 08:35:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+WIWpY0ndV9Ms9b5rY9QpfI7AS9Brky1owH34Ob3frQ=;
        b=BSH791OccSrkrSkxh2t31vogbBCFy77ql/urCa/j37KGe2/5Hb9cvZDk3YShhAkx+6
         8fnF+6c7pe9/FqXrtyCH85a/6/faFhiYTJpMfV2HJYbH/simV7CqcED4rPCC+LUNmvVz
         oekCebGoh39m2VoHjxVLvrffyl4C5lKn9ZzQ/b4GCl9W++gB/Y9/8Ed3LSwXf7woaWVf
         Djs/y8TiFZ/TzjFnJC79jx5Jh6eWMuYv9RZ8bKw5el+0MP1rLnsBHVDrMhXAj5XVLRGf
         GaiSQTDKyBHDbRTh+AJX4DqqJjStFs+hiNt0u92Ks7p1Zcf3QWS+fVVbaXhsQ6oK7KbY
         KMLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+WIWpY0ndV9Ms9b5rY9QpfI7AS9Brky1owH34Ob3frQ=;
        b=TnNC0dAYxDDrXH8b9QwtyMbCvEpGZOWOFCP4FY4gFUYECZ35MXm6WkOE0nPgwr2oL1
         T0QtuOldW4bioj9YtswuDv3BhjFrJZxavjaDfIJK6bLFwwVCwGqyCizqcWyZ65wx1lSF
         X9kJBYATq8NHfyBzi40IEf4x5CHR44n7t0P9WGt6VDXGdohsJmSC8W/5/gjOqGU6CKa4
         6rSaR8qH7Xk6pyOVt9tZXx9msqaRGqZdGNerqJ66dkUiTc/m9j545BN3xhOWMtNZb+wp
         ziu8/xYOA0IM7NjWb8svP+E7pjqbPVs/bPEks3hS3CERYzq9kVsOPVffnorRdic8J8u1
         R7nA==
X-Gm-Message-State: AO0yUKVQz9UpU0Ata79+oswnsHDwPET3fbQncJ2/gjR+XPjUyHvvo9h1
        +h6phjUaXh0wCGt4IptM0QhEODvSvOIxH63nB8RK5g==
X-Google-Smtp-Source: AK7set++Gso9IzSBLtLzVMjAwmCr7SZAAFLEvs/oCmY6sg7al29hiweRIC5X7fpVCZ+jVAdgZdHzm30S2UtU+Lrm4mc=
X-Received: by 2002:a0d:ea43:0:b0:506:38f1:918b with SMTP id
 t64-20020a0dea43000000b0050638f1918bmr496611ywe.255.1674578108308; Tue, 24
 Jan 2023 08:35:08 -0800 (PST)
MIME-Version: 1.0
References: <cover.1674526718.git.lucien.xin@gmail.com> <CANn89iKZKgzOZRj+yp-OBG=y6Lq4VZhU+c9vno=1VXixaijMWw@mail.gmail.com>
 <CADvbK_d750m=r5LDyBXHPsceo2hEtQ0y=P17DWVWfQqOm=0zSA@mail.gmail.com>
In-Reply-To: <CADvbK_d750m=r5LDyBXHPsceo2hEtQ0y=P17DWVWfQqOm=0zSA@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 24 Jan 2023 17:34:56 +0100
Message-ID: <CANn89iKX6yTPmK6ahxHa6duO1PMn=fFhAXWdYuxNsDkvh8QvLA@mail.gmail.com>
Subject: Re: [PATCHv2 net-next 00/10] net: support ipv4 big tcp
To:     Xin Long <lucien.xin@gmail.com>
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

On Tue, Jan 24, 2023 at 4:51 PM Xin Long <lucien.xin@gmail.com> wrote:
>
> On Tue, Jan 24, 2023 at 3:27 AM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Tue, Jan 24, 2023 at 3:20 AM Xin Long <lucien.xin@gmail.com> wrote:
> > >
> > > This is similar to the BIG TCP patchset added by Eric for IPv6:
> > >
> > >   https://lwn.net/Articles/895398/
> > >
> > > Different from IPv6, IPv4 tot_len is 16-bit long only, and IPv4 header
> > > doesn't have exthdrs(options) for the BIG TCP packets' length. To make
> > > it simple, as David and Paolo suggested, we set IPv4 tot_len to 0 to
> > > indicate this might be a BIG TCP packet and use skb->len as the real
> > > IPv4 total length.
> > >
> > > This will work safely, as all BIG TCP packets are GSO/GRO packets and
> > > processed on the same host as they were created; There is no padding
> > > in GSO/GRO packets, and skb->len - network_offset is exactly the IPv4
> > > packet total length; Also, before implementing the feature, all those
> > > places that may get iph tot_len from BIG TCP packets are taken care
> > > with some new APIs:
> > >
> > > Patch 1 adds some APIs for iph tot_len setting and getting, which are
> > > used in all these places where IPv4 BIG TCP packets may reach in Patch
> > > 2-8, and Patch 9 implements this feature and Patch 10 adds a selftest
> > > for it.
> > >
> > > Note that the similar change as in Patch 2-6 are also needed for IPv6
> > > BIG TCP packets, and will be addressed in another patchset.
> > >
> > > The similar performance test is done for IPv4 BIG TCP with 25Gbit NIC
> > > and 1.5K MTU:
> > >
> > > No BIG TCP:
> > > for i in {1..10}; do netperf -t TCP_RR -H 192.168.100.1 -- -r80000,80000 -O MIN_LATENCY,P90_LATENCY,P99_LATENCY,THROUGHPUT|tail -1; done
> > > 168          322          337          3776.49
> > > 143          236          277          4654.67
> > > 128          258          288          4772.83
> > > 171          229          278          4645.77
> > > 175          228          243          4678.93
> > > 149          239          279          4599.86
> > > 164          234          268          4606.94
> > > 155          276          289          4235.82
> > > 180          255          268          4418.95
> > > 168          241          249          4417.82
> > >
> >
> > NACK again
> >
> > You have not addressed my feedback.
> >
> > Given the experimental nature of BIG TCP, we need separate netlink attributes,
> > so that we can selectively enable BIG TCP for IPV6, and not for IPV4.
> >
> That will be some change, and I will try to work on it.
>
> While at it, just try to be clearer, about the fixes for IPv6 BIG TCP
> I mentioned in this patchset. Since skb->len is trustable for GSO TCP
> packets. Are you still not okay with checking the skb_ipv6_pktlen()
> API added to fix them in netfilter/tc/bridge/openvswitch?
>

Are you speaking of length_mt6() ?

Quite frankly I do not think its implementation should care of GSO or anything.

Considering the definition of this thing clearly never thought of
having big packets,
and an overflow was already possible, I do not see how you can fix it
without some hack...

struct xt_length_info {
    __u16 min, max;
    __u8 invert;
};

Something like:

diff --git a/net/netfilter/xt_length.c b/net/netfilter/xt_length.c
index 1873da3a945abbc6e8849e4555b42acdd34cff2d..90eba619cbe1d11f0fdd394f6dfda2b03fa573cd
100644
--- a/net/netfilter/xt_length.c
+++ b/net/netfilter/xt_length.c
@@ -30,8 +30,7 @@ static bool
 length_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 {
        const struct xt_length_info *info = par->matchinfo;
-       const u_int16_t pktlen = ntohs(ipv6_hdr(skb)->payload_len) +
-                                sizeof(struct ipv6hdr);
+       u32 pktlen = min_t(u32, skb->len, 65535);

        return (pktlen >= info->min && pktlen <= info->max) ^ info->invert;
 }
