Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0F96201A79
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 20:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388647AbgFSSiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 14:38:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730687AbgFSSiG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 14:38:06 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8948FC0613EE
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 11:38:06 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id c21so6122412lfb.3
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 11:38:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=H3fbVijkwGqEXjgf746UVzNHZFijt5PEP/I+cIGFrOI=;
        b=Pbi6ZcZ/j5UzKi4TuELv3vWZVoPaSRX4qHDHfjemlgk/7t9FABxdeWgh51bILfCKJ5
         wi8F+rrtMy4gj2dpmCJd8yxSDI3bKAoHjCDk9Pmgk4ebmFXb7pgJH6u8Pl1d3HL2Cn+Y
         CfZiRrUn8yF0xtr+Dhn2AXvWp8IgyXRWpqhQ8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=H3fbVijkwGqEXjgf746UVzNHZFijt5PEP/I+cIGFrOI=;
        b=qy6MOidr0c0Kg9uko8LG0ujoCSX1MD5x3RcnETlB9CqXqn22k1kR5kV/rkKq3CHzN9
         rK4db/XX2BUHB0Kblxep6NxnHnA65+N3qbHWPJBfSC+V4HOUlAFF8KAfqmvPWL8G5xaL
         FLG3M+aohGIX80779+NRpXqValekfOdX/jJZIHL5cWen7wrZ+XB1QHvp/l1YfsGvd4vh
         LQvQiQTW49QzVfdHy3YL38Ok0MledjaHaentDvimoWOZi/V8UnzLdPIzp+zFicHdAkzD
         UVzsOffqKJEvBl5XOSN8hAD1Zb1q/cqxKcTXvyk1tZ3r3GE56eVBS29Cs30QJwSp0bnq
         U2tg==
X-Gm-Message-State: AOAM531nedkUzEU0/7FEBxzhHSt1TKyKlgWuVGMNBV6gvXw4WKnqJNhB
        kD2h5tgRiJxPXn8zQzabawmCswWCBog=
X-Google-Smtp-Source: ABdhPJwN5BQP0LYNPYolrYS3tp7BdldSGAHZc6ckjz6svbm1am5UjyK8qHXwlsos01X7MFfp5VRSgA==
X-Received: by 2002:a19:4301:: with SMTP id q1mr2638706lfa.96.1592591884615;
        Fri, 19 Jun 2020 11:38:04 -0700 (PDT)
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com. [209.85.167.50])
        by smtp.gmail.com with ESMTPSA id q13sm1540278lfb.55.2020.06.19.11.38.03
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Jun 2020 11:38:04 -0700 (PDT)
Received: by mail-lf1-f50.google.com with SMTP id c21so6122360lfb.3
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 11:38:03 -0700 (PDT)
X-Received: by 2002:a19:ae0f:: with SMTP id f15mr2684358lfc.142.1592591883165;
 Fri, 19 Jun 2020 11:38:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200618210645.GB2212102@localhost.localdomain>
In-Reply-To: <20200618210645.GB2212102@localhost.localdomain>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 19 Jun 2020 11:37:47 -0700
X-Gmail-Original-Message-ID: <CAHk-=whz7xz1EBqfyS-C8zTx3_q54R1GuX9tDHdK1-TG91WH-Q@mail.gmail.com>
Message-ID: <CAHk-=whz7xz1EBqfyS-C8zTx3_q54R1GuX9tDHdK1-TG91WH-Q@mail.gmail.com>
Subject: Re: [PATCH] linux++, this: rename "struct notifier_block *this"
To:     Alexey Dobriyan <adobriyan@gmail.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 2:06 PM Alexey Dobriyan <adobriyan@gmail.com> wrote:
>
> Rename
>         struct notifier_block *this
> to
>         struct notifier_block *nb
>
> "nb" is arguably a better name for notifier block.

Maybe it's a better name. But it doesn't seem worth it.

Because C++ reserved words are entirely irrelevant.

We did this same dance almost three decades ago, and the fact is, C++
has other reserved words that make it all pointless.

There is no way I will accept the renaming of various "new" variables.
We did it, it was bad, we undid it, and we now have a _lot_ more uses
of 'new' and 'old', and no, we're not changing it for a braindead
language that isn't relevant to the kernel.

The fact is, C++ chose bad identifiers to make reserved words.

If you want to build the kernel with C++, you'd be a lot better off just doing

   /* C++ braindamage */
   #define this __this
   #define new __new

and deal with that instead.

Because no, the 'new' renaming will never happen, and while 'this'
isn't nearly as common or relevant a name, once you have the same
issue with 'new', what's the point of trying to deal with 'this'?

             Linus
