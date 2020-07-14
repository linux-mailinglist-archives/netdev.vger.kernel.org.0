Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A921D21F928
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 20:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728985AbgGNSXX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 14:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725951AbgGNSXX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 14:23:23 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37368C061755
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 11:23:23 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id gc15so1186514pjb.0
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 11:23:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dOF0KcOAMey7OwWBu3VFMKyGMjn/UASQWe7FxH8TLu0=;
        b=vW+kdZOHDYB0wFd2aZAEfh34lR/RsGq/FAgduQn0iRN8XwQpEwSIIlpSTG9pqyiRCN
         xb4GAKOEa/3TyDcDpWRZEHVAjR84mfIUcP4JMjohCvOrhWKRgFFpi5MytyW+8HNrFzqY
         rkMVi5StksEfOVNXAadKtG78bNLAFbGZnlxUArJedsxwJzYniwnL0tNCw1E2Rd34y+m2
         YQ1R27qymK/zonFgwHYj5LV22acK0VqxZOetBavqS/btegW4oyMBNyQ4JxIn/Mi2atIg
         x25v7Juqepuz/UOVcvKCj0oCy4b0YM9OZtEqTj1B2niZ7lbgRAtt2ih62tf6OB5meHK/
         rv2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dOF0KcOAMey7OwWBu3VFMKyGMjn/UASQWe7FxH8TLu0=;
        b=G/i6Xcueot1NYX76TafGWC+eVwDidTtakl3CRLGDjDKOCXxae1OrTbVzxFrF7OaUJg
         XZzxSmV/M2EJcnINZgDp0/L94GQED4Zd7ZyOqBAfur0L3c5iZi/l6AMYpVDq/CbRr+fU
         GIAOQKo45ci9Z6GMZgpY+8/ADYXFNmrJZ0owPSmFRemDjFxPeEeNyA0ygWHXoQ20eehW
         ILzBXG4TVZIzBCfjCpNQxKYZpyrRCkSBuaSapvyfaeRpkDap+VhqfaWHv6fkdUIMMQs8
         439Xyk52ea0Oga2y2U/l2uP9gOazpoMWDsCZPQEUyUPOAfBxmXpvxbr7oxD8Fgww4X1h
         awgA==
X-Gm-Message-State: AOAM533BRMT/kG1fbs551npA14KQqNsxLITmwefl3y3NlHPvAcq6GeNi
        k9sUBBIoP8KFYlX1V9zn5sFw55jMFqoO6+PUHNPTFw==
X-Google-Smtp-Source: ABdhPJwrudGFuKZJw+FbkVIqwln+dxgpYN7wHF7xLlU/GLaACH6N2a56+HOTD/+Lzx+ZGKnn9RX78xhgpVuEYxmRjj4=
X-Received: by 2002:a17:90a:d306:: with SMTP id p6mr5541989pju.25.1594751002608;
 Tue, 14 Jul 2020 11:23:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200708230402.1644819-1-ndesaulniers@google.com>
In-Reply-To: <20200708230402.1644819-1-ndesaulniers@google.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 14 Jul 2020 11:23:11 -0700
Message-ID: <CAKwvOdmXtFo8YoNd7pgBnTQEwTZw0nGx-LypDiFKRR_HzZm9aA@mail.gmail.com>
Subject: Re: [PATCH v2 0/2 net] bitfield.h cleanups
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, oss-drivers@netronome.com,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, Alex Elder <elder@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 8, 2020 at 4:04 PM Nick Desaulniers <ndesaulniers@google.com> wrote:
>
> Two patches, one that removes a BUILD_BUG_ON for a case that is not a
> compile time bug (exposed by compiler optimization).
>
> The second is a general cleanup in the area.
>
> I decided to leave the BUILD_BUG_ON case first, as I hope it will
> simplify being able to backport it to stable, and because I don't think
> there's any type promotion+conversion bugs there.
>
> Though it would be nice to use consistent types widths and signedness,
> equality against literal zero is not an issue.
>
> Jakub Kicinski (1):
>   bitfield.h: don't compile-time validate _val in FIELD_FIT
>
> Nick Desaulniers (1):
>   bitfield.h: split up __BF_FIELD_CHECK macro
>
>  .../netronome/nfp/nfpcore/nfp_nsp_eth.c       | 11 ++++----
>  include/linux/bitfield.h                      | 26 +++++++++++++------
>  2 files changed, 24 insertions(+), 13 deletions(-)
>
> --
> 2.27.0.383.g050319c2ae-goog
>

Hey David, when you have a chance, could you please consider picking
up this series?
-- 
Thanks,
~Nick Desaulniers
