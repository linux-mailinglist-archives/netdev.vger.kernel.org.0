Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 598D567A01B
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 18:26:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233302AbjAXR0E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 12:26:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233149AbjAXR0D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 12:26:03 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D589249011
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 09:26:02 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id a9so19784000ybb.3
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 09:26:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hRaqCqR7RIwDhw+WiyMJ4YfG2UJESa35+M5vhF1uVlM=;
        b=OmDH5KaDdrJ5gSmaKv5d2S1Bgkdqm9/aRf/+g/8YbsNBSX5Nv4whPqhtPtMztxgEl+
         6yhh2oOvfRt1OzHgUu4OxUxurj4lmsMv8I/nyCpukzwvitNLkTHv54ncQKr/Ce+bD2IK
         aOYNBO7LH5nzG5HeoqKK2hKl8BBbrfsbpDY/R7UHdZ88YYQL8QunqacdqzlPG3t6hS8B
         NMeFUVKWwU4CBSOEwyVnvHYAf2vzb0fasTsoSjXgnBBTNbG0kVNxLv0qXpI15OGVun8l
         YdkvU7LJrOQbO4fZbRqB/z5fwtDPo1zN4fv0hrbfc6U3kgMbZwKXnxVmh0CX7Tvge741
         /Kxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hRaqCqR7RIwDhw+WiyMJ4YfG2UJESa35+M5vhF1uVlM=;
        b=eIfufjrUnlEGfgr9hUeE6VBs9NbEqfjq+djQhzsJoIjOSdZr5sr5n558vvxS54BvrC
         K6DZFarxf6y2DfaEJeVkP3ntoMDXonCnCM0N7rO/LAI9ei2WMlmGUtCIFPEPxN4dNlDi
         fTcpuZ3hTBuJ6EW8WEJUFqPug7sgvqaM+2cmyA5Wt7UgURIl+zBILjPPIPTojrtQa0Ws
         7XtXMaz70HrU0D+ZSIb7W9f7N/pTLQr0PdXdl64WI66/2gMXzM0yUkF5lqTWeN9BBNTP
         Jf5AjM15lDrlSwn833nwYqAFpWdrCSKBvOlAQ+7x5fbnwh1LNSVi3piUJRPamJFykWLv
         WRmQ==
X-Gm-Message-State: AFqh2kpml1HsaMg01hepnV0M87rBP3MKqFAB1/dkL0TgYDhJ6dhCFo8N
        9Pg5FYItH1UtBGt77IsjJ3g/TZCBWCIYOfRJtY65tTyLfpKCLlMeApY=
X-Google-Smtp-Source: AMrXdXsnIPbQa+KdwfIMOG3WanLzr6bfbKlJsNa94zAaCu30oPnleIv+s0KHpd2eVtIJEg5Q/9FCNgFVDTSRaMb+DBU=
X-Received: by 2002:a25:fd4:0:b0:803:fbad:94a4 with SMTP id
 203-20020a250fd4000000b00803fbad94a4mr1532785ybp.407.1674581161703; Tue, 24
 Jan 2023 09:26:01 -0800 (PST)
MIME-Version: 1.0
References: <cover.1674526718.git.lucien.xin@gmail.com> <CANn89iKZKgzOZRj+yp-OBG=y6Lq4VZhU+c9vno=1VXixaijMWw@mail.gmail.com>
 <CADvbK_d750m=r5LDyBXHPsceo2hEtQ0y=P17DWVWfQqOm=0zSA@mail.gmail.com>
 <CANn89iKX6yTPmK6ahxHa6duO1PMn=fFhAXWdYuxNsDkvh8QvLA@mail.gmail.com> <CADvbK_ePmmWt-QfCaAC2S5B03V+CTK1c=Ewya+O+ry5yjz13yw@mail.gmail.com>
In-Reply-To: <CADvbK_ePmmWt-QfCaAC2S5B03V+CTK1c=Ewya+O+ry5yjz13yw@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 24 Jan 2023 18:25:50 +0100
Message-ID: <CANn89iJbL2wyZTiS3Sz9AkS47C+euKdef8BBK0gPUR+9RAp8RQ@mail.gmail.com>
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

