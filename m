Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7459F4FADDE
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 14:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234340AbiDJMez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 08:34:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbiDJMey (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 08:34:54 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C3025C37F
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 05:32:44 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id d4so8926918iln.6
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 05:32:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U8j4qe5zCB/oTS5Do5ySTVR4sbjdB408NL2GCcz32EA=;
        b=Ul1t9nzGIKEtZPmfHaugwAiabwfvE2/7lVDEEapSlU94iAt96HMpaDUVTMSX6nD7KM
         CiGgCSS0M6aTVRLlejn9hBeJnzCr6zrGLFs3UjdlxFZQpGhKH5S3DZ0D+hbM3WEwX0aa
         +tElIA/3AU/j8jnEJgJup8JLXG5kjfM6VdDaA0BoHAsCSfh7gu/0mtaoAtDi8ldH4Iq3
         z39tMcm1s0URY8gtxsCoKM3gvC1qENAPuKCNaACLuZTU6SnNqwi0llcpaUGxfOB0M0CK
         ktiZ2KG7HoI4HpBtAQhR2Rfo3NQdIIFsDtDHZzr16TBqyGccMHrh0q/SLE+b1BoqYsDR
         F4aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U8j4qe5zCB/oTS5Do5ySTVR4sbjdB408NL2GCcz32EA=;
        b=1/pn4TxwPLCcZtfPm2GFPc/3rHlosMPUA7SUDf0DC8n1iBr2ANBmY701X/BQ7DEng5
         Kn8WiO+J1DsC+b8yHpPtxSzD290c28g2JjYu9LznHXL1o26zhSckOhrvXftcrin+E28R
         f2vpyVVoIkLHZRSBt8nSMLypbAtEheHd1PKE0W7/gJCfAYsFbpB8Mwaa00ptsjpI8Wfy
         ZbNGUnuEGQlpC3QAhJAW6o3z2bhYbBx6xhNGyeL511tEC+iiCnBLuQd1xPpVzQJmjo41
         TOXvHGzuNpRdGp0cVNfS+I5men9XcI2JakeF0+ZEStHlWlruU5CtHyjLzpZU/jH1ohIc
         6Apg==
X-Gm-Message-State: AOAM530UnKJoU4nW3f+Xs/e9xkp6x6dAxKg4/TTGJ3RM3wwsNgR/ZZs9
        bE+SHVukttQ9UQkEEFrbgjzxoTs6OQ+PMnQlKLwG1A==
X-Google-Smtp-Source: ABdhPJwSQrJL06v1GQBZZxMGjG+H5sJyDebyBmoCr6DzBKHjt822Id6pLpUiIshQ2h1UQSTqMCuohrG4ja86wN6QE1g=
X-Received: by 2002:a92:6012:0:b0:2bd:fb5f:d627 with SMTP id
 u18-20020a926012000000b002bdfb5fd627mr11898125ilb.86.1649593963669; Sun, 10
 Apr 2022 05:32:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220403175544.26556-1-gerhard@engleder-embedded.com>
 <20220403175544.26556-2-gerhard@engleder-embedded.com> <20220410062621.GA212299@hoboy.vegasvil.org>
In-Reply-To: <20220410062621.GA212299@hoboy.vegasvil.org>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
Date:   Sun, 10 Apr 2022 14:32:32 +0200
Message-ID: <CANr-f5x-Vif5RJ5JBM+8L28byPb-E6-d0J1j5njhFiReTvXdZw@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/5] ptp: Add cycles support for virtual clocks
To:     Richard Cochran <richardcochran@gmail.com>, yangbo.lu@nxp.com
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mlichvar@redhat.com,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > @@ -225,6 +233,21 @@ struct ptp_clock *ptp_clock_register(struct ptp_clock_info *info,
> >       mutex_init(&ptp->n_vclocks_mux);
> >       init_waitqueue_head(&ptp->tsev_wq);
> >
> > +     if (!ptp->info->getcycles64 && !ptp->info->getcyclesx64) {
>
> Please swap blocks, using non-negated logical test:
>
>         if (ptp->info->getcycles64 || ptp->info->getcyclesx64)

I will change it as suggested.

> > +             /* Free running cycle counter not supported, use time. */
> > +             ptp->info->getcycles64 = ptp_getcycles64;
> > +
> > +             if (ptp->info->gettimex64)
> > +                     ptp->info->getcyclesx64 = ptp->info->gettimex64;
> > +
> > +             if (ptp->info->getcrosststamp)
> > +                     ptp->info->getcrosscycles = ptp->info->getcrosststamp;
> > +     } else {
> > +             ptp->has_cycles = true;
> > +             if (!ptp->info->getcycles64 && ptp->info->getcyclesx64)
> > +                     ptp->info->getcycles64 = ptp_getcycles64;
> > +     }
> > +
> >       if (ptp->info->do_aux_work) {
> >               kthread_init_delayed_work(&ptp->aux_work, ptp_aux_kworker);
> >               ptp->kworker = kthread_create_worker(0, "ptp%d", ptp->index);
>
>
> > @@ -231,10 +231,12 @@ static ssize_t n_vclocks_store(struct device *dev,
> >                       *(ptp->vclock_index + ptp->n_vclocks - i) = -1;
> >       }
> >
> > -     if (num == 0)
> > -             dev_info(dev, "only physical clock in use now\n");
> > -     else
> > -             dev_info(dev, "guarantee physical clock free running\n");
> > +     if (!ptp->has_cycles) {
>
> Not sure what this test means ...

I thought these dev_info() are useless if the free running cycle
counter is supported,
because the behavior of the physical clock does not change in this case.

> > +             if (num == 0)
> > +                     dev_info(dev, "only physical clock in use now\n");
>
> Shouldn't this one print even if has_cycles == false?

It will print if has_cycles == false.

In my opinion this dev_info() tells the user that the physical clock can be used
again. So it does not carry any interesting information if has_cycles == true.

> > +             else
> > +                     dev_info(dev, "guarantee physical clock free running\n");
> > +     }
> >
> >       ptp->n_vclocks = num;
> >       mutex_unlock(&ptp->n_vclocks_mux);

Thank you!

Gerhard
