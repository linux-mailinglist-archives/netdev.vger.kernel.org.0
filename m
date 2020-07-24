Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5424622BDD3
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 08:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbgGXGAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 02:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbgGXGAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 02:00:23 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FF14C0619D3
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 23:00:23 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id t131so8720180iod.3
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 23:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DRC5p8Zr2Q9ijQICvFmLoRlLIBF3P6JAstz9o33Zk20=;
        b=ogUPkKp/P7GtjdapuolmjsArEXmZEMIg7Yy+12Wl/NDP5nmqqqsOaIQWSv9rmQeaky
         UBwjgpSlMwkPCaMOUV9AMW38B2c8b+88OdnRUh4/8KP0mO/dN6KzJVF4+fejM37QZBht
         wD0PTQM9Vldi3ElpbX3fdDt166U/ZSSTx3nmLXboWOVlEPzYMVe7vIOabFnrM6ey40R/
         6Mz6D5SMM9ynbd4zM4NToHGBJ/HLU8pQ5ATxcNHuD7e4srkOYxU6r52On1RIfzYzXn5O
         Ztlph4FOWOXGp40eTFhiV69K5uEqk1L8uUSfudHSBYaGsPDf5d7w4RyOWx0IO9HhcDPK
         0QSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DRC5p8Zr2Q9ijQICvFmLoRlLIBF3P6JAstz9o33Zk20=;
        b=Fz6xShujo65yHW0kSTqr2iZ5y5tpZbRYaeY4DbcOV+QDs5a3bpWEj4YPguw+INzslx
         aiAN3kRRoCmOI7mY7K1UKYcuo+sCB4+q8IEUUsDHVCapOLLEI8Yub8wBpQfOeBDxMxzj
         xB1nkmqYBbNr8FY5bTDaNM12ztqtBo0+6Fbl127GKbcZzNd/VX5EeHQ2ywvAMcELE2d0
         JFD6ze7fz23cz4ZokcKTTDOuXfEm9+wfzJ/I0KrIY3a5xxsq6nIvn1ltQlM0BGe58+EZ
         FfCvNGIaOS31RZt1Lj+qnc/bTv/byj0imOeCVL1s5AZHYdw2hSUVW7blSGlzyJWxxLki
         PUgg==
X-Gm-Message-State: AOAM531Y5CKuZNA70Cjc/Dj0PL8WAMkkuW03PBT8UxcfFP1OehtkCtED
        8RhVinGeMKNcfF0FsNrNHRgMF1/kaxKZc48JBRI=
X-Google-Smtp-Source: ABdhPJy3IjUM6EoX4Gpkros8bEHoxWgO8iYMKvKi/29cIlna/ZriplK8zufs7ZX3405pdRX1j6ozjqAxv2enl5ko9/E=
X-Received: by 2002:a05:6638:14b:: with SMTP id y11mr9044166jao.49.1595570422402;
 Thu, 23 Jul 2020 23:00:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200724045040.20070-1-xiyou.wangcong@gmail.com> <590b7621-95bf-1220-f786-783996fd4a4c@gmail.com>
In-Reply-To: <590b7621-95bf-1220-f786-783996fd4a4c@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 23 Jul 2020 23:00:11 -0700
Message-ID: <CAM_iQpW+TmWjFu=gqDkAVPZ9q6PkJAfMeu87WJ98d-c2PxWoQA@mail.gmail.com>
Subject: Re: [Patch net] qrtr: orphan skb before queuing in xmit
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzbot <syzbot+6720d64f31c081c2f708@syzkaller.appspotmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 23, 2020 at 10:35 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 7/23/20 9:50 PM, Cong Wang wrote:
> > Similar to tun_net_xmit(), we have to orphan the skb
> > before queuing it, otherwise we may use the socket when
> > purging the queue after it is freed by user-space.
>
> Which socket ?

sk->sk_wq points to &sock->wq. The socket is of course from
qrtr_create().

>
> By not calling skb_orphan(skb), this skb should own a reference on skb->sk preventing
> skb->sk to disappear.
>

I said socket, not sock. I believe the socket can be gone while the sock is
still there.


> It seems that instead of skb_orphan() here, we could avoid calling skb_set_owner_w() in the first place,
> because this is confusing.

Not sure about this, at least tun calls skb_set_owner_w() too. More
importantly, sock_alloc_send_skb() calls it too. :)
