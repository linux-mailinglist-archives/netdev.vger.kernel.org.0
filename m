Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E61A2A85E9
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 19:15:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732210AbgKESPH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 13:15:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732077AbgKESPA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 13:15:00 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3ECDC0613CF
        for <netdev@vger.kernel.org>; Thu,  5 Nov 2020 10:15:00 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id h4so485640pjk.0
        for <netdev@vger.kernel.org>; Thu, 05 Nov 2020 10:15:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zr+O4641r70/m+Ora5m3lFETamMDRZrip5r52/NS1D4=;
        b=ZfQNOrSey3faOuXuVNRJ1QpWcnr290Y7asLPe4IcU4mptJMgeiDAXeijfSxtf6qWFo
         wzKmWOkJXfGDyEaH8RA8LWQZzXqZPU96i2GMamol5crR4O3URGAJuQvF+YAgQ8Pkn5jp
         JY8wa/ZXRVeyjQsYHI8f7/9KGuanQJNUhEZPTFUCBoCPdUVm/qcxc9OyZKnxSSJ3X5OF
         bGZWwiX6ZNst0UxZdvCiDiZRy8T7fxwBKDVMCeO3AlYixv6f85e4mSxDasqsKQHBGd04
         GlJjk1LkmoYLONQKH+VS2kM7C9+PJzZkLpPwS9lsQPmDT16dbAsQcmUOWvD3ky32NKY/
         hjrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=zr+O4641r70/m+Ora5m3lFETamMDRZrip5r52/NS1D4=;
        b=pnntyQixEUhFFh9PAhI5vnqvR4PcqsacZu5uYxlPQk6PD7ViSQSdJyqhVRvWzsZgLq
         bHguajeg8ZidCIwglbDFLrqiGodOfSOLd64hFwRu/NEYGhjrincrkzN2QXCPfNGicZ4S
         T3tc2efezjdSv2ikc/Sc+Qv/P8KUTWqklGIk89JxQRB9g6bwpWkwWW9/WDQ55+p6dpDR
         WaqxpTAjDHVZF6VX2QySNoyaQmR74Vcb7yBAMFjR5fA8NOmDrGBvTN6rTbmi3h9Climr
         8VdLKHsV5dEpgFc0WI7g48yddzO3fPnwPA0Wpc5c9ny19s1PRj2AfwYGeX7TanD4WyVl
         4B3w==
X-Gm-Message-State: AOAM531twdp/Ua8LfLxWpZUNBrppfARlJ5aoHAlp+gLWqF7Zc2uDOFEA
        dd9amfKrrGWmleMkW6/0Z/rFDllynk60
X-Google-Smtp-Source: ABdhPJzMztYOVEejvswOIfXcY1eJ1oPwhghppVLlSWc+6G1lhscstTeu4ZQxxGj2CQWw5wuh+Ap3Ug==
X-Received: by 2002:a17:902:8347:b029:d5:de7a:db11 with SMTP id z7-20020a1709028347b02900d5de7adb11mr3159891pln.2.1604600100107;
        Thu, 05 Nov 2020 10:15:00 -0800 (PST)
Received: from work ([103.59.133.81])
        by smtp.gmail.com with ESMTPSA id t8sm3300941pfe.65.2020.11.05.10.14.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 05 Nov 2020 10:14:59 -0800 (PST)
Date:   Thu, 5 Nov 2020 23:44:53 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        Thomas Kopp <thomas.kopp@microchip.com>
Subject: Re: [net 21/27] can: mcp251xfd: mcp251xfd_regmap_crc_read():
 increase severity of CRC read error messages
Message-ID: <20201105181453.GJ7308@work>
References: <20201103220636.972106-1-mkl@pengutronix.de>
 <20201103220636.972106-22-mkl@pengutronix.de>
 <20201105162417.GH7308@work>
 <cee3b960-6633-bffd-d1a6-05e4a5e20b2e@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cee3b960-6633-bffd-d1a6-05e4a5e20b2e@pengutronix.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 05, 2020 at 05:39:31PM +0100, Marc Kleine-Budde wrote:
> On 11/5/20 5:24 PM, Manivannan Sadhasivam wrote:
> > Hi Marc,
> > 
> > On Tue, Nov 03, 2020 at 11:06:30PM +0100, Marc Kleine-Budde wrote:
> >> During debugging it turned out that some people have setups where the SPI
> >> communication is more prone to CRC errors.
> >>
> >> Increase the severity of both the transfer retry and transfer failure message
> >> to give users feedback without the need to recompile the driver with debug
> >> enabled.
> >>
> >> Cc: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> >> Cc: Thomas Kopp <thomas.kopp@microchip.com>
> >> Link: http://lore.kernel.org/r/20201019190524.1285319-15-mkl@pengutronix.de
> >> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> >> ---
> >>  drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c | 16 ++++++++--------
> >>  1 file changed, 8 insertions(+), 8 deletions(-)
> >>
> >> diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c
> >> index ba25902dd78c..c9ffc5ea2b25 100644
> >> --- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c
> >> +++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c
> >> @@ -330,17 +330,17 @@ mcp251xfd_regmap_crc_read(void *context,
> >>  			goto out;
> >>  		}
> >>  
> >> -		netdev_dbg(priv->ndev,
> >> -			   "CRC read error at address 0x%04x (length=%zd, data=%*ph, CRC=0x%04x) retrying.\n",
> >> -			   reg, val_len, (int)val_len, buf_rx->data,
> >> -			   get_unaligned_be16(buf_rx->data + val_len));
> >> -	}
> >> -
> >> -	if (err) {
> >>  		netdev_info(priv->ndev,
> >> -			    "CRC read error at address 0x%04x (length=%zd, data=%*ph, CRC=0x%04x).\n",
> >> +			    "CRC read error at address 0x%04x (length=%zd, data=%*ph, CRC=0x%04x) retrying.\n",
> >>  			    reg, val_len, (int)val_len, buf_rx->data,
> >>  			    get_unaligned_be16(buf_rx->data + val_len));
> > 
> > I'm not finding this inner debug log useful. Does the user really care
> > about the iterations it took to read a register? Just throwing the error
> > after max try seems better to me.
> 
> Bitflips on the SPI should not happen, at least not regularly. Even with my
> breadboard setup and max SPI frequency, I don't see any SPI CRC errors, unless
> there is bad cabling. Then a retry most of the times helps and the user doesn't
> notice. This drops performance...Yes logging drop performance, too, but at least
> someone will notice.
> 
> My rationale was to give the user feedback and not cover a potential problem.
> The driver is new and probably not widely used and I have no idea how often it
> runs into read-CRC problems in production use.
> 

Okay. Let's see if anyone complain ;)

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

Thanks,
Mani

> Marc
> 
> -- 
> Pengutronix e.K.                 | Marc Kleine-Budde           |
> Embedded Linux                   | https://www.pengutronix.de  |
> Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
> Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |
> 



