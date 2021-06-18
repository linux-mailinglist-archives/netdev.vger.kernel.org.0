Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3103ACABE
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 14:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232155AbhFRM0n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 08:26:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231474AbhFRM0i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 08:26:38 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00E59C061574
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 05:24:28 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id l12so10340419oig.2
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 05:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=aleksander-es.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zGMiRyRq//Dmyu1IU2B9k28pLofo2fcJNcRGLdmdXBI=;
        b=QuJaZ1Jp0HJIGh8YZnu6ydU2L5dX6HOhfRdu9kDddNub/w55cjtKHA13sJUmZgiofz
         GpLkWMkct9iFtf0ZUNsbaS3dqiRXl27SsCj6K69SitBlTCMauEaCPk+ZmuZCQVv202UG
         nB2a/wI0WstcN/b2dvdjxoW1Uclz5jLN7LcARfwhywqO9uUu98j46bV11Yu6ZKIZNl+8
         yGEtMKbXk+lAUBO4JS0deDefM02fwy6DiWyKOtqxePzwuIkV+8pPeEi9n8reQesDZvoj
         N/igwfDpz1gGQcPfnXAmjc03cI5dAysuScVpPljRqMTo8j7Glq2cedV+19tAjZWkubyU
         9ymw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zGMiRyRq//Dmyu1IU2B9k28pLofo2fcJNcRGLdmdXBI=;
        b=EeRN/3vkeGZmPVkZ/qIP6bm0W8f5CMJ0pdbCmG7Q5s7rIOmNB71ZaJhttWL4Sou/If
         6/8xN+skRJs2Fx943E2W9OLg4jg75dfjIkaqLVkJg1+K79zAzQ9cjxajKPuM2AyM1Owv
         dveU+kBrU60uvag1znEYCUdvVBpfd3ldx/GGyPIM3dKZ7YVng/JSlv4l2h7bwId4cLKz
         5/fxwAgzJEoD2e+GPKqw3OnkvwbpEAPuEX6i7uTn16XMxvOHoYa6p8yrIzPT9VKzBHvf
         nkyJ4h//LWSKtczJL7Por7fHSI835Seu+Dn+1oOH7xApFZbysfowph8Gcnma7gh+BKpV
         xZDg==
X-Gm-Message-State: AOAM532z23QnS8yooUTOf7rshtIapwP3nr3EbU64LfI/RU2Gwawbxv7L
        ntjYzNhuCtLNdVA/nk3A3IT9/apd4lAfqFad309yYA==
X-Google-Smtp-Source: ABdhPJzbrSc8Z7nx9BQg7dqAKn++bJoithUarzQuKATTzxcv+74R8gd6Gfk/gduBg7VKKUuI1FMPDLFKHnZaFG3O5i0=
X-Received: by 2002:a05:6808:13d5:: with SMTP id d21mr14723893oiw.114.1624019068209;
 Fri, 18 Jun 2021 05:24:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210618075243.42046-1-stephan@gerhold.net> <20210618075243.42046-3-stephan@gerhold.net>
 <CAAP7ucKHXv_Wu7dpSmPpy1utMZV5iXGOjGg87AbcR4j+Xcz=WA@mail.gmail.com> <YMxx0XimZAEHmeUx@gerhold.net>
In-Reply-To: <YMxx0XimZAEHmeUx@gerhold.net>
From:   Aleksander Morgado <aleksander@aleksander.es>
Date:   Fri, 18 Jun 2021 14:24:17 +0200
Message-ID: <CAAP7uc+ckHLdMis0WQpuJSCJ0Ln7zBddEa-w3itRGykXsUiF2Q@mail.gmail.com>
Subject: Re: [PATCH net-next v2 2/3] net: wwan: Add RPMSG WWAN CTRL driver
To:     Stephan Gerhold <stephan@gerhold.net>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Leon Romanovsky <leon@kernel.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        linuxwwan@intel.com, Ohad Ben-Cohen <ohad@wizery.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-remoteproc@vger.kernel.org,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        phone-devel@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        ~postmarketos/upstreaming@lists.sr.ht
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey,

> > So, does this mean we're limiting the amount of channels exported to
> > only one QMI control port and one AT control port?
>
> Yep, but I think:
>   - It's easy to extend this with additional ports later
>     if someone has a real use case for that.
>   - It's still possible to export via rpmsgexport.
>

Ah, that's good then, if we can have the rpmsgexport fallback, there
shouldn't be any issue.

> > Not saying that's wrong, but maybe it makes sense to add a comment
> > somewhere specifying that explicitly.
>
> Given that these channels were only found through reverse engineering,
> saying that DATA*_CNTL/DATA* are fully equivalent QMI/AT ports is just
> a theory, I have no proof for this. Generally these channels had some
> fixed use case on the original Android system, for example DATA1 (AT)
> seems to have been often used for Bluetooth Dial-Up Networking (DUN)
> while DATA4 was often more general purpose.
>
> Perhaps DATA* are all fully equivalent, independent AT channels at the
> end, or perhaps DATA1/DATA4 behave slightly differently because there
> were some special requirements for Bluetooth DUN. I have no way to tell.
> And it can vary from device to device since we're stuck with
> device-specific (and usually signed) firmware.
>
> Another example: I have seen DATA11 on some devices, but it does not
> seem to work as AT port for some reason, there is no reply at all
> from the modem on that channel. Perhaps it needs to be activated
> somehow, perhaps it's not an AT channel at all, I have no way to tell.
>
> My point is: Here I'm only enabling what is proven to work on all
> devices (used in postmarketOS for more than a year). I have insufficient
> data to vouch for the reliability of any other channel. I cannot say if
> the channels are really independent, or influence each other somehow.
>

Fair enough; I think your approach is the correct one, just enable
what's known to work.

> As far as I understand, we currently do not have any use case for having
> multiple QMI/AT ports exposed for ModemManager, right? And if someone
> does have a use case, perhaps exposing them through the WWAN subsystem
> is not even what they want, perhaps they want to forward them through
> USB or something.
>

There is no such usecase in MM; having one single QMI port in MM is
more than enough, and having the extra AT port gives some
functionalities that we don't yet support in QMI (e.g. voice call
management). We don't gain anything extra by having more QMI or more
AT ports at this moment.

> > Also, would it make sense to have some way to trigger the export of
> > additional channels somehow via userspace? e.g. something like
> > rpmsgexport but using the wwan subsystem. I'm not sure if that's a
> > true need anywhere or just over-engineering the solution, truth be
> > told.
>
> So personally I think we should keep this simple and limited to existing
> use cases. If someone shows up with different requirements we can
> investigate this further.
>

Yes, I think I'm on that same boat.

> If I send a v3 I will check if I can clarify this in the commit
> message somewhat. I actually had something related in there but removed
> it shortly before submitting the patch because I thought it's mostly
> just speculation and the message was already quite long. Oh well :)
>

Heh :) Thanks!

-- 
Aleksander
https://aleksander.es
