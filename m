Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC643A6B30
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 18:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234533AbhFNQEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 12:04:05 -0400
Received: from mail-lf1-f51.google.com ([209.85.167.51]:40924 "EHLO
        mail-lf1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233779AbhFNQEE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 12:04:04 -0400
Received: by mail-lf1-f51.google.com with SMTP id k40so21940511lfv.7;
        Mon, 14 Jun 2021 09:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FV9HGOUAE7b4IZzZmRAbso8S6XwSXYjDPYy+Xj3hAAg=;
        b=KCe2OsJe+ygPPHOLSI6DFy56Z1+7CVqaNtiQdXJAhaMEk+K8Nkl1s0A2qXAw3PNu5k
         EqLLmSpkJAxkQGn6lsrHSBPILY8aUqCTZIHGtNEZQkeT5D20K0w6qRgKQXATLwp8nJF6
         jZ8NUF5tJVOamjef2Mu6EIJu9mu6PlO8D9oweKesmyyXR+4gj1v2NUY9H5nzEewyT547
         Ad5engDloXONKDcOrQRDqLz/E99iFSVEsHKRKGFPPb67Yximw2RyyytCJRG1IBtdflIb
         dwFbqodZuFwINSD9uT2wgvfqg4+tGPZL5IiGC+KO9h3I4rVXOElNIWZ8Z6n94XiNeY/C
         SfWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FV9HGOUAE7b4IZzZmRAbso8S6XwSXYjDPYy+Xj3hAAg=;
        b=qEz2WZ6PLYRiQHSX7sM+0PC94/LlqKHn1/g8nBuKy5/znzQGOhNljdPWENS+AdWy53
         +r4uzEn8bnr7KiFB4Pfg2Yu6cQ+CKj9Yoy/2rGOETSvwaMH9JUapcpv7RRv5BE97oxOC
         AZmQcPRLSLqO+t0f80ZUdW+DFycP2BL0orxYB22NC5VhjCs61PKuwToBUfM0fqxpEE3x
         Ok/8W/bDZmpwVUPF3ueLtw17bHspcUBbpk+LW9pInzYrRpJ0dWuGUVzhBqCQ1INrJHUh
         IOj4ToEO6zpnDlmZOPPTQidCai+bFEk6nCNYCXKAJIwvsykLqCh7k1QBhx8v28lzfl+Z
         qqMg==
X-Gm-Message-State: AOAM530E/nykHfmxUFg5xd9nnlcT0hbTDW+nXkQ2Q6fKnw5fpViDU0Ie
        K1Wk/y37Jnox/JD40gza8J0=
X-Google-Smtp-Source: ABdhPJw2/JOEKiGuLWuRM2C7SZE/UXE6y6M9zal/gIoxum9HS86rIuVgxgwI8Df6wDRmbBUoL2PEZA==
X-Received: by 2002:a05:6512:31c2:: with SMTP id j2mr11990556lfe.69.1623686450083;
        Mon, 14 Jun 2021 09:00:50 -0700 (PDT)
Received: from localhost.localdomain ([94.103.229.24])
        by smtp.gmail.com with ESMTPSA id o8sm942948ljj.108.2021.06.14.09.00.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 09:00:49 -0700 (PDT)
Date:   Mon, 14 Jun 2021 19:00:45 +0300
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     Dongliang Mu <mudongliangabcd@gmail.com>
Cc:     steve.glendinning@shawell.net, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: usb: fix possible use-after-free in smsc75xx_bind
Message-ID: <20210614190045.5b4c92e6@gmail.com>
In-Reply-To: <20210614153712.2172662-1-mudongliangabcd@gmail.com>
References: <20210614153712.2172662-1-mudongliangabcd@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Jun 2021 23:37:12 +0800
Dongliang Mu <mudongliangabcd@gmail.com> wrote:

> The commit 46a8b29c6306 ("net: usb: fix memory leak in smsc75xx_bind")
> fails to clean up the work scheduled in smsc75xx_reset->
> smsc75xx_set_multicast, which leads to use-after-free if the work is
> scheduled to start after the deallocation. In addition, this patch
> also removes one dangling pointer - dev->data[0].
> 
> This patch calls cancel_work_sync to cancel the schedule work and set
> the dangling pointer to NULL.
> 
> Fixes: 46a8b29c6306 ("net: usb: fix memory leak in smsc75xx_bind")
> Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> ---
>  drivers/net/usb/smsc75xx.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/usb/smsc75xx.c b/drivers/net/usb/smsc75xx.c
> index b286993da67c..f81740fcc8d5 100644
> --- a/drivers/net/usb/smsc75xx.c
> +++ b/drivers/net/usb/smsc75xx.c
> @@ -1504,7 +1504,10 @@ static int smsc75xx_bind(struct usbnet *dev,
> struct usb_interface *intf) return 0;
>  
>  err:
> +	cancel_work_sync(&pdata->set_multicast);
>  	kfree(pdata);
> +	pdata = NULL;
> +	dev->data[0] = 0;
>  	return ret;
>  }
>  

Hi, Dongliang!

Just my thougth about this patch:

INIT_WORK(&pdata->set_multicast, smsc75xx_deferred_multicast_write);
does not queue anything, it just initalizes list structure and assigns
callback function. The actual work sheduling happens in
smsc75xx_set_multicast() which is smsc75xx_netdev_ops member.

In case of any error in smsc75xx_bind() the device registration fails
and smsc75xx_netdev_ops won't be registered, so, i guess, there is no
chance of UAF. 


Am I missing something? :)



With regards,
Pavel Skripkin
