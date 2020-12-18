Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3E562DEA84
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 21:51:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725854AbgLRUvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 15:51:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbgLRUvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 15:51:03 -0500
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40C7DC0617A7
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 12:50:23 -0800 (PST)
Received: by mail-vs1-xe2a.google.com with SMTP id z16so2076136vsp.5
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 12:50:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Zos+vrw1juFtOnAJ8lVtlsVNlgoQCX/rILjdtFe2IBs=;
        b=daz/w2601L7YtLmdqpf+GSyKjyRxSQ9iMU9wAJTWleM3YVSjdjWr73nAGQe0qOljc8
         /FMOJ8dgU1LSkrZqVAioOgYAmvoSojcxAXG7Fr57BTDaBBeS6C1gFTbHqv+Rsd3rWvu/
         vhbbUndUeTSyD5E32vyndocKmzmaFVWMRbFmR+Wf64PjaBv1pZje8v2pdDKpDyxmN3W6
         TjGumugI05EXhMWfWRNeCg7n7o/lCHoJ/3uqGSM9IDvI+I17XrVi6Zl9cQxN4lcWQU8B
         QFqCX1rbrBaNJ+7Ba1I+dcX68Wml6Tp8WY09PQHOBe+hTjOxRVfPLsO5Vo+eqPfEj23M
         KTHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Zos+vrw1juFtOnAJ8lVtlsVNlgoQCX/rILjdtFe2IBs=;
        b=FZB9ElYn/+huvHC6M7VULMPtojtm2s0SDNhVZL8Nvv8pcEEkRxhSXwEWVdgfp3Hw/T
         oAT8+/q/bHiltbcKO/AD1OF7459rllqA8SyzELhhrxw9Kx9iMY0rfVnJSqRbmsnA2SUR
         YoERNr/yPx3clDxxXGSmIJ9r0ETDh3JcQcSDNfW6zKCipIUha8a5NRHaRj+vhRkUaEr6
         4Qi77DIhoDFIuIVjy7uAkPI7M2VEErdMvYdj6sZS2Q8M1ozXPQhqgf/lG9N008ob4etI
         fxBuULTMLVMM8zUhAl+FD15RPdz5nVu9TVaGSylpXQEt9cA0JW5lz/iqU6iZOO6Dg/Tk
         J7zQ==
X-Gm-Message-State: AOAM5316vdIzCwJuLhHeRP6+qmns0O64/3YtgkeP7Y9v3b1PVVhVz6YW
        pkYzXdtNkggoTklJBRR8KsB3kjgC+gw=
X-Google-Smtp-Source: ABdhPJyQ4Q10uB7BCt9u82Td3KPu4gY72vXRx1EsaZ3M1QMV73aDjhZy7eepSzVMajpve6TJSDrVxg==
X-Received: by 2002:a05:6102:310d:: with SMTP id e13mr6388473vsh.13.1608324621925;
        Fri, 18 Dec 2020 12:50:21 -0800 (PST)
Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com. [209.85.222.52])
        by smtp.gmail.com with ESMTPSA id j203sm1145606vsd.1.2020.12.18.12.50.20
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Dec 2020 12:50:21 -0800 (PST)
Received: by mail-ua1-f52.google.com with SMTP id t19so1274907uaq.1
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 12:50:20 -0800 (PST)
X-Received: by 2002:ab0:4:: with SMTP id 4mr6249912uai.122.1608324620457; Fri,
 18 Dec 2020 12:50:20 -0800 (PST)
MIME-Version: 1.0
References: <20201218201633.2735367-1-jonathan.lemon@gmail.com>
In-Reply-To: <20201218201633.2735367-1-jonathan.lemon@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 18 Dec 2020 15:49:44 -0500
X-Gmail-Original-Message-ID: <CA+FuTSeM0pqj=LywVUUpNyekRDmpES1y8ksSi5PJ==rw2-=cug@mail.gmail.com>
Message-ID: <CA+FuTSeM0pqj=LywVUUpNyekRDmpES1y8ksSi5PJ==rw2-=cug@mail.gmail.com>
Subject: Re: [PATCH 0/9 v1 RFC] Generic zcopy_* functions
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 18, 2020 at 3:23 PM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
>
> From: Jonathan Lemon <bsd@fb.com>
>
> This is set of cleanup patches for zerocopy which are intended
> to allow a introduction of a different zerocopy implementation.

Can you describe in more detail what exactly is lacking in the current
zerocopy interface for this this different implementation? Or point to
a github tree with the feature patches attached, perhaps.

I think it's good to split into multiple smaller patchsets, starting
with core stack support. But find it hard to understand which of these
changes are truly needed to support a new use case.

If anything, eating up the last 8 bits in skb_shared_info should be last resort.

I'll take a look at the individual patches in more detail later.
