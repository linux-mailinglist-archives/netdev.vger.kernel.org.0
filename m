Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 561D33ABCC0
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 21:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233186AbhFQTcQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 15:32:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231756AbhFQTcM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 15:32:12 -0400
Received: from mail-oo1-xc2c.google.com (mail-oo1-xc2c.google.com [IPv6:2607:f8b0:4864:20::c2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC21FC061574
        for <netdev@vger.kernel.org>; Thu, 17 Jun 2021 12:30:03 -0700 (PDT)
Received: by mail-oo1-xc2c.google.com with SMTP id q20-20020a4a6c140000b029024915d1bd7cso1850009ooc.12
        for <netdev@vger.kernel.org>; Thu, 17 Jun 2021 12:30:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=96aOqFV+Msept1aExEkb8x6Rqhfeyqwt0lWHBevMNvo=;
        b=oIB+8RnNPZyuKWRqD2bU8tkh/BghW1F0ppi6t9hKA1zF5buiMYjTkXkIhwTvmKhdxm
         IGq5N8xt3LwhgoEG6ydIYCuY/1sQwkMdTD8fQsrz0Be+jZIMtY+Vsq78m4XdWHmKznN1
         1c/XxoKiFU7kyNBAhN8hjv+3S0KhkfFo5cNok=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=96aOqFV+Msept1aExEkb8x6Rqhfeyqwt0lWHBevMNvo=;
        b=LIQ42S5GhNjZUn2KJpKRQ3snHAbiTkTzz5z5nZcmURPVfRH6zNjzM75Ginzbit+5/A
         0smAC8kZcnt6ITM3fAFIEnAgM3ArGF1uXj1R+JGPBBdDjKSQEILnEj0RxdBa3f9Y4Zwv
         +uQP4VD7U1O+1VxgQ8aR5CkISQzP+Lfie/Vp4tSQGvakPFlh1NwvUPbQTDRamz7V9KCO
         439N9vSJCS4oCZGnLDPmcaQdV+cBbP8e9wpexyY3YL/LnDHBpw2EnXxCZGdHqdRlohPc
         BmH+dhhculXLnmangtzaUj926iEteAtzP65Va53beqM1RXa78Gfv8C2GJguSv1vBtyEb
         8nKw==
X-Gm-Message-State: AOAM530/0F5zLrQbJxOsOyI6gF1bqulq1lTBsQXRHOB23l2apm4UChNg
        y3lTlUgYlfIJo65v3TebsJlbus9K9ruEFQ==
X-Google-Smtp-Source: ABdhPJzL+DNJaOeQrVaTCZuzilrAmvbhDUj7f6OOFMhQ2GULqkw+DiQvEsePU4zuMgfNpMbCovtb5w==
X-Received: by 2002:a4a:e9b1:: with SMTP id t17mr5858577ood.0.1623958202732;
        Thu, 17 Jun 2021 12:30:02 -0700 (PDT)
Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com. [209.85.167.172])
        by smtp.gmail.com with ESMTPSA id x199sm1272905oif.5.2021.06.17.12.30.01
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Jun 2021 12:30:02 -0700 (PDT)
Received: by mail-oi1-f172.google.com with SMTP id x196so7710699oif.10
        for <netdev@vger.kernel.org>; Thu, 17 Jun 2021 12:30:01 -0700 (PDT)
X-Received: by 2002:a05:6808:60e:: with SMTP id y14mr11266904oih.105.1623958199878;
 Thu, 17 Jun 2021 12:29:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210617171522.3410951-1-keescook@chromium.org>
In-Reply-To: <20210617171522.3410951-1-keescook@chromium.org>
From:   Brian Norris <briannorris@chromium.org>
Date:   Thu, 17 Jun 2021 12:29:47 -0700
X-Gmail-Original-Message-ID: <CA+ASDXOE2EgkiqyqkiXrUCMas+aVU1hJy4uDwafhWv6REjsefg@mail.gmail.com>
Message-ID: <CA+ASDXOE2EgkiqyqkiXrUCMas+aVU1hJy4uDwafhWv6REjsefg@mail.gmail.com>
Subject: Re: [PATCH] mwifiex: Avoid memset() over-write of WEP key_material
To:     Kees Cook <keescook@chromium.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 17, 2021 at 10:15 AM Kees Cook <keescook@chromium.org> wrote:
>
> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memset(), avoid intentionally writing across
> neighboring array fields.
>
> When preparing to call mwifiex_set_keyparamset_wep(), key_material is
> treated very differently from its structure layout (which has only a
> single struct mwifiex_ie_type_key_param_set). Instead, add a new type to
> the union so memset() can correctly reason about the size of the
> structure.
>
> Note that the union ("params", 196 bytes) containing key_material was
> not large enough to hold the target of this memset(): sizeof(struct
> mwifiex_ie_type_key_param_set) == 60, NUM_WEP_KEYS = 4, so 240
> bytes, or 44 bytes past the end of "params". The good news is that
> it appears that the command buffer, as allocated, is 2048 bytes
> (MWIFIEX_SIZE_OF_CMD_BUFFER), so no neighboring memory appears to be
> getting clobbered.

Yeah, this union vs. the underlying buffer size always throws me for a
loop on figuring out whether there's truly a buffer overflow on some
of this stuff...

> Signed-off-by: Kees Cook <keescook@chromium.org>

Looks like a valid refactor to me:

Reviewed-by: Brian Norris <briannorris@chromium.org>
