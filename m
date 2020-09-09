Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 584802638E2
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 00:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729275AbgIIWMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 18:12:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726726AbgIIWMv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 18:12:51 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C7E8C061573
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 15:12:51 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id p13so3865826ils.3
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 15:12:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lhtoqJyCIzQ4QUDzCEQZZOvOi9vwVRyu9S380wXL7eM=;
        b=h7muXLBH4QSm17T5JVJF1Ff0LkG4cc6r6Z7XyLdlsTUrbXllhQOHhGMLvehPJoTBKe
         y1myQxxeHqd5Tvqo+bUrmE4p72rYiop+rDLA/UUhI0wuidcTMeg+SxaJh4yfeiMit8Du
         vdP6z9LYMe7O7l09XXWIRr7dSO/xo7zGDc1MIQ7RF7iOyRJpzSw7OnQGaTvIL+/e0hJC
         asC2xFNy5y4tXTYYdN/ZO5MlDJeC4odq0VoxDiIxxMR3Oa9613Q9ySYEuPN4GxKHoI8Y
         a8ioiYEsMRXVMsFF8QWBj0ZXaJPkgQNW1VfomA6ve6KzI0R/q8/JmqaEWwuJ8WOVqBxJ
         nnIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lhtoqJyCIzQ4QUDzCEQZZOvOi9vwVRyu9S380wXL7eM=;
        b=LNjbq3s56VvY03x3mZ6uTjPUfXesqNVZVr42HfK7pHvccWDPWWVd+iucoUQ8l9raLr
         oOM8Wgi7fk/sIG2wEGIgCyPT+GYAh4gaIhXZBUCGbyQIncBnLnT0BkyVmoTfxpUBmgc7
         WRTgqTRHQIFPt4Jp42IrFgffEzA4KMf61ko1XFq4If55u0l+HfBgIPDbUxfIs9Ebz4QG
         lUY2/t0bGDmJ+4Ff9YcRKvFXFcPnEmsMO/H6+hi4OlXQJnxdTLubXerdamIPUd88+9q1
         5xAK5UEUuu2yxRJr/o/S8Om9frpGnMOZ2ptHZTW0F6NgvHgEhRxxhkKmDxZCOLHG4pjb
         dbRw==
X-Gm-Message-State: AOAM532OyG1vbaeyF3NkEmPBlNcT7+3R9RMcwkD3NnLY1EOpsFaoXwWq
        SXI+8/dx7N6eApuXMpNEsrHqdKm3lP4AcxIIEyAS3g==
X-Google-Smtp-Source: ABdhPJzqIFQSl6YzjZRgX2+puPFNWdusRrTjuFAVRL6zzxNTL8BLknhJ8bk3O5V2izY52QxhX33+yHNPdOCMwzbwvCU=
X-Received: by 2002:a92:8488:: with SMTP id y8mr5420667ilk.29.1599689570215;
 Wed, 09 Sep 2020 15:12:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200908183909.4156744-1-awogbemila@google.com>
 <20200908183909.4156744-9-awogbemila@google.com> <20200908122757.303196fd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200908122757.303196fd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   David Awogbemila <awogbemila@google.com>
Date:   Wed, 9 Sep 2020 15:12:39 -0700
Message-ID: <CAL9ddJdJtN5GG3-v=6frKfE43AvP5-QynX8E+YbzAdPn13V=Lg@mail.gmail.com>
Subject: Re: [PATCH net-next v3 8/9] gve: Use link status register to report
 link status
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Patricio Noyola <patricion@google.com>,
        Yangchun Fu <yangchun@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 8, 2020 at 12:28 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue,  8 Sep 2020 11:39:08 -0700 David Awogbemila wrote:
> > +             dev_info(&priv->pdev->dev, "Device link is up.\n");
> > +             netif_carrier_on(priv->dev);
> > +     } else {
> > +             dev_info(&priv->pdev->dev, "Device link is down.\n");
> > +             netif_carrier_off(priv->dev);
>
> These should be netdev_info()
Thanks. I'll adjust these.
