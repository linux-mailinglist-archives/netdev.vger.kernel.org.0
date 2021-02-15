Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BFE531BEA6
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 17:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbhBOQOn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 11:14:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232624AbhBOP7Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 10:59:24 -0500
Received: from mail-oo1-xc30.google.com (mail-oo1-xc30.google.com [IPv6:2607:f8b0:4864:20::c30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23E3CC0613D6;
        Mon, 15 Feb 2021 07:58:44 -0800 (PST)
Received: by mail-oo1-xc30.google.com with SMTP id z36so1634418ooi.6;
        Mon, 15 Feb 2021 07:58:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WEACmCkgL/TM4hrtjiINmc1isFYTeQEPw/cMrn0TOb8=;
        b=pxCnbeanx20AM85pB9UePv+EUKwTcmmMHTq33viceAq5x5Lo3xrjSGaZ1JHgngvSiJ
         sYbmLHNDHJXxvSpb5aFLVfME/p37XMw/roWLW8VewXfUhFKINStji5A97O+eF1gwTyXU
         hAGvNx0HtN2RoAx2eT3HqRH6HSKzK2CQgJpSklFNZc+rm194Rk9Rorr+XZl6YlJ1vvmK
         foIRc6MtNcCOzTRjohd5d9jPNFaJhdA8BCRBIykfV9uf+Z91tla+15R+beP7FmeSwFnc
         6lrjGB2w9xgfGVIe8Uf3xnkrktdcmj7IcMwXK3ig8FtrJOvjrN0JmXn30Iu/+SPtN1BW
         vRqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WEACmCkgL/TM4hrtjiINmc1isFYTeQEPw/cMrn0TOb8=;
        b=HDHzCja5H5PFpr+8/o+IzkqHYPjLvwuWUGlSir09/RzD72V8xGMS/ULHhmcy74JD9w
         BPloPy4f+/Hjfg8BE3DuLR7R4QMRqFfOp9T/w85xFuyb6F8ehrjXn0YxjRDCrlWfcS+n
         nQtkPzzX30+kzf+ohCtq/3/vKfDK3zp+SbVrmLh3YPcL6pnfjVI4Mr87P0V8jyGirvZV
         dSxAq+SDKO67KjYbr7VP/wXesNzxUemY5kFxnffMGEGYSabW5cwf15jNvqNsIwQPSC0A
         yzrWeM0tssU65zgA9Je0PPzVDT3qd45XjEDgdVcno3/M/IK/6LGn2EYvYKNssz3dJ/x6
         fzrg==
X-Gm-Message-State: AOAM530o8CWuvdh0utl7NgYIxfIth32g5GaLDQvXqaCeggAi/5Hu6wYM
        Zg6Hl0vgVw4iTG8Y+mEpVUm31mNam4M=
X-Google-Smtp-Source: ABdhPJyey6pEye22s5MbAnms/IMF/0TE5yuvKM3/n0AGkX9+CrcF435g/f0ANgpkmjk8OgbJ1Ohw2Q==
X-Received: by 2002:a4a:96b3:: with SMTP id s48mr11234851ooi.11.1613404723229;
        Mon, 15 Feb 2021 07:58:43 -0800 (PST)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id o98sm3728749ota.0.2021.02.15.07.58.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Feb 2021 07:58:42 -0800 (PST)
Sender: Larry Finger <larry.finger@gmail.com>
Subject: Re: [PATCH] b43: N-PHY: Fix the update of coef for the PHY revision
 >= 3case
To:     Colin King <colin.king@canonical.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        "John W . Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210215120532.76889-1-colin.king@canonical.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <a1f578d8-bfaf-ec92-7874-84a586385495@lwfinger.net>
Date:   Mon, 15 Feb 2021 09:58:41 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210215120532.76889-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/15/21 6:05 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The documentation for the PHY update [1] states:
> 
> Loop 4 times with index i
> 
>      If PHY Revision >= 3
>          Copy table[i] to coef[i]
>      Otherwise
>          Set coef[i] to 0
> 
> the copy of the table to coef is currently implemented the wrong way
> around, table is being updated from uninitialized values in coeff.
> Fix this by swapping the assignment around.
> 
> [1] https://bcm-v4.sipsolutions.net/802.11/PHY/N/RestoreCal/
> 
> Fixes: 2f258b74d13c ("b43: N-PHY: implement restoring general configuration")
> Addresses-Coverity: ("Uninitialized scalar variable")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>   drivers/net/wireless/broadcom/b43/phy_n.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/broadcom/b43/phy_n.c b/drivers/net/wireless/broadcom/b43/phy_n.c
> index b669dff24b6e..665b737fbb0d 100644
> --- a/drivers/net/wireless/broadcom/b43/phy_n.c
> +++ b/drivers/net/wireless/broadcom/b43/phy_n.c
> @@ -5311,7 +5311,7 @@ static void b43_nphy_restore_cal(struct b43_wldev *dev)
>   
>   	for (i = 0; i < 4; i++) {
>   		if (dev->phy.rev >= 3)
> -			table[i] = coef[i];
> +			coef[i] = table[i];
>   		else
>   			coef[i] = 0;
>   	}
> 

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Good catch, thanks.

Larry

