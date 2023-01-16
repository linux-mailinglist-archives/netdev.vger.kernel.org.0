Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5285266CE19
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 18:57:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233640AbjAPR52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 12:57:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjAPR5L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 12:57:11 -0500
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8546832E4B;
        Mon, 16 Jan 2023 09:37:27 -0800 (PST)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-4b6255ce5baso389263807b3.11;
        Mon, 16 Jan 2023 09:37:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=o7ffGoY4eCLj8yDNQi7T006ppwWaASx3d9SNMxIIAV0=;
        b=Z+OBwHVG03lC66vuwwvVZ0jz3iBaFYNGCZN321Porv+C2vrLIRT+63m+OZ4/AMwwQ1
         iy88nVrpmtLglsgO/hKVEDv/heO/J8MZiGg/+1cC0MPYta+MQFqk6yauebj+r1FzfxzI
         r8U1VchV/15s7Rqi4JbOBgxTBAVBZ8QbuF/LMSHHM1AwgtDQ+NgbDZTLv1gJRSrnsEwC
         M3gilwvu9a6R9kafl5s7PpzMql1n3QUXx5hn0bj7TaoV/n5C49naxwobGkhQgePmAOQx
         LAEdOCDn5vsxWMSkpaoyrWK0+4CGJXxIW0lGwdQeh8nkvD/NakXNuytZpk2UDUuAnAlQ
         kLiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o7ffGoY4eCLj8yDNQi7T006ppwWaASx3d9SNMxIIAV0=;
        b=kKYo7zujHo7Yn4qyhTl/Emc+LUepirge8Mp/3D8Xe8GpX5RLaWWPpOH3aFq4ezkCOK
         Foi62H1lKbrNaz7W9LCfsiiENdu60CjhHSSFtrQhQ/E/QCYuQXLo876S3B1ZGMeXPnEQ
         vSr2ee2G9frRVeW0S0UcU5CvTXLr0RMaEKQ+B6IIpKR3hnAQil4JV7X9dCMTXN0EClvJ
         C7PdXJTbNClxOKUsUsHMt7svXU+Koc0rPgJPv+BV/Orh9vxn4xbVnt+SCyLyeiVnZfwQ
         9gBedzOQDdjM1ollhIUKEcB5ZUIgU8utWCt7j368PAL/56HkO7OL0n8wZnpXzdramOca
         QUbg==
X-Gm-Message-State: AFqh2kp3M0ZpVUNJUySJP2SGNSdvbuVnLSUDTbW2RYFWdE4wUWqDsW2p
        f6TQm4GVJp+K9ta+3+nhBJnQKF0+JeM1clUmEgo=
X-Google-Smtp-Source: AMrXdXs9TmOx5dAu2oY0Ifc/obE8JX/OvMS67TB1jOsFeKWVyLG6txVr5jVm/I8NNapTw1weKUpBgCVvKDtWpVXwFes=
X-Received: by 2002:a81:914b:0:b0:4d6:ae92:686f with SMTP id
 i72-20020a81914b000000b004d6ae92686fmr18425ywg.198.1673890646650; Mon, 16 Jan
 2023 09:37:26 -0800 (PST)
MIME-Version: 1.0
References: <cover.1673666803.git.lucien.xin@gmail.com> <d19e0bd55ea5477d94567c00735b78d8da6a38cb.1673666803.git.lucien.xin@gmail.com>
 <CAHC9VhRXd+RkHSRLUt=0HFm42xPKGsSdSkxA6EHwipDukZH_mA@mail.gmail.com>
 <CADvbK_e_V_scDpHiGw+Qqmarw8huYYES2j8Z36KYkgT2opED3w@mail.gmail.com> <CAHC9VhQeaOeX-5SENhpScKN9kF1rAKoZX23KOUqQ5=uz6v92iA@mail.gmail.com>
In-Reply-To: <CAHC9VhQeaOeX-5SENhpScKN9kF1rAKoZX23KOUqQ5=uz6v92iA@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Mon, 16 Jan 2023 12:36:07 -0500
Message-ID: <CADvbK_cR5paEunENmWd62XfXtMSf+MHhhc-S1z_gLWp_dUx=8w@mail.gmail.com>
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

