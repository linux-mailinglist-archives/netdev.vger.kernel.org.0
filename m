Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A08491BB47F
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 05:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbgD1D0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 23:26:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbgD1DZ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 23:25:59 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BF23C03C1A9;
        Mon, 27 Apr 2020 20:25:57 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id p8so9645978pgi.5;
        Mon, 27 Apr 2020 20:25:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=FFTLljngH5Ep/2srKRJ65CGWNleK6dFyUqeICWr8QnA=;
        b=uq3UadvMRtLCXF31OuHf3ywAgGYrv8LdscF/4AgCkWOGHhQyakRnn0ONx/eQGuMqOb
         hmOo0ZE4+ZyndnBQjg3oy48Owm7oTy3TS/3tJUnBWitWZUuurnffAcFVGJ2VTO7PVBPl
         q9+jExUo83Siw6An6pgaQ2oD/Qrjgp8kBoPZrvGk5pjKul6X+QL+pttHdjGDGSOrrhBD
         dG7ZGFf66P0XsHLoM6fRmbjViZ/4J0j2XeK5OpmEQraTal+6E5qY5L0JmySRkWgeNPA/
         lZjXw/oPM9gAL+q7w9Obn+imTYsVSXuEp1M8UNbugB2JceDy9MYl6i2BDLCBZ/YhDQrL
         X/LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=FFTLljngH5Ep/2srKRJ65CGWNleK6dFyUqeICWr8QnA=;
        b=rerskyfyYkV3etT/2oUPK+ga92+5Rmbh+cdUMphDuAOppV4WeeIavU71nv39K8C+BU
         PDQyHhubDJ/FCIIcLo4L0Ol4u+38X+XvsE6SoG15RYLW3fBi0x3pacZJolvTAmj5Y9UB
         8iad1nJuTyD+G3htGtJ1XsO684Zf42t4jwlQQNjqsRPmKMCObPWgJO7M/xfF50kCsPKN
         5/y1aCVCDrX0tJxRSMlJvir/AC4WR1e3Ma7HnFyzyO53O1pw8Cev3DpehiXlxTOtPYe1
         pWdnJJvnwZM+v85thE/ytMkRrFwmfEJ2gsD9SFLDtSgB4+SIpvLDtezamdIxr3BNhQ+p
         K3xQ==
X-Gm-Message-State: AGi0PuZi98vLp242CnjvfHEDGqWUNl5r5oy/oc78feDea/0nVlWaUcOe
        d7OvlL1lnOY9MysFmvDz1QdSG2ZT
X-Google-Smtp-Source: APiQypL26QPZ/Q+aPgprO7DSDWvEqjnEK+WAtBVgxAsvoURjYwyzagDo4R4MfH3tOSrkXlW04a3d4g==
X-Received: by 2002:a62:764b:: with SMTP id r72mr27393411pfc.207.1588044357036;
        Mon, 27 Apr 2020 20:25:57 -0700 (PDT)
Received: from localhost ([89.208.244.169])
        by smtp.gmail.com with ESMTPSA id x13sm13757432pfq.154.2020.04.27.20.25.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 27 Apr 2020 20:25:56 -0700 (PDT)
Date:   Tue, 28 Apr 2020 11:25:51 +0800
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     Yash Shah <yash.shah@sifive.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        "palmer@dabbelt.com" <palmer@dabbelt.com>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH net v1] net: macb: fix an issue about leak related system
 resources
Message-ID: <20200428032551.GB32072@nuc8i5>
References: <20200425125737.5245-1-zhengdejin5@gmail.com>
 <MN2PR13MB355263F89012F7D742DAE5FA8CAF0@MN2PR13MB3552.namprd13.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN2PR13MB355263F89012F7D742DAE5FA8CAF0@MN2PR13MB3552.namprd13.prod.outlook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 27, 2020 at 08:25:41AM +0000, Yash Shah wrote:
> > -----Original Message-----
> > From: Dejin Zheng <zhengdejin5@gmail.com>
> > Sent: 25 April 2020 18:28
> > To: davem@davemloft.net; Paul Walmsley <paul.walmsley@sifive.com>;
> > palmer@dabbelt.com; nicolas.ferre@microchip.com; Yash Shah
> > <yash.shah@sifive.com>; netdev@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org; Dejin Zheng <zhengdejin5@gmail.com>;
> > Andy Shevchenko <andy.shevchenko@gmail.com>
> > Subject: [PATCH net v1] net: macb: fix an issue about leak related system
> > resources
> > 
> > [External Email] Do not click links or attachments unless you recognize the
> > sender and know the content is safe
> > 
> > A call of the function macb_init() can fail in the function fu540_c000_init. The
> > related system resources were not released then. use devm_ioremap() to
> > replace ioremap() for fix it.
> > 
> > Fixes: c218ad559020ff9 ("macb: Add support for SiFive FU540-C000")
> > Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
> > Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
> > ---
> >  drivers/net/ethernet/cadence/macb_main.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/ethernet/cadence/macb_main.c
> > b/drivers/net/ethernet/cadence/macb_main.c
> > index a0e8c5bbabc0..edba2eb56231 100644
> > --- a/drivers/net/ethernet/cadence/macb_main.c
> > +++ b/drivers/net/ethernet/cadence/macb_main.c
> > @@ -4178,7 +4178,7 @@ static int fu540_c000_init(struct platform_device
> > *pdev)
> >         if (!res)
> >                 return -ENODEV;
> > 
> > -       mgmt->reg = ioremap(res->start, resource_size(res));
> > +       mgmt->reg = devm_ioremap(&pdev->dev, res->start,
> > + resource_size(res));
> >         if (!mgmt->reg)
> >                 return -ENOMEM;
> > 
> > --
> > 2.25.0
> 
> The change looks good to me.
> Reviewed-by: Yash Shah <yash.shah@sifive.com>
>
Thanks Yash!

> - Yash
> 
