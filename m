Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07E431C7C96
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 23:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729743AbgEFVko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 17:40:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728621AbgEFVko (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 17:40:44 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB7AEC061A0F;
        Wed,  6 May 2020 14:40:42 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id rh22so2705113ejb.12;
        Wed, 06 May 2020 14:40:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ICA08eo2A+qP7RtXmrfg2CY1fdR7TD7YkRgnps9JOzE=;
        b=cH/93Cd9cgBcrTrT7Mv6ggZmvk02MtrgH1b/9h+qdX57UGj0tckw19IPgbfASl0az9
         Ix9a291erbKk7XqEl1Bw1YwWxnxnmXQ7Iw5j3FeeOnyLebw5ye44+k+r31/jC+BpRLV3
         8PpwgMGHPp9GaHEKB8KcDSW5lAUyfLfsGaXWKWaHu2NtuqFLop8xt17Rrj4hz+AYzrgz
         bNO0APyAprnHMK/1cGt4nv2CKnZbetJJjipsqubhdUD3ADfVAyZv0YlO+egx+caIcfd2
         wGhLyylogXp7AHKVRkMQ+WTYsENt9wFYv4SaHIh8Hz0Ca/KuwVcRzvHh/zjioqimXnKU
         ZG/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ICA08eo2A+qP7RtXmrfg2CY1fdR7TD7YkRgnps9JOzE=;
        b=E0+WL+BwEfmeZPz5MYIaZgygoJQYlw8UrIGZbqRKP4rLYbFAQFx9ZzEhuPf2f24xyf
         Nrl2DoNtnRTHz5slm90MgEKJUfVw23ha0MYMMMyTMEY2+xnrA2VKo8uLHE7yojw1WmzT
         tdyYrNRjZGZquJtjosGk1Dlf+D1izJY1SC9kKzlfwoWFIRWRISIfGbMRaashGkZKJ2nx
         7RMOzXEzuj6GWTIed4CaXp99JsppFwb2W9syIEaq+vIC28NeuAz7fDsrE4tcYy0AZRCc
         /57KreG/T1m8ORqna7IJUOCfJEabnRkxmPXuesd8bJ0Eb89NMmZidiwgQ/z5p+06QhNj
         cMrw==
X-Gm-Message-State: AGi0PuZk1gpf+mAx/G54essh71pC61nwz+Z567/C38M1im2c7YHv1QsC
        uQKoBWknJjvGVPxOr3N/XizNXQCpuF7G9sJPtGU=
X-Google-Smtp-Source: APiQypJnw0Jz2ypKpzJSJkiIrfJb3kLjeivaSwH/8wusiDlBWyXe5u+Atl3yINQgW/XjkecO1pqvluM/TJX9osgD2PE=
X-Received: by 2002:a17:906:355b:: with SMTP id s27mr9460830eja.184.1588801241411;
 Wed, 06 May 2020 14:40:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200505210253.20311-1-f.fainelli@gmail.com> <20200505172302.GB1170406@t480s.localdomain>
 <d681a82b-5d4b-457f-56de-3a439399cb3d@gmail.com>
In-Reply-To: <d681a82b-5d4b-457f-56de-3a439399cb3d@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 7 May 2020 00:40:30 +0300
Message-ID: <CA+h21hpvC6ST2iv-4xjpwpmRHQJvk-AufYFvG0J=5KzUgcnC5A@mail.gmail.com>
Subject: Re: [RFC net] net: dsa: Add missing reference counting
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On Thu, 7 May 2020 at 00:24, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 5/5/2020 2:23 PM, Vivien Didelot wrote:
> > On Tue,  5 May 2020 14:02:53 -0700, Florian Fainelli <f.fainelli@gmail.com> wrote:
> >> If we are probed through platform_data we would be intentionally
> >> dropping the reference count on master after dev_to_net_device()
> >> incremented it. If we are probed through Device Tree,
> >> of_find_net_device() does not do a dev_hold() at all.
> >>
> >> Ensure that the DSA master device is properly reference counted by
> >> holding it as soon as the CPU port is successfully initialized and later
> >> released during dsa_switch_release_ports(). dsa_get_tag_protocol() does
> >> a short de-reference, so we hold and release the master at that time,
> >> too.
> >>
> >> Fixes: 83c0afaec7b7 ("net: dsa: Add new binding implementation")
> >> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> >
> > Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
> >
> Andrew, Vladimir, any thoughts on that?
> --
> Florian

I might be completely off because I guess I just don't understand what
is the goal of keeping a reference to the DSA master in this way for
the entire lifetime of the DSA switch. I think that dev_hold is for
short-term things that cannot complete atomically, but I think that
you are trying to prevent the DSA master from getting freed from under
our feet, which at the moment would fault the kernel instantaneously?

If this is correct, it certainly doesn't do what it intends to do:
echo 0000\:00\:00.5> /sys/bus/pci/drivers/mscc_felix/unbind
[   71.576333] unregister_netdevice: waiting for swp0 to become free.
Usage count = 1
(hangs there)

But if I'm right and that's indeed what you want to achieve, shouldn't
we be using device links instead?
https://www.kernel.org/doc/html/v4.14/driver-api/device_link.html

Thanks,
-Vladimir
