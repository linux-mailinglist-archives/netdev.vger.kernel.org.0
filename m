Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E578723D355
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 22:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727783AbgHEU7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 16:59:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725920AbgHEU7m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 16:59:42 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 044D1C061575
        for <netdev@vger.kernel.org>; Wed,  5 Aug 2020 13:59:42 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id l4so47852770ejd.13
        for <netdev@vger.kernel.org>; Wed, 05 Aug 2020 13:59:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AjdPp5HfnZVGenP9lTHrdK9u1iI0kLOkTgaBNwCu1fk=;
        b=WPk9Toq1zctR5cl5+5VKgtNzzHgRmBDJ+ou76I4k2dQrrjlmm3azSB4BIBEl9Bj7lC
         RBkZFJv+vONuoBrTJFAtPYWQluc6GbGfYbkSlrWOOZO1q0biDdBC0/YRs6WqVWW+zVLV
         fj9HEeb5sFQnPkzDXvxMo85WKX9zFjHHWAwNBtEk0OPX2MX4z1dpU/iznpxzHJpmZAbm
         gVC9+ldei8YfGaKz3nSZJtdKHqr3JaK6QPyc3Xfv7sPL4/sIgE87e/8M+6s3tPfvMgge
         siWRrImMX6n3dlZTTd8dbXgJTu6b4xCQ6KIUyiiCq15gCIC+eHrw5HiXrJf3Q8PB0y8t
         HJ4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AjdPp5HfnZVGenP9lTHrdK9u1iI0kLOkTgaBNwCu1fk=;
        b=mxzkpSdAIpwsXBueQtmCwx9DSfulpGO5cPzf9dFoWG1S+nVxohp50KG4EuzDOB6fwM
         fbORPfK6xvpVunRDWjnAm9VlMeweAcNA4nLHuow/74v6gOWxKN2J3PCfbeSZUpdosEBV
         MxUKRlMpk2aihD3XJwFL3FaFRTqn5ofEkmEfDrjJARBfRRDrLy2Hhe4Njt+tNiYz5iFV
         L1Qg/jNKkbI5FZ0/adbHnK0AssRmqFPzgO01qIkLtAFPGBzo+zCxVkbuZ+vgIc0H24nT
         SGeEUkDGXcdeufO8xTlLR34Ura5cfEwAnETbpf/nTgS10vkImZ7bPogIZVFjoDo/siVo
         Tg1Q==
X-Gm-Message-State: AOAM532VU6hIj796VvGsrR/m7ha9Kk7VwC8SE0EeBycQdB3xdx6aLoXb
        eFrKk9jOgE4AV+QriNLDi0Cn3wf7
X-Google-Smtp-Source: ABdhPJx+O4NLGxzYc3MWzhgSp42ao4PGb8kqfUjkNggkciSZeLFrhm3SeKWdEFqqbOHAvR8n6HKV+Q==
X-Received: by 2002:a17:906:b08:: with SMTP id u8mr1175994ejg.401.1596661180712;
        Wed, 05 Aug 2020 13:59:40 -0700 (PDT)
Received: from skbuf ([188.26.57.97])
        by smtp.gmail.com with ESMTPSA id y26sm2112813edu.96.2020.08.05.13.59.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2020 13:59:40 -0700 (PDT)
Date:   Wed, 5 Aug 2020 23:59:38 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        andrew@lunn.ch, vivien.didelot@gmail.com
Subject: Re: [PATCH net-next] net: dsa: sja1105: use detected device id
 instead of DT one on mismatch
Message-ID: <20200805205938.2d2bhrkyeu3lgioe@skbuf>
References: <20200803164823.414772-1-olteanv@gmail.com>
 <20200804.155950.60471933904505919.davem@davemloft.net>
 <3d3de571-fcd3-7885-628a-432980d4999d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d3de571-fcd3-7885-628a-432980d4999d@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 04, 2020 at 08:01:46PM -0700, Florian Fainelli wrote:
> On 8/4/2020 3:59 PM, David Miller wrote:
> > From: Vladimir Oltean <olteanv@gmail.com>
> > Date: Mon,  3 Aug 2020 19:48:23 +0300
> > 
> >> Although we can detect the chip revision 100% at runtime, it is useful
> >> to specify it in the device tree compatible string too, because
> >> otherwise there would be no way to assess the correctness of device tree
> >> bindings statically, without booting a board (only some switch versions
> >> have internal RGMII delays and/or an SGMII port).
> >>
> >> But for testing the P/Q/R/S support, what I have is a reworked board
> >> with the SJA1105T replaced by a pin-compatible SJA1105Q, and I don't
> >> want to keep a separate device tree blob just for this one-off board.
> >> Since just the chip has been replaced, its RGMII delay setup is
> >> inherently the same (meaning: delays added by the PHY on the slave
> >> ports, and by PCB traces on the fixed-link CPU port).
> >>
> >> For this board, I'd rather have the driver shout at me, but go ahead and
> >> use what it found even if it doesn't match what it's been told is there.
> >>
> >> [    2.970826] sja1105 spi0.1: Device tree specifies chip SJA1105T but found SJA1105Q, please fix it!
> >> [    2.980010] sja1105 spi0.1: Probed switch chip: SJA1105Q
> >> [    3.005082] sja1105 spi0.1: Enabled switch tagging
> >>
> >> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> > 
> > Andrew/Florian, do we really want to set a precedence for doing this
> > kind of fallback in our drivers?
> 
> Not a big fan of it, and the justification is a little bit weak IMHO,
> especially since one could argue that the boot agent providing the FDT
> could do that check and present an appropriate compatible string to the
> kernel.

I'll admit I'm not a huge fan either, but what you're suggesting is
basically to move the whole problem one level lower (somebody would
still have to be aware about the device id mismatch). I _was_ going to
eventually patch the U-Boot driver to adapt to the real device id too,
but only for its own use of networking. I am an even smaller fan of
having to do a fdt fixup from U-Boot, then I'd have to rely on that
always being there to do its job properly.

I've been using this board with a local fdt blob for more than one year
now, but it's inconvenient for me to have custom tftp commands for this
one board only. I hope I'm not setting for a behavior that might be
abused, tbh I don't really see how. At the end of the day though, I
don't see why the driver would have to be as punishing as to refuse to
probe when it can, warning is more than enough.

Thanks,
-Vladimir
