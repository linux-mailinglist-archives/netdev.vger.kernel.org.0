Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4B6430282
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 13:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240376AbhJPMAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 08:00:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237354AbhJPMAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Oct 2021 08:00:14 -0400
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050::465:101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61ED4C061570;
        Sat, 16 Oct 2021 04:58:06 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4HWhV42KNVzQkBP;
        Sat, 16 Oct 2021 13:58:04 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hauke-m.de; s=MBO0001;
        t=1634385482;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zsKwS6F8UjWzhAlYTHRy4Hc+M+BiPhF7fV4hrQ8cfa4=;
        b=UgCKdTq8CohrRhsn3YjXVjEMreslxZcRenBy75dzDrB4s6bXATbear4SwxLqp8sXQaoH8p
        0xeBdOH+5Tll61/kh0kJLKKy65ZFiHma1aWcwP8tmSFlk2pcC7p9cz+w3ZqfzDarWyBcGh
        mRl8q6GBwII3NCvyGdTb+Ln6iWyIu4mLWDM825dPay2opaYQZUPGSI8IFWHd5/mBHHVPLV
        xHVL8H5OOGIzjAaep+JPJHpL3A+x6LQ5wvCglMReep0JB7DM2mADkppYe2c1vVb8U9InDf
        WwwbROpdvFIPKgkto8sMxk13drafdONfMikvCwagpxwnY5LaUbE5R5Ss3tw7KQ==
Subject: Re: [PATCH net] net: dsa: lantiq_gswip: fix register definition
To:     Aleksander Jan Bajkowski <olek2@wp.pl>, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211015221020.3590-1-olek2@wp.pl>
From:   Hauke Mehrtens <hauke@hauke-m.de>
Message-ID: <0abd339a-3a9b-edfc-d697-27fce492bdd0@hauke-m.de>
Date:   Sat, 16 Oct 2021 13:57:59 +0200
MIME-Version: 1.0
In-Reply-To: <20211015221020.3590-1-olek2@wp.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D509522F
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/16/21 12:10 AM, Aleksander Jan Bajkowski wrote:
> I compared the register definitions with the D-Link DWR-966
> GPL sources and found that the PUAFD field definition was
> incorrect. This definition is unused and causes no issues.
> 
> Fixes: 14fceff4771e ("net: dsa: Add Lantiq / Intel DSA driver for vrx200")
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>

Acked-by: Hauke Mehrtens <hauke@hauke-m.de>

Thanks for finding this problem.

> ---
>   drivers/net/dsa/lantiq_gswip.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
> index 3ff4b7e177f3..dbd4486a173f 100644
> --- a/drivers/net/dsa/lantiq_gswip.c
> +++ b/drivers/net/dsa/lantiq_gswip.c
> @@ -230,7 +230,7 @@
>   #define GSWIP_SDMA_PCTRLp(p)		(0xBC0 + ((p) * 0x6))
>   #define  GSWIP_SDMA_PCTRL_EN		BIT(0)	/* SDMA Port Enable */
>   #define  GSWIP_SDMA_PCTRL_FCEN		BIT(1)	/* Flow Control Enable */
> -#define  GSWIP_SDMA_PCTRL_PAUFWD	BIT(1)	/* Pause Frame Forwarding */
> +#define  GSWIP_SDMA_PCTRL_PAUFWD	BIT(3)	/* Pause Frame Forwarding */
>   
>   #define GSWIP_TABLE_ACTIVE_VLAN		0x01
>   #define GSWIP_TABLE_VLAN_MAPPING	0x02
> 

