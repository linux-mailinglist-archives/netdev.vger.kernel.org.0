Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 636D32873F5
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 14:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729820AbgJHMXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 08:23:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729745AbgJHMXY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 08:23:24 -0400
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16A36C0613D2
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 05:23:24 -0700 (PDT)
Received: by mail-vs1-xe43.google.com with SMTP id v23so346229vsp.6
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 05:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6yaLQlxNw70bRGmpr47sIPOg0JWUbIqHrAviNgxR9U8=;
        b=ZV/udlGzIl/jBrUJkuN1KwkLbErRiww1AXfbdYjhu4aftSNTMtV4+PM1BRjHauZxfp
         HbtfbtxaCjWO7kt3kz8IqDCxFVt6zufkjs0R5JcP1kz9I5bfIyMblsiuAEvsfk4IJitP
         k7F6hH3KcaYkZgb85VTdANYMENGpTOqykJwHPOTx+/h7Lk61QKg66tm/uB+lty3qHwiW
         GEqGpwFCwllORWVB21LnPAoTOZk+p4jhax1BUnlUQoHo1whWYCl7pItcKd+vz4XSCK5I
         gNwxPHcFXodJUNDYPYp7haWTvUmJiATg0vIwrH1GHoNVL4t1C2nyWafuHOFtVW9XD5+C
         tTzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6yaLQlxNw70bRGmpr47sIPOg0JWUbIqHrAviNgxR9U8=;
        b=t2o3b5IwF40ZpXdKldH/6cUno7jEBHUjEHe77f/4NEY5q0GvTF+5w6wtdYZj6Hn/do
         9enJ2nQuJ80kzzU7El3G1A8Me1tqavFBJN6W/+WdZPi8GSr9oh4GZaZAMFQGq/K0xlGC
         hmd+ZaIP0fK7pjyMqLaBCkAg+Np+IaD+S0H9Q6yyKEAZWjz9QxJaV+NfqtuaqNROq2Xv
         vJabNrSact0EAeBRa1tZZccJWB37eyNzAPEzQiPQqxCYCpRJXWDB/lQJZ5xsEqH0J+av
         0LTunGQxLbla9yRK+RxASJUELufZKnwgOzGep5tb30beR02uGl98RKMRGBvrqALD47x0
         LAeg==
X-Gm-Message-State: AOAM530RJMT5ZX89D5tKUD25yNk/4JubfNRgWwN8nX+1iceHZaKAVd1O
        6NA1DHYcCMT/qIJDz9d033HNmV5pcsI=
X-Google-Smtp-Source: ABdhPJwFkIn6Lj7BsbMY+J3jJppdZBTOrzeFW571H2IG7PCrRLfpTcVlys7TZwnbHjtQuoOaa5hlWA==
X-Received: by 2002:a67:6c86:: with SMTP id h128mr4262889vsc.42.1602159802431;
        Thu, 08 Oct 2020 05:23:22 -0700 (PDT)
Received: from mail-vs1-f52.google.com (mail-vs1-f52.google.com. [209.85.217.52])
        by smtp.gmail.com with ESMTPSA id f3sm695887vkk.32.2020.10.08.05.23.21
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2020 05:23:21 -0700 (PDT)
Received: by mail-vs1-f52.google.com with SMTP id r1so1899297vsi.12
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 05:23:21 -0700 (PDT)
X-Received: by 2002:a67:d84:: with SMTP id 126mr4218029vsn.51.1602159800489;
 Thu, 08 Oct 2020 05:23:20 -0700 (PDT)
MIME-Version: 1.0
References: <20201008115808.91850-1-coiby.xu@gmail.com> <20201008115808.91850-2-coiby.xu@gmail.com>
In-Reply-To: <20201008115808.91850-2-coiby.xu@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 8 Oct 2020 08:22:44 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdEK+0nBCd5KAYpbEECmSvjoMEgcEOtM+ZKFF4QQKuAfw@mail.gmail.com>
Message-ID: <CA+FuTSdEK+0nBCd5KAYpbEECmSvjoMEgcEOtM+ZKFF4QQKuAfw@mail.gmail.com>
Subject: Re: [PATCH v1 1/6] staging: qlge: Initialize devlink health dump
 framework for the dlge driver
To:     Coiby Xu <coiby.xu@gmail.com>
Cc:     devel@driverdev.osuosl.org,
        Benjamin Poirier <benjamin.poirier@gmail.com>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Manish Chopra <manishc@marvell.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:QLOGIC QLGE 10Gb ETHERNET DRIVER" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 8, 2020 at 7:58 AM Coiby Xu <coiby.xu@gmail.com> wrote:
>
> Initialize devlink health dump framework for the dlge driver so the
> coredump could be done via devlink.
>
> Signed-off-by: Coiby Xu <coiby.xu@gmail.com>

> @@ -4556,6 +4559,13 @@ static int qlge_probe(struct pci_dev *pdev,
>         struct ql_adapter *qdev = NULL;
>         static int cards_found;
>         int err = 0;
> +       struct devlink *devlink;
> +       struct qlge_devlink *ql_devlink;
> +
> +       devlink = devlink_alloc(&qlge_devlink_ops, sizeof(struct qlge_devlink));
> +       if (!devlink)
> +               return -ENOMEM;
> +       ql_devlink = devlink_priv(devlink);
>
>         ndev = alloc_etherdev_mq(sizeof(struct ql_adapter),
>                                  min(MAX_CPUS,

need to goto devlink_free instead of return -ENOMEM here, too.

> @@ -4614,6 +4624,16 @@ static int qlge_probe(struct pci_dev *pdev,
>                 free_netdev(ndev);
>                 return err;

and here

>         }
> +
> +       err = devlink_register(devlink, &pdev->dev);
> +       if (err) {
> +               goto devlink_free;
> +       }
> +
> +       qlge_health_create_reporters(ql_devlink);
> +       ql_devlink->qdev = qdev;
> +       ql_devlink->ndev = ndev;
> +       qdev->ql_devlink = ql_devlink;
>         /* Start up the timer to trigger EEH if
>          * the bus goes dead
>          */
> @@ -4624,6 +4644,10 @@ static int qlge_probe(struct pci_dev *pdev,
>         atomic_set(&qdev->lb_count, 0);
>         cards_found++;
>         return 0;
> +
> +devlink_free:
> +       devlink_free(devlink);
> +       return err;
>  }
