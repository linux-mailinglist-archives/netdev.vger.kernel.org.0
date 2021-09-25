Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2887418504
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 00:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbhIYWpt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 18:45:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbhIYWpt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Sep 2021 18:45:49 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A69A1C061570
        for <netdev@vger.kernel.org>; Sat, 25 Sep 2021 15:44:13 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id u8so56534488lff.9
        for <netdev@vger.kernel.org>; Sat, 25 Sep 2021 15:44:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HQsIqUX6X8OxUoEQPl4MjIP3qqh7oluyrTYL6veznXQ=;
        b=sMo+qRw+OHLfrUcSZkD2OGCLTyYhDpAlPxTlh1ZQ1EcuI4uNjoyr5COsHh3/4fze9v
         lmgIjtRtADNMZtZlyRtZ14IrEDsOh1cI3TQ4gTy8dcg5L8mF4wmbNqFjdDZ//9+7N6hz
         pYBuxdWOZmHX0Rje+kIodqHH93OsvgfaRtBtKRZ6AO+EL0rTPbvTY9cDnVLJft9Va1t5
         o4z2K+3l+0W8MYpTcT/Y1CtgAVZqUdoIiiBMQehYvbkewLocCaRSqDvkoMohrGQeMvXZ
         Ss2xELdlBykuXWnkHBAjDHcph+UjnF6fgLRrvifsKtWRwjaqXmcAWUrM7lJcH3RKsr7U
         nJkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HQsIqUX6X8OxUoEQPl4MjIP3qqh7oluyrTYL6veznXQ=;
        b=yOQ31+fEiQVpO6VQz4ZSBMEYmBnDz0W/CdsfuUJmiHBPnTe+W2mP8X9PVG2ZAAraUB
         6Z26yNQhJMBSJAT4/V0Hsc6azXUymkQb9qjpJxhOiqsQ9xNM1WQow1x2iqgjzk5ZayDu
         YyTh2n1voqcXDLb6sXuFGOSG5/l5fcFGHuAGC/Qc9xYUkHZzMDkdScLu7IGlHa8ACPq9
         vkk6IU9HMj9itrhKtrsH5zxZociJp8DF56tY8W+5EMOLHZHhoquxqc2vUd4qrMHv10eb
         NkN0jzP0sznEOQYqtfvxiQsernCMhiRadW+5TZej3Of6k2DbSiHRiQOl/Ex2xS6nloWg
         zyXA==
X-Gm-Message-State: AOAM532RJE6KjI8hcFvrF6hw02Ordcsw8Jgzwj4vsQK+8qNrxhUNpSkE
        w+flra/ofJFUX8HkpMrlSggHID6E/myeKrTDYFBH3g==
X-Google-Smtp-Source: ABdhPJxm9W2Q+RrZhok/viww7sqKszYrkydaaqR2OKEB4owm5SMTZUvmLVB9UtJSPBqmrceHyXZ3Lgg4V/71YEn9C2I=
X-Received: by 2002:a19:f249:: with SMTP id d9mr17141997lfk.229.1632609851899;
 Sat, 25 Sep 2021 15:44:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210925132311.2040272-1-linus.walleij@linaro.org>
 <20210925132311.2040272-4-linus.walleij@linaro.org> <a4c7ffae-b99a-00ee-6de3-8c7e40ecd286@bang-olufsen.dk>
 <20210925183811.jsq2qps257jeqgmf@skbuf>
In-Reply-To: <20210925183811.jsq2qps257jeqgmf@skbuf>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sun, 26 Sep 2021 00:44:00 +0200
Message-ID: <CACRpkdaP85xKvyRNQw1mThCHg4hUD_avZz9mf7M0svYyq1QJ_w@mail.gmail.com>
Subject: Re: [PATCH net-next 3/6 v6] net: dsa: rtl8366rb: Rewrite weird VLAN
 filering enablement
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Mauri Sandberg <sandberg@mailfence.com>,
        DENG Qingfang <dqfext@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 25, 2021 at 8:38 PM Vladimir Oltean <olteanv@gmail.com> wrote:

> Documentation/networking/switchdev.rst says:

Aha now I get this in context, thanks a lot!

> Anyway, I suppose Linus can make that adjustment after the fact too, if
> everything else is ok in the other patches.

I better get this right and explain it to myself while I still have it
in my head, I'm sending a new version of this patch (the whole
set) that fixes it according to spec (I hope).

Yours,
Linus Walleij
