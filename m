Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8E845054E
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 14:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbhKONZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 08:25:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232060AbhKONXi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 08:23:38 -0500
Received: from mail-ua1-x92d.google.com (mail-ua1-x92d.google.com [IPv6:2607:f8b0:4864:20::92d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1CF8C061206
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 05:20:41 -0800 (PST)
Received: by mail-ua1-x92d.google.com with SMTP id p37so33104905uae.8
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 05:20:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v2+72Tw5DDPlkU3wXlLqIr3oCf8oYEOw8g5Hr7HlF88=;
        b=NgC+zasV2hBWUoKS2OK6oAjBn2Rl/sN0qojKl9OxFncV0JZNPS3Vow4ntmzpge2GNA
         t6RnS2mx6wBKv9qWjIAQRTPTuFRsNMICQ1OUJ8PwGySh1yM70uJfk63DbN669xcs+MOa
         1HoYELX9QzWIJeZEht4vBxUfVaH9F81guz8rygvCHt/E7zZIIMlWnY6c7sMYbxB+0DBg
         dWdKnNy2IH1QVzkaojgJMEwib0aH0OIOB+GoR4DyHb0jES5ujbkIHqzkYJWF4YGT+b5o
         tD5TqePpNLhoaBx2/DKMtz4uVlnwWpv3ZntFIjOyLBLQgFHbxtuDH9XYxsdAtHsGcA95
         makw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v2+72Tw5DDPlkU3wXlLqIr3oCf8oYEOw8g5Hr7HlF88=;
        b=vNW2qIjJJ+Zjjph+ip0usYSF0iu/+Pc55LHMFk0/yijHo6qE3X67oXbm54lT5NoJ06
         qe0zNq0J4uGFIMbOEtmpTdAV8z19gfHJ/k0LFmzfgPVjGi9eiIE1Uylu0+0vS9DTOwKM
         dOu6U0xzJEQSUK9oKgwosEXtd3XP++1uHlGEAK+sktp93qOf4zIxtfCrndBuxWwL2Qei
         op2TOX0NpRZ9tTUWZUrmE6MkAyqImxz28mH1DGnR3ZmDxEfTzA8mUxPUXiraGBC2EwcE
         +vpjmDbplWvV1Ep7d09XNpbw+biRtNPJFiQrj8dN+e2mQTq+G1dwD1d419cUtpN7PYT/
         XTwA==
X-Gm-Message-State: AOAM5332mNU++KE6e3vqisb7KxFIa/ahuZr+kMFYdwlXAw+CpTH9IN0V
        K5ColZLf7YCpJUxcAyIV/wUdPQv+8RUVJmADovE=
X-Google-Smtp-Source: ABdhPJzk6zTwJHutCGB6ydLu9Kw8JNMYDU4+cZjHabyYQf/Cd8yHvUxN5yT4lEN2jylF7zzMZb+ldCg+6X2DwzG5juI=
X-Received: by 2002:a05:6102:3e81:: with SMTP id m1mr42223478vsv.44.1636982441165;
 Mon, 15 Nov 2021 05:20:41 -0800 (PST)
MIME-Version: 1.0
References: <20211115105659.331730-1-m.chetan.kumar@linux.intel.com>
In-Reply-To: <20211115105659.331730-1-m.chetan.kumar@linux.intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Mon, 15 Nov 2021 16:20:29 +0300
Message-ID: <CAHNKnsR3JSW_j0V3WbCYZODfOR0Pxt9CqEgakGiK34g2rW9gEQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net: wwan: iosm: device trace collection using relayfs
To:     M Chetan Kumar <m.chetan.kumar@linux.intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>, krishna.c.sudi@intel.com,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 15, 2021 at 1:49 PM M Chetan Kumar
<m.chetan.kumar@linux.intel.com> wrote:
> This patch brings in support for device trace collection.
> It implements relayfs interface for pushing device trace
> from kernel space to user space.
>
> On driver load iosm debugfs entry is created in below path
> /sys/kernel/debug/

This code will break as soon as the user attaches a second modem to
the host. The debugfs directory will not be created due to the name
collision, so the user will only be able to trace the second modem
when he detaches the first one.

In general, I like the idea of exporting debug information via
debugfs. But the direct export of a debug interface of a driver that
intensively uses some subsystem (bypassing the subsyste) looks odd.

This pollutes debugfs root with unrelated directories and makes it
harder for an end user to match control devices from /dev with debugfs
entries.

Maybe we should add a common debugfs infrastructure to the wwan
subsystem to facilitate the driver development and end user
operations. So the driver should care only about a particular debug
knob without caring too much about the base directory for a device
instance.

E.g. for the IOSM driver this will mean that the trace file will be moved from

/sys/kernel/debugfs/iosm/trace

to the

/sys/kernel/debugfs/wwan/wwan0/trace

-- 
Sergey
