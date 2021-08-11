Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7798F3E9288
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 15:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231756AbhHKNZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 09:25:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231740AbhHKNZB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 09:25:01 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34D35C061765
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 06:24:35 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id g13so5626092lfj.12
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 06:24:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Hepg0rNNghmUr1sfvzx9UE/hmpBIZIRNybqE5ozw90s=;
        b=t/osFBq57w3GdoBWbzZU1r7INz1N4b2LqTNcHJOVE70cLZqO7wLx+Ua6g3PhpAIBBG
         zCkz+mH1kCoV+sDyZnHWKEfGUfbmsFBj2rjkDx1PBS2AZLVuc3tZK5rs1PLSs7QGz75F
         p/z268wE8CURaAhC1x/ox1f2cyA4nBUcswi5BIPgUtMiR1oZtpVMHxRcmeRH1xHyxRS/
         +iU2zEZGLrDp0keoWik43PkELVQ8Qm9BgQof6m9VSyYdiYpUWK/5Ttiklw5Ves424PTR
         iKkRK1GWNyi+DLYnvagLb+NNCLaAzscLjInn6m9TkNmWWChkNesgPodHXeREsVEdnRW0
         lRQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Hepg0rNNghmUr1sfvzx9UE/hmpBIZIRNybqE5ozw90s=;
        b=cAA3y/gKFGF494OkO0pApoNQzLuUmwl5OYLo8DCSr7kIDidPiFmzMIH9Qji++USBNR
         yM2mygsEW7xbetE0fc7VoDoE9QzWUCJZzTKv7rr81gOVQMgDzIoGmODqvR7lS7zAHcrJ
         fe/b6lTy/55s5Q3VFhIUtdrlTq2rlZzI4RoRUnq25evfMK611IqDA9nsadLXN1a3zu9Q
         qUJo50zPVSOsFj9rFV1Fuo2gdtX6Xt1VYOgxkDlaYFLS+iy0odhe2TVeUM5rGIC1xH2+
         vz4tK8R0HJYX69NVjCkADlF4Q9eiWjBUfhIxuoAF4fo0k3NIOo4W54q8Z35jKluNf8y7
         7GZw==
X-Gm-Message-State: AOAM530Q2J5L/e2mVvTUq5SeKx3A9iX8EggOrRiKlaUOHm+eDSvrjeRq
        vPNp0tWfe5DDzudlwBPb0tY0pKmCBDk3lNlLzo8M0g==
X-Google-Smtp-Source: ABdhPJyFjHD6TCxNQFpPEnI5V6HC3ibMLT5APRmYI95t01BOAQ6mOYZxp124jFsL0p3/0NCDm58NfKiei7mvPok3KnY=
X-Received: by 2002:a05:6512:32a3:: with SMTP id q3mr13969531lfe.157.1628688273576;
 Wed, 11 Aug 2021 06:24:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210809115722.351383-1-vladimir.oltean@nxp.com> <20210809115722.351383-3-vladimir.oltean@nxp.com>
In-Reply-To: <20210809115722.351383-3-vladimir.oltean@nxp.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Wed, 11 Aug 2021 15:24:22 +0200
Message-ID: <CACRpkdZMyJ4ZnyKrMgEpBmGh0=8vTjkMn0r2xkdBnF2D7Xwc_Q@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 2/4] net: dsa: create a helper which
 allocates space for EtherType DSA headers
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev <netdev@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 9, 2021 at 1:57 PM Vladimir Oltean <vladimir.oltean@nxp.com> wrote:

> Hide away the memmove used by DSA EtherType header taggers to shift the
> MAC SA and DA to the left to make room for the header, after they've
> called skb_push(). The call to skb_push() is still left explicit in
> drivers, to be symmetric with dsa_strip_etype_header, and because not
> all callers can be refactored to do it (for example, brcm_tag_xmit_ll
> has common code for a pre-Ethernet DSA tag and an EtherType DSA tag).
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
