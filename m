Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69E7614BD22
	for <lists+netdev@lfdr.de>; Tue, 28 Jan 2020 16:41:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbgA1Plo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jan 2020 10:41:44 -0500
Received: from mail-ed1-f47.google.com ([209.85.208.47]:43851 "EHLO
        mail-ed1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726384AbgA1Plo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jan 2020 10:41:44 -0500
Received: by mail-ed1-f47.google.com with SMTP id dc19so15097310edb.10
        for <netdev@vger.kernel.org>; Tue, 28 Jan 2020 07:41:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cPm9vyFsLaXH3plg0BdGuzklrtZJFmGMvh1LbsmGIK4=;
        b=APN+6FDoFfWErw3nwkRdcBERMUMzmmoXKqO7UigoZb6eHkin5iGlVl6J8du0QncvRy
         w4UV+EyUz++qIi0hQng9cIc0NKtlR7gvLLCd6FlG86CgKmsQVZD0nOm9JL233P0unxqb
         hNzKbSrTnGsacB6753EVfoUqJ/0QJvIsJwyDwnZHN4YQKkS6VV7LJFMDAXBbWenvCevT
         EBpKHzIlOPCwJIp+KMYypIYiy54dSN+npAuyYJPlBe1V8htxRqKswZNUlstYG9XXr0MJ
         8T0kEnDGBwTX9cSXz8K320kArfmGp5hOX+xH/J6oXBgP9Ur4J37Mm2E5PbazRU8NNsHb
         9l5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cPm9vyFsLaXH3plg0BdGuzklrtZJFmGMvh1LbsmGIK4=;
        b=XNwvY0k47I+jBVZ81qdjNqzIfHbONIqqCmTr7sxIOsZtYEb5Z3X9tYEDLKpX17T3K8
         w5RSR7PnZWbbg+13jVnyhlWKphqFtyddOVigxBfdtkXgXIXBz4aXbLX2eUnYyED9pGd/
         lRAh23opHniW8ffnrhj0jkxMZKShH0Cj0SmURMLw4M9tAm//soGjLbnVDoCkEmBCuDFG
         OKvlByiiwABKjxQdOYWP7s6knXMhCLT3aETUiwHT/J8DHrqBd1qKhUjfFtfy5Bjmx91l
         jrbyhHsq+fVKuSIPE6v91/o6MBvvzKWYNmYTZPm4Bi9KExX1r1c2SNNLvJxaW2DwKXIt
         1xVA==
X-Gm-Message-State: APjAAAWA3hR7dRNej9zDdhyLVn8NUFna1eMXMwg0z5/iKVaKBh4QCl98
        aB9/g9aglRjc46teyTG7bD0kiMP8EZzkz70Ppyc=
X-Google-Smtp-Source: APXvYqxhkRGX/gJY9xbXZJXsE6ppTZ/+niZjQtz80+/AWe9ubuKU3ZBpIN4rqzwwu3peYCkS8rYMkqyOVGkogeRMHQw=
X-Received: by 2002:a05:6402:3132:: with SMTP id dd18mr4036661edb.118.1580226102191;
 Tue, 28 Jan 2020 07:41:42 -0800 (PST)
MIME-Version: 1.0
References: <1580137671-22081-1-git-send-email-madalin.bucur@oss.nxp.com>
 <1580137671-22081-3-git-send-email-madalin.bucur@oss.nxp.com>
 <CA+h21hqzR72v9=dWGk1zBptNHNst+kajh6SHHSUMp02fAq5m5g@mail.gmail.com> <20200127160413.GI13647@lunn.ch>
In-Reply-To: <20200127160413.GI13647@lunn.ch>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 28 Jan 2020 17:41:31 +0200
Message-ID: <CA+h21hoZVDFANhzP5BOkZ+HxLMg9=pcdmLbaavg-1CpDEq=CHg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] dpaa_eth: support all modes with rate adapting PHYs
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     madalin.bucur@oss.nxp.com, "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>, ykaukab@suse.de
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Mon, 27 Jan 2020 at 18:04, Andrew Lunn <andrew@lunn.ch> wrote:
>
> > Is this sufficient?
> > I suppose this works because you have flow control enabled by default?
> > What would happen if the user would disable flow control with ethtool?
>
> It will still work. Network protocols expect packets to be dropped,
> there are bottlenecks on the network, and those bottlenecks change
> dynamically. TCP will still be able to determine how much traffic it
> can send without too much packet loss, independent of if the
> bottleneck is here between the MAC and the PHY, or later when it hits
> an RFC 1149 link.

Following this logic, this patch isn't needed at all, right? The PHY
will drop frames that it can't hold in its small FIFOs when adapting a
link speed to another, and higher-level protocols will cope. And flow
control at large isn't needed.

What I was trying to see Madalin's opinion on was whether in fact we
want to keep the RX flow control as 'fixed on' if the MAC supports it
and the PHY needs it, _as a function of the current phy_mode and maybe
link speed_ (the underlined part is important IMO).

>
>     Andrew
>

Thanks,
-Vladimir
