Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27F1241C073
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 10:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244688AbhI2ISA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 04:18:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244582AbhI2IR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 04:17:59 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C764EC06161C
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 01:16:18 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id i25so7323179lfg.6
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 01:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tgcsUycp2YbDQ1PdP3bUM6QsFJX9CRZxHyD55sRVpFU=;
        b=RMhPCzhcKEJMIeynmE67imI6kRe9fca82cx99mFMKrNkIWxussWNA8h+tsyi4+z/cL
         aVcdU8bdpVChQ2WeBgqEawU6nl2KsUgBEO4jdY9uPLIQ+2es5UMeG4JgFLZBLPq4F0pU
         LXzCT1hLCj51DonEzBPe4x9KqyM3RHd/odKqE3tP4RpN6EUZ7s3NUszGt7EDtSVcUMVW
         vsAV5yNIQv00oJD9YvaKVbQmmexW3DBMEYjLjfutCx28zH+3NdzQNOnu7IJApqTp6hH3
         p8cazgdoQJ1YFgLTHySRNGW2Tq4oA83ZW28slxyuAqdSzK7mx/MUOWSnFfRv7vzUKNr0
         9Q3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tgcsUycp2YbDQ1PdP3bUM6QsFJX9CRZxHyD55sRVpFU=;
        b=KyY1nmVp5aZMjVRlrsg5YbxVV7gJs1YRGymL4+3/VotWMplBRoQfN5lSarLxrI2679
         kD9rKekWYxvRdnSuCFbbwuRkP+Hq4sx6wdz468Qv8/UoRefsmI7Kb4GbMyShx0ZXih0c
         87kye1P9X3LvxugrvqhZk0CPSm5u4DvlevYCuJ1Vw0HsxwVOirC4oVDnNtakHH4J9VTq
         YQ690Nh9AUwSuJyJtagnPsyoJIAecEauhTjPj9fjmXZSW3dLXxsIvigH5m/fn1gvhPNP
         qHP3apncYVyykbcMd65JOx12RUiFB6b2mJ0LUwH3e/kSrQ6pE+w/evmhvoS+xad7Jr9t
         MqeQ==
X-Gm-Message-State: AOAM531CZ9Ff+LpFnx78ytUzPTCBYiRhkgVTscRjJNDprhcs6XbqNXRK
        btCYcGTcbh4wwLh2wOSu+b7ICM43SJdSgW1rgiUnFw==
X-Google-Smtp-Source: ABdhPJw2pbvJ67snYeDfkBZehrWuQtDGpA+PYMjZNJu7qmJmR2jDpqoRjnbUbPlR5kU5ofjk/ZS4Yqdky6ShWxLQRNo=
X-Received: by 2002:a05:6512:706:: with SMTP id b6mr356994lfs.656.1632903377127;
 Wed, 29 Sep 2021 01:16:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210928144149.84612-1-linus.walleij@linaro.org> <20210928172519.4655ec60@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210928172519.4655ec60@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Wed, 29 Sep 2021 10:16:05 +0200
Message-ID: <CACRpkdYfJrT=L70j1YqSexSL+qa=RVD1ByM6T4aB=tnncfgD1Q@mail.gmail.com>
Subject: Re: [PATCH net-next 0/6 v8] RTL8366(RB) cleanups part 1
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 29, 2021 at 2:25 AM Jakub Kicinski <kuba@kernel.org> wrote:

> > After these patches are merged, I will send the next set which
> > adds new features, some which have circulated before.
>
> Looks like v7 got silently applied. Would you mind converting
> to incremental fixups?

No problem it's just one small incremental change, I'll fix.

Yours,
Linus Walleij
