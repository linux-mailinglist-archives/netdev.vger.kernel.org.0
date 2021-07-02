Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1B03BA489
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 22:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231130AbhGBUDQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 16:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230490AbhGBUDO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 16:03:14 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFB57C061762
        for <netdev@vger.kernel.org>; Fri,  2 Jul 2021 13:00:41 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id r4-20020a0568301204b029047d1030ef5cso4269557otp.12
        for <netdev@vger.kernel.org>; Fri, 02 Jul 2021 13:00:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aH3w41EwdMyT/8s30UWWDd82Dspwb91q3dRXX79Zl34=;
        b=TrGvzdo2YheAg05MejpJSoFabJW9/gXflvRFaR+XsCNtRJMtMKdnE1UxxXd9NUqdr2
         Fqwr6rcwK434vR7W2XQuifomg8dg4ewPVzDRj8CcyV5HO2oL393Dyh3K5wzQH2Ng0mfH
         MSkru+Y6owiwE+f93cUP2s9gdNOfcaNnlQ+lY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aH3w41EwdMyT/8s30UWWDd82Dspwb91q3dRXX79Zl34=;
        b=rGwOtdSASNH3rsDrYmZ/dYjEd1p4RUuW5EV3KWIoCWyXcZFFUCNmf9FD0XdI5WO2m9
         OhxRTYolnBVNvcu9onRFwfcjyv2Cz4biQqbzHISWfXjL1Uct06sahV5x1YLZ87QKbEPD
         UDrLKqrF1CLtLge7ii+143nyO06RGsezmVOpEZTG3nPZE2RxkLBeffu3VJ/LTx0mYAP9
         VqljNm6VfEi4QPGtg8a/IbNAZj8n3xrQmXOgLYQtqk4tnFcM/RQZhqNukU+Jsk0vG8VN
         VAG6lFaPhN1QeVMdakXEFl1hiF3jAX9MrNnizwwxlIXYJ9QgP8ZAKe8sj7Pgdpk4fqX4
         6ilA==
X-Gm-Message-State: AOAM530w/K7pSbTa6mJ4knTPyFn3LmJijQChLerwDm8wppu+ac5cC4b0
        7vunQFEaypmsFX7KukGsXe/8GWEMErLKSQ==
X-Google-Smtp-Source: ABdhPJyC6OCQDmjbH3rHPmJWsFPa+tFxVofWsJl0PwGFJYk5YBSuWSuVQ0CoIzjhlLfFoDRTyMH1vw==
X-Received: by 2002:a9d:ac6:: with SMTP id 64mr759571otq.239.1625256040644;
        Fri, 02 Jul 2021 13:00:40 -0700 (PDT)
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com. [209.85.167.179])
        by smtp.gmail.com with ESMTPSA id f25sm794350oto.26.2021.07.02.13.00.39
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Jul 2021 13:00:40 -0700 (PDT)
Received: by mail-oi1-f179.google.com with SMTP id t3so12653469oic.5
        for <netdev@vger.kernel.org>; Fri, 02 Jul 2021 13:00:39 -0700 (PDT)
X-Received: by 2002:aca:a8d6:: with SMTP id r205mr1121595oie.77.1625256039095;
 Fri, 02 Jul 2021 13:00:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210618064625.14131-1-pkshih@realtek.com> <20210618064625.14131-5-pkshih@realtek.com>
 <20210702072308.GA4184@pengutronix.de> <CA+ASDXNjHJoXgRAM4E7TcLuz9zBmQkaBMuhK2DEVy3dnE-3XcA@mail.gmail.com>
 <20210702175740.5cdhmfp4ldiv6tn7@pengutronix.de> <CA+ASDXP0_Y1x_1OixJFWDCeZX3txV+xbwXcXfTbw1ZiGjSFiCQ@mail.gmail.com>
 <20210702193253.sjj75qp7kainvxza@pengutronix.de>
In-Reply-To: <20210702193253.sjj75qp7kainvxza@pengutronix.de>
From:   Brian Norris <briannorris@chromium.org>
Date:   Fri, 2 Jul 2021 13:00:27 -0700
X-Gmail-Original-Message-ID: <CA+ASDXP8JU+VXQV1ZHLsV88y_Ejr4YbS3YwDmWiKjhYsQ-F2Yw@mail.gmail.com>
Message-ID: <CA+ASDXP8JU+VXQV1ZHLsV88y_Ejr4YbS3YwDmWiKjhYsQ-F2Yw@mail.gmail.com>
Subject: Re: [PATCH 04/24] rtw89: add debug files
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 2, 2021 at 12:32 PM Oleksij Rempel <o.rempel@pengutronix.de> wrote:
> On Fri, Jul 02, 2021 at 11:38:26AM -0700, Brian Norris wrote:
> > Well mainly, I don't really like people dreaming up arbitrary rules
> > and enforcing them only on new submissions.
>
> It is technical discussion. There is no reason to get personal.

I'm not really intending to make this personal, so apologies if it
appeared that way.

What I'm trying to get at is that
(a) no other wireless driver does this, so why should this one? and
(b) the feature you claim this driver can use does not appear suited
to the task.

It's easier to make suggestions than to make them a reality.

> > If such a change was
> > Recommended, it seems like a better first step would be to prove that
> > existing drivers (where there are numerous examples) can be converted
> > nicely, instead of pushing the work to new contributors arbitrarily.
>
> Hm, my experience as patch submitter is rather different, but who knows,
> every subsystem has diffent rules. Good to know, wireless is different.

I'm not an arbiter for "wireless" -- so my thoughts are purely my own
opinion. But I have noted some technical reasons why wireless drivers
may be different than ethernet drivers, and the suggested (again,
purely my own opinion) exercise might show you that your suggestion
won't really work out in practice.

Brian
