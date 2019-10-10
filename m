Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05667D313B
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 21:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbfJJTRg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 15:17:36 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38548 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbfJJTRg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 15:17:36 -0400
Received: by mail-wm1-f65.google.com with SMTP id 3so7899574wmi.3;
        Thu, 10 Oct 2019 12:17:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uuIo5G1j8JdYWkm8a2AXwPr729T9AqWFq/hV8sTFav4=;
        b=t/AhgBSAiRfKCfO0kr+fpusDLUTbJFX/Yx6/wD8w5UDE9MvKaM0Q4iBT9laKk3282P
         enMyLskjPsBINzuM+HOlI3YmAc2W9+UvSZX8hgMZRgg6lG5QhW021hHWwgjdFPE9OFd9
         DExDLxcLSlq+xdrqF4+au5fZIZ5kuT9ppFTZzTH+OFU2LTBzrF7kFSx6Plc5qAXQ+RqB
         ex+a0XTmyx4DLEadOa3//5vpD9HD2n3pWqKSYBCEi04PQm836NC43T4tRcoLG9+Fq2rO
         CbpU5Cw1jt5CxgLL01oOmGogbrALnClge4IFLl6Zk91DZ/gj4JHTgGtbj3zk8Cj9B7yv
         rWEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uuIo5G1j8JdYWkm8a2AXwPr729T9AqWFq/hV8sTFav4=;
        b=kfv6mlfD60KvIzB+ucIi3TAG6rq/DH07hfjsPfckk7/vpVcUvmI1h5uaNTvhu3k9xb
         2xLIbrLkzB2kGfuxkRwEdg34V4j87cLN77cEIm1Mf8QfkRRYabdRoIkIfJB00FIbrrbZ
         8pBpZgGpddlgAoyE+EU3Wu1WQx4Ie7xqymPbxVY6QqZ7rF8w6z0jiy+Eg2CvW3v+80At
         9a1KMtTc1cxCcUuZYdzBObDDMlJZp9vugJPJKZpg19EmsIMZHhOn+jHCL2eWGJ0B8GOt
         S5tt/6HgjZozxFmIep+YyUIj1KljMY3xo/iGHMtZBFLRDERxt3DPahno5ZLN2U6lAGne
         hDRA==
X-Gm-Message-State: APjAAAWqbPRXgGwrEgbVQ8iOWS5gefHwp6Jdpta2gsU9oLRElLJvA3Uv
        V/gx5IxIEsbx6p5q+tCeoCg=
X-Google-Smtp-Source: APXvYqyjE7MnNnJi1GR1xAalT9DSuFjbdrYz5QVNqqcYlQcWh3at5fCxSLtDIUfa1M2NJQfLqmtRqg==
X-Received: by 2002:a7b:ce89:: with SMTP id q9mr114443wmj.2.1570735053819;
        Thu, 10 Oct 2019 12:17:33 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f26:6400:1d9e:f0ba:1c44:fdf8? (p200300EA8F2664001D9EF0BA1C44FDF8.dip0.t-ipconnect.de. [2003:ea:8f26:6400:1d9e:f0ba:1c44:fdf8])
        by smtp.googlemail.com with ESMTPSA id f18sm4507445wmh.43.2019.10.10.12.17.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Oct 2019 12:17:33 -0700 (PDT)
Subject: Re: [RFC PATCH net] net: phy: Fix "link partner" information
 disappear issue
To:     Yonglong Liu <liuyonglong@huawei.com>, davem@davemloft.net,
        andrew@lunn.ch, Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, salil.mehta@huawei.com,
        yisen.zhuang@huawei.com, shiju.jose@huawei.com
References: <1570699808-55313-1-git-send-email-liuyonglong@huawei.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <ee969d27-debe-9bc4-92f2-fe5b04c36a39@gmail.com>
Date:   Thu, 10 Oct 2019 21:17:25 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1570699808-55313-1-git-send-email-liuyonglong@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10.10.2019 11:30, Yonglong Liu wrote:
> Some drivers just call phy_ethtool_ksettings_set() to set the
> links, for those phy drivers that use genphy_read_status(), if
> autoneg is on, and the link is up, than execute "ethtool -s
> ethx autoneg on" will cause "link partner" information disappear.
> 
> The call trace is phy_ethtool_ksettings_set()->phy_start_aneg()
> ->linkmode_zero(phydev->lp_advertising)->genphy_read_status(),
> the link didn't change, so genphy_read_status() just return, and
> phydev->lp_advertising is zero now.
> 
I think that clearing link partner advertising info in
phy_start_aneg() is questionable. If advertising doesn't change
then phy_config_aneg() basically is a no-op. Instead we may have
to clear the link partner advertising info in genphy_read_lpa()
if aneg is disabled or aneg isn't completed (basically the same
as in genphy_c45_read_lpa()). Something like:

if (!phydev->autoneg_complete) { /* also covers case that aneg is disabled */
	linkmode_zero(phydev->lp_advertising);
} else if (phydev->autoneg == AUTONEG_ENABLE) {
	...
}

> This patch call genphy_read_lpa() before the link state judgement
> to fix this problem.
> 
> Fixes: 88d6272acaaa ("net: phy: avoid unneeded MDIO reads in genphy_read_status")
> Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
> ---
>  drivers/net/phy/phy_device.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 9d2bbb1..ef3073c 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -1839,6 +1839,10 @@ int genphy_read_status(struct phy_device *phydev)
>  	if (err)
>  		return err;
>  
> +	err = genphy_read_lpa(phydev);
> +	if (err < 0)
> +		return err;
> +
>  	/* why bother the PHY if nothing can have changed */
>  	if (phydev->autoneg == AUTONEG_ENABLE && old_link && phydev->link)
>  		return 0;
> @@ -1848,10 +1852,6 @@ int genphy_read_status(struct phy_device *phydev)
>  	phydev->pause = 0;
>  	phydev->asym_pause = 0;
>  
> -	err = genphy_read_lpa(phydev);
> -	if (err < 0)
> -		return err;
> -
>  	if (phydev->autoneg == AUTONEG_ENABLE && phydev->autoneg_complete) {
>  		phy_resolve_aneg_linkmode(phydev);
>  	} else if (phydev->autoneg == AUTONEG_DISABLE) {
> 

