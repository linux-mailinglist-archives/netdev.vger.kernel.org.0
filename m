Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 620D62C906F
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 23:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727590AbgK3WBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 17:01:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbgK3WBG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 17:01:06 -0500
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 446B6C0613D2
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 14:00:26 -0800 (PST)
Received: by mail-il1-x141.google.com with SMTP id w8so12860109ilg.12
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 14:00:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LJ9SjJ/0B20ZhgHvkLEch2PuIF7bGKLEueO/TBLcBNo=;
        b=tWMcoD8OcJA6WQfz7VRy+5b+7/YzAwShqglstVoZfC0lJF3nFdXP5Ye5CcDZhZCifg
         oEjp86VhOiKr1/10iGNP3U54KqDYetEkGr4LrYJ+1oh30phkAV1hk10Ucs2PNElYcVWC
         SkR1HQh4esDpgm9c74fLfCy/pYxF1rn3ECE48HjymAlh42s7cZB4W8t57bY0MwbzLagd
         WRSgyH2UZWyIj2VIq/lKn3u6xckoLLxFnNTLO0gdP7IYhpRxCd+yk+norr2CkUqQi6se
         nPpfSwMTsPcuc0RnLjhQKJ/XlSWdeZIA9xc/hwoJqSppmwAXxZyxOC1BeOAVbC+MWwjQ
         Eo9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LJ9SjJ/0B20ZhgHvkLEch2PuIF7bGKLEueO/TBLcBNo=;
        b=W/zP+QTX7AO/a1gCFYjoN5We0LnsrPiQWwY3HPe5dOOktm8bDoiuKZxpftkTxwjr1s
         X6fYMvCF7s8Tq9wpKe4s4EVzJ6ZgBOo9TVuXsjw9kaUouM5lnoZUswQdZ+dlSNKnikCJ
         FsLI7hIMU+qtoT0FMdZyPUAdVELBIWtxnsANJY+oLVXhgWwhlyryydSdWVHPwQpcHeQa
         WhywoI4Cqud4njwO9cOoGJFgwhtbadtP6DpWKzq6KoaNFUSlsQNQjxAVyknHr1uQITNI
         9rIG/UaLFfL4gAmkoY2BdB1JCYrgrw8rqXpDnIiShhKB1fDSJnKigrMdjRXZuR4W23DT
         +Ffw==
X-Gm-Message-State: AOAM531IkfheU2bcMC8AqsJylHD9tjT5gY/C6RRF3txKQy7wm5vpBe9i
        x497Xkw6MIF23Uc4iDrd2aFxJcDzV5nh/qPx8qs=
X-Google-Smtp-Source: ABdhPJwqF+w2CSgBhdGV+TFE2dm8r4kYsra8znUTmV/jJf+Z4JmJm2VxoXntGgi5/DwihXFI1Cs0BJPzRDCBKJ2l9qU=
X-Received: by 2002:a92:aacc:: with SMTP id p73mr20499921ill.64.1606773625369;
 Mon, 30 Nov 2020 14:00:25 -0800 (PST)
MIME-Version: 1.0
References: <20201130212907.320677-1-anthony.l.nguyen@intel.com> <20201130212907.320677-2-anthony.l.nguyen@intel.com>
In-Reply-To: <20201130212907.320677-2-anthony.l.nguyen@intel.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 30 Nov 2020 14:00:14 -0800
Message-ID: <CAKgT0Uf7BoQ5DAWD8V7vhRZfRZCEBxc_X4Wn35mYEvMPSq-EaQ@mail.gmail.com>
Subject: Re: [net-next 1/4] e1000e: allow turning s0ix flows on for systems
 with ME
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mario Limonciello <mario.limonciello@dell.com>,
        Netdev <netdev@vger.kernel.org>,
        Stefan Assmann <sassmann@redhat.com>,
        "Neftin, Sasha" <sasha.neftin@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 30, 2020 at 1:32 PM Tony Nguyen <anthony.l.nguyen@intel.com> wrote:
>
> From: Mario Limonciello <mario.limonciello@dell.com>
>
> S0ix for GBE flows are needed for allowing the system to get into deepest
> power state, but these require coordination of components outside of
> control of Linux kernel.  For systems that have confirmed to coordinate
> this properly, allow turning on the s0ix flows at load time or runtime.
>
> Fixes: e086ba2fccda ("e1000e: disable s0ix entry and exit flows for ME systems")
> Signed-off-by: Mario Limonciello <mario.limonciello@dell.com>
> Tested-by: Aaron Brown <aaron.f.brown@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  .../device_drivers/ethernet/intel/e1000e.rst  |  23 ++++
>  drivers/net/ethernet/intel/e1000e/e1000.h     |   7 ++
>  drivers/net/ethernet/intel/e1000e/netdev.c    |  64 +++++-----
>  drivers/net/ethernet/intel/e1000e/param.c     | 110 ++++++++++++++++++
>  4 files changed, 166 insertions(+), 38 deletions(-)
>
> diff --git a/Documentation/networking/device_drivers/ethernet/intel/e1000e.rst b/Documentation/networking/device_drivers/ethernet/intel/e1000e.rst
> index f49cd370e7bf..da029b703573 100644
> --- a/Documentation/networking/device_drivers/ethernet/intel/e1000e.rst
> +++ b/Documentation/networking/device_drivers/ethernet/intel/e1000e.rst
> @@ -249,6 +249,29 @@ Debug
>
>  This parameter adjusts the level of debug messages displayed in the system logs.
>
> +EnableS0ix
> +----------
> +:Valid Range: 0, 1, 2
> +:Default Value: 1 (Use Heuristics)
> +
> +   +-------+----------------+
> +   | Value |    EnableS0ix  |
> +   +=======+================+
> +   |   0   |    Disabled    |
> +   +-------+----------------+
> +   |   1   | Use Heuristics |
> +   +-------+----------------+
> +   |   2   |    Enabled     |
> +   +-------+----------------+
> +
> +Controls whether the e1000e driver will attempt s0ix flows.  S0ix flows require
> +correct platform configuration. By default the e1000e driver will use some heuristics
> +to decide whether to enable s0ix.  This parameter can be used to override heuristics.
> +
> +Additionally a sysfs file "enable_s0ix" will be present that can change the value at
> +runtime.
> +
> +Note: This option is only effective on Cannon Point or later hardware.
>
>  Additional Features and Configurations
>  ======================================

Generally the use of module parameters and sysfs usage are frowned
upon. Based on the configuration isn't this something that could just
be controlled via an ethtool priv flag? Couldn't you just have this
default to whatever the heuristics decide at probe on and then support
enabling/disabling it via the priv flag? You could look at
igb_get_priv_flags/igb_set_priv_flags for an example of how to do what
I am proposing.

I think it would simplify this quite a bit since you wouldn't have to
implement sysfs show/store operations for the value and would instead
be allowing for reading/setting via the get_priv_flags/set_priv_flags
operations. In addition you could leave the code for checking what
supports this in place and have it set a flag that can be read or
overwritten.
