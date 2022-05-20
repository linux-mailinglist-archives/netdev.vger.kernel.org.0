Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1D052E354
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 05:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345188AbiETDqx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 23:46:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240860AbiETDqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 23:46:52 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB84A30542;
        Thu, 19 May 2022 20:46:49 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id x12so6695529pgj.7;
        Thu, 19 May 2022 20:46:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/VikhDlDIJyIH73NRxQkB3ZE1WQu0G4Ns/0LJwqLnks=;
        b=mZEYcXVLOBS1Ve29MU+uG2hu32buxfY0bsbb8XSiCFttMoX5hRMSUN+zChGwJkKG8v
         W5h6OJCR+h49kSaPilh0L5wTK7Lh8oP6MIdudzZMWeXj5/i1kaaT6tlg2mVQHaOD6IfB
         W44WfRnmmgUhk7TNQ+xNPjxlWCK0Pkmu6US3Pxg74jc5UzdVNbNHB9HtUhSeXJqLm/1V
         viddMSamrI9MnAa4tuW7RJqGsJWriqSbiq2rS+AONczyMSot8p3uCpPrfALXfYVPdI4c
         Ks1QOgKEnsZyBCzNqMEkTac3JSziGE0qU8hPYrbDoiNU3gy/efRQay/AzskhyrPOKry3
         C90A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/VikhDlDIJyIH73NRxQkB3ZE1WQu0G4Ns/0LJwqLnks=;
        b=qbpE6SmKn6VehAPG0/S6hYej7CEII8knVPiSAUX9WfWAMTiR31qQiNglL1q452inF4
         WGkEyGl0IMtmoJCaCc/dTkKYqyxwEgMnocuMjYiKuAa82TdhpIEF+/QJii4DKfQMoT3I
         XQjlI/9JMH2lMZ/un29t2ePQR27nrTcm2f949pOn4Q/yQR0K3Sm/Yf3O79FqhwpXhltL
         ENCoyihIaFnhFrcJaiLeMwoovJzr2Sf+2fjK0pdL97CxbHwl2REaDcAdHMCzwO2hm442
         Nm+Ssb4Pkj4zRHy2fZqIoJPvLLYe3JCgKAC1JROnjZr27a7jAop8mzFx8d/cnnOg2888
         Pa3g==
X-Gm-Message-State: AOAM532i10VfESj7Ps/oYLFIodvImXaMMk+GmmB98Z/9d8JCCMvoKKmu
        AhJTpk6gihdNKIVmyxtcMDGwcybjJc8m1DMjIw==
X-Google-Smtp-Source: ABdhPJzrQ6ntAU/WFr+YDc3l0WoI1X1KLri6KUai1jfgGpDhODlE7mGaZ7jWf6iVZaGLz1316hhvwsUeoN2TmNgStx0=
X-Received: by 2002:a63:d3:0:b0:3f6:139:d62 with SMTP id 202-20020a6300d3000000b003f601390d62mr6646266pga.113.1653018409307;
 Thu, 19 May 2022 20:46:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220409062449.3752252-1-zheyuma97@gmail.com> <CA++WF2Np7Bk_qT68Uc3mrC38mN5p3fm9eVT7VA8NoX6=es2r2w@mail.gmail.com>
 <CAMhUBjkWcg4+YYynsd90jX1A+zp95tUUcLgYrTPAqSmbxM7TJA@mail.gmail.com> <CA++WF2MFwtKs8-uy+e_77P0ySsN8y6W_8+Z8AdxBKsutcYK-ig@mail.gmail.com>
In-Reply-To: <CA++WF2MFwtKs8-uy+e_77P0ySsN8y6W_8+Z8AdxBKsutcYK-ig@mail.gmail.com>
From:   Zheyu Ma <zheyuma97@gmail.com>
Date:   Fri, 20 May 2022 11:46:38 +0800
Message-ID: <CAMhUBjmbfYCiNvgVkC7x0QQLCxsttEX9CpHOK=N+Gt4YxUCu2Q@mail.gmail.com>
Subject: Re: [PATCH] wireless: ipw2x00: Refine the error handling of ipw2100_pci_init_one()
To:     Stanislav Yakovlev <stas.yakovlev@gmail.com>
Cc:     kvalo@kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, pabeni@redhat.com,
        wireless <linux-wireless@vger.kernel.org>,
        netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 23, 2022 at 3:25 AM Stanislav Yakovlev
