Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B733D8DEF6
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 22:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728884AbfHNUh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 16:37:26 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:35943 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbfHNUhZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 16:37:25 -0400
Received: by mail-pf1-f194.google.com with SMTP id w2so52170pfi.3
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 13:37:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+VxcUkgMv5C6Owq6hhiGOKhlX0kBsP7MBfCttk6k1Us=;
        b=0IUppGsDxlHyQcKfLHuFd0H0tqux2bMDBNt+M9ss0PCKz5bACHobFhyOYp7Zj4EC1j
         9epvFIDrmlrsbzOUTkzM6YF/E8jZE/MKCPg1ByTtJ9FKnZJZPbOhafwVlAd1gARv0LnG
         IWcJuHoG0RxHuF0MnRIhMEMp2SRfyezE5FbAbKV/WLSJx2RdYZ70zDq3c+RoJpoq9EWh
         Wg5XNdDlCBBFnPig0ysqw4ZY7RW83xnu2TZFbBtry88P+W2HWhp1/hgX51AiuTONehOW
         bbaFLkj/CwBagVuF5Kip4D246zK0MK4Uy/dbMoEgmsAqRL7Qgqcc2Z+Trlftw6MYCaSA
         ZF0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+VxcUkgMv5C6Owq6hhiGOKhlX0kBsP7MBfCttk6k1Us=;
        b=V74nsqJ4c8VJdkIzXnwHkTpvwSRi5f1yx/fAohB3Vl7Xya/+kS5u29i7rk+oZLtB/k
         lF4YSexz4IHcfaegVJQ1iDiU0asHU926/Q9nG1JYFWw94xgNbc/jm0USo4O+Fpck8P8B
         Hm0na27CkST4UmzWnavMzrTyaCWfA5V6ey1BIkV24NO4UhSNVGTvTxhb/4psuFWBnWFZ
         TuRt3xFOEBYqJAzciaAj89Z0q9pe2McMHRN0togEaM1M17opecoGKDy9qT3NIPHesGtF
         fx1W5rH5zJnuIeT5g1r+N3on5iFA/Q224mQpa1enODbVjsOH/QavM4hdGheXc6ZacA4X
         28iw==
X-Gm-Message-State: APjAAAW2BvPYJTl+ud47s5m6wQQhjKtMwobscG4IygHuBJDbTv2xgWhN
        R+/jhpIWA9mvhYZlvqk92TZzTg==
X-Google-Smtp-Source: APXvYqxcGm5E951PLcX5Ut7DOoqZwMC1w9WWE8vb6odAAJNKWlIxebVN7cf4TB5eKyp/1ueFj6wl2Q==
X-Received: by 2002:a63:e901:: with SMTP id i1mr777506pgh.451.1565815044726;
        Wed, 14 Aug 2019 13:37:24 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id u18sm767106pfl.29.2019.08.14.13.37.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2019 13:37:24 -0700 (PDT)
Date:   Wed, 14 Aug 2019 13:37:17 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Wenwen Wang <wenwen@cs.uga.edu>
Cc:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-hyperv@vger.kernel.org (open list:Hyper-V CORE AND DRIVERS),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH] hv_netvsc: Fix a memory leak bug
Message-ID: <20190814133717.4172033e@hermes.lan>
In-Reply-To: <1565813771-8967-1-git-send-email-wenwen@cs.uga.edu>
References: <1565813771-8967-1-git-send-email-wenwen@cs.uga.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 14 Aug 2019 15:16:11 -0500
Wenwen Wang <wenwen@cs.uga.edu> wrote:

> In rndis_filter_device_add(), 'rndis_device' is allocated through kzalloc()
> by invoking get_rndis_device(). In the following execution, if an error
> occurs, the execution will go to the 'err_dev_remv' label. However, the
> allocated 'rndis_device' is not deallocated, leading to a memory leak bug.
> 
> Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
> ---
>  drivers/net/hyperv/rndis_filter.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
> index 317dbe9..ed35085 100644
> --- a/drivers/net/hyperv/rndis_filter.c
> +++ b/drivers/net/hyperv/rndis_filter.c
> @@ -1420,6 +1420,7 @@ struct netvsc_device *rndis_filter_device_add(struct hv_device *dev,
>  
>  err_dev_remv:
>  	rndis_filter_device_remove(dev, net_device);
> +	kfree(rndis_device);
>  	return ERR_PTR(ret);
>  }
>  

The rndis_device is already freed by:

rndis_filter_device_remove
	netvsc_device_remove
		free_netvsc_device_rcu

free_netvsc_device called by rcu

static void free_netvsc_device(struct rcu_head *head)
{
	struct netvsc_device *nvdev
		= container_of(head, struct netvsc_device, rcu);
	int i;

	kfree(nvdev->extension);  << here
