Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8C31EC3F4
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 22:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728395AbgFBUnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 16:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728070AbgFBUnk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 16:43:40 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E51F2C08C5C1
        for <netdev@vger.kernel.org>; Tue,  2 Jun 2020 13:43:39 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id r125so6975755lff.13
        for <netdev@vger.kernel.org>; Tue, 02 Jun 2020 13:43:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Azl+Ad2Snhfc0xP2HW9Ep94V4yuBccpc/CvQD+kNGgE=;
        b=bUurhMFsGKldaV/fuSmBFvEu0dq7tRd7XTk2lYRSi7CMt/C6LTxrmwSmxTUVSAUw+R
         hFe8+ZbhpvMW8p8gN7hIFf7JuzG0jpuk+SD5IcjAuz+qyt7SbCCoAckx1gBtY7EuHg70
         ph2LYj1CMupe+0MuVxpfesphrjpJYdYSsavyk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Azl+Ad2Snhfc0xP2HW9Ep94V4yuBccpc/CvQD+kNGgE=;
        b=c1lt0Azaewfpty++wgHM5AsFI5kWePuFB26sG6In1dVBsdEyrWxhUWG1uQkXazPZx9
         63SnWPShcWKNdrd2Yv/A3mMhTcBBW+clm+v54fEoissliqQLJRPixha1+uLsvs1Hs6+J
         43zeXpoHV6WKCIz2iXqXs0yH36caftNDypgVEUNOZ9pHVOYS/zKvZfPZb6bQAJJxINqR
         USKZclIHSOQ7IQoD0rkgBAQRpdSp8kdtAWRfnt83Tri2o+nJDC6JfvPPe3zSSMwftgtq
         Inwjooerll5m9sIFGLQhO09tapLaKyLEUUqWi+jhaj/cXGMJ4EThRzKjn7+rjOG5MI1K
         nK/w==
X-Gm-Message-State: AOAM5322ejAOX2DxU7uK5Csp70ee1HSpohEZe3J5L2Nf/IzSVsXW3fNN
        vwirrN2y0TI44YN6CdWkc4ddq1UbpxM=
X-Google-Smtp-Source: ABdhPJyVFuVyLXzZELtG/2S8aU9RYW1ONkwqSPWivuNHHf0UyWUEg5RytG1I3m2+FDvQjBG6As4NrA==
X-Received: by 2002:a05:6512:2ed:: with SMTP id m13mr581172lfq.43.1591130617631;
        Tue, 02 Jun 2020 13:43:37 -0700 (PDT)
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com. [209.85.167.50])
        by smtp.gmail.com with ESMTPSA id c7sm1386ljj.109.2020.06.02.13.43.36
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Jun 2020 13:43:36 -0700 (PDT)
Received: by mail-lf1-f50.google.com with SMTP id u16so7020095lfl.8
        for <netdev@vger.kernel.org>; Tue, 02 Jun 2020 13:43:36 -0700 (PDT)
X-Received: by 2002:a19:d52:: with SMTP id 79mr590629lfn.125.1591130616197;
 Tue, 02 Jun 2020 13:43:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200602084257.134555-1-mst@redhat.com> <fc204429-7a6e-8214-a66f-bf2676018aae@redhat.com>
 <20200602163306.GM23230@ZenIV.linux.org.uk> <CAHk-=wjgg0bpD0qjYF=twJNXmRXYPjXqO1EFLL-mS8qUphe0AQ@mail.gmail.com>
 <20200602162931-mutt-send-email-mst@kernel.org>
In-Reply-To: <20200602162931-mutt-send-email-mst@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 2 Jun 2020 13:43:20 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgYu+qk15_NpUZXwbetEU5eiWppJ=Z_A6dCSCWKxCfDfw@mail.gmail.com>
Message-ID: <CAHk-=wgYu+qk15_NpUZXwbetEU5eiWppJ=Z_A6dCSCWKxCfDfw@mail.gmail.com>
Subject: Re: [PATCH RFC] uaccess: user_access_begin_after_access_ok()
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Jason Wang <jasowang@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 2, 2020 at 1:33 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> Hmm are you sure we can drop it? access_ok is done in the context
> of the process. Access itself in the context of a kernel thread
> that borrows the same mm. IIUC if the process can be 32 bit
> while the kernel is 64 bit, access_ok in the context of the
> kernel thread will not DTRT.

You're historically expected to just "set_fs()" when you do use_mm().

Then we fixed it in commit...

Oh, when I look for it, I notice that it still hasn't gotten merged.
It's still pending, see

  https://lore.kernel.org/lkml/20200416053158.586887-4-hch@lst.de/

for the current thing.

              Linus
