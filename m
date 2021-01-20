Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04EEA2FD533
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 17:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391294AbhATQOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 11:14:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391338AbhATQNo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 11:13:44 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0637C061575
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 08:13:03 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id p72so23134025iod.12
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 08:13:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pWOxMTP51ISi4PRYG2+h1trMlNivuZ+0gVNmY3W4pJM=;
        b=fn5jqCvuxkxNb0MNHKrZzi1mBb4R2EF2Awll07gVgMHB70kg+vpErkZicAMRDLXZfa
         IYlAdZuEsMYBYPV27AjsaN76VvAnn3+OAye5+2v4AmP831Fum8tyzaDUSm2QAlcd6tv6
         zNbMp9zWaLJsPqNT+Q8gEUMK75zkdwkDG4hQM5HFsJYSnzOeEjlp/7Wg/VE0tCk8hBVS
         Iami4MyHAYOW+rYpwB5eFKdPWKzPPlHxtcJrThyf04IZsER7Cl5TOv/DSplMWBjZekhG
         ICtGk7LNjmKNCGpx0VBlwjtMVSjCFJAmTYG8yPDg0wHzQJSqM/WSxYvNMTG1k3s5sz1W
         Ix/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pWOxMTP51ISi4PRYG2+h1trMlNivuZ+0gVNmY3W4pJM=;
        b=fhL4Lo5M87eiC6mYZHPvw2LHEjwNZpcbphEVE60iM+nK4cTsJfGeVKs7ITKr6OAoGz
         pwfRbRlInVYkUem9osnXcgE+dklxFMf/5qycNz4bage15btJ/h1kcXSrcaNgX4/AWXbC
         uBqlWdqjYeEaCv8AGEI2dstljW5IAqGh6gwcXm0thYldVBmwcd9Fa78IdmOIPUfUA4Mt
         1Wya0gRiwOTtX3VTZxwbZVigqHJf48udtAyqOSEfUSH40KtsbplAeAaqAjVo6VLlWUql
         O5ZMhshW7nsngwF2Nt15n0UHLbcpMTz05S3+U/NV9ESRAUdpM7/0nk9Q+Hw7ikGrW4oa
         OYLw==
X-Gm-Message-State: AOAM532M2UE88hluhjx4IQQr4LwQjQs6pR0JjFC2GU90D7F3pt10e4q4
        yIqH2FkMrlVbag7+JABKwsH1blUGBhlRAtCyfQo=
X-Google-Smtp-Source: ABdhPJyE/wGX4Xup02vHUcTeAIwo6mrCB78FtnHwf53qUb1GmHo6wBIpD3nP6MYjlLJLbeyxLKWAh8J+jZjW0yarYcQ=
X-Received: by 2002:a6b:d007:: with SMTP id x7mr7427773ioa.88.1611159183095;
 Wed, 20 Jan 2021 08:13:03 -0800 (PST)
MIME-Version: 1.0
References: <20210120033455.4034611-1-weiwan@google.com> <20210120033455.4034611-4-weiwan@google.com>
In-Reply-To: <20210120033455.4034611-4-weiwan@google.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 20 Jan 2021 08:12:51 -0800
Message-ID: <CAKgT0UdKXjPM7sf2qKntEZQWgmDq0yfTOtcfevkZFY11kVK4Qg@mail.gmail.com>
Subject: Re: [PATCH net-next v7 3/3] net: add sysfs attribute to control napi
 threaded mode
To:     Wei Wang <weiwan@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 19, 2021 at 7:35 PM Wei Wang <weiwan@google.com> wrote:
>
> This patch adds a new sysfs attribute to the network device class.
> Said attribute provides a per-device control to enable/disable the
> threaded mode for all the napi instances of the given network device.
> User sets it to 1 or 0 to enable or disable threaded mode per device.
> However, when user reads from this sysfs entry, it could return:
>   1: means all napi instances belonging to this device have threaded
> mode enabled.
>   0: means all napi instances belonging to this device have threaded
> mode disabled.
>   -1: means the system fails to enable threaded mode for certain napi
> instances when user requests to enable threaded mode. This happens
> when the kthread fails to be created for certain napi instances.
>
> Co-developed-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> Co-developed-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
> Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
> Co-developed-by: Felix Fietkau <nbd@nbd.name>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> Signed-off-by: Wei Wang <weiwan@google.com>
> ---
>  include/linux/netdevice.h |  2 ++
>  net/core/dev.c            | 28 ++++++++++++++++
>  net/core/net-sysfs.c      | 68 +++++++++++++++++++++++++++++++++++++++
>  3 files changed, 98 insertions(+)
>
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 8cb8d43ea5fa..26c3e8cf4c01 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -497,6 +497,8 @@ static inline bool napi_complete(struct napi_struct *n)
>         return napi_complete_done(n, 0);
>  }
>
> +int dev_set_threaded(struct net_device *dev, bool threaded);
> +
>  /**
>   *     napi_disable - prevent NAPI from scheduling
>   *     @n: NAPI context
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 7ffa91475856..e71c2fd91595 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -6767,6 +6767,34 @@ static int napi_set_threaded(struct napi_struct *n, bool threaded)
>         return 0;
>  }
>
> +static void dev_disable_threaded_all(struct net_device *dev)
> +{
> +       struct napi_struct *napi;
> +
> +       list_for_each_entry(napi, &dev->napi_list, dev_list)
> +               napi_set_threaded(napi, false);
> +}
> +
> +int dev_set_threaded(struct net_device *dev, bool threaded)
> +{
> +       struct napi_struct *napi;
> +       int ret;
> +
> +       dev->threaded = threaded;
> +       list_for_each_entry(napi, &dev->napi_list, dev_list) {
> +               ret = napi_set_threaded(napi, threaded);
> +               if (ret) {
> +                       /* Error occurred on one of the napi,
> +                        * reset threaded mode on all napi.
> +                        */
> +                       dev_disable_threaded_all(dev);
> +                       break;
> +               }
> +       }
> +
> +       return ret;
> +}
> +

So I have a question about this function. Is there any reason why
napi_set_threaded couldn't be broken into two pieces and handled in
two passes with the first allocating the kthread and the second
setting the threaded bit assuming the allocations all succeeded? The
setting or clearing of the bit shouldn't need any return value since
it is void and the allocation of the kthread is the piece that can
fail. So it seems like it would make sense to see if you can allocate
all of the kthreads first before you go through and attempt to enable
threaded NAPI.

Then you should only need to make a change to netif_napi_add that will
allocate the kthread if adding a new instance on a device that is
running in threaded mode and if a thread allocation fails you could
clear dev->threaded so that when napi_enable is called we don't bother
enabling any threaded setups since some of the threads are
non-functional.

Doing so would guarantee all-or-nothing behavior and you could then
just use the dev->threaded to signal if the device is running threaded
or not as you could just clear it if the kthread allocation fails.
