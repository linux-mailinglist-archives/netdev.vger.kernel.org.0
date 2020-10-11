Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E076F28AA6D
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 22:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729432AbgJKUcr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 16:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729424AbgJKUcq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 16:32:46 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA20DC0613CE
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 13:32:46 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id m15so7345571pls.8
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 13:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Jg21fVtgptgAWAYeT/2X7xATpMSFTImoY00uUZ+iTnA=;
        b=fwIzrfjnIdeMXV03viMJsBuTf/6FjIHSr34srfoNzRilKwjWSBYJTQcaRSc3UVqdyO
         2lSxOy/Ou97nbYdZ6rQIN19FfUJgp2MgLV8D4nIyURIAyxIiPwPMlB1q76cjGspzHsVP
         ta/PzA3oRXNovNOP5Hg2xIVEkmhKFVF7ldbo+Ih3HyeRXb4bFXssX2/URb7+YNWwIfE2
         aTgivJPg9KyY0M44tNcGlvQ+e0aXpsO1x0W3jIlsj+m5Ip8+cCPkRqxAfD4SHvbr40II
         QVgNxIOJGQQ33oilI1pZugFhVxuzKJV9bmb8TrdzKRlHaZVfyEBTcNySMYmi87IkzxF4
         AB+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Jg21fVtgptgAWAYeT/2X7xATpMSFTImoY00uUZ+iTnA=;
        b=nclhiLwahYtbvUqbH19Jg8SM8AVukaAPH3CEiRhe5dyRbB7S8ZNX4M7LunoA1ms5X5
         8F29Kc1fSyRqc8KBRjXV6TqVjaOZbV4U5tPf8brk4fTYKcIm4Rp9lnyzgzbHguIm5Xn5
         8KqazYSlt1l3kXpuxR5uQ2dCisI5GEPT2n1LUCOckW8cdEXjJzMjaTiYUk0IdLFqtS6+
         5p4F9AFICxCovEUim7BRv/YdxCUQaE0ZxpQKGJx8SB4Z7n5twoY9jfSE84gUctEnmpTq
         9hD9NyphcTChO0fwOPRFb182YX3FxT7yyMLo67QJDCqvy53VJ9yUmfNiJf5+RfmGr2cG
         IfMw==
X-Gm-Message-State: AOAM530rbmbxLn+yzxwSGZRHIxYiYfxiHdFUQNct/1zuv3ZvELq9LxtA
        MYfdmvfxddaiH0hYnM0HLV/6S8/76D4zREFnLzRxJ3mSRJ8=
X-Google-Smtp-Source: ABdhPJwDv+Zou0TSHE3wkFkgrgOnDXgFIaQA/taSOOwPa0tfo5tzkGRDkUGak4luXBSxMaWcqUNXuOr35GTwyatyKx0=
X-Received: by 2002:a17:902:9694:b029:d2:1b52:f46 with SMTP id
 n20-20020a1709029694b02900d21b520f46mr21759908plp.78.1602448366355; Sun, 11
 Oct 2020 13:32:46 -0700 (PDT)
MIME-Version: 1.0
References: <20201011191129.991-1-xiyou.wangcong@gmail.com>
In-Reply-To: <20201011191129.991-1-xiyou.wangcong@gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Sun, 11 Oct 2020 13:32:35 -0700
Message-ID: <CAJht_EP5LWUadxwMpdsRAhUrjaUHpi-1QO5N28r7Sqtp4Qxjpw@mail.gmail.com>
Subject: Re: [Patch net v2] ip_gre: set dev->hard_header_len and
 dev->needed_headroom properly
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzbot <syzbot+4a2c52677a8a1aa283cb@syzkaller.appspotmail.com>,
        William Tu <u9012063@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 11, 2020 at 12:11 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> GRE tunnel has its own header_ops, ipgre_header_ops, and sets it
> conditionally. When it is set, it assumes the outer IP header is
> already created before ipgre_xmit().
>
> This is not true when we send packets through a raw packet socket,
> where L2 headers are supposed to be constructed by user. Packet
> socket calls dev_validate_header() to validate the header. But
> GRE tunnel does not set dev->hard_header_len, so that check can
> be simply bypassed, therefore uninit memory could be passed down
> to ipgre_xmit(). Similar for dev->needed_headroom.
>
> dev->hard_header_len is supposed to be the length of the header
> created by dev->header_ops->create(), so it should be used whenever
> header_ops is set, and dev->needed_headroom should be used when it
> is not set.

Hi, thanks for attempting to fix this tunnel. Are we still considering
removing header_ops->create?

As said in my email sent previously today, I want to remove
header_ops->create because 1) this keeps the un-exposed headers of GRE
devices consistent with those of GRETAP devices, and 2) I think the
GRE header (and the headers before the GRE header) is not actually the
L2 header of the tunnel (the Wikipedia page for "Generic Routing
Encapsulation" doesn't consider this protocol to be at L2 either).

I'm not sure if you still agree to remove header_ops->create. Do you
still agree but think it'd be better to do that in a separate patch?

Removing header_ops->create would simplify the fixing of the issue you
are trying to fix, too, because that way we would no longer need to
use header_ops or hard_header_len. Also, I'm worried that changing
hard_header_len (or needed_headroom) in ipgre_link_update would have
racing issues. If we remove header_ops, we no longer need to use
hard_header_len and we can just set needed_headroom to the maximum
value, so that we no longer need to update them in ipgre_link_update.
