Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 173A6823D3
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 19:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729990AbfHERRH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 13:17:07 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42659 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728800AbfHERRG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 13:17:06 -0400
Received: by mail-pg1-f195.google.com with SMTP id t132so40070020pgb.9;
        Mon, 05 Aug 2019 10:17:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4NC2zi5IdzFcXT8R+nruR6XNWC2GpDooQHfTzo9KoSA=;
        b=iiW81S07d4eMhALtP7MW1KgdQ7nbI/gKmy8K3xOqOMfp0+223L32TMn5HUdDvbTU9s
         6Cij4xclx6Z07oTFrAz04zrxFVB0wN9j4Ic/aNPNWunygqFlGvNrNRMTqyjkcdVNtIlR
         b0ts+PI6TrqlGzQx/t4ZaoA7HNIouo7tX0qdEMRowXdnBaoqJVBeMl0dGYtpJCIWkLGu
         lNI6ga+NljhxzOdC2gSzVK4ydC2WMUnDg4OCt8oRhiept6g1ZLgEqBN4QBbX6KmWndtV
         PINHL39SQ2LYtAAFEU8RCEmbA7cXg5har7938FwsaKw/QpOFVxduoFqID6L8NAwaPGd4
         yyHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4NC2zi5IdzFcXT8R+nruR6XNWC2GpDooQHfTzo9KoSA=;
        b=prOea4pRc20+TM7MYAyfEaglZOAG49CVxFEyGUaCJaa0iPUvq3WTDhVd+PVeFeYKVO
         BWzqdrEjTuS39tj0J0FhJDH2g3OZoQwlfW9FvFjqbk9C3PInbiTZSliMnRNXZStdZbY3
         64cFIBimWoCADxHihZtZM39vUeCc/a+jz5skrIJNDYp3rTN2/y5fFUSeiFBDZj7GCsEQ
         xwTeMS4eJ3tjeiTvTvLKc4mDmpZFbYsg5jtXa3kUIP7zyF4iznXmVwOqnEX37jbk1NcX
         +jTBxUhPDqYcSrhdEsBwAeDtiUunW544nEWH1HE1nIey1+D3eTT41+jxYhJTC94xQ4pe
         dwSg==
X-Gm-Message-State: APjAAAVYJJY2H5ndS2kwVT69lISrzbM4zbeyCTNLfBZHChoVYwazz6G/
        4roVfLzrzrixpOENuMEDi9Q=
X-Google-Smtp-Source: APXvYqwPEDszDM0jyKUO8QgFrdnjL04bjKfl638yOaagVV40YvbMLuMju59szRlv3RJCcOM6VGSk2g==
X-Received: by 2002:a65:4341:: with SMTP id k1mr2736382pgq.153.1565025425997;
        Mon, 05 Aug 2019 10:17:05 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id v10sm83322212pfe.163.2019.08.05.10.17.04
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 05 Aug 2019 10:17:05 -0700 (PDT)
Date:   Mon, 5 Aug 2019 10:17:03 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Hubert Feurstein <h.feurstein@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [RFC] net: dsa: mv88e6xxx: ptp: improve phc2sys precision for
 mv88e6xxx  switch in combination with imx6-fec
Message-ID: <20190805171702.GA1552@localhost>
References: <20190802163248.11152-1-h.feurstein@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190802163248.11152-1-h.feurstein@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 02, 2019 at 06:32:48PM +0200, Hubert Feurstein wrote:

> diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
> index 2f6057e7335d..20f589dc5b8b 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -1814,11 +1814,25 @@ static int fec_enet_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
>  
>  	reinit_completion(&fep->mdio_done);
>  
> -	/* start a write op */
> -	writel(FEC_MMFR_ST | FEC_MMFR_OP_WRITE |
> -		FEC_MMFR_PA(mii_id) | FEC_MMFR_RA(regnum) |
> -		FEC_MMFR_TA | FEC_MMFR_DATA(value),
> -		fep->hwp + FEC_MII_DATA);
> +	if (bus->ptp_sts) {
> +		unsigned long flags = 0;
> +		local_irq_save(flags);
> +		__iowmb();
> +		/* >Take the timestamp *after* the memory barrier */
> +		ptp_read_system_prets(bus->ptp_sts);
> +		writel_relaxed(FEC_MMFR_ST | FEC_MMFR_OP_WRITE |
> +			FEC_MMFR_PA(mii_id) | FEC_MMFR_RA(regnum) |
> +			FEC_MMFR_TA | FEC_MMFR_DATA(value),
> +			fep->hwp + FEC_MII_DATA);
> +		ptp_read_system_postts(bus->ptp_sts);

Regarding generic support of this, see if you can't place the
ptp_read_system_prets/postts() calls at the mii_bus layer.  This could
mean, for example, offering a two-part write API, to split this write
operation from...

> +		local_irq_restore(flags);
> +	} else {
> +		/* start a write op */
> +		writel(FEC_MMFR_ST | FEC_MMFR_OP_WRITE |
> +			FEC_MMFR_PA(mii_id) | FEC_MMFR_RA(regnum) |
> +			FEC_MMFR_TA | FEC_MMFR_DATA(value),
> +			fep->hwp + FEC_MII_DATA);
> +	}
>
>  	/* wait for end of transfer */
>  	time_left = wait_for_completion_timeout(&fep->mdio_done,

...this kind of thing ^^^

Thanks,
Richard
