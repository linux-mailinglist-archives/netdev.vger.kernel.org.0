Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C83C47A20E
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 21:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236525AbhLSU2R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Dec 2021 15:28:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbhLSU2Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Dec 2021 15:28:16 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CFE9C061574
        for <netdev@vger.kernel.org>; Sun, 19 Dec 2021 12:28:16 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id n8so6471742plf.4
        for <netdev@vger.kernel.org>; Sun, 19 Dec 2021 12:28:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2hd8grfKA8Roj/EoP2XsZH6ibAWZRXthUWmzOTcb/cY=;
        b=nD/lvI+oLry5SDMZmYUUZg677651aOiYAlF2k04tJCPoh7j60GA0SAzlyzLDIi7eeG
         Xmo+4kz2NVV/8VKhQdtfj6+QH1W8xK1iqO/wLOzYIRFIdNCfzI4DXepPqdn0i6nqIGNk
         wl28lrn9NCS98oovc/1sKfAMRSJv9JPPzUjRh7nfLbEPANi+K9KNiEwZVdIgr4zMK2Jf
         4VNwEqRbITzzlq/RUph+/VU0fvXcL+FywMaj/2L0Fev7dBA1d4qXdCFPcAoB+dvTuGly
         DwC6bnhkDwUqhuYdhjylOncoYp0jbPR0027KleOMN4qu3XojVV7FZxWG67Z92pXQ7V97
         ZHsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2hd8grfKA8Roj/EoP2XsZH6ibAWZRXthUWmzOTcb/cY=;
        b=H/XxHq/Q063tNTAu8h8nPfz/bJIklquaGIP5ixxqeAz/f+Y+dCp//NFLp45l2jTbg1
         347nFiF5rR9KE1UZlnm8RMdt9oL/8KUXYBeNoHJF3YYtK0QSAIGrBlX524yYdhUwh5Hc
         DFnYlkyujUP/95FoyNQlY2NbEch4p+9ZjYT2c81+jRCBTQdTx8u3hupu7eBiZwIakQx5
         Ll0soDIjbCLg3kD4Ot3ijoTWA060B6yx4tGL/7kDR835Da+PUmYxMuHdTaSub5a1vgtx
         rEc2J1rJOjbLHQUyoZp4qxD+RbtHhJv7ku/tj7StdTG3/6EAfwotS5dfWJUsYtXPQsP0
         B7jw==
X-Gm-Message-State: AOAM5311Swr5OtHjca+EnAiXDooGeflaaNtyLhyaI8euoONjWQDUZbUc
        jsWVKT1htiy7cHFQCGUUkRiggzcenGyzrYvxhQQ=
X-Google-Smtp-Source: ABdhPJzegPrpEHqQjYXUD0LIRA3ooqEFJ3kRuD8kcoeyE+qWr+QOaalziwnQqsRAlvL6rGx1MrevZOgeqpWYX72clro=
X-Received: by 2002:a17:90a:f405:: with SMTP id ch5mr23230279pjb.32.1639945695840;
 Sun, 19 Dec 2021 12:28:15 -0800 (PST)
MIME-Version: 1.0
References: <20211216201342.25587-1-luizluca@gmail.com> <20211216201342.25587-12-luizluca@gmail.com>
 <47a7ad5b-aa12-1eb9-2556-a00793d01181@gmail.com>
In-Reply-To: <47a7ad5b-aa12-1eb9-2556-a00793d01181@gmail.com>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Sun, 19 Dec 2021 17:28:04 -0300
Message-ID: <CAJq09z4FGL43rr3TAxVXvFzFuuctRymdJb-0srZijebM-=KGLQ@mail.gmail.com>
Subject: Re: [PATCH net-next 11/13] net: dsa: realtek: rtl8367c: use
 GENMASK(n-1,0) instead of BIT(n)-1
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>, vivien.didelot@gmail.com,
        olteanv@gmail.com,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>
> Missing spaces between priv->num_ports, and -1 here, and the comma
> before 0 as well:
>                 mb->port_mask = GENMASK(priv->num_ports - 1, 0);
>
> is what we would expect to see.

v2 fixed that. Did I mess with v2 submission?

https://patchwork.kernel.org/project/netdevbpf/patch/20211218081425.18722-11-luizluca@gmail.com/

> --
> Florian
