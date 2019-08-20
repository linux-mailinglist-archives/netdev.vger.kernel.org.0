Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14C6A96986
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 21:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730689AbfHTTg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 15:36:56 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:35053 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729833AbfHTTg4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 15:36:56 -0400
Received: by mail-ed1-f67.google.com with SMTP id t50so72285edd.2;
        Tue, 20 Aug 2019 12:36:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ssVD5/TzJgfMACz5kPlsQVhEOA3I+2lHkW03mTYu31M=;
        b=TA2vEXPpAza5KHjgAN2Gf9naHEdL2ay+D9lvygTcpaJYp2LYiaQ/J/QuE/cArxI5tY
         MV9OJd7tbvacNaZGK07GLxHd6adz+pXy+mEFvwjVQX4Ikspe08+RymDZbh5sC6QLK4T5
         w6thbhR8jh2BDazODvf/s3qJKNZK8CUlkAS02eglvbBxEgc1gsBGtSXiqeVjnceTTgGu
         1JGUFEbUjGLsv3mmfuCVoBHHwDrF2zLuihBgQHamrAl+VtUYYihDOp1NM/U8ls6o/NOK
         tpJQZhYE6xY6lIoTP8HT/87IDcoCT9ff4VBHLGDW/ismN3GM3vFBZicReWa81KJmpdxK
         S0KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ssVD5/TzJgfMACz5kPlsQVhEOA3I+2lHkW03mTYu31M=;
        b=p9t4JdhBUYE2t3jNBGL85IqLDxR+4dmFActT+zGX2Kf3NXAwPV4BjVSly9f2pGnwww
         kchX3qYq6zRTn5M8f19H5dMsEsiLRJc9XaLtaxomeskBIvsxq6PAEstgk18lNPFFAxzs
         vPfo6sWCf3X+FvvoNQ5whzqL5WiCmAnKPiuLwbuGceWDSVcBMA78JY/WnwGPKZJCOzET
         4vKHorl+LVkzgzPjbcxkFiszmy+iDeFzE/RBAgWY4+mFho/A9u+FZq6eqRGXIY5Sx9EG
         FEQVZ3JXEp+8926MtdRGbTtj5xMNEbKi8E5nEkOLrWmK4HWgJW69cu6kxcRIqzJcxy7L
         Yu7g==
X-Gm-Message-State: APjAAAXoZLA/KSerzluF6x4OK05MspqnNWhx6mWg0bWfnvHK7z3veoXd
        EIS2+OxQEnreMmZK7Iw3d9H7y33UipIWExMcazE=
X-Google-Smtp-Source: APXvYqw132PL3++2GpKPNO1956fNnG9ZyrqF3cLIcwniOSzE9Gexb8xeRGB0/NKnjk/5d38XyhsD1kP5ct0Q3d1MAaA=
X-Received: by 2002:a17:906:1484:: with SMTP id x4mr274147ejc.204.1566329814479;
 Tue, 20 Aug 2019 12:36:54 -0700 (PDT)
MIME-Version: 1.0
References: <20190818182600.3047-1-olteanv@gmail.com> <20190818182600.3047-2-olteanv@gmail.com>
 <20190820182128.GH4738@sirena.co.uk>
In-Reply-To: <20190820182128.GH4738@sirena.co.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 20 Aug 2019 22:36:43 +0300
Message-ID: <CA+h21hpgi7-dJ-QoRBEQorcRyEuhqhKixpFK5fGxOnZxTHi-4g@mail.gmail.com>
Subject: Re: [PATCH spi for-5.4 1/5] spi: Use an abbreviated pointer to
 ctlr->cur_msg in __spi_pump_messages
To:     Mark Brown <broonie@kernel.org>
Cc:     Hubert Feurstein <h.feurstein@gmail.com>, mlichvar@redhat.com,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-spi@vger.kernel.org, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mark,

On Tue, 20 Aug 2019 at 21:21, Mark Brown <broonie@kernel.org> wrote:
>
> On Sun, Aug 18, 2019 at 09:25:56PM +0300, Vladimir Oltean wrote:
>
> >       /* Extract head of queue */
> > -     ctlr->cur_msg =
> > -             list_first_entry(&ctlr->queue, struct spi_message, queue);
> > +     mesg = list_first_entry(&ctlr->queue, struct spi_message, queue);
> > +     ctlr->cur_msg = mesg;
>
> Why mesg when the existing code uses msg as an abbreviation here?

Does it matter? I took from spi_finalize_current_message which also uses mesg.
