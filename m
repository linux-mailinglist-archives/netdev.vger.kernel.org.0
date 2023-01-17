Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C18CB66E871
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 22:30:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbjAQV34 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 16:29:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbjAQV3M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 16:29:12 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5AAC55280
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 11:51:55 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id z3so128871pfb.2
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 11:51:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=40idOBW7gst++SEGq9xCV+9wVReBq2NIJIu3QdfZwfI=;
        b=c3Q/iJqm8IUGGv6XVF56oVYBMV0jpUWf2lT0YTWOVuN5F+JseQC9hY6uWGPtHqoMbQ
         wB1rOdAD0YG38t8PJwGp0kK22l04LTyK6LznTc/G6OyPZhVQQhBrngcUJP7GvRLkznyl
         XZdNI1fTWdQEYF8KDMPXxr3snC2ejyOFB9L0tS9gc8JrDGbq+Vz2+g86o8IfeTCZmZ6l
         KFpP9PwCPJGnzkyiUdWe4/0MgS8xeilgci68+fBy6BLGoJgFF0OJM8m2f4wCkemQ3Rll
         xSXkig+O0MLk21Wras8gXCBi5R+KVczyzx4lxzmmxDkCA/+Os1lxcgFEBsv2sa2SLW4D
         PWbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=40idOBW7gst++SEGq9xCV+9wVReBq2NIJIu3QdfZwfI=;
        b=aSdb2t7fFgC8w8+h6fRlQZNMP1xOi44+q8oBQpjpn+rdn7fVOGMgFHjYA1NKLOLyuR
         ONNKWPT7r7PuLaErTSGjCom1qHAOF6t4ZurQ4Du7xCDlbZytzTarrOw4nOStqedZM1qw
         J0FSWmo4+Teg/lDjgNUsXGzSR3LaWV4hh4S1OyMs5BYTMjsn0n8DmsnsmsokEDlSHP/m
         eZDY5kV0ZjRBc/0Dj1jrasyEgG8KPmNk1AN4u2ApGc4EpgD2f3bhWUZuzGlwz03t3m+0
         lo7tNuqi5uGaVcIQ9n/Inm72o57FcrowlmJvbMTYbO575N+dG/ovV3IK/6tJW76VYe+E
         3Nkg==
X-Gm-Message-State: AFqh2koGdCv/sDuE3Wje0dqOkttfwfLBEJ152xoqUKTYjiltfDimV3SJ
        5tUfgKwS336/kUEjMiOkBm1JnAWA+nUllujUkzAf
X-Google-Smtp-Source: AMrXdXuMCt3DbvSHOrQ9BXAyjcsUSFuj7WuMqUlrFG9DMcvKemHY+hbWmKPPZbU5F+Iqw4i2YfPY+N6Um6ECx1t2qHI=
X-Received: by 2002:a63:6e82:0:b0:4c7:ac8f:9e9c with SMTP id
 j124-20020a636e82000000b004c7ac8f9e9cmr275583pgc.92.1673985115074; Tue, 17
 Jan 2023 11:51:55 -0800 (PST)
MIME-Version: 1.0
References: <cover.1673666803.git.lucien.xin@gmail.com> <d19e0bd55ea5477d94567c00735b78d8da6a38cb.1673666803.git.lucien.xin@gmail.com>
 <CAHC9VhRXd+RkHSRLUt=0HFm42xPKGsSdSkxA6EHwipDukZH_mA@mail.gmail.com>
 <CADvbK_e_V_scDpHiGw+Qqmarw8huYYES2j8Z36KYkgT2opED3w@mail.gmail.com>
 <CAHC9VhQeaOeX-5SENhpScKN9kF1rAKoZX23KOUqQ5=uz6v92iA@mail.gmail.com>
 <CADvbK_cR5paEunENmWd62XfXtMSf+MHhhc-S1z_gLWp_dUx=8w@mail.gmail.com>
 <CAHC9VhSk8pYtOJHCZ1uNvv1SJiazWkJVd1BCfyiLCXPMPKe_Pg@mail.gmail.com> <CADvbK_ds4ixHgPGA4iKb1kkFc=SF8SXPM-ZL-kb-ZA0B-70Xqg@mail.gmail.com>
In-Reply-To: <CADvbK_ds4ixHgPGA4iKb1kkFc=SF8SXPM-ZL-kb-ZA0B-70Xqg@mail.gmail.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 17 Jan 2023 14:51:43 -0500
Message-ID: <CAHC9VhR4_ae=QzrUUM=1MZTWJ9MQom0fEAME3b+z+uBrA8PpcQ@mail.gmail.com>
Subject: Re: [PATCH net-next 06/10] cipso_ipv4: use iph_set_totlen in skbuff_setattr
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
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
        Guillaume Nault <gnault@redhat.com>,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 16, 2023 at 2:35 PM Xin Long <lucien.xin@gmail.com> wrote:
