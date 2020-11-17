Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 318002B6F52
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 20:52:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730564AbgKQTuf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 14:50:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728309AbgKQTue (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 14:50:34 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E4F0C0613CF;
        Tue, 17 Nov 2020 11:50:34 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id v12so17967306pfm.13;
        Tue, 17 Nov 2020 11:50:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LDAEmhNdku9VAWF7fGVJyr3eF+5Nl9MfyP1c5wCk+Qg=;
        b=Lm0ry1bUCaP1i76eXxbXB695bO5Z9mRG8713U6+3u15LHetOu1oB3JAwSaD9bZtvcC
         /wyLo0KKvWQTKGowO5utZS58GfnQC08x5pAJcm/ehyy5v3dciOXl6wptSQuqLxxzUmb3
         8Tx/wikGTWiMWXarqZWrxvgIKWKM25YNwcQ370iQQEwRBe8r2EHpWoUKAo6lqYQM4XDB
         hZPpPymDK7V3Uy9ON8H/9oODLOFcf98mfcG0bFSq4RKzXwiX35gQuGJH7/wEZCqDNtJd
         Qj6QNC22AbtezIceA5870sZ3qKZlgw5FNFZ0LUM5GlRMb3QDQeRzpc4tboYr9s10VifI
         Gvsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LDAEmhNdku9VAWF7fGVJyr3eF+5Nl9MfyP1c5wCk+Qg=;
        b=OHw+OFZpAd2Vki/n/PWToApnn+bC+dwmcOPTmzFuibsaLffdxKoJ8XwmuuFspJ0Up+
         WC/ZN64KW0uFnSEkufVh5bMaROI44CTaW3ZsFVAg0fXez71CW3QHYCg2xMyReoeXRZ0K
         lqYyiIDhNtDQLVp6rlCQ19dKF2OlH8//naVdFwAz+ZcXUkEliBuFzVIEtoSFHT7HqlbH
         JKFNuaqzcwcnzfwpvipFWiuZDCmoWw3bHJseKDAt8A3D+WvdQyyPqp4aH2YsInMFM7qM
         bOCINaeZfpvWUDcODYl221ood3Ljl3frApGpIDUwZ4CvFgfGIUJEa2Yv4J3hn+OCPI3Q
         w8KA==
X-Gm-Message-State: AOAM532dhN3B75dGVXNPqMJSs7k5/HZ73mmY/2qpnf9sMch6x14rREot
        ITRVRcvZrR8AHnYahRdrmB1nevwSWDFmm7+s7pwFUOZEDPM=
X-Google-Smtp-Source: ABdhPJyrt2/yEdjoVLA8SLqCI1GEtqRtkALsHHeiQczj/+I6NgFaSf4UAPq4bnKwzIwZcwb4Wv1D8MJJCMcSeWnmZ9I=
X-Received: by 2002:a63:1d0b:: with SMTP id d11mr2265333pgd.368.1605642634151;
 Tue, 17 Nov 2020 11:50:34 -0800 (PST)
MIME-Version: 1.0
References: <20201116135522.21791-1-ms@dev.tdt.de> <20201116135522.21791-4-ms@dev.tdt.de>
In-Reply-To: <20201116135522.21791-4-ms@dev.tdt.de>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Tue, 17 Nov 2020 11:50:23 -0800
Message-ID: <CAJht_EN0fhD08+wH5kSBWvciHU7uM7iKJu_UcEXwZBKssuqNVw@mail.gmail.com>
Subject: Re: [PATCH net-next v2 3/6] net/x25: replace x25_kill_by_device with x25_kill_by_neigh
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     Andrew Hendry <andrew.hendry@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 16, 2020 at 6:00 AM Martin Schiller <ms@dev.tdt.de> wrote:
>
> Remove unnecessary function x25_kill_by_device.

> -/*
> - *     Kill all bound sockets on a dropped device.
> - */
> -static void x25_kill_by_device(struct net_device *dev)
> -{
> -       struct sock *s;
> -
> -       write_lock_bh(&x25_list_lock);
> -
> -       sk_for_each(s, &x25_list)
> -               if (x25_sk(s)->neighbour && x25_sk(s)->neighbour->dev == dev)
> -                       x25_disconnect(s, ENETUNREACH, 0, 0);
> -
> -       write_unlock_bh(&x25_list_lock);
> -}
> -
>  /*
>   *     Handle device status changes.
>   */
> @@ -273,7 +257,11 @@ static int x25_device_event(struct notifier_block *this, unsigned long event,
>                 case NETDEV_DOWN:
>                         pr_debug("X.25: got event NETDEV_DOWN for device: %s\n",
>                                  dev->name);
> -                       x25_kill_by_device(dev);
> +                       nb = x25_get_neigh(dev);
> +                       if (nb) {
> +                               x25_kill_by_neigh(nb);
> +                               x25_neigh_put(nb);
> +                       }
>                         x25_route_device_down(dev);
>                         x25_link_device_down(dev);
>                         break;

This patch might not be entirely necessary. x25_kill_by_neigh and
x25_kill_by_device are just two helper functions. One function takes
nb as the argument and the other one takes dev as the argument. But
they do almost the same things. It doesn't harm to keep both. In C++
we often have different functions with the same name doing almost the
same things.

The original code also seems to be a little more efficient than the new code.
