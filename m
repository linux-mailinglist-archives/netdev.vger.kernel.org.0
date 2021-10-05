Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF5D6422E70
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 18:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235684AbhJEQyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 12:54:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233825AbhJEQyp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 12:54:45 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DD63C061749
        for <netdev@vger.kernel.org>; Tue,  5 Oct 2021 09:52:54 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id b20so89681334lfv.3
        for <netdev@vger.kernel.org>; Tue, 05 Oct 2021 09:52:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eLZ4fUPrQrbt7FIi8eh6e+j83DwiHUC8faRiqF4uPzs=;
        b=Sx/egy7EF/hE71/yLc5iCclMS1KXr0PsI3iiyddcxXDm2B0Fxf8mgNzYhQ2YN7zBBO
         /4+9Kcm3Z11rJyATI53bYBVYHhIMcqzuKTHZLXoJBScRA6Yo3U68Qhd6c/SYBgRtmj6W
         xEbTJ6zX5RaesGntJeEEsVug181hbwk/vJhRE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eLZ4fUPrQrbt7FIi8eh6e+j83DwiHUC8faRiqF4uPzs=;
        b=2dV761AOQgE0pJvfwxf42/YFYW6CznVmRLCCLi2oZsEMZxHEAIlgD8R4Su0YPPcRfP
         5YwyuuVdmcx12rjfys/PVReBKWJW9B4euLWXZbFTAfTza7LeiNJtQ6739lSSIhnteAve
         3rj7HZB/GoZ5sp3f5isvFAy5MTZPIWrIdnAPwgmd5p5L1BvsdgdTlQyNRsxkAzBbTLJ/
         cuZrToTnvLyk2zlUWeuVgDRCZ7geM59b6swKpIOmRuhsPG+grHpG9G8Wr6lJnkPYvXIb
         lQfDprQgrpN+5xKOKqejmI4EPBMJtkZZL6xOPvFjoi+OmE7ZLJ9Os6nnA5H1EOi4td/G
         wUxg==
X-Gm-Message-State: AOAM5322/ILcSd0bUu/N1JFlJ2tSvVDE6CSFEVHyBu+ONeRdBfN7uVZy
        UFGCsWxQfpZev11JLxfI7fpZlhpYmJ25VM6n
X-Google-Smtp-Source: ABdhPJwXPhlRpmvuKzQ2TQrj+6exwqIVfYzYWPvxfbwUVOaK7HZ0gA8td1Ru2NorLXPMkxvWroWRcA==
X-Received: by 2002:a05:6512:1052:: with SMTP id c18mr4298055lfb.223.1633452772111;
        Tue, 05 Oct 2021 09:52:52 -0700 (PDT)
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com. [209.85.167.53])
        by smtp.gmail.com with ESMTPSA id i15sm898307lfc.11.2021.10.05.09.52.51
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Oct 2021 09:52:51 -0700 (PDT)
Received: by mail-lf1-f53.google.com with SMTP id i24so38870096lfj.13
        for <netdev@vger.kernel.org>; Tue, 05 Oct 2021 09:52:51 -0700 (PDT)
X-Received: by 2002:a05:6512:12c4:: with SMTP id p4mr4519659lfg.280.1633452446149;
 Tue, 05 Oct 2021 09:47:26 -0700 (PDT)
MIME-Version: 1.0
References: <20211005094728.203ecef2@gandalf.local.home> <CAHk-=wj0AJAv9o2sW7ReCFRaD+TatSiLMYjK=FzG9-X=q5ZWwA@mail.gmail.com>
 <20211005123729.6adf304b@gandalf.local.home>
In-Reply-To: <20211005123729.6adf304b@gandalf.local.home>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 5 Oct 2021 09:47:10 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg8duLUhR4duN2fNWRF73oGufZNMyvyF5Twp9FnqXmq+g@mail.gmail.com>
Message-ID: <CAHk-=wg8duLUhR4duN2fNWRF73oGufZNMyvyF5Twp9FnqXmq+g@mail.gmail.com>
Subject: Re: [RFC][PATCH] rcu: Use typeof(p) instead of typeof(*p) *
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, rcu <rcu@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        coreteam@netfilter.org, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 5, 2021 at 9:37 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> Oh well, it was a fun exercise. Too bad we failed due to inconsistencies in
> compilers :-(

I'm admittedly surprised that something like this would be a
"different compiler versions" issue. But "typeof()" isn't exactly
standard C, so the fact that some version of gcc did something
slightly different is annoying but I guess not _that_ surprising.

Oh well indeed,

           Linus
