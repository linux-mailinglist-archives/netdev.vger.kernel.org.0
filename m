Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1DDD219026
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 21:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbgGHTEp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 15:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725978AbgGHTEp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 15:04:45 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB4F3C061A0B;
        Wed,  8 Jul 2020 12:04:44 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id b9so1031887plx.6;
        Wed, 08 Jul 2020 12:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tMh+N4AelkPm2oxZYynrDFABsoJu3LSOWaAFcX31Lf8=;
        b=bbuDMatH/BcR0zzFHOI3DZgIsYWFm64I++XTTIGrVi2+xdx+pMM7n6CWrcgGn5kk0i
         9e5MqVzqDEY/IA7Im1fKWhdJiRKtfl7Qq8p5IDvRHdTqK0Z2wt64Ry9T98MygfZUlqwp
         Qvzg4nK1jLVyn/mGtdIZOW7XkKepbBTEo4dIP+8SdeLhOXJ42t3sgyvKMGgcHOZhayvd
         TtC6m0u4TIQKMnkDUVOaL52hHtEZJZS1kolgpG5EmwQ1uRr136gJG6UcRsArjIbsZ7qa
         7vwxbXzTd84lNdeCAo6LroBh/EkJBk7GEO4HDF3NcDv1EF6g5Wm0JiudEmXiXL2s+98+
         fJiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tMh+N4AelkPm2oxZYynrDFABsoJu3LSOWaAFcX31Lf8=;
        b=GGzFFUC7gMM/0YUzwVhXPZ8ScdoQ4nY0beABdLpHyCVOJQOgtxy9m4ilhOlcpkp+u4
         2z3XgpRmgiupFICyHLkobi+l0YSUEe9MH8zt2W+rwt+NNzbwrLInG+phviJnbljTgY9s
         hVYlccbttMo+qbzHnjg1JG1MUXxqbTc1nkuesxsvMDG/O/YzqRdKlG3c8uMmS3MBDRpg
         9E+xHwYVG33TQ+2SjC+oojbWYLhj3c6TByN0S6lBG7IsknfD9PDbKWGXECgfglwWz3/J
         wxXJwC7DcBn3W83yyOUpszfCxzXPC5rDv+FazVooxrkGPgy9/HLw7GMpwM2GHxRLjdfp
         O7Pg==
X-Gm-Message-State: AOAM530Lf7HwdSJqxQtZusbU6nKnnMo7XCvZG+aYSZ5xzef6Y9zfHWNg
        p968+5NKCzmW0hSr47mlX5+zLEEgnjdw2igRH4o=
X-Google-Smtp-Source: ABdhPJyy3TSipk2YYG/tuc7Dy5N4FMY3OHCMqS4pCZQoXQb0WR+rAjCtGOKlh71Q3iIpaSxdKRWydloMvpDw21iA1dQ=
X-Received: by 2002:a17:902:fe0b:: with SMTP id g11mr51231040plj.269.1594235084568;
 Wed, 08 Jul 2020 12:04:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200708043754.46554-1-xie.he.0141@gmail.com> <20200708.101321.1049330296069021543.davem@davemloft.net>
In-Reply-To: <20200708.101321.1049330296069021543.davem@davemloft.net>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Wed, 8 Jul 2020 12:04:33 -0700
Message-ID: <CAJht_EOqgWh0dShG258C3uoYdQga+EUae34tvL9HhqpztAv1PQ@mail.gmail.com>
Subject: Re: [PATCH] drivers/net/wan/x25_asy: Fix to make it work
To:     David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Shannon Nelson <snelson@pensando.io>,
        Martin Habets <mhabets@solarflare.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-x25@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Wed, Jul 8, 2020 at 10:13 AM -0700
> Something's not right, because I find it hard to believe this has been
> so fundamentally broken for such a long period of time.
>
> Maybe the drivers all handle things differently, and whilst your change
> might fix some drivers, it will break others.
>
> I'm not applying this until this situation is better understood.

Yes, it was hard for me to believe, too.

At first when I tried this driver, it was silently not able to establish
LAPB connections, I found that it was because it was ignoring
2-byte frames. I changed it to make 2-byte frames pass. Then I
encountered kernel panic. I don't know how to solve it, so I looked
at the way "lapbether" does things and changed this driver according
to the "lapbether" driver. And it worked.

The "lapbether" driver and this driver both use the "lapb" module to
implement the LAPB protocol, so they should implement LAPB-related
code in the same way.

This patch only changes this driver and does not affect other drivers.

I don't know how I can better explain this situation. Please tell me
anything I can do to help. Thanks!
