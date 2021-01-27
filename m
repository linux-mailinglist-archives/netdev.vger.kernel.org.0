Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 974FC306535
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 21:31:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233218AbhA0Ubo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 15:31:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233238AbhA0UaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 15:30:23 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63D41C06174A;
        Wed, 27 Jan 2021 12:29:43 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id e9so1690754plh.3;
        Wed, 27 Jan 2021 12:29:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=35nce9wUdGps1xFNE+LJWAtds0eN6VprBugB5bMnyd4=;
        b=lc9qa04WTv0m3c/3XhNlf7uDFlWXVko6oHEt3W5ZOc7fHSaDKbtZ68UbdT4Tc/5/Oc
         yyk+MkwlyYN8ZFDLTWHgZcIQHop2n8EmepZG23sNKQrG+JYzWUm8728P25A1iZ/zcy+t
         vD4hxI/jiBWYfvMgGIXVJ9RPVrbaqUxOx16nXJqWyANmiJeyvvQZPGhkO4vkKQz6wMRV
         heAbzQs9/EnqBMQ6vC1aBk2gjPS0tTyKWPMmF30xznDpB7PnrtydWfmjINUnTUXT9W3x
         9L5VO6zli5WtQIeLuAtl3pkGTlE1pik/uKVxFFcij2Qpyeagse7GDi5OgHuHR6L6Ey51
         bfBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=35nce9wUdGps1xFNE+LJWAtds0eN6VprBugB5bMnyd4=;
        b=oXVpQwyNVXjx4tcagCS8Jq542489+Ic2z8O7SKp2QAAFQyNMtZNu5cS2AS0/rf1088
         h+Ml0vPO6uyDTTHVY72OkVFJM/F8fmt9elTYVgAx/P3qPp5dx+61Zc4NJyf/hpuj5qpm
         DVEIO5ZggbyiO0rDxC5hskGULry5rlzkE5wWBcZ8jyYre8/9fUxlSNA5VHk0LjBDJAHp
         WNnsOBSf9/C6x+r8/rTMsILb5psAf6ICqtc6/JnVnkw2bGkgeESKJD+0kgYHr5Ya5+Zb
         4cOQZLTgOW3yCma4dAEZyNUhyhO+G8haNSwPtRuEvKq9KAQiguiMLpEmC4y9wjSlfydc
         i9tw==
X-Gm-Message-State: AOAM531gcrAahfJQUZYRNlt5Q8wgCdCeXxWRcoRsPx0Wpjnr0Auc5uEc
        sK3yEoAhlcSCCdySKHDH/JPX2oARBCCenFMKXxw=
X-Google-Smtp-Source: ABdhPJxEi3uD5rET0PDQTKx6E4iOY3SwYwOFQfmoAC68fdLXTbDKCkktMTASlHWeX+NrtO+A9y2MnK9ScP7jXhgTnjk=
X-Received: by 2002:a17:90a:5403:: with SMTP id z3mr7616166pjh.198.1611779383014;
 Wed, 27 Jan 2021 12:29:43 -0800 (PST)
MIME-Version: 1.0
References: <20210127090747.364951-1-xie.he.0141@gmail.com> <77971dffcff441c3ad3d257825dc214b@AcuMS.aculab.com>
In-Reply-To: <77971dffcff441c3ad3d257825dc214b@AcuMS.aculab.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Wed, 27 Jan 2021 12:29:32 -0800
Message-ID: <CAJht_ENmxCBk=h68CN55qySMAiYhcgS0AtVzo6RvS5xf_6EkRw@mail.gmail.com>
Subject: Re: [PATCH net] net: hdlc_x25: Use qdisc to queue outgoing LAPB frames
To:     David Laight <David.Laight@aculab.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-x25@vger.kernel.org" <linux-x25@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Martin Schiller <ms@dev.tdt.de>,
        Krzysztof Halasa <khc@pm.waw.pl>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 2:14 AM David Laight <David.Laight@aculab.com> wrote:
>
> If I read this correctly it adds a (potentially big) queue between the
> LAPB code that adds the sequence numbers to the frames and the hardware
> that actually sends them.

Yes. The actual number of outgoing LAPB frames being queued depends on
how long the hardware driver stays in the TX busy state, and is
limited by the LAPB sending window.

> IIRC [1] there is a general expectation that the NR in a transmitted frame
> will be the same as the last received NS unless acks are being delayed
> for flow control reasons.
>
> You definitely want to be able to ack a received frame while transmitting
> back-to-back I-frames.
>
> This really means that you only want 2 frames in the hardware driver.
> The one being transmitted and the next one - so it gets sent with a
> shared flag.
> There is no point sending an RR unless the hardware link is actually idle.

If I understand correctly, what you mean is that the frames sent on
the wire should reflect the most up-to-date status of what is received
from the wire, so queueing outgoing LAPB frames is not appropriate.

But this would require us to deal with the "TX busy" issue in the LAPB
module. This is (as I said) not easy to do. I currently can't think of
a good way of doing this.

Instead, we can think of the TX queue as part of the "wire". We can
think of the wire as long and having a little higher latency. I
believe the LAPB protocol has no problem in handling long wires.

What do you think?
