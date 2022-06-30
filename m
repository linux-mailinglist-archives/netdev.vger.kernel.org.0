Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E24F561FF4
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 18:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235607AbiF3QJe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 12:09:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235567AbiF3QJc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 12:09:32 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4B131EAFC;
        Thu, 30 Jun 2022 09:09:30 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id pk21so39992533ejb.2;
        Thu, 30 Jun 2022 09:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W7SHta3R6YcleHmOphCvTADHKrbts/DoO7PiUh5TyAw=;
        b=leQQP/xhczwNdOGnF18R9mF1JXFj2pmiWegEIpuR/mn6I7XObmb8R/TeqQyM7hkH0F
         kYK75lbPEikoYA5d/mNMOo9I5X01TIWLhsFRp7GYYk4blQ9KDfwKc2R6hPys1gv31QZC
         7vHGwCNZUN+IjHVGqL/BNxJzmdkkbru/xoOdG8X5yCdqqV0exGFQkXXtQdcDBQ5IPRBO
         Ks9mL31MeKBiF9JARxV/08FqW39PJuiX1sYOhBgCNdhcHsHkXHqyu36RSzhqg081jEJh
         mstGPi3BeGuxoB7S6rP1c6v9vJYkwQU5M8af5DrCcEhbq6GJXDOsa2sxpd3fswRdDhwP
         eb4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W7SHta3R6YcleHmOphCvTADHKrbts/DoO7PiUh5TyAw=;
        b=T+D2AmOCNHdzK00YZRDUCYelNM5HmO5KsnCvANvXMIjovu+3clDmk0ra7JIfh/X1nz
         w1d248KJM9fl8na+XuPynb28A4vZXcHFjXUcYlM0Av4jrm3zLA2MmDQcV3QLGaZUHVhB
         q5vWK9kIGnvmRLc9nYo0jPnnK7UAyYOJuphP/Cz1aZhAptrfxdbqiRGd5rFuMTTFI4rr
         MeuokdjuMg1DhbTk8OxWLvowmLdIoN70NnNwmuNwMdsHBjIAht/btL7wQAH4oFapyOe4
         LvrV24nYPQQSWs3bB4RxzTodPRpRCOe8XtL+E35p1XFNjaL9HubZk8kfg46QIfC/PI40
         zh4A==
X-Gm-Message-State: AJIora9SkLY6cS9XASW5R508D5XX5YjOkxl2twC6rH6bwXhEnOJ/PIZd
        wYSRS1lX/lzUfq5qklAZpXpZCpIKInIFdvwl9vI=
X-Google-Smtp-Source: AGRyM1see/eF8lNqERI7kZvJTMTd5XDcrqHQx57Y8MmMZ80nmUey6lr33deQShd6xy8hmeSnHCAIpwbadHNwDYyAiBE=
X-Received: by 2002:a17:907:d17:b0:726:a3be:bba4 with SMTP id
 gn23-20020a1709070d1700b00726a3bebba4mr9602604ejc.584.1656605369361; Thu, 30
 Jun 2022 09:09:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220629085836.18042-1-fmdefrancesco@gmail.com>
 <Yr12jl1nEqqVI3TT@boxer> <CAKgT0UfGM8nCZnnYjWPKT+JXOwVJx1xj6n7ssGi41vH4GrUy0Q@mail.gmail.com>
 <CANn89iK6g+4Fy2VMV7=feUAOUDHu-J38be+oU76yp+zGH6xCJQ@mail.gmail.com>
In-Reply-To: <CANn89iK6g+4Fy2VMV7=feUAOUDHu-J38be+oU76yp+zGH6xCJQ@mail.gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 30 Jun 2022 09:09:18 -0700
Message-ID: <CAKgT0UcKRJUJrpFHdNrdH98eu_dpiZiVakJRqc2qHrdGJJQRQA@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH] ixgbe: Use kmap_local_page in ixgbe_check_lbtest_frame()
To:     Eric Dumazet <edumazet@google.com>
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        "Fabio M. De Francesco" <fmdefrancesco@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, bpf <bpf@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ira Weiny <ira.weiny@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>
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

On Thu, Jun 30, 2022 at 8:25 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Thu, Jun 30, 2022 at 5:17 PM Alexander Duyck
> <alexander.duyck@gmail.com> wrote:
> >
> > On Thu, Jun 30, 2022 at 3:10 AM Maciej Fijalkowski
> > <maciej.fijalkowski@intel.com> wrote:
> > >
> > > On Wed, Jun 29, 2022 at 10:58:36AM +0200, Fabio M. De Francesco wrote:
> > > > The use of kmap() is being deprecated in favor of kmap_local_page().
> > > >
> > > > With kmap_local_page(), the mapping is per thread, CPU local and not
> > > > globally visible. Furthermore, the mapping can be acquired from any context
> > > > (including interrupts).
> > > >
> > > > Therefore, use kmap_local_page() in ixgbe_check_lbtest_frame() because
> > > > this mapping is per thread, CPU local, and not globally visible.
> > >
> > > Hi,
> > >
> > > I'd like to ask why kmap was there in the first place and not plain
> > > page_address() ?
> > >
> > > Alex?
> >
> > The page_address function only works on architectures that have access
> > to all of physical memory via virtual memory addresses. The kmap
> > function is meant to take care of highmem which will need to be mapped
> > before it can be accessed.
> >
> > For non-highmem pages kmap just calls the page_address function.
> > https://elixir.bootlin.com/linux/latest/source/include/linux/highmem-internal.h#L40
>
>
> Sure, but drivers/net/ethernet/intel/ixgbe/ixgbe_main.c is allocating
> pages that are not highmem ?
>
> This kmap() does not seem needed.

Good point. So odds are page_address is fine to use. Actually there is
a note to that effect in ixgbe_pull_tail.

As such we could probably go through and update igb, and several of
the other Intel drivers as well.

- Alex
