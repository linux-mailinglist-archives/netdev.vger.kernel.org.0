Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24BFE66CF96
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 20:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233741AbjAPTfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 14:35:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232033AbjAPTfM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 14:35:12 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3040265AD;
        Mon, 16 Jan 2023 11:35:10 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id e202so8051322ybh.11;
        Mon, 16 Jan 2023 11:35:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KMPLH0tcsV7ysQ/ZKecHZ9s4Ah42akaniQfufWerNXI=;
        b=BPju0L7di1DiAIg0hHK/FV/lcUSPRwjZV52iIbvGjMTI8kmLC836dU+p8wMYSUp6OG
         i8dhrVHZpJnm1nA0vopU/vQfD9w0GuyVyOSodkAqCCNptlML97oUJ2r7hCXoC5avTcLe
         Irz3857HGebCXocHGQjUX6YNineoO1nEWbrhMopcEpEGcp7POur6BFI11q1gb/RUjzfy
         nVceXLjF0Uz4rRqXJHhwacmnV+Bo4niYsZZqCuiA7wRqf+OIp2jni8z6VJYUatn1b5ys
         kp/J7eXjsE+lELd8U/VxSu4wVfJUbTBIqR3BdQkV5s3NGDWzutcOCBvtrE/QmMo8CKDx
         OTgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KMPLH0tcsV7ysQ/ZKecHZ9s4Ah42akaniQfufWerNXI=;
        b=30BUpt825Tb17yPM8f0MIkqr5Qa4LoUOkxiSaRpsilyiwsP37H6VmMNzX4AuThX6ME
         T6cxelOG4daRArcWZgeqb0e5KzNi0ASNdvpGRFsT2sYsVUrhqIIt1EK931B2Iu8yNU78
         5zk9nj43rVkBXv6DIPrMxnxYky4GW7CR2k8kfyuG9jCfdlNPEIOXDQplt/w2ky+TTu+b
         kQgOcZVTFxezXXbzx0+rSOdojTumC6ijMcHK621uxjmpVmo0BaswpAyQYZ1a0WZYV+u/
         R0sI1UzofejXo6DqTOcP+TWvE1iS69NrnK4/X/xbp/lAaIkiGjfiESoWnB1on6O8Y1Yy
         th+A==
X-Gm-Message-State: AFqh2kqTFkq0EU4711EXL6h66u86L3wtyDiNGiyCLz2gJXtNC6OxamDi
        PkGKjthSzc35NhsWTCIPVMWWGcXku3kWa1J3VrT6bR7rdwzcSA==
X-Google-Smtp-Source: AMrXdXtnG75LfiiJAXgV87cUvDQmZOdq4/xde0mHLXm4iDgs5/qJP006e0U5kXk+zwqLVuL9xd3pb6SVwmmr6Ej6P7E=
X-Received: by 2002:a25:d15:0:b0:7dd:57a3:4bb8 with SMTP id
 21-20020a250d15000000b007dd57a34bb8mr85642ybn.27.1673897710098; Mon, 16 Jan
 2023 11:35:10 -0800 (PST)
MIME-Version: 1.0
References: <cover.1673666803.git.lucien.xin@gmail.com> <d19e0bd55ea5477d94567c00735b78d8da6a38cb.1673666803.git.lucien.xin@gmail.com>
 <CAHC9VhRXd+RkHSRLUt=0HFm42xPKGsSdSkxA6EHwipDukZH_mA@mail.gmail.com>
 <CADvbK_e_V_scDpHiGw+Qqmarw8huYYES2j8Z36KYkgT2opED3w@mail.gmail.com>
 <CAHC9VhQeaOeX-5SENhpScKN9kF1rAKoZX23KOUqQ5=uz6v92iA@mail.gmail.com>
 <CADvbK_cR5paEunENmWd62XfXtMSf+MHhhc-S1z_gLWp_dUx=8w@mail.gmail.com> <CAHC9VhSk8pYtOJHCZ1uNvv1SJiazWkJVd1BCfyiLCXPMPKe_Pg@mail.gmail.com>
