Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 938D92E104D
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 23:37:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728401AbgLVWa5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 17:30:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728163AbgLVWa4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 17:30:56 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7845DC0613D6
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 14:30:16 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id b26so26103031lff.9
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 14:30:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vjYFPjk7rgVuqAwGx+B/otvJ3LuNwvpN2FEt46eyObc=;
        b=amvUI7K4WAcLJ9tnS+LAQ/n1NuF8P0UHe7+AYMNPMZnlv7fJUTNx6E64RbgvlZ8Owe
         TJ2z8GKkZYGOSNicckNAcD9zOIvW/TqKNSMHTQvnPxXGufSRr4imYMXgwJdUYT5XGD2N
         NiKRNsdPVxPuEYBGxfX557J2zseQwqgqzGg3c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vjYFPjk7rgVuqAwGx+B/otvJ3LuNwvpN2FEt46eyObc=;
        b=Ak9EcESe0qzgPwa7dwIRGZUwE9ve03urP+N0U+NAVRDkTpRZiQ1OkxmNsIjMccSy8H
         w9U/CSCqScRoh6S25l4O7xuMu4jMH0acS/zHS+k4PXAlkSE0tUzeq1dd8V7wBVbmNTYA
         7eTOf10Vv9D2Vwlb0nv6XgISSxvgCx4iLniDKxlq9WjkUexa5MwjHOIz7+i1J30ZDKbn
         o6fWIqTl59E7qrC9uBDZmrphsrSdUJvmIx37nBp4blnKUiFkalf0fqTzz4hpR+UoD27w
         DIXfqK0wcOLLveSOatQuyRRYt3vMOZQDqzRMZOqP2YTfsA6EVf7yazax4qpT1zS4X2Qe
         9tYw==
X-Gm-Message-State: AOAM533dr9otUy6LVwcZRhzO2jAmAYYJJPM8A1dQcd28++rVpE2lhoS4
        QbwgvOgW4H9tLfyPypEyfGdTtyFajA28Bg==
X-Google-Smtp-Source: ABdhPJyfpO4Kqt28nTSYOsVKsSaEUPOfTsWqykkkc2rZXmF9+vDSP05mmsflrVMLdVq5y2QhZid7zg==
X-Received: by 2002:a19:e20a:: with SMTP id z10mr2904328lfg.295.1608676214540;
        Tue, 22 Dec 2020 14:30:14 -0800 (PST)
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com. [209.85.167.52])
        by smtp.gmail.com with ESMTPSA id i18sm3028615lja.102.2020.12.22.14.30.13
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Dec 2020 14:30:13 -0800 (PST)
Received: by mail-lf1-f52.google.com with SMTP id o13so35620747lfr.3
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 14:30:13 -0800 (PST)
X-Received: by 2002:a05:6512:789:: with SMTP id x9mr9144963lfr.487.1608676213222;
 Tue, 22 Dec 2020 14:30:13 -0800 (PST)
MIME-Version: 1.0
References: <000000000000fcbe0705b70e9bd9@google.com> <20201222222356.22645-1-fw@strlen.de>
In-Reply-To: <20201222222356.22645-1-fw@strlen.de>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 22 Dec 2020 14:29:57 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjB83CZvzp88Axc278L+uSKEdztA9OO7kjx64R7Y9n31A@mail.gmail.com>
Message-ID: <CAHk-=wjB83CZvzp88Axc278L+uSKEdztA9OO7kjx64R7Y9n31A@mail.gmail.com>
Subject: Re: [PATCH nf] netfilter: xt_RATEEST: reject non-null terminated
 string from userspace
To:     Florian Westphal <fw@strlen.de>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        syzbot <syzbot+e86f7c428c8c50db65b4@syzkaller.appspotmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 22, 2020 at 2:24 PM Florian Westphal <fw@strlen.de> wrote:
>
> strlcpy assumes src is a c-string. Check info->name before its used.

If strlcpy is the only problem, then the fix is to use strscpy(),
which doesn't have the design mistake that strlcpy has.

Of course, if the size limit of the source and the destination differ
(ie if you really want to limit the source to one thing, and the
destination to another - there are in theory valid cases where that
happens), then there are no useful helper functions for that.

                Linus
