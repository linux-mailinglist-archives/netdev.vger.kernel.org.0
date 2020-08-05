Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50B9923CE19
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 20:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729190AbgHESNp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 14:13:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729077AbgHESLu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 14:11:50 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67601C061757
        for <netdev@vger.kernel.org>; Wed,  5 Aug 2020 11:11:48 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id g6so36118572ljn.11
        for <netdev@vger.kernel.org>; Wed, 05 Aug 2020 11:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uHPd0ivHK9bW5amsgeLfepexH6gYrZPkMtMTrC1KpJc=;
        b=G6m8qZi+rIjXCmBgPmBj7032K/nQAr3NLRmvf8lYANY8VpHEqkoOUIMmt+d3pIfFAy
         8S/32NBJn8RJ/n/l2yPIG3zMcmrEYdd6pmDQs2lDLxgnOVDIQ+3AIoH5XEELjwY5dNjh
         HhXyJvJT3gL+HQyS6+b1R9X52DRdebGwo1/5U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uHPd0ivHK9bW5amsgeLfepexH6gYrZPkMtMTrC1KpJc=;
        b=H7sUQJ6Nr1msq+XW1o/BFPjIgjExmXq9eXiVdjKz5Rt/T+z53V2NnsFQMeOGbWZ7sL
         dSmlJrkrQIwz8stswQEpilwPloAG8Jcio0QQj2JJCunHLnhPeWN9n1DsGW11i7OF6Tej
         KDzb7xH/U6TwpUE1M4POfcM+srRLCU7Xje93k7/tZZrUGwInp11u1WJ7ErLO7JVIufZa
         axd/jTYf2xjPUokwBNJ/e8+JtnwCq9lG/4rJBmZbNAKRrEJT9N3pyWJQR/Wk07qN2Cp9
         5rb0RD5wAzQcVHCVSlFLdl3ZTZNt0ysYqNjUBbqrJKuqF/7Ynerngm/eZkwZa+IsPR1i
         CiTA==
X-Gm-Message-State: AOAM532fox0ZUOBNUWBchqh2Wf2sN50vkOhuqvcmjX+t9HVHGvv/ANMx
        qYmUOZ0IFrTMh7QC2GnAO6t+QjDZ+BI=
X-Google-Smtp-Source: ABdhPJyajO50xYoJV2ZzYM+JoBJIrpPW0i6yvzFzthW1rd5Nw8ZJXpzQ0decQPbws/xtGUM2mtLZmA==
X-Received: by 2002:a05:651c:543:: with SMTP id q3mr1977943ljp.145.1596651106382;
        Wed, 05 Aug 2020 11:11:46 -0700 (PDT)
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com. [209.85.208.170])
        by smtp.gmail.com with ESMTPSA id j144sm1544408lfj.54.2020.08.05.11.11.45
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Aug 2020 11:11:45 -0700 (PDT)
Received: by mail-lj1-f170.google.com with SMTP id w14so18930019ljj.4
        for <netdev@vger.kernel.org>; Wed, 05 Aug 2020 11:11:45 -0700 (PDT)
X-Received: by 2002:a2e:9252:: with SMTP id v18mr1882996ljg.70.1596651104717;
 Wed, 05 Aug 2020 11:11:44 -0700 (PDT)
MIME-Version: 1.0
References: <E1k3KUx-0000da-In@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1k3KUx-0000da-In@rmk-PC.armlinux.org.uk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 5 Aug 2020 11:11:28 -0700
X-Gmail-Original-Message-ID: <CAHk-=whbLwN9GEVVt=7eYhPYk0t0Wh1xeuNEDD+xmQxBFjAQJA@mail.gmail.com>
Message-ID: <CAHk-=whbLwN9GEVVt=7eYhPYk0t0Wh1xeuNEDD+xmQxBFjAQJA@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: update phylink/sfp keyword matching
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 5, 2020 at 7:34 AM Russell King <rmk+kernel@armlinux.org.uk> wrote:
>
> Is this something you're willing to merge directly please?

Done.

That said:

> -K:     phylink
> +K:     phylink\.h|struct\s+phylink|\.phylink|>phylink_|phylink_(autoneg|clear|connect|create|destroy|disconnect|ethtool|helper|mac|mii|of|set|start|stop|test|validate)

That's a very awkward pattern. I wonder if there could be better ways
to express this (ie "only apply this pattern to these files" kind of
thing)

Isn't the 'F' pattern already complete enough that maybe the K pattern
isn't even worth it?

Just a thought, no biggie.

           Linus