<stas.yakovlev@gmail.com> wrote:
>
> Hi Zheyu,
>
> On 18/04/2022, Zheyu Ma <zheyuma97@gmail.com> wrote:
> > On Thu, Apr 14, 2022 at 2:40 AM Stanislav Yakovlev
> > <stas.yakovlev@gmail.com> wrote:
> >>
> >> On Sat, 9 Apr 2022 at 02:25, Zheyu Ma <zheyuma97@gmail.com> wrote:
> >> >
> >> > The driver should release resources in reverse order, i.e., the
> >> > resources requested first should be released last, and the driver
> >> > should adjust the order of error handling code by this rule.
> >> >
> >> > Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
> >> > ---
> >> >  drivers/net/wireless/intel/ipw2x00/ipw2100.c | 34 +++++++++-----------
> >> >  1 file changed, 16 insertions(+), 18 deletions(-)
> >> >
> >> [Skipped]
> >>
> >> > @@ -6306,9 +6303,13 @@ static int ipw2100_pci_init_one(struct pci_dev
> >> > *pci_dev,
> >> >  out:
> >> >         return err;
> >> >
> >> > -      fail_unlock:
> >> > +fail_unlock:
> >> >         mutex_unlock(&priv->action_mutex);
> >> > -      fail:
> >> > +fail:
> >> > +       pci_release_regions(pci_dev);
> >> > +fail_disable:
> >> > +       pci_disable_device(pci_dev);
> >> We can't move these functions before the following block.
> >>
> >> > +fail_dev:
> >> >         if (dev) {
> >> >                 if (registered >= 2)
> >> >                         unregister_netdev(dev);
> >> This block continues with a function call to ipw2100_hw_stop_adapter
> >> which assumes that device is still accessible via pci bus.
> >
> > Thanks for your reminder, but the existing error handling does need to
> > be revised, I got the following warning when the probing fails at
> > pci_resource_flags():
> >
> > [   20.712160] WARNING: CPU: 1 PID: 462 at lib/iomap.c:44
> > pci_iounmap+0x40/0x50
> > [   20.716583] RIP: 0010:pci_iounmap+0x40/0x50
> > [   20.726342]  <TASK>
> > [   20.726550]  ipw2100_pci_init_one+0x101/0x1ee0 [ipw2100]
> >
> > Since I am not familiar with the ipw2100, could someone give me some
> > advice to fix this.
>
> Could you please rebuild the kernel with IPW2100_DEBUG config option
> enabled, rerun the test and post your results here? Also, please post
> the output of "lspci -v" here.

Sorry for the late response.
I have rebuilt the kernel with IPW2100_DEBUG, and got the following result:

[   29.469624] libipw: 802.11 data/management/control stack, git-1.1.13
[   29.470034] libipw: Copyright (C) 2004-2005 Intel Corporation
<jketreno@linux.intel.com>
[   29.477455] ipw2100: Intel(R) PRO/Wireless 2100 Network Driver, git-1.2.2
[   29.477833] ipw2100: Copyright(c) 2003-2006 Intel Corporation
[   29.478197] ipw2100Error calling ioremap.
[   29.478398] ------------[ cut here ]------------
[   29.478630] Bad IO access at port 0x0 ()
[   29.478834] WARNING: CPU: 0 PID: 304 at lib/iomap.c:44 pci_iounmap+0x40/0x50
[   29.481116] RIP: 0010:pci_iounmap+0x40/0x50
[   29.485282] Call Trace:
[   29.485407]  <TASK>
[   29.485514]  ipw2100_pci_init_one+0x192/0x20c0 [ipw2100]
[   29.487496]  local_pci_probe+0x13f/0x200

Actually, I made a special virtual device to test this driver, not
real hardware, so the "lspci" results are irrelevant here.
I injected a software fault in the pci_iomap() function to force the
driver to fail here, and then the driver goto "fail" tag, and under
the "fail" tag the pci_iounmap() is called, resulting in a crash.
In fact such error handling is incorrect and we should not release
resources that have not been requested yet.

Thanks,
Zheyu Ma
