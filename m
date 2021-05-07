Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8608637681C
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 17:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237969AbhEGPgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 11:36:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236209AbhEGPf6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 11:35:58 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7064CC061574
        for <netdev@vger.kernel.org>; Fri,  7 May 2021 08:34:58 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id gq14-20020a17090b104eb029015be008ab0fso5441668pjb.1
        for <netdev@vger.kernel.org>; Fri, 07 May 2021 08:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JjLxc1gE4zTEm+ur3BD5goxnNP9vlhrdsXVrtbr+H6U=;
        b=myz7+8s0Nf4RRZaK13lgfJyCZnBRGRctGGS3QSVCaGIhgG6znUyUpJfwFjXSdAjphS
         86NlcJvEwVVcbR9aprZa051RGPk95cp/H1RQUcJ4OgwyxC4vMIot3fkw/9ueUxj9IMDW
         ECDOJxxY8ykgSo60NGk6PGgeqiNm/9Mily52nXdmVLoSAriBKG3tTssS1UvjoUl4NYgu
         60JGZD226BCiBBdDBDbalJyL+WZZYj2qA9FCNWg28Iv69YtxjTAu183nawyMs5txZM8z
         aHo8BMmDFHaaS9RfPb8Yc5IRmx7NkBaov0D1RS60ZcxqVFQs5VVEtBwy8Welhbb4zK72
         zgww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JjLxc1gE4zTEm+ur3BD5goxnNP9vlhrdsXVrtbr+H6U=;
        b=aUKq+uiHqotjs+vemwGENGnBqIffHZJVvwxBwA/Mm5wWPMe/oamBlo+xFmMZUbMF4m
         jNZyYI7YfywIvfoJQ9jzKsERJHwsCYKYpWbKXnmqoz7PK19upTPQIJtr10CZNrbQggIm
         t+PfLGw9WQSJyUUWe4Uiu7A4IJ4IBeRXRHXycKI6tG8jZupZ8vBbdDsnhGDNgf/dTN1n
         C0TmqV8mNFWQZWjNS1p4XvMUt/u/7sMGOJsw8osf6SUmaMuhb5YDOrRVCRlqu/1YmRve
         nqQrNp7fdj24xJbhblKjudNmtrC+5jJuMq9V13Y+zYb/p4ytZVMyzlUuiUceAtRSweAT
         zvJg==
X-Gm-Message-State: AOAM530PaaJQDBrgMcRUrMB4M2JKnd1u+tSpHu29NKROjOR1KPWF9HWI
        s8Hm7AuoWyrzTUtu/gF9P0KxM/tP9j6TdXZNBPZKew==
X-Google-Smtp-Source: ABdhPJzAJhJKcj+oqzprYDBQpQBsBeYhgXEh360O1Z359JNkGBKerpZ8jsZKimV1hWcT3U0c/x+AGq9gfN3Zi4v2lzk=
X-Received: by 2002:a17:90a:a60b:: with SMTP id c11mr10947257pjq.125.1620401697927;
 Fri, 07 May 2021 08:34:57 -0700 (PDT)
MIME-Version: 1.0
References: <421cc86c-b66f-b372-32f7-21e59f9a98bc@kontron.de> <CAHCN7xJCUtmi1eOftFq0mg28SFyt2a34q3Vy8c0fvOs5wHC-yg@mail.gmail.com>
In-Reply-To: <CAHCN7xJCUtmi1eOftFq0mg28SFyt2a34q3Vy8c0fvOs5wHC-yg@mail.gmail.com>
From:   Tim Harvey <tharvey@gateworks.com>
Date:   Fri, 7 May 2021 08:34:47 -0700
Message-ID: <CAJ+vNU2_VQRYzJKnHkLpJUYY7KZNGC8_fHj_7VcUdvHkbzFWGQ@mail.gmail.com>
Subject: Re: i.MX8MM Ethernet TX Bandwidth Fluctuations
To:     Adam Ford <aford173@gmail.com>,
        Frieder Schrempf <frieder.schrempf@kontron.de>
Cc:     NXP Linux Team <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 6, 2021 at 12:20 PM Adam Ford <aford173@gmail.com> wrote:
>
> On Thu, May 6, 2021 at 9:51 AM Frieder Schrempf
> <frieder.schrempf@kontron.de> wrote:
> >
> > Hi,
> >
> > we observed some weird phenomenon with the Ethernet on our i.MX8M-Mini boards. It happens quite often that the measured bandwidth in TX direction drops from its expected/nominal value to something like 50% (for 100M) or ~67% (for 1G) connections.
> >
> > So far we reproduced this with two different hardware designs using two different PHYs (RGMII VSC8531 and RMII KSZ8081), two different kernel versions (v5.4 and v5.10) and link speeds of 100M and 1G.
> >
> > To measure the throughput we simply run iperf3 on the target (with a short p2p connection to the host PC) like this:
> >
> >         iperf3 -c 192.168.1.10 --bidir
> >
> > But even something more simple like this can be used to get the info (with 'nc -l -p 1122 > /dev/null' running on the host):
> >
> >         dd if=/dev/zero bs=10M count=1 | nc 192.168.1.10 1122
> >
> > The results fluctuate between each test run and are sometimes 'good' (e.g. ~90 MBit/s for 100M link) and sometimes 'bad' (e.g. ~45 MBit/s for 100M link).
> > There is nothing else running on the system in parallel. Some more info is also available in this post: [1].
> >
> > If there's anyone around who has an idea on what might be the reason for this, please let me know!
> > Or maybe someone would be willing to do a quick test on his own hardware. That would also be highly appreciated!
>
> I have seen a similar regression on linux-next on both Mini and Nano.
> I thought I broke something, but it returned to normal after a reboot.
>   However, with a 1Gb connection, I was running at ~450 Mbs which is
> consistent with what you were seeing with a 100Mb link.
>
> adam
>

Frieder,

I've noticed this as well on our designs with IMX8MN+DP83867 and
IMX8MM+KSZ9897S. I also notice it with IMX8MN+DP83867. I have noticed
it on all kernels I've tested and it appears to latch back and forth
every few times I run a 10s iperf3 between 50% and 100% line speed.

I have no idea what it is but glad you are asking and hope someone
knows how to fix it!

Best Regards,

Tim
