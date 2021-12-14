Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4A9E473CE8
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 07:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbhLNGDx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 01:03:53 -0500
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:44608
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230196AbhLNGDw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 01:03:52 -0500
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 826FA3F1D7
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 06:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1639461831;
        bh=WL9VjCk8gKCYRWvjUSeuXNo5gRaGFyR5coWlvQxj9dA=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=qZnVIlhvkExRsJxNOmi4AalgKQofSs20yrkPleGuW4/gcM0+WSgo9u4OXrnzxFNP+
         6tDLd71TPJulci6BRXWEbw7lpLTqXn/pXkyqHsgbE7cQLFnRM6bFCjbK1UfpGhW3X0
         Ijo2bqrq4QiEolNJWuG9FzPxiIN3f5KRHhtzUTEDUp2gFpoARhMqVYhXhJsVLkRIVC
         755dkTLv91YaFoWjX90w39nKuE2IiVO3NnYfHe5tabvIU+ETKDrs5U31kkDIPGCrxt
         GA7O1WLC9daYwXAxV49dcfBckEi3qm0Qvzoqk7YSPn3etuzqCwGIwAGOmmz8kXkozS
         73+auCkkFECow==
Received: by mail-oi1-f197.google.com with SMTP id n4-20020acabd04000000b002a28d888c48so12321905oif.9
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 22:03:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WL9VjCk8gKCYRWvjUSeuXNo5gRaGFyR5coWlvQxj9dA=;
        b=OAKv900B6GGgiOnD64hW4xRqjG6qrHP51rC87myu0xFl7dv65vZNvheFKENixHFSt2
         DAMyTDS5vb/XeUjB5yy+wk2NSHNv0nynDhKxz6DNaSe32bLhdcYkU4Xm27jxSeCpZWGj
         ac6aNXjO0uuPJ98yNaFQaY5OigD0FY2v1iEnRzIeQnEtZoZccMPelh7zfiNREfAHKIkk
         h3nivvL443Q4eF1fbVo8iWAfGLzBTQtIX1Vtfss9Td/HsIiReeuxwvCBYp0IE2x32PYA
         /3uwU8EvOxuJGU7kSpB5ilkDfllUqPDeVuHAUJ4f65x4sFTCkY/y5YUkXefl6+ImITjR
         2XfQ==
X-Gm-Message-State: AOAM5325OLzskJoN7uHX6amjbIJaCqwXjcdoMDau8J8KCTOL7yMSfyiD
        WAh/ExYcvOWzlm7c5apJCRT+igo7FNtwlzguJxQojQ/dQmi3xTMEDIpHkBHGdcxU6ggeDM7sPGk
        ofSRMai0QQi/IH4R0dMAmyKDwjhPbQXigaBr17eiJdfqsrInoMw==
X-Received: by 2002:a05:6808:199c:: with SMTP id bj28mr32514055oib.98.1639461830407;
        Mon, 13 Dec 2021 22:03:50 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxQiPiixM9RSi+NUpDxh/HasGW+Yuj7rq8GDGN14tmgm1XRQz4dAKdr2QTqTZbeWJcCpX/bCTqbYZQUKb2+2KA=
X-Received: by 2002:a05:6808:199c:: with SMTP id bj28mr32514034oib.98.1639461830205;
 Mon, 13 Dec 2021 22:03:50 -0800 (PST)
MIME-Version: 1.0
References: <20211214053302.242222-1-kai.heng.feng@canonical.com> <874k7bkabi.fsf@codeaurora.org>
In-Reply-To: <874k7bkabi.fsf@codeaurora.org>
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Date:   Tue, 14 Dec 2021 14:03:39 +0800
Message-ID: <CAAd53p5KRufZLSCX6Z5LwiyD87rPy=+34Lnh1VNQfVT_i6tRvg@mail.gmail.com>
Subject: Re: [PATCH v2] rtw88: Disable PCIe ASPM while doing NAPI poll on 8821CE
To:     Kalle Valo <kvalo@kernel.org>
Cc:     tony0620emma@gmail.com, pkshih@realtek.com, jhp@endlessos.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Po-Hao Huang <phhuang@realtek.com>,
        Brian Norris <briannorris@chromium.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 14, 2021 at 1:46 PM Kalle Valo <kvalo@kernel.org> wrote:
>
> Kai-Heng Feng <kai.heng.feng@canonical.com> writes:
>
> > Many Intel based platforms face system random freeze after commit
> > 9e2fd29864c5 ("rtw88: add napi support").
> >
> > The commit itself shouldn't be the culprit. My guess is that the 8821CE
> > only leaves ASPM L1 for a short period when IRQ is raised. Since IRQ is
> > masked during NAPI polling, the PCIe link stays at L1 and makes RX DMA
> > extremely slow. Eventually the RX ring becomes messed up:
> > [ 1133.194697] rtw_8821ce 0000:02:00.0: pci bus timeout, check dma status
> >
> > Since the 8821CE hardware may fail to leave ASPM L1, manually do it in
> > the driver to resolve the issue.
> >
> > Fixes: 9e2fd29864c5 ("rtw88: add napi support")
> > Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=215131
> > BugLink: https://bugs.launchpad.net/bugs/1927808
> > Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
>
> [...]
>
> >  static bool rtw_disable_msi;
> >  static bool rtw_pci_disable_aspm;
> > +static int rtw_rx_aspm = -1;
> >  module_param_named(disable_msi, rtw_disable_msi, bool, 0644);
> >  module_param_named(disable_aspm, rtw_pci_disable_aspm, bool, 0644);
> > +module_param_named(rx_aspm, rtw_rx_aspm, int, 0444);
> >  MODULE_PARM_DESC(disable_msi, "Set Y to disable MSI interrupt support");
> >  MODULE_PARM_DESC(disable_aspm, "Set Y to disable PCI ASPM support");
> > +MODULE_PARM_DESC(rx_aspm, "Use PCIe ASPM for RX (0=disable, 1=enable, -1=default)")
>
> We already have disable_aspm parameter, why do we need yet another one?
> There's a high bar for new module parameters.

It's a good way for (un)affected users to try out different settings.
But yes the parameter isn't necessary. Let me send another version without it.

Kai-Heng

>
> --
> https://patchwork.kernel.org/project/linux-wireless/list/
>
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
