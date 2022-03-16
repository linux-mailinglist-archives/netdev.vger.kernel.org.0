Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF7FF4DAAAD
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 07:22:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353888AbiCPGXS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 02:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240322AbiCPGWw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 02:22:52 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAA3A60D96;
        Tue, 15 Mar 2022 23:21:37 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id dr20so2024675ejc.6;
        Tue, 15 Mar 2022 23:21:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hgpsIXhWXZ3F8B3VLBgLArpvJDiuNjo8cGLlauM+oRM=;
        b=fcn5Mw2spLnzVl7JnZNa4eAUt+cPHW5WHsChwl4MbXQt94FY0iSG6neOwmJQmuU0Bn
         GqRl9f6i+0ZQR9CchwTe4eF/iSHDGvWUg13K06KGFL6Lo8fFjPmj+8qYgm8cW11tgQ8G
         Q7vPVz2Ij7J65XgoN8YKfKpy47OlALjWTDzn7Aup/6tj7xbotjUPA5W4Lr9HDZOCU+pF
         IMbX1gQ/eVhWYTZG6emAnuBveZIAdnEdFBgdEA274uD8PdmUrJ06vM3nDyioSe5DlAs9
         brsmoy4rqsXxB5Ae53AFM5ZJUE/YTnihXM9dAt733j2RjXR2L7o2UXDed1DksnJvBdXf
         136g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hgpsIXhWXZ3F8B3VLBgLArpvJDiuNjo8cGLlauM+oRM=;
        b=Bs+JFnWfL8Q6m7b03eU69ebucLLFWU6eODNeVykYOnfBrefvQRd+Nm3QLPg19KXzhf
         CG8RdaSdMX/xLj2Ga6cQLHJA8eSm3c1jbABCX53mw6zc+qxBpTcbI8YyL3w/DGiyllNO
         1rXwR5HhO9pk6b4qGho4w2v+J3ngrGEu3quhwk2XQHSSBcHJ719WkkEKLwb1kmDwszEf
         ckJxkXqdAHnyIznM2hSjZfPYK6XqpKqR+QFuVkIUc6yLUMYirF1WnWE0cKAKG9d5mDQL
         WaAc0nGCznhM5baYSO9VojGfB6llZZUt9kc5hndoiuNOx4xHXsjOVDuhB/FJhcQOGiVt
         EPlw==
X-Gm-Message-State: AOAM532IQH1kzHR2F/Weh2zGjHCl/X6oRO7bmLaIzbvENIcH+CCSBBfS
        pH+Du7qRx5dh9ZIEv9AOefts/DaocPWK74Humy0=
X-Google-Smtp-Source: ABdhPJwA1jJigHg/FBOIIUD5uLCtHnBLNVuez+GZ5eMj96EXdiBTqJO+J5suoQCjusSrRs4dI1W1SWT1b0D+dO/pb3c=
X-Received: by 2002:a17:907:2d29:b0:6db:2b1f:333a with SMTP id
 gs41-20020a1709072d2900b006db2b1f333amr25629444ejc.704.1647411696231; Tue, 15
 Mar 2022 23:21:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220314133312.336653-1-imagedong@tencent.com>
 <20220314133312.336653-4-imagedong@tencent.com> <20220315201706.464d5ecd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220315201706.464d5ecd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Wed, 16 Mar 2022 14:21:24 +0800
Message-ID: <CADxym3Yj58gXe9kHRxNvxxMfNMYjvzbrdcq7sNAo6SQHXb98nQ@mail.gmail.com>
Subject: Re: [PATCH net-next 3/3] net: ipgre: add skb drop reasons to gre_rcv()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, xeb@mail.ru,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Menglong Dong <imagedong@tencent.com>,
        Eric Dumazet <edumazet@google.com>, Martin Lau <kafai@fb.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kees Cook <keescook@chromium.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Hao Peng <flyingpeng@tencent.com>,
        Mengen Sun <mengensun@tencent.com>, dongli.zhang@oracle.com,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Biao Jiang <benbjiang@tencent.com>
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

