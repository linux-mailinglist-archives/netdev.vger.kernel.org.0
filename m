Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D60B42BBA60
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 00:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728430AbgKTXun (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 18:50:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727364AbgKTXun (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 18:50:43 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 406F8C0613CF;
        Fri, 20 Nov 2020 15:50:43 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id t37so8585795pga.7;
        Fri, 20 Nov 2020 15:50:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x+VRrY9R8Fek/ma6fK+h1GJxZ+01lLXYDncUiaHc+18=;
        b=uX7vzR+xT2SS3BLynmzaH8E5JPpSnpNOZwUopYees7e5PjrCTSYxuhGmlluTYPcm8l
         kL9ENaX/79ZoJKfrA/zRZXTxDQ6fCzWn6rG01DvrxL6kZSrddwvm4r35IjeSzp7w94/0
         4LQDU75uXPBsWp/Pvqj/xw2HKkdoEMdOa1eRlby7tUOd2f6UPxvGX/DzGKU2uEUwRqgx
         RiBflxOwCkb/pL22z9nyeBixGBlS0obVLtejJlu3fNzvAjhrSZkGAWcqOg+qDvq21194
         jYM0qmcZnVcZyf35QN/0wbmMHUhEpz8MonuZY+1SkIsPwOw4e7rCXDXMbkvRVqdcPRQq
         L66w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x+VRrY9R8Fek/ma6fK+h1GJxZ+01lLXYDncUiaHc+18=;
        b=mQMbR+6mpuWx+6oHqd/1RekzwNXzO5XF+NRPQ40A3bvOen254IKcTvPoKNnsm4YSDp
         E77eKvYP+VU8PPGx6FqCUOHx6smTJsqeLRZ0OhDvqEenQxky2C8xYlK0iaSgCigp0IhG
         T//ByB2dTbiWaWcbUNWb0Uf989xGsarxPVZL4tOU3Z5P+KQUKCUnLaKwV6RNwIkj5jng
         /K0z5iUh3g2s/POtNdOGIdHkXWKRrOprfSJZgDckfQ/sX52GQqON7NxcVpRCJEFG9UXX
         u312KZ2LBbHFgvd0wfPWMCentR5KIXRaC1/Lowdc+hzXHoN6RcYfDQeEqCk6VUd25Uv9
         SAlg==
X-Gm-Message-State: AOAM533isTdczEBsP4qxHwk9TJUo12a9cpYPXYUj5c9z/I1KAN0H89Vd
        xhEd1IICPUUXCO4Z9t3Uc3OZzqZH81WJ2vC+WC4=
X-Google-Smtp-Source: ABdhPJyqk5SI0b4KOczElKitjGAYAnP/+majfWho0/qSwvuapRnSbkpr2QhZdam6bYX/zrA3Ra/qmoEHLyvmQIrzK+o=
X-Received: by 2002:a17:90a:ff08:: with SMTP id ce8mr12888020pjb.210.1605916242824;
 Fri, 20 Nov 2020 15:50:42 -0800 (PST)
MIME-Version: 1.0
References: <20201120054036.15199-1-ms@dev.tdt.de> <20201120054036.15199-3-ms@dev.tdt.de>
 <CAJht_EONd3+S12upVPk2K3PWvzMLdE3BkzY_7c5gA493NHcGnA@mail.gmail.com>
In-Reply-To: <CAJht_EONd3+S12upVPk2K3PWvzMLdE3BkzY_7c5gA493NHcGnA@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Fri, 20 Nov 2020 15:50:31 -0800
Message-ID: <CAJht_EP_oqCDs6mMThBZNtz4sgpbyQgMhKkHeqfS_7JmfEzfQg@mail.gmail.com>
Subject: Re: [PATCH net-next v4 2/5] net/lapb: support netdev events
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

On Fri, Nov 20, 2020 at 3:11 PM Xie He <xie.he.0141@gmail.com> wrote:
>
> Should we also handle the NETDEV_UP event here? In previous versions
> of this patch series you seemed to want to establish the L2 connection
> on device-up. But in this patch, you didn't handle NETDEV_UP.
>
> Maybe on device-up, we need to check if the carrier is up, and if it
> is, we do the same thing as we do on carrier-up.

Are the device up/down status and the carrier up/down status
independent of each other? If they are, on device-up or carrier-up, we
only need to try establishing the L2 connection if we see both are up.

On NETDEV_GOING_DOWN, we can also check the carrier status first and
if it is down, we don't need to call lapb_disconnect_request.
