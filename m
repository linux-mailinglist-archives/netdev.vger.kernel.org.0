Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAA5F46DB95
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 19:53:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239422AbhLHS5a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 13:57:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232216AbhLHS53 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 13:57:29 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D166EC061746
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 10:53:57 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id g17so8091280ybe.13
        for <netdev@vger.kernel.org>; Wed, 08 Dec 2021 10:53:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p4NKapJGA4nFNt7YTHbkgMIRDAqXj6aOrq+ENRmYhlY=;
        b=bWXTTD3U3fB6zFcyF8BBQfmOYml6w7c7MWITDBDl3WP98IPV9yLqSCmLS+pK6HOl0n
         Z5NbHaggI1+pa9PcfqwbQ+SI6AmzHM/iglmOtJFXzgyJFh8f/rCvbqz4ruFZjVt+/ydX
         52pmOzP1v7o7rXPMBdHBf08YkM/dEpOb8gG2ZuhNXWb9KQbZQQ1BHUw/DwbyC8hCTk3R
         l6ddfcmWox/qP7qJyk7a7x3qrnQY6iOGcZqLkGyBi7EjzeiSNimrrXHdgAq6f3ltZqzn
         6GopVxna0zzFC2R7Ln8CUceObRL1Asm+a+8ALTpnII2EA4nXUgc4paDvcWpx7ZU+gxNM
         w2lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p4NKapJGA4nFNt7YTHbkgMIRDAqXj6aOrq+ENRmYhlY=;
        b=7ABl80FWzsC5WGDirufxuAuu6oMwOLbUiLlrZ8yyDVm8rBOUqdXg9ufePb8SR1E5kw
         ImExHrQrOIvmnvkCttr437v19wj+HrvagsHzj8Or0HOVhVu+kEyN34LGIwi9SIhhfPZs
         47IVXq3hl2CmeqmXW/TXQ+wLa+tdqJ4RDwly0Z9jVmPsIjcnXpD6JPMaYu/bz2mXLIAv
         3kdAVeHcDkqGuU/j9S77ihp0SOYWSR+NWPsL1hlOHXNLUzpbyqaOnYVgUHnY4Z1YGBJW
         q5K3cw8FWqJrVkOnUQFvQo8E52vLH7zfqfXxFUgoXCgNZXLIORZkQ/YRO3TgADXe7tDX
         M55g==
X-Gm-Message-State: AOAM531Cv2ffXQMGFm5BAaUJoF7m2vuajCFKoB7EWw7CzvjDTIp03dNB
        4wmiHBZNlTz4ERr+FeGCV/EA0WJHswUzujPh4/Aw2Q==
X-Google-Smtp-Source: ABdhPJxK3odst3dBrrLqVmhiSwRsnRa9+IA154+4HmbfZ/BQpVktEkZtO1a8iC7otHRWsS0nM3TeFMnZoJIAmB4NU9c=
X-Received: by 2002:a25:9d82:: with SMTP id v2mr559200ybp.383.1638989636696;
 Wed, 08 Dec 2021 10:53:56 -0800 (PST)
MIME-Version: 1.0
References: <Ya6bj2nplJ57JPml@lunn.ch> <CANn89iLPSianJ7TjzrpOw+a0PTgX_rpQmiNYbgxbn2K-PNouFg@mail.gmail.com>
 <Ya6kJhUtJt5c8tEk@lunn.ch> <CANn89iL4nVf+N1R=XV5VRSm4193CcU1N8XTNZzpBV9-mS3vxig@mail.gmail.com>
 <Ya6m1kIqVo52FkLV@lunn.ch> <CANn89i+b_6R820Om9ZjK-E5DyvnNUKXxYODpmt1B6UHM1q7eoQ@mail.gmail.com>
 <Ya6qewYtxoRn7BTo@lunn.ch> <CANn89iKbAr2aqiOLWuyYADW7b4fc3fy=DFRJ5dUG7F=BPiWKZQ@mail.gmail.com>
 <Ya+7YlIZgQ1Lz9SI@lunn.ch> <CANn89iKdh3SMT_OED10cBKek5OC6Y8ELPK1jOzmnu9tfBPYh1A@mail.gmail.com>
 <YbDrgEX99jnHlLYV@lunn.ch> <CANn89iLNokrV-sagQARMb2407vg5zzqp+S98nbbWPhoNpeDe3Q@mail.gmail.com>
In-Reply-To: <CANn89iLNokrV-sagQARMb2407vg5zzqp+S98nbbWPhoNpeDe3Q@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 8 Dec 2021 10:53:45 -0800
Message-ID: <CANn89iK9ijiQb9ihAZwywzqmOmEbz8YA375SAAzEAUq_vxUSmw@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 00/23] net: add preliminary netdev refcount tracking
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 8, 2021 at 10:21 AM Eric Dumazet <edumazet@google.com> wrote:
>

> I do not think ns precision of a ktime_t is really needed.
>
> jiffies should be enough, saving potential high cost of ktime_get_ns()
>

Also worth mentioning this is doubling size of ref_tracker.
(going from 32-byte to 64-bytes standard kmem cache)

I would advise creating a dedicated kmem_cache to avoid wasting memory.

current layout being:

struct ref_tracker {
 struct list_head           head;                 /*     0  0x10 */
 bool                       dead;                 /*  0x10   0x1 */

 /* XXX 3 bytes hole, try to pack */

 depot_stack_handle_t       alloc_stack_handle;   /*  0x14   0x4 */
 depot_stack_handle_t       free_stack_handle;    /*  0x18   0x4 */

 /* size: 32, cachelines: 1, members: 4 */
 /* sum members: 25, holes: 1, sum holes: 3 */
 /* padding: 4 */
 /* last cacheline: 32 bytes */
};
