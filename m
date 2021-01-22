Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC0012FFA4E
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 03:12:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbhAVCLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 21:11:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726601AbhAVCLL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 21:11:11 -0500
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76A6AC0613D6
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 18:10:29 -0800 (PST)
Received: by mail-vs1-xe32.google.com with SMTP id w187so2236137vsw.5
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 18:10:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IPV6PmbYU2gwkanIK2+z9F2DbEY+8hcpTu/drzyeUqQ=;
        b=P2vdFRdQ129SlJTrxq5hPPT5YvVn+xEtZ0ly6HcBuBxMz9VrBgUKfBWT1s1TJat52q
         b9tDan7ScdtnWNAwwLqXTbb5NJA2D00KxYQpYkaEmzmARpeD2rtdelIsJ7D7MPKZXRuG
         eg46T71ee2lgihM3wNqSbQsfKIv158NTseFt4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IPV6PmbYU2gwkanIK2+z9F2DbEY+8hcpTu/drzyeUqQ=;
        b=FIPbMPygDNBp6tqibVG3q1Rke6ko60obm23bwRQ95cLv4L04I8AYLv8B9FqIO+g2jv
         cz9wxgQfvVRajgWIj6XF+WVkMefOvmF5KJ+s8WibkC/0in85K4j/+oUpUoAw82ZxkA26
         RUsnTyNrtR7asDfoYBiNq1BlP4RUa7VkZX8wyexSIL7kdEXAz/0cj0UlzIyfMUmEIDnw
         /vn5Jq2aWgizqdtIvucWMsM9mLRFLubXU2d4/c1aW+sHPe0QlP5B9kdOdhc9vT/JVe9i
         W2aOK8YbL5nFmmoGN7JIAzWGz+Ocs+2XLuO6u86wog7Q3Xean6YOEOlicwBl0GJHPvbi
         jhFQ==
X-Gm-Message-State: AOAM532c7lifys8h64GM3vTlF47NdhU1cHgK8VlyS28m4pWAeSjK7raF
        l/kYKB3bwDvmxTDNKFwUeJbpkHGF9MB7Zatx8Wq/yw==
X-Google-Smtp-Source: ABdhPJwftGhTAEkd3ofI2fb+kV1jWpvn0D6bzVLuF3TPqxg6o+Rd5AcJ6qsP+3xf96d6Cx+PWmeb8CFKYxRUxt27AdE=
X-Received: by 2002:a05:6102:1276:: with SMTP id q22mr1609759vsg.20.1611281428351;
 Thu, 21 Jan 2021 18:10:28 -0800 (PST)
MIME-Version: 1.0
References: <20210121125731.19425-1-oneukum@suse.com> <YAoqXZJVhRDiRI+9@lunn.ch>
In-Reply-To: <YAoqXZJVhRDiRI+9@lunn.ch>
From:   Grant Grundler <grundler@chromium.org>
Date:   Fri, 22 Jan 2021 02:10:17 +0000
Message-ID: <CANEJEGs7VQ4N9OgtDJ0k7DqgqruwpEm7LZ07UUdD3PGepLeLHg@mail.gmail.com>
Subject: Re: [PATCHv2 0/3] usbnet: speed reporting for devices without MDIO
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Oliver Neukum <oneukum@suse.com>,
        Hayes Wang <hayeswang@realtek.com>,
        Grant Grundler <grundler@chromium.org>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, linux-usb@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 22, 2021 at 1:29 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Thu, Jan 21, 2021 at 01:57:28PM +0100, Oliver Neukum wrote:
> > This series introduces support for USB network devices that report
> > speed as a part of their protocol, not emulating an MII to be accessed
> > over MDIO.
> >
> > v2: adjusted to recent changes
>
> Hi Oliver
>
> Please give more details what actually changed.  Does this mean you
> just rebased it on net-next? Or have you made real changes?

My apologies to Oliver - the changes he's referring to are the ones I submitted:
   https://www.spinics.net/lists/netdev/msg715248.html

which is related to this series:
   https://www.spinics.net/lists/netdev/msg714493.html

I wasn't aware of and didn't look for the series Oliver had previously
posted. *sigh*  I have been talking to Realtek about getting the issue
of RTL8156 spewing notifications every 32ms fixed (thinking a FW
change could fix it) for nearly three months.  It is unfortunate
timing that Roland Dreier decided to do something about it in December
- which I didn't expect to happen given this problem was reported
nearly two years ago.

> The discussion with v1 suggested that this framework should also be
> used by anything which gets notified in CDC style. So i was expecting
> to see cdc_ether.c also use this.

Agreed. That's a two lines change to cdc_ether.c. I can submit this if
Oliver doesn't want to spin the series.

I've reviewed all three patches and besides one nit (which could be
ignored or fixed later), I'm offering my
   Reviewed-by: Grant Grundler <grundler@chromium.org>

in the off chance that helps get this accepted into net-next (and/or
5.11 RC release).

cheers,
grant

>
>             Andrew
