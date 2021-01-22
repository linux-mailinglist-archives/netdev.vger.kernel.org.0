Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B56DB2FFAF1
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 04:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726644AbhAVDTc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 22:19:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725984AbhAVDTU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 22:19:20 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94066C06174A
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 19:18:39 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id q12so5568358lfo.12
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 19:18:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wml7QTbmq4yq5V/auUOV9vZUKRrdYtWtvrQE87PaN2c=;
        b=Py5q/BO1+LPHI6m7OU74LBucTD0cQq2UpIeHjvSTkK8ZGr7QVs51H1COfm53iWQjJa
         O6ICMSImz+P1707lGxH0/NG75tln0fDRFjAL7Jf7A7hmDsKV58ntaceGkpqvK8n7S3Hy
         3gROYc//RVWs4AOSFiyqYa+r7/gtl5N7lhNo6w7gS3/Kur4v2Y9z0lXBMQwtd5X/Gxqw
         TrgvArcHNaN1bmOdpXzz6SjtAfakO+LP6xHzr7WwKaBw+gFj8MpYRRQ1TaRdmkvCED50
         0qDuC7YO4lJ79VTckei10hYOyeEJHwBQq6I+XkXE3YnJAiq1xFP4ALxi5NVe//NV+kT0
         5EJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wml7QTbmq4yq5V/auUOV9vZUKRrdYtWtvrQE87PaN2c=;
        b=FChrETUzw/aAI+oXLXokCZ9dZ7znusaTtRQCCFtVaMLLRrkZPlK4F8BFNRXJq0hcOp
         863bEXrRDDW82pg1Ds+vQqYVdQUgHiNQCvN/KuMt9X1njWsyaiMz5PgG4O9NM7WV0oeT
         WU5AWO3/krWmmFCEdvA/ynOkZntwiZwhOAuD1pq3Mm23JSRYXky0KMVB3UEvRJTu1D1F
         5FNbPA8DVBeWCI8+s91plF5TwdHuLSmkaRpRLNTEOJwBeJrl2lqS68su05tmL+b1YJ6k
         IyQIpf1P4ya3TUC9vWWnk/mGzb1qyX8DsmNlWgZw1uxqxMKeENyiPH6H6UXcce0AWpZd
         VQ4Q==
X-Gm-Message-State: AOAM533G9uEB8sjkIbeWTnJI2K+XTLnv6AhimAIAjfuQN1ttdcPLJyAO
        vU/Dc9VtKJkQDtw1b73c2200mY4VQk1s4cP7fco=
X-Google-Smtp-Source: ABdhPJzCHjrtONv7f1j9bCDbvlMPRuJPHOh/5hmEHFgD0k4hrby80f/uMZ+HVUKLhd0/gEtfRDsRnrK+utNsjfbY3uw=
X-Received: by 2002:ac2:418b:: with SMTP id z11mr438165lfh.479.1611285518133;
 Thu, 21 Jan 2021 19:18:38 -0800 (PST)
MIME-Version: 1.0
References: <cover.1611218673.git.lucien.xin@gmail.com> <0fa4f7f04222e0c4e7bd27cbd86ffe22148f6476.1611218673.git.lucien.xin@gmail.com>
 <bb59ed7c9c438bf076da3a956bb24fddf80978f7.1611218673.git.lucien.xin@gmail.com>
 <CAKgT0Ucb6EO45+AxWAL8Vgwy4e7b=88TagW+xE-XizedOvmQEw@mail.gmail.com>
