Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06540670DCD
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 00:42:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbjAQXmB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 18:42:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbjAQXl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 18:41:29 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E1F96189F
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 14:47:01 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id bj3so30718350pjb.0
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 14:47:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pDfrRPcarawgDNq5Pj7xF15dtohFR+yiPCxt6dTRL68=;
        b=Deb1FxgItCBI4GjYe5RjGQdjfd8FnAIRm9uM/YiAVhDlAcvrFv/n2PMQaAiNGBy5OB
         Jx1d+tsVQcw+zM8EDqluGx3/wuGO/xGfeRco8EObXVtqyyOqTRfMvMB/JxbE/pUSoLYg
         2FLxkl42G9GYd8q1T+06Qsq3mI3bSGi0TFLv2bEbbQvVZ2LDc+WYxcNRPWeMys/hPqPl
         C70NN53tk3UObL+N3J8pdWsc7I3GvYJ4MJ8ak8gP7wd6dS7STeZQnZk8kdtAeZG2qLrn
         uyy8+qjQn0CCgEFB8WoGXzmHBa0RI1/6icF+5PG6hv6ZFAXGoeMizAvNjNDIun/5VvcB
         mPtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pDfrRPcarawgDNq5Pj7xF15dtohFR+yiPCxt6dTRL68=;
        b=u/ia4uyGCvkxN48UDjOIoC5MJ7fc+KJ1ESczXl6J1oBjeNuYLIxjg/FM0Cb80lK8oA
         CuPumWPXsSn1dDVnnegiCynVrF84u23bMBGv92EZEUkcgBWrUdYG8TdE6cum3kZDEF7y
         2/d+lajy8hh6A5Ugm9VZVQ/BsWrnrkw2cQGNcwWanGjTxF/uEUu551DVZXMjVCP2Ar7p
         B0/vS3+kJ9zelAoIeJMm0EI+CugozNzz6MejFJ1h11tkalonWn2Wzv0rcjyF/1O+FxIR
         nOyln7s0vttHeWOgtLPXxDftgO4a3u7CRzgwuIypSuhz6nydGXcHKVhQg4uHGICU0UdH
         Dx4w==
X-Gm-Message-State: AFqh2kqXmlvoC3KVBNAjirxqI26XCGl+nUa0KJsfXBgn8nZSTXDBhfMU
        bCVY2vUIBK51WQt1N2VnAh63JxUqq4iubK1nvV0R
X-Google-Smtp-Source: AMrXdXt65y12KQW+gMg8Z4l+eTgQTkdup2EVQxIwB/GpxnMV30e0Qw6m3i9vf5fhpJEfF95dMz4YaojDCKwRd2PDhTY=
X-Received: by 2002:a17:90a:d683:b0:229:5912:1043 with SMTP id
 x3-20020a17090ad68300b0022959121043mr544439pju.69.1673995621155; Tue, 17 Jan
 2023 14:47:01 -0800 (PST)
MIME-Version: 1.0
References: <cover.1673666803.git.lucien.xin@gmail.com> <d19e0bd55ea5477d94567c00735b78d8da6a38cb.1673666803.git.lucien.xin@gmail.com>
 <CAHC9VhRXd+RkHSRLUt=0HFm42xPKGsSdSkxA6EHwipDukZH_mA@mail.gmail.com>
 <CADvbK_e_V_scDpHiGw+Qqmarw8huYYES2j8Z36KYkgT2opED3w@mail.gmail.com>
 <CAHC9VhQeaOeX-5SENhpScKN9kF1rAKoZX23KOUqQ5=uz6v92iA@mail.gmail.com>
 <CADvbK_cR5paEunENmWd62XfXtMSf+MHhhc-S1z_gLWp_dUx=8w@mail.gmail.com>
 <CAHC9VhSk8pYtOJHCZ1uNvv1SJiazWkJVd1BCfyiLCXPMPKe_Pg@mail.gmail.com>
 <CADvbK_ds4ixHgPGA4iKb1kkFc=SF8SXPM-ZL-kb-ZA0B-70Xqg@mail.gmail.com> <CAHC9VhR4_ae=QzrUUM=1MZTWJ9MQom0fEAME3b+z+uBrA8PpcQ@mail.gmail.com>
In-Reply-To: <CAHC9VhR4_ae=QzrUUM=1MZTWJ9MQom0fEAME3b+z+uBrA8PpcQ@mail.gmail.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 17 Jan 2023 17:46:49 -0500
Message-ID: <CAHC9VhSRgQuyPgio7d9ZNbs53oCvpq3KQJ9gG5rKX67Wn+P6kw@mail.gmail.com>
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

