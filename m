Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 744AE31F0D1
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 21:08:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232238AbhBRUIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 15:08:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231989AbhBRUG6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 15:06:58 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B928EC06178B;
        Thu, 18 Feb 2021 12:06:17 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id s16so1849228plr.9;
        Thu, 18 Feb 2021 12:06:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dMbJmdRaY4vfG00koCsvkPR/U7WAiUX8hNZHDlwWe28=;
        b=YsuE22azdu18HaTMEtOCgZygSoSSxe/L+KLqHQGnitgtAooyq/dMbQrh2WSPSOwVrn
         G8ENzrPqhXaMiT30v+xvukAHiadnP8CWL/Er/IqoLAV/3Z5ulNChCeNv4csJJEdp/tpX
         qTY8hsXpkLTqn4nQAJoGyBN0e1KQb5mvhALIaFjAAEf6BihjuxNwIxRVdfVmUlJzLXdn
         squ/Ein7iMtlEjhliP3u5gw34EECZwaNijX53cCqQD4g+itUX2RcKIjSBySgKikuZSUz
         0DN5iklLyuWA/YmfF54OE+UjuZDtWFzhu33ZgbXa2XrC78UTeVZtSdfOMjtsro4JV8Py
         NCsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dMbJmdRaY4vfG00koCsvkPR/U7WAiUX8hNZHDlwWe28=;
        b=gzj4fzhsuO8gNne6EYzqXr+s0acmlvTSwMTWNPjChX5H4y2qliG8vdNLAUD7yIrqeN
         zHYg0aXySDI09OK4JuSGtm52I7r3NrY6APw5NYcT6dQGxSwdz9VGBC/nFmrWS6qL2xlb
         QRLqi1R7APU5a6LzyqESvvzhrhkdLMqQrNbC10rNI0ED6H+Ljra/+kAtUw9bszUs6xEY
         GtubjDZyFgLHi7NEiKx1LzXlroMzyxkcU/5lmPM7VyNC79/SFuRl3pbzo93fbHFBifxr
         MQuSGLVfjBt/o96WWfNSiZ2HZIjbWN4HWeECBy3frpOWBZbD0YWfYizO/aIy8iQmM4zi
         p2lw==
X-Gm-Message-State: AOAM530wg/dfX5wvrFI0aEC7DnOtzmUkwwCPF2a/bCDJYgjVHzZTdqBw
        ohOdLyMMl4rfsZRZCISAQQEScGgdJYk4Jy/OuUfoFLFX
X-Google-Smtp-Source: ABdhPJwl0xv9E12Ry5xTq6VyT6cp0/yTNTylgtr7DDMZtNiqvPNMrmZbP9U8fAOx04Z+QtvUN+PYpoKUfe2DDk29nlo=
X-Received: by 2002:a17:90b:368a:: with SMTP id mj10mr5568018pjb.210.1613678777210;
 Thu, 18 Feb 2021 12:06:17 -0800 (PST)
MIME-Version: 1.0
References: <20210216201813.60394-1-xie.he.0141@gmail.com> <YC4sB9OCl5mm3JAw@unreal>
 <CAJht_EN2ZO8r-dpou5M4kkg3o3J5mHvM7NdjS8nigRCGyih7mg@mail.gmail.com>
 <YC5DVTHHd6OOs459@unreal> <CAJht_EOhu+Wsv91yDS5dEt+YgSmGsBnkz=igeTLibenAgR=Tew@mail.gmail.com>
 <YC7GHgYfGmL2wVRR@unreal>
In-Reply-To: <YC7GHgYfGmL2wVRR@unreal>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Thu, 18 Feb 2021 12:06:06 -0800
Message-ID: <CAJht_EPZ7rVFd-XD6EQD2VJTDtmZZv0HuZvii+7=yhFgVz68VQ@mail.gmail.com>
Subject: Re: [PATCH net-next RFC v4] net: hdlc_x25: Queue outgoing LAPB frames
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Martin Schiller <ms@dev.tdt.de>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 18, 2021 at 11:55 AM Leon Romanovsky <leon@kernel.org> wrote:
>
> This is how we write code, we use defines instead of constant numbers,
> comments to describe tricky parts and assign already preprocessed result.
>
> There is nothing I can do If you don't like or don't want to use Linux kernel
> style.

So what is your suggestion exactly? Use defines or write comments?

As I understand, you want to replace the "3 - 1" with "2", and then
write comments to explain that this "2" is the result of "3 - 1".

Why do you want to do this? You are doing useless things and you force
readers of this code to think about useless things.

You said this was "Linux kernel style"? Why? Which sentence of the
Linux kernel style guide suggests your way is better than my way?
