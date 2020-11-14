Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD3C32B2B96
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 06:27:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbgKNF0m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 00:26:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726228AbgKNF0m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 00:26:42 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48EF5C0613D1;
        Fri, 13 Nov 2020 21:26:42 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id c9so15815418wml.5;
        Fri, 13 Nov 2020 21:26:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xUpfzh51sqEyr356yzQdiYFeL0QOtdHTWibmueRiRDA=;
        b=WUQeyK7FC2sU2xzsWpwe6wtOYvIArlYkRpqmFxzT1RUm/d92azjxPzW9I2S4PaKOHL
         qwxVsle+COi7cXXW3DFrXIYCaFL7XZ7d/ZiYfWioGP2OBM+qDRpLXtUBTbNFo0iUDZ4U
         lzsx4KEpWzPz8X3QVhPBBiajUzGL/shGKjtYbd2/ZrtFRzcl8lqh1+SQh1xDAecBdVlY
         kjke4KvfKQpKJC7a7xq5sXz8bpwJ03ebYqeXht+VcOPPdXzUVOD6RvswPHB3jADXu24h
         5Ye7nOSAnA2ADdJdzmP68qrW57FF44xhW+WOa0BwSyR6WIHeAvZGokCn9rLAKa5fccKB
         q0zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xUpfzh51sqEyr356yzQdiYFeL0QOtdHTWibmueRiRDA=;
        b=IwBuymBMOcQ6VyHlXQ+8Na5nVGvKhABLtcDz1gxCWNB5ELWr1zkw7ewO/8+FBHMMdZ
         MxdZ0WigTngALE10aEPDQ9iV171iM8DPUvcRo4mfXKaAxzcs1oKi7YPv+jacQNpuj8Ju
         /qiMENEoLUfckggjC8Y7kerrkSmwCYj6rVYFBceyaZmbBHp9UwRoBc6ugenWHtM0vsfS
         F0O77VOa0h0uGZOpCtJxHKhq0BySZCcpV4x9kcYw9hYzC1zfweV0o+07qPtHiiSRe6Gr
         EedIPpn3kkcgxOOxgwRle6IF7En6MkhH+eGJ4O+zC1RA6lSiDNw1R4V0qFzKvDtI4a+k
         mPIg==
X-Gm-Message-State: AOAM531VtY3bZvA/PjkXkvAJIw35Z+0z/2vw4oknj2JpoL4xy2AjtAEM
        8dqiqwziE9Ti/ZRRL9eb5srvJan4mmEW7y/4wz8=
X-Google-Smtp-Source: ABdhPJzbDa2kXnQuoL+TZXIeSCAMPDhSxZUULKhTModrDLp5dRTY9FhZ2tMjmTkIs978jar8mfpzTa0YR0YExjZxw7g=
X-Received: by 2002:a1c:1d82:: with SMTP id d124mr5816600wmd.12.1605331600898;
 Fri, 13 Nov 2020 21:26:40 -0800 (PST)
MIME-Version: 1.0
References: <7cb07ff74acd144f14a4467c7dddd12a940fbf52.1605259104.git.lucien.xin@gmail.com>
 <20201113123529.GI3913@localhost.localdomain>
In-Reply-To: <20201113123529.GI3913@localhost.localdomain>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Sat, 14 Nov 2020 13:26:29 +0800
Message-ID: <CADvbK_dZzdqGsDw1yr7e8ic+xgsJfB+dbA-P+nPTnvq_kWqSCw@mail.gmail.com>
Subject: Re: [PATCH net] sctp: change to hold/put transport for proto_unreach_timer
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        davem <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 13, 2020 at 8:35 PM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> Hi,
>
> On Fri, Nov 13, 2020 at 05:18:24PM +0800, Xin Long wrote:
> ...
> > diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
> > index 813d307..0a51150 100644
> > --- a/net/sctp/sm_sideeffect.c
> > +++ b/net/sctp/sm_sideeffect.c
> > @@ -419,7 +419,7 @@ void sctp_generate_proto_unreach_event(struct timer_list *t)
> >               /* Try again later.  */
> >               if (!mod_timer(&transport->proto_unreach_timer,
> >                               jiffies + (HZ/20)))
> > -                     sctp_association_hold(asoc);
> > +                     sctp_transport_hold(transport);
> >               goto out_unlock;
> >       }
> >
>
> The chunk above covers the socket busy case, but for the normal cases
> it also needs:
>
> @@ -435,7 +435,7 @@ void sctp_generate_proto_unreach_event(struct timer_list *t)
>
>  out_unlock:
>         bh_unlock_sock(sk);
> -       sctp_association_put(asoc);
> +       sctp_transport_put(asoc);
>  }
yeah, right, posted v2.

Thanks.
>
>   /* Handle the timeout of the RE-CONFIG timer. */
>
> > diff --git a/net/sctp/transport.c b/net/sctp/transport.c
> > index 806af58..60fcf31 100644
> > --- a/net/sctp/transport.c
> > +++ b/net/sctp/transport.c
> > @@ -133,7 +133,7 @@ void sctp_transport_free(struct sctp_transport *transport)
> >
> >       /* Delete the ICMP proto unreachable timer if it's active. */
> >       if (del_timer(&transport->proto_unreach_timer))
> > -             sctp_association_put(transport->asoc);
> > +             sctp_transport_put(transport);
> >
> >       sctp_transport_put(transport);
>
> Btw, quite noticeable on the above list of timers that only this timer
> was using a reference on the asoc. Seems we're good now, then. :-)
>
correct! :D