In-Reply-To: <CAHC9VhSk8pYtOJHCZ1uNvv1SJiazWkJVd1BCfyiLCXPMPKe_Pg@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Mon, 16 Jan 2023 14:33:50 -0500
Message-ID: <CADvbK_ds4ixHgPGA4iKb1kkFc=SF8SXPM-ZL-kb-ZA0B-70Xqg@mail.gmail.com>
Subject: Re: [PATCH net-next 06/10] cipso_ipv4: use iph_set_totlen in skbuff_setattr
To:     Paul Moore <paul@paul-moore.com>
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
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 16, 2023 at 1:13 PM Paul Moore <paul@paul-moore.com> wrote:
>
> On Mon, Jan 16, 2023 at 12:37 PM Xin Long <lucien.xin@gmail.com> wrote:
> > On Mon, Jan 16, 2023 at 11:46 AM Paul Moore <paul@paul-moore.com> wrote:
> > > On Sat, Jan 14, 2023 at 12:54 PM Xin Long <lucien.xin@gmail.com> wrote:
> > > > On Sat, Jan 14, 2023 at 10:39 AM Paul Moore <paul@paul-moore.com> wrote:
> > > > > On Fri, Jan 13, 2023 at 10:31 PM Xin Long <lucien.xin@gmail.com> wrote:
> > > > > >
> > > > > > It may process IPv4 TCP GSO packets in cipso_v4_skbuff_setattr(), so
> > > > > > the iph->tot_len update should use iph_set_totlen().
> > > > > >
> > > > > > Note that for these non GSO packets, the new iph tot_len with extra
> > > > > > iph option len added may become greater than 65535, the old process
> > > > > > will cast it and set iph->tot_len to it, which is a bug. In theory,
> > > > > > iph options shouldn't be added for these big packets in here, a fix
> > > > > > may be needed here in the future. For now this patch is only to set
> > > > > > iph->tot_len to 0 when it happens.
> > > > >
> > > > > I'm not entirely clear on the paragraph above, but we do need to be
> > > > > able to set/modify the IP options in cipso_v4_skbuff_setattr() in
> > > > > order to support CIPSO labeling.  I'm open to better and/or
> > > > > alternative solutions compared to what we are doing now, but I can't
> > > > > support a change that is a bug waiting to bite us.  My apologies if
> > > > > I'm interpreting your comments incorrectly and that isn't the case
> > > > > here.
> > > > setting the IP options may cause the packet size to grow (both iph->tot_len
> > > > and skb->len), for example:
> > > >
> > > > before setting it, iph->tot_len=65535,
> > > > after setting it, iph->tot_len=65535 + 14 (assume the IP option len is 14)
> > > > however, tot_len is 16 bit, and can't be set to "65535 + 14".
> > > >
> > > > Hope the above makes it clearer.
> > >
> > > Thanks, it does.
> > >
> > > > This problem exists with or without this patch. Not sure how it should
> > > > be fixed in cipso_v4 ...
> > > >
> > > > Not sure if we can skip the big packet, or segment/fragment the big packet
> > > > in cipso_v4_skbuff_setattr().
> > >
> > > We can't skip the CIPSO labeling as that would be the network packet
> > > equivalent of not assigning a owner/group/mode to a file on the
> > > filesystem, which is a Very Bad Thing :)
> > >
> > > I spent a little bit of time this morning looking at the problem and I
> > > think the right approach is two-fold: first introduce a simple check
> > > in cipso_v4_skbuff_setattr() which returns -E2BIG if the packet length
> > > grows beyond 65535.  It's rather crude, but it's a tiny patch and
> > > should at least ensure that the upper layers (NetLabel and SELinux)
> > > don't send the packet with a bogus length field; it will result in
> > > packet drops, but honestly that seems preferable to a mangled packet
> > > which will likely be dropped at some point in the network anyway.
> > >
> > > diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
> > > index 6cd3b6c559f0..f19c9beda745 100644
> > > --- a/net/ipv4/cipso_ipv4.c
> > > +++ b/net/ipv4/cipso_ipv4.c
> > > @@ -2183,8 +2183,10 @@ int cipso_v4_skbuff_setattr(struct sk_buff *skb,
> > >         * that the security label is applied to the packet - we do the same
> > >         * thing when using the socket options and it hasn't caused a problem,
> > >         * if we need to we can always revisit this choice later */
> > > -
> > >        len_delta = opt_len - opt->optlen;
> > > +       if ((skb->len + len_delta) > 65535)
> > > +               return -E2BIG;
> > > +
> >
> > Right, looks crude. :-)
>
> Yes, but what else can we do?  There is fragmentation, but that is
> rather ugly and we would still need a solution for when the don't
> fragment bit is set.  I'm open to suggestions.
looking at ovs_dp_upcall(), for GSO/GRO packets it goes to
queue_gso_packets() where it calls __skb_gso_segment()
to segment it into small segs/skbs, then process these segs instead.

