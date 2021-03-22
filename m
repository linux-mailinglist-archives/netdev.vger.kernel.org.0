Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4FCC344FE8
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 20:30:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231307AbhCVTaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 15:30:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231438AbhCVT35 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 15:29:57 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A952C061574
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 12:29:57 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id jy13so23174773ejc.2
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 12:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+vrCEtnNzpF2lGZIvRFUNbDWkPOqF8VGlcmZG441UqU=;
        b=cARzWt+icePoEAme6f9ViejW8T+Lm8fg9DVr2VZCwFI01YACmjAvS1cFcJV4LdMBNf
         buTG1JG9tb4YYYgalLd/wB4f810bWTvMPfoj0NwpUqysq3kVPilwQ0hWNXaMlEXWy7Cn
         YcMK5jBNFAooMqXnX3n4drNroneHTEezQ3EBgPpe+Zh/UPaivOHJH+73DrdoLSyXuwL7
         8oI9vR2mRcxkamvK1hN0Zgn8igBODZ6kF1BtSZ2pXyqT40WI2N+HvXVIHAqdbXjo/Iz7
         AZMl9e/5oHflnVhVOHcicUHw2voKwE6GCLH+G4+93GOY+d+Cb3HgLxpt1epq3Us+JcBd
         WgAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+vrCEtnNzpF2lGZIvRFUNbDWkPOqF8VGlcmZG441UqU=;
        b=I9Pfm3iruQmbHxtPMagW9hqq6sFaBCOfePoERKMVRMEGPpW4qgRwwfuM4hPF/5uOyO
         WO0UJAITiM4z2PdKEqqqGaEUIiDCIxse+PNRueX4RkybaT7rRDBJPnAgKY8+uqOEhnZe
         SH9qxyfDcJn3LetxZ1feYcY94KrYbGf/3qF/NBZ5oIMmrPGalYy1rRNBIjyUS4zSpCg6
         nPgdYOa+rxHYDC8d3hIquFeNgkkHqbRKHQLEXMAGAxQNSMoRcFSseAJbtFSjcfqhu5li
         yfsJCrorHVMK3JLqXqGnQIC5t6S+H5E/80wYyGqHP8grLd9Kl25GtPEQw/FTKC4ecexL
         q9XQ==
X-Gm-Message-State: AOAM531V2IFd+zPzZODd2Jxe0vOtEv4bmELf1jhIpfC5bbapBxH4GU2J
        cTDZ3ZVXRL5nHDBoWLZYNmoINHknjHNOOuSwLA3FhA==
X-Google-Smtp-Source: ABdhPJwMlMempyUD18tUPCMYyfirlTw+DuCk3V0KF0ToOolMrcuVOKqhA0PuA0hcW0leH4yIeWL0xfdOlaVwqdexNP0=
X-Received: by 2002:a17:906:5689:: with SMTP id am9mr1317762ejc.298.1616441395706;
 Mon, 22 Mar 2021 12:29:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210322182145.531377-1-eric.dumazet@gmail.com>
In-Reply-To: <20210322182145.531377-1-eric.dumazet@gmail.com>
From:   Guenter Roeck <groeck@google.com>
Date:   Mon, 22 Mar 2021 12:29:44 -0700
Message-ID: <CABXOdTf0iw6J67B581nvKM5nyi5cMQqMntUN-_W4mv9faq-Lfg@mail.gmail.com>
Subject: Re: [PATCH net-next] net: set initial device refcount to 1
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 22, 2021 at 11:21 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> When adding CONFIG_PCPU_DEV_REFCNT, I forgot that the
> initial net device refcount was 0.
>
> When CONFIG_PCPU_DEV_REFCNT is not set, this means
> the first dev_hold() triggers an illegal refcount
> operation (addition on 0)
>
> refcount_t: addition on 0; use-after-free.
> WARNING: CPU: 0 PID: 1 at lib/refcount.c:25 refcount_warn_saturate+0x128/0x1a4
>
> Fix is to change initial (and final) refcount to be 1.
>
> Also add a missing kerneldoc piece, as reported by
> Stephen Rothwell.
>
> Fixes: 919067cc845f ("net: add CONFIG_PCPU_DEV_REFCNT")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Guenter Roeck <groeck@google.com>

The problems observed with next-20210322 are gone with this patch applied.

Tested-by: Guenter Roeck <groeck@google.com>

Thanks,
Guenter

> ---
>  include/linux/netdevice.h | 1 +
>  net/core/dev.c            | 9 ++++++---
>  2 files changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 8f003955c485b81210ed56f7e1c24080b4bb46eb..b11c2c1890b2a28ba2d02fc4466380703a12efaf 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -1792,6 +1792,7 @@ enum netdev_ml_priv_type {
>   *
>   *     @proto_down_reason:     reason a netdev interface is held down
>   *     @pcpu_refcnt:           Number of references to this device
> + *     @dev_refcnt:            Number of references to this device
>   *     @todo_list:             Delayed register/unregister
>   *     @link_watch_list:       XXX: need comments on this one
>   *
> diff --git a/net/core/dev.c b/net/core/dev.c
> index be941ed754ac71d0839604bcfdd8ab67c339d27f..95c78279d900796c8a3ed0df59b168d5c5e0e309 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -10348,7 +10348,7 @@ static void netdev_wait_allrefs(struct net_device *dev)
>         rebroadcast_time = warning_time = jiffies;
>         refcnt = netdev_refcnt_read(dev);
>
> -       while (refcnt != 0) {
> +       while (refcnt != 1) {
>                 if (time_after(jiffies, rebroadcast_time + 1 * HZ)) {
>                         rtnl_lock();
>
> @@ -10385,7 +10385,7 @@ static void netdev_wait_allrefs(struct net_device *dev)
>
>                 refcnt = netdev_refcnt_read(dev);
>
> -               if (refcnt && time_after(jiffies, warning_time + 10 * HZ)) {
> +               if (refcnt != 1 && time_after(jiffies, warning_time + 10 * HZ)) {
>                         pr_emerg("unregister_netdevice: waiting for %s to become free. Usage count = %d\n",
>                                  dev->name, refcnt);
>                         warning_time = jiffies;
> @@ -10461,7 +10461,7 @@ void netdev_run_todo(void)
>                 netdev_wait_allrefs(dev);
>
>                 /* paranoia */
> -               BUG_ON(netdev_refcnt_read(dev));
> +               BUG_ON(netdev_refcnt_read(dev) != 1);
>                 BUG_ON(!list_empty(&dev->ptype_all));
>                 BUG_ON(!list_empty(&dev->ptype_specific));
>                 WARN_ON(rcu_access_pointer(dev->ip_ptr));
> @@ -10682,6 +10682,9 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
>         dev->pcpu_refcnt = alloc_percpu(int);
>         if (!dev->pcpu_refcnt)
>                 goto free_dev;
> +       dev_hold(dev);
> +#else
> +       refcount_set(&dev->dev_refcnt, 1);
>  #endif
>
>         if (dev_addr_init(dev))
> --
> 2.31.0.291.g576ba9dcdaf-goog
>
