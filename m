Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39A8B6AF70E
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 21:59:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbjCGU7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 15:59:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjCGU7U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 15:59:20 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40D5899650;
        Tue,  7 Mar 2023 12:59:19 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id i6so12731070ybu.8;
        Tue, 07 Mar 2023 12:59:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678222758;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tHJXrIjsNIHO7LWs4CXCAWVbyd5QEtRy0CMDfKJJ6po=;
        b=Nwvd5g85FsgOa+I//hm0swX2q+YvWc4e75buSzlEXP2bpqPY8ISmDnagYKE1Mhbgxc
         obDz4+7l3GJFg07cb4JDX+0r3RkXYI5MtMLLQiM5d+nN8XxKfsdCMFuDLHTyUXwexDaZ
         yWdqgPc2YOJPMnEktFbYHPUXu06PnTQqwd6LUL0MgQAHLzUK5ePNan3uzkIn1Vrd6KBk
         UpX43enLYKuoFtPUdgRbKminwE708AZQBnglSNJOGyp9MTPkGgEASN3GjESS0rBgsvTF
         KPwD06FWdQeU+iwCsMlozp/0oWgU+nLWlWz/ukOVRojsjJTVVNuex1YF/OWzZFH3wrau
         323w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678222758;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tHJXrIjsNIHO7LWs4CXCAWVbyd5QEtRy0CMDfKJJ6po=;
        b=RiKTypZIyrZsVs3n6EYSAtHwxQCX8pAW35e+pVWUJXCAMUeT0FI5olkI1XjyVpcs2+
         r9rfD0vqMeOH6VHwwlC2MKMroS6MsQt3yK12ZwmZhCAF86EXfmZgP5Ntuy6zULsKMvaC
         zuL+yRpreQ3U8qRci3Y7i7s/dEBdxn9ccKzs7jtljFUTcEmhPBqzDylTWKpJumT5aD+R
         zRUDRxx/2WgNq7222/bqYSxhCQjtcbKyqHH2xIKZzpYBVjhfZREy90vreaR4ZkSQeD5m
         MjZS1h4wdhAyqlgdrzFI5KIgK4QOAiPmIipeochBV2BcKQuM3v0itt66QlhR80ZpL6Hk
         /luA==
X-Gm-Message-State: AO0yUKUiDwjFkzng2/wkSQKDE1RB7uszdyNH2pjWBiqCiMMCeeDLRt59
        UpADgJ17Ze0+/AyrMFMnXb4AMBEB5FT5CyZfbh8=
X-Google-Smtp-Source: AK7set8SGIM++YKZWAw23kBW+DHamqpKNeLHk+g0lWX48d425TylxbEtTYlohseB2xiH/zxl1/LZtyo2Gwt6R13VBxU=
X-Received: by 2002:a25:8b8f:0:b0:906:307b:1449 with SMTP id
 j15-20020a258b8f000000b00906307b1449mr9461031ybl.5.1678222758360; Tue, 07 Mar
 2023 12:59:18 -0800 (PST)
MIME-Version: 1.0
References: <cover.1677888566.git.lucien.xin@gmail.com> <5411027934a79f0430edb905ad4b434ec6b8396e.1677888566.git.lucien.xin@gmail.com>
 <ZAYWP1FbItjLN48Y@corigine.com>
In-Reply-To: <ZAYWP1FbItjLN48Y@corigine.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 7 Mar 2023 15:58:51 -0500
Message-ID: <CADvbK_c7gSYkvLy53sQU+_co_o7xLF52KeWTKH0xpMDD02pW5A@mail.gmail.com>
Subject: Re: [PATCH nf-next 5/6] netfilter: use nf_ip6_check_hbh_len in nf_ct_skb_network_trim
To:     Simon Horman <simon.horman@corigine.com>
Cc:     netfilter-devel@vger.kernel.org,
        network dev <netdev@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Aaron Conole <aconole@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 6, 2023 at 11:35=E2=80=AFAM Simon Horman <simon.horman@corigine=
.com> wrote:
>
> On Fri, Mar 03, 2023 at 07:12:41PM -0500, Xin Long wrote:
> > For IPv6 Jumbo packets, the ipv6_hdr(skb)->payload_len is always 0,
> > and its real payload_len ( > 65535) is saved in hbh exthdr. With 0
> > length for the jumbo packets, all data and exthdr will be trimmed
> > in nf_ct_skb_network_trim().
> >
> > This patch is to call nf_ip6_check_hbh_len() to get real pkt_len
> > of the IPv6 packet, similar to br_validate_ipv6().
> >
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
>
> ...
>
> > diff --git a/net/netfilter/nf_conntrack_ovs.c b/net/netfilter/nf_conntr=
ack_ovs.c
> > index 52b776bdf526..2016a3b05f86 100644
> > --- a/net/netfilter/nf_conntrack_ovs.c
> > +++ b/net/netfilter/nf_conntrack_ovs.c
>
> ...
>
> > @@ -114,14 +115,20 @@ EXPORT_SYMBOL_GPL(nf_ct_add_helper);
> >  int nf_ct_skb_network_trim(struct sk_buff *skb, int family)
> >  {
> >       unsigned int len;
> > +     int err;
> >
> >       switch (family) {
> >       case NFPROTO_IPV4:
> >               len =3D skb_ip_totlen(skb);
> >               break;
> >       case NFPROTO_IPV6:
> > -             len =3D sizeof(struct ipv6hdr)
> > -                     + ntohs(ipv6_hdr(skb)->payload_len);
> > +             len =3D ntohs(ipv6_hdr(skb)->payload_len);
> > +             if (ipv6_hdr(skb)->nexthdr =3D=3D NEXTHDR_HOP) {
>
> nit: if you spin a v2,
>      you may consider reducing the scope of err to this block.
>
Hi, Simon,

I will post v2 with your suggestions including those in another 3 patches. =
:)

Thanks.

> > +                     err =3D nf_ip6_check_hbh_len(skb, &len);
> > +                     if (err)
> > +                             return err;
> > +             }
> > +             len +=3D sizeof(struct ipv6hdr);
> >               break;
> >       default:
> >               len =3D skb->len;
> > --
> > 2.39.1
> >