On Wed, Mar 16, 2022 at 11:17 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 14 Mar 2022 21:33:12 +0800 menglong8.dong@gmail.com wrote:
> > From: Menglong Dong <imagedong@tencent.com>
> >
> > Replace kfree_skb() used in gre_rcv() with kfree_skb_reason(). With
> > previous patch, we can tell that no tunnel device is found when
> > PACKET_NEXT is returned by erspan_rcv() or ipgre_rcv().
> >
> > In this commit, following new drop reasons are added:
> >
> > SKB_DROP_REASON_GRE_CSUM
> > SKB_DROP_REASON_GRE_NOTUNNEL
> >
> > Reviewed-by: Hao Peng <flyingpeng@tencent.com>
> > Reviewed-by: Biao Jiang <benbjiang@tencent.com>
> > Signed-off-by: Menglong Dong <imagedong@tencent.com>
> > ---
> >  include/linux/skbuff.h     |  2 ++
> >  include/trace/events/skb.h |  2 ++
> >  net/ipv4/ip_gre.c          | 28 ++++++++++++++++++----------
> >  3 files changed, 22 insertions(+), 10 deletions(-)
> >
> > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > index 5edb704af5bb..4f5e58e717ee 100644
> > --- a/include/linux/skbuff.h
> > +++ b/include/linux/skbuff.h
> > @@ -448,6 +448,8 @@ enum skb_drop_reason {
> >       SKB_DROP_REASON_GRE_NOHANDLER,  /* no handler found (version not
> >                                        * supported?)
> >                                        */
> > +     SKB_DROP_REASON_GRE_CSUM,       /* GRE csum error */
> > +     SKB_DROP_REASON_GRE_NOTUNNEL,   /* no tunnel device found */
> >       SKB_DROP_REASON_MAX,
> >  };
> >
> > diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
> > index f2bcffdc4bae..e8f95c96cf9d 100644
> > --- a/include/trace/events/skb.h
> > +++ b/include/trace/events/skb.h
> > @@ -63,6 +63,8 @@
> >       EM(SKB_DROP_REASON_TAP_TXFILTER, TAP_TXFILTER)          \
> >       EM(SKB_DROP_REASON_GRE_VERSION, GRE_VERSION)            \
> >       EM(SKB_DROP_REASON_GRE_NOHANDLER, GRE_NOHANDLER)        \
> > +     EM(SKB_DROP_REASON_GRE_CSUM, GRE_CSUM)                  \
> > +     EM(SKB_DROP_REASON_GRE_NOTUNNEL, GRE_NOTUNNEL)          \
> >       EMe(SKB_DROP_REASON_MAX, MAX)
> >
> >  #undef EM
> > diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
> > index b1579d8374fd..b989239e4abc 100644
> > --- a/net/ipv4/ip_gre.c
> > +++ b/net/ipv4/ip_gre.c
> > @@ -421,9 +421,10 @@ static int ipgre_rcv(struct sk_buff *skb, const struct tnl_ptk_info *tpi,
> >
> >  static int gre_rcv(struct sk_buff *skb)
> >  {
> > +     enum skb_drop_reason reason = SKB_DROP_REASON_NOT_SPECIFIED;
> >       struct tnl_ptk_info tpi;
> >       bool csum_err = false;
> > -     int hdr_len;
> > +     int hdr_len, ret;
> >
> >  #ifdef CONFIG_NET_IPGRE_BROADCAST
> >       if (ipv4_is_multicast(ip_hdr(skb)->daddr)) {
> > @@ -438,19 +439,26 @@ static int gre_rcv(struct sk_buff *skb)
>
> I feel like gre_parse_header() is a good candidate for converting
> to return a reason instead of errno.
>

Enn...isn't gre_parse_header() returning the header length? And I
didn't find much useful reason in this function.

>
> >               goto drop;
> >
> >       if (unlikely(tpi.proto == htons(ETH_P_ERSPAN) ||
> > -                  tpi.proto == htons(ETH_P_ERSPAN2))) {
> > -             if (erspan_rcv(skb, &tpi, hdr_len) == PACKET_RCVD)
> > -                     return 0;
> > -             goto out;
> > -     }
> > +                  tpi.proto == htons(ETH_P_ERSPAN2)))
> > +             ret = erspan_rcv(skb, &tpi, hdr_len);
> > +     else
> > +             ret = ipgre_rcv(skb, &tpi, hdr_len);
>
> ipgre_rcv() OTOH may be better off taking the reason as an output
> argument. Assuming PACKET_REJECT means NOMEM is a little fragile.

Yeah, it seems not friendly. I think it's ok to ignore such 'NOMEM' reasons?
Therefore, we only need to consider the PACKET_NEXT return value, and
keep ipgre_rcv() still.

>
> >
> > -     if (ipgre_rcv(skb, &tpi, hdr_len) == PACKET_RCVD)
> > +     switch (ret) {
> > +     case PACKET_NEXT:
> > +             reason = SKB_DROP_REASON_GRE_NOTUNNEL;
> > +             break;
> > +     case PACKET_RCVD:
> >               return 0;
> > -
> > -out:
> > +     case PACKET_REJECT:
> > +             reason = SKB_DROP_REASON_NOMEM;
> > +             break;
> > +     }
> >       icmp_send(skb, ICMP_DEST_UNREACH, ICMP_PORT_UNREACH, 0);
> >  drop:
> > -     kfree_skb(skb);
> > +     if (csum_err)
> > +             reason = SKB_DROP_REASON_GRE_CSUM;
> > +     kfree_skb_reason(skb, reason);
> >       return 0;
> >  }
> >
>
