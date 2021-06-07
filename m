Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9200B39E86C
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 22:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbhFGUba (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 16:31:30 -0400
Received: from mail-ej1-f51.google.com ([209.85.218.51]:39576 "EHLO
        mail-ej1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbhFGUb2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 16:31:28 -0400
Received: by mail-ej1-f51.google.com with SMTP id l1so28814557ejb.6
        for <netdev@vger.kernel.org>; Mon, 07 Jun 2021 13:29:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TQTw38zSn6V5v7YhKd8FRGOL/X+Zyg1czB6RcfxkopI=;
        b=Ph0Ky3O84ypaaUbB0pfP3jM1I4E9W+fI2Xf7Ocv8okvebs7jS6m3qO9fuKNJ9ME2pw
         uFiDlC0R73Zj3QBN2++haVvgJXrpddrOB+hv4eXNl5BjrqX8ADpCKymO7LngDlNwbu0/
         Ux3/a7z2+V8zAIIyZxAns/LaTaVlFn5ZEYE24NuKqns4kvn4hImxOnsVUq/c7bCmOnEq
         PA16ODJ+ko1eV8j9PWTh5MW4udmycRHrEYUO4p5MM9tb+x4DZrgTJuSyoqoKvp7NmepA
         hS3nsJbxNlccbLb77DgIsc0S7AHZDWUUwul2gDRRfxU9imWzstVAajG/UwHZXiPPsTI9
         TfBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TQTw38zSn6V5v7YhKd8FRGOL/X+Zyg1czB6RcfxkopI=;
        b=XdbXLiXNXIetK8kRE+DnO5fjFvQVY1Kh1nvvZJmDGEX9++ZnY30l44Sj1voGuH7G9U
         ja5I77wB/2lpJimOassVaDDD/rq3GC8wCseKxirDHxioooBv/ElXhw7W73w6/5fxyUx2
         6/Id2FaQvFJHD9mzyhq2SyFa5lyETiYXxE2+0Jvd/PBgyqdEZzKdwXQHcP5vL3WRjzdk
         EXrSGy9BT8CasWcLMdIF1lvpQJ6gXNfHhWlUTnEDbbHHMI6Tfr85DepsbArr5ZayoeB/
         LE6G/636LtZ+ggSgfdOGubLuAyj05HI8UXfyJjhXLgWXe+WfnduA2GuahaJy8zl1/twt
         H+jw==
X-Gm-Message-State: AOAM532qc8DTX0WXMBKMVxGTg3zK4uuQuH9Kwec0tSIJrKB8z1gypP00
        LFaZlnE4ypxOLg9pcGddGvUHhBXBhrKEAwwpYsKWZGSpxSA=
X-Google-Smtp-Source: ABdhPJz9Os8Ws3GjUg9QJmByPTpKYIhHsKfVbXOcfKMXL3YytQXhcGIOjkCgKMMBXAHu0VQ7C9GFIeysBypcIJ0w/j4=
X-Received: by 2002:a17:906:7d8d:: with SMTP id v13mr19618643ejo.2.1623097715552;
 Mon, 07 Jun 2021 13:28:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210604161250.49749-1-lxu@maxlinear.com> <20210604194428.2276092-1-martin.blumenstingl@googlemail.com>
 <b01a8ac2-b77e-32aa-7c9b-57de4f2d3a95@maxlinear.com> <YLuzX5EYfGNaosHT@lunn.ch>
 <9ecb75b8-c4d8-1769-58f4-1082b8f53e05@maxlinear.com>
In-Reply-To: <9ecb75b8-c4d8-1769-58f4-1082b8f53e05@maxlinear.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Mon, 7 Jun 2021 22:28:24 +0200
Message-ID: <CAFBinCARo+YiQezBQfZ=M6HNwvkro0nK=0Y9KhhhRO+akiaHbw@mail.gmail.com>
Subject: Re: [PATCH v3] net: phy: add Maxlinear GPY115/21x/24x driver
To:     Liang Xu <lxu@maxlinear.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        Hauke Mehrtens <hmehrtens@maxlinear.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Thomas Mohren <tmohren@maxlinear.com>,
        "vee.khee.wong@linux.intel.com" <vee.khee.wong@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 7, 2021 at 6:37 AM Liang Xu <lxu@maxlinear.com> wrote:
[...]
> >> It creates difficulty for the test coverage to put together.
> > That also does not really matter. If somebody has both, does the work
> > to merge the drivers and overall we have less code and more features,
> > the patch will be accepted.
> >
> >
> >          Andrew
> >
> >
> The datasheet of GPY2xx are only available under NDA currently, since we
> have
>
> to protect our IP for the new devices.
I don't understand how knowledge about some registers can lead to IP
being stolen by other vendors

> I do not know much about XWAY feature set, but I guess the difference should
>
> be 2.5G support, C45 register set, PTP offload, MACsec offload, etc.
I think [0] lists the functional differences - GPY115 and newer seem
to differ from older PHYs in:
- xMII interface
- MACSEC
- IEEE-1588 v2 (PTP)
- Syn-E (not sure what this is)
- Thermal Sensor

> Problem of merging the both drivers would be the verification of the old
> devices
>
> for which I do not have a test environment. I can't deliver code without
> testing,
According to the GPY111 and GPY112 product pages the status is
"Active" ("PARTS & PURCHASING" tab).
quote from the same tab:
"Active - the part is released for sale, standard product."

I believe that these are rebranded Lantiq PHYs:
GPY111 and GPY112 are using PHYID register values which are compatible
with the intel-xway driver.
So I think you can use these PHYs for testing

Also people from the OpenWrt community (for example: me, possible also
Aleksander and Hauke) can help testing on existing hardware

[...]
> We will check for options and need approval from company, but this will
> not be
>
> possible short term within this merge window.
I hope that it is possible with GPY111 and/or GPY112 as mentioned above

> For now, can I upstream this new driver first, and merge the old driver
> into new one later?
My answer to this question depends on the actual differences between
the "old" and "new" PHYs.
For example: if WoL and LED configuration are (mostly) identical then
personally I vote for having one driver from the beginning


Best regards,
Martin


[0] https://www.maxlinear.com/products/connectivity/wired/ethernet/ethernet-transceivers-phy
[1] https://www.maxlinear.com/product/connectivity/wired/ethernet/ethernet-transceivers-phy/gpy111