I'm thinking you can try to do the same in cipso_v4_skbuff_setattr(),
and I don't think 64K non-GSO packets exist in the user environment,
so taking care of GSO packets should be enough.

I just don't know if the security_hook will be able to process these
smaller segs/skbs after the segment.

>
> > Note that for BIG TCP packets skb->len is bigger than 65535.
> > (I assume CIPSO labeling will drop BIG TCP packets.)
>
> It seems like there is still ongoing discussion about even enabling
> BIG TCP for IPv4, however for this discussion let's assume that BIG
> TCP is merged for IPv4.
>
> We really should have a solution that allows CIPSO for both normal and
> BIG TCP, if we don't we force distros and admins to choose between the
> two and that isn't good.  We should do better.  If skb->len > 64k in
> the case of BIG TCP, how is the packet eventually divided/fragmented
> in such a way that the total length field in the IPv4 header doesn't
> overflow?  Or is that simply handled at the driver/device layer and we
> simply set skb->len to whatever the size is, regardless of the 16-bit
Yes, for BIG TCP, 16-bit length is set to 0, and it just uses skb->len
as the IP packet length.

> length limit?  If that is the case, does the driver/device layer
> handle copying the IPv4 options and setting the header/total-length
> fields in each packet?  Or is it something else completely?
Yes, I think the driver/device layer will handle copying the IPv4 options
and setting the header/total-length, and that's how it works.

>
> > >        /* if we don't ensure enough headroom we could panic on the skb_push()
> > >         * call below so make sure we have enough, we are also "mangling" the
> > >         * packet so we should probably do a copy-on-write call anyway */
> > >
> > > The second step will be to add a max-length IPv4 option filled with
> > > IPOPT_NOOP to the local sockets in the case of
> > > netlbl_sock_setattr()/NETLBL_NLTYPE_ADDRSELECT.  In this case we would
> > > either end up replacing the padding with a proper CIPSO option or
> > > removing it completely in netlbl_skbuff_setattr(); in either case the
> > > total packet length remains the same or decreases so we should be
> > > "safe".
> >
> > sounds better.
>
> To be clear, it's not a one-or-the-other choice, both patches would be
> necessary as the padding route described in the second step would only
> apply to traffic generated locally from a socket.  We still have the
> ugly problem of dealing with forwarded traffic, which it looks like we
> discuss more on that below ...
I got that.

>
> > > The forwarded packet case is still a bit of an issue, but I think the
> > > likelihood of someone using 64k max-size IPv4 packets on the wire
> > > *and* passing this traffic through a Linux cross-domain router with
> > > CIPSO (re)labeling is about as close to zero as one can possibly get.
> > > At least given the size check present in step one (patchlet above) the
> > > packet will be safely (?) dropped on the Linux system so an admin will
> > > have some idea where to start looking.
> >
> > don't know the likelihood of CIPSO (re)labeling on a Linux cross-domain router.
> > But 64K packets could be GRO packets merged on the interface (GRO enabled)
> > of the router, not directly from the wire.
>
> In the GRO case, is it safe to grow the packet such that skb->len is
> greater than 64k?  I presume that the device/driver is going to split
> the packet anyway and populate the IPv4 total length fields in the
> header anyway, right?  If we can't grow the packet beyond 64k, is
> there some way to signal to the driver/device at runtime that the
> largest packet we can process is 64k minus 40 bytes (for the IPv4
> options)?
at runtime, not as far as I know.
It's a field of the network device that can be modified by:
# ip link set dev eth0 gro_max_size $MAX_SIZE gso_max_size $MAX_SIZE

>
> > > I've got some basic patches written for both, but I need to at least
> > > give them a quick sanity test before posting.
> >
> > Good that you can take care of it from the security side.
>
> It's not yet clear to me that we can, see the above questions.
>
> > I think a similar problem exists in calipso_skbuff_setattr() in
> > net/ipv6/calipso.c.
>
> Probably, but one mess at a time, especially since several of the
> questions above apply to both IPv4 and IPv6.
>
Just wanted you to know that IPv6 BIG TCP is something already
in the kernel, unlike IPv4 BIG TCP, we can avoid this problem in
advance before it's in the kernel.

Thanks.
