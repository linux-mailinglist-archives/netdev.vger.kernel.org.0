Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E192748A48F
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 01:51:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345986AbiAKAvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 19:51:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345988AbiAKAvV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 19:51:21 -0500
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93D08C06175B
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 16:51:18 -0800 (PST)
Received: by mail-qt1-x836.google.com with SMTP id b11so10027858qtk.12
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 16:51:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+sLp7uiXG6rPIwVr5Lx4s12bT/foyboWbp+QYVK4VYg=;
        b=CJoRpn+Ay1jfgcksIW/QFzjNCuOTQn5w0UmXNQKEHF46aqDBvyyvaPav8fHytmAJtB
         9pwzjPaUJ5qpvgt8GFPEY+GWgg0FPf303Ql3mVUL7iMQa3xU18kWdd1RMoVvxJqsqKJw
         1JPyiVa1Mkqa8ax5O3A9U7nrkDzKR6BwmqpzA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+sLp7uiXG6rPIwVr5Lx4s12bT/foyboWbp+QYVK4VYg=;
        b=RAPXjECNFB4Grj/TLJJeTiD5EtcT9fp1rurm/3NBxzqmWb0x3Ma7lTnQGzga36MztU
         9Csn4qvdIWbqQstlSwXzr8mr91pWArgENiN3B22ZAWjU3vjin2nZqNmT2x8qdgxP5eKC
         oxEyKEFC1Em2TETojKC0rT4FuD6Gym15GIg2LJ+/5/cJpYmB+NOyiYGUDCJwuq+Y8DI2
         n4jOes+8Dn8LIQBMzkUFItJU3ZhpaibSYneORRL56giFIwwP7NOlp+dDZkSSQt2amVgM
         KNq3+AInI+yJ1hgO25tMtLBy7sZDxFFm1DdAPqWwvkRcSZGR6WU2nMu6EIn65JnBNtdM
         /eCA==
X-Gm-Message-State: AOAM533eDWA51cePmsQscfpYPgArrCaKwJJXELrqPfmoBaFhYFC9wOYu
        05MA1EZFx6KRVCMUehJK0t9GpJBC21RHCw==
X-Google-Smtp-Source: ABdhPJzLZjkw5k+0Z+D2mbV8KJ6yvEsbkBswRmhGYbaZ0dQLIJMCHVCAwVZKj3coXCRjrEvTW0YERA==
X-Received: by 2002:a05:622a:1a1e:: with SMTP id f30mr1942424qtb.465.1641862277589;
        Mon, 10 Jan 2022 16:51:17 -0800 (PST)
Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com. [209.85.219.174])
        by smtp.gmail.com with ESMTPSA id h9sm2546804qkn.60.2022.01.10.16.51.17
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Jan 2022 16:51:17 -0800 (PST)
Received: by mail-yb1-f174.google.com with SMTP id m6so32573775ybc.9
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 16:51:17 -0800 (PST)
X-Received: by 2002:a25:d142:: with SMTP id i63mr3201948ybg.253.1641862276626;
 Mon, 10 Jan 2022 16:51:16 -0800 (PST)
MIME-Version: 1.0
References: <20220110231255.v2.1.Ie4dcc45b0bf365077303c596891d460d716bb4c5@changeid>
In-Reply-To: <20220110231255.v2.1.Ie4dcc45b0bf365077303c596891d460d716bb4c5@changeid>
From:   Doug Anderson <dianders@chromium.org>
Date:   Mon, 10 Jan 2022 16:51:04 -0800
X-Gmail-Original-Message-ID: <CAD=FV=VVzQFK_PwnCXkJ6OK3DcgBnoxmvNG3WXFn30ncdY-E_w@mail.gmail.com>
Message-ID: <CAD=FV=VVzQFK_PwnCXkJ6OK3DcgBnoxmvNG3WXFn30ncdY-E_w@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] ath10k: search for default BDF name provided in DT
To:     Abhishek Kumar <kuabhs@chromium.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        ath10k <ath10k@lists.infradead.org>,
        Rakesh Pillai <pillair@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@kernel.org>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Jan 10, 2022 at 3:15 PM Abhishek Kumar <kuabhs@chromium.org> wrote:
>
> +int ath10k_core_parse_default_bdf_dt(struct ath10k *ar)
> +{
> +       struct device_node *node;
> +       const char *board_name = NULL;
> +
> +       ar->id.default_bdf[0] = '\0';
> +
> +       node = ar->dev->of_node;
> +       if (!node)
> +               return -ENOENT;
> +
> +       of_property_read_string(node, "qcom,ath10k-default-bdf",
> +                               &board_name);
> +       if (!board_name)
> +               return -ENODATA;
> +
> +       if (strscpy(ar->id.default_bdf,
> +                   board_name, sizeof(ar->id.default_bdf)) < 0)
> +               ath10k_warn(ar,
> +                           "default board name is longer than allocated buffer, board_name: %s; allocated size: %ld\n",
> +                           board_name, sizeof(ar->id.default_bdf));

I suspect, but don't know for sure, that you're going to get another
builder splat here. Just like sizeof() isn't guaranteed to return an
"unsigned int", it's also not guaranteed to return an "unsigned long".
I believe you want %zu. See Documentation/core-api/printk-formats.rst

> +
> +       return 0;
> +}
> +EXPORT_SYMBOL(ath10k_core_parse_default_bdf_dt);

Boy, that function seems like overkill for something that you need
once at init time. ...and I also suspect that the lifetime of the
string returned by of_property_read_string() is valid for as long as
your "of_node" is held and thus probably you could use it directly (it
likely has a longer lifetime than the location you're storing it).

...but I guess it matches the ath10k_core_check_dt() function above
it, so I guess it's fine?

-Doug
