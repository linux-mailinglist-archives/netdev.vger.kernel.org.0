Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E74A18617F
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 03:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729441AbgCPCRp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 22:17:45 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:34466 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729324AbgCPCRo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Mar 2020 22:17:44 -0400
Received: by mail-pl1-f196.google.com with SMTP id a23so7273258plm.1;
        Sun, 15 Mar 2020 19:17:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=qWjBZjkx/KY8oeosSpB9MAxoMYpT7Z/9Dd9HUziHQCo=;
        b=TGqbQ6O1HzIXJAmUYkTcbObT8QAmErwTVdiAxeK7pZ4bDCI/CJ6m6H8xDzUP9gz0+i
         fSCRDMrYZhHgvU9DLCpfWsQSHZO7Nn7OtKE2CBchARrdH7O39In+Zfodd1y1ZSRtj93E
         R3bVRUQyv1JPlang3KriuWWgp0LjMks4SJKtbIcueuV+fX/T1x++8AWlSR/p7K3wQLnA
         tnTbJSpaPsPfQuPjctU9EzmBPo363wshN7EhePGon5nhS9kh3aT/SRJs2cfjhkVl3i8n
         pjKgydM/sfBWG9mNJOFv0mrdM1EOws14tO37iMVZeXDpLzi7YNgDhfsLdoZB+93jusqP
         6VdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=qWjBZjkx/KY8oeosSpB9MAxoMYpT7Z/9Dd9HUziHQCo=;
        b=lruVIhqihHnsSCJ5Xq3J6RFyohJsv75jv6gz0CY7qYn3TYB9zc851tqi8VVPaqoSzE
         sPJJ9A6NQrcBXzf+sG4D7m5QqDpnxyl0EfVPLEwz5sHW0St6oF665A1YN33/pMNTm6qp
         6waGVP4QytUgvTziJMbkDWDyN+KMrKpviRkffdUq/VyvTmjsBVyyQaKuZdCHehyfHHQ1
         uEsIeG0g4YLVoHCh+2VSPlDWw9i9cSklgXYALeDyQTr8Rtva8nAEmFpj/BbHDTxNiMUa
         ZQI2GxnBT3TpBRwg4AeT4IY5l8W/Ij2KLPFeOJxiwLTgDyLUxxdKAJErjAPhdN5dTTJW
         N/eQ==
X-Gm-Message-State: ANhLgQ2LDyKRp8P8anFfeCGSNmuOOCuFDnRqEracon2eDpY3bPTxBR7A
        65kCmwcbte1xFiuiHwgV9ik=
X-Google-Smtp-Source: ADFU+vvSlXruOq6QGZEaPnd9d+OEhOdhxSx/jKZA5JkbYveY8eFrZeTezL22IYW2GE+BrhiktXdAsw==
X-Received: by 2002:a17:902:bb92:: with SMTP id m18mr24764047pls.46.1584325063169;
        Sun, 15 Mar 2020 19:17:43 -0700 (PDT)
Received: from localhost (216.24.188.11.16clouds.com. [216.24.188.11])
        by smtp.gmail.com with ESMTPSA id s25sm4830589pgv.70.2020.03.15.19.17.42
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 15 Mar 2020 19:17:42 -0700 (PDT)
Date:   Mon, 16 Mar 2020 10:17:40 +0800
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net-next v2 1/2] net: stmmac: use readl_poll_timeout()
 function in init_systime()
Message-ID: <20200316021740.GA3024@nuc8i5>
References: <20200315150301.32129-1-zhengdejin5@gmail.com>
 <20200315150301.32129-2-zhengdejin5@gmail.com>
 <20200315182504.GA8524@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200315182504.GA8524@lunn.ch>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 15, 2020 at 07:25:04PM +0100, Andrew Lunn wrote:

Hi Andrew and David :

> On Sun, Mar 15, 2020 at 11:03:00PM +0800, Dejin Zheng wrote:
> > The init_systime() function use an open coded of readl_poll_timeout().
> > Replace the open coded handling with the proper function.
> > 
> > Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
> > ---
> > v1 -> v2:
> > 	- no changed.
> > 
> >  .../net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c  | 14 ++++++--------
> >  1 file changed, 6 insertions(+), 8 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
> > index 020159622559..2a24e2a7db3b 100644
> > --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
> > +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
> > @@ -10,6 +10,7 @@
> >  *******************************************************************************/
> >  
> >  #include <linux/io.h>
> > +#include <linux/iopoll.h>
> >  #include <linux/delay.h>
> >  #include "common.h"
> >  #include "stmmac_ptp.h"
> > @@ -53,8 +54,8 @@ static void config_sub_second_increment(void __iomem *ioaddr,
> >  
> >  static int init_systime(void __iomem *ioaddr, u32 sec, u32 nsec)
> >  {
> > -	int limit;
> >  	u32 value;
> > +	int err;
> >  
> >  	writel(sec, ioaddr + PTP_STSUR);
> >  	writel(nsec, ioaddr + PTP_STNSUR);
> > @@ -64,13 +65,10 @@ static int init_systime(void __iomem *ioaddr, u32 sec, u32 nsec)
> >  	writel(value, ioaddr + PTP_TCR);
> >  
> >  	/* wait for present system time initialize to complete */
> > -	limit = 10;
> > -	while (limit--) {
> > -		if (!(readl(ioaddr + PTP_TCR) & PTP_TCR_TSINIT))
> > -			break;
> > -		mdelay(10);
> > -	}
> > -	if (limit < 0)
> > +	err = readl_poll_timeout(ioaddr + PTP_TCR, value,
> > +				 !(value & PTP_TCR_TSINIT),
> > +				 10000, 100000);
> > +	if (err)
> >  		return -EBUSY;
> 
> Hi Dejin
> 
> It is normal to just return whatever error code readl_poll_timeout()
> returned.
> 
> 	Andrew

You are right. I will modify it. Thanks!

BR,
Dejin

