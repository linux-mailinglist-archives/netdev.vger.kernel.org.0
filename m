Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 545B112FECD
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 23:32:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728796AbgACWcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 17:32:11 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:33007 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728687AbgACWcL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 17:32:11 -0500
Received: by mail-ed1-f68.google.com with SMTP id r21so42807217edq.0
        for <netdev@vger.kernel.org>; Fri, 03 Jan 2020 14:32:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DI+q8l26li/5PDrOxJxAXEHpg2W9fEGy8X9N/luNSeE=;
        b=wKwl4/j7D9z1Dils+P4kypKdzyBAo55uRQO8biaPYyQ/FtNs2lDFnOFA16ux5vX/Og
         rmJ2IoklRdanTEz/WN36N0ln0A/bjmeo5pMtC6LiwkIAiHoDw1osT/pZul/snEoP1uFj
         hTupc/FJhcHlDLTEKQk89q1mHsQwNRMHY+scVL3B/1i35BiRI+/1Wq3b3wrUY41cF5Q+
         2BtI11PHnYuhryC8kUNwrAvjP/hmbjmWmEoS0I4dGbd/kKYe3VSzk6A8VWc6bqrIKZJL
         FE0UY/vXkzRsfQ++QaDsvXhWNUsKPleql4zXpw5Gxm9QZEld67JMrosj1YdGPz9YU/+p
         d2Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DI+q8l26li/5PDrOxJxAXEHpg2W9fEGy8X9N/luNSeE=;
        b=a13GCjF7xxVEKmYRKIdQvNBiZK2238uosdIIvqJlRDxrzVyi37bXdhQ3moLvJ06rWu
         mFSAprEqroi2nvC3ggqtcqsaXZpo0VQcbpBKahopBLoOawZ0QALUAfWaKn8wQexY8/tA
         LOKxex8AlmzzLAQF7yX5jD7gxqBcmaQzToDZYwEVx3HCSkhQpQmhGg9AdrDdN6RWYrPl
         41LtdzYcweNroGCv0S0hjKYTEnBbeP4xvjIXOyrpjnk2jAqmICk4Ye7bOG0H60HFF6WU
         owIpCx3OwmkhRT8zxmTm1xo4p+K/3FU++/cb8X2Q5JObacAINQS0YibxcAJHJ9XiT1Ma
         61zQ==
X-Gm-Message-State: APjAAAU9O54z2imRR+wlhba0pPEo3+HWKbf7w9HXjDR4CEmNWX4+tYSf
        6VFV1sx5oAWA+eIcKSn6iEo/xph/Jf/XKZ0Qx7OmjVKX
X-Google-Smtp-Source: APXvYqxUxugEq8aeJmiPH3w/i+eqShuYK2ceL0vW5Q/Etqt+yUmhsy//eltyL0myLP6L1ODcnNIXgcki0zarh0iDZ74=
X-Received: by 2002:a17:906:2e53:: with SMTP id r19mr95716896eji.306.1578090729107;
 Fri, 03 Jan 2020 14:32:09 -0800 (PST)
MIME-Version: 1.0
References: <CALx6S37uWDOgWqx_8B0YunQZRGCyjeBY_TLczxmKZySDK4CteA@mail.gmail.com>
 <20200103081147.8c27b18aec79bb1cd8ad1a1f@gmail.com> <CALx6S361vkhp8rLzP804oMz2reuDgQDjm9G_+eXfq5oQpVscyg@mail.gmail.com>
 <20200103.124517.1721098411789807467.davem@davemloft.net>
In-Reply-To: <20200103.124517.1721098411789807467.davem@davemloft.net>
From:   Tom Herbert <tom@herbertland.com>
Date:   Fri, 3 Jan 2020 14:31:58 -0800
Message-ID: <CALx6S34vyjNnVbYfjqB1mNDDr3-zQixzXk=kgDqjJ0yxHVCgKg@mail.gmail.com>
Subject: Re: [PATCH v8 net-next 0/9] ipv6: Extension header infrastructure
To:     David Miller <davem@davemloft.net>
Cc:     Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Simon Horman <simon.horman@netronome.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 3, 2020 at 12:45 PM David Miller <davem@davemloft.net> wrote:
>
> From: Tom Herbert <tom@herbertland.com>
> Date: Fri, 3 Jan 2020 09:35:08 -0800
>
> > The real way to combat this provide open implementation that
> > demonstrates the correct use of the protocols and show that's more
> > extensible and secure than these "hacks".
>
> Keep dreaming, this won't stop Cisco from doing whatever it wants to do.

See QUIC. See TLS. See TCP fast open. See transport layer encryption.
These are prime examples where we've steered the Internet from host
protocols and implementation to successfully obsolete or at least work
around protocol ossification that was perpetuated by router vendors.
Cisco is not the Internet!
