Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83A8D375DEF
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 02:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233728AbhEGAj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 20:39:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231720AbhEGAj3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 20:39:29 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 368AFC061574;
        Thu,  6 May 2021 17:38:29 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id s6so8158521edu.10;
        Thu, 06 May 2021 17:38:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZAjjQc5GIaQm8QziUbIPzE+PeYzCka/kXgPfW0S9Hn8=;
        b=oNZ3I9VdeV92qqz0nDv2htQYIj1hl3cXHFQDsVrveqj7gw7p1vZEUsGqS1waYxUDtA
         5j3FO+BcdndreaW2v2ATgKuNbSV3T153IF3pYaH6vZhJgD/gu2ItGJlg13pCRnBI8TJj
         Jf6joIgz/+AVYyAjTyUlq0CtEeXqc9VF9E7i31OGg6XnkFBv89077u8arnFjwImMvSBS
         tnjMfgJifVnTrbgamwO/X3HjAdH3i35ZEPfKW7l9ADuEqtHOeOwglKmikF81bl12t+MS
         ixAuIWQVgILljEj36Kq5sAo5JOjjiin/ZBlZkW8l7Q3G9J15dIyJOkCusp9+ta6AhG5Q
         XqfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZAjjQc5GIaQm8QziUbIPzE+PeYzCka/kXgPfW0S9Hn8=;
        b=HWRCz/oJn8x4CF3dD2u5PgFlhOGkzFNvBypHeLVJuHquGn1XeKsq7BpH0T7lUEyEJf
         2I2n9NOQTQkQ2GkVG0VMetGISZ1ahGhDx7fSxyRBtR7blatyAi+Fz1crB2tA2WYiWeYv
         oMhRJDgbzcMChbU78l3d5iQ++yd/7D06KhmdK1oCbzhZcfGvwMVxMhE+oAE9W/cGF4AF
         gB1f6LFDjbfq6tvjcH2oUuWGcmHoDE+BhriVGqsw8WoOTXQ16jQ+WsKmp1aIRqsgxp80
         39c6wzxsw8DwdLLBJ5kRnoGDtmf/MlyrTohhRZOu3ijUq1DKijgMSoVEJSJYunp7CcXS
         uvHw==
X-Gm-Message-State: AOAM530bs9tJ1S1ieLz52tGLADJDE6GnfrWMKX3S2c3yOnJOzrQ4fsPV
        MEB+9Sg8gtp3R8QMzSUyCIqh2E6YZ2ORbYEynHwIT/jE1fk=
X-Google-Smtp-Source: ABdhPJxOV7RC0YgLydvghPN9HwvKvvjoX/jZsx7ugciyaBQBFZpjrp6JNyahMeNulvOT/I0xvwy5mSqBSy7Xa7ZWpaI=
X-Received: by 2002:a50:8fe6:: with SMTP id y93mr8214261edy.224.1620347907299;
 Thu, 06 May 2021 17:38:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210406123619.rhvtr73xwwlbu2ll@spock.localdomain>
 <20210406114734.0e00cb2f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210407060053.wyo75mqwcva6w6ci@spock.localdomain> <20210407083748.56b9c261@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAKgT0UfLLQycLsAZQ98ofBGYPwejA6zHbG6QsNrU92mizS7e0g@mail.gmail.com>
 <20210407110722.1eb4ebf2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAKgT0UcQXVOifi_2r_Y6meg_zvHDBf1me8VwA4pvEtEMzOaw2Q@mail.gmail.com>
 <20210423081944.kvvm4v7jcdyj74l3@spock.localdomain> <20210423155836.25ef1e77@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210426064736.7efynita4brzos4u@spock.localdomain> <CAKgT0Uemubh8yP+UXh-n-YceheFRZO+hYpxtqs+=vedv7hbv4w@mail.gmail.com>
 <20210506163257.000036fe@intel.com>
In-Reply-To: <20210506163257.000036fe@intel.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 6 May 2021 17:38:16 -0700
Message-ID: <CAKgT0UegmWH93wy1G-eE8LsCc_qhQf=XvmKTVj0a_XDt17RzHA@mail.gmail.com>
Subject: Re: [igb] netconsole triggers warning in netpoll_poll_dev
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     Oleksandr Natalenko <oleksandr@natalenko.name>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 6, 2021 at 4:32 PM Jesse Brandeburg
<jesse.brandeburg@intel.com> wrote:
>
> Alexander Duyck wrote:
>
> > On Sun, Apr 25, 2021 at 11:47 PM Oleksandr Natalenko
> > <oleksandr@natalenko.name> wrote:
> > >
> > > Hello.
> > >
> > > On Fri, Apr 23, 2021 at 03:58:36PM -0700, Jakub Kicinski wrote:
> > > > On Fri, 23 Apr 2021 10:19:44 +0200 Oleksandr Natalenko wrote:
> > > > > On Wed, Apr 07, 2021 at 04:06:29PM -0700, Alexander Duyck wrote:
> > > > > > On Wed, Apr 7, 2021 at 11:07 AM Jakub Kicinski <kuba@kernel.org=
> wrote:
> > > > > > > Sure, that's simplest. I wasn't sure something is supposed to=
 prevent
> > > > > > > this condition or if it's okay to cover it up.
> > > > > >
> > > > > > I'm pretty sure it is okay to cover it up. In this case the "bu=
dget -
> > > > > > 1" is supposed to be the upper limit on what can be reported. I=
 think
