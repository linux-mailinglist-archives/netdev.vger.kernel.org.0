Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92EAF3B060A
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 15:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231269AbhFVNpG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 09:45:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231289AbhFVNpF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 09:45:05 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2ECDC061756
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 06:42:48 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id m2so17113309pgk.7
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 06:42:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6rN+K++/vtavrDv2dzbgvxLGYnarSsv9ByjXTqrJ3Ws=;
        b=z6msanFIFU0lmF0RY5nlmAAa1Mg4A+zLwPn6DdR9wzyYH+bqafttnyAJ0Lr6abEbkQ
         MH8uQP+oPufhnDg0SlOLgZoS4Yc+UX4v8JEhltYLPWgKmIJKVEq53qT21LDO2cGdwxYe
         a+qyWltHavtPPetuRL8s3gXJ+4P9SuBCXGnl0jwhwuMdVhBT9bo7Hnyy/iPjIP2/bRDn
         JhJhdCvJDsCoF5GJXAIVaRIqYIaRQS8XZNMFoRvQtPX9thjR+kmrm0kZB7gXZ5PtyflH
         l+do+o6/7u9LdFpmDAohL4aTu+ULbhKOLv1kO/n/Lo4uywKneKvygkFJ4g7a4cj1k0oy
         eL4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6rN+K++/vtavrDv2dzbgvxLGYnarSsv9ByjXTqrJ3Ws=;
        b=sFicFRypn3DUQHYN0jD59Hc+VpLyYqNAJgnpkvnvgfTpuHFjMxB2LmVR55xne9CmoQ
         xSfpukP1k8tRCQU/xPStt0Jaq0aSfJdfEFWjuyYe0AOXH3A/KRbOJQX3te6Y+Q5X1ACE
         gRYzajE3rVjilPghcejGD+UOXg2kog9Uct3uXmkP8scnIq6VqqdxE31vw5kMwbemHhFq
         1rMO1TVGD+lV7CGxj9vkh4/HG1Al4JUWN2SbosnH0165Ym0Kz5NlV0qaf++0ZUWroi+3
         LxWaMTsrBJrGibXILcEwhOBpm2cb0jRgbCAo+sIMIMZBlTBNKmGdsiRUTf8m/VNNsi2W
         xbEQ==
X-Gm-Message-State: AOAM531Z4edHSsisTMwTZ0IWifF1E3BklQO0O2lsN6cEKyp//FrOAK8b
        K5/DN+bABmUxtZKDiGwXGiAOMbmtU7AUc1jXu4gwuQ==
X-Google-Smtp-Source: ABdhPJx8XDMcJc0oXhdxI2rV9wl1X9Cd6RobTja1/neX3rAhDSMmqtmqS1noFebhCX3KE0cSGMfynMo1H5XQqVrSluM=
X-Received: by 2002:a63:4a18:: with SMTP id x24mr3798502pga.303.1624369368437;
 Tue, 22 Jun 2021 06:42:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210621225100.21005-1-ryazanov.s.a@gmail.com> <20210621225100.21005-8-ryazanov.s.a@gmail.com>
In-Reply-To: <20210621225100.21005-8-ryazanov.s.a@gmail.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Tue, 22 Jun 2021 15:51:41 +0200
Message-ID: <CAMZdPi8W750LSFLNOCrgRqbS78kWTZEe5hsJenEWNVjA=Tw+Kg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 07/10] wwan: core: no more hold netdev ops
 owning module
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Jun 2021 at 00:51, Sergey Ryazanov <ryazanov.s.a@gmail.com> wrote:
>
> The WWAN netdev ops owner holding was used to protect from the
> unexpected memory disappear. This approach causes a dependency cycle
> (driver -> core -> driver) and effectively prevents a WWAN driver
> unloading. E.g. WWAN hwsim could not be unloaded until all simulated
> devices are removed:
>
> ~# modprobe wwan_hwsim devices=2
> ~# lsmod | grep wwan
> wwan_hwsim             16384  2
> wwan                   20480  1 wwan_hwsim
> ~# rmmod wwan_hwsim
> rmmod: ERROR: Module wwan_hwsim is in use
> ~# echo > /sys/kernel/debug/wwan_hwsim/hwsim0/destroy
> ~# echo > /sys/kernel/debug/wwan_hwsim/hwsim1/destroy
> ~# lsmod | grep wwan
> wwan_hwsim             16384  0
> wwan                   20480  1 wwan_hwsim
> ~# rmmod wwan_hwsim
>
> For a real device driver this will cause an inability to unload module
> until a served device is physically detached.
>
> Since the last commit we are removing all child netdev(s) when a driver
> unregister the netdev ops. This allows us to permit the driver
> unloading, since any sane driver will call ops unregistering on a device
> deinitialization. So, remove the holding of an ops owner to make it
> easier to unload a driver module. The owner field has also beed removed
> from the ops structure as there are no more users of this field.
>
> Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>

Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
