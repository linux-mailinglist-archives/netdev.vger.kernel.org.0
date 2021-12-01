Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C853D465827
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 22:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240431AbhLAVNA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 16:13:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238123AbhLAVM7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 16:12:59 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77362C061748
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 13:09:38 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id p65so8723553iof.3
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 13:09:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SDcnRnl8WP6Hhxu22CYqrzttmdFEJ6bFnF0IuQOZgnM=;
        b=HIo8SsAV/jdz9Ezru0XkiaGCYNseoT0H9XCbHbUEUQxxnhdW+xPryVmgZIs8RchCVS
         iVjIkQfiWSh3hFCK3p5QzB243IfIiojauSMYHCnbtSyBlDlAOxTbjKOkl4xk0dvFGjNb
         +S8xtG82gzw4TCMF/rs/NDRUeqgrwF5zbweeA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SDcnRnl8WP6Hhxu22CYqrzttmdFEJ6bFnF0IuQOZgnM=;
        b=2RfcbgBiffEBT8RQb3gBL3EwbkhEYC/M/XCL82KK4efW7NI4kgPEPhMhXpPADcKtvC
         T+cek4m2FLKIybNsFnDKkQo32t7uUxns/g0ZPgjUwRLWG4sjHfaivqek84SCKAF4H/Yu
         3woZ6u0LBgceRiUHYsG+dnsPD2cp8rFlRe/GC7rzIxZUGW3kpN0yqtmACy76aKK/MCG6
         RGuTJEcLHwIZLtC8B38VMSVa8A2nsObld31pl9ngwOE/7IuWW2XQFbDBbMOBdh/eQrj9
         rj1Bx4RC70uYPe8Zn/cZymh50TuS/V0ejjTS17UxqdUCspDy5E0Hcip4Rfc7qJlrvyND
         Iu7w==
X-Gm-Message-State: AOAM531xR+q8cZhjJ5Sk7d8kJCxCH9nMHx7pd0FDUbSq2HJVBEFSdZX0
        p7PImUn/d/7t8k6ZawgqNKGX6ShNcuyFuA==
X-Google-Smtp-Source: ABdhPJwdqaLI8sTVBlTbYFM6tflLruxr96s4hpFmT5BijkszEgSCtpww5dX+jGsBtKcQ/GmmkQNO9A==
X-Received: by 2002:a5d:85d5:: with SMTP id e21mr11674495ios.51.1638392977612;
        Wed, 01 Dec 2021 13:09:37 -0800 (PST)
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com. [209.85.166.170])
        by smtp.gmail.com with ESMTPSA id i8sm541835ilu.84.2021.12.01.13.09.36
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Dec 2021 13:09:36 -0800 (PST)
Received: by mail-il1-f170.google.com with SMTP id a11so26577013ilj.6
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 13:09:36 -0800 (PST)
X-Received: by 2002:a92:ca0e:: with SMTP id j14mr10532883ils.27.1638392976093;
 Wed, 01 Dec 2021 13:09:36 -0800 (PST)
MIME-Version: 1.0
References: <0e495b14-efbb-e0da-37bd-af6bd677ee2c@gmail.com> <YaV0pllJ5p/EuUat@google.com>
In-Reply-To: <YaV0pllJ5p/EuUat@google.com>
From:   Doug Anderson <dianders@chromium.org>
Date:   Wed, 1 Dec 2021 13:09:24 -0800
X-Gmail-Original-Message-ID: <CAD=FV=UEA8JG8=tNWMdv2p9jgEm6KCGUeMCi1O4T7eVVnefZjg@mail.gmail.com>
Message-ID: <CAD=FV=UEA8JG8=tNWMdv2p9jgEm6KCGUeMCi1O4T7eVVnefZjg@mail.gmail.com>
Subject: Re: [PATCH] mwifiex: Fix possible ABBA deadlock
To:     Brian Norris <briannorris@chromium.org>
Cc:     Jia-Ju Bai <baijiaju1990@gmail.com>, amitkarwar@gmail.com,
        ganapathi017@gmail.com, sharvari.harisangam@nxp.com,
        huxinming820@gmail.com, kvalo@codeaurora.org,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Nov 29, 2021 at 4:47 PM Brian Norris <briannorris@chromium.org> wrote:
>
> Quoting Jia-Ju Bai <baijiaju1990@gmail.com>:
>
>   mwifiex_dequeue_tx_packet()
>      spin_lock_bh(&priv->wmm.ra_list_spinlock); --> Line 1432 (Lock A)
>      mwifiex_send_addba()
>        spin_lock_bh(&priv->sta_list_spinlock); --> Line 608 (Lock B)
>
>   mwifiex_process_sta_tx_pause()
>      spin_lock_bh(&priv->sta_list_spinlock); --> Line 398 (Lock B)
>      mwifiex_update_ralist_tx_pause()
>        spin_lock_bh(&priv->wmm.ra_list_spinlock); --> Line 941 (Lock A)
>
> Similar report for mwifiex_process_uap_tx_pause().
>
> While the locking expectations in this driver are a bit unclear, the
> Fixed commit only intended to protect the sta_ptr, so we can drop the
> lock as soon as we're done with it.
>
> IIUC, this deadlock cannot actually happen, because command event
> processing (which calls mwifiex_process_sta_tx_pause()) is
> sequentialized with TX packet processing (e.g.,
> mwifiex_dequeue_tx_packet()) via the main loop (mwifiex_main_process()).
> But it's good not to leave this potential issue lurking.
>
> Fixes: ("f0f7c2275fb9 mwifiex: minor cleanups w/ sta_list_spinlock in cfg80211.c")
> Cc: Douglas Anderson <dianders@chromium.org>
> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
> Link: https://lore.kernel.org/linux-wireless/0e495b14-efbb-e0da-37bd-af6bd677ee2c@gmail.com/
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> ---
>
> On Tue, Nov 23, 2021 at 11:31:34AM +0800, Jia-Ju Bai wrote:
> > I am not quite sure whether these possible deadlocks are real and how to fix
> > them if they are real.
> > Any feedback would be appreciated, thanks :)
>
> I think these are at least theoretically real, and so we should take
> something like the $subject patch probably. But I don't believe we can
> actually hit this due to the main-loop structure of this driver.
>
> Anyway, see the surrounding patch.
>
> Thanks,
> Brian
>
>
>  drivers/net/wireless/marvell/mwifiex/sta_event.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)

Though I'm by no means an expert on this code and I wrote the patch in
question a long time ago, this seems reasonable to me. Thanks for
fixing.

Reviewed-by: Douglas Anderson <dianders@chromium.org>
