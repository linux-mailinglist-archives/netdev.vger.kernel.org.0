Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DAD97AD1F
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 18:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732774AbfG3QAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 12:00:36 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36732 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727937AbfG3QAg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 12:00:36 -0400
Received: by mail-pf1-f195.google.com with SMTP id r7so30074275pfl.3;
        Tue, 30 Jul 2019 09:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wW+xc9Xlw2bu+K653N1yOhVKcSYS+KkktZQO9tOmIPA=;
        b=C2gP4V6SRRGKWO60VOsZvA1swD6ZnkJl42IMkeGBbKTq6tQk0m7fUBHqG75Oy3jQig
         jXRW3i+yZiIXOBQuZS6Dpdx45gIYQf52FwP7rUR7XXCIVLl7I1cXL1hmEBAGJAMdsj+S
         7ojoFNu9m23sbUPKc6SXKHw0chTjyjMFOz5O5Ex75K6j0fhJ8P5BUO1Zeq1vDG7IHM44
         4ysVcfjAu61vDBa3rBs3XGvKbqQ3mToM9Je5/d+d2t9rz8k1oV1gSO5K3g79VJMNODf5
         i6cFxmkUm+plU5tKqDgw1cnaq7NfJk1/V7IML5gMl6v3OvodJc0Nqths/2zSVxu/m+C9
         74Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wW+xc9Xlw2bu+K653N1yOhVKcSYS+KkktZQO9tOmIPA=;
        b=fTUkNXzVybZ2V8X8GnilHFdBWl4+aAKVZC2kszDB4JIipKhsfkXu+ehFAzW5s4mZbD
         2OD2V18nuVrFtEQPrD7oWYYauLnbIYezXFXnypLFK2IxR/37RnLZK6ySWdEywm2a/PMw
         7eMEbBGr49E+5pyyQ8gioyfwHuSzcCtUY2TklPmlDnLzZ9SH6VuamKpF/QU/gNO4pT+Z
         fT4NipGgPyyQ5f6YGarC6lefy6dTio3ibmCoDXSrEllBQYmgVDj+XJX2IoPIb3OFclPp
         HPt+KLB0ncQGs4xeAEUOnP8fSYYbjBrcwmCrJIPlUgdcSwcSSgTh+x7mMBuUASg9ZGIE
         /suQ==
X-Gm-Message-State: APjAAAXnhnpiFbFrMxKFIIAJlsmqfAhfZTt2zoUBqFWPzUnQrvL+0Xcv
        +56QdZNy9AzXAGj2f5+ur24T0Txo
X-Google-Smtp-Source: APXvYqzj2DZFl8jNtMjbadFdv7+wxNLAYWpl6FZ49oH4kTxWHBLLDqv+fuQODPBxVH5i89VLxtdPXg==
X-Received: by 2002:a17:90a:fa18:: with SMTP id cm24mr114728053pjb.120.1564502435745;
        Tue, 30 Jul 2019 09:00:35 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id k22sm70726634pfk.157.2019.07.30.09.00.34
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 30 Jul 2019 09:00:34 -0700 (PDT)
Date:   Tue, 30 Jul 2019 09:00:32 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Hubert Feurstein <h.feurstein@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: Re: [PATCH 4/4] net: dsa: mv88e6xxx: add PTP support for MV88E6250
 family
Message-ID: <20190730160032.GA1251@localhost>
References: <20190730100429.32479-1-h.feurstein@gmail.com>
 <20190730100429.32479-5-h.feurstein@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190730100429.32479-5-h.feurstein@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 30, 2019 at 12:04:29PM +0200, Hubert Feurstein wrote:
> diff --git a/drivers/net/dsa/mv88e6xxx/ptp.c b/drivers/net/dsa/mv88e6xxx/ptp.c
> index 768d256f7c9f..51cdf4712517 100644
> --- a/drivers/net/dsa/mv88e6xxx/ptp.c
> +++ b/drivers/net/dsa/mv88e6xxx/ptp.c
> @@ -15,11 +15,38 @@
>  #include "hwtstamp.h"
>  #include "ptp.h"
>  
> -/* Raw timestamps are in units of 8-ns clock periods. */
> -#define CC_SHIFT	28
> -#define CC_MULT		(8 << CC_SHIFT)
> -#define CC_MULT_NUM	(1 << 9)
> -#define CC_MULT_DEM	15625ULL
> +/* The adjfine API clamps ppb between [-32,768,000, 32,768,000], and

That is not true.

> + * therefore scaled_ppm between [-2,147,483,648, 2,147,483,647].
> + * Set the maximum supported ppb to a round value smaller than the maximum.
> + *
> + * Percentually speaking, this is a +/- 0.032x adjustment of the
> + * free-running counter (0.968x to 1.032x).
> + */
> +#define MV88E6XXX_MAX_ADJ_PPB	32000000

I had set an arbitrary limit of 1000 ppm.  I can't really see any
point in raising the limit.

> +/* Family MV88E6250:
> + * Raw timestamps are in units of 10-ns clock periods.
> + *
> + * clkadj = scaled_ppm * 10*2^28 / (10^6 * 2^16)
> + * simplifies to
> + * clkadj = scaled_ppm * 2^7 / 5^5
> + */
> +#define MV88E6250_CC_SHIFT	28
> +#define MV88E6250_CC_MULT	(10 << MV88E6250_CC_SHIFT)
> +#define MV88E6250_CC_MULT_NUM	(1 << 7)
> +#define MV88E6250_CC_MULT_DEM	3125ULL
> +
> +/* Other families:
> + * Raw timestamps are in units of 8-ns clock periods.
> + *
> + * clkadj = scaled_ppm * 8*2^28 / (10^6 * 2^16)
> + * simplifies to
> + * clkadj = scaled_ppm * 2^9 / 5^6
> + */
> +#define MV88E6XXX_CC_SHIFT	28
> +#define MV88E6XXX_CC_MULT	(8 << MV88E6XXX_CC_SHIFT)
> +#define MV88E6XXX_CC_MULT_NUM	(1 << 9)
> +#define MV88E6XXX_CC_MULT_DEM	15625ULL
>  
>  #define TAI_EVENT_WORK_INTERVAL msecs_to_jiffies(100)
>  
> @@ -179,24 +206,14 @@ static void mv88e6352_tai_event_work(struct work_struct *ugly)
>  static int mv88e6xxx_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
>  {
>  	struct mv88e6xxx_chip *chip = ptp_to_chip(ptp);
> -	int neg_adj = 0;
> -	u32 diff, mult;
> -	u64 adj;
> +	s64 adj;
>  
> -	if (scaled_ppm < 0) {
> -		neg_adj = 1;
> -		scaled_ppm = -scaled_ppm;
> -	}

Please don't re-write this logic.  It is written like that for a reason.

> -	mult = CC_MULT;
> -	adj = CC_MULT_NUM;
> -	adj *= scaled_ppm;
> -	diff = div_u64(adj, CC_MULT_DEM);

Just substitute CC_MULT* with your new chip->ptp_cc_mult*
and leave the rest alone.

Thanks,
Richard
