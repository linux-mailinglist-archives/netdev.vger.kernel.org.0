Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D117F42E8FA
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 08:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234388AbhJOG3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 02:29:47 -0400
Received: from mail-vk1-f182.google.com ([209.85.221.182]:33507 "EHLO
        mail-vk1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233311AbhJOG3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 02:29:46 -0400
Received: by mail-vk1-f182.google.com with SMTP id t200so4663869vkt.0
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 23:27:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zLWrh2HbN7U/0CA4mkAltroII0u8oVmRY36amHD0pU8=;
        b=1c1eYp6M3ixzG0O+hV2b48BuSEXGvA0GtPXDa0v0qjRUdWdiF7ZOunHeaQKQ7f0P/K
         KssBypa8eiFsP5Pg8EGS9s0JrgVUl0wpVQZ7JiliKEUUxqgxPVuRBVx+kstHVBB1CUxE
         0PidFfQbb/gvRh3+vC71LExxX1J9DMcp/H/tdTz1PjdBD9d92MMfwvoeitJoR5GgPC4O
         piHAk/KR9NOm7UfSbiBGPFAfQ6GFnYUR/ZmCuJC4WBd3eVdm/G+hVRZs48S/6BUbliNm
         6iPs+3GwsNdJAt8Uw3QAA3r2Wb24dAU+p6DoDtnfEsX6dKxb+kX0uexON663aFfbX5Yd
         85Gw==
X-Gm-Message-State: AOAM532+SqGk1mNyZg0X3fUsdrV54dNCbwLOH92/hMCdYSGA2/aE68tC
        kNzigoM1etYGT/O+VWBtrOxtMhIvPt86/g==
X-Google-Smtp-Source: ABdhPJzx42IyPgH0P9z8wzE+mYdJB8qy329zjZdThyvTU0Mrf41MFbgOfMXOpgQz6BsyyAfgMiA0lg==
X-Received: by 2002:a1f:2515:: with SMTP id l21mr10508709vkl.13.1634279260113;
        Thu, 14 Oct 2021 23:27:40 -0700 (PDT)
Received: from mail-ua1-f49.google.com (mail-ua1-f49.google.com. [209.85.222.49])
        by smtp.gmail.com with ESMTPSA id p191sm3191264vkp.31.2021.10.14.23.27.39
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Oct 2021 23:27:39 -0700 (PDT)
Received: by mail-ua1-f49.google.com with SMTP id h19so15984399uax.5
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 23:27:39 -0700 (PDT)
X-Received: by 2002:a67:cb0a:: with SMTP id b10mr12377426vsl.9.1634279259068;
 Thu, 14 Oct 2021 23:27:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210729022053.134453-1-jk@codeconstruct.com.au>
 <20210729022053.134453-5-jk@codeconstruct.com.au> <20211014183456.GA8474@asgard.redhat.com>
In-Reply-To: <20211014183456.GA8474@asgard.redhat.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 15 Oct 2021 08:27:27 +0200
X-Gmail-Original-Message-ID: <CAMuHMdVJusoGEe-+eLnA5zKJ79Z4uRYVePTFsa6WVfKDqwmySw@mail.gmail.com>
Message-ID: <CAMuHMdVJusoGEe-+eLnA5zKJ79Z4uRYVePTFsa6WVfKDqwmySw@mail.gmail.com>
Subject: Re: [PATCH net-next v4 04/15] mctp: Add sockaddr_mctp to uapi
To:     Eugene Syromiatnikov <esyr@redhat.com>
Cc:     Jeremy Kerr <jk@codeconstruct.com.au>,
        netdev <netdev@vger.kernel.org>,
        Matt Johnston <matt@codeconstruct.com.au>,
        Andrew Jeffery <andrew@aj.id.au>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-m68k <linux-m68k@lists.linux-m68k.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 15, 2021 at 12:32 AM Eugene Syromiatnikov <esyr@redhat.com> wrote:
> On Thu, Jul 29, 2021 at 10:20:42AM +0800, Jeremy Kerr wrote:
> > This change introduces the user-visible MCTP header, containing the
> > protocol-specific addressing definitions.
>
> [...]
>
> > --- a/include/uapi/linux/mctp.h
> > +++ b/include/uapi/linux/mctp.h
> > @@ -9,7 +9,28 @@
> >  #ifndef __UAPI_MCTP_H
> >  #define __UAPI_MCTP_H
> >
> > +#include <linux/types.h>
> > +
> > +typedef __u8                 mctp_eid_t;
> > +
> > +struct mctp_addr {
> > +     mctp_eid_t              s_addr;
> > +};
> > +
> >  struct sockaddr_mctp {
> > +     unsigned short int      smctp_family;
>
> This gap makes the size of struct sockaddr_mctp 2 bytes less at least
> on m68k, are you fine with that?
>
> > +     int                     smctp_network;
> > +     struct mctp_addr        smctp_addr;
> > +     __u8                    smctp_type;
> > +     __u8                    smctp_tag;

And it may be wise to add 1 byte of explicit padding here?
Or is there a good reason not to do so?

> >  };

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
