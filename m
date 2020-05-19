Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEB491D9D22
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 18:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729345AbgESQqY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 12:46:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728953AbgESQqY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 12:46:24 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 969B5C08C5C1
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 09:46:22 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id r125so57353lff.13
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 09:46:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TC0qAtFd13O2JOLCB7SFLNnsJ0TrRRfShJMVEYLbwy0=;
        b=BM7rNRUOZPJu6CqIZoTyNHsH3OhfbJ7v4lyTa1sXCfThZdyIW2MAwpqUoVdCrwYJYJ
         M+8yUvqSB1mogas+2iJO8jLleH/wb+mxdAsp/6H+RxHZ44GfbLZBQMjsb0UkWlV6SNKA
         VToCUizM9QTTj9Opl/oBOtfqOQD3JZAH4FWEo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TC0qAtFd13O2JOLCB7SFLNnsJ0TrRRfShJMVEYLbwy0=;
        b=bRttK5YQ1kvD5cEyr4yKPpcHiq6uK/l/TYPWipOmgo6ied7werLAa1cESoY4Ws6JaU
         HJxBD6iMgrckRZ5zH2cqigvOg3md9OrWX97wMFa+Pw10H0Rsivcw1duLT0noBOl5CYEd
         XJfhhYupIHD6dvDvLFq2saX1ImbGKRM/KxQifalWw9nOmuNxNm3M41L4ZLS7bJyaKcL7
         bpTWvI1dJOt77U6GLm9UDgmpM1iepVyGS9F1OPpHH8SFlaU3WENKlUyDbUmth/RDjh6Z
         PIjGiCfk3QkgLT3sRezBLXXjro7xO9ep7urU1QKbY20M4ekH/OgKsitimSE4yPVz0m8u
         uDgQ==
X-Gm-Message-State: AOAM533tHyUlb5Ix5eMQ7NlyZVdDTuvHnsQ1AMK5gIKyZ041V+FgtiQc
        +A508tem4Xc0e+NTdmx5JKJ3XdVIcnI=
X-Google-Smtp-Source: ABdhPJxI/cvx+BTM7gGo+TmxPRH1FR72H4WMtYreQuira6B6maew+3wZMhETYkCJ5nSaS5MdZH3PAw==
X-Received: by 2002:a19:5056:: with SMTP id z22mr1889406lfj.195.1589906780111;
        Tue, 19 May 2020 09:46:20 -0700 (PDT)
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com. [209.85.208.171])
        by smtp.gmail.com with ESMTPSA id x28sm78624ljd.53.2020.05.19.09.46.18
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 May 2020 09:46:19 -0700 (PDT)
Received: by mail-lj1-f171.google.com with SMTP id m18so459338ljo.5
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 09:46:18 -0700 (PDT)
X-Received: by 2002:a2e:8956:: with SMTP id b22mr218841ljk.16.1589906778412;
 Tue, 19 May 2020 09:46:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200519134449.1466624-1-hch@lst.de> <20200519134449.1466624-13-hch@lst.de>
 <CAHk-=whE_C2JF0ywF09iMBWtquEfMM3aSxCeLrb5S75EdHr1JA@mail.gmail.com> <20200519164146.GA28313@lst.de>
In-Reply-To: <20200519164146.GA28313@lst.de>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 19 May 2020 09:46:02 -0700
X-Gmail-Original-Message-ID: <CAHk-=whVd4evLe-pi7VNrh4Htp1SjogWtEqgot6Ta+kavyqamg@mail.gmail.com>
Message-ID: <CAHk-=whVd4evLe-pi7VNrh4Htp1SjogWtEqgot6Ta+kavyqamg@mail.gmail.com>
Subject: Re: [PATCH 12/20] maccess: remove strncpy_from_unsafe
To:     Christoph Hellwig <hch@lst.de>
Cc:     "the arch/x86 maintainers" <x86@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-parisc@vger.kernel.org,
        linux-um <linux-um@lists.infradead.org>,
        Netdev <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 19, 2020 at 9:41 AM Christoph Hellwig <hch@lst.de> wrote:
>
> I had a lot of folks complaining about things like:
>
> #ifdef CONFIG_FOO
>         if (foo)
>                 do_stuff();
>         else
> #endif
>                 do_something_else();
>
> which I personally don't mind at all, so I switched to this style.

Well, I don't particularly like that style either, it is _very_ easy
to get wrong when you edit it later (and various indentation checkers
tend to be very unhappy about it too).

But that's why I like trying to just make simple helper functions instead.

Yeah, it's often a few more lines of code (if only because of the
extra function definition etc), but with good naming and sane
arguments those few extra lines can also help make it much more
understandable in the process, and it gives you a nice place to add
commentary for the really odd cases (comments inside code that then
does other things often make things just harder to see).

             Linus
