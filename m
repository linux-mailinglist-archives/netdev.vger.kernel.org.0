Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7FE24A9C88
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 16:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376365AbiBDPz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 10:55:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376456AbiBDPzv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 10:55:51 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 277E3C06175C
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 07:55:27 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id w25so14012068edt.7
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 07:55:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n6D04wilXtSuF+RMEcMT67RNVn5L7mpxQdznF4XFDzQ=;
        b=p4FOldEf2GNlGiU+Iw+BJwLo+ev9+ma1Pmp4LoZTAP5hfxVsc04zBzIVHmGqQN3qVR
         R0Hr2V2LggIKu2uZb3GKEX3WYk0tJTeqRJ+nHUWolFpZufVihh7ZI/0z4lUyLZJlx7Mb
         Gmd216X7pI5LLKb5zU2ZWnIg+YuWCg8G6u9gupC8lw6QCukuQrOgyc4wPx62C8Stg5WA
         C1q3qjZ5uBjSHFMnX0ZdSOZdBjcqUJOkqDoevUIGGuzjo3xTuMS8nmPkmfuCrenma5JW
         I0e+hixC65nweRteVYWPC41PugcU1FQJn6mTALDubSDYodOVIVhI/yp1NFBjbM79NQ4Q
         n2Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n6D04wilXtSuF+RMEcMT67RNVn5L7mpxQdznF4XFDzQ=;
        b=OZk2OrHcAE73Z6dE23T7GpZoB+fcV1dmYdySZ8PTwq9B9VKjagi57lS06RfYpROBmw
         SrRt8LDzLUEFlOpBc+xZUEWMx/UmERG68EfgoR186QHhAUWc9IqsPE0edBQOKby13mPL
         HudPxlPRkXyl531yG9JkK/C1gWC27WmxBhxSJ3X1X4hqCoEW/a4/VWNoSU79V4/lG/4P
         Js+O/H8omPYNSv6xXjHyezHAWjIk7E04ClOlxu3a0VbYTYjeTWMj8Y0fAGC0sEQ6fBH9
         VIupD9nwDKB6LXnvAId47qxR1ZtxaLAjL6ggMpAfC9yXj/gUKZ6w063ZCpD1uo2p7S7G
         KxqQ==
X-Gm-Message-State: AOAM531+Eu/ukxbcpPEZZBZ479e1j+kpKjY+uiSbY266JDRLIJ+X/dmh
        wza9a9Tdp6ElM2apZEhGci3fB/LKJynsRw1d/iA=
X-Google-Smtp-Source: ABdhPJwGPzOofWLNMERK8olF+8/cbJtlaXHU7we3ZSs6cvYLqAaHNqHKwKhrSiQ21JXdFSvhzRu6sKf3y9wprLd2kRY=
X-Received: by 2002:a05:6402:3c6:: with SMTP id t6mr3618083edw.21.1643990125569;
 Fri, 04 Feb 2022 07:55:25 -0800 (PST)
MIME-Version: 1.0
References: <cover.1643972527.git.pabeni@redhat.com>
In-Reply-To: <cover.1643972527.git.pabeni@redhat.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 4 Feb 2022 07:55:14 -0800
Message-ID: <CAKgT0UeNKjFYZkUfXCX8W8DTxJH7bXxCfERH6e0w6DZ2+N5v1g@mail.gmail.com>
Subject: Re: [PATCH net-next 0/2] gro: a couple of minor optimization
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 4, 2022 at 3:29 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> This series collects a couple of small optimizations for the GRO engine,
> reducing slightly the number of cycles for dev_gro_receive().
> The delta is within noise range in tput tests, but with big TCP coming
> every cycle saved from the GRO engine will count - I hope ;)
>
> v1 -> v2:
>  - a few cleanup suggested from Alexander(s)
>  - moved away the more controversial 3rd patch
>
> Paolo Abeni (2):
>   net: gro: avoid re-computing truesize twice on recycle
>   net: gro: minor optimization for dev_gro_receive()
>
>  include/net/gro.h | 52 +++++++++++++++++++++++++----------------------
>  net/core/gro.c    | 16 ++++-----------
>  2 files changed, 32 insertions(+), 36 deletions(-)

This addresses the concern I had.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
