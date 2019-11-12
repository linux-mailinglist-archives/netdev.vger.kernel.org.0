Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C237BF9115
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 14:53:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727362AbfKLNxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 08:53:04 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:35854 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbfKLNxD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 08:53:03 -0500
Received: by mail-ed1-f65.google.com with SMTP id f7so14974942edq.3
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 05:53:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=F6hTFtvbCS9Rrf/QydOMqYK3BwvfL9UyV16fF7L9MzU=;
        b=dNU2oGuXtu/k7U4ZX9iHlRojJrVqZEO5n9ni38BgZ9A/qVnOxvM0/C8GL58mlfazuP
         S4F4zjbtdqWXffhYykBkpJ20Xfu9NilgpGvqwC5RVmwwjSptuol9K0EDprbQLR5Gc87B
         Z9RKQBTEh/d3Bf/L/t4uPxCuYbUsvaVnzJIzaBXCpevhWj5afSME6AQ+71hXredXBrIy
         bTQ9znmzJS8SnVi/yBG+o7Pleks3jgvx1A/SZ3kNar+5ZPeS9JNf73qrb8hM1FM73uvE
         FkVpsuMi5xTZmiQAF20T2y6Y484vd0uL8+uWZYQVYS+GnALUMEv0y+1D9u6Q/VM5BjdB
         jHQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F6hTFtvbCS9Rrf/QydOMqYK3BwvfL9UyV16fF7L9MzU=;
        b=A8Xe7rtSdGNPuzytMVQVL5JidtVdFPrjSapsmYGImRnRuj5Z78QhrGDMoWJKNs6Zs2
         ++wU+j/laL4/trZM8kvoElt+zOANZerAt5b1p20+bcLG9O0WIQroo721vLihguQ8v7P+
         Y+QBcdNSMWckltv7xSMFzTbcE3zNQDOxD9LLjPGx7rCCJ5FvWJqLmvPMAat7NvLe8Ssq
         wkg7K9V80a9rN88BpZUEYH56ZGDSg81l0HnQ8wonsSnW8mvOgy+YMu5DlWCOd+zOjPF+
         lj4+S3endgoXHVwo9JJ8iaPtFh3Gs7famSBP80vyHmrj+ihNWrGw+UKwxkrkA0UgxoY5
         N9oQ==
X-Gm-Message-State: APjAAAXibbAewX+VtIWeqbGmFf2+J+CjwzyG+1+OqbNTT7/syxZ7/XeD
        rbhY4IHoQ/nqbD3Emhg6f0YtMbBQNwgu6XMoQ1E=
X-Google-Smtp-Source: APXvYqzSYeCpGrgUV1sTT+uCK5AF7jo31YP+WIR9jvtens+aGfx3tzHkP8CL91DSXrW0H5auyrOq+n3tLpUhajyUKPs=
X-Received: by 2002:a50:91c4:: with SMTP id h4mr33264048eda.36.1573566782658;
 Tue, 12 Nov 2019 05:53:02 -0800 (PST)
MIME-Version: 1.0
References: <20191112124420.6225-1-olteanv@gmail.com> <20191112124420.6225-7-olteanv@gmail.com>
 <20191112135107.GH5090@lunn.ch>
In-Reply-To: <20191112135107.GH5090@lunn.ch>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 12 Nov 2019 15:52:51 +0200
Message-ID: <CA+h21hrb9pc6q9EwjCeApQ0TmC--0s9RT31f640cQ1sxiKtUqw@mail.gmail.com>
Subject: Re: [PATCH net-next 06/12] net: mscc: ocelot: adjust MTU on the CPU
 port in NPI mode
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Nov 2019 at 15:51, Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Tue, Nov 12, 2019 at 02:44:14PM +0200, Vladimir Oltean wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> > When using the NPI port, the DSA tag is passed through Ethernet, so the
> > switch's MAC needs to accept it as it comes from the DSA master. Increase
> > the MTU on the external CPU port to account for the length of the
> > injection header.
>
> I think this is the only DSA driver which needs to do this. Generally,
> the port knows it is adding/removing the extra header, and so
> magically accepts bigger frames.
>
> Where i have seen issues is the other end, the host interface. It
> sometimes drops 'full MTU' frames because the DSA header makes the
> frame too big.
>

No, that worked out of the box because DSA adjusts the MTU of the
master interface by the amount of bytes specified in the overhead of
the tagger.

> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
>
>     Andrew
