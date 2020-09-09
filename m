Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D56DF2638E0
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 00:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728405AbgIIWMn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 18:12:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbgIIWMk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 18:12:40 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E09C1C061573
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 15:12:37 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id l4so3859750ilq.2
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 15:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SWXX7iJOFv4pgSEDscNMIExXkwK6Wq3Ylz27lBPl5ZQ=;
        b=SuhHUI5Szn/4qH2gGDjatVZT8nQ/T46KieAzDNM2b1sknyMjjUJC4tod6lVfhfRKEM
         mojnlb8Fzev9HDHuF5jGRm7TMYj3Kbg3dgC0yiqaZokyBs4uhcb6awFcSWzgc3xaruHQ
         qzgqEN6A5O15DDrCrtAA24MVtKwaCtGzdb/9O80h1ECdxCJsTBdJWlfjaMz2oruBuRZA
         /mA2OpOQyXASlEHa6wjiEGt+uiBGA+QZ1oEHmgeLpxul75z5z84vVdUZDuHF7DdqUMJT
         Bhv0Bkfb6ssq1D/wBN6FvIy5fDn1y9mLXIF0LicyPuk47c9VtTLin3FK9mikYDsHey62
         XJrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SWXX7iJOFv4pgSEDscNMIExXkwK6Wq3Ylz27lBPl5ZQ=;
        b=R7Z/Af/fPS8NS6Sd/MRLDNTT0+hlRsKXAGto82TkuM6zAuV+/u5OO4F8+gWWU1N9Fu
         nQUm7cbHHwFn+kchhk0f+OWfXMcuy00QSPmDA4NitYVI0y3FQAFXLYIAy0Q23t4Pu3dL
         ZsjV/4eYLDEkDRABO9gdG4PLpbR8ivAtc3sv8JQjLeArj7VoSDNx2UEzE7U6pU3d6GH/
         X4523XsOwW96AqZ18NkTRcuPDGzfD4ToVdiIYti1/4nEUMx56gmzY4Pi+D9nzHiygs85
         nALasGARnVbRvhISwON8PwWus6WPj6yaDyAgk6D9cJrJ18OLd3WFVylt6nC6JSDJrR8h
         rMBQ==
X-Gm-Message-State: AOAM531Ft5lMVySbp3dBe98c9iQbbt8gHIz+awBIckvnPqvmkJ2qCkt3
        ODAqpV0Y/o+GHqxkmuggPFXC3J0Env8R91XDukNy4w==
X-Google-Smtp-Source: ABdhPJxiMsBxn0yRRjgwxvm+JAkmKJ0d07QdAsZ3bfkXA8ujaiLvq/+Puh1UteiHL4dB5/KUW2qInkosgxj8zV7Frws=
X-Received: by 2002:a05:6e02:ed2:: with SMTP id i18mr4162876ilk.124.1599689556979;
 Wed, 09 Sep 2020 15:12:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200908183909.4156744-1-awogbemila@google.com>
 <20200908183909.4156744-6-awogbemila@google.com> <20200908122440.580c0a10@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200908122440.580c0a10@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   David Awogbemila <awogbemila@google.com>
Date:   Wed, 9 Sep 2020 15:12:26 -0700
Message-ID: <CAL9ddJeKNXYqvGEoHAFx0fmgMdMhkiFk+qu_Uo1sS6+ZBLZo-Q@mail.gmail.com>
Subject: Re: [PATCH net-next v3 5/9] gve: Add Gvnic stats AQ command and
 ethtool show/set-priv-flags.
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Kuo Zhao <kuozhao@google.com>,
        Yangchun Fu <yangchun@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 8, 2020 at 12:24 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue,  8 Sep 2020 11:39:05 -0700 David Awogbemila wrote:
> > +     /* Only one priv flag exists: report-stats (BIT(0))*/
> > +     if (flags & BIT(0))
> > +             new_flags |= BIT(0);
> > +     else
> > +             new_flags &= ~(BIT(0));
> > +     priv->ethtool_flags = new_flags;
> > +     /* update the stats when user turns report-stats on */
> > +     if (flags & BIT(0))
> > +             gve_handle_report_stats(priv);
> > +     /* zero off gve stats when report-stats turned off */
> > +     if (!(flags & BIT(0)) && (ori_flags & BIT(0))) {
> > +             int tx_stats_num = GVE_TX_STATS_REPORT_NUM *
> > +                     priv->tx_cfg.num_queues;
> > +             int rx_stats_num = GVE_RX_STATS_REPORT_NUM *
> > +                     priv->rx_cfg.num_queues;
> > +
> > +             memset(priv->stats_report->stats, 0, (tx_stats_num + rx_stats_num) *
> > +                                sizeof(struct stats));
> > +     }
>
> I don't understand why you don't cancel/start the timer when this flag
> is changed. Why waste the CPU cycles on handling a useless timer?
Thanks, I'll adjust this to turn the timer on/off when the flag is
turned on/off.
