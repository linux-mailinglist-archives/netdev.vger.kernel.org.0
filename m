Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 671D92C5DE1
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 23:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391868AbgKZWgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 17:36:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387561AbgKZWgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 17:36:23 -0500
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A394C0613D4
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 14:36:21 -0800 (PST)
Received: by mail-lf1-x142.google.com with SMTP id q13so3800166lfr.10
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 14:36:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=7NGv4Vfwf5X1fGBSvb1yUPJjNHzCKOF6w3Ppx30gK4E=;
        b=YJoZbLW6R9nBN/GdkubNfetV5W1Z14Fw6pUmMEu8AxB6jEqbvlMreBwRlss+ZkvpYq
         OtU30bomk8AqV5wrfLqFziBdNksOnpTAS+6X2Qr0AjerdZuKK7J/JNdSM1kqQHXKalDy
         /BX/WpsFspAax9yP7bH7LOjmgzcqtWJGym0lIrPX20RFef34WZtlmy7pqUhQC8zXF+W+
         BTxkuJSQ4Noa488z494F0T8Z/vMXVjbTcc1oJGk0ODSHVNgJ4E4126bqKPU/ZOL65Gr+
         TA3doONWwKJlnmEbBiEZTPQlKBe4O2Xyt76d2Jb1CnpSn8r8b7N79Z6koGJuwDSW5i8c
         4qCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=7NGv4Vfwf5X1fGBSvb1yUPJjNHzCKOF6w3Ppx30gK4E=;
        b=eAvo/pFUwcCCoM3weTXAM5hArmqJXnESMBg4D1rdz1luaztrahIGuI14qmFCw0HoVl
         SKBfEncFCxvsvEjSYifjkEXZFInTc3S7XxGKH31K8KrHkEDf3VIY7CaKhFjkurFJu0//
         faFoZ4WwmjoxUE+G8HPt7rBnGyCUhrlTOJLa4otWrbG+Kcqj0LkqvRELmp6JvXafq9E1
         4LkAnIyMlRMuDrM+oGs6L7eoudQqU1Q5eflWIXgel4Yt0JJcGIjQwent1ShVOFNxGh+f
         44X2yZQMxD+4l2TfjSjinAl3kqs3TXwMcz8pjEayBEolZBvzJj9wQAmGdixuoQBI1XoF
         XdLQ==
X-Gm-Message-State: AOAM532I2JQpDp0Ua7NLydDfA5bBTf6bW398CXOHrQY2MsrJDty0eLfU
        JS7ecOtZt+3wlFLdr1OR3/SkkKe9GoG33oKr
X-Google-Smtp-Source: ABdhPJwQxI8j92w+fPywjV16iLcwFzCmTRx2ND+/PKeyG+Pg6kUDFXn1QaMwrnQN5FL+HiV7rEy8Zg==
X-Received: by 2002:a19:22c9:: with SMTP id i192mr2295228lfi.65.1606430179220;
        Thu, 26 Nov 2020 14:36:19 -0800 (PST)
Received: from wkz-x280 (h-79-28.A259.priv.bahnhof.se. [79.136.79.28])
        by smtp.gmail.com with ESMTPSA id u5sm464333lff.78.2020.11.26.14.36.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2020 14:36:18 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, vivien.didelot@gmail.com,
        olteanv@gmail.com, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/4] net: dsa: Link aggregation support
In-Reply-To: <20201120133050.GF1804098@lunn.ch>
References: <20201119144508.29468-1-tobias@waldekranz.com> <20201119144508.29468-3-tobias@waldekranz.com> <20201120003009.GW1804098@lunn.ch> <5e2d23da-7107-e45e-0ab3-72269d7b6b24@gmail.com> <20201120133050.GF1804098@lunn.ch>
Date:   Thu, 26 Nov 2020 23:36:17 +0100
Message-ID: <87v9dr925a.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 20, 2020 at 14:30, Andrew Lunn <andrew@lunn.ch> wrote:
> On Thu, Nov 19, 2020 at 06:43:38PM -0800, Florian Fainelli wrote:
>> > 
>> > Hi Tobias
>> > 
>> > My comment last time was to statically allocated them at probe
>> > time. Worse case scenario is each port is alone in a LAG. Pointless,
>> > but somebody could configure it. In dsa_tree_setup_switches() you can
>> > count the number of ports and then allocate an array, or while setting
>> > up a port, add one more lag to the list of lags.

Right, yes I forgot about that, sorry.

Permit me a final plea for the current implementation. If it is a hard
no, say the word and I will re-spin a v2 with your suggestion.

>> The allocation is allowed to sleep (have not checked the calling context
>> of dsa_lag_get() whether this is OK) so what would be the upside of

These events always originate from a sendmsg (netlink message), AFAIK
there is no other way for an interface to move to a new upper, so I do
not see any issues there.

>> doing upfront dsa_lag allocation which could be wasteful?
>
> Hi Florian
>
> It fits the pattern for the rest of the DSA core. We never allocate
> anything at runtime. That keeps the error handling simple, we don't
> need to deal with ENOMEM errors, undoing whatever we might of done,
> implementing transactions etc.

I understand that argument in principle. The reason that I think it
carries less weight in this case has to do with the dynamic nature of
the LAGs themselves.

In the cases of `struct dsa_port`s or `struct dsa_switch`es there is no
way for them to be dynamically removed, so it makes a lot of sense to
statically allocate everything.

Contrast that with a LAG that dynamically created and dynamically
modified, i.e. more ports can join/leave the LAG during its
lifecycle. This means you get all the headache of figuring out if the
LAG is in use or not anyway, i.e. you need to refcount them.

So essentially we _will_ be dynamically allocating/freeing them. We just
get to choose if we do it through the SLAB allocator, or through the
static array.

If you go with the static array, you theoretically can not get the
equivalent of an ENOMEM. Practically though you have to iterate through
the array and look for a free entry, but you still have to put a return
statement at the bottom of that function, right? Or panic I suppose. My
guess is you end up with:

    struct dsa_lag *dsa_lag_get(dst)
    {
        for (lag in dst->lag_array) {
            if (lag->dev == NULL)
                return lag;
        }

        return NULL;
    }

So now we have just traded dealing with an ENOMEM for a NULL pointer;
pretty much the same thing.
