Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 719FE7710B
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 20:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728594AbfGZSPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 14:15:02 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37381 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726781AbfGZSPC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 14:15:02 -0400
Received: by mail-wm1-f67.google.com with SMTP id f17so48395842wme.2;
        Fri, 26 Jul 2019 11:15:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JKw39pI2llb7A01NXuEKDfaC4+iRUymYwQL0imdPSKs=;
        b=dNqzYdVqcZfPAziZ23MpFrZNMRjes+fGTgZkSQ1C+5pbkn7xHFhvm8aXQ1gHZJW9ZH
         El2HrLr604GsqqIFQg5uuc+Zg0CY4Ust2WMYx5pWJnVbQFNF9lbeDcv6H/gu5PRS3x8B
         nBp3Aut03vN4wALa1S8wR/68wgUpJxD8UlMbQdqpvaj1ca03j5ULZ+UB5HD6pmjTQjzR
         gg/ttUspqIuZ9YJdsrWGXq0oolILm02GG1l9aflkLD+c/+MOup7a5dV9pNvTTCSTp8uD
         qs/fL5gzo4gnV+OBdwvaDSLxDtbf6s7lprq1Q9wPXS6IT8NucSkx2or0ekft2KeT1Ahm
         zlXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JKw39pI2llb7A01NXuEKDfaC4+iRUymYwQL0imdPSKs=;
        b=ffhg1Hl2sxi1CDhgpLTgrdvghFHnLaONSZcBb1+Ps/f57AsTJrXluGijcE+CQ3W2ic
         cgCFMzZlIoHWIFYigmI8r2FnpFAO/lKnqFpeFAYAGdIBJUHjxm7FszaVBM9mhNECD/8Z
         P67odqxA6iCVoodR0jFMnCdduyEYom3nvxgscwxg+yUX55r9JZESx9XCOOdkrCpQm+oY
         PQGeYR5MIr02QG7uapWLDw3FIfr5PzEpzSJSe3QeCg9zDC+fuq5/gDcZhnmEXV+3GmV/
         m/OLxDLec0VaKYvj88nzPXDG0lcr7jnbZLxNk45DFsa9cTQGo9meFcOBc0QzS7xyFSlr
         XFtQ==
X-Gm-Message-State: APjAAAWlGmE5LZGSSXreYO7Se0eZnOXInJql37hrIjcsZjc7EU9uQ2Nt
        0EPw173Ts8rD3Vis0yk0fCM=
X-Google-Smtp-Source: APXvYqxYXMQI2HJ97cUHUaomwuteph1EY3UXRjsSSsubmMq20Bid28heJ2nMYVrj8lNHRSbGUubIAw==
X-Received: by 2002:a05:600c:230c:: with SMTP id 12mr83673655wmo.166.1564164899711;
        Fri, 26 Jul 2019 11:14:59 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f43:4200:55f1:e404:698f:358? (p200300EA8F43420055F1E404698F0358.dip0.t-ipconnect.de. [2003:ea:8f43:4200:55f1:e404:698f:358])
        by smtp.googlemail.com with ESMTPSA id u6sm54367668wml.9.2019.07.26.11.14.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2019 11:14:59 -0700 (PDT)
Subject: Re: [RFC] net: phy: read link status twice when
 phy_check_link_status()
To:     Yonglong Liu <liuyonglong@huawei.com>, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, salil.mehta@huawei.com,
        yisen.zhuang@huawei.com, shiju.jose@huawei.com
References: <1564134831-24962-1-git-send-email-liuyonglong@huawei.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <92f42ee8-3659-87a7-ac96-d312a98046ba@gmail.com>
Date:   Fri, 26 Jul 2019 20:14:28 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1564134831-24962-1-git-send-email-liuyonglong@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26.07.2019 11:53, Yonglong Liu wrote:
> According to the datasheet of Marvell phy and Realtek phy, the
> copper link status should read twice, or it may get a fake link
> up status, and cause up->down->up at the first time when link up.
> This happens more oftem at Realtek phy.
> 
This is not correct, there is no fake link up status.
Read the comment in genphy_update_link, only link-down events
are latched. Means if the first read returns link up, then there
is no need for a second read. And in polling mode we don't do a
second read because we want to detect also short link drops.

It would be helpful if you could describe your actual problem
and whether you use polling or interrupt mode.

> I add a fake status read, and can solve this problem.
> 
> I also see that in genphy_update_link(), had delete the fake
> read in polling mode, so I don't know whether my solution is
> correct.
> 
> Or provide a phydev->drv->read_status functions for the phy I
> used is more acceptable?
> 
> Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
> ---
>  drivers/net/phy/phy.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> index ef7aa73..0c03edc 100644
> --- a/drivers/net/phy/phy.c
> +++ b/drivers/net/phy/phy.c
> @@ -1,4 +1,7 @@
>  // SPDX-License-Identifier: GPL-2.0+
> +	err = phy_read_status(phydev);
> +	if (err)
> +		return err;

This seems to be completely wrong at that place.

>  /* Framework for configuring and reading PHY devices
>   * Based on code in sungem_phy.c and gianfar_phy.c
>   *
> @@ -525,6 +528,11 @@ static int phy_check_link_status(struct phy_device *phydev)
>  
>  	WARN_ON(!mutex_is_locked(&phydev->lock));
>  
> +	/* Do a fake read */
> +	err = phy_read(phydev, MII_BMSR);
> +	if (err < 0)
> +		return err;
> +
>  	err = phy_read_status(phydev);
>  	if (err)
>  		return err;
> 

