Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B98FF40CD1A
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 21:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231562AbhIOTUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 15:20:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231433AbhIOTUh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 15:20:37 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD682C061764
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 12:19:17 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id m3so6699945lfu.2
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 12:19:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hRAe5/tE1Mx+glbEumA/10LHbf2sLTrpOcfg2d46p4U=;
        b=VWatl0Tg6Rs2+8cyQ1nNI7llz+Jwjnz45GyA7Ialu8h0m7yH1LKoqAuI6k/Ywlygil
         KDQQX525bUWsnQP59sCymg2Xi7UR5AijXzfqK2/Z2O+QbzWUet5is4fYAxM3ieQOdqUi
         Q6n8XepF4xgcAuR6YdqHkkzo9csOkkBGuEk5Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hRAe5/tE1Mx+glbEumA/10LHbf2sLTrpOcfg2d46p4U=;
        b=NsIXeJzDTr5AhrNtFCF3uKtWur9nG464iqBXrLm+1lSw0G9WGSyktR+G0tqnAeumlX
         wVum+J3eAjmOk5LZH/KFsn0PEHoVi8L0OpRjxWU6s/2w/x80utHIuG3r6N3/bLoY9ll1
         muBawS6ncbrYDDJ4bhT1JwvdrEJFvpoHNkIICg8Z8LBusREstJI+eKCcDk+HheFKTOuC
         x/V5q8eweGljmOV+mTKiDnbv+8ixULUFsVUMpHD4iBHkA8BIqtyBdFssivv07DyRuxQr
         T8NkNVracEVB7Q3V0r/sT+bwJYGvPgR6N/fM8inrj02aoA0nqLjQSVTvarXDg/1nScPI
         V7tg==
X-Gm-Message-State: AOAM532EhF33IA75bii8eTZI/14bOjrXGDiPf55068U/HvH9E0beHwGF
        KT+330wHLTmCuL35FMBEBQteXJ4Ks1b12idmecA=
X-Google-Smtp-Source: ABdhPJw/X7Yg03G74H6Z5CgFsIzGUSpzRoxxHdRBzScQT/+/7uPW2wI2zjVgtGZgtnFwdrytjmEc3Q==
X-Received: by 2002:a2e:9852:: with SMTP id e18mr1427455ljj.173.1631733555881;
        Wed, 15 Sep 2021 12:19:15 -0700 (PDT)
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com. [209.85.167.47])
        by smtp.gmail.com with ESMTPSA id y9sm58945lfh.52.2021.09.15.12.19.14
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Sep 2021 12:19:14 -0700 (PDT)
Received: by mail-lf1-f47.google.com with SMTP id k4so8524710lfj.7
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 12:19:14 -0700 (PDT)
X-Received: by 2002:a05:6512:94e:: with SMTP id u14mr1121103lft.173.1631733554128;
 Wed, 15 Sep 2021 12:19:14 -0700 (PDT)
MIME-Version: 1.0
References: <20210915035227.630204-1-linux@roeck-us.net>
In-Reply-To: <20210915035227.630204-1-linux@roeck-us.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 15 Sep 2021 12:18:58 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjXr+NnNPTorhaW81eAbdF90foVo-5pQqRmXZi-ZGaX6Q@mail.gmail.com>
Message-ID: <CAHk-=wjXr+NnNPTorhaW81eAbdF90foVo-5pQqRmXZi-ZGaX6Q@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] Introduce and use absolute_pointer macro
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
        Helge Deller <deller@gmx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        alpha <linux-alpha@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-parisc@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Sparse Mailing-list <linux-sparse@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 14, 2021 at 8:52 PM Guenter Roeck <linux@roeck-us.net> wrote:
>
> This patch series introduces absolute_pointer() to fix the problem.
> absolute_pointer() disassociates a pointer from its originating symbol
> type and context, and thus prevents gcc from making assumptions about
> pointers passed to memory operations.

Ok, I've applied this to my tree.

I note that the physical BOOT_PCB addresses in the alpha setup.h file
might be useful for things like MILO in user space, but since I
couldn't even find MILO sources any more, I couldn't really check.

I suspect alpha is basically on life support and presumably nobody
would ever compile a bootloader anyway, so it's unlikely to matter.

If somebody does find any issues, we'll know better and we can ask
where the user space sources are that might use that alpha setup.h
file.

                Linus
