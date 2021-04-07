Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0B435783F
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 01:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbhDGXGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 19:06:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbhDGXGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 19:06:51 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E63C061760;
        Wed,  7 Apr 2021 16:06:41 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id t14so181511ilu.3;
        Wed, 07 Apr 2021 16:06:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KdT8k9WThaEXk/i1KdIUz/lLL55KvYS2BmGyHiYmbV4=;
        b=vMG8xBKLE17PSfo64RlRvfIs0SgnHFQd51M/25/4qnA/rFcVuD+qT9F0Jw/AR4aNuv
         prRRs6XLW94wMpPt7g5kYWqPEUvyP46uU2iRGFF+F0hIJYaZqFUyxJNpHNfKQmywcUJQ
         JosvHxyE8NBhCUn5NpqWbs5W4wLdxDb0/5z2psk2d3KcmAFw4SwAfE1tgz60SAXFHRgd
         2Fu9KfRxR24bUJikmCQoSIP/0rw6jVnpjni6rGwxJ4UB4cIr1q6ktUpGo7SEEKMXuMZM
         1NQ84twGmD1tSNcaExQ82/x2FYXpOKatQ9Jg4jJnu4uCGgTnPtnSRFb7BxXVxdbscOaD
         A5WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KdT8k9WThaEXk/i1KdIUz/lLL55KvYS2BmGyHiYmbV4=;
        b=BJBHNEADHaQ+uyAO/LRj6pstuvJjaE7DZqZfktlMsYXEYHOBB0t2LqLqMAhdKJtz4M
         iSgpKKoJBSUNi6M3vaEWeq12Ba6YnI3H2XzDwClaXpiCRX7Uz1ootqyeCEp0cDbZOATn
         Pjh4oU7uAUNams3F2IfvjTJBkFcAmYNDQ+fx5i1amJs9rF0ycbodLuV8iIAHh4CTrUiw
         VrKXK3PzMiz6EvmsMhrPIzMY6E+HLlVlnV7iMfjpcfL6eODeojtRYhEZzMiwMN7zYEd8
         1Z9LM10fwcNYZYY5WgcD6Np8BqByYkBKSCnAXciWXeEZk+sYX13+zkmdgu+wuq4u4OTn
         LE6g==
X-Gm-Message-State: AOAM533GBnv0bG5W08IHagL/fErMcB3gT5gmBcXs9gl3KQ5y44TbQDyr
        ey0cmb5FDu1W9tsy/jLgtURXNDCYUwzqbDGglAs=
X-Google-Smtp-Source: ABdhPJztZvqkUgf+53X/OU/6w3VRVdGjRifBLqqQ36Cnaa0HtUei8KTXcQ8+sNofR4RUCNkvkX4YF01CxU7JqBZrhts=
X-Received: by 2002:a05:6e02:6cf:: with SMTP id p15mr4670068ils.237.1617836800398;
 Wed, 07 Apr 2021 16:06:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210406123619.rhvtr73xwwlbu2ll@spock.localdomain>
 <20210406114734.0e00cb2f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210407060053.wyo75mqwcva6w6ci@spock.localdomain> <20210407083748.56b9c261@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAKgT0UfLLQycLsAZQ98ofBGYPwejA6zHbG6QsNrU92mizS7e0g@mail.gmail.com> <20210407110722.1eb4ebf2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210407110722.1eb4ebf2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 7 Apr 2021 16:06:29 -0700
Message-ID: <CAKgT0UcQXVOifi_2r_Y6meg_zvHDBf1me8VwA4pvEtEMzOaw2Q@mail.gmail.com>
Subject: Re: [igb] netconsole triggers warning in netpoll_poll_dev
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Oleksandr Natalenko <oleksandr@natalenko.name>,
        linux-kernel@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 7, 2021 at 11:07 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 7 Apr 2021 09:25:28 -0700 Alexander Duyck wrote:
> > On Wed, Apr 7, 2021 at 8:37 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > >
> > > On Wed, 7 Apr 2021 08:00:53 +0200 Oleksandr Natalenko wrote:
> > > > Thanks for the effort, but reportedly [1] it made no difference,
> > > > unfortunately.
> > > >
> > > > [1] https://bugzilla.kernel.org/show_bug.cgi?id=212573#c8
> > >
> > > The only other option I see is that somehow the NAPI has no rings.
> > >
> > > diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
> > > index a45cd2b416c8..24568adc2fb1 100644
> > > --- a/drivers/net/ethernet/intel/igb/igb_main.c
> > > +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> > > @@ -7980,7 +7980,7 @@ static int igb_poll(struct napi_struct *napi, int budget)
> > >         struct igb_q_vector *q_vector = container_of(napi,
> > >                                                      struct igb_q_vector,
> > >                                                      napi);
> > > -       bool clean_complete = true;
> > > +       bool clean_complete = q_vector->tx.ring || q_vector->rx.ring;
> > >         int work_done = 0;
> > >
> > >  #ifdef CONFIG_IGB_DCA
> >
> > It might make sense to just cast the work_done as a unsigned int, and
> > then on the end of igb_poll use:
> >   return min_t(unsigned int, work_done, budget - 1);
>
> Sure, that's simplest. I wasn't sure something is supposed to prevent
> this condition or if it's okay to cover it up.

I'm pretty sure it is okay to cover it up. In this case the "budget -
1" is supposed to be the upper limit on what can be reported. I think
it was assuming an unsigned value anyway.

Another alternative would be to default clean_complete to !!budget.
Then if budget is 0 clean_complete would always return false.
