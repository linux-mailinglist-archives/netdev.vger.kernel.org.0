Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A76FC2BB7F6
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 21:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729885AbgKTUxl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 15:53:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729541AbgKTUxl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 15:53:41 -0500
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B6C2C061A04
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 12:53:40 -0800 (PST)
Received: by mail-oi1-x243.google.com with SMTP id s18so10791998oih.1
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 12:53:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Tm5oQGDIWj52Bp56wXe66Os4mWl35FpTbKVQbQHjiA0=;
        b=Q/ayshPw7MqVSNseI330O4AYlTJ4Xssc3g4VnY0j0IDdzFMEowMylO8koqPB01IYI9
         t6ZFW87UdnQlfA0XS8AhgxB6uQ4CUOIKV+qklIG+JulBiVk0DopsABcifPjKvwZEFQyd
         pMDL9hBMf8V10ABQl6nxC7VrDcQcLsUU+xZeM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Tm5oQGDIWj52Bp56wXe66Os4mWl35FpTbKVQbQHjiA0=;
        b=kVfZFuAdhgvmNn54LdQx05bgTPghUV49KrX4Uq7gcwjjPh8o1uGjxClJchTAi1MIcu
         bWdGZi4MMjC7rA1iWYkPuDdKrEIhQrKzT6pLgq8KDjJpzTAL1XpXNndRa4eMafRgPAwg
         9WbWbgXEoEfDkiPeSJq4ZK9KShZaUgC7UrORCbRE5rznYhOGHaSNKHh61wivxDcA3Xrp
         FyOyaWBOHvVnl7yu5JbjcObr7EmOq/QTmzw8k7wCXwgqjB+3zHRKyQoCq5lCQLMWvu0t
         0vMZS6bjtKoBdsyziGpvV6E4WXLDiYdsR3s5/uM0rtnJbv74Ga4QE5Ou7wj+6vKFDLRU
         psUQ==
X-Gm-Message-State: AOAM530aQGJjDB34WXdO6iEGF6YBRkKrQyXTcpge9Jt2T0jaoIpWdQfs
        sPpjgJhl9mqBJDA+3wKPlc6wFQP464skSA==
X-Google-Smtp-Source: ABdhPJxUQAOjrgbPaygG1TE7u68onizVxuddBoVn7b5vLosR336wueDFz6trVyop82NTcE2LlQuyKw==
X-Received: by 2002:aca:b8c3:: with SMTP id i186mr3692876oif.78.1605905618338;
        Fri, 20 Nov 2020 12:53:38 -0800 (PST)
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com. [209.85.210.46])
        by smtp.gmail.com with ESMTPSA id o63sm2168188ooa.10.2020.11.20.12.53.35
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Nov 2020 12:53:36 -0800 (PST)
Received: by mail-ot1-f46.google.com with SMTP id k3so9987626otp.12
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 12:53:35 -0800 (PST)
X-Received: by 2002:a05:6830:1291:: with SMTP id z17mr15586229otp.229.1605905615285;
 Fri, 20 Nov 2020 12:53:35 -0800 (PST)
MIME-Version: 1.0
References: <20201028142625.18642-1-kitakar@gmail.com> <CA+ASDXPX+fadTKLnxNVZQ0CehsHNwvWHXEdLqZVDoQ6hf6Wp8Q@mail.gmail.com>
 <7db5b6cba1548308a63855ec1dda836b6d6d9757.camel@gmail.com>
In-Reply-To: <7db5b6cba1548308a63855ec1dda836b6d6d9757.camel@gmail.com>
From:   Brian Norris <briannorris@chromium.org>
Date:   Fri, 20 Nov 2020 12:53:23 -0800
X-Gmail-Original-Message-ID: <CA+ASDXNPcXtTWS8pOjfoxiYOAcRMmsqZwXe3mnxOw388MCEu9g@mail.gmail.com>
Message-ID: <CA+ASDXNPcXtTWS8pOjfoxiYOAcRMmsqZwXe3mnxOw388MCEu9g@mail.gmail.com>
Subject: Re: [PATCH] mwifiex: pcie: add enable_device_dump module parameter
To:     Tsuchiya Yuto <kitakar@gmail.com>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@intel.com>, verdre@v0yd.nl
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(Sorry if anything's a bit slow here. I don't really have time to
write out full proposals myself.)

On Fri, Oct 30, 2020 at 3:30 AM Tsuchiya Yuto <kitakar@gmail.com> wrote:
> Let me know if splitting this patch like this works. 1) The first patch
> is to add this module parameter but don't change the default behavior.

That *could* be OK with me, although it's already been said that there
are many people who dislike extra module parameters. I also don't see
why this needs to be a module parameter at all. If you do #2 right,
you don't really need this, as there are already several standard ways
of doing this (e.g., via Kconfig, or via nl80211 on a per-device
basis).

> 2) The second patch is to change the parameter value depending on the
> DMI matching or something so that it doesn't break the existing users.

Point 2 sounds good, and this is the key point. Note that you can do
point 2 without making it a module parameter. Just keep a flag in the
driver-private structures.

> But what I want to say here as well is that, if the firmware can be fixed,
> we don't need a patch like this.

Sure. That's also where we don't necessarily need more ways to control
this from user space (e.g., module parameters), but just better
detection of currently broken systems (in the driver). And if firmware
ever gets fixed, we can undo the "broken device" detection.

Brian
