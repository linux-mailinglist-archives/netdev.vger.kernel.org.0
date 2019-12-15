Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FED911F648
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 06:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbfLOFaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 00:30:09 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:44900 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbfLOFaI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Dec 2019 00:30:08 -0500
Received: by mail-pj1-f66.google.com with SMTP id w5so1518903pjh.11
        for <netdev@vger.kernel.org>; Sat, 14 Dec 2019 21:30:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=44sFNzZQ0jSuT6radZuvST83PN+QjHbvo3eNnAqz5T4=;
        b=kVOMbtGBBLgupm5qfLlUah9HJi6mvcL2+CQpl+ip5Mr2/y4jgaWO7m8XsuvlSbzr1B
         56atFJdqDKDgaEH3Zwh9dvCk6ey7GVgwV+14VPDSIWXEfxtONV2twj0O/6VFEDLfmnnG
         Y/R2GzrKO5c4nr21jpYl+coNSuwDy74Ly1gBrkXLeDpoFEs11npXQY5zjmz85mBUPe2N
         XCNy7joLURr2cH5EqjTuJOwFdpO/K47dre+eui+sHrlbJzO4Qh3dbQPu3nrcwFsQ/2md
         GpWWGeKWDPI4qXwQpj+QpXuZWnmZDwD5W9w0SEVogDAwFp08++Ubzrr0xEPSZq5ZbMeB
         r3UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=44sFNzZQ0jSuT6radZuvST83PN+QjHbvo3eNnAqz5T4=;
        b=LemDLgVZO2B5+/LlkbgLR01Rc0VAU5egNlUecK1KSUwuDe8uw9jWWiVUY6PzzFibgQ
         lF++FB8hYGxIVOVGo4rWg8xftp14EPEDSnZABifKrBjbwQNqsTw156H6NNrjO337kXSe
         yj3vZ2tbM/YwSjaJaj6ImofcEIoHw7ndseTlteY+V8b6QmbMxy7cCZ/+H43Ll3KUdP66
         SRFAFqsikI6U8TxfgSnzXmlELNpfDrGmGd4GBwdLeQyTGGDkrPzE7EXDfqyBzweGgsMU
         nTNtzAVVxaDRv1ZcuQLEd9BD/rsOLbxTv/AQtLjvekZYwZtNhfKG3e0SHoXNuTJEcNAO
         ZMqQ==
X-Gm-Message-State: APjAAAUAVz4DWPJec5KRaW8VjlzB0tQgFz4HYIcC6ckd4RJaTNj3JLdg
        trQYYgUSrfCg6y1dwQBMzyEpcQ==
X-Google-Smtp-Source: APXvYqwFqDaiPoweWqW+e4/UbXoaeJqK1PyQGB+t1cFA+Sgs8rS7ucmoBEfzYEpd/P51IO3mqJ2ztQ==
X-Received: by 2002:a17:90a:a88f:: with SMTP id h15mr5704028pjq.32.1576387808224;
        Sat, 14 Dec 2019 21:30:08 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id u5sm16876060pfm.115.2019.12.14.21.30.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Dec 2019 21:30:08 -0800 (PST)
Date:   Sat, 14 Dec 2019 21:30:05 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Yangbo Lu <yangbo.lu@nxp.com>
Subject: Re: [PATCH net] dpaa2-ptp: fix double free of the ptp_qoriq IRQ
Message-ID: <20191214213005.701756d0@cakuba.netronome.com>
In-Reply-To: <1576231462-23886-1-git-send-email-ioana.ciornei@nxp.com>
References: <1576231462-23886-1-git-send-email-ioana.ciornei@nxp.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Dec 2019 12:04:22 +0200, Ioana Ciornei wrote:
> Upon reusing the ptp_qoriq driver, the ptp_qoriq_free() function was
> used on the remove path to free any allocated resources.
> The ptp_qoriq IRQ is among these resources that are freed in
> ptp_qoriq_free() even though it is also a managed one (allocated using
> devm_request_threaded_irq).
> 
> Drop the resource managed version of requesting the IRQ in order to not
> trigger a double free of the interrupt as below:
> 
> [  226.731005] Trying to free already-free IRQ 126
> [  226.735533] WARNING: CPU: 6 PID: 749 at kernel/irq/manage.c:1707
> __free_irq+0x9c/0x2b8
> [  226.743435] Modules linked in:
> [  226.746480] CPU: 6 PID: 749 Comm: bash Tainted: G        W
> 5.4.0-03629-gfd7102c32b2c-dirty #912
> [  226.755857] Hardware name: NXP Layerscape LX2160ARDB (DT)
> [  226.761244] pstate: 40000085 (nZcv daIf -PAN -UAO)
> [  226.766022] pc : __free_irq+0x9c/0x2b8
> [  226.769758] lr : __free_irq+0x9c/0x2b8
> [  226.773493] sp : ffff8000125039f0
> (...)
> [  226.856275] Call trace:
> [  226.858710]  __free_irq+0x9c/0x2b8
> [  226.862098]  free_irq+0x30/0x70
> [  226.865229]  devm_irq_release+0x14/0x20
> [  226.869054]  release_nodes+0x1b0/0x220
> [  226.872790]  devres_release_all+0x34/0x50
> [  226.876790]  device_release_driver_internal+0x100/0x1c0
> 
> Fixes: d346c9e86d86 ("dpaa2-ptp: reuse ptp_qoriq driver")
> Cc: Yangbo Lu <yangbo.lu@nxp.com>
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> ---
>  drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c
> index a9503aea527f..04a4b316f1dc 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c
> @@ -160,10 +160,10 @@ static int dpaa2_ptp_probe(struct fsl_mc_device *mc_dev)
>  	irq = mc_dev->irqs[0];
>  	ptp_qoriq->irq = irq->msi_desc->irq;
>  
> -	err = devm_request_threaded_irq(dev, ptp_qoriq->irq, NULL,
> -					dpaa2_ptp_irq_handler_thread,
> -					IRQF_NO_SUSPEND | IRQF_ONESHOT,
> -					dev_name(dev), ptp_qoriq);
> +	err = request_threaded_irq(ptp_qoriq->irq, NULL,
> +				   dpaa2_ptp_irq_handler_thread,
> +				   IRQF_NO_SUSPEND | IRQF_ONESHOT,
> +				   dev_name(dev), ptp_qoriq);
>  	if (err < 0) {
>  		dev_err(dev, "devm_request_threaded_irq(): %d\n", err);
>  		goto err_free_mc_irq;
> @@ -173,7 +173,7 @@ static int dpaa2_ptp_probe(struct fsl_mc_device *mc_dev)
>  				   DPRTC_IRQ_INDEX, 1);
>  	if (err < 0) {
>  		dev_err(dev, "dprtc_set_irq_enable(): %d\n", err);
> -		goto err_free_mc_irq;
> +		goto err_free_threaded_irq;
>  	}
>  
>  	err = ptp_qoriq_init(ptp_qoriq, base, &dpaa2_ptp_caps);

There is another goto right here which still jumps to err_free_mc_irq
rather than err_free_threaded_irq. Is that intentional?

> @@ -185,6 +185,8 @@ static int dpaa2_ptp_probe(struct fsl_mc_device *mc_dev)
>  
>  	return 0;
>  
> +err_free_threaded_irq:
> +	free_irq(ptp_qoriq->irq, ptp_qoriq);
>  err_free_mc_irq:
>  	fsl_mc_free_irqs(mc_dev);
>  err_unmap:

