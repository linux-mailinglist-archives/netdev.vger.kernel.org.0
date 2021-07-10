Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADF0C3C3355
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 08:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbhGJHAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Jul 2021 03:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbhGJHAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Jul 2021 03:00:15 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13DE7C0613DD;
        Fri,  9 Jul 2021 23:57:31 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id f13so27987331lfh.6;
        Fri, 09 Jul 2021 23:57:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NBcTamtXp24UNp39VrBbszNi7MPHaYOLPiju2AfDcAg=;
        b=h/E9KNZ7oxCLC3Ux0hQ6M2WvPuI8ijIO7ehBy+aII8eIMiiGa0dQoujumej4oPh6kd
         AoRfcKK6AHloDqM6z8Wm5SEjO9PeXV5PeEyrOJlopebWGM3EokZLt/dOW/50OZmwKh3O
         1RGQ1fvdlBr7O36Yfo7lsbnlf9xizWHtFv7M+3NlpNYkDLT5N2Okb4k9ldUxHkBGgoOs
         SbgntQiIwc0sONHiEY3HRO3ChCzGCvRf4YY7qgVUQ5TwqoqGfrikLOYKsW34V0nnrCk4
         jH/LX78Z9G+IVkanFTC411qRRK3VqFBDoBas7/yRxeJWjS2M2vVJUr7XoD00HISImw0l
         OWMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NBcTamtXp24UNp39VrBbszNi7MPHaYOLPiju2AfDcAg=;
        b=jgYxiLIJSl8puiFqz0hDZxaJ31kSO8lSoF5inK9K0IgTA4MW8lB1YYd8SelOo12cUS
         vUIlu2sSATTQ8AxRSoZj1AfqbUB/R/tiMnHxc6mS5F7wan+f51MH01RPmlTeR34Uc3Kt
         aV79MD94UV7gSUOUB1BO/ZmojVZ0CnXomcXJCZy1C8BynvhRs7gypBtY+Z50DX9HWceE
         ixmt7gUitjTjrobIXM+qFtioZm51oSeyLWcuubHmXxUNOh+WaeL/L/k234VwV/xRO8Ww
         H+wuIZZrZ3BI4CZFU2hv1r/YPQXQV5XW62FpFp/6qsLhCb6krF9LIZS2iRJA3rx+YDJA
         YiuA==
X-Gm-Message-State: AOAM531E5eswF/mR2hosVziIDhwwIEVlVZWCuAuqLo6LNFINEyDRMBR2
        wEwEgJiBovTQJGeeWoTTXd9C63uSPOUbTA==
X-Google-Smtp-Source: ABdhPJyXM3lkyS7QMVSuQCuzH4E6XiR9jy1GvXOjrBvJAR+Y2hqWv/LZHsFCrmew/kfxbYSMhdz5fA==
X-Received: by 2002:a05:6512:38a4:: with SMTP id o4mr31269888lft.288.1625900249145;
        Fri, 09 Jul 2021 23:57:29 -0700 (PDT)
Received: from localhost.localdomain ([94.103.225.155])
        by smtp.gmail.com with ESMTPSA id q14sm416655lfe.106.2021.07.09.23.57.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jul 2021 23:57:28 -0700 (PDT)
Date:   Sat, 10 Jul 2021 09:57:17 +0300
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     Timur Tabi <timur@kernel.org>
Cc:     David Miller <davem@davemloft.net>, kuba@kernel.org,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: qcom/emac: fix UAF in emac_remove
Message-ID: <20210710095717.140ec45a@gmail.com>
In-Reply-To: <CAOZdJXWm4=UHw42YjUAQLZTNd=qbxyRag7-MJ5V4aq_xf8-1Vw@mail.gmail.com>
References: <20210709142418.453-1-paskripkin@gmail.com>
        <CAOZdJXWm4=UHw42YjUAQLZTNd=qbxyRag7-MJ5V4aq_xf8-1Vw@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 10 Jul 2021 00:02:26 -0500
Timur Tabi <timur@kernel.org> wrote:

> On Fri, Jul 9, 2021 at 9:24 AM Pavel Skripkin <paskripkin@gmail.com>
> wrote:
> >
> > adpt is netdev private data and it cannot be
> > used after free_netdev() call. Using adpt after free_netdev()
> > can cause UAF bug. Fix it by moving free_netdev() at the end of the
> > function.
> 
> Please spell out what "UAF" means, thanks.  If you fix that, then
> 
> Acked-by: Timur Tabi <timur@kernel.org>
> 
> Thanks.

Hi, Timur!

Thank you for feedback. 


David has already applied this pacth. So, should I send v2 or maybe
revert + v2? I haven't been in such situations yet :)




With regards,
Pavel Skripkin
