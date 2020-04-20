Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82AAD1B0EA7
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 16:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730033AbgDTOiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 10:38:52 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:56123 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730030AbgDTOiv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 10:38:51 -0400
Received: from mail-qv1-f43.google.com ([209.85.219.43]) by
 mrelayeu.kundenserver.de (mreue106 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1M5g68-1jKTp51flS-007GCE; Mon, 20 Apr 2020 16:38:49 +0200
Received: by mail-qv1-f43.google.com with SMTP id p13so4739694qvt.12;
        Mon, 20 Apr 2020 07:38:49 -0700 (PDT)
X-Gm-Message-State: AGi0PubeLOHIFr+q6MdDkl4lsROusM2wrT+4cZYEpYJ85VuMcyrmcMDT
        KklW3S3g2K8LdxeYbmezCkcjKspwlF+fcXrjwwI=
X-Google-Smtp-Source: APiQypI3lMjarwBrOvk5z/7dRwm3+aExp21uRLy8rLXkUHXJMJ56+Iub039Oa9WO9CTS7wUa1aJc481OluDjX+031BM=
X-Received: by 2002:a0c:eb11:: with SMTP id j17mr15247436qvp.197.1587393528146;
 Mon, 20 Apr 2020 07:38:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200416085627.1882-1-clay@daemons.net> <6fef3a00-6c18-b775-d1b4-dfd692261bd3@ti.com>
 <20200420093610.GA28162@arctic-shiba-lx>
In-Reply-To: <20200420093610.GA28162@arctic-shiba-lx>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 20 Apr 2020 16:38:32 +0200
X-Gmail-Original-Message-ID: <CAK8P3a36ZxNJxUS4UzrwJiMx8UrgYPkcv4X6yYw7EC4jRBbbGQ@mail.gmail.com>
Message-ID: <CAK8P3a36ZxNJxUS4UzrwJiMx8UrgYPkcv4X6yYw7EC4jRBbbGQ@mail.gmail.com>
Subject: Re: [PATCH] net: cpts: Condition WARN_ON on PTP_1588_CLOCK
To:     Clay McClure <clay@daemons.net>
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sekhar Nori <nsekhar@ti.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:Lmfro+z52/v9+PRc0aC+yIa6QG4vLVKhVAGm/vpSmVpGr58hA8V
 NTX2p+r9e5q/P34ZBCXfCsacArwKIQjfaANvptrHm7Z4a26Gsae+G3uSFLQlRnnpf5dvbim
 SIRd6bsCWFA1TvTksc9ps2YAcje4zwfvbCzY3UzGDbDG5XvFidAFJ1jxsFPrOFfxBVasdKi
 x42089Ni2C2x5j/X7R9bA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:w2gl9SsonXU=:hNvQCu59NPRR1VA4T2tUWe
 nIYuK5PQIUEoh3vp9EhTJeR0bQy1iHFhnt2CcDjl1bst5f77ker+ryoBJR6UP9f3lfYwOFCXL
 aIXjpZHcvl/rPHswaqc8DLUuwZ6iMk64oH7mWiR3eJN6Pxw2DzyTq+ZS1J/oorSTsrLgjA+3U
 aqgauk07rMq6ei5eevYTasZIrW56vXFLOmtoU1rPgIAoQRJ2z4OIKsqcQUzpm2USlUwtleuN7
 t2YDlKO4s5Txy0PYDaJGT3HKyMiBax8oiaGVB4ljPKjsjK7fisV6rNc1+SprfL3QDI+wXpJFF
 z4zLSZ4Uuf3gXz13Xf7owHlu13f3AXneTJO9bhzkD1gE0SoiOgf+AKqBGrjdJKsv40h4mzxGZ
 H5oOZaHGxy7oT8HsnyPcSYgXmxvah8OdrI2Y35HtrTRqURi+aEUwRzbD+t61HgdUl+E7MjsVk
 G9GxeB1Cc+evXpNISQWJolDffwXXwcIlwZukN4CAtchLxKIYt7jrFwUFpHBzl9Wj2l4P+87gq
 VFtQjOfaddxBCCfW3yL5Hcs9ioqK83MmQ+udp08qPLGxRzwBswiP2IfZmuwlFS0LOhB6RvfL0
 yIWaE82l8W23TlUw1gVzcjsRqCVUMxZJ6xm9MoOK/EBK66tRGD2CD7+1/J23a9jDXMH92VqJ+
 rYVT98KFfH6p0pgFbgqWJCQt3xRePBx8rGUGUFI2HYVPRqgXPrNKfM6CMyNpH+iq6stGsexUs
 PxjsVf1EgfBrqPBuZhFfJAzs5O+2plhi2G+eUBPcCbTYn6L15r7ZHUkdNlZTo1jqvtiAA6xNq
 IQJi8g0XEZ6L7FLNyhNuZZfdsQSz7nRAbJxz/hnGPut84/fyUo=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 20, 2020 at 11:38 AM Clay McClure <clay@daemons.net> wrote:
> On Thu, Apr 16, 2020 at 02:11:45PM +0300, Grygorii Strashko wrote:
>
> > > CPTS_MOD merely implies PTP_1588_CLOCK; it is possible to build cpts
> > > without PTP clock support. In that case, ptp_clock_register() returns
> > > NULL and we should not WARN_ON(cpts->clock) when downing the interface.
> > > The ptp_*() functions are stubbed without PTP_1588_CLOCK, so it's safe
> > > to pass them a null pointer.
> >
> > Could you explain the purpose of the exercise (Enabling CPTS with
> > PTP_1588_CLOCK disabled), pls?
>
> Hardware timestamping with a free-running PHC _almost_ works without
> PTP_1588_CLOCK, but since PHC rollover is handled by the PTP kworker
> in this driver the timestamps end up not being monotonic.
>
> And of course the moment you want to syntonize/synchronize the PHC with
> another clock (say, CLOCK_REALTIME), you'll need a PTP clock device. So
> you're right, there's not much point in building CPTS_MOD without
> PTP_1588_CLOCK.
>
> Given that, I wonder why all the Ethernet drivers seem to just `imply`
> PTP_1588_CLOCK, rather than `depends on` it?

I suspect we should move all of them back. This was an early user
of 'imply', but the meaning of that keyword has now changed
in the latest Kconfig.

> diff --git a/drivers/net/ethernet/ti/cpts.c b/drivers/net/ethernet/ti/cpts.c
> index 10ad706dda53..70b15039cd37 100644
> --- a/drivers/net/ethernet/ti/cpts.c
> +++ b/drivers/net/ethernet/ti/cpts.c
> @@ -462,8 +462,8 @@ int cpts_register(struct cpts *cpts)
>         timecounter_init(&cpts->tc, &cpts->cc, ktime_get_real_ns());
>
>         cpts->clock = ptp_clock_register(&cpts->info, cpts->dev);
> -       if (IS_ERR(cpts->clock)) {
> -               err = PTR_ERR(cpts->clock);
> +       if (IS_ERR_OR_NULL(cpts->clock)) {
> +               err = cpts->clock ? PTR_ERR(cpts->clock) : -EOPNOTSUPP;
>                 cpts->clock = NULL;
>                 goto err_ptp;

Something else is wrong if you need IS_ERR_OR_NULL(). Any
kernel interface should either return an negative error code when
something goes wrong, or should return NULL for all errors, but
not mix the two.

        Arnd
