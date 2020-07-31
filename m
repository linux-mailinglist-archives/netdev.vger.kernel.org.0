Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5079B233C86
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 02:25:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730896AbgGaAZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 20:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730850AbgGaAYn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 20:24:43 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3875EC061575
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 17:24:43 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id 11so27424226qkn.2
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 17:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bCnm2zhl1XL25GtJr/etbA3HQMGW2EG8k+e5UYsAJpw=;
        b=lJtMgGbhxO85pPQ3zmFyvT81x30eZCJUjTqGcbLx9wGlUYe1jJjdPY6ReHw6gFzteV
         PGVcl91LOUNhqC6ggzpRMQ6AloWyvYhtERJOjsT7jyjSwQaTtyqF3aHUeBUqvy/VXOBh
         oblTtIls0ssqkEbpSn4i+FQqshusH5TL4zGs4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bCnm2zhl1XL25GtJr/etbA3HQMGW2EG8k+e5UYsAJpw=;
        b=n/gokPEKZeRnqMy12t4+fFmMJvQZ6+7RfANwIUoAxeHkd9DR7MtmU3jPmXtpGv+DRh
         lOLMIUtrbezwnvE3oOjGymh3i/DRz/WHiKZ7K0vfVrWKXHyn12S8Nj1h2weExPMs6xzN
         rv/XzjXXH+O2+4yk5uzkg9hIM9kmvcUppbDEQ4DUV2Xp7j5W8UXbVhlM0vaepcAmSBO5
         TGFH4QH1XsOQ1/QJVJK2lwA867q42k83hynYOHJz/tnh/Q3CgwyCUfQzrkFP9qWt3O3h
         GXPtV5Yr9xD10AYiX6YUhyti1Rkm63XL/M+WeAA2UJVQWyDsQ96z0zPy4KsvdMKkgGIU
         1B2A==
X-Gm-Message-State: AOAM5318IVC7d5cAGZ9tjWnFt2rSdI3nVaFQgq6BammZ2uVw9AunqlQx
        omMmx6PLUvvSTnlOXhkr8xFvdZCIsEw=
X-Google-Smtp-Source: ABdhPJyL8nQHq/feRWODL+f6riWUWlIIvckSPKVw6ASKdLUBWFslheoDaEo+8HzSvCwEcQUNggF16g==
X-Received: by 2002:a37:aa56:: with SMTP id t83mr1744268qke.150.1596155081428;
        Thu, 30 Jul 2020 17:24:41 -0700 (PDT)
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com. [209.85.222.171])
        by smtp.gmail.com with ESMTPSA id h144sm5618406qke.83.2020.07.30.17.24.39
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2020 17:24:40 -0700 (PDT)
Received: by mail-qk1-f171.google.com with SMTP id j187so27335572qke.11
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 17:24:39 -0700 (PDT)
X-Received: by 2002:a05:620a:3de:: with SMTP id r30mr1567282qkm.221.1596155079426;
 Thu, 30 Jul 2020 17:24:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200726110524.151957-1-xie.he.0141@gmail.com>
 <20200728195246.GA482576@google.com> <CAJht_EOcRx=J5PiZwsSh+0Yb0=QJFahqxVbeMgFbSxh+cNZLew@mail.gmail.com>
In-Reply-To: <CAJht_EOcRx=J5PiZwsSh+0Yb0=QJFahqxVbeMgFbSxh+cNZLew@mail.gmail.com>
From:   Brian Norris <briannorris@chromium.org>
Date:   Thu, 30 Jul 2020 17:24:27 -0700
X-Gmail-Original-Message-ID: <CA+ASDXPRLqq=vxnkF4z8=xvuqOKuuoqifvsNsERWg9uYJrFXgg@mail.gmail.com>
Message-ID: <CA+ASDXPRLqq=vxnkF4z8=xvuqOKuuoqifvsNsERWg9uYJrFXgg@mail.gmail.com>
Subject: Re: [PATCH] drivers/net/wan/lapbether: Use needed_headroom instead of hard_header_len
To:     Xie He <xie.he.0141@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 6:42 PM Xie He <xie.he.0141@gmail.com> wrote:
> On Tue, Jul 28, 2020 at 12:52 PM -0700
> Brian Norris <briannorris@chromium.org> wrote:
> > What is the intention with this X25 protocol? I guess the headers added
> > in lapbeth_data_transmit() are supposed to be "invisible", as with this
> > note in af_packet.c?
...
> This driver is not intended to be used with IPv4 or IPv6 protocols,
> but is intended to be used with a special "X.25" protocol. That's the
> reason the device type is ARPHRD_X25. I used "grep" in the X.25
> network layer code (net/x25) and I found there's nowhere
> "dev_hard_header" is called. I also used "grep" in all the X.25

That well could just be a bug in net/x25/. But from context, it does
appear that X.25 does not intend to expose its headers to higher
layers.

> drivers in the kernel (lapbether.c, x25_asy.c, hdlc_x25.c under
> drivers/net/wan) and I found no driver implemented "header_ops". So I
> think the X.25 networking code doesn't expect any header visible
> outside of the device driver, and X.25 drivers should make their
> headers invisible outside of them.
>
> So I think hard_header_len should be 0 for all X.25 drivers, so that
> they can be used correctly with af_packet.c.
>
> I don't know if this sounds plausible to you. If it does, could you
> please let me have your name in a "Reviewed_by" tag. It would be of
> great help to have your support. Thanks!

Sure, I can do that:

Reviewed-by: Brian Norris <briannorris@chromium.org>

I guess x25 is basically an abandoned project, if you're coming to me for this?
