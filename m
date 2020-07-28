Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE822307A0
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 12:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728704AbgG1K1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 06:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728424AbgG1K1U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 06:27:20 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDD6EC061794
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 03:27:19 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id a15so10341466ybs.8
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 03:27:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tJhPt4tvCTwgvPIl/mV5HjfxhXvas0frAcXAhLS6UD8=;
        b=AyK0CVMZitsf50IIqjqbXvkj8EGF7DJorN02Wa6oEfFGivcbp0WDmqrZDpAzXRbLhj
         dbiL9zc5KN8IlQ6ZM4WWM+jiDqMJfZi0b4CwunYRoPO++cNTWTou25PFDC8mt0u8152r
         dqJHaPv4R0/iU5Glw1KuHZUWyB0MJvH4b0178+VkAiRmAmnYYBcvt0KJIXDHurjE5So8
         b+6sXy69+VHeQs0d1ccFvc0xHJNpe2efus+xoHV4yxtFI05Elyjm5IJd53R/HzTvrnUu
         XbNwCqFaE4Jogyhs/ILMyp0tVPq0qmwN+HtArfaR1BIms2jJ7y1bJvWKWAgvtQ7XUZ7y
         6kFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tJhPt4tvCTwgvPIl/mV5HjfxhXvas0frAcXAhLS6UD8=;
        b=Z4xSATw0dRaKrzhWm7iU54EC5slbOFpHTHsU2DBzGVYoBJOCyoWUVgJWxm77quvgG5
         wDBJUrpAS4ERHnR50xWXMRdPjQIfrO6EIGJ4AhUkQQQjDeb6BsGSpyyZL1frZ0SoezPY
         EaBq437jLTM7t3+g3vNWV03H8cSPcXNvz/5wkp8WC5+rfZYDvGjkxcFMLaNPtc5oTaPF
         ySEjmTc8E0A/SNkjwvq4xbcDHD9Akr4ce7M7Xi5ZtW3Sm/ECDlUEbrSx7mTiGn8mcphP
         ZSl3bfyfh8V7eUy/paBZn4fsLhVNz8qXvASA6RKc2iSo1+eGRjWfSpVrFXEe3kf2oLJH
         pgmA==
X-Gm-Message-State: AOAM531P44OKmd1Ka1qb9zfWRjV4bolFiULAkHtqvvtoOMGJQXcX22sS
        zbEHandf1L28iL+kdnw7mya5Eqf91KqR8qmn1Uk=
X-Google-Smtp-Source: ABdhPJxgjZ/UxF76zzLSqk1llxnaI25fOWbU0/cfn08NBS/rQdHbb4QFiRhW2SbJEKeJbIwSNkxnG4DzLvVukB0uEmM=
X-Received: by 2002:a25:c6c7:: with SMTP id k190mr44302757ybf.11.1595932039124;
 Tue, 28 Jul 2020 03:27:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200728091035.112067-1-saeedm@mellanox.com> <20200728091035.112067-2-saeedm@mellanox.com>
In-Reply-To: <20200728091035.112067-2-saeedm@mellanox.com>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Tue, 28 Jul 2020 13:27:07 +0300
Message-ID: <CAJ3xEMi-wTfGZvTh=g6Gb5taK_qR=PiDyiAQAPRPiEaSckH8_A@mail.gmail.com>
Subject: Re: [net 01/12] net/mlx5e: Hold reference on mirred devices while
 accessing them
To:     Eli Cohen <eli@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 12:13 PM Saeed Mahameed <saeedm@mellanox.com> wrote:
> From: Eli Cohen <eli@mellanox.com>
>
> Net devices might be removed. For example, a vxlan device could be
> deleted and its ifnidex would become invalid. Use dev_get_by_index()
> instead of __dev_get_by_index() to hold reference on the device while
> accessing it and release after done.

haven't this patch sent in the past in the same form and we were in the middle
of discussing how to properly address this? if something changed, what?
