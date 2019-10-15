Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4DA7D7E07
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 19:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388231AbfJORpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 13:45:38 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:41636 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727542AbfJORph (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 13:45:37 -0400
Received: by mail-pg1-f194.google.com with SMTP id t3so12569646pga.8;
        Tue, 15 Oct 2019 10:45:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0Zw6zxuSC/nytxzOrlwgYWA4bamXdQBINNQlEwcpCSI=;
        b=eCwwFcgJDAKIfTUi/5rE/cW8Yvit1Khr8/Ykgd2TRiLtr37O1lK72uj2VnnCPn1vYK
         PfKWx1b+iS3CtKiugrcMIqChiGISE2RayQUnDHOD021eURkgLsNqDKKNNnyNg5AUNaka
         7gUr/NodR/nnDXIkJ6wB4vA78A1ZkB7lKQC2T6VBDAjJY0J7OfNT6xwC01VxVRX+5+K2
         jI6BVWHe51hfET0T8L6EcrPiSNNv4DOmUvrUntI9CkzsCy7OHTYTH5et3NLaUWRp/2X0
         +PAnz2ksnO+wIDj1H4jBUArUQf8SMSAAlPnqCYCxCA1fqrDj6YILFxRkkV+ijFp9X631
         tmqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=0Zw6zxuSC/nytxzOrlwgYWA4bamXdQBINNQlEwcpCSI=;
        b=WENX51LfW+kxKrwD9feaOOFYZQx4ZsoKXccgFffiM60/jcSyNXauNkaWyGwN9ZKRjc
         //p2IlDBWLXcNY38jkKoEiCb6vxpOEu9OgQle4G+h+1MrR4TLio6lCZBRgEe8uv+dqsD
         rAmUy7+T3npv7TiivvtDDHWDpA5AnXxp2KIbiZDY1ZNMwR/tK56uyPOl0MOA1QalyJt2
         HY1mzisZo33cWFewzj+W7glZRLyb7rAkB8a8sxrwsTk6d8nPfaD79nN+Wd6wL2u5rFca
         CEVRgNiVzXAVWABIfNSXgR1KnbPrsUG00pUp9ADbv262J8WQklxzKehSQa7XdLrpWIoF
         TU3A==
X-Gm-Message-State: APjAAAVRc/KzatnOdTj+8/WL5fME2JWxtUoWNZQMsgInilzIGu7ZBni8
        HX2T5CDKdeWHTF2+pvcDyuk/v8F2
X-Google-Smtp-Source: APXvYqxOoBpQh1qHbWikN9mSrlsJhXVAt8qzJC4nwkS8mDRAIe6rP4tNcr2NVr78Dub0D5RPYCSZvg==
X-Received: by 2002:a62:d408:: with SMTP id a8mr39277960pfh.15.1571161536469;
        Tue, 15 Oct 2019 10:45:36 -0700 (PDT)
Received: from [10.67.51.137] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id m34sm43134575pgb.91.2019.10.15.10.45.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Oct 2019 10:45:35 -0700 (PDT)
Subject: Re: [PATCH net-next] net: bcmgenet: Add a shutdown callback
To:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        "open list:BROADCOM GENET ETHERNET DRIVER" 
        <bcm-kernel-feedback-list@broadcom.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20191015173624.10452-1-f.fainelli@gmail.com>
From:   Doug Berger <opendmb@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=opendmb@gmail.com; prefer-encrypt=mutual; keydata=
 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 YVs=
Message-ID: <81a0edb7-efa9-2abd-6158-52504efab913@gmail.com>
Date:   Tue, 15 Oct 2019 10:45:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191015173624.10452-1-f.fainelli@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/15/19 10:36 AM, Florian Fainelli wrote:
> Make sure that we completely quiesce the network device, including its
> DMA to avoid having it continue to receive packets while there is no
> software alive to service those.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  drivers/net/ethernet/broadcom/genet/bcmgenet.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> index 12cb77ef1081..ecbb1e7353ba 100644
> --- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> +++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> @@ -3597,6 +3597,11 @@ static int bcmgenet_remove(struct platform_device *pdev)
>  	return 0;
>  }
>  
> +static void bcmgenet_shutdown(struct platform_device *pdev)
> +{
> +	bcmgenet_remove(pdev);
> +}
> +
>  #ifdef CONFIG_PM_SLEEP
>  static int bcmgenet_resume(struct device *d)
>  {
> @@ -3715,6 +3720,7 @@ static SIMPLE_DEV_PM_OPS(bcmgenet_pm_ops, bcmgenet_suspend, bcmgenet_resume);
>  static struct platform_driver bcmgenet_driver = {
>  	.probe	= bcmgenet_probe,
>  	.remove	= bcmgenet_remove,
> +	.shutdown = bcmgenet_shutdown,
>  	.driver	= {
>  		.name	= "bcmgenet",
>  		.of_match_table = bcmgenet_match,
> 

Acked-by: Doug Berger <opendmb@gmail.com>
