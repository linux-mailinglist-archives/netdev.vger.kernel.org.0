Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C398F2E1DB2
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 16:02:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727880AbgLWPCv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 10:02:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbgLWPCu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 10:02:50 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50F90C061793;
        Wed, 23 Dec 2020 07:02:10 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id c7so16460656edv.6;
        Wed, 23 Dec 2020 07:02:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Oj1uLQphjM5m67YDASt6Wdxp/c4NyvEZdxL2VxWRwS8=;
        b=RWOG23AoTw1lOJcOYpr6/hBrgxOLufI8yrMWh9D0JjhPq4VQ4NfMXISCMAwQafwBZs
         tcPHIHpKKJGtUqgvn5Z5+mUhZDzhE+7+HAf/3yWam36cIwFcl2Rmpa/nYjE/btU8wsOl
         /XggaFpOG7IXRc6yhBcRifDapxygw4xWGvyNI5oP08+tQh7yxyz/kgv9k3zlhDpfdE9O
         jlGNuSCLz9Q2c/dyL9fuIUNU9K24ePegh7K2PWA7u0xfl0I3aw3h78g2kun5uUlrlYx2
         QIPffj+fEOVOVejodpbrgVaI1R+vchNMn6hZOVSUDnx1QmrqFQwh7OZbtXmO2DVGTMvw
         ItRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Oj1uLQphjM5m67YDASt6Wdxp/c4NyvEZdxL2VxWRwS8=;
        b=t1GKhDWcebDUWQpDTAiOdStJcVsIn/24TEdO8gjP/19H1QFulSDZv7lbL1g+BDdRV0
         zIOeLDei/219LdLfKv65cZZJ3kujhd9+yOs7D0THsIO9vX9F3zWifsFI98wEq97xbfjl
         4Lj3AJGSxM9pNBc8D/Yb9gopNClggrLG1x9Kdqhbua2mC0xS7AmoBSlLmeId/ffjSmtL
         jSBCtIQ4DHDezCvPlzye9+NCFLsdUwVy9JLGA6LDg8+HGdBI6JFtd+LsJa1vfSJRtLQ2
         S5W6Nt8x5J+IHhs09Tsqy9pT6DnbjFY9eW7u9Tp8io6vjUjRpRG1EVHNX+vLcuAkN2XX
         eAjw==
X-Gm-Message-State: AOAM5318NELdMgZT1VV3s72lXzHumz5xnPZxSzGYgbdL9fmczwIJP2zG
        egV0cmZo022sPiXlebgsnazj4Woadac=
X-Google-Smtp-Source: ABdhPJwJsQG0ksLeVR+faNKXCvdcUfX+FYmdg82lxtNlMXDAgpc6ElHfXuCO8g1yUj5hWvDkjFDx7w==
X-Received: by 2002:a05:6402:2710:: with SMTP id y16mr14773513edd.21.1608735728783;
        Wed, 23 Dec 2020 07:02:08 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:f15a:e2ad:a009:fa06? (p200300ea8f065500f15ae2ada009fa06.dip0.t-ipconnect.de. [2003:ea:8f06:5500:f15a:e2ad:a009:fa06])
        by smtp.googlemail.com with ESMTPSA id g10sm30898976edu.97.2020.12.23.07.02.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Dec 2020 07:02:08 -0800 (PST)
Subject: Re: [PATCH -next] intel/iwlwifi: use DEFINE_MUTEX (and mutex_init()
 had been too late)
To:     Zheng Yongjun <zhengyongjun3@huawei.com>, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20201223141152.32564-1-zhengyongjun3@huawei.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <35876d6b-f5bd-daed-f2e3-cb78e9bc8206@gmail.com>
Date:   Wed, 23 Dec 2020 16:02:03 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201223141152.32564-1-zhengyongjun3@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23.12.2020 15:11, Zheng Yongjun wrote:
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> ---
>  drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
> index 9dcd2e990c9c..71119044382f 100644
> --- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
> +++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
> @@ -133,7 +133,7 @@ enum {
>  };
>  
>  /* Protects the table contents, i.e. the ops pointer & drv list */
> -static struct mutex iwlwifi_opmode_table_mtx;
> +static DEFINE_MUTEX(iwlwifi_opmode_table_mtx);
>  static struct iwlwifi_opmode_table {
>  	const char *name;			/* name: iwldvm, iwlmvm, etc */
>  	const struct iwl_op_mode_ops *ops;	/* pointer to op_mode ops */
> @@ -1786,8 +1786,6 @@ static int __init iwl_drv_init(void)
>  {
>  	int i, err;
>  
> -	mutex_init(&iwlwifi_opmode_table_mtx);
> -
>  	for (i = 0; i < ARRAY_SIZE(iwlwifi_opmode_table); i++)
>  		INIT_LIST_HEAD(&iwlwifi_opmode_table[i].drv);
>  
> 
The change itself is ok, but:
- commit message is missing (did you run checkpatch?)
- Why should the current mutex_init() call be too late?
