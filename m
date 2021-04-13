Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B345A35D530
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 04:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245445AbhDMCR4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 22:17:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239415AbhDMCRz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 22:17:55 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69893C061574;
        Mon, 12 Apr 2021 19:17:36 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id h19-20020a9d64130000b02902875a567768so3759095otl.0;
        Mon, 12 Apr 2021 19:17:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fSxsn65EUsOh+O13K1SDdQjwp4rSXw4cGvQZYhLTy4w=;
        b=UjhlUpEhCdk8GnfT/iFiLz0vCdgDf+MjXL8Tyd2IAmTDHUc8vHS2F3WZ2cVlSUOYHc
         LESa9Id11SXNBaS/JSkO/nM+n74ekN7S6CRLqmJLnd7FM2LRbbrb10+2LUUN9iqgTRIv
         ehUk+3/Oh22Gyhe1caE0cxSaqb8IMqiysqT81YgxTvOsEFAnWLi3ra+vxjlDktep+XyX
         mNiIwOM7YfFTaYhGokJovHc62i5B9FhisuioWuQrwUCI4N4lHooSNmZippkRTUPtzbdg
         vu8EhTm9LkWBLcDGUlk6Z9p/QpzpCZLDWKjfr9BZztvvdH1FtXdiBv78035SVAGdOi88
         QtqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fSxsn65EUsOh+O13K1SDdQjwp4rSXw4cGvQZYhLTy4w=;
        b=cwXBW9yP5xaIw89YrJSoKILnNwJXCvK4wB28DczlolV9DWe8aqzdDVhjQ6wtXEG4+w
         r1mnboFz2zvB/CvF7IU6S6OpURXg1yeiGEn9Jx0KzyRR6AQvpOf0F/nCh0IX9JHjeJuJ
         gxzs51keeUxjiDGPbzn3aVjPfyGAs9qEkPiF0SIk+ws/A8nr61rOdseCmewbH8G8119R
         qu0kxaPtV03AFEw0VyKQ5ldYhW7bgw+Vm1EK+fkIAzmnI5v12Hpc9OABi8I1IRHzPyi6
         f8izogppYZBka90kl6N1hLv5xE/UzGjYa/uZQ3mBjzeDd4MXcqdL/w+BAIb4GR2P7JyX
         /vug==
X-Gm-Message-State: AOAM530m4uSWfwoNrYrmbGRpkjW60riG2rBUSMmPXWEDho2xFgmx0tF1
        xPuCBsTSltw8sDvfmzBy97TtIQ+o+KqMtLkwUoRor1bB6ixuEQ==
X-Google-Smtp-Source: ABdhPJx2SV6Eb4LfwNCWO6ws/iWrTQgLal8zMyEu58hWic1n8h9aO4mro0Kl/nTW7U6wxMcIhJpqXVMh2kHHsMg+lhI=
X-Received: by 2002:a05:6830:802:: with SMTP id r2mr25324193ots.110.1618280255731;
 Mon, 12 Apr 2021 19:17:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210412065759.2907-1-kerneljasonxing@gmail.com> <20210412145229.00003e5d@intel.com>
In-Reply-To: <20210412145229.00003e5d@intel.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Tue, 13 Apr 2021 10:17:00 +0800
Message-ID: <CAL+tcoCJZBbkszE68xLRSrtfByZ3Epg7u40e2YftccUDi4034Q@mail.gmail.com>
Subject: Re: [PATCH] i40e: fix the panic when running bpf in xdpdrv mode
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     anthony.l.nguyen@intel.com, David Miller <davem@davemloft.net>,
        kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, intel-wired-lan@lists.osuosl.org,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf@vger.kernel.org,
        Jason Xing <xingwanli@kuaishou.com>,
        Shujin Li <lishujin@kuaishou.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 5:52 AM Jesse Brandeburg
<jesse.brandeburg@intel.com> wrote:
>
> kerneljasonxing@gmail.com wrote:
>
> > From: Jason Xing <xingwanli@kuaishou.com>
> >
> > Re: [PATCH] i40e: fix the panic when running bpf in xdpdrv mode
>
> Please use netdev style subject lines when patching net kernel to
> indicate which kernel tree this is targeted at, "net" or "net-next"
> [PATCH net v2] i40e: ...
>
> > Fix this by add more rules to calculate the value of @rss_size_max which
>
> Fix this panic by adding ...
>
> > could be used in allocating the queues when bpf is loaded, which, however,
> > could cause the failure and then triger the NULL pointer of vsi->rx_rings.
>
> trigger
>
> > Prio to this fix, the machine doesn't care about how many cpus are online
> > and then allocates 256 queues on the machine with 32 cpus online
> > actually.
> >
> > Once the load of bpf begins, the log will go like this "failed to get
> > tracking for 256 queues for VSI 0 err -12" and this "setup of MAIN VSI
> > failed".
> >
> > Thus, I attach the key information of the crash-log here.
> >
> > BUG: unable to handle kernel NULL pointer dereference at
> > 0000000000000000
> > RIP: 0010:i40e_xdp+0xdd/0x1b0 [i40e]
> > Call Trace:
> > [2160294.717292]  ? i40e_reconfig_rss_queues+0x170/0x170 [i40e]
> > [2160294.717666]  dev_xdp_install+0x4f/0x70
> > [2160294.718036]  dev_change_xdp_fd+0x11f/0x230
> > [2160294.718380]  ? dev_disable_lro+0xe0/0xe0
> > [2160294.718705]  do_setlink+0xac7/0xe70
> > [2160294.719035]  ? __nla_parse+0xed/0x120
> > [2160294.719365]  rtnl_newlink+0x73b/0x860
> >
> > Signed-off-by: Jason Xing <xingwanli@kuaishou.com>
> > Signed-off-by: Shujin Li <lishujin@kuaishou.com>
>
> if you send to "net" - I suspect you should supply a Fixes: line, above
> the sign-offs.
> In this case however, this bug has been here since the beginning of the
> driver, but the patch will easily apply, so please supply
>
> Fixes: 41c445ff0f48 ("i40e: main driver core")
>
> > ---
> >  drivers/net/ethernet/intel/i40e/i40e_main.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
> > index 521ea9d..4e9a247 100644
> > --- a/drivers/net/ethernet/intel/i40e/i40e_main.c
> > +++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
> > @@ -11867,6 +11867,7 @@ static int i40e_sw_init(struct i40e_pf *pf)
> >  {
> >       int err = 0;
> >       int size;
> > +     u16 pow;
> >
> >       /* Set default capability flags */
> >       pf->flags = I40E_FLAG_RX_CSUM_ENABLED |
> > @@ -11885,6 +11886,11 @@ static int i40e_sw_init(struct i40e_pf *pf)
> >       pf->rss_table_size = pf->hw.func_caps.rss_table_size;
> >       pf->rss_size_max = min_t(int, pf->rss_size_max,
> >                                pf->hw.func_caps.num_tx_qp);
> > +
> > +     /* find the next higher power-of-2 of num cpus */
> > +     pow = roundup_pow_of_two(num_online_cpus());
> > +     pf->rss_size_max = min_t(int, pf->rss_size_max, pow);
> > +
>
> The fix itself is fine, and is correct as far as I can tell, thank you
> for sending the patch!
>

Thanks for your advice. I'm going to send the patch v2 :)

Jason

> >       if (pf->hw.func_caps.rss) {
> >               pf->flags |= I40E_FLAG_RSS_ENABLED;
> >               pf->alloc_rss_size = min_t(int, pf->rss_size_max,
>
>
