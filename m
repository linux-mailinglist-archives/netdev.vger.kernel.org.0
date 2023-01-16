Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 155BE66CEC8
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 19:26:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233973AbjAPS0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 13:26:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233024AbjAPS0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 13:26:06 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC632366A
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 10:13:03 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id p24so31059421plw.11
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 10:13:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OOLidPG4k2t/KJPWtxlpT1eReQbWaTq9bHpN0zJzCfQ=;
        b=de7c+ZhDa5PmljPp9CFyPNry3W61iU/KuSGDaOdmt0AoFt8MuTXXQxV4c6GwNckV4I
         wm8S93HX8J2BY0+bCtGa5mVBoUKblbBopjkkABA5Y7RVLFLQJ5u/l6WcEujRoLMiJgbg
         lYckOX/ZFxNQZu66kb62jMmNGk2aoeCJCLwsr11jBeTdEc0ereK6ThE1jWu621yi/VN0
         dk7TsToqL9KoG5uA5tZrgkYzua5I+btAA3TrnCTMd1UjjykqbB2SeaFSkwyywJbPh0h/
         lCM4lA2grQ1YS0YZyiB+sjo7cEfFuy/uFAffKhZlTFYnPu9duaLKzSQfsSkDq4MQj308
         Uhiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OOLidPG4k2t/KJPWtxlpT1eReQbWaTq9bHpN0zJzCfQ=;
        b=wfGWj5oMdstXUN1ydMkKp7tsoCwRXRXTY8p4Lm/qRXt2rOR6YHWo0vzlnLE5UtDzK3
         A32cyrA4MjFiIBx6uVCej4aPVN+iUmO+lQnNawY5evWE/4nWBGTiSWmIBB+iMIT9C3Ii
         1J0LeMrTrXin04eSz5Z/F3Jun0QCMFeRCSfGXRT16Adb89hTyd5lA3kRcI10XQlUCz5n
         DdmtWt504AaixKYDFcepMgbx1IZtf9dayBtZdk8jqI75eX7o/sDPKgPwZ3yTMwwjPK+I
         sAdxVb8KF0rVZ7p7j1JcFuGR184LEcEEAX6KKdwrh/MWCbgvxvOQEpIAyYuRNF8jrDA2
         YUaA==
X-Gm-Message-State: AFqh2krHAyZdkVRMnBFCryZm6yzzXP6vfNHrWrRZkGQL8ec+ivoX9thL
        isg6TUh2HYepcnLlVTQmGwvedcECoGSDxGcK7FSm
X-Google-Smtp-Source: AMrXdXuaNOK0uua7VUQ1yc62bUVgcX+r2p4LzJ4PUOz2xTWSjvwukhd3fj1vRIYtBeyNqaQA/XbhaRbPenJOGFgNgWU=
X-Received: by 2002:a17:90a:c784:b0:227:202b:8eaa with SMTP id
 gn4-20020a17090ac78400b00227202b8eaamr13278pjb.147.1673892782223; Mon, 16 Jan
 2023 10:13:02 -0800 (PST)
MIME-Version: 1.0
References: <cover.1673666803.git.lucien.xin@gmail.com> <d19e0bd55ea5477d94567c00735b78d8da6a38cb.1673666803.git.lucien.xin@gmail.com>
 <CAHC9VhRXd+RkHSRLUt=0HFm42xPKGsSdSkxA6EHwipDukZH_mA@mail.gmail.com>
 <CADvbK_e_V_scDpHiGw+Qqmarw8huYYES2j8Z36KYkgT2opED3w@mail.gmail.com>
 <CAHC9VhQeaOeX-5SENhpScKN9kF1rAKoZX23KOUqQ5=uz6v92iA@mail.gmail.com> <CADvbK_cR5paEunENmWd62XfXtMSf+MHhhc-S1z_gLWp_dUx=8w@mail.gmail.com>
In-Reply-To: <CADvbK_cR5paEunENmWd62XfXtMSf+MHhhc-S1z_gLWp_dUx=8w@mail.gmail.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Mon, 16 Jan 2023 13:12:50 -0500
Message-ID: <CAHC9VhSk8pYtOJHCZ1uNvv1SJiazWkJVd1BCfyiLCXPMPKe_Pg@mail.gmail.com>
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

