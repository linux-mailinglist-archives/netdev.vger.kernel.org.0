Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4AA2E89FE
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 03:13:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726517AbhACCNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jan 2021 21:13:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725786AbhACCNO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jan 2021 21:13:14 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63DC6C061573;
        Sat,  2 Jan 2021 18:12:33 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id w1so32266427ejf.11;
        Sat, 02 Jan 2021 18:12:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mdMzQazYuuqK+Mo77p87BaWfToOrxP/Uh7GEHhqBbnA=;
        b=G6d3qNATHB3eF3CsfNBka8AtiMvfx5Q4/GBB9HFwCHs5K1Od6c4qeGzcWmyzti1HsY
         E7o2hU/rrz3tOdKYMQ/i22lgwdNkXB09zAigcZpa/xnSiJdznqzD4yxFLTpiHaxcsdL4
         UeIUg5i6OAvyPYLmDFanaAy4sqKEFSixyBi+bWkeb4vAmn7QJVS1RcUTYewWlonvhS2b
         xcfb6jqDM/9EK0iVpUZV7T6qZ1SS1zWztBrCYNL43/CFymXF09Bmj9ZGNAejCG7dfIG2
         4pYqqq6gPtresYOTn/LCs7YGxH8YQTnamwZ6WJndpADxx7nazjPsGB5J52G1oLBLXRoS
         No7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mdMzQazYuuqK+Mo77p87BaWfToOrxP/Uh7GEHhqBbnA=;
        b=PwwYqkVHJ163UElOhkESvCL6nvH91393aZyBEbugNMaVKxbWcFXTIahuJGg5XYR9oH
         Xp6HTLjU0Qb11Jou+cK1sEjExfT48wTbodkQFSBB8t6MQ+pqEqKdAtXaZ0K72KqBwbeW
         wj3jBSsuMXeVnJFAmyq2XUVcWmcN3vNc7UKpuOBwdVyVCVLNjOfWgHHGhJwxdfF/g4NO
         tBS/ykpEX81uM9X6NVn+HbyIbdNWDrirnRJozjI8sqp/AK+Mo9FqqdIEaiyrHhGRcJBF
         rWQvV4jxb7BU+ifu6GHhVjGY569z9Ec1TbXgxpmUpYKWOQuqVWHoRNtMBaF0GdZOV78/
         EmPA==
X-Gm-Message-State: AOAM533h5m4hekfqpvSxnk45KY9LjOdG9Fj179RPmPtWOi9gSvW/rKeB
        GKoxkoqvMyCgkghowWlO0U9DIiiN912+PE+PlVJmLfI5
X-Google-Smtp-Source: ABdhPJy6U5s2WOp2nU/9XhogGb5WrtJh1O2h9AcrMsNWHnkQQIhwzuCBlBvLRacpd0Z9MX/Zg6IFLwpY++pelA1K3ck=
X-Received: by 2002:a17:906:4050:: with SMTP id y16mr60198536ejj.537.1609639952205;
 Sat, 02 Jan 2021 18:12:32 -0800 (PST)
MIME-Version: 1.0
References: <20210103012544.3259029-1-martin.blumenstingl@googlemail.com>
 <20210103012544.3259029-2-martin.blumenstingl@googlemail.com> <X/EnSv8gyprpOWRr@lunn.ch>
In-Reply-To: <X/EnSv8gyprpOWRr@lunn.ch>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Sun, 3 Jan 2021 03:12:21 +0100
Message-ID: <CAFBinCD7cOPZf8NpkhpRG2PiuMcjtqwxu7vQQoXULpCBbTCAoA@mail.gmail.com>
Subject: Re: [PATCH 1/2] net: dsa: lantiq_gswip: Enable GSWIP_MII_CFG_EN also
 for internal PHYs
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Hauke Mehrtens <hauke@hauke-m.de>, netdev@vger.kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Sun, Jan 3, 2021 at 3:09 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Sun, Jan 03, 2021 at 02:25:43AM +0100, Martin Blumenstingl wrote:
> > Enable GSWIP_MII_CFG_EN also for internal PHYs to make traffic flow.
> > Without this the PHY link is detected properly and ethtool statistics
> > for TX are increasing but there's no RX traffic coming in.
> >
> > Fixes: 14fceff4771e51 ("net: dsa: Add Lantiq / Intel DSA driver for vrx200")
> > Cc: stable@vger.kernel.org
>
> Hi Martin
>
> No need to Cc: stable. David or Jakub will handle the backport to
> stable.  You should however set the subject to [PATCH net 1/2] and
> base the patches on the net tree, not net-next.
do you recommend re-sending these patches and changing the subject?
the lantiq_gswip.c driver is identical in -net and -net-next and so
the patch will apply fine in both cases


Best regards,
Martin
