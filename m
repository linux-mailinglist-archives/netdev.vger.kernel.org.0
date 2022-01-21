Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 396C949587F
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 04:14:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232482AbiAUDON (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 22:14:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232195AbiAUDOM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 22:14:12 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BFB4C061574
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 19:14:12 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id t18so7145859plg.9
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 19:14:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9VTA7AoVBK4ocD9DPyHctnOkfSnvbD5hSyVzDe0DyIc=;
        b=JJTPKaQv1lCRv6edJ7ZEQh2wZxj2Iz7VMMWqBD/WlE5raLd8143gVC58CXN1kZBG2B
         9NG5z+IB7T8vrI7LFxHvswdgXwBLpyH6VZbKfYumZAgbGc/lS0M6XlQC7SWleGpXf2Sv
         iun1yA/DxnECCuad76Bfi8UL/4JrS+eK26uF47Wo8D7nJPbDPd2FUwuTVFDdqmTWmCg3
         kpeZkubaRyWLIn2O61E2Tqg2DMa3zCvq1aadqQCBckzCMlSIu/dV7+7CwTvlA1bZf6O/
         bAGvVVQRwc1lo73AqlFdySkFYY8nbJxoLZ5lsV0ntZBVs0YRaCr63O3thWZ33EDG+KZx
         v/5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9VTA7AoVBK4ocD9DPyHctnOkfSnvbD5hSyVzDe0DyIc=;
        b=TvZrl19MpvLgm1cceyq2HLkT+oYzZpmgxKnQs2y4EE+PlNUpuyCTYI5fmYjtO2oVnp
         p/Wiz8pkFYwx/4vMTtYpU40EEyMbq/nr0uR9CSHltmqBqWWquTsVUKBJiGF5TBT9xg2C
         4+Zi1oM2DuHHS6AdcZHc5KTfvXvLVk3REmjJ5GsKdA4o1i+QWe0HLITjxnOnNazJkpcI
         KM0Tz/oVKyO76A86Rfy88GVjq1Z5+eZThu3byhsXvc46z+9AXdEpyZRadHf3VD5P5tKo
         g3s+G40cyCntFp7riOL0KqP3MjoTUxfXr8rSNoNeHose2AI7/e4mPXbhWxMCxvPj+gud
         qBNw==
X-Gm-Message-State: AOAM530d+IJXqp5qeCMLMownBlJjRF10qFtlAnKo5vXxfozYe5QDh383
        e8ykhCF88f365SL1gdRVaEsD7yTnJ3Ci5E90ecU1nfm531pJvWFQ
X-Google-Smtp-Source: ABdhPJwb4JUzSlKlTGqu6k9wBboYv2RfpYTsuCQTERF1LjvWn7avIy1kkbaU+fKyk64CSr7sN296/wXjN4cQlRtcbzA=
X-Received: by 2002:a17:903:246:b0:14a:26ae:4e86 with SMTP id
 j6-20020a170903024600b0014a26ae4e86mr1956157plh.59.1642734850136; Thu, 20 Jan
 2022 19:14:10 -0800 (PST)
MIME-Version: 1.0
References: <87ee5fd80m.fsf@bang-olufsen.dk> <trinity-ea8d98eb-9572-426a-a318-48406881dc7e-1641822815591@3c-app-gmx-bs62>
 <87r19e5e8w.fsf@bang-olufsen.dk> <trinity-4b35f0dc-6bc6-400a-8d4e-deb26e626391-1641926734521@3c-app-gmx-bap14>
 <87v8ynbylk.fsf@bang-olufsen.dk> <trinity-d858854a-ff84-4b28-81f4-f0becc878017-1642089370117@3c-app-gmx-bap49>
 <CAJq09z7jC8EpJRGF2NLsSLZpaPJMyc_TzuPK_BJ3ct7dtLu+hw@mail.gmail.com>
 <Yea+uTH+dh9/NMHn@lunn.ch> <20220120151222.dirhmsfyoumykalk@skbuf>
 <CAJq09z6UE72zSVZfUi6rk_nBKGOBC0zjeyowHgsHDHh7WyH0jA@mail.gmail.com> <20220121020627.spli3diixw7uxurr@skbuf>
In-Reply-To: <20220121020627.spli3diixw7uxurr@skbuf>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Fri, 21 Jan 2022 00:13:58 -0300
Message-ID: <CAJq09z5HbnNEcqN7LZs=TK4WR1RkjoefF_6ib-hFu2RLT54Nug@mail.gmail.com>
Subject: Re: [PATCH net-next v4 11/11] net: dsa: realtek: rtl8365mb: multiple
 cpu ports, non cpu extint
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Frank Wunderlich <frank-w@public-files.de>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> :) device tree properties are not the fix for everything!

I'm still getting used to it ;-)

In this thread, Alvin suggested adding a new property to define which
port will be used as trap_port instead of using the last CPU port.
Should I try something different?

        switch1 {
               compatible = "realtek,rtl8367s";
               reg = <29>;

               realtek,trap-port = <&port7>;

               ports {
                        ....
                        port7: port@7 {
                            ...
                       };
        };

Should I do something differently?

> I think I know what the problem is. But I'd need to know what the driver
> for the DSA master is, to confirm. To be precise, what I'd like to check
> is the value of master->vlan_features.

Here it is 0x1099513266227 (I hope). Oh, this DSA driver still does
not implement vlan nor bridge offload. Maybe it would matter.

Regards,

Luiz
