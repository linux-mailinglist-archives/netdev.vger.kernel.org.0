Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE01131BD7
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 23:51:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727308AbgAFWvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 17:51:43 -0500
Received: from mail-qv1-f67.google.com ([209.85.219.67]:44496 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727297AbgAFWvm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 17:51:42 -0500
Received: by mail-qv1-f67.google.com with SMTP id n8so19736579qvg.11
        for <netdev@vger.kernel.org>; Mon, 06 Jan 2020 14:51:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DcDJpyHhT/zuHt9L/g76CdYSvylHBQA1EbFEZdNVtEg=;
        b=d35htZm0gVCK/o7dbN8yxRvxzIEDYFhUfHYTtCUanbQlAQUMbA7D9fJQ7sI+7YkUYI
         fpuj36oPW2PXPysY4rVwdiRH0I2zfeUYPpyYdP1pGpAM2VHM60s2z5fmvIrfO0S+4CcN
         lOApLOvozrkfiXp8w2ciqEbwqOGsPZ9cKipyo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DcDJpyHhT/zuHt9L/g76CdYSvylHBQA1EbFEZdNVtEg=;
        b=oyQwHvuEFnFAVZp2lFWgEhAF4of4OdHgMNsjhcQypLuOjfor+cELeqdyQgiQtxT5Rb
         1L8iDSzPpTCrtmMKVpce/iPo6JMh0dFTpt0EFG/JzkVxHd1AxPKucbXA35sutPoyvl8v
         6h13F/5JrycZWzeZGTbIYEfRe/kZKFHb5SpA8Hubh/4ZNrlCds+dc4VWlZiq21q3hi88
         UEVjhjT3AZkRkI0cee6ziGHZy0rZDYGJGJ3HVFAHTAogdCeYCj58gbI0MX+ZwGG3VodG
         MXqp4Hm9v9KXnfJdL+qI+ofIFyhoG+h6Y1Zu8GyA/Nim94oaK3zdhzu9E7+KD/EYxKrK
         Cbrg==
X-Gm-Message-State: APjAAAXVRFXDNet82d5ocudazA/hQphlDsAts14Oa1Vsht1K/6x4f5kG
        ICXfkElDtqXOYEUkV298RRSL0ULyCSo=
X-Google-Smtp-Source: APXvYqyX31a3GiinbPnj6sWB94xm8Z6f66673ewRcSuQ9GB4VRIRM73DORXVqJHj0Mh/BxnPozr2Bg==
X-Received: by 2002:ad4:4b6d:: with SMTP id m13mr83023631qvx.240.1578351101189;
        Mon, 06 Jan 2020 14:51:41 -0800 (PST)
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com. [209.85.160.181])
        by smtp.gmail.com with ESMTPSA id d51sm21676134qtc.67.2020.01.06.14.51.40
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jan 2020 14:51:40 -0800 (PST)
Received: by mail-qt1-f181.google.com with SMTP id q20so43820892qtp.3
        for <netdev@vger.kernel.org>; Mon, 06 Jan 2020 14:51:40 -0800 (PST)
X-Received: by 2002:ac8:678d:: with SMTP id b13mr67296866qtp.213.1578351099829;
 Mon, 06 Jan 2020 14:51:39 -0800 (PST)
MIME-Version: 1.0
References: <20191227174055.4923-1-sashal@kernel.org> <20191227174055.4923-8-sashal@kernel.org>
In-Reply-To: <20191227174055.4923-8-sashal@kernel.org>
From:   Brian Norris <briannorris@chromium.org>
Date:   Mon, 6 Jan 2020 14:51:28 -0800
X-Gmail-Original-Message-ID: <CA+ASDXM6UvVCDYGq7gMEai_v3d79Pi_ZH=UFs1gfw_pL_BLMJg@mail.gmail.com>
Message-ID: <CA+ASDXM6UvVCDYGq7gMEai_v3d79Pi_ZH=UFs1gfw_pL_BLMJg@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.4 008/187] mwifiex: fix possible heap overflow
 in mwifiex_process_country_ie()
To:     Sasha Levin <sashal@kernel.org>
Cc:     Linux Kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        huangwen <huangwenabc@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 27, 2019 at 9:59 AM Sasha Levin <sashal@kernel.org> wrote:
>
> From: Ganapathi Bhat <gbhat@marvell.com>
>
> [ Upstream commit 3d94a4a8373bf5f45cf5f939e88b8354dbf2311b ]

FYI, this upstream commit has unbalanced locking. I've submitted a
followup here:

[PATCH] mwifiex: fix unbalanced locking in mwifiex_process_country_ie()
https://lkml.kernel.org/linux-wireless/20200106224212.189763-1-briannorris@chromium.org/T/#u
https://patchwork.kernel.org/patch/11320227/

I'd recommend holding off until that gets landed somewhere. (Same for
the AUTOSEL patches sent to other kernel branches.)

Regards,
Brian
