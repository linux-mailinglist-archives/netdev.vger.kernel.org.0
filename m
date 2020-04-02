Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D554619B983
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 02:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732989AbgDBA0m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 20:26:42 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:45664 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732385AbgDBA0m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 20:26:42 -0400
Received: by mail-pf1-f193.google.com with SMTP id r14so855335pfl.12
        for <netdev@vger.kernel.org>; Wed, 01 Apr 2020 17:26:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ob50KPPitu/VAsCZRCb3jIgsR0wX/xQsKu6DYbArPO4=;
        b=pHAONuh2cBAam65QtvHR6M5VI4wsm+z8NLQz0FSUy4wl0NcZnViOpfQYIAVwYqo+GZ
         6u/yJcCBkg0GUBhSG+eGb8Z1GJWrDcwH3Wr5Ry3Ms1DEAEk7yD7os4vd6JhSOKjskUG4
         r3wGD+dWECHTN6nYHUIfjqza7scSXkzCDEqQe6q5Jm+B/gCnFnsp+OMy6VjIcO592Sj2
         xXlTkTicFXlyELgXpyjKervJ7cz84gj7hK65zerNKNVET0gcejyJGIFz5ka8k4RL3Hpl
         MhTRtr5Jqi/dTDEmBmUoeRo4kXd5QMl/ivO71/Ze8GThkm01gienkv1OsisOlGAwhZmz
         QbRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ob50KPPitu/VAsCZRCb3jIgsR0wX/xQsKu6DYbArPO4=;
        b=BGRinF0Q9hx5kQ41Lhkiko1xlNgYICzkSsTvXme637N68EYpSo12hYskLZcv4QCvnP
         doDkSEtwme+1ksV+0dCEG8lBOwfgDl2HDSdbLm8xevXJfldOn17qFfcqwWGvrsuJB5Yg
         /L0foY6ogt35dp2BVu/qek8QKU3qPS7cJPMcOvXgxEahBdZ94jEsJ7Zu3m+lYvYnnmgr
         5e6tW4lFwBo38prswgF1qgQk1AWmfezCmcekgLpBSklp7+qvNG2iDMV6g0YWSFF2yNOQ
         pAc+e70ahQJPb137WmWmq6fAL6hnmRdlouz7kIQBS0qJoEk7BUHCcYSuxIKheCc+7QIa
         Prng==
X-Gm-Message-State: AGi0PuaTJGgSaoRiLgtwScjUUzgegiqBKnl6pTXmzAPuf4kO+FPs4G7G
        Go9em513Ld6ajn+ODhhFS9IXdKGE78m2jqeJJDP5pQ==
X-Google-Smtp-Source: APiQypKeG0RcaEryHPNpjDE3LJENFRlmFYUd6WwW6EYlUJOuCKtogvsWiFcehG/IvwaDMd5evl8Xm6x6apMH7SD2Ofc=
X-Received: by 2002:a63:a34d:: with SMTP id v13mr837990pgn.10.1585787200467;
 Wed, 01 Apr 2020 17:26:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200311024240.26834-1-elder@linaro.org> <20200401173515.142249-1-ndesaulniers@google.com>
 <3659efd7-4e72-6bff-5657-c1270e8553f4@linaro.org> <CAKwvOdn7TpsZJ70mRiQARJc9Fy+364PXSAiPnSpc_M9pOaXjGw@mail.gmail.com>
 <3c878065-8d25-8177-b7c4-9813b60c9ff6@linaro.org> <CAKwvOdnZ-QNeYQ_G-aEuo8cC_m68E5mAC4cskwAQpJJQPc1BSg@mail.gmail.com>
 <efd2c8b1-4efd-572e-10c5-c45f705274d0@linaro.org> <CAKwvOdnZ9KL1Esmdjvk-BTP2a+C24bOWguNVaU3RSXKi1Ouh+w@mail.gmail.com>
 <5635b511-64f8-b612-eb25-20b43ced4ed3@linaro.org>
In-Reply-To: <5635b511-64f8-b612-eb25-20b43ced4ed3@linaro.org>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Wed, 1 Apr 2020 17:26:29 -0700
Message-ID: <CAKwvOdnO2=yjEerw50b_C2vrgdCh2es6ZRfQpBRVR9RCrvwi6Q@mail.gmail.com>
Subject: Re: [PATCH v3] bitfield.h: add FIELD_MAX() and field_max()
To:     Alex Elder <elder@linaro.org>,
        Maxim Kuvyrkov <maxim.kuvyrkov@linaro.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 1, 2020 at 4:18 PM Alex Elder <elder@linaro.org> wrote:
>
> On 4/1/20 5:26 PM, Nick Desaulniers wrote:
> >
> > mainline is hosed for aarch64 due to some dtc failures.  I'm not sure
> > how TCWG's CI chooses the bisection starting point, but if mainline
> > was broken, and it jumped back say 300 commits, then the automated
> > bisection may have converged on your first patch, but not the second.
>
> This is similar to the situation I discussed with Maxim this
> morning.  A different failure (yes, DTC related) led to an
> automated bisect process, which landed on my commit. And my
> commit unfortunately has the the known issue that was later
> corrected.
>
> Maxim said this was what started the automated bisect:
> ===
> +# 00:01:41 make[2]: *** [arch/arm64/boot/dts/ti/k3-am654-base-board.dtb] Error 2
> +# 00:01:41 make[2]: *** [arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dtb] Error 2
> +# 00:01:41 make[1]: *** [arch/arm64/boot/dts/ti] Error 2
> +# 00:01:41 make: *** [dtbs] Error 2

DTC thread:
https://lore.kernel.org/linux-arm-kernel/20200401223500.224253-1-ndesaulniers@google.com/

Maxim, can you describe how the last known good sha is chosen?  If you
persist anything between builds, like ccache dir, maybe you could
propagate a sha of the last successful build, updating it if no
regression occurred?  Then that can always be a precise last known
good sha.  Though I don't know if the merge commits complicate this.
-- 
Thanks,
~Nick Desaulniers
