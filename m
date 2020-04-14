Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B94951A8E17
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 23:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504893AbgDNVxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 17:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732193AbgDNVxN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 17:53:13 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEB57C061A0E
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 14:53:12 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id m12so1655798edl.12
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 14:53:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vanguardiasur-com-ar.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6XJggBeqNZwHcHHLY6sfVeMbXT+yRwu9kmL0zKIOza0=;
        b=wO7J5PV5FopClacEDaXHeMrwLMwC17ui0SIQ6zF4hBB0JwsYSsHQcsO5AZjXXbQBqJ
         3zkwayOjJq/AHgwrVV+QGe118BDRodau2efv2VgMEBcbOVNhidTBarndJobl5/O7c7vW
         tfK+Gx/M9r8JRYxvNQDrvcknJbIsWgEjP1VglMGQ8mjWMve+6SkCr/nRvSe8kTMsSd/r
         mu1r+ciy84hDdk+WHmYkTdnrqVNCR9GiNSlR6f2bOYr7YZEojOH2lV9I/YSKRIPol7ed
         e84jIHLgq/3JhGeJU8amfIfUIjbSVgLILi9PeGfXXAAzDqDEmEXQff+61X9q+a1R9cuO
         vIdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6XJggBeqNZwHcHHLY6sfVeMbXT+yRwu9kmL0zKIOza0=;
        b=UihvKV6vCsXyt2gMYjXKtSVzOa1Qd5hlvAU/xeMjo9z1hKx6LtLO7s4jzGT9MZblK6
         5f0Q+5JYUIMIz//R4xoLv8qxqT0E+IX49njFyCfFBOfl22PBb3lRCLn6TAv3yzC2YK3z
         QEXPvKgYHO6SkEwQxAr9/5qfhrM6PDSIOq1MVbMsrh1RTTjx6nX+hikJRkjufk5lY6or
         jPu4QTkrzzUIdVgo6Wx1WEOeEe5tHm5dAMMh7z7Bh7U9LiBhi4sQil0L60E8L5h0mOef
         xsyRxVnprmABl33rOe0QDRuQfzQyOOyy+m+gvALo33AnPEEfFkLekP1QuVPCcZM8dVBm
         O8IQ==
X-Gm-Message-State: AGi0PuZ1Lg+50RQyzwiMm5QzFjGNCgPGmxJN2+mggFcKYqfuvx3SiXBK
        5G49PgzQTXlwZobovaKhS3NL+kVgh5xF7Ud94RP6fA==
X-Google-Smtp-Source: APiQypLki1g/gVUbhYrj9kqnpCfe34IkYcW0Znyiw/nNCI+JYjLa2TqgKGZzxlNCajxLF4KJ/EkcPl3s1JpnvWDv+lw=
X-Received: by 2002:a05:6402:1587:: with SMTP id c7mr3505722edv.61.1586901191377;
 Tue, 14 Apr 2020 14:53:11 -0700 (PDT)
MIME-Version: 1.0
References: <2bc5a902-acde-526a-11a5-2357d899916c@linaro.org> <20200414180105.20042-1-andrzej.p@collabora.com>
In-Reply-To: <20200414180105.20042-1-andrzej.p@collabora.com>
From:   Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Date:   Tue, 14 Apr 2020 18:52:59 -0300
Message-ID: <CAAEAJfAZCq2OWfTT2Vqy5xzpOre3yYDOOP29+Y0n5_oGrrbsQg@mail.gmail.com>
Subject: Re: [RFC v2 0/9] Stop monitoring disabled devices
To:     Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Cc:     Linux-pm mailing list <linux-pm@vger.kernel.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        platform-driver-x86@vger.kernel.org, kernel@collabora.com,
        Fabio Estevam <festevam@gmail.com>,
        Amit Kucheria <amit.kucheria@verdurent.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-acpi@vger.kernel.org, NXP Linux Team <linux-imx@nxp.com>,
        Darren Hart <dvhart@infradead.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Gayatri Kammela <gayatri.kammela@intel.com>,
        Len Brown <lenb@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Allison Randal <allison@lohutok.net>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Support Opensource <support.opensource@diasemi.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Peter Kaestle <peter@piie.net>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Networking <netdev@vger.kernel.org>,
        Enrico Weigelt <info@metux.net>,
        "David S . Miller" <davem@davemloft.net>,
        Andy Shevchenko <andy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrzej,

Thanks for your patches.

On Tue, 14 Apr 2020 at 15:01, Andrzej Pietrasiewicz
<andrzej.p@collabora.com> wrote:
>
> This is the second iteration of this RFC.
>
> The series now focuses on cleaning up the code in the first place.
>
[..]
>  12 files changed, 180 insertions(+), 208 deletions(-)
>

Compared with the previous iteration, and just judging
by this diffstat, I think it's a step in the right direction.

Nice job :-)

Ezequiel
