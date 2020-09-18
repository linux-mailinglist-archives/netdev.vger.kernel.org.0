Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1165270113
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 17:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726306AbgIRPdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 11:33:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbgIRPdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 11:33:06 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5ADEC0613CE;
        Fri, 18 Sep 2020 08:33:05 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id n25so5455468ljj.4;
        Fri, 18 Sep 2020 08:33:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=wNOM6zr1Mh2QfwiAZNoraDFNpUhjuei2ItlYgdAj68o=;
        b=QQ4IeIf7b/sTdn6o92fz7i7W/nGyknL7TCt5drh4SX+DtIjdU0wNZdBIfhvSjI1tXI
         9a9OqVs/9UlxvKOQV5Nf1wejuA0CnhHKNpbKrJoh8L0Q/WrSI5cztmesrqHdf7sxu1bd
         E3I/SHy9IkSdnBOxCK09LGTu0ecxWjIIAG7CmNpODymN1xshZuT5r36e+KzwlKelEuQO
         T3t0sPAPvHigwoliZ+vHmK1DD5ORJh9pSk7iKSJwe2VFCvYVTSfAeQeCLST+nO4Qy/a4
         Ln95qb8Df/PjmPAAmXGdYacXQEnCbhMdwhZBX6Po192xOz1IbJbk+WPMEB454KVtpi+p
         JvkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=wNOM6zr1Mh2QfwiAZNoraDFNpUhjuei2ItlYgdAj68o=;
        b=thWgKBEXl96Mx4df8mdEgf8I3pZvGKO5kfiJ2BUUYxm67rOlaw2XJ/4zhGsvEKlJpF
         68sUWtdOAtt6YZe3RftdtzyT6Vzb6hfvEbPe++zV4vxYdZMHEY4immnhsbaeyKhVfpDg
         7b6BwJ+Dc0UZ5PhvNy1GsJwsrYPL5H+PdmstjYl3QnRJtWp4gPFYV1Aj/NTIHAFj7zxJ
         zfLmJpg8Qhjr0l1snBhjt28a1LTsugdPHIhSVoX1IiqoNtAYTPf2JxA+5wPy2mCUnYFT
         ZDMqdxrXqEfaT16TbJr4bS8LmJnaIpn5mvamP9MK5srrFnALbvoyr7HmSzrNKz/uB2QY
         lSEQ==
X-Gm-Message-State: AOAM53380zo9PdcsXP7BxOVBwCmz7koLoyTzqwjrGBKx5Neel3SMwUoy
        QeCUpumE4atuFqodzWcjwyQ=
X-Google-Smtp-Source: ABdhPJylcdJRAf/I2EOK5WE+iRZcPr52qiGreQL6YhIc6pXd9GLIT/0C02nSUCVAm3rMVa13zTpZ+Q==
X-Received: by 2002:a05:651c:107b:: with SMTP id y27mr10985574ljm.338.1600443183947;
        Fri, 18 Sep 2020 08:33:03 -0700 (PDT)
Received: from mobilestation ([95.79.141.114])
        by smtp.gmail.com with ESMTPSA id b25sm646174lfc.298.2020.09.18.08.33.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2020 08:33:03 -0700 (PDT)
Date:   Fri, 18 Sep 2020 18:33:01 +0300
From:   Serge Semin <fancer.lancer@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>, Kyle Evans <kevans@FreeBSD.org>,
        Willy Liu <willy.liu@realtek.com>
Cc:     "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ryan Kao <ryankao@realtek.com>,
        Joe Hershberger <joe.hershberger@ni.com>,
        Peter Robinson <pbrobinson@gmail.com>
Subject: Re: [PATCH] net: phy: realtek: fix rtl8211e rx/tx delay config
Message-ID: <20200918153301.chwlvzh6a2bctbjw@mobilestation>
References: <1600307253-3538-1-git-send-email-willy.liu@realtek.com>
 <20200917101035.uwajg4m524g4lz5o@mobilestation>
 <87c4ebf4b1fe48a7a10b27d0ba0b333c@realtek.com>
 <20200918135403.GC3631014@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200918135403.GC3631014@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Andrew.

On Fri, Sep 18, 2020 at 03:54:03PM +0200, Andrew Lunn wrote:
> On Fri, Sep 18, 2020 at 06:55:16AM +0000, 劉偉權 wrote:
> > Hi Serge,
> 
> > Thanks for your reply. There is a confidential issue that realtek
> > doesn't offer the detail of a full register layout for configuration
> > register.
> 
> ...
> 
> > >  	 * 0xa4 extension page (0x7) layout. It can be used to disable/enable
> > >  	 * the RX/TX delays otherwise controlled by RXDLY/TXDLY pins. It can
> > >  	 * also be used to customize the whole configuration register:
> > 
> > > -	 * 8:6 = PHY Address, 5:4 = Auto-Negotiation, 3 = Interface Mode Select,
> > > -	 * 2 = RX Delay, 1 = TX Delay, 0 = SELRGV (see original PHY datasheet
> > > -	 * for details).
> > > +	 * 13 = Force Tx RX Delay controlled by bit12 bit11,
> > > +	 * 12 = RX Delay, 11 = TX Delay
> > 
> 
> > Here you've removed the register layout description and replaced itq
> > with just three bits info. So from now the text above doesn't really
> > corresponds to what follows.
> 
> > I might have forgotten something, but AFAIR that register bits
> > stateq mapped well to what was available on the corresponding
> > external pins.
> 
> Hi Willy
> 

> So it appears bits 3 to 8 have been reverse engineered. Unless you
> know from your confidential datasheet that these are wrong, please
> leave the comment alone.
> 
> If you confidential datasheet says that the usage of bits 0-2 is
> wrong, then please do correct that part.

I've got that info from Kyle post here:
https://reviews.freebsd.org/D13591

My work with that problem has been done more than a year ago, so I don't
remember all the details. But IIRC the very first nine bits [8:0] must be a copy
of what is set on the external configuration pins as I described in the comment.
AFAIR I tried to manually change these pins [1] and detected that change right
there in the register. That fully fitted to what Kyle wrote in his post. Alas I
can't repeat it to be completely sure at the moment due to the lack of the
hardware. So I might have missed something, and Willy' confirmation about that
would have been more than welcome. What we can say now for sure I didn't use
the magic number in my patch. That could have been a mistake from what Willy
says in the commit-log...

Anyway aside with the Magic bits settings (which by Willy' patch appears to be
the Tx/Rx delays + Force Tx/Rx delay setting) Kyle also clears the bits 1-2 with
a comment "Ensure both internal delays are turned off". Willy, what can you say
about that? Can we really leave them out from the change? Kyle, could you give
us a comment about your experience with that?

[1] RTL8211E-VB-CG, RTL8211E-VL-CG, RTL8211E-VL-CG, "INTEGRATED 10/100/1000M ETHERNET
    TRANSCEIVER" Datasheet, Table 13. Configuration Register Definition, Rev. 1.6,
    03 April 2012, Track ID: JATR-3375-16, p.16

-Sergey

> 
>        Andrew