On Tue, Jan 17, 2023 at 2:51 PM Paul Moore <paul@paul-moore.com> wrote:
> On Mon, Jan 16, 2023 at 2:35 PM Xin Long <lucien.xin@gmail.com> wrote:
> > On Mon, Jan 16, 2023 at 1:13 PM Paul Moore <paul@paul-moore.com> wrote:
> > > On Mon, Jan 16, 2023 at 12:37 PM Xin Long <lucien.xin@gmail.com> wrote:
> > > > On Mon, Jan 16, 2023 at 11:46 AM Paul Moore <paul@paul-moore.com> wrote:
> > > > > On Sat, Jan 14, 2023 at 12:54 PM Xin Long <lucien.xin@gmail.com> wrote:
> > > > > > On Sat, Jan 14, 2023 at 10:39 AM Paul Moore <paul@paul-moore.com> wrote:
> > > > > > > On Fri, Jan 13, 2023 at 10:31 PM Xin Long <lucien.xin@gmail.com> wrote:
>
> ...
>
> > > > > We can't skip the CIPSO labeling as that would be the network packet
> > > > > equivalent of not assigning a owner/group/mode to a file on the
> > > > > filesystem, which is a Very Bad Thing :)
> > > > >
> > > > > I spent a little bit of time this morning looking at the problem and I
> > > > > think the right approach is two-fold: first introduce a simple check
> > > > > in cipso_v4_skbuff_setattr() which returns -E2BIG if the packet length
> > > > > grows beyond 65535.  It's rather crude, but it's a tiny patch and
> > > > > should at least ensure that the upper layers (NetLabel and SELinux)
> > > > > don't send the packet with a bogus length field; it will result in
> > > > > packet drops, but honestly that seems preferable to a mangled packet
> > > > > which will likely be dropped at some point in the network anyway.
> > > > >
> > > > > diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
> > > > > index 6cd3b6c559f0..f19c9beda745 100644
> > > > > --- a/net/ipv4/cipso_ipv4.c
> > > > > +++ b/net/ipv4/cipso_ipv4.c
> > > > > @@ -2183,8 +2183,10 @@ int cipso_v4_skbuff_setattr(struct sk_buff *skb,
> > > > >         * that the security label is applied to the packet - we do the same
> > > > >         * thing when using the socket options and it hasn't caused a problem,
> > > > >         * if we need to we can always revisit this choice later */
> > > > > -
> > > > >        len_delta = opt_len - opt->optlen;
> > > > > +       if ((skb->len + len_delta) > 65535)
> > > > > +               return -E2BIG;
> > > > > +
> > > >
> > > > Right, looks crude. :-)
> > >
> > > Yes, but what else can we do?  There is fragmentation, but that is
> > > rather ugly and we would still need a solution for when the don't
> > > fragment bit is set.  I'm open to suggestions.
> >
> > looking at ovs_dp_upcall(), for GSO/GRO packets it goes to
> > queue_gso_packets() where it calls __skb_gso_segment()
> > to segment it into small segs/skbs, then process these segs instead.
> >
> > I'm thinking you can try to do the same in cipso_v4_skbuff_setattr(),
> > and I don't think 64K non-GSO packets exist in the user environment,
> > so taking care of GSO packets should be enough.
>
> Thanks, I'll take a look.

Unfortunately I don't think the ovs_dp_upcall() approach will work as
that is an endpoint in the kernel which sends the GSO'd packet up to
userspace in segements.  In the case of cipso_v4_skbuff_setattr() we
are setting an IPv4 option on a packet in either the NF_INET_LOCAL_OUT
or NF_INET_FORWARD output path.  I believe we can resolve the
LOCAL_OUT case with the padding approach I mentioned previously, but
the FORWARD path remains a challenge; I simply don't see a way to
handle growing the packet beyond 64k in the forward path.  I'm also
realizing that we should be sending a ICMP_FRAG_NEEDED in the forward
case when we have to drop the packet due to size issues, as the normal
MTU/size check happens prior to the NF_INET_FORWARD hooks (and hence
cipso_v4_skbuff_setattr()).

> > > It seems like there is still ongoing discussion about even enabling
> > > BIG TCP for IPv4, however for this discussion let's assume that BIG
> > > TCP is merged for IPv4.
> > >
> > > We really should have a solution that allows CIPSO for both normal and
> > > BIG TCP, if we don't we force distros and admins to choose between the
> > > two and that isn't good.  We should do better.  If skb->len > 64k in
> > > the case of BIG TCP, how is the packet eventually divided/fragmented
> > > in such a way that the total length field in the IPv4 header doesn't
> > > overflow?  Or is that simply handled at the driver/device layer and we
> > > simply set skb->len to whatever the size is, regardless of the 16-bit
> >
> > Yes, for BIG TCP, 16-bit length is set to 0, and it just uses skb->len
> > as the IP packet length.
>
> In the BIG TCP case, when is the IPv4 header zero'd out?  Currently
> cipso_v4_skbuff_setattr() is called in the NF_INET_LOCAL_OUT and
> NF_INET_FORWARD chains, is there an easy way to distinguish between a
> traditional segmentation offload mechanism, e.g. GSO, and BIG TCP?  If
> BIG TCP allows for arbitrarily large packets we can just grow the
> skb->len value as needed and leave the total length field in the IPv4
> header untouched/zero, but we would need to be able to distinguish
> between a segmentation offload and BIG TCP.

Keeping the above questions as they still apply, rather I could still
use some help understanding what a BIG TCP packet would look like
during LOCAL_OUT and FORWARD.

> > > In the GRO case, is it safe to grow the packet such that skb->len is
> > > greater than 64k?  I presume that the device/driver is going to split
> > > the packet anyway and populate the IPv4 total length fields in the
> > > header anyway, right?  If we can't grow the packet beyond 64k, is
> > > there some way to signal to the driver/device at runtime that the
> > > largest packet we can process is 64k minus 40 bytes (for the IPv4
> > > options)?
> >
> > at runtime, not as far as I know.
> > It's a field of the network device that can be modified by:
> > # ip link set dev eth0 gro_max_size $MAX_SIZE gso_max_size $MAX_SIZE
>
> I need to look at the OVS case above, but one possibility would be to
> have the kernel adjust the GSO size down by 40 bytes when
> CONFIG_NETLABEL is enabled, but that isn't a great option, and not
> something I consider a first (or second) choice.

Looking more at the GSO related code, this isn't likely to work.

-- 
paul-moore.com
