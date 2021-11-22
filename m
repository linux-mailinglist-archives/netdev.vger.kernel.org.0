Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08292459386
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 17:57:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231771AbhKVRA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 12:00:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbhKVRA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 12:00:28 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3CF6C061574;
        Mon, 22 Nov 2021 08:57:21 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id iq11so14314340pjb.3;
        Mon, 22 Nov 2021 08:57:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NAobme2p/Ajnt+G3U/7DiFlRPmisaHsfuClX7nAtobQ=;
        b=lDrzENJsdcjoVHxJUfwI9ZifWeSnhc8r5aFMpp5eDWNnFcWdlijUp+QIEjaQEIL8Ai
         bd6sR4P9JUUmB5p1/j/RszdZdtIK3wG0wnj5DHyLqvPw9NFCz2dQy7HYovSg6V3/A1eP
         9Lo0wWQX0RfAhaEnvZ5I1ES3abhW0tnakI5+rGO7ut+y7n8lkJwmGyC/Fm5U14dNAF2V
         SaGDrpTGttGEEbCJafaGlo73sC/EcqeJdqfc5vnBDcRGrt4X5I53I00AKDtJdzydlH8N
         Y78+ov8AfrgQjt2M7PGyhjXlW3WMlsMIOb4acW6kqPDrd7bXRt3OK6fuVm/v99h9RFta
         g1DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NAobme2p/Ajnt+G3U/7DiFlRPmisaHsfuClX7nAtobQ=;
        b=3y5D38KtIeA6UzReRvkSGVuVNHiXJaYtqLOlNF3ZJcFY3UjVZhYAePrZSvgegpSUyL
         fTJjW0lktKhNutfnIKvb5fmeqSJc3HonrPVAjIXpH/9CH8kOASaeoPD/WGO/mZsUuMii
         KOI/oMZ2/EeSA+PZFfYmt8RkWhSu5ndP0nLXEPqitMk9YQx/By3rNnBqkXWh898opSXn
         5AyN9lrEPMOnzxaETwtwwylxpE4WtMPfjLjfCIPS6wj9dOTuGg/0OivqKWpwjsKmwoC7
         NuL/ootR9tuLP3XTM0YvPzNOnLMvg8zCrpOp9TvfhiDQFWzAppIn9kIo1kkD1nYdgGxt
         jVvQ==
X-Gm-Message-State: AOAM5313uP6IsyaB5iM1UcRuOZnz615TXLyRgzCbcbgM3WvrESd0mPhR
        FYogeMaWDjL6qXharIi/ekcVv75fdTmHOFmJFq1XG6lroK8=
X-Google-Smtp-Source: ABdhPJzpa0fB0JCqEyHaGHfnvwjuHBEt/iZwtORb59FC1MCOXXvrcsknpp2i2+rfaWa3umuI2wRb9D2UXU9GNhC4iPk=
X-Received: by 2002:a17:902:be06:b0:142:5a21:9e8a with SMTP id
 r6-20020a170902be0600b001425a219e8amr109416661pls.17.1637600241267; Mon, 22
 Nov 2021 08:57:21 -0800 (PST)
MIME-Version: 1.0
References: <20211122142456.181724-1-atenart@kernel.org>
In-Reply-To: <20211122142456.181724-1-atenart@kernel.org>
From:   Jonathon Reinhart <jonathon.reinhart@gmail.com>
Date:   Mon, 22 Nov 2021 11:56:55 -0500
Message-ID: <CAPFHKzcph=MiDWgiZ2TLAZukARsL1wi2FGAfLQ2MX_T+oe4KyQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2] sections: global data can be in .bss
To:     Antoine Tenart <atenart@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, arnd@arndb.de,
        Linux Netdev List <netdev@vger.kernel.org>,
        linux-arch@vger.kernel.org, tglx@linutronix.de,
        peterz@infradead.org, Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 22, 2021 at 9:24 AM Antoine Tenart <atenart@kernel.org> wrote:
>
> When checking an address is located in a global data section also check
> for the .bss section as global variables initialized to 0 can be in
> there (-fzero-initialized-in-bss).
>
> This was found when looking at ensure_safe_net_sysctl which was failing
> to detect non-init sysctl pointing to a global data section when the
> data was in the .bss section.
>
> Signed-off-by: Antoine Tenart <atenart@kernel.org>
> Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

Co-Developed-by: Jonathon Reinhart <jonathon.reinhart@gmail.com>
Signed-off-by: Jonathon Reinhart <jonathon.reinhart@gmail.com>

> ---
>
> A few remarks:
>
> - This still targets net-next but I added Arnd if he prefers to take it
>   through the 'asm-generic' tree, now that is_kernel_core_data is in
>   include/asm-generic/.
>
> - I kept the Acked-by tag as the change is the same really, the
>   difference is the core_kernel_data function was renamed to
>   is_kernel_core_data and moved since then.
>
> - @Jonathon: with your analysis and suggestion I think you should be
>   listed as a co-developer. If that's fine please say so, and reply
>   with both a Co-developed-by and a Signed-off-by tags.

Added, thanks. Although it appears I may have missed the boat.