> On Mon, Jan 16, 2023 at 1:13 PM Paul Moore <paul@paul-moore.com> wrote:
> > On Mon, Jan 16, 2023 at 12:37 PM Xin Long <lucien.xin@gmail.com> wrote:
> > > On Mon, Jan 16, 2023 at 11:46 AM Paul Moore <paul@paul-moore.com> wrote:
> > > > On Sat, Jan 14, 2023 at 12:54 PM Xin Long <lucien.xin@gmail.com> wrote:
> > > > > On Sat, Jan 14, 2023 at 10:39 AM Paul Moore <paul@paul-moore.com> wrote:
> > > > > > On Fri, Jan 13, 2023 at 10:31 PM Xin Long <lucien.xin@gmail.com> wrote:

...

> > > > We can't skip the CIPSO labeling as that would be the network packet
> > > > equivalent of not assigning a owner/group/mode to a file on the
> > > > filesystem, which is a Very Bad Thing :)
> > > >
> > > > I spent a little bit of time this morning looking at the problem and I
> > > > think the right approach is two-fold: first introduce a simple check
> > > > in cipso_v4_skbuff_setattr() which returns -E2BIG if the packet length
> > > > grows beyond 65535.  It's rather crude, but it's a tiny patch and
> > > > should at least ensure that the upper layers (NetLabel and SELinux)
> > > > don't send the packet with a bogus length field; it will result in
> > > > packet drops, but honestly that seems preferable to a mangled packet
> > > > which will likely be dropped at some point in the network anyway.
> > > >
> > > > diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
> > > > index 6cd3b6c559f0..f19c9beda745 100644
> > > > --- a/net/ipv4/cipso_ipv4.c
> > > > +++ b/net/ipv4/cipso_ipv4.c
> > > > @@ -2183,8 +2183,10 @@ int cipso_v4_skbuff_setattr(struct sk_buff *skb,
> > > >         * that the security label is applied to the packet - we do the same
> > > >         * thing when using the socket options and it hasn't caused a problem,
> > > >         * if we need to we can always revisit this choice later */
> > > > -
> > > >        len_delta = opt_len - opt->optlen;
> > > > +       if ((skb->len + len_delta) > 65535)
> > > > +               return -E2BIG;
> > > > +
> > >
> > > Right, looks crude. :-)
> >
> > Yes, but what else can we do?  There is fragmentation, but that is
> > rather ugly and we would still need a solution for when the don't
> > fragment bit is set.  I'm open to suggestions.
>
> looking at ovs_dp_upcall(), for GSO/GRO packets it goes to
> queue_gso_packets() where it calls __skb_gso_segment()
> to segment it into small segs/skbs, then process these segs instead.
>
> I'm thinking you can try to do the same in cipso_v4_skbuff_setattr(),
> and I don't think 64K non-GSO packets exist in the user environment,
> so taking care of GSO packets should be enough.

Thanks, I'll take a look.

> I just don't know if the security_hook will be able to process these
> smaller segs/skbs after the segment.

As long as the smaller, segmented packets have the IPv4 options
preserved/copied on each smaller packet it should be okay.

> > It seems like there is still ongoing discussion about even enabling
> > BIG TCP for IPv4, however for this discussion let's assume that BIG
> > TCP is merged for IPv4.
> >
> > We really should have a solution that allows CIPSO for both normal and
> > BIG TCP, if we don't we force distros and admins to choose between the
> > two and that isn't good.  We should do better.  If skb->len > 64k in
> > the case of BIG TCP, how is the packet eventually divided/fragmented
> > in such a way that the total length field in the IPv4 header doesn't
> > overflow?  Or is that simply handled at the driver/device layer and we
> > simply set skb->len to whatever the size is, regardless of the 16-bit
>
> Yes, for BIG TCP, 16-bit length is set to 0, and it just uses skb->len
> as the IP packet length.

In the BIG TCP case, when is the IPv4 header zero'd out?  Currently
cipso_v4_skbuff_setattr() is called in the NF_INET_LOCAL_OUT and
NF_INET_FORWARD chains, is there an easy way to distinguish between a
traditional segmentation offload mechanism, e.g. GSO, and BIG TCP?  If
BIG TCP allows for arbitrarily large packets we can just grow the
skb->len value as needed and leave the total length field in the IPv4
header untouched/zero, but we would need to be able to distinguish
between a segmentation offload and BIG TCP.

> > In the GRO case, is it safe to grow the packet such that skb->len is
> > greater than 64k?  I presume that the device/driver is going to split
> > the packet anyway and populate the IPv4 total length fields in the
> > header anyway, right?  If we can't grow the packet beyond 64k, is
> > there some way to signal to the driver/device at runtime that the
> > largest packet we can process is 64k minus 40 bytes (for the IPv4
> > options)?
>
> at runtime, not as far as I know.
> It's a field of the network device that can be modified by:
> # ip link set dev eth0 gro_max_size $MAX_SIZE gso_max_size $MAX_SIZE

I need to look at the OVS case above, but one possibility would be to
have the kernel adjust the GSO size down by 40 bytes when
CONFIG_NETLABEL is enabled, but that isn't a great option, and not
something I consider a first (or second) choice.

-- 
paul-moore.com
