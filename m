Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE3752A2283
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 01:06:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727526AbgKBAGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 19:06:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727309AbgKBAGz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 19:06:55 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45C3AC0617A6
        for <netdev@vger.kernel.org>; Sun,  1 Nov 2020 16:06:55 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id a71so7249336edf.9
        for <netdev@vger.kernel.org>; Sun, 01 Nov 2020 16:06:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yW24AEBAMhqFYho18ZDpd5QCNSsbOCt0uotVzU5EYPs=;
        b=h7LPI96QlhwooEE5zhzyE1+q7JBd2mcZLd7uocNcnQSQP3rFDedLvW78GrY1vUnK4l
         FGXV9S2hWzTMIMLwUjPfTm7KxGDl9DXN1VmQ+0YIqOyOgoePhz7ltcQCz+IXiT578gXw
         900aFy+XfXsyBmT0vAhqWb7KVM9fZb+0ZSuqOLKWAcekhC8pjizB9SMI1CFhmNCA2vT4
         HKwhsBAazNz3L7gvW2GeSr0kEJv6ne+AnUHGkSDpvxmCNZwsFgAAfXVwRV7f031dUZI4
         +5vcXRaE4n2SS7YeCimTTHcBENnEIOBd37ub5yMZYFvkTemeBYinWov5mnV3PQ5gPyih
         M0TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yW24AEBAMhqFYho18ZDpd5QCNSsbOCt0uotVzU5EYPs=;
        b=eRaqafdKWUeMEQ0xLLfCbe90/1DKHbpQxB48eLQ11zQaW7ssvBdlXu+umi9OMPbf/x
         pjYVwKrqRw83lq1rgeSLPRLh4FHPWdDI9C8tiUgLNnyqXLOX2k1rIbVLa2B6MMtAVwKi
         7McWQBsy3rmfPgJGmHVGElm3aDsZEmGCiKZkUTHPiYRsyzdD/f9OFSZWDEhtOBW+nGLu
         NA2r/QvPcdYfY4KBiXLy+ydW1EXU34uPk095Ukl6WbvWoj6ch0CCU+yS6h7pBLZceiex
         i2xwzdyFuw8wCVUN/mA2DFqGv8JzhVOEOYOXmT+SeaOjJmSLIEe4NimZyXcm7u3Uh3xc
         MEbg==
X-Gm-Message-State: AOAM533oKjx6V3uv6xDlUHBoZOhH/3KDI89six+DD2Z19ANz0CXCEqaM
        PcmKUxYpNjo+5YD9J5k/isY=
X-Google-Smtp-Source: ABdhPJyZAu/9HHaYNoD5XinVQPNtzyza3oR2n47Nw2gGkazTuTjTQDMagzBznsQjHbEWVc84FtsLhw==
X-Received: by 2002:aa7:ce18:: with SMTP id d24mr14543743edv.9.1604275613880;
        Sun, 01 Nov 2020 16:06:53 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id d6sm9323313edr.26.2020.11.01.16.06.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2020 16:06:53 -0800 (PST)
Date:   Mon, 2 Nov 2020 02:06:52 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] r8169: set IRQF_NO_THREAD if MSI(X) is enabled
Message-ID: <20201102000652.5i5o7ig56lymcjsv@skbuf>
References: <446cf5b8-dddd-197f-cb96-66783141ade4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <446cf5b8-dddd-197f-cb96-66783141ade4@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 01, 2020 at 11:30:44PM +0100, Heiner Kallweit wrote:
> We had to remove flag IRQF_NO_THREAD because it conflicts with shared
> interrupts in case legacy interrupts are used. Following up on the
> linked discussion set IRQF_NO_THREAD if MSI or MSI-X is used, because
> both guarantee that interrupt won't be shared.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> Link: https://www.spinics.net/lists/netdev/msg695341.html

I am not sure if this utilization of the Link: tag is valid. I think it
has a well-defined meaning and maintainers use it to provide a link to
the email where the patch was picked from:
https://lkml.org/lkml/2011/4/6/421

> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index 319399a03..4d6afaf7c 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -4690,6 +4690,7 @@ static int rtl_open(struct net_device *dev)
>  {
>  	struct rtl8169_private *tp = netdev_priv(dev);
>  	struct pci_dev *pdev = tp->pci_dev;
> +	unsigned long irqflags;
>  	int retval = -ENOMEM;
>  
>  	pm_runtime_get_sync(&pdev->dev);
> @@ -4714,8 +4715,9 @@ static int rtl_open(struct net_device *dev)
>  
>  	rtl_request_firmware(tp);
>  
> +	irqflags = pci_dev_msi_enabled(pdev) ? IRQF_NO_THREAD : IRQF_SHARED;
>  	retval = request_irq(pci_irq_vector(pdev, 0), rtl8169_interrupt,
> -			     IRQF_SHARED, dev->name, tp);
> +			     irqflags, dev->name, tp);
>  	if (retval < 0)
>  		goto err_release_fw_2;
>  
> -- 
> 2.29.2
> 

So all things considered, what do you want to achieve with this change?
Is there other benefit with disabling force threading of the
rtl8169_interrupt, or are you still looking to add back the
napi_schedule_irqoff call?
