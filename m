Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77DEA2A6B71
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 18:10:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731330AbgKDRKp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 12:10:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731090AbgKDRKp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 12:10:45 -0500
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0390EC0613D3;
        Wed,  4 Nov 2020 09:10:45 -0800 (PST)
Received: by mail-vs1-xe42.google.com with SMTP id b3so11882331vsc.5;
        Wed, 04 Nov 2020 09:10:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w/TI0h5kA8xnp2MjFDz/KpTULt58Y87+u3TWyNSEhKc=;
        b=H6Clz4e2VWSAxLuKi2tOcipA/qGCKHVG65DtJMaFFLXk58sqM012pYTe46jC46fjc/
         ObSZ9QDUu2RQivtaTXfNlu5Y9Ee2h6Wi1/4pr8WjxtHJhQ4Qw9o2cpFt76U0PfL41ua8
         Oaf6hdc+yhsJx8F8ewYx0t16090aVPgZl/pG0xt0UV4Ta/IqKEtnN8+UiqAMHddKs05O
         Mu8J1rSH5239IMNtdWOf3UIYWfe48+AF6flu5yVD5YKVf/qwFZs0GFCMVag1XM6ryRjR
         X/unG2egbg4oG7xRdOq35XoTb/lQoIAfmK9SVlqDP4nNE06mNBnc7prZNIfeU8OY2okk
         Ie5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w/TI0h5kA8xnp2MjFDz/KpTULt58Y87+u3TWyNSEhKc=;
        b=EGoUmcsCIgNp+INer6WeLyBILGF1RegFXmSzMlss92LTulT5DjKbmC89QvfUhQ402U
         f5sr0ASyp0XQDCUJuo9ncmV/LJwXhIOrX7/PEUL/FuX/89wMjPQxJayc75sa46XJmHw2
         nD/lcQVJRUqrAMUmK2AZIOlhJJ3RpydUfwPJ63fW0oylYHDJ2zHtE4+rOF8t4tVtTE+J
         O+LYSLWYQAKdZn9AgM6WX87KD7dwInpajXUSu67KrXmjl2K2gt4mBV+CEk76MoSvXRzw
         7Nkmcsd2pQuYbHnzcl6/WGh/oVGRzKNNxb5eg0PUmTXTabURyPTYgD4n3LEV5k6ywWQ2
         Sj3A==
X-Gm-Message-State: AOAM5300lj2uO/vVheA7TaL6H7NY74+y/mUkV/78GHE7gDGG6vKQl8gb
        7Ul6N2Q46VzfMSvNX1qOxucnKLzHIxgjuQ9rP+w=
X-Google-Smtp-Source: ABdhPJyiJ37qGglMEBL44iH5BJg3IiyTTKrCL3OzzSbhx2K5W/eJGZzpyXnKzk66PNjTIFP7kiyMEXMAl/4h1fzYwcw=
X-Received: by 2002:a67:2c53:: with SMTP id s80mr11474066vss.12.1604509844212;
 Wed, 04 Nov 2020 09:10:44 -0800 (PST)
MIME-Version: 1.0
References: <20201104160847.30049-1-TheSven73@gmail.com> <20201104162734.GA1249360@lunn.ch>
 <CAGngYiUtMN0nOV+wZC-4ycwOAvU=BqhdP7Z3PUPh2GX8Fvo3jg@mail.gmail.com> <20201104165509.GB1249360@lunn.ch>
In-Reply-To: <20201104165509.GB1249360@lunn.ch>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Wed, 4 Nov 2020 12:10:33 -0500
Message-ID: <CAGngYiWmVr4hVEQgZ74NEbonVnoJjsci7U+bBGFF5v2gg9HpdA@mail.gmail.com>
Subject: Re: [PATCH v1] lan743x: correctly handle chips with internal PHY
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Roelof Berg <rberg@berg-solutions.de>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 4, 2020 at 11:55 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/drivers/net/ethernet/microchip/lan743x_main.c?h=v5.9.3&id=6f197fb63850b26ef8f70f1bfe5900e377910a5a
>
> If you look at that patch, you see:
>
> -       ret = phy_connect_direct(netdev, phydev,
> -                                lan743x_phy_link_status_change,
> -                                PHY_INTERFACE_MODE_GMII);
> -       if (ret)
> -               goto return_error;
>
>
> That was added as part of the first commit for the lan743x
> driver. Changing that now seems dangerous.

My knowledge of netdev/phy is extremely limited, so bear with me.

The code quoted above (the first commit for lan743x) has been reinstated
in my patch. It's literally identical - in the case the kernel can't find any
available/sensible devicetree phy description.

In the case of devicetree phys, which have been added recently,
the 'phy-connection-type' prop appeared to have been optional,
defaulting to (G)MII. My patch removes that devicetree default.

So I guess my question is this - is there really a need for a
devicetree default for 'phy-connection-type'? If not, no code
duplication or mdio refactoring is required.
