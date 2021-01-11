Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD5112F1E1F
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 19:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390179AbhAKSfH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 13:35:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726435AbhAKSfG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 13:35:06 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A9F0C061786
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 10:34:26 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id n3so301670pjm.1
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 10:34:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NtyyhY/1nRxnMQNpMnsEqZnZoAfskZI4ZaycyaGUR3s=;
        b=m8+FBvVxDV9Bz3v+nO4VgCbtvhmeCPc6MmbKSeZChO2MwOgZP33Tc//++zpq3VO11X
         +CqWYKjFTdBa+CdjU4hgPlHO19zUafkPOhdhtfaaZs7zvYzunO8LyM6iEZSgbTHeXZtq
         dqld5jfJfZQg6zmpPjOeuPH/AdQJkj8NRgOfp+WPotnp2Z9QQ/2ldUg4E+BaJbB2bc7V
         SWUpyKy/lSA+bv1ZRfryA/YIyovxQycNCsAaY7jJPimQgQE0av3i1dQ7XNZyUka8rvSL
         FgNYIVCk86ft0xfVQZCfn0ohaA4OWxBYwIPqZQaIUr5pROEtx42C9u1+sHjE2XV+FxhW
         UBsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NtyyhY/1nRxnMQNpMnsEqZnZoAfskZI4ZaycyaGUR3s=;
        b=ZoWWdI4fOE27ZCigWC+JF+m54NI0JZvu/xS1R8a19qcnZ5ubw1tr+Zj9ZcTkcUW94B
         uu3eicbubLepW1ea86z5ZtSrq123Z8s37Kv/zQ8uUouC9Gmx6pY27CIy4nFx8BSONBLg
         LXO9BnWMH0AzsdPtudt/8Iapt9ZsKK+5g18M/KGKqyvhfSyLFXedccen6SRX0KKWYhwW
         XneGezsy2hb6C1S+5WWdXOqztyMoGpH6UO6gw8wEIhcUXHg3CaH42P/rwgojQ1wI6hA+
         bYqAzUSWZYzLS3sG0AWnYOeSaorNhy70Z2m2wn58z1MCgvYeIt9lzVdoycfzfeFTQxtK
         aGHQ==
X-Gm-Message-State: AOAM530RsuafP+X333tJMhRIVcP9VqhcmM4jx6q9LIUcmMzUSv+4/Va4
        CH49YUFFf59cB9EuEFHRHojxVkxJT9KUYaL9OXY=
X-Google-Smtp-Source: ABdhPJxzp/yeEhQih9MpMxuU7+lz39laoABeq2v8vxhj8CJeEvhO/XQKPlhlqzys2mqmn/ZCvi7mu+9f2X59x8gQFSM=
X-Received: by 2002:a17:902:9302:b029:da:f6b0:643a with SMTP id
 bc2-20020a1709029302b02900daf6b0643amr586239plb.33.1610390065740; Mon, 11 Jan
 2021 10:34:25 -0800 (PST)
MIME-Version: 1.0
References: <20210111052922.2145003-1-kuba@kernel.org>
In-Reply-To: <20210111052922.2145003-1-kuba@kernel.org>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 11 Jan 2021 10:34:15 -0800
Message-ID: <CAM_iQpWObTT=wRyebs0BOX5Bx_5d_ox=uMdLnLLTnCkptY9Q8Q@mail.gmail.com>
Subject: Re: [PATCH net-next] net: bareudp: simplify error paths calling dellink
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 10, 2021 at 9:29 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> bareudp_dellink() only needs the device list to hand it to
> unregister_netdevice_queue(). We can pass NULL in, and
> unregister_netdevice_queue() will do the unregistering.
> There is no chance for batching on the error path, anyway.
>
> Suggested-by: Cong Wang <xiyou.wangcong@gmail.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>


Reviewed-by: Cong Wang <xiyou.wangcong@gmail.com>

Thanks for cleaning up!