> > > > > > it was assuming an unsigned value anyway.
> > > > > >
> > > > > > Another alternative would be to default clean_complete to !!bud=
get.
> > > > > > Then if budget is 0 clean_complete would always return false.
> > > > >
> > > > > So, among all the variants, which one to try? Or there was a sepa=
rate
> > > > > patch sent to address this?
> > > >
> > > > Alex's suggestion is probably best.
> > > >
> > > > I'm not aware of the fix being posted. Perhaps you could take over =
and
> > > > post the patch if Intel doesn't chime in?
> > >
> > > So, IIUC, Alex suggests this:
> > >
> > > ```
> > > diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/=
ethernet/intel/igb/igb_main.c
> > > index a45cd2b416c8..7503d5bf168a 100644
> > > --- a/drivers/net/ethernet/intel/igb/igb_main.c
> > > +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> > > @@ -7981,7 +7981,7 @@ static int igb_poll(struct napi_struct *napi, i=
nt budget)
> > >                                                      struct igb_q_vec=
tor,
> > >                                                      napi);
> > >         bool clean_complete =3D true;
> > > -       int work_done =3D 0;
> > > +       unsigned int work_done =3D 0;
> > >
> > >  #ifdef CONFIG_IGB_DCA
> > >         if (q_vector->adapter->flags & IGB_FLAG_DCA_ENABLED)
> > > @@ -8008,7 +8008,7 @@ static int igb_poll(struct napi_struct *napi, i=
nt budget)
> > >         if (likely(napi_complete_done(napi, work_done)))
> > >                 igb_ring_irq_enable(q_vector);
> > >
> > > -       return min(work_done, budget - 1);
> > > +       return min_t(unsigned int, work_done, budget - 1);
> > >  }
> > >
> > >  /**
> > > ```
> > >
> > > Am I right?
> > >
> > > Thanks.
> >
> > Actually a better way to go would be to probably just initialize
> > "clean_complete =3D !!budget". With that we don't have it messing with
> > the interrupt enables which would probably be a better behavior.
>
>
> Thanks guys for the suggestions here! Finally got some time for
> this, so here is the patch I'm going to queue shortly.
>
> From ffd24e90d688ee347ab051266bfc7fca00324a68 Mon Sep 17 00:00:00 2001
> From: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Date: Thu, 6 May 2021 14:41:11 -0700
> Subject: [PATCH net] igb: fix netpoll exit with traffic
> To: netdev,
>     Oleksandr Natalenko <oleksandr@natalenko.name>
> Cc: Jakub Kicinski <kuba@kernel.org>, LKML <linux-kernel@vger.kernel.org>=
, "Brandeburg, Jesse" <jesse.brandeburg@intel.com>, "Nguyen, Anthony L" <an=
thony.l.nguyen@intel.com>, "David S. Miller" <davem@davemloft.net>, intel-w=
ired-lan <intel-wired-lan@lists.osuosl.org>, Alexander Duyck <alexander.duy=
ck@gmail.com>
>
> Oleksandr brought a bug report where netpoll causes trace messages in
> the log on igb.
>
> [22038.710800] ------------[ cut here ]------------
> [22038.710801] igb_poll+0x0/0x1440 [igb] exceeded budget in poll
> [22038.710802] WARNING: CPU: 12 PID: 40362 at net/core/netpoll.c:155 netp=
oll_poll_dev+0x18a/0x1a0
>
> After some discussion and debug from the list, it was deemed that the
> right thing to do is initialize the clean_complete variable to false
> when the "netpoll mode" of passing a zero budget is used.
>
> This logic should be sane and not risky because the only time budget
> should be zero on entry is netpoll.  Change includes a small refactor
> of local variable assignments to clean up the look.
>
> Fixes: 16eb8815c235 ("igb: Refactor clean_rx_irq to reduce overhead and i=
mprove performance")
> Reported-by: Oleksandr Natalenko <oleksandr@natalenko.name>
> Suggested-by: Alexander Duyck <alexander.duyck@gmail.com>
> Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> ---
>
> Compile tested ONLY, but functionally it should be exactly the same for
> all cases except when budget is zero on entry, which will hopefully fix
> the bug.
> ---
>  drivers/net/ethernet/intel/igb/igb_main.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethe=
rnet/intel/igb/igb_main.c
> index 0cd37ad81b4e..b0a9bed14071 100644
> --- a/drivers/net/ethernet/intel/igb/igb_main.c
> +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> @@ -7991,12 +7991,16 @@ static void igb_ring_irq_enable(struct igb_q_vect=
or *q_vector)
>   **/
>  static int igb_poll(struct napi_struct *napi, int budget)
>  {
> -       struct igb_q_vector *q_vector =3D container_of(napi,
> -                                                    struct igb_q_vector,
> -                                                    napi);
> -       bool clean_complete =3D true;
> +       struct igb_q_vector *q_vector;
> +       bool clean_complete;
>         int work_done =3D 0;
>
> +       /* if budget is zero, we have a special case for netconsole, so
> +        * make sure to set clean_complete to false in that case.
> +        */
> +       clean_complete =3D !!budget;
> +
> +       q_vector =3D container_of(napi, struct igb_q_vector, napi);
>  #ifdef CONFIG_IGB_DCA
>         if (q_vector->adapter->flags & IGB_FLAG_DCA_ENABLED)
>                 igb_update_dca(q_vector);

I'm not a big fan of moving the q_vector init as a part of this patch
since it just means more backport work.

That said the change itself should be harmless so I am good with it either =
way.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