On Mon, Jan 16, 2023 at 11:46 AM Paul Moore <paul@paul-moore.com> wrote:
>
> On Sat, Jan 14, 2023 at 12:54 PM Xin Long <lucien.xin@gmail.com> wrote:
> > On Sat, Jan 14, 2023 at 10:39 AM Paul Moore <paul@paul-moore.com> wrote:
> > > On Fri, Jan 13, 2023 at 10:31 PM Xin Long <lucien.xin@gmail.com> wrote:
> > > >
> > > > It may process IPv4 TCP GSO packets in cipso_v4_skbuff_setattr(), so
> > > > the iph->tot_len update should use iph_set_totlen().
> > > >
> > > > Note that for these non GSO packets, the new iph tot_len with extra
> > > > iph option len added may become greater than 65535, the old process
> > > > will cast it and set iph->tot_len to it, which is a bug. In theory,
> > > > iph options shouldn't be added for these big packets in here, a fix
> > > > may be needed here in the future. For now this patch is only to set
> > > > iph->tot_len to 0 when it happens.
> > >
> > > I'm not entirely clear on the paragraph above, but we do need to be
> > > able to set/modify the IP options in cipso_v4_skbuff_setattr() in
> > > order to support CIPSO labeling.  I'm open to better and/or
> > > alternative solutions compared to what we are doing now, but I can't
> > > support a change that is a bug waiting to bite us.  My apologies if
> > > I'm interpreting your comments incorrectly and that isn't the case
> > > here.
> > setting the IP options may cause the packet size to grow (both iph->tot_len
> > and skb->len), for example:
> >
> > before setting it, iph->tot_len=65535,
> > after setting it, iph->tot_len=65535 + 14 (assume the IP option len is 14)
> > however, tot_len is 16 bit, and can't be set to "65535 + 14".
> >
> > Hope the above makes it clearer.
>
> Thanks, it does.
>
> > This problem exists with or without this patch. Not sure how it should
> > be fixed in cipso_v4 ...
> >
> > Not sure if we can skip the big packet, or segment/fragment the big packet
> > in cipso_v4_skbuff_setattr().
>
> We can't skip the CIPSO labeling as that would be the network packet
> equivalent of not assigning a owner/group/mode to a file on the
> filesystem, which is a Very Bad Thing :)
>
> I spent a little bit of time this morning looking at the problem and I
> think the right approach is two-fold: first introduce a simple check
> in cipso_v4_skbuff_setattr() which returns -E2BIG if the packet length
> grows beyond 65535.  It's rather crude, but it's a tiny patch and
> should at least ensure that the upper layers (NetLabel and SELinux)
> don't send the packet with a bogus length field; it will result in
> packet drops, but honestly that seems preferable to a mangled packet
> which will likely be dropped at some point in the network anyway.
>
> diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
> index 6cd3b6c559f0..f19c9beda745 100644
> --- a/net/ipv4/cipso_ipv4.c
> +++ b/net/ipv4/cipso_ipv4.c
> @@ -2183,8 +2183,10 @@ int cipso_v4_skbuff_setattr(struct sk_buff *skb,
>         * that the security label is applied to the packet - we do the same
>         * thing when using the socket options and it hasn't caused a problem,
>         * if we need to we can always revisit this choice later */
> -
>        len_delta = opt_len - opt->optlen;
> +       if ((skb->len + len_delta) > 65535)
> +               return -E2BIG;
> +
Right, looks crude. :-)
Note that for BIG TCP packets skb->len is bigger than 65535.
(I assume CIPSO labeling will drop BIG TCP packets.)

>        /* if we don't ensure enough headroom we could panic on the skb_push()
>         * call below so make sure we have enough, we are also "mangling" the
>         * packet so we should probably do a copy-on-write call anyway */
>
> The second step will be to add a max-length IPv4 option filled with
> IPOPT_NOOP to the local sockets in the case of
> netlbl_sock_setattr()/NETLBL_NLTYPE_ADDRSELECT.  In this case we would
> either end up replacing the padding with a proper CIPSO option or
> removing it completely in netlbl_skbuff_setattr(); in either case the
> total packet length remains the same or decreases so we should be
> "safe".
sounds better.

>
> The forwarded packet case is still a bit of an issue, but I think the
> likelihood of someone using 64k max-size IPv4 packets on the wire
> *and* passing this traffic through a Linux cross-domain router with
> CIPSO (re)labeling is about as close to zero as one can possibly get.
> At least given the size check present in step one (patchlet above) the
> packet will be safely (?) dropped on the Linux system so an admin will
> have some idea where to start looking.
don't know the likelihood of CIPSO (re)labeling on a Linux cross-domain router.
But 64K packets could be GRO packets merged on the interface (GRO enabled)
of the router, not directly from the wire.

>
> I've got some basic patches written for both, but I need to at least
> give them a quick sanity test before posting.
>
Good that you can take care of it from the security side.

I think a similar problem exists in calipso_skbuff_setattr() in
net/ipv6/calipso.c.

Thanks.
