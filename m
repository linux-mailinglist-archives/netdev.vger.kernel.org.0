Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 174AB679DFB
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 16:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233650AbjAXPvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 10:51:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232788AbjAXPvs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 10:51:48 -0500
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AD41360BA
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 07:51:46 -0800 (PST)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-4a2f8ad29d5so223832237b3.8
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 07:51:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mMjovDh1cKqbTJ/U3z5vmKOvnxG9VKQrQ6uLkkAlvmQ=;
        b=IW1vCYgdmp/zeo6Ws1lcIlthbkCnzqH2ZY7pfkur83xWWx2xpF+MncQblRy2ufv0Mn
         hyCRWHxJXjr+J3e/i728T2kAf15G4XSf0ksC3ZOPhpDAg5va3EF9lHpGdLL6EEAIA3xE
         +AHSv2dnNK5RvdEhXoU1+QY28VHhqYqW86/9knDbpeCtPbvz/ejNVvh78SBt6ts21mcE
         xOnxdfIklxyuJLOeGDQv/gK0yElmB4aMx4hrvTtGYPTbNfmI45X4ArAcNJ/x1br1Xkee
         ucOPYUoqEJ3NRooRKkmIvJkg6U67sRjXBDDc/pep78h8gNGAGW4nezCYVHJ3Ex1wKlOa
         uVog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mMjovDh1cKqbTJ/U3z5vmKOvnxG9VKQrQ6uLkkAlvmQ=;
        b=fwCeT7Ti/CUaIqxlvklLmUZRV8+QdINytVwQlKICHsHAPR9w/EfcLIc8YSLw32SMMr
         UDz0GkrYjGNEVw6E7hgKe6mj+GPCJary6QibJk0X6k0wyIFYjgEppJ2z7BP0af8Vpe03
         Jiztb7+q1Wgdj+fNJ5qHXk+uZIkDO1+GijqX06yO5HSVwS1qSPM1Jrfrm9+eqDYucIco
         xbYfAhe62rmMIpawAVgnmn4SILdvn371cbJfy+yJBh2ftQsSGdvkLfhr2jnwg6C2Ohw1
         FenC2wXUKUL7Tq3rg+okdSf+YDs79qRqxKa2hRVnTeaK4gpZgXAEFdjwK5B0xwlWtay0
         4Aqw==
X-Gm-Message-State: AFqh2kre4V3ZFUb/hmXKqEcvm29wHDifVHkCyZiv9Y7dRBAwWodR6xcc
        2bjs53ahqBXZNwI9OLGTGQVgZK2kOZDlcVA9Z7w=
X-Google-Smtp-Source: AMrXdXuzKkcTMQnx3dV8neWdoHaeHegclEe3NmiiWXDW/NWjTjduxHds27c/6XGp7R+I/1ztOBzuY3IcAc70Gvl8m+M=
X-Received: by 2002:a81:1252:0:b0:4db:1b7:54b8 with SMTP id
 79-20020a811252000000b004db01b754b8mr3577219yws.449.1674575505787; Tue, 24
 Jan 2023 07:51:45 -0800 (PST)
MIME-Version: 1.0
References: <cover.1674526718.git.lucien.xin@gmail.com> <CANn89iKZKgzOZRj+yp-OBG=y6Lq4VZhU+c9vno=1VXixaijMWw@mail.gmail.com>
In-Reply-To: <CANn89iKZKgzOZRj+yp-OBG=y6Lq4VZhU+c9vno=1VXixaijMWw@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 24 Jan 2023 10:51:33 -0500
Message-ID: <CADvbK_d750m=r5LDyBXHPsceo2hEtQ0y=P17DWVWfQqOm=0zSA@mail.gmail.com>
Subject: Re: [PATCHv2 net-next 00/10] net: support ipv4 big tcp
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

On Tue, Jan 24, 2023 at 3:27 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Tue, Jan 24, 2023 at 3:20 AM Xin Long <lucien.xin@gmail.com> wrote:
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
> > 2-8, and Patch 9 implements this feature and Patch 10 adds a selftest
> > for it.
> >
> > Note that the similar change as in Patch 2-6 are also needed for IPv6
> > BIG TCP packets, and will be addressed in another patchset.
> >
> > The similar performance test is done for IPv4 BIG TCP with 25Gbit NIC
> > and 1.5K MTU:
> >
> > No BIG TCP:
> > for i in {1..10}; do netperf -t TCP_RR -H 192.168.100.1 -- -r80000,80000 -O MIN_LATENCY,P90_LATENCY,P99_LATENCY,THROUGHPUT|tail -1; done
> > 168          322          337          3776.49
> > 143          236          277          4654.67
> > 128          258          288          4772.83
> > 171          229          278          4645.77
> > 175          228          243          4678.93
> > 149          239          279          4599.86
> > 164          234          268          4606.94
> > 155          276          289          4235.82
> > 180          255          268          4418.95
> > 168          241          249          4417.82
> >
>
> NACK again
>
> You have not addressed my feedback.
>
> Given the experimental nature of BIG TCP, we need separate netlink attributes,
> so that we can selectively enable BIG TCP for IPV6, and not for IPV4.
>
That will be some change, and I will try to work on it.

While at it, just try to be clearer, about the fixes for IPv6 BIG TCP
I mentioned in this patchset. Since skb->len is trustable for GSO TCP
packets. Are you still not okay with checking the skb_ipv6_pktlen()
API added to fix them in netfilter/tc/bridge/openvswitch?

Thanks.
