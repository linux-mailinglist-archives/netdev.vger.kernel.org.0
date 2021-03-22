Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F260D343FA7
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 12:27:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbhCVL0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 07:26:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbhCVL0Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 07:26:25 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1EC4C061574
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 04:26:24 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id 61so16250945wrm.12
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 04:26:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pOTsHRhiu0iIEj0RjAwVmMdK6j7gtOTyp3Ky7/dNNq8=;
        b=sGthxQKAW8wmue7GiGrCwzYEke246J1+/HR4dPx6nmw4pf/u8mtXmbfBBZa+0MCDcr
         Q/s4mIzMOiiEwajrnYKEZvql2qnYhp4yau6us7/yRGyw6VAsFVSjSvzkwnK64QAtFW/C
         6QzuW0dhC1Cee7mIIMweT8em85ij9Ov/Z07rLzC5Nn/hMqfXz7ANQQ4rU7KmPoMrm/G9
         4nTgJkDXmPKEwPUC/gGJ4+7CSaigGXFU7RAxSXQghIi0ljmcIc/OHc3At0t5kBHoWQRt
         rAMfFSLWmmjKuWIm4AqJ/rlrW7d20HsLjmvxi6mDFsIbC4LFhzJVZItpuBn9BrJ26Cko
         6DqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pOTsHRhiu0iIEj0RjAwVmMdK6j7gtOTyp3Ky7/dNNq8=;
        b=Z2AUI6I7xUxM6JGnigaep+0NQhyqWLuMDwRgf4vsJ1JekCKGLcnmSGV8RjfTzncBOY
         JEPptRTCdoriJgFYRDdWuFX88c+NwObPGkuw2N9zzU+KNy/sNbHa45jfaiKj6pevbHoC
         kZLOHfMvTl3E2QJNcmDnzObPSuDiyo4tPYDcQaXu4CnRfxhQKlBvqIK8QtKy9bjxaZFl
         SfpoWlUa2cV8g37ANoT5dDLDQ/IoHhhuZnqrm3K70bYqNSNUIPwW9VTq8lzV69CXI982
         4fl2L1h786c3AD4viAQ05ndNs8U2eZ/P8X1iB1tEPjlOC4VsEm3UKAKSAn6ybvUe01wh
         kBjQ==
X-Gm-Message-State: AOAM530Dz0uRLGHS1Ut0Kzre7oGc1domoGeQat0aq3wUox/nAYtoUh54
        +bLxVMuR8xDIt+BCs6UBqqU=
X-Google-Smtp-Source: ABdhPJy+2sp3OkESUuXh0xnc0DVQJMIURpMrJtMWZ6fEH4bO6yo4tQ9F27pu/ps16dRSoxsXlVtxbg==
X-Received: by 2002:a5d:5649:: with SMTP id j9mr11159251wrw.400.1616412383354;
        Mon, 22 Mar 2021 04:26:23 -0700 (PDT)
Received: from hthiery.fritz.box (ip1f1322f8.dynamic.kabel-deutschland.de. [31.19.34.248])
        by smtp.gmail.com with ESMTPSA id q15sm19468726wrr.58.2021.03.22.04.26.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 04:26:22 -0700 (PDT)
From:   Heiko Thiery <heiko.thiery@gmail.com>
To:     olteanv@gmail.com
Cc:     andrew@lunn.ch, davem@davemloft.net, dsahern@kernel.org,
        f.fainelli@gmail.com, kuba@kernel.org, netdev@vger.kernel.org,
        vladimir.oltean@nxp.com, yoshfuji@linux-ipv6.org,
        heiko.thiery@gmail.com
Subject: Re: [PATCH net] net: ipconfig: ic_dev can be NULL in ic_close_devs
Date:   Mon, 22 Mar 2021 12:25:52 +0100
Message-Id: <20210322112551.2704-1-heiko.thiery@gmail.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210322002637.3412657-1-olteanv@gmail.com>
References: <20210322002637.3412657-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

> ic_close_dev contains a generalization of the logic to not close a
> network interface if it's the host port for a DSA switch. This logic is
> disguised behind an iteration through the lowers of ic_dev in
> ic_close_dev.
> 
> When no interface for ipconfig can be found, ic_dev is NULL, and
> ic_close_dev:
> - dereferences a NULL pointer when assigning selected_dev
> - would attempt to search through the lower interfaces of a NULL
>   net_device pointer
> 
> So we should protect against that case.
> 
> The "lower_dev" iterator variable was shortened to "lower" in order to
> keep the 80 character limit.
> 
> Fixes: f68cbaed67cb ("net: ipconfig: avoid use-after-free in ic_close_devs")
> Fixes: 46acf7bdbc72 ("Revert "net: ipv4: handle DSA enabled master network devices"")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Tested-by: Heiko Thiery <heiko.thiery@gmail.com>

> ---
>  net/ipv4/ipconfig.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/net/ipv4/ipconfig.c b/net/ipv4/ipconfig.c
> index 47db1bfdaaa0..bc2f6ca97152 100644
> --- a/net/ipv4/ipconfig.c
> +++ b/net/ipv4/ipconfig.c
> @@ -309,7 +309,7 @@ static int __init ic_open_devs(void)
>   */
>  static void __init ic_close_devs(void)
>  {
> -	struct net_device *selected_dev = ic_dev->dev;
> +	struct net_device *selected_dev = ic_dev ? ic_dev->dev : NULL;
>  	struct ic_device *d, *next;
>  	struct net_device *dev;
>  
> @@ -317,16 +317,18 @@ static void __init ic_close_devs(void)
>  	next = ic_first_dev;
>  	while ((d = next)) {
>  		bool bring_down = (d != ic_dev);
> -		struct net_device *lower_dev;
> +		struct net_device *lower;
>  		struct list_head *iter;
>  
>  		next = d->next;
>  		dev = d->dev;
>  
> -		netdev_for_each_lower_dev(selected_dev, lower_dev, iter) {
> -			if (dev == lower_dev) {
> -				bring_down = false;
> -				break;
> +		if (selected_dev) {
> +			netdev_for_each_lower_dev(selected_dev, lower, iter) {
> +				if (dev == lower) {
> +					bring_down = false;
> +					break;
> +				}
>  			}
>  		}
>  		if (bring_down) {
> -- 
> 2.25.1


Thank you.

-- 
Heiko
