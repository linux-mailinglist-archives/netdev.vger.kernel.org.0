Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2B329E035
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 02:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730110AbgJ2BLu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 21:11:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729861AbgJ1WFL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:05:11 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05ED6C0613CF
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 15:05:11 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id 23so894740ljv.7
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 15:05:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6RgMxKcrxfWcCrPGpUNDV3hziCJkG59Qu7/5cCUuIBQ=;
        b=IyTD+Hke82m6aRlezzLOka0h4MepZinimVyEYyRZqSWlegMfn0lYc8H/2OUV8yMtSq
         tMzhUkYkKnHUX8dcuDZIbjXEUAObRpf/BEeMw+pgRYZiIMJ96queOmywsDyVJ5OxWOxr
         HEl8PS8ayrpRyfa9dqdJZlbekwaI2p8yDlWxM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6RgMxKcrxfWcCrPGpUNDV3hziCJkG59Qu7/5cCUuIBQ=;
        b=BnKB6du06gbGoZ0bKkMw27vwFaAN2EEp1dw2aODgbpUpsx5ku77/+nx88rYe+0IqvD
         BVoQ3/GfVL8KxFoHsVxDJJy43mf7ctzjC4ffKh031eL1yEoQQm4jtl03GgxCzVR6LMPw
         qlfO4VqrLBYoEda+ocWaWFA3+TvIZbwJDlvfApdAUjWcnIkS8APrngMWThWrAxd7o7Ye
         dB9IpDNJrpEfZ9QAIXd3rjADe8Xk4BcERZaFl6vcGKkVPqrItJ38jl8oJfqGKpkRTVR0
         Mb6FC73BhKu+tDYxZL/ZOxQktXWU/GBBkdr2q9/sMcX9kP/A2lt9qNHV7r3HEDyRgS9Q
         0xbg==
X-Gm-Message-State: AOAM532UL08FKEXxP0+dsVkqe/ssQDhAwFbp5qP6CyqCBR4LeQC1Rd1E
        yEQN9NFH8szIXfi5dFn8qgqQ06kh8d5otg==
X-Google-Smtp-Source: ABdhPJyjivtTeadSmcyE8s59P1u37MYwEFhVpgsgiGMMKPFvSWLeZ2R2PzbtbHKSSACuuY+0hbsuJg==
X-Received: by 2002:a2e:9dd1:: with SMTP id x17mr463312ljj.219.1603922708907;
        Wed, 28 Oct 2020 15:05:08 -0700 (PDT)
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com. [209.85.167.53])
        by smtp.gmail.com with ESMTPSA id 27sm81038lfy.109.2020.10.28.15.05.07
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2020 15:05:07 -0700 (PDT)
Received: by mail-lf1-f53.google.com with SMTP id i6so788222lfd.1
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 15:05:07 -0700 (PDT)
X-Received: by 2002:ac2:4d03:: with SMTP id r3mr450997lfi.89.1603922707215;
 Wed, 28 Oct 2020 15:05:07 -0700 (PDT)
MIME-Version: 1.0
References: <20201028142433.18501-1-kitakar@gmail.com> <20201028142433.18501-3-kitakar@gmail.com>
In-Reply-To: <20201028142433.18501-3-kitakar@gmail.com>
From:   Brian Norris <briannorris@chromium.org>
Date:   Wed, 28 Oct 2020 15:04:55 -0700
X-Gmail-Original-Message-ID: <CA+ASDXMXoyOr9oHBjtXZ1w9XxDggv+=XS4nwn0qKWCHQ3kybdw@mail.gmail.com>
Message-ID: <CA+ASDXMXoyOr9oHBjtXZ1w9XxDggv+=XS4nwn0qKWCHQ3kybdw@mail.gmail.com>
Subject: Re: [PATCH 2/3] mwifiex: add allow_ps_mode module parameter
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

On Wed, Oct 28, 2020 at 2:56 PM Tsuchiya Yuto <kitakar@gmail.com> wrote:
>
> To make the ps_mode (power_save) control easier, this commit adds a new
> module parameter allow_ps_mode and set it false (disallowed) by default.

This sounds like a bad idea, as it breaks all the existing users who
expect this feature to be allowed. Seems like you should flip the
defaults. Without some better justification, NACK.

Also, I can't find the other 2 patches in this alleged series. Maybe
they're still making it through the mailing lists and archives.

Brian

> When this parameter is set to false, changing the power_save mode will
> be disallowed like the following:
>
>     $ sudo iw dev mlan0 set power_save on
>     command failed: Operation not permitted (-1)
>
> Signed-off-by: Tsuchiya Yuto <kitakar@gmail.com>
