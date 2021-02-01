Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA1C30B28B
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 23:07:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbhBAWGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 17:06:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbhBAWEV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 17:04:21 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24404C061573
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 14:03:41 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id m13so20543344oig.8
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 14:03:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B49gml/8cpgz8Os7F0PVegLTz0oYjIQVNIevIep8kh4=;
        b=Gh9nYVSmTAOkcwnoYC7iPOHwxtJA70Mk0Z650ygrrx6ADWq9ub7IYWOPuASCC9cfkR
         GNhMZJWnjvwu8PZuhQEAvjEz9dOe5j3dbaPZKcR1CsU4U6CZJNDNcG3q1TzPmIR7xT5+
         57Fg8AK0YFDpp5Gd6AIZUFWO5td0ItCu3ZNxs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B49gml/8cpgz8Os7F0PVegLTz0oYjIQVNIevIep8kh4=;
        b=iAxhguiuHBu8YX0COOjPagI3OmJ9ZXoaUnWwt4dKRDhVcv/+dBWD3JSoaKlKVJOEvT
         yzbdEvJiF92aFBbnRP16GZIJcZAJrBLNDRcXqsu660DZ/mjGJPfxKjUN7Sm8VUF0yOQE
         Ji9JmxFf+LafAjsxAtx5RlRsves8ZK51ANQMGcfjV73SoznOSeVz1ETFwrAu6GU9oe9a
         XPw17dSDhn0DPczyXJvzZeXnp20BAG+caknYHkMGreFB8LuyDKcqye0k6WYxt5FbiMil
         L6yXCw7A3B7zCgOoFJXoAGwudsUQyUODz8FYhYN6B1vVh+BqejVLaaI7BP6KJn/njLwt
         SGiA==
X-Gm-Message-State: AOAM531sMqHsS5E0TKLpAGqrnD7cxdhWX5PNf9mU7jD00YRFcwMc+6KF
        DD8aLg8EVMFBjK4Y22Ry59Cj/znfI6WDzA==
X-Google-Smtp-Source: ABdhPJxab1PydMalj/6X4nvgPsmyd+zdOXZJxDYzELTmpccsbUo2ECwyRSwqGjSsbFOCMf6u9RtY7Q==
X-Received: by 2002:aca:1813:: with SMTP id h19mr668502oih.102.1612217020182;
        Mon, 01 Feb 2021 14:03:40 -0800 (PST)
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com. [209.85.167.176])
        by smtp.gmail.com with ESMTPSA id l4sm4376087oou.8.2021.02.01.14.03.38
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Feb 2021 14:03:39 -0800 (PST)
Received: by mail-oi1-f176.google.com with SMTP id d20so4785498oiw.10
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 14:03:38 -0800 (PST)
X-Received: by 2002:aca:f40c:: with SMTP id s12mr622260oih.105.1612217018531;
 Mon, 01 Feb 2021 14:03:38 -0800 (PST)
MIME-Version: 1.0
References: <20210201070649.1667209-1-yenlinlai@chromium.org>
In-Reply-To: <20210201070649.1667209-1-yenlinlai@chromium.org>
From:   Brian Norris <briannorris@chromium.org>
Date:   Mon, 1 Feb 2021 14:03:26 -0800
X-Gmail-Original-Message-ID: <CA+ASDXO-bVXhEJE+7kSe85e8i31kzACHeypt-8vBD2ZO2_1=3Q@mail.gmail.com>
Message-ID: <CA+ASDXO-bVXhEJE+7kSe85e8i31kzACHeypt-8vBD2ZO2_1=3Q@mail.gmail.com>
Subject: Re: [PATCH] mwifiex: Report connected BSS with cfg80211_connect_bss()
To:     Yen-lin Lai <yenlinlai@chromium.org>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Xinming Hu <huxinming820@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 31, 2021 at 11:07 PM Yen-lin Lai <yenlinlai@chromium.org> wrote:
> When a network is moved or reconfigured on the different channel, there
> can be multiple BSSes with the same BSSID and SSID in scan result
> before the old one expires. Then, it can cause cfg80211_connect_result
> to map current_bss to a bss with the wrong channel.
>
> Let mwifiex_cfg80211_assoc return the selected BSS and then the caller
> can report it cfg80211_connect_bss.
>
> Signed-off-by: Yen-lin Lai <yenlinlai@chromium.org>

This seems sane to me:

Reviewed-by: Brian Norris <briannorris@chromium.org>
