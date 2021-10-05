Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 379724232D7
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 23:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236749AbhJEVaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 17:30:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236701AbhJEVaC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 17:30:02 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64F7CC061755
        for <netdev@vger.kernel.org>; Tue,  5 Oct 2021 14:28:11 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id m3so1670119lfu.2
        for <netdev@vger.kernel.org>; Tue, 05 Oct 2021 14:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K7jQ1mmWi2XBmpgAPcJ8NJOBcFNqeNIIIqJq69SJlXI=;
        b=aqmi0VcnQ1JDOG+62KHNkPCW9psm3Gc6I0WmwAmeqOHaqPxliahcaOEbptUWdB27P7
         TVvOUr1XDPRcbTiUrvwEYTrrA6U7YHnWyjQWHv9VYsTcw+eKDp1YRbSzqXp42CGdFQm/
         dlspqoxgRfSifvqYNBCP8cB8iMfjHRGMisfOY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K7jQ1mmWi2XBmpgAPcJ8NJOBcFNqeNIIIqJq69SJlXI=;
        b=ypP2Z0X1AgoWMf+EEX4R9vUPadm95RlBKayr0gG0vD6mlslSuUorh/X+K1jn71/8yu
         CftX12YNyWyiaeU74HEsoUmOlM0b/t3jMtHVRzsTY62b5KgXkJNVwMrI1gCvST+NhKiR
         +RQb1ZFOlGkjZyfM2Evntsk5WkrTOIGXVyNlKtyIiW99u9GtKbriqw0O1SdyZhyLYOp5
         e1OjRlayboy8RdeiXj37WvtTqzqGjddCWbPm/4lKMdjav+Qc3+oIM+qliShAxzJHgkaX
         2skjogek7sU42q0wp1hLPmyhy8yJWfX6OhGYqu+D8sjTmpGFjWpScH2GWN8EoyUWbwk3
         DDbA==
X-Gm-Message-State: AOAM5333cAnuQm5bUvpB/dJLWA6PbnJA1JnUipeCWkeckEPY3UZ1QflU
        +5b3I+Kwp2JOLFs+MUVPqcmmazQs4FBmzzFwAtA=
X-Google-Smtp-Source: ABdhPJzCr2DLiHJhDVnER7Z8iitGsXvCjKxpccoQuta/Qb6GP4OLrodhZxYmyjHtLYLDZIAtY4NNUA==
X-Received: by 2002:a05:651c:544:: with SMTP id q4mr26702721ljp.60.1633469289533;
        Tue, 05 Oct 2021 14:28:09 -0700 (PDT)
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com. [209.85.167.41])
        by smtp.gmail.com with ESMTPSA id 14sm2078030lfy.54.2021.10.05.14.28.06
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Oct 2021 14:28:07 -0700 (PDT)
Received: by mail-lf1-f41.google.com with SMTP id x27so1613405lfu.5
        for <netdev@vger.kernel.org>; Tue, 05 Oct 2021 14:28:06 -0700 (PDT)
X-Received: by 2002:a2e:5815:: with SMTP id m21mr24761572ljb.95.1633469286442;
 Tue, 05 Oct 2021 14:28:06 -0700 (PDT)
MIME-Version: 1.0
References: <20211005094728.203ecef2@gandalf.local.home> <ef5b1654-1f75-da82-cab8-248319efbe3f@rasmusvillemoes.dk>
 <639278914.2878.1633457192964.JavaMail.zimbra@efficios.com>
 <826o327o-3r46-3oop-r430-8qr0ssp537o3@vanv.qr> <20211005144002.34008ea0@gandalf.local.home>
 <srqsppq-p657-43qq-np31-pq5pp03271r6@vanv.qr> <20211005154029.46f9c596@gandalf.local.home>
 <20211005163754.66552fb3@gandalf.local.home> <pn2qp6r2-238q-rs8n-p8n0-9s37sr614123@vanv.qr>
In-Reply-To: <pn2qp6r2-238q-rs8n-p8n0-9s37sr614123@vanv.qr>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 5 Oct 2021 14:27:49 -0700
X-Gmail-Original-Message-ID: <CAHk-=whFhTofNk5G6dYFoFJC10EKzGdZVQdQygXHXWm_jodwBQ@mail.gmail.com>
Message-ID: <CAHk-=whFhTofNk5G6dYFoFJC10EKzGdZVQdQygXHXWm_jodwBQ@mail.gmail.com>
Subject: Re: [RFC][PATCH] rcu: Use typeof(p) instead of typeof(*p) *
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Paul <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        "Joel Fernandes, Google" <joel@joelfernandes.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, rcu <rcu@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        coreteam <coreteam@netfilter.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 5, 2021 at 2:09 PM Jan Engelhardt <jengelh@inai.de> wrote:
>
> Illegal.
> https://en.cppreference.com/w/c/language/conversion
> subsection "Pointer conversion"
> "No other guarantees are offered"

Well, we happily end up casting pointers to 'unsigned long' and back,
and doing bit games on the low bits of a pointer value.

So it's not like the kernel deeply cares about theoretical portability.

But I do discourage casting when not required, just because as much
static type checking we can possibly have is good when we can do it.

              Linus
