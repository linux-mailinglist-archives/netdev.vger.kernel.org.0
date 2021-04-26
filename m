Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DEC336B5C9
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 17:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234081AbhDZP3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 11:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233674AbhDZP3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 11:29:34 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E906C061574;
        Mon, 26 Apr 2021 08:28:52 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id t4so1782093ejo.0;
        Mon, 26 Apr 2021 08:28:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M5rHl1uTPHcNcUuxY/E3wd4JEZWlIuCjeq1wxcyEpDI=;
        b=gxIek4o9quqavrkE+Xlb1OWBOADVfMEK55W1qRIFN+jG9v8r15SD/LJCR4ow5Gx2nA
         Kn71I+KZGVenIf5dBtOLRMnSnptyYWeHWyZzD4TetNo6vCL0YcwW/hDqGccrra1WeyDV
         kKiKqIN/6UdiUGTKl6dzvQkCadXAt1BP9bBlz/bQaSQ+KuWS1w9JEx+fSKv5OiT4d0Ke
         Mrt9P2eN+0Vdl1VJtWESOBl6rnJhkjd0XNJFLqNPqiGvxr+zDZYNGxhhF3DNUZG9z+RB
         Jv3YTr9h6DNwihnohBT6SvCzS/JTaeJkKlMVmWOZhvuM53N+iUzr9wP1woKY1lnZ1FBh
         QCpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M5rHl1uTPHcNcUuxY/E3wd4JEZWlIuCjeq1wxcyEpDI=;
        b=CaV0Nt/D8Hj332fVQ6Y07I1NHCfJ5nJh/FjewPy5XZvZwB40MA3ODO0Ruaxl4joMSR
         auz/G0YGfkxznvln5v6QxXCcDrCYNaNhZ015xrK4Ml6KMU1JKYwpGfUreRwynj9R5Cqu
         Y31+yS+Lj2WiY7b1yNNtBtwhT2syX004Gky+Nu1HxDGquLoaaHtBGJZepZVfiuL+/PTj
         mNjAUQ6ltCZRHY+69Fxaj7I1WPLp06Mvodse84vzkK++2tBS7BdzwTttPmxyMfKxVSSC
         J3BtEevYq6Yl8T1gymJaxbf+6TzHt4MRK113PuNoTd6yeyY+8B93yD5JMEx+O7ha0B83
         qeEA==
X-Gm-Message-State: AOAM530YJCNZ1buzL6ShIvIXIpZqNGtZj6p4dr+r2VfXVIojJgFxO9P3
        Qrtk+jnYvc7bnTE02JB8k76fghPdaYHgg2daq3c=
X-Google-Smtp-Source: ABdhPJy+pIsSR8u9JuZX6ML4NK4MUr1r5mS+Y6zvqckgwnnfCXVg5wLMymxt8pIahThSrGGa+hYCy8jNFzwT7ihNnGU=
X-Received: by 2002:a17:907:7b9f:: with SMTP id ne31mr3671687ejc.139.1619450931244;
 Mon, 26 Apr 2021 08:28:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210406123619.rhvtr73xwwlbu2ll@spock.localdomain>
 <20210406114734.0e00cb2f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210407060053.wyo75mqwcva6w6ci@spock.localdomain> <20210407083748.56b9c261@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAKgT0UfLLQycLsAZQ98ofBGYPwejA6zHbG6QsNrU92mizS7e0g@mail.gmail.com>
 <20210407110722.1eb4ebf2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAKgT0UcQXVOifi_2r_Y6meg_zvHDBf1me8VwA4pvEtEMzOaw2Q@mail.gmail.com>
 <20210423081944.kvvm4v7jcdyj74l3@spock.localdomain> <20210423155836.25ef1e77@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210426064736.7efynita4brzos4u@spock.localdomain>
In-Reply-To: <20210426064736.7efynita4brzos4u@spock.localdomain>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 26 Apr 2021 08:28:40 -0700
Message-ID: <CAKgT0Uemubh8yP+UXh-n-YceheFRZO+hYpxtqs+=vedv7hbv4w@mail.gmail.com>
Subject: Re: [igb] netconsole triggers warning in netpoll_poll_dev
To:     Oleksandr Natalenko <oleksandr@natalenko.name>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 25, 2021 at 11:47 PM Oleksandr Natalenko
<oleksandr@natalenko.name> wrote:
>
> Hello.
>
> On Fri, Apr 23, 2021 at 03:58:36PM -0700, Jakub Kicinski wrote:
> > On Fri, 23 Apr 2021 10:19:44 +0200 Oleksandr Natalenko wrote:
> > > On Wed, Apr 07, 2021 at 04:06:29PM -0700, Alexander Duyck wrote:
> > > > On Wed, Apr 7, 2021 at 11:07 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > > > > Sure, that's simplest. I wasn't sure something is supposed to prevent
> > > > > this condition or if it's okay to cover it up.
> > > >
> > > > I'm pretty sure it is okay to cover it up. In this case the "budget -
> > > > 1" is supposed to be the upper limit on what can be reported. I think
> > > > it was assuming an unsigned value anyway.
> > > >
> > > > Another alternative would be to default clean_complete to !!budget.
> > > > Then if budget is 0 clean_complete would always return false.
> > >
> > > So, among all the variants, which one to try? Or there was a separate
> > > patch sent to address this?
> >
> > Alex's suggestion is probably best.
> >
> > I'm not aware of the fix being posted. Perhaps you could take over and
> > post the patch if Intel doesn't chime in?
>
> So, IIUC, Alex suggests this:
>
> ```
> diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
> index a45cd2b416c8..7503d5bf168a 100644
> --- a/drivers/net/ethernet/intel/igb/igb_main.c
> +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> @@ -7981,7 +7981,7 @@ static int igb_poll(struct napi_struct *napi, int budget)
>                                                      struct igb_q_vector,
>                                                      napi);
>         bool clean_complete = true;
> -       int work_done = 0;
> +       unsigned int work_done = 0;
>
>  #ifdef CONFIG_IGB_DCA
>         if (q_vector->adapter->flags & IGB_FLAG_DCA_ENABLED)
> @@ -8008,7 +8008,7 @@ static int igb_poll(struct napi_struct *napi, int budget)
>         if (likely(napi_complete_done(napi, work_done)))
>                 igb_ring_irq_enable(q_vector);
>
> -       return min(work_done, budget - 1);
> +       return min_t(unsigned int, work_done, budget - 1);
>  }
>
>  /**
> ```
>
> Am I right?
>
> Thanks.

Actually a better way to go would be to probably just initialize
"clean_complete = !!budget". With that we don't have it messing with
the interrupt enables which would probably be a better behavior.