On Tue, Jan 24, 2023 at 6:14 PM Xin Long <lucien.xin@gmail.com> wrote:
>
> On Tue, Jan 24, 2023 at 11:35 AM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Tue, Jan 24, 2023 at 4:51 PM Xin Long <lucien.xin@gmail.com> wrote:
> > >
> > > On Tue, Jan 24, 2023 at 3:27 AM Eric Dumazet <edumazet@google.com> wrote:
> > > >
> > > > On Tue, Jan 24, 2023 at 3:20 AM Xin Long <lucien.xin@gmail.com> wrote:
> > > > >
> > > > > This is similar to the BIG TCP patchset added by Eric for IPv6:
> > > > >
> > > > >   https://lwn.net/Articles/895398/
> > > > >
> > > > > Different from IPv6, IPv4 tot_len is 16-bit long only, and IPv4 header
> > > > > doesn't have exthdrs(options) for the BIG TCP packets' length. To make
> > > > > it simple, as David and Paolo suggested, we set IPv4 tot_len to 0 to
> > > > > indicate this might be a BIG TCP packet and use skb->len as the real
> > > > > IPv4 total length.
> > > > >
> > > > > This will work safely, as all BIG TCP packets are GSO/GRO packets and
> > > > > processed on the same host as they were created; There is no padding
> > > > > in GSO/GRO packets, and skb->len - network_offset is exactly the IPv4
> > > > > packet total length; Also, before implementing the feature, all those
> > > > > places that may get iph tot_len from BIG TCP packets are taken care
> > > > > with some new APIs:
> > > > >
> > > > > Patch 1 adds some APIs for iph tot_len setting and getting, which are
> > > > > used in all these places where IPv4 BIG TCP packets may reach in Patch
> > > > > 2-8, and Patch 9 implements this feature and Patch 10 adds a selftest
> > > > > for it.
> > > > >
> > > > > Note that the similar change as in Patch 2-6 are also needed for IPv6
> > > > > BIG TCP packets, and will be addressed in another patchset.
> > > > >
> > > > > The similar performance test is done for IPv4 BIG TCP with 25Gbit NIC
> > > > > and 1.5K MTU:
> > > > >
> > > > > No BIG TCP:
> > > > > for i in {1..10}; do netperf -t TCP_RR -H 192.168.100.1 -- -r80000,80000 -O MIN_LATENCY,P90_LATENCY,P99_LATENCY,THROUGHPUT|tail -1; done
> > > > > 168          322          337          3776.49
> > > > > 143          236          277          4654.67
> > > > > 128          258          288          4772.83
> > > > > 171          229          278          4645.77
> > > > > 175          228          243          4678.93
> > > > > 149          239          279          4599.86
> > > > > 164          234          268          4606.94
> > > > > 155          276          289          4235.82
> > > > > 180          255          268          4418.95
> > > > > 168          241          249          4417.82
> > > > >
> > > >
> > > > NACK again
> > > >
> > > > You have not addressed my feedback.
> > > >
> > > > Given the experimental nature of BIG TCP, we need separate netlink attributes,
> > > > so that we can selectively enable BIG TCP for IPV6, and not for IPV4.
> > > >
> > > That will be some change, and I will try to work on it.
> > >
> > > While at it, just try to be clearer, about the fixes for IPv6 BIG TCP
> > > I mentioned in this patchset. Since skb->len is trustable for GSO TCP
> > > packets. Are you still not okay with checking the skb_ipv6_pktlen()
> > > API added to fix them in netfilter/tc/bridge/openvswitch?
> > >
> >
> > Are you speaking of length_mt6() ?
> Yes, but not only there, see also:
>
> [1]:
> dump_ipv6_packet()
> nf_ct_bridge_pre()
> ovs_skb_network_trim()/tcf_ct_skb_network_trim()
> cake_ack_filter()
>
> These places get pktlen directly from ipv6_hdr(skb)->payload_len.

dump_ipv6_packet() is right if its intent is to 'dump header values'
If jumbo is not yet parsed, this should be added.

cake_ack_filter() depends on receiving non malicious packets, which is
not guaranteed.

Special casing GSO seems the wrong way to fix buggy spots like these.
