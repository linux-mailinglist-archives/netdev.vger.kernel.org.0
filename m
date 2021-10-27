Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C343443D0A6
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 20:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243506AbhJ0S0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 14:26:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239968AbhJ0S0U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 14:26:20 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7766C061745
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 11:23:54 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id h14so2563141qtb.3
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 11:23:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5dU5i2rPAA1rWa1tBZegagA5UHnsbTclU/Hvls+bm6w=;
        b=LnRRS+MmzvGJTLZ4cdjuzpaM79iMGNZvfqRkeBYT+/VV6Zxo3dkTmrRHfLbM2Y/Cw2
         1+b0r9rHhreWhKzLcucFILGrNT9TEqlx0EM0ljZnye2h5Xduc1sS5dWHE1Xk3PzU3B1L
         3RQhu5MNmGTwvqi8CZObzmDLH4GSQbKTFjuwA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5dU5i2rPAA1rWa1tBZegagA5UHnsbTclU/Hvls+bm6w=;
        b=MHkNTs0XRzJoRB01+p6tk2E2UNH4GYTR7ctGuAGSxLeRtfiPxm8z1CRFIB/bvn+P+c
         MD8uZ+Iy/xFh5qok1OqXali3OBSjk65mQBJy/K/t+liBRgyRpOTkbKJHUVPfHQWhAbbv
         t+klV0F/c6HY8odKHI/EgvhwkcqhHuYBIqzo5ajRl7zWlmrnmzKFEKgq/vyuChR7uJ6O
         V/9ta73GXv9CZTQHlwIw/+zg+CmlJO76QtD0un97fzt3duNez7Tq3Fvc6UxWEJQXrgr0
         LMO44TN9iuqFbn93D/0CdSofDxXhUhTVarXD94fa3qt+55WraHmxQYOQp/W/vAqbyGIb
         PRAg==
X-Gm-Message-State: AOAM530FExnEUuSv/6G/QDrqmoQ/X0mkWjHypFJtmiZ4nATo9DnqljBZ
        ARZEo4fq1/ULJwRywMFTNB+rBZCXWE8ysA==
X-Google-Smtp-Source: ABdhPJzUJjRs8qoZy53FtXlYRl/hYtQgt195bHwjTZhRzZxhaRArm88rPpuHXIFoxn8Dz4x1vpAs5Q==
X-Received: by 2002:ac8:5c42:: with SMTP id j2mr1390752qtj.391.1635359033516;
        Wed, 27 Oct 2021 11:23:53 -0700 (PDT)
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com. [209.85.219.181])
        by smtp.gmail.com with ESMTPSA id r18sm620003qkp.12.2021.10.27.11.23.52
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Oct 2021 11:23:52 -0700 (PDT)
Received: by mail-yb1-f181.google.com with SMTP id q74so2701975ybq.11
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 11:23:52 -0700 (PDT)
X-Received: by 2002:a25:b851:: with SMTP id b17mr32814544ybm.301.1635359032208;
 Wed, 27 Oct 2021 11:23:52 -0700 (PDT)
MIME-Version: 1.0
References: <20211026095214.26375-1-johan@kernel.org> <20211026095214.26375-3-johan@kernel.org>
 <CA+ASDXNbMJ1EgPRvosx0AbJgsE-qOiaQjeD=vCEyDLoUQAgkiw@mail.gmail.com> <YXkCVLJrQC7ig31t@hovoldconsulting.com>
In-Reply-To: <YXkCVLJrQC7ig31t@hovoldconsulting.com>
From:   Brian Norris <briannorris@chromium.org>
Date:   Wed, 27 Oct 2021 11:23:41 -0700
X-Gmail-Original-Message-ID: <CA+ASDXPGDOmZgCV01xAAgyOei9sSyNe_VUDWK7pkC_VLs4K8JA@mail.gmail.com>
Message-ID: <CA+ASDXPGDOmZgCV01xAAgyOei9sSyNe_VUDWK7pkC_VLs4K8JA@mail.gmail.com>
Subject: Re: [PATCH 3/3] mwifiex: fix division by zero in fw download path
To:     Johan Hovold <johan@kernel.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Amitkumar Karwar <akarwar@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 27, 2021 at 12:40 AM Johan Hovold <johan@kernel.org> wrote:
> On Tue, Oct 26, 2021 at 10:35:37AM -0700, Brian Norris wrote:
> > Seems like you're missing a changelog and a version number, since
> > you've already sent previous versions of this patch.
>
> Seems like you're confusing me with someone else.

Oops, you're correct :( It was only a week or two ago someone else was
trying to patch this, and I didn't remember the "From" correctly.
Sorry!

> I'll send a v2.

Looks better, thanks.

Brian
