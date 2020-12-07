Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 476AC2D19E0
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 20:42:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726499AbgLGTl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 14:41:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbgLGTl5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 14:41:57 -0500
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48C4BC061793
        for <netdev@vger.kernel.org>; Mon,  7 Dec 2020 11:41:17 -0800 (PST)
Received: by mail-il1-x143.google.com with SMTP id v3so13346385ilo.5
        for <netdev@vger.kernel.org>; Mon, 07 Dec 2020 11:41:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=newoldbits-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zYJcT4hetYL0tKq9XSHGQkMfsmmcPjbj08++qXmaLCM=;
        b=tlLC68iK8/I/THqmaQXIaoQOQrE/ecLEdQS+XINmXM3dTf2eOjXQLPBIuos5p8vsS+
         neSdG2DpBL7mxDNw6tzUBtMAja0R9XFS/6uF1NDnAUL5SdaTK+qEsmBaxLdQosZnjKXB
         EKdvegPEYvpZtvl6TIYbQr+M4SZORKenIW3lzqsRjuXeNLgZxpiw5UNnRgl1n92Ac1RS
         vlfk3hF2hh25s8tG6EFo+KIJbcEvP9Ou1rr7Uh3v1i8qR1vEgdOs9jeGZDlDKlfS11Qv
         ht+MJyi+M7ulLv3mRU67gOomblnSmoFcCWu17MVA4qKuMruBpJhsfWUdd0skLnM1/Sso
         tGrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zYJcT4hetYL0tKq9XSHGQkMfsmmcPjbj08++qXmaLCM=;
        b=llBlN7EI9ejfBrw79VJZGld7fgIFaK38KY59sNGEMVEgVnjiKgpShzNRuZaaoKGeca
         Vu83pSf1SJbPcfnoVIvnUeR28js3hQXoqVTtumzpybJVfeiC26/yLr9uVcUd6AvsL32m
         ipjLFArgk2FaS30JRHHXTV8S6paP7OcmTX63ApCDcTMDewUzmpPB1IFYlrI+zVXf8DCp
         rqx/+nOnTnBr1LgV0f65fyugmDCLums78CCsR0iGn1kAMSk6maDY2Wg8cxSqH1OTem8+
         Xkq/HufGKym389B+lakyLQr5pJtG4g9yx+vYp16R1y/1n0Jn/Xxga1LDuYRuAZan6+je
         BEgA==
X-Gm-Message-State: AOAM533S26OSHqQm2chUgThZ+6pMH23at2sbcFL25GHLdZxaUbV1mrLH
        KWG/wHyrDL906MImJR/jQ/i2AKf590nBVfhig50b4g==
X-Google-Smtp-Source: ABdhPJw07PSB4YyIs3KMeAufuOw+D5vgUuqY57Hc8lSSbaw3ooS9fotF8itkZSUBuD7KmfK0LaQNPdkro1uTDRNSZZE=
X-Received: by 2002:a92:130e:: with SMTP id 14mr23031339ilt.281.1607370076640;
 Mon, 07 Dec 2020 11:41:16 -0800 (PST)
MIME-Version: 1.0
References: <20201201083408.51006-1-jean.pihet@newoldbits.com>
 <20201201184100.GN2073444@lunn.ch> <CAORVsuXv5Gw18EeHwP36EkzF4nN5PeGerBQQa-6ruWAQRX+GoQ@mail.gmail.com>
 <20201201194819.ygmrdwcpvywkszat@skbuf>
In-Reply-To: <20201201194819.ygmrdwcpvywkszat@skbuf>
From:   Jean Pihet <jean.pihet@newoldbits.com>
Date:   Mon, 7 Dec 2020 20:41:05 +0100
Message-ID: <CAORVsuWFiTo0-cX-8vbPh+bYvNyTM6NiFPaM5fij9bO4pWymyA@mail.gmail.com>
Subject: Re: [PATCH v2] net: dsa: ksz8795: adjust CPU link to host interface
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Ryan Barnett <ryan.barnett@rockwellcollins.com>,
        Conrad Ratschan <conrad.ratschan@rockwellcollins.com>,
        Hugo Cornelis <hugo.cornelis@essensium.com>,
        Arnout Vandecappelle <arnout.vandecappelle@essensium.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Tue, Dec 1, 2020 at 8:48 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> Hi Jean,
>
> On Tue, Dec 01, 2020 at 07:58:01PM +0100, Jean Pihet wrote:
> > Hi Andrew,
> >
> > On Tue, Dec 1, 2020 at 7:41 PM Andrew Lunn <andrew@lunn.ch> wrote:
> > >
> > > On Tue, Dec 01, 2020 at 09:34:08AM +0100, Jean Pihet wrote:
> > > > Add support for RGMII in 100 and 1000 Mbps.
> > > >
> > > > Adjust the CPU port settings from the host interface settings: interface
> > > > MII type, speed, duplex.
> > >
> > > Hi Jean
> > >
> > > You have still not explained why this is needed. Why? is always the
> > > important question to answer in the commit message. The What? is
> > > obvious from reading the patch. Why does you board need this, when no
> > > over board does?
> >
> > I reworked the commit description about the What and thought it was
> > enough. Do you need a cover letter to describe it more?
> >
> > The Why is:
> > "
> > Configure the host port of the switch to match the host interface
> > settings. This is useful when the switch is directly connected to the
> > host MAC interface.
> > "
> > Thank you for reviewing the patch.
>
> First of all, I am not clear if you want the patch merged or not. If you
> do, then I don't understand why you did not use the ./scripts/get_maintainer.pl
> tool to get the email addresses of the people who can help you with
> that. No one from Microchip, not the DSA maintainers, not the networking
> maintainer.
My bad, I thought that sending to both LKML and netdev was enough.

>
> Secondly, don't you get an annoying warning that you should not use
> .adjust_link and should migrate to .phylink_mac_link_up? Why do you
> ignore it? Did you even see it?
No there is no warning using my arm config, both with linux and netdev kernels.

>
> Thirdly, your patch is opaque and has three changes folded into one. You
> refactor some code from ksz8795_port_setup into a separate function, you
> add logic for the speeds of 100 and 10 for RGMII, and you call this
> function from .adjust_link. You must justify why you need all of this,
> and cannot just add 3 lines to ksz8795_port_setup. You must explain that
> the ksz8795_port_setup function does not use information from device
> tree. Then you must explain why the patch is correct.
> The code refactored out of ksz8795_port_setup, plus the changes you've
> added to it, looks now super weird. Half of ksz8795_mii_config treats
> p->phydev.speed as an output variable, and half of it as an input
> variable. To the untrained eye this looks like a hack. I'm sure you can
> clarify. This is what Andrew wants to see.

Ok taking notes here, thanks for the valuable input.

>
> Fourth, seriously now, could you just copy Microchip people to your
> patches? The phylink conversion was done this summer, I'm sure they can
> help with some suggestions.
Ok will do, and check the phylink conversion code.

Thank you for reviewing.

BR,
Jean
