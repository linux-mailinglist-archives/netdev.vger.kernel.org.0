Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C36C23DE0EE
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 22:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231623AbhHBUpG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 16:45:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231397AbhHBUpF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 16:45:05 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57B21C061760
        for <netdev@vger.kernel.org>; Mon,  2 Aug 2021 13:44:55 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id u10so25626883oiw.4
        for <netdev@vger.kernel.org>; Mon, 02 Aug 2021 13:44:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=65+jrHTcPSfFspE6Vmz1rG6EbI2IG4N74S4TbLrG0m8=;
        b=mCf0e2Lw9a6KuAQ+ZhulAC0ymPq0TDdch4DN3/auqE25liVUTinAcAS6LhwatQKPaG
         HwtzYcBe81X21EhGCDb5qs6Ket6QO8PfYzGJ9epPepL0ctuCeMEhErF8IYOLkuWDEh89
         umliBVP8PgM06YcQ12ynXmnjC0Vb/bNtSm22Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=65+jrHTcPSfFspE6Vmz1rG6EbI2IG4N74S4TbLrG0m8=;
        b=gzpoDU7u8OEBmCpRXUiMa8wFEJV69ZfH7ywr0oKV9unN+QAXYGGWRhHoDKALXL4Aux
         kSEED7fLw+ejrAm69suI3OiJHZtTlVZnjsQscYw5fGDYJRxQ5Go9eAQoKrXe80GWqWgt
         koVSlY6jNfFCimer9PDJIkF7ss43Ox9+LKRLsBZCZRDwnMi5dnPF8Zs9pCIx4tdHMbmc
         9NOxneiAldhJnMFWURmj/XyFjRsPbUuN8y6YrylzNrQDv4MWVURPly+XKBNgx0MOcIEd
         nvfYQv7279OkIGAf62zFHmzwgg8+LeSfflDspPG9NW7/7MzjSCmp3kpkRrHNR6CZSwE2
         NW/g==
X-Gm-Message-State: AOAM530mECg/C2nOblmfBtEluzxXFvs/hq2f/+lKxBjrBTYpVDP/uXEZ
        aI8gwyO8u9ulQaDFNmzY+dg2U/DFjRAHJg==
X-Google-Smtp-Source: ABdhPJzqbNDHB/bjaOsucY90rBH6MBFQjYMIvUJvJlmYysw4dZusLhmT4On12HksRXKxNu+ucIcpGQ==
X-Received: by 2002:a05:6808:180a:: with SMTP id bh10mr641840oib.147.1627937094336;
        Mon, 02 Aug 2021 13:44:54 -0700 (PDT)
Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com. [209.85.161.44])
        by smtp.gmail.com with ESMTPSA id n20sm2121110otj.11.2021.08.02.13.44.53
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Aug 2021 13:44:53 -0700 (PDT)
Received: by mail-oo1-f44.google.com with SMTP id s21-20020a4ae5550000b02902667598672bso4704000oot.12
        for <netdev@vger.kernel.org>; Mon, 02 Aug 2021 13:44:53 -0700 (PDT)
X-Received: by 2002:a4a:d6c2:: with SMTP id j2mr12299774oot.66.1627937092774;
 Mon, 02 Aug 2021 13:44:52 -0700 (PDT)
MIME-Version: 1.0
References: <968036b8-df27-3f22-074b-3aeed7c7bbf2@gmail.com>
In-Reply-To: <968036b8-df27-3f22-074b-3aeed7c7bbf2@gmail.com>
From:   Brian Norris <briannorris@chromium.org>
Date:   Mon, 2 Aug 2021 13:44:41 -0700
X-Gmail-Original-Message-ID: <CA+ASDXPYbCFsu0zoTafgc3atHvK1TAx=S_NTkfb0UNtKwuZOZQ@mail.gmail.com>
Message-ID: <CA+ASDXPYbCFsu0zoTafgc3atHvK1TAx=S_NTkfb0UNtKwuZOZQ@mail.gmail.com>
Subject: Re: [BUG] mwifiex: possible null-pointer dereference in mwifiex_dnld_cmd_to_fw()
To:     Li Tuo <islituo@gmail.com>
Cc:     amit karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        baijiaju1990@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, Jul 30, 2021 at 9:13 PM Li Tuo <islituo@gmail.com> wrote:
> Our static analysis tool finds a possible null-pointer dereference in
> the mwifiex driver in Linux 5.14.0-rc3:

Wouldn't be the first time a static analysis tool tripped up over
excessively redundant "safety" checks :)

For example:
https://lore.kernel.org/linux-wireless/20210731163546.10753-1-len.baker@gmx.com/T/#u

> The variable cmd_node->cmd_skb->data is assigned to the variable
> host_cmd, and host_cmd is checked in:
> 190:    if (host_cmd == NULL || host_cmd->size == 0)
>
> This indicates that host_cmd can be NULL.
> If so, the function mwifiex_recycle_cmd_node() will be called with the
> argument cmd_node:
> 196:    mwifiex_recycle_cmd_node(adapter, cmd_node);
>
> In this called function, the variable cmd_node->cmd_skb->data is
> assigned to the variable host_cmd, too.
> Thus the variable host_cmd in the function mwifiex_recycle_cmd_node()
> can be also NULL.
> However, it is dereferenced when calling le16_to_cpu():
> 144:    le16_to_cpu(host_cmd->command)
>
> I am not quite sure whether this possible null-pointer dereference is
> real and how to fix it if it is real.
> Any feedback would be appreciated, thanks!

I doubt it's real; the NULL check is probably excessive. I don't think
there's any case in which such skb's will have no ->data. If you're
interested, you could test and submit a "fix" to drop the excess
check.

Brian
