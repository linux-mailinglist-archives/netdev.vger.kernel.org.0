Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F345345C27
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 11:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbhCWKpl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 06:45:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbhCWKpH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 06:45:07 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F2ADC061574
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 03:45:06 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id m12so25899355lfq.10
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 03:45:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=L4M5r2hwtEWv5Cy7s/XFmYZvx3wS+vbZ9obCpM51snM=;
        b=MiKeNtJbpg644nXC+N5G5YiJHEg9DEpe+waBAjAQYaDWD/A+OXaTLspLWGIHCsFvVd
         xsMLnMqzwvwS0tgcDSJGEW4z7z9p0Ek8Wwvn8Yct76228I6Fppo1ALuXqT31fc19HMrE
         8MW3TJMLzNqaEWvEObd5Txb+lCCFzZrYxMRaCKY1GtkOQwQEq20I81fgQRKoetZE3jWM
         Ojeey7bMVOJ0kHR+Hxleez1GN1ig+6hrxhiwODoZ2CFvEAUTwiBFZqrBoAkhVy1o93qs
         Qryrt3UFf8nkdv2DXU98koxlfqgXAQvJkLJqcPq4S3srZf3VevAbs+bM3+0TuG6hRSIM
         IHYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=L4M5r2hwtEWv5Cy7s/XFmYZvx3wS+vbZ9obCpM51snM=;
        b=tWIK36SCMIpeb2yXn7og+4jpA41NaFiztiC4YZIxeHJE2WwdUIsfebauoLdvG7LTXU
         SdEbPyf6QxYgSUGnrHOjXQF9ISn9O/k2VHX2te3jYvNZGyIv4RGIEBvZB5/JjN+KGbTd
         ahRwMwj2zv9eCDgK+7sXKU7HvFArhQm3mRz7zqfiSUeo+4MKrOwVrISdMjpXXzJssEcl
         8AONXPm1ols5gZqIylM+I3cBsoUjb+SnaJXE7dgY6pvJUHjeE1UT5M6BejQiS++0tdcb
         hv1+AoV5hsytzlqFrakaJ9hG6mHmG/R2WzfmQeAWU0pVcud4+UwM+8iYZIJPbqXtri0V
         sQeg==
X-Gm-Message-State: AOAM532fBDy6qdZNzlhd/gvZJUlAAUdLNIWEun06kilzc4DgRwMtEe9I
        a+y/06FnN6QebsSiOneIroabmzvmjhnHz3KJoEY=
X-Google-Smtp-Source: ABdhPJy3EfjPV4K62Y5OcT1Va2CTQ8PKzNqy38enKzncW+ZZjjSIlpsYmTkVoldOuRYc0uv3kWuCjA==
X-Received: by 2002:a05:6512:11cc:: with SMTP id h12mr2290099lfr.567.1616496304722;
        Tue, 23 Mar 2021 03:45:04 -0700 (PDT)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id g24sm1536368lfv.257.2021.03.23.03.45.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 03:45:04 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 0/8] net: dsa: mv88e6xxx: Offload bridge port flags
In-Reply-To: <20210318192540.895062-1-tobias@waldekranz.com>
References: <20210318192540.895062-1-tobias@waldekranz.com>
Date:   Tue, 23 Mar 2021 11:45:03 +0100
Message-ID: <87im5im9n4.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 18, 2021 at 20:25, Tobias Waldekranz <tobias@waldekranz.com> wrote:
> Add support for offloading learning and broadcast flooding flags. With
> this in place, mv88e6xx supports offloading of all bridge port flags
> that are currently supported by the bridge.
>
> Broadcast flooding is somewhat awkward to control as there is no
> per-port bit for this like there is for unknown unicast and unknown
> multicast. Instead we have to update the ATU entry for the broadcast
> address for all currently used FIDs.
>
> v2 -> v3:
>   - Only return a netdev from dsa_port_to_bridge_port if the port is
>     currently bridged (Vladimir & Florian)
>
> v1 -> v2:
>   - Ensure that mv88e6xxx_vtu_get handles VID 0 (Vladimir)
>   - Fixed off-by-one in mv88e6xxx_port_set_assoc_vector (Vladimir)
>   - Fast age all entries on port when disabling learning (Vladimir)
>   - Correctly detect bridge flags on LAG ports (Vladimir)
>
> Tobias Waldekranz (8):
>   net: dsa: Add helper to resolve bridge port from DSA port
>   net: dsa: mv88e6xxx: Avoid useless attempts to fast-age LAGs
>   net: dsa: mv88e6xxx: Provide generic VTU iterator
>   net: dsa: mv88e6xxx: Remove some bureaucracy around querying the VTU
>   net: dsa: mv88e6xxx: Use standard helper for broadcast address
>   net: dsa: mv88e6xxx: Flood all traffic classes on standalone ports
>   net: dsa: mv88e6xxx: Offload bridge learning flag
>   net: dsa: mv88e6xxx: Offload bridge broadcast flooding flag
>
>  drivers/net/dsa/mv88e6xxx/chip.c | 270 ++++++++++++++++++++++---------
>  drivers/net/dsa/mv88e6xxx/port.c |  21 +++
>  drivers/net/dsa/mv88e6xxx/port.h |   2 +
>  include/net/dsa.h                |  14 ++
>  net/dsa/dsa_priv.h               |  14 +-
>  5 files changed, 232 insertions(+), 89 deletions(-)
>
> -- 
> 2.25.1

Jakub/Dave, is anything blocking this series from going in? I am unable
to find the series on patchwork, is that why?
