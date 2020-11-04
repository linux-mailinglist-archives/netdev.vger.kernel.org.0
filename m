Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3EDA2A6A01
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 17:40:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731067AbgKDQj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 11:39:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729081AbgKDQj7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 11:39:59 -0500
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E080CC0613D3;
        Wed,  4 Nov 2020 08:39:58 -0800 (PST)
Received: by mail-vs1-xe44.google.com with SMTP id b129so11834279vsb.1;
        Wed, 04 Nov 2020 08:39:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a6DTwSAQkFfpIa5MUZdryepAOiGExl2mvc+eSaUHwKs=;
        b=r4HZN7lC0Y21M3MrpX4kaDk3STCeV/fbM5YWsfdFHTjEWMMncza2Mdq3EYxeP/45AO
         4+NuCy759H5SSvcKz9LX+hwNlItLJ6gmnmATCozLIR4wNgFJCFkztMVQpEgiIJWgn1gK
         ed+ldKCW053UsKll2FEKboUEBXLgbg+wg3CH+U3IAHY9u3AJUpCWNEzJSxGk1bhEwyo6
         U3fkiTkb/G3/v7xTCnjtk+/H9yqw+loyzt3MvyNvCY9ZhJ2Y4CNEGNU4a7oGKqhhSBkT
         c72OCv9aEiPKufaxKP1308wrvJ0lM6jGq8YEeFYRmyis5q6bpOs8nFglo4hHsSeRUzG7
         QFxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a6DTwSAQkFfpIa5MUZdryepAOiGExl2mvc+eSaUHwKs=;
        b=XSqipurXdj3ls0qUxmkRCdkGto3BusckVP2H7zae4Tkbhf3GqW6G+J/ANKyj+HP2Lf
         HMC/ZSvCKBrBDOuVT7xRgXxW5pOS5iHJc37hSG2xZdLOUIym9M63RpZn1vyQ+XxAnosY
         teXu8nUq+tGB+D4wWY/0PkYJ3bGC6iulVQN6R8aqLdC5tHtP36xYIkFa6n3FBU6uBd55
         9zfhchXUjJtMhC2WenhHO5C8dRMw6uCRSjC2jBdbSxDSvp11mBs3kXfmVosKcUO120YO
         u0fMOuwZ24KAk0YSy6wgE5YBv/6Nvgb/LjTwKbnBh86jm7mcx9kA6IdABFsKZEK8R0j9
         SuuQ==
X-Gm-Message-State: AOAM5339EpRJgWWACaiAITDG6ADifpo7/mDgEx7J1xK0rK0epEchtQlY
        gm77+ID5+FPMBoQ3OKGIpkn2bddeFOhjzGuMNZ8=
X-Google-Smtp-Source: ABdhPJxTAYVmV+Fsx6gWBA16LWcVlx7U9UG8tJSTMpCitxIFqH0Q8jbATyd9XIjKNugtIS5i4RF2aHNConMluveV1pQ=
X-Received: by 2002:a67:2ac1:: with SMTP id q184mr22197716vsq.57.1604507998057;
 Wed, 04 Nov 2020 08:39:58 -0800 (PST)
MIME-Version: 1.0
References: <20201104160847.30049-1-TheSven73@gmail.com> <20201104162734.GA1249360@lunn.ch>
In-Reply-To: <20201104162734.GA1249360@lunn.ch>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Wed, 4 Nov 2020 11:39:47 -0500
Message-ID: <CAGngYiUtMN0nOV+wZC-4ycwOAvU=BqhdP7Z3PUPh2GX8Fvo3jg@mail.gmail.com>
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

Hi Andrew, many thanks for looking at this patch !

On Wed, Nov 4, 2020 at 11:27 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > Note that as a side-effect, the devicetree phy mode now no longer
> > has a default, and always needs to be specified explicitly (via
> > 'phy-connection-type').
>
> That sounds like it could break systems. Why do you do this?

Because the standard mdio library function (of_phy_get_and_connect())
does not appear to support a default value. The original driver
code duplicated that library function's code, with a slight
tweak - the default value.

The default value was introduced quite recently, in the commit which
this patch fixes:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/drivers/net/ethernet/microchip/lan743x_main.c?h=v5.9.3&id=6f197fb63850b26ef8f70f1bfe5900e377910a5a

I'm not sure if other devices that specify phys in devicetrees have a
default for 'phy-connection-type'. I'm wondering if any do?