In-Reply-To: <CAKgT0Ucb6EO45+AxWAL8Vgwy4e7b=88TagW+xE-XizedOvmQEw@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Fri, 22 Jan 2021 11:18:26 +0800
Message-ID: <CADvbK_c0ByOxha_+afNP_UqdVcKmuQjbp1S47j+4Zjvu+aBPLw@mail.gmail.com>
Subject: Re: [PATCH net-next 2/3] net: add CSUM_T_IP_GENERIC csum_type
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 22, 2021 at 2:13 AM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Thu, Jan 21, 2021 at 12:46 AM Xin Long <lucien.xin@gmail.com> wrote:
> >
> > This patch is to extend csum_type field to 2 bits, and introduce
> > CSUM_T_IP_GENERIC csum type, and add the support for this in
> > skb_csum_hwoffload_help(), just like CSUM_T_SCTP_CRC.
> >
> > Note here it moves dst_pending_confirm field below ndisc_nodetype
> > to avoid a memory hole.
> >
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
> >  include/linux/skbuff.h |  5 +++--
> >  net/core/dev.c         | 17 +++++++++++++----
> >  2 files changed, 16 insertions(+), 6 deletions(-)
> >
> > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > index 67b0a01..d5011fb 100644
> > --- a/include/linux/skbuff.h
> > +++ b/include/linux/skbuff.h
> > @@ -224,6 +224,7 @@
> >
> >  #define CSUM_T_INET            0
> >  #define CSUM_T_SCTP_CRC                1
> > +#define CSUM_T_IP_GENERIC      2
> >
> >  /* Maximum value in skb->csum_level */
> >  #define SKB_MAX_CSUM_LEVEL     3
> > @@ -839,11 +840,11 @@ struct sk_buff {
> >         __u8                    vlan_present:1;
> >         __u8                    csum_complete_sw:1;
> >         __u8                    csum_level:2;
> > -       __u8                    csum_type:1;
> > -       __u8                    dst_pending_confirm:1;
> > +       __u8                    csum_type:2;
> >  #ifdef CONFIG_IPV6_NDISC_NODETYPE
> >         __u8                    ndisc_nodetype:2;
> >  #endif
> > +       __u8                    dst_pending_confirm:1;
> >
> >         __u8                    ipvs_property:1;
> >         __u8                    inner_protocol_type:1;
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 3241de2..6d48af2 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -3617,11 +3617,20 @@ static struct sk_buff *validate_xmit_vlan(struct sk_buff *skb,
> >  int skb_csum_hwoffload_help(struct sk_buff *skb,
> >                             const netdev_features_t features)
> >  {
> > -       if (unlikely(skb_csum_is_sctp(skb)))
> > -               return !!(features & NETIF_F_SCTP_CRC) ? 0 :
> > -                       skb_crc32c_csum_help(skb);
> > +       if (likely(!skb->csum_type))
> > +               return !!(features & NETIF_F_CSUM_MASK) ? 0 :
> > +                      skb_checksum_help(skb);
> >
> > -       return !!(features & NETIF_F_CSUM_MASK) ? 0 : skb_checksum_help(skb);
> > +       if (skb_csum_is_sctp(skb)) {
> > +               return !!(features & NETIF_F_SCTP_CRC) ? 0 :
> > +                      skb_crc32c_csum_help(skb);
> > +       } else if (skb->csum_type == CSUM_T_IP_GENERIC) {
> > +               return !!(features & NETIF_F_HW_CSUM) ? 0 :
> > +                      skb_checksum_help(skb);
> > +       } else {
> > +               pr_warn("Wrong csum type: %d\n", skb->csum_type);
> > +               return 1;
> > +       }
>
> Is the only difference between CSUM_T_IP_GENERIC the fact that we
> check for NETIF_F_HW_CSUM versus using NETIF_F_CSUM_MASK? If so I
> don't think adding the new bit is adding all that much value. Instead
> you could probably just catch this in the testing logic here.
>
> You could very easily just fold CSUM_T_IP_GENERIC into CSUM_T_INET,
> and then in the checks here you split up the checks for
> NETIF_F_HW_CSUM as follows:
If so, better not to touch csum_not_inet now. I will drop the patch 1/3.

>
>  if (skb_csum_is_sctp(skb))
>     return !!(features & NETIF_F_SCTP_CRC) ? 0 : skb_crc32c_csum_help(skb);
>
> if (skb->csum_type) {
>     pr_warn("Wrong csum type: %d\n", skb->csum_type);
>     return 1;
> }
>
> if (features & NETIF_F_HW_CSUM)
>     return 0;
>
> if (features & NETIF_F_CSUM_MASK) {
>     switch (skb->csum_offset) {
>     case offsetof(struct tcphdr, check):
>     case offsetof(struct udphdr, check):
>             return 0;
>     }
Question is: is it reliable to check the type by skb->csum_offset?
What if one day there's another protocol, whose the checksum field
is on the same offset, which is also using the CSUM_T_IP_GENERIC?

> }
>
> return skb_checksum_help(skb);
