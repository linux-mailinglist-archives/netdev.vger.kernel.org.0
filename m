Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A30793A883D
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 20:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbhFOSIZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 14:08:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbhFOSIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 14:08:25 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45513C061574
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 11:06:20 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id r198so28427637lff.11
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 11:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/qEnYGVBFFbXkq5KvPtZ4VbGgkzVQLvVMcAHO89ymh8=;
        b=e+3T/cGDneNOGM3EtKxeixqgv8YFwnvwg34OxaUhgby81ngEvynd8vT7uwKn1KT5QB
         zaLKV/9hkcVwq9vBc4W8Q+j/hGY0oSBcJzEo4gNAKsdpjROcgagHK3m7fXzTZxydLd8x
         ve/cAzVBacvLZLBxquthJRg8JOKVTAwQvlIb4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/qEnYGVBFFbXkq5KvPtZ4VbGgkzVQLvVMcAHO89ymh8=;
        b=CpR5sU2xkp1wMmFlK6Q6viYUOPqEUxJbJa9hkeVxbjCy6uvl3ViGjufelCCicx448r
         BnDSbs/7KdCQ/9ky4SG//vZWrtBxirgS6xjkIvTgyQ5aLlW3DfeIgVfFZz/8mXKl5Zyh
         XDLT9tQhNcDaffl77RNBTVMxuG9dl1CcQ0D9V09gHTfSYeIFKx6fPAsxGU5rQ5bN7At7
         GwxzF2W7vYyBexgzZZjRDhXv5z0YczIqiN7bF2pjXJB3plpNjatWg9I2kMW4blu3aoyh
         4cqfJrkKky6BdXlVreG39VuBCOQoTJlkkeGVKOEaglEgtmISNkcxLRMCuLr4zjqpNEjX
         h3lw==
X-Gm-Message-State: AOAM531gMVJAa8elY6pwfDYe0HSs7Uvn6OtJ4j9EIibJ243yW/OOkazf
        I9W+EUZMoNE5ZGrhkPOETNFdyTVnZ6wwvRS+
X-Google-Smtp-Source: ABdhPJxZ7g2F2y2Xz7yJ9Nry/q+bCV43UfQvHA38lihu56AqDkcxCAowJcvjxa406WkQCaPXyu4N3g==
X-Received: by 2002:a19:c7cf:: with SMTP id x198mr464809lff.462.1623780378499;
        Tue, 15 Jun 2021 11:06:18 -0700 (PDT)
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com. [209.85.208.178])
        by smtp.gmail.com with ESMTPSA id q6sm1419357ljg.62.2021.06.15.11.06.16
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jun 2021 11:06:16 -0700 (PDT)
Received: by mail-lj1-f178.google.com with SMTP id b37so10270922ljr.13
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 11:06:16 -0700 (PDT)
X-Received: by 2002:a2e:b618:: with SMTP id r24mr775343ljn.48.1623780376308;
 Tue, 15 Jun 2021 11:06:16 -0700 (PDT)
MIME-Version: 1.0
References: <YMjTlp2FSJYvoyFa@unreal> <CAHk-=wiucGtZQHpyfm5bK1xp9vepu9dA_OBE-A1-Gr=Neo8b2Q@mail.gmail.com>
 <YMjnRLdctAzzP0Fi@unreal>
In-Reply-To: <YMjnRLdctAzzP0Fi@unreal>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 15 Jun 2021 11:06:00 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjjzn7Yu42LMJosifcJm6Qp6O0DszTbFyWcdYZ6zQ4eeA@mail.gmail.com>
Message-ID: <CAHk-=wjjzn7Yu42LMJosifcJm6Qp6O0DszTbFyWcdYZ6zQ4eeA@mail.gmail.com>
Subject: Re: NetworkManager fails to start
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Andrea Righi <andrea.righi@canonical.com>,
        stable <stable@vger.kernel.org>,
        linux-netdev <netdev@vger.kernel.org>,
        youling 257 <youling257@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 15, 2021 at 10:45 AM Leon Romanovsky <leon@kernel.org> wrote:
>
> Yes, this patch fixed the issue.
> Tested-by: Leon Romanovsky <leonro@nvidia.com>

Thanks.

I've committed that minimal fix, although we still seem to have some
unexplained failure in this area for android 7 cm14.1 user space.

This has turned out to be fairly painful, with multiple fixes on top
of fixes, and there's still something odd going on. Grr.

           Linus
