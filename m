Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DAC441A614
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 05:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238837AbhI1Dff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 23:35:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238745AbhI1Dff (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 23:35:35 -0400
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23222C061575
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 20:33:56 -0700 (PDT)
Received: by mail-vs1-xe2d.google.com with SMTP id i30so176619vsj.13
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 20:33:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zwn0Hfbvtdu02PvhsEsV4657yOEzSj+yc6jqRDVhmVU=;
        b=Wx1pf+T88P/nXVEQlApnz3Q2dBcvSv5iLYrUPfFIi4jecEAdQI561bW7YqYzWEaxuY
         rtOpsehq7aSQeB3U9xic6lm+GLymRRjgkJquREipUeasP9rXTanSuxvQx8mRkBBuxbIh
         UBbpdwevu92Dk3hHNbQKMwRNiFXgmi9aqhgqZKSNiz1WPUz+4ZjTilQ807gxy6PA+9lA
         2tVPcecQwpyAnqyj6GMsvcLh1jbw59/R6to/zNes4tccLDRAG2YA3VsoGaEbZXiknMtY
         Ov5Uod4iAs6IgbZpzYKocaoaZHLslhGtrqOYsguzROfYmLhEDcgnbpOZfiljTczJark2
         2uLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zwn0Hfbvtdu02PvhsEsV4657yOEzSj+yc6jqRDVhmVU=;
        b=CJ2epCak7RGMrwX5P37r2+mlnjzWSvWgX4rWbEwMWOHNSUUr336F1inw+l97yckBj1
         po0tWYYm9Xlpsq9jlCTEQPsvRDOvzCpOnlqy8+g2DwsqWkOS7bqFVXbGsM1tTyHHAA63
         rkbaWtE9VnNO9vWJokXoUGFnTEqZdCQFKXEh7+05+sFNmn+gGh2UdiL1/ZcxU7vXLon4
         UtQm+DLUgZNwYxpnWMbfv8kmAxAmxRkUR18UqsNxP7SJTCcMgZb/at42YjDZpmO6gQRm
         TfWdqR4E1ksSaLy+A0cddTtvhQo06KnwK9dj4NW68AerM6n3UzdTOuYkov0pMQxrvMlR
         uoNw==
X-Gm-Message-State: AOAM533FhO9Bmmn+2TJbfLYhIrOgUH6M1p1AH7TenGGenZbR0lFRdjfP
        6WqSo43T3zL8GzBvmDy8xRtv1/K7QqB5aXSEsYX8ZA==
X-Google-Smtp-Source: ABdhPJyOArVvgQqX7HEEkgqoyEdc+wscoRNxSlSmXGocC1/ZRHMumtJVfqPAL1fbItJkXl7Mh6hVMxcw1+yjnW4t0tU=
X-Received: by 2002:a67:f294:: with SMTP id m20mr3540179vsk.58.1632800035005;
 Mon, 27 Sep 2021 20:33:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210927182523.2704818-1-weiwan@google.com> <20210927175017.57348a9b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210927175017.57348a9b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Wei Wang <weiwan@google.com>
Date:   Mon, 27 Sep 2021 20:33:44 -0700
Message-ID: <CAEA6p_DjyGWF5J5zovoCEdXL8t6grP980WFm0szvy_ZnsZt0mA@mail.gmail.com>
Subject: Re: [PATCH net-next 0/3] net: add new socket option SO_RESERVE_MEM
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Shakeel Butt <shakeelb@google.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 27, 2021 at 5:50 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 27 Sep 2021 11:25:20 -0700 Wei Wang wrote:
> > This patch series introduces a new socket option SO_RESERVE_MEM.
> > This socket option provides a mechanism for users to reserve a certain
> > amount of memory for the socket to use. When this option is set, kernel
> > charges the user specified amount of memory to memcg, as well as
> > sk_forward_alloc. This amount of memory is not reclaimable and is
> > available in sk_forward_alloc for this socket.
> > With this socket option set, the networking stack spends less cycles
> > doing forward alloc and reclaim, which should lead to better system
> > performance, with the cost of an amount of pre-allocated and
> > unreclaimable memory, even under memory pressure.
>
> Does not apply cleanly - would you mind rebasing/resending?
>
Sure. Will do. Sorry about that.

> Would you be able to share what order of magnitude improvements you see?
>
OK. Will share some results from a synthetic benchmark.

> Thanks!
