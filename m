Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77B9835CDD0
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344162AbhDLQjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343553AbhDLQfZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 12:35:25 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A352C061248
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 09:28:47 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id v140so22405022lfa.4
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 09:28:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qZnpGTTVy12LfI0sdZ4E7fBRBWOOqVoEC2alh6kMWDY=;
        b=ETzMw5s2kXuc9Y/2ra+bvdUF33rGFaBIkySx0hcWLWbidoSKgMVim2dAvjamPpV0QM
         4TyYhczD2W2l+0e5Njug1LuCt5A6wO1oEXj8ZDZXUo+eIaFLexZJcPDPlggOza31nZ1t
         ApPObtQ9fKw6tJfPWayLLxkYUpk9TiOIbuaW8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qZnpGTTVy12LfI0sdZ4E7fBRBWOOqVoEC2alh6kMWDY=;
        b=H9WmCFwFudSJfvQvUcBgOkKjfVZvTAmOmLineh9AnYPFEyY+J1lc96rNweZzb3L/m7
         t2GK6XHiSPJ9U+tFDWdEUj3NiDwNBjyNRvLEF9LDzWNSWy6m8hZ51+fDwZkPblEc89/Z
         t65oWmwe7jBG7fApOn0z+C6sQBeuDCPHNC5LUEVVs+6FZIhpnrH9KYwdM1rH7opEnKHs
         lo6a9DG2vrxQ8k7+8Fd4Vt20MXUZxvgZNfJX170Fu7WCI6VQ9rOYATJNX2xyo2Uz/BKY
         nMtcNyhRd23vFYhZ1EFC+aliweHupTyQ9V/w8YDQ9p0L81JRYmuwijbCOh9RjeZ33v1w
         pwsQ==
X-Gm-Message-State: AOAM5330PoCaBs0G4vYlD0QH7Jv6moCKHj6iS2d86gmSrRWx+KkAPF/M
        hC9iOOnCYWKPdhsxS3DfvqwJRLuAk1pM0Fin
X-Google-Smtp-Source: ABdhPJwqaqGVDlRXD3Xsrd0ahCPB/qwsfcDsMH4s5rXjKXoqfCKnq1Y7W1kupv+1mQt3p1Aoq/JKmA==
X-Received: by 2002:a05:6512:38aa:: with SMTP id o10mr19842349lft.261.1618244925558;
        Mon, 12 Apr 2021 09:28:45 -0700 (PDT)
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com. [209.85.167.51])
        by smtp.gmail.com with ESMTPSA id c5sm2549551lfk.141.2021.04.12.09.28.44
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Apr 2021 09:28:45 -0700 (PDT)
Received: by mail-lf1-f51.google.com with SMTP id z13so5320934lfd.9
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 09:28:44 -0700 (PDT)
X-Received: by 2002:ac2:58fc:: with SMTP id v28mr18962348lfo.201.1618244924698;
 Mon, 12 Apr 2021 09:28:44 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wiHGchP=V=a4DbDN+imjGEc=2nvuLQVoeNXNxjpU1T8pg@mail.gmail.com>
 <20210412051445.GA47322@roeck-us.net>
In-Reply-To: <20210412051445.GA47322@roeck-us.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 12 Apr 2021 09:28:28 -0700
X-Gmail-Original-Message-ID: <CAHk-=whYcwWgSPxuu8FxZ2i_cG7kw82m-Hbj0-67C6dk1Wb0tQ@mail.gmail.com>
Message-ID: <CAHk-=whYcwWgSPxuu8FxZ2i_cG7kw82m-Hbj0-67C6dk1Wb0tQ@mail.gmail.com>
Subject: Re: Linux 5.12-rc7
To:     Guenter Roeck <linux@roeck-us.net>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Eric Dumazet <edumazet@google.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 11, 2021 at 10:14 PM Guenter Roeck <linux@roeck-us.net> wrote:
>
> Qemu test results:
>         total: 460 pass: 459 fail: 1
> Failed tests:
>         sh:rts7751r2dplus_defconfig:ata:net,virtio-net:rootfs
>
> The failure bisects to commit 0f6925b3e8da ("virtio_net: Do not pull payload in
> skb->head"). It is a spurious problem - the test passes roughly every other
> time. When the failure is seen, udhcpc fails to get an IP address and aborts
> with SIGTERM. So far I have only seen this with the "sh" architecture.

Hmm. Let's add in some more of the people involved in that commit, and
also netdev.

Nothing in there looks like it should have any interaction with
architecture, so that "it happens on sh" sounds odd, but maybe it's
some particular interaction with the qemu environment.

             Linus
