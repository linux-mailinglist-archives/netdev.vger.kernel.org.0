Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 189782C0E46
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 16:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389163AbgKWOzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 09:55:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727446AbgKWOzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 09:55:50 -0500
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACC13C0613CF
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 06:55:48 -0800 (PST)
Received: by mail-io1-xd42.google.com with SMTP id i9so18374109ioo.2
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 06:55:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CqyI3EQt2bmPt5VisvW9e8Pv56v0kXNU0qvEIjly+uw=;
        b=tEtOlEx2qU8KDHO8JpqNT4/7QQ7DseRlOHh4tAXIJ/nj4RKuv9tIQ8qC5EwlREa5oV
         Qa5iM1F4Ns+IlpnCSFgqc5iyXvjD0ABoXCtXTd0HF6XMzZbwALgBoYj5BCN8PVus9Pte
         /u98oBMioxJeIl+gENEIT3RZkq1XqHPzfv6bmzuMScwSg6uuJzzvd47RY80LPKp/tbwg
         69EbxT1XKJsd26jEVmO4Mt0JFsXpuHRY+n3EiE5hekHjrozid5gUVaom7MEahHtJw1b3
         yxra7meZdgTTdWu+sYhV5YP2iq8g0tisqvPCy+/giyg1t1wsHRY0HdaobgjBZPFKuFWK
         eOeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CqyI3EQt2bmPt5VisvW9e8Pv56v0kXNU0qvEIjly+uw=;
        b=AklN1WV3Jccqcw4szrvQ5BZtG1IDqAR0QizbtJy1qSkeb0HPdWinDcqhMPwKqWrytn
         RhXTiury63rnNIPKKowOqnyDhpm7d6qW2T5CYSn5INgrxQh1kx6TXhmf/9kYRXH7rVEu
         qSy1t/wnYpGXiCLlnl5x0iA0JefYLKFaQyCEhxnP++t1GdiLyANVscPrQOuaHDkcDaBd
         5snm8E6kJhHp6ZUMfOaPiVUaNVtsbvcPokJHWuGZTYDxknGu0eHxPqBizoAWLxxkBUuB
         2M+jvYHaDZHtRsPFpiaUvVRHH5kcmkc2d19ck4nUurBot1QaiNKOd51d40u7QZ/p69nT
         iKCA==
X-Gm-Message-State: AOAM533sm9pa6nXo5K5OevRtcC1BjRyiv1Zg6M7MQwIwhu4dmbckht9M
        6wNeh/0Esy7Ex6GXqNIG/f9gv0bcsIMQle14wYTISW23SLHjpJri
X-Google-Smtp-Source: ABdhPJwpnn99NzbGBOBMNHFXpAYlfnGwVheQo+eBFmdClW6unzq6nXeGJVkkgES4B9zFx4MW6PDmqPSGb70eRX2/Lxo=
X-Received: by 2002:a5d:948d:: with SMTP id v13mr63638ioj.117.1606143347829;
 Mon, 23 Nov 2020 06:55:47 -0800 (PST)
MIME-Version: 1.0
References: <20201123141256.14208-1-tariqt@nvidia.com>
In-Reply-To: <20201123141256.14208-1-tariqt@nvidia.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 23 Nov 2020 15:55:35 +0100
Message-ID: <CANn89iKRVyTZg-tNQvo_Ub-RZ_A+OOQQY8Py3J9fx=NOZXF9Qw@mail.gmail.com>
Subject: Re: [PATCH net] netdevice.h: Fix unintentional disable of ALL_FOR_ALL
 features on upper device
To:     Tariq Toukan <tariqt@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev <netdev@vger.kernel.org>,
        Moshe Shemesh <moshe@nvidia.com>,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 23, 2020 at 3:13 PM Tariq Toukan <tariqt@nvidia.com> wrote:
>
> Calling netdev_increment_features() on upper/master device from
> netdev_add_tso_features() implies unintentional clearance of ALL_FOR_ALL
> features supported by all slaves.  Fix it by passing ALL_FOR_ALL in
> addition to ALL_TSO.
>
> Fixes: b0ce3508b25e ("bonding: allow TSO being set on bonding master")

I think you should give more details to your bug report, because
netdev_add_tso_features() is used from different
places.

Thanks.
