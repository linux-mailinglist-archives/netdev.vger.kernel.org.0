Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D31853E39DD
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 12:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbhHHKXS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 06:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbhHHKXR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Aug 2021 06:23:17 -0400
Received: from mail-oo1-xc36.google.com (mail-oo1-xc36.google.com [IPv6:2607:f8b0:4864:20::c36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A424EC061760;
        Sun,  8 Aug 2021 03:22:57 -0700 (PDT)
Received: by mail-oo1-xc36.google.com with SMTP id e3-20020a4ab9830000b029026ada3b6b90so3549187oop.0;
        Sun, 08 Aug 2021 03:22:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=60Gvr5OIXwK22nwkVBSgaU/i8SL3qWVYPuBR2P0gTyg=;
        b=D1MJm4Eo1stU5GMhmbNoMKYFYExcT2+lF4HylgYWWM41/WLLyx8UWwLWbsQmiOCqZE
         d+G14VFI6Vy+vd81WU5cjxJmmuR+nwCxwyUnXxAc7q8hWgWuOyVlPEefQMZHWmBJT+22
         KdkAIG/ed8vtFUFnIGCAiVnQEtcPttvryJ9a9RhM+8tPZ8ezuflbnGJKxBA+WW7fa+VE
         bqC2qAwM8VC1MMZJINUBlwgzzWPXn9XtfhlDxYLC1Xl84ReTbnlBII2n5JiTmNTtRAFh
         sBlMnRX2nJj0zQdYPOGaAmKMZJ4rze5rPuZrhZyNUB2bfCCHzoN4eHUwU4xu22vSqg/m
         tBig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=60Gvr5OIXwK22nwkVBSgaU/i8SL3qWVYPuBR2P0gTyg=;
        b=K/xlvdChOAHOviMNttPJpdIq3E0k+iwVycPqTqbw6+rXWaX4sl8kpSMiVcxJ+uobIn
         OIny9wV9ueeclh4aUla+825t0ytHfUNQtoYKr9WnfT1oOqPW/+4cfn1W2RUn3BnRwm0k
         l6i/YxnKpkQu+pLtXltziTXW0fYtRA0IeGKWImKSqAuMxX6DqTU1VOLeRNtuM85Jq+dE
         jVafW4X/VruI0VJR/kdDihVtO5F97ASQc0j/x/+whQSvmhNnqbNDg9Ct2MOJ0FcRVTTg
         Wk7XDnBXcb5dcR+SXh3kuhBJB/myku+zUUfIu5Pn44lV5ZKbAjO3lApzXN9PyWPp2HqH
         Cbog==
X-Gm-Message-State: AOAM530WM3rOQq081Gag/yrkkjMymbo1HBe4Vp9JioHecfwEree9+osB
        2q341tSezkL9hXlXZSQuPiDc2mrPQGqGtBBMZsM=
X-Google-Smtp-Source: ABdhPJy9Q7gNsBcArGWIDUn1yfqmW3uJ2x7jmvfjMbBIVVdHGOmTpeeTeps8cD8p0eeluQrRRYYscI93toHv05G0CEE=
X-Received: by 2002:a4a:98b0:: with SMTP id a45mr12054396ooj.22.1628418176944;
 Sun, 08 Aug 2021 03:22:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210808063344.255867-1-weiyongjun1@huawei.com>
In-Reply-To: <20210808063344.255867-1-weiyongjun1@huawei.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Sun, 8 Aug 2021 13:23:17 +0300
Message-ID: <CAHNKnsQHpkMU6yo7MB0M_9ucwRynNwdKx7a9+6WB9Zx+_s_mGg@mail.gmail.com>
Subject: Re: [PATCH net-next] wwan: mhi: Fix missing spin_lock_init() in mhi_mbim_probe()
To:     Wei Yongjun <weiyongjun1@huawei.com>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Hulk Robot <hulkci@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 8, 2021 at 9:21 AM Wei Yongjun <weiyongjun1@huawei.com> wrote:
>
> The driver allocates the spinlock but not initialize it.
> Use spin_lock_init() on it to initialize it correctly.
>
> Fixes: aa730a9905b7 ("net: wwan: Add MHI MBIM network driver")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Reviewed-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
