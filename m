Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFA62515F83
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 19:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235263AbiD3R0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 13:26:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233111AbiD3R0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 13:26:06 -0400
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CDB8220F5
        for <netdev@vger.kernel.org>; Sat, 30 Apr 2022 10:22:44 -0700 (PDT)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-2f863469afbso89685817b3.0
        for <netdev@vger.kernel.org>; Sat, 30 Apr 2022 10:22:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/tFFgm7LUDtEaAD5vNpWmv0ZKzKK1iJd3PrKl4A/cVY=;
        b=q7gGCMGseE4Jvx0leG2MP27QRJBhk/lgUGjyPBGlSDG/pn5APhXGl+nA87g3IsAEbB
         5GlAcxJNjMecETUCHlUGhBqIkBNv8gRx7l0a+qHIDevvDfPqJ/gYxc8L7C3Qs214tZDz
         JUi2IsZLg45KZTsdGWAh81SMxLm5Y3cp6Xv6GKI+NzIijHBAELqWWmbUQ9zvuchSeCzu
         aZx5hjySfRNJ3sidcPEa3+YmZVGzejApPEUStHLdO/iEIpiKsGmZPjU9hNQTjjyuFaWl
         6GqtDINe+xNV5slrD3FvSDkEX0FpEJZxsgE7QG4q5853aX4p9xfF6PnxZ9Wqj2gmM/Lr
         fzvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/tFFgm7LUDtEaAD5vNpWmv0ZKzKK1iJd3PrKl4A/cVY=;
        b=7Q8alpq1XZhE+fF+OwwSGXcwAIF6NKTIxknQOKVsMw61fvoxD1liGnQOBG1BpG4W0/
         nzCyxdayVTJsfrvyvE1DJaYO3gZVLEgkbCr62VHud4GtX6WHCzMkZvbVzm1ZzAMsZuA2
         uZH9Gx9V/CedzDMZP9zJCj9a58Ehciy/5vImNWgXHZDGX4uJYgFDTbvZfTY2ZfDsRprq
         cnnqaGB/Zqp4Ztvtp9dalNlI/tdGAC/KR3MI7fBFCaEJwUeXfSQO6JKsmeyQB/Fr8rKx
         UYJ9YJg66/DOEZWmO2tdzTLDdf9EN30HzEyQL11e3d15mRRxCr/Kv74SzleCFFjrvH72
         f+Ug==
X-Gm-Message-State: AOAM533298k0Z5BVt/NQXnIxP9mqpzyLRoQvzhOwoJ+ELtFpf9hOS3YR
        vmhDzepkDICrtjYiIR6CFB0IW3WRKjTfbWsPK1LINO6R
X-Google-Smtp-Source: ABdhPJxsgRVqHFhE1gZxiJDWc4I6AaxoBDjVAgybysjitFNTtXDfnNK0EXJk5hERw47Bh7tkZ4aXYxpblnXPie+rxa0=
X-Received: by 2002:a81:8d02:0:b0:2f8:c9f7:4041 with SMTP id
 d2-20020a818d02000000b002f8c9f74041mr4712635ywg.117.1651339363420; Sat, 30
 Apr 2022 10:22:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220410161042.183540-1-xiyou.wangcong@gmail.com>
 <20220410161042.183540-2-xiyou.wangcong@gmail.com> <20220425120724.32af0cc3@kernel.org>
In-Reply-To: <20220425120724.32af0cc3@kernel.org>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat, 30 Apr 2022 10:22:33 -0700
Message-ID: <CAM_iQpX0Ej+dCCum8mpVM+dYmi=dxmDa+OhnVEQhoB9av_yGDQ@mail.gmail.com>
Subject: Re: [Patch bpf-next v1 1/4] tcp: introduce tcp_read_skb()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>
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

On Mon, Apr 25, 2022 at 12:07 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sun, 10 Apr 2022 09:10:39 -0700 Cong Wang wrote:
> > +int tcp_read_skb(struct sock *sk, read_descriptor_t *desc,
> > +              sk_read_actor_t recv_actor)
> > +{
> > +     struct sk_buff *skb;
> > +     struct tcp_sock *tp =3D tcp_sk(sk);
> > +     u32 seq =3D tp->copied_seq;
> > +     u32 offset;
> > +     int copied =3D 0;
> > +
> > +     if (sk->sk_state =3D=3D TCP_LISTEN)
> > +             return -ENOTCONN;
> > +     while ((skb =3D tcp_recv_skb(sk, seq, &offset, true)) !=3D NULL) =
{
> > +             if (offset < skb->len) {
> > +                     int used;
> > +                     size_t len;
> > +
> > +                     len =3D skb->len - offset;
> > +                     used =3D recv_actor(desc, skb, offset, len);
> > +                     if (used <=3D 0) {
> > +                             if (!copied)
> > +                                     copied =3D used;
> > +                             break;
> > +                     }
> > +                     if (WARN_ON_ONCE(used > len))
> > +                             used =3D len;
> > +                     seq +=3D used;
> > +                     copied +=3D used;
> > +                     offset +=3D used;
> > +
> > +                     if (offset !=3D skb->len)
> > +                             continue;
> > +             }
> > +             if (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN) {
> > +                     kfree_skb(skb);
> > +                     ++seq;
> > +                     break;
> > +             }
> > +             kfree_skb(skb);
> > +             if (!desc->count)
> > +                     break;
> > +             WRITE_ONCE(tp->copied_seq, seq);
> > +     }
> > +     WRITE_ONCE(tp->copied_seq, seq);
> > +
> > +     tcp_rcv_space_adjust(sk);
> > +
> > +     /* Clean up data we have read: This will do ACK frames. */
> > +     if (copied > 0)
> > +             tcp_cleanup_rbuf(sk, copied);
> > +
> > +     return copied;
> > +}
> > +EXPORT_SYMBOL(tcp_read_skb);
>
> I started prototyping a similar patch for TLS a while back but I have
> two functions - one to get the skb and another to consume it. I thought
> that's better for TLS, otherwise skbs stuck in the middle layer are not
> counted towards the rbuf. Any thoughts on structuring the API that way?
> I guess we can refactor that later, since TLS TCP-only we don't need
> proto_ops plumbing there.

Do you have a pointer to the source code? I am not sure how TLS uses
->read_sock() (or which interface is relevant).

>
> Overall =F0=9F=91=8D for adding such API.

Thanks.
