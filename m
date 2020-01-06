Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2C401318FC
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 21:03:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbgAFUDU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 15:03:20 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:37207 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726569AbgAFUDU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 15:03:20 -0500
Received: by mail-il1-f194.google.com with SMTP id t8so43617997iln.4
        for <netdev@vger.kernel.org>; Mon, 06 Jan 2020 12:03:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hfA6s3NarKYGLzFGZq8HGLv1/a38tEXGKQGZpJX4POU=;
        b=nw4NVzLFPzkVuFaRrtXPWimSlPsWGKO6IE06Fzf+S8KrzOa62x4j4dnGITzsRgNBn/
         JduI0Ec6BSN6hw5R6jUnpEcJ+TN1Ui/24rXu3uI1jiuAhRBP7I9P1vUPGW3+tRBFfkKU
         BSSZaWgGumfAHdi3X3WdHUCyJYvcL/0sfxStf/sGWkuYJaFmEZYfnbofxYkw8+vnxNzi
         4Ng90Ugr+8Zr4f3jPE+6rHxa3w5e8weXvURzX52Wi5DYzfo+8P2gBdDOg7zf7025vgHQ
         KqBAwpTUAtqgKdJMf0yE4OEjUOvaw+P+kxE4VL6zK3IcsfktNP5cLJSQEpUttj87Q89s
         5XLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hfA6s3NarKYGLzFGZq8HGLv1/a38tEXGKQGZpJX4POU=;
        b=CwwUZ00C43qmX6unqk5k03BLVXbRkiylcsbmg0VJimSQsgEktjsY8OFcYDtSDmanl7
         wfA3VK/RsheIE6lhscpnV0LZ1atbbmXrGF9SpBdhiHx/SEWeyQyz4udBXsVqtFwpsN+G
         /GrQHvQJ/DmFG65s2roFKiIIgJtnrOSiT0tWKP8Qu7oLMmdNOBJ3K98Najov61fs6Thq
         OfXv13O3INt6r/+jTYU9Sq2awoCwLmL166HF62/Qdl0fRC3+pIeRGya3cYPH/noyO9ld
         wQAEfxzNVIQj4DS4VZB4zNaoHWIYYYuconfd7suiguythtGlEfSO/VZslNewNV+ZnlUL
         gD7g==
X-Gm-Message-State: APjAAAXY4VvTNGBjRbuzqhiyNLvhrCNKxMAhRJPTm4sR/THrtPDDWGqW
        iJltbycdyh90ki7t+MxhyaZ5Du2BnBKbC/sRp+0=
X-Google-Smtp-Source: APXvYqzhC0DqaCpx48OOAPhYk84asmy+m6q/P/ZZXZSxMfQiF3UYat9X7FHISk1uGUpdULMFlPx+FeNH1sJ/1Zo0+Jw=
X-Received: by 2002:a92:b65b:: with SMTP id s88mr89781896ili.171.1578340999420;
 Mon, 06 Jan 2020 12:03:19 -0800 (PST)
MIME-Version: 1.0
References: <20200106161352.4461-1-andrew@lunn.ch>
In-Reply-To: <20200106161352.4461-1-andrew@lunn.ch>
From:   Chris Healy <cphealy@gmail.com>
Date:   Mon, 6 Jan 2020 12:03:08 -0800
Message-ID: <CAFXsbZrTYjhvja4+-X9hmWGX1-GShXt_SmjgRydN1OTmGS+xmQ@mail.gmail.com>
Subject: Re: [PATCH net-next 0/5] Unique mv88e6xxx IRQ names
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Series is:

Tested-by: Chris Healy <cphealy@gmail.com>

On Mon, Jan 6, 2020 at 8:14 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> There are a few boards which have multiple mv88e6xxx switches. With
> such boards, it can be hard to determine which interrupts belong to
> which switches. Make the interrupt names unique by including the
> device name in the interrupt name. For the SERDES interrupt, also
> include the port number. As a result of these patches ZII devel C
> looks like:
>
>  50:          0  gpio-vf610  27 Level     mv88e6xxx-0.1:00
>  54:          0  mv88e6xxx-g1   3 Edge      mv88e6xxx-0.1:00-g1-atu-prob
>  56:          0  mv88e6xxx-g1   5 Edge      mv88e6xxx-0.1:00-g1-vtu-prob
>  58:          0  mv88e6xxx-g1   7 Edge      mv88e6xxx-0.1:00-g2
>  61:          0  mv88e6xxx-g2   1 Edge      !mdio-mux!mdio@1!switch@0!mdio:01
>  62:          0  mv88e6xxx-g2   2 Edge      !mdio-mux!mdio@1!switch@0!mdio:02
>  63:          0  mv88e6xxx-g2   3 Edge      !mdio-mux!mdio@1!switch@0!mdio:03
>  64:          0  mv88e6xxx-g2   4 Edge      !mdio-mux!mdio@1!switch@0!mdio:04
>  70:          0  mv88e6xxx-g2  10 Edge      mv88e6xxx-0.1:00-serdes-10
>  75:          0  mv88e6xxx-g2  15 Edge      mv88e6xxx-0.1:00-watchdog
>  76:          5  gpio-vf610  26 Level     mv88e6xxx-0.2:00
>  80:          0  mv88e6xxx-g1   3 Edge      mv88e6xxx-0.2:00-g1-atu-prob
>  82:          0  mv88e6xxx-g1   5 Edge      mv88e6xxx-0.2:00-g1-vtu-prob
>  84:          4  mv88e6xxx-g1   7 Edge      mv88e6xxx-0.2:00-g2
>  87:          2  mv88e6xxx-g2   1 Edge      !mdio-mux!mdio@2!switch@0!mdio:01
>  88:          0  mv88e6xxx-g2   2 Edge      !mdio-mux!mdio@2!switch@0!mdio:02
>  89:          0  mv88e6xxx-g2   3 Edge      !mdio-mux!mdio@2!switch@0!mdio:03
>  90:          0  mv88e6xxx-g2   4 Edge      !mdio-mux!mdio@2!switch@0!mdio:04
>  95:          3  mv88e6xxx-g2   9 Edge      mv88e6xxx-0.2:00-serdes-9
>  96:          0  mv88e6xxx-g2  10 Edge      mv88e6xxx-0.2:00-serdes-10
> 101:          0  mv88e6xxx-g2  15 Edge      mv88e6xxx-0.2:00-watchdog
>
> Interrupt names like !mdio-mux!mdio@2!switch@0!mdio:01 are created by
> phylib for the integrated PHYs. The mv88e6xxx driver does not
> determine these names.
>
> Andrew Lunn (5):
>   net: dsa: mv88e6xxx: Unique IRQ name
>   net: dsa: mv88e6xxx: Unique SERDES interrupt names
>   net: dsa: mv88e6xxx: Unique watchdog IRQ name
>   net: dsa: mv88e6xxx: Unique g2 IRQ name
>   net: dsa: mv88e6xxx: Unique ATU and VTU IRQ names
>
>  drivers/net/dsa/mv88e6xxx/chip.c        | 11 +++++++++--
>  drivers/net/dsa/mv88e6xxx/chip.h        |  6 ++++++
>  drivers/net/dsa/mv88e6xxx/global1_atu.c |  5 ++++-
>  drivers/net/dsa/mv88e6xxx/global1_vtu.c |  5 ++++-
>  drivers/net/dsa/mv88e6xxx/global2.c     | 10 ++++++++--
>  5 files changed, 31 insertions(+), 6 deletions(-)
>
> --
> 2.25.0.rc1
>
