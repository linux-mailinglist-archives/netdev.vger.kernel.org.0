Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F38EB4D54C5
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 23:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344446AbiCJWpH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 17:45:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344413AbiCJWpE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 17:45:04 -0500
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 811B3190C36;
        Thu, 10 Mar 2022 14:43:57 -0800 (PST)
Received: by mail-qt1-x830.google.com with SMTP id v14so1626947qta.2;
        Thu, 10 Mar 2022 14:43:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hSx2wMxzDpIQ8A7Q2B9OaU0Z9cc1aqyiEXduTYNSa9A=;
        b=mMNZoPpq0bPT6Von03F6SslaHTpwZWcgHrxmkDY+/m4jvhgKAhE1es/HV+Yu5MfkkC
         YW4DsQssw6228gSHtWZCazVGB2jMxTtDY+LaG4BQQZsXUwiO2ywPUIwujg31zw4u2bGU
         KTuvJ7w6jKu2Z3Z3TRf2z5hPP/XEiVBe8+uTz9SCnI7wDTs6jrGP4EzipjkChrI9U5EG
         S/cqg2Y22zwSt4wmurn45B0euPuwNUPq42XvtQ+G2A/6w4o/5v6HcNRj1ebBjcB/Uu43
         coeMKf57QzCKDnJMTRsbJRlsIfvh6IaDUVfsoxPPGToEiimTSJCudOKcudEZ0t2FM9wk
         Vh3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hSx2wMxzDpIQ8A7Q2B9OaU0Z9cc1aqyiEXduTYNSa9A=;
        b=c94oC8kMzcoO9VOsgQuABSzJA+/u/RTa9rzQI7lkHua+pQlXYym63pzrfkKoYQJtw7
         cdy/qVJczN5sv4ouCZMa42UlnbLl9vyA4HUrnGY+GcPBu4BvKtVHCddxjXL9DNhj2fsS
         +3wgWzJvRPJYeJavxbMBdSn8aWoeUCtAzbK2Z6XJnlXvA+zcEppHx6xq7weDjhrCmbx/
         OlfTpAFVfSEhKXvMDJxSe06DA9fFfyXT9iA7wAjYRYKclkiVn1df+e6PmzF5zGNibw3C
         EBPjMt496Hbk3nt4bndUdmybQQofYsZ3P7oPTb2JVQzTRJ8vAytoQPeCqAOURpfWvjCV
         2jOw==
X-Gm-Message-State: AOAM532Im3Bdyd0UeExz4Iq0qTcRKlo6o48lWQkqvXB/6SNX0kvFbYza
        Mft9l/MuIYJhL7TGxk9QFX/wpFwcvNsJat0vxgk=
X-Google-Smtp-Source: ABdhPJw7XtrEc3Yf9PdiTO5/XVKITkunzcVoFz+FobsR5iuPM5qor3Td5XAZhOh7my7EgM5mxc7SmWE02XkMPsaOo+U=
X-Received: by 2002:a05:622a:1802:b0:2e1:abdb:e522 with SMTP id
 t2-20020a05622a180200b002e1abdbe522mr4120736qtc.144.1646952236625; Thu, 10
 Mar 2022 14:43:56 -0800 (PST)
MIME-Version: 1.0
References: <CA+FuTScPUVpyK6WYXrePTg_533VF2wfPww4MOJYa17v0xbLeGQ@mail.gmail.com>
 <20220310221328.877987-1-tadeusz.struk@linaro.org> <20220310143011.00c21f53@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220310143011.00c21f53@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 10 Mar 2022 17:43:20 -0500
Message-ID: <CAF=yD-LrVjvY8wAqZtUTFS8V9ng2AD3jB1DOZvkagPOp3Sbq-g@mail.gmail.com>
Subject: Re: [PATCH v2] net: ipv6: fix skb_over_panic in __ip6_append_data
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Tadeusz Struk <tadeusz.struk@linaro.org>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        syzbot+e223cf47ec8ae183f2a0@syzkaller.appspotmail.com,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 10, 2022 at 5:30 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 10 Mar 2022 14:13:28 -0800 Tadeusz Struk wrote:
> > diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
> > index 4788f6b37053..6d45112322a0 100644
> > --- a/net/ipv6/ip6_output.c
> > +++ b/net/ipv6/ip6_output.c
> > @@ -1649,6 +1649,16 @@ static int __ip6_append_data(struct sock *sk,
> >                       skb->protocol = htons(ETH_P_IPV6);
> >                       skb->ip_summed = csummode;
> >                       skb->csum = 0;
> > +
> > +                     /*
> > +                      *      Check if there is still room for payload
> > +                      */
>
> TBH I think the check is self-explanatory. Not worth a banner comment,
> for sure.
>
> > +                     if (fragheaderlen >= mtu) {
> > +                             err = -EMSGSIZE;
> > +                             kfree_skb(skb);
> > +                             goto error;
> > +                     }
>
> Not sure if Willem prefers this placement, but seems like we can lift
> this check out of the loop, as soon as fragheaderlen and mtu are known.
>
> >                       /* reserve for fragmentation and ipsec header */
> >                       skb_reserve(skb, hh_len + sizeof(struct frag_hdr) +
> >                                   dst_exthdrlen);

Just updating this boundary check will do?

        if (mtu < fragheaderlen ||
            ((mtu - fragheaderlen) & ~7) + fragheaderlen <
sizeof(struct frag_hdr))
                goto emsgsize;