On Mon, Jan 16, 2023 at 12:37 PM Xin Long <lucien.xin@gmail.com> wrote:
> On Mon, Jan 16, 2023 at 11:46 AM Paul Moore <paul@paul-moore.com> wrote:
> > On Sat, Jan 14, 2023 at 12:54 PM Xin Long <lucien.xin@gmail.com> wrote:
> > > On Sat, Jan 14, 2023 at 10:39 AM Paul Moore <paul@paul-moore.com> wrote:
> > > > On Fri, Jan 13, 2023 at 10:31 PM Xin Long <lucien.xin@gmail.com> wrote:
> > > > >
> > > > > It may process IPv4 TCP GSO packets in cipso_v4_skbuff_setattr(), so
> > > > > the iph->tot_len update should use iph_set_totlen().
> > > > >
> > > > > Note that for these non GSO packets, the new iph tot_len with extra
> > > > > iph option len added may become greater than 65535, the old process
> > > > > will cast it and set iph->tot_len to it, which is a bug. In theory,
> > > > > iph options shouldn't be added for these big packets in here, a fix
> > > > > may be needed here in the future. For now this patch is only to set
> > > > > iph->tot_len to 0 when it happens.
> > > >
> > > > I'm not entirely clear on the paragraph above, but we do need to be
> > > > able to set/modify the IP options in cipso_v4_skbuff_setattr() in
> > > > order to support CIPSO labeling.  I'm open to better and/or
> > > > alternative solutions compared to what we are doing now, but I can't
> > > > support a change that is a bug waiting to bite us.  My apologies if
> > > > I'm interpreting your comments incorrectly and that isn't the case
> > > > here.
> > > setting the IP options may cause the packet size to grow (both iph->tot_len
> > > and skb->len), for example:
> > >
> > > before setting it, iph->tot_len=65535,
> > > after setting it, iph->tot_len=65535 + 14 (assume the IP option len is 14)
> > > however, tot_len is 16 bit, and can't be set to "65535 + 14".
> > >
> > > Hope the above makes it clearer.
> >
> > Thanks, it does.
> >
> > > This problem exists with or without this patch. Not sure how it should
> > > be fixed in cipso_v4 ...
> > >
> > > Not sure if we can skip the big packet, or segment/fragment the big packet
> > > in cipso_v4_skbuff_setattr().
> >
> > We can't skip the CIPSO labeling as that would be the network packet
> > equivalent of not assigning a owner/group/mode to a file on the
> > filesystem, which is a Very Bad Thing :)
> >
> > I spent a little bit of time this morning looking at the problem and I
> > think the right approach is two-fold: first introduce a simple check
> > in cipso_v4_skbuff_setattr() which returns -E2BIG if the packet length
> > grows beyond 65535.  It's rather crude, but it's a tiny patch and
> > should at least ensure that the upper layers (NetLabel and SELinux)
> > don't send the packet with a bogus length field; it will result in
> > packet drops, but honestly that seems preferable to a mangled packet
> > which will likely be dropped at some point in the network anyway.
> >
> > diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
> > index 6cd3b6c559f0..f19c9beda745 100644
> > --- a/net/ipv4/cipso_ipv4.c
> > +++ b/net/ipv4/cipso_ipv4.c
> > @@ -2183,8 +2183,10 @@ int cipso_v4_skbuff_setattr(struct sk_buff *skb,
> >         * that the security label is applied to the packet - we do the same
> >         * thing when using the socket options and it hasn't caused a problem,
> >         * if we need to we can always revisit this choice later */
> > -
> >        len_delta = opt_len - opt->optlen;
> > +       if ((skb->len + len_delta) > 65535)
> > +               return -E2BIG;
> > +
>
> Right, looks crude. :-)

Yes, but what else can we do?  There is fragmentation, but that is
rather ugly and we would still need a solution for when the don't
fragment bit is set.  I'm open to suggestions.

> Note that for BIG TCP packets skb->len is bigger than 65535.
> (I assume CIPSO labeling will drop BIG TCP packets.)

It seems like there is still ongoing discussion about even enabling
BIG TCP for IPv4, however for this discussion let's assume that BIG
TCP is merged for IPv4.

We really should have a solution that allows CIPSO for both normal and
BIG TCP, if we don't we force distros and admins to choose between the
two and that isn't good.  We should do better.  If skb->len > 64k in
the case of BIG TCP, how is the packet eventually divided/fragmented
in such a way that the total length field in the IPv4 header doesn't
overflow?  Or is that simply handled at the driver/device layer and we
simply set skb->len to whatever the size is, regardless of the 16-bit
length limit?  If that is the case, does the driver/device layer
handle copying the IPv4 options and setting the header/total-length
fields in each packet?  Or is it something else completely?

> >        /* if we don't ensure enough headroom we could panic on the skb_push()
> >         * call below so make sure we have enough, we are also "mangling" the
> >         * packet so we should probably do a copy-on-write call anyway */
> >
> > The second step will be to add a max-length IPv4 option filled with
> > IPOPT_NOOP to the local sockets in the case of
> > netlbl_sock_setattr()/NETLBL_NLTYPE_ADDRSELECT.  In this case we would
> > either end up replacing the padding with a proper CIPSO option or
> > removing it completely in netlbl_skbuff_setattr(); in either case the
> > total packet length remains the same or decreases so we should be
> > "safe".
>
> sounds better.

To be clear, it's not a one-or-the-other choice, both patches would be
necessary as the padding route described in the second step would only
apply to traffic generated locally from a socket.  We still have the
ugly problem of dealing with forwarded traffic, which it looks like we
discuss more on that below ...

> > The forwarded packet case is still a bit of an issue, but I think the
> > likelihood of someone using 64k max-size IPv4 packets on the wire
> > *and* passing this traffic through a Linux cross-domain router with
> > CIPSO (re)labeling is about as close to zero as one can possibly get.
> > At least given the size check present in step one (patchlet above) the
> > packet will be safely (?) dropped on the Linux system so an admin will
> > have some idea where to start looking.
>
> don't know the likelihood of CIPSO (re)labeling on a Linux cross-domain router.
> But 64K packets could be GRO packets merged on the interface (GRO enabled)
> of the router, not directly from the wire.

In the GRO case, is it safe to grow the packet such that skb->len is
greater than 64k?  I presume that the device/driver is going to split
the packet anyway and populate the IPv4 total length fields in the
header anyway, right?  If we can't grow the packet beyond 64k, is
there some way to signal to the driver/device at runtime that the
largest packet we can process is 64k minus 40 bytes (for the IPv4
options)?

> > I've got some basic patches written for both, but I need to at least
> > give them a quick sanity test before posting.
>
> Good that you can take care of it from the security side.

It's not yet clear to me that we can, see the above questions.

> I think a similar problem exists in calipso_skbuff_setattr() in
> net/ipv6/calipso.c.

Probably, but one mess at a time, especially since several of the
questions above apply to both IPv4 and IPv6.

-- 
paul-moore.com
