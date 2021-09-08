Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC7EB403F28
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 20:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350166AbhIHSh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 14:37:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233322AbhIHSh1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Sep 2021 14:37:27 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0AF9C061757
        for <netdev@vger.kernel.org>; Wed,  8 Sep 2021 11:36:18 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id z18so6169090ybg.8
        for <netdev@vger.kernel.org>; Wed, 08 Sep 2021 11:36:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HjX7K+TpcsYd5c/+i/WbHHjSxL38J99SoKGPyzKH+qw=;
        b=CYBWB5q7jmOjcODURqsEnS5W5yx2Qi6I07YkUlnIctAeoRJ8biEygroEnwpp0PDJ6U
         ze0b1h8LMgTHCC0GhPo7kEJwcMqGeyNuVfTlSGTHT52D+jPtlCpMun2plXeYb79OrxCu
         vnvXypySx/umpFMQc2pjnisaNxF24BXtfkIqcc2MqlfKaxgOiSX/lILCmeEmDs2NMdkk
         ZGKNbTQLa6RW9jmCYjVh3M0JvoIa3AOBQHSblCxS3t72mLmAIunEooTILzdLP2D0S/3B
         TDaUmYA1VfWvhRWgGNIrmsOd0+2kfykDZwRVTmv8AH9aPF4adoNPkTtfvKkM1XzxemQx
         4inA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HjX7K+TpcsYd5c/+i/WbHHjSxL38J99SoKGPyzKH+qw=;
        b=fe6+Q/Bz+mQeU/q3ewhIIPgVWYF3utKCHu7TJg62BkfSOxGbI1UfBnHCIN4FEHcmqX
         REJfZ4+PcibJr8+ep7oJFJtqiH7l8WlLfIRqDBpKj9ADph4sq2+1Ly/01RmJDJIYHyd7
         kGy0jqpw69y66KD8f2ALG5V1dJPzrVOw4cuF2zSvqy2gUOoeVksEErU4wWmDzwN6L0eg
         2yy4a5DvTm9b2YuYG5znqi5hFUjItj72ofD1TdZRHwdhD7tTE5FL5W0EMmwoq1a05zb2
         A3ckxmj8i9W3SgQx+gRdHDIH6Kv3DwfjLygmPvwvlZEMRfYJsGtxXLWrcOzxe/TjWr8+
         tRFg==
X-Gm-Message-State: AOAM5314GloUwLNFL5aBuYxlh6X7VGuIqtvtDo0Htuh24X4MTJetCDty
        QLxFbGLGY/ZAJzGDLiP1aZWl9rcj7qW4gi3RES8QWw==
X-Google-Smtp-Source: ABdhPJzBtuBmf8CUZA8q8DjeeQMm7Fxlgthk077R1iNzqYe+bpT075CwGt89gtqpajwh7YnIq5OiO03iBkciQ03ShwY=
X-Received: by 2002:a25:5606:: with SMTP id k6mr6705534ybb.476.1631126178008;
 Wed, 08 Sep 2021 11:36:18 -0700 (PDT)
MIME-Version: 1.0
References: <YSf/Mps9E77/6kZX@lunn.ch> <CAGETcx_h6moWbS7m4hPm6Ub3T0tWayUQkppjevkYyiA=8AmACw@mail.gmail.com>
 <YSg+dRPSX9/ph6tb@lunn.ch> <CAGETcx_r8LSxV5=GQ-1qPjh7qGbCqTsSoSkQfxAKL5q+znRoWg@mail.gmail.com>
 <YSjsQmx8l4MXNvP+@lunn.ch> <CAGETcx_vMNZbT-5vCAvvpQNMMHy-19oR-mSfrg6=eSO49vLScQ@mail.gmail.com>
 <YSlG4XRGrq5D1/WU@lunn.ch> <CAGETcx-ZvENq8tFZ9wb_BCPZabpZcqPrguY5rsg4fSNdOAB+Kw@mail.gmail.com>
 <YSpr/BOZj2PKoC8B@lunn.ch> <CAGETcx_mjY10WzaOvb=vuojbodK7pvY1srvKmimu4h6xWkeQuQ@mail.gmail.com>
 <YS4rw7NQcpRmkO/K@lunn.ch>
In-Reply-To: <YS4rw7NQcpRmkO/K@lunn.ch>
From:   Saravana Kannan <saravanak@google.com>
Date:   Wed, 8 Sep 2021 11:35:41 -0700
Message-ID: <CAGETcx8haSe5Hx0ywfTS+htST=FoH5=+u=v0KMPvtMeeJ_BB3w@mail.gmail.com>
Subject: Re: [PATCH v1 1/2] driver core: fw_devlink: Add support for FWNODE_FLAG_BROKEN_PARENT
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        Alvin Sipraga <ALSI@bang-olufsen.dk>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 31, 2021 at 6:16 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > > I must admit, my main problem at the moment is -rc1 in two weeks
> > > time. It seems like a number of board with Ethernet switches will be
> > > broken, that worked before. phy-handle is not limited to switch
> > > drivers, it is also used for Ethernet drivers. So it could be, a
> > > number of Ethernet drivers are also going to be broken in -rc1?
> >
> > Again, in those cases, based on your FEC example, fw_devlink=on
> > actually improves things.
>
> Debatable. I did some testing. As expected some boards with Ethernet
> switches are now broken. Without fw_devlink=on, some boards are not
> optimal, but they actually work. With it, they are broken.
>
> I did a bisect, and they have been broken since:
>
> ea718c699055c8566eb64432388a04974c43b2ea is the first bad commit
> commit ea718c699055c8566eb64432388a04974c43b2ea
> Author: Saravana Kannan <saravanak@google.com>
> Date:   Tue Mar 2 13:11:32 2021 -0800
>
>     Revert "Revert "driver core: Set fw_devlink=on by default""
>
>     This reverts commit 3e4c982f1ce75faf5314477b8da296d2d00919df.
>
>     Since all reported issues due to fw_devlink=on should be addressed by
>     this series, revert the revert. fw_devlink=on Take II.
>
>     Signed-off-by: Saravana Kannan <saravanak@google.com>
>     Link: https://lore.kernel.org/r/20210302211133.2244281-4-saravanak@google.com
>     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
>  drivers/base/core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> So however it is fixed, it needs to go into stable, not just -rc1.
>
> > Again, it's not a widespread problem as I explained before.
> > fw_devlink=on has been the default for 2 kernel versions now. With no
> > unfixed reported issues.
>
> Given that some Ethernet switches have been broken all that time, i
> wonder what else has been broken? Normally, the kernel which is
> release in December becomes the next LTS. It then gets picked up by
> the distros and more wide spread tested. So it could be, you get a
> flood of reports in January and February about things which are
> broken. This is why i don't think you should be relying on bug
> reports, you should be taking a more proactive stance and trying to
> analyse the DTB blobs.
>
> I will spend some time trying out your proposed fix. See if they are a
> quick fix for stable.

Hi Andrew,

Did you have a chance to try it out? I can fix up the commit text and
send out vN+1 of the patch if it works for you.

-Saravana
