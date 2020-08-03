Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBEBB23ABC4
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 19:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbgHCRlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 13:41:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbgHCRlG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 13:41:06 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59136C06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 10:41:06 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id l60so330596pjb.3
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 10:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ct+gHTv9M+sZSSdYbof9J8RLkflBsAKZLGIPpxg6dgI=;
        b=YE9ROR55spcdnc0x8Genub0jtIyHrcohsnHekC5IWO263Lr86SBFhG2Q5TGVKib32J
         W74Lh8ragtTz15IHFKT1DVaePgg2fSDACPQV9bWouC9puwdRWEHmkJ4IfJEfUX5ihxS6
         ltoSWKvGYXgZcKInYskCzdF2JAWDoeeIHvzjX0LkcCTNV9/rVL5Q3/gMPdqWikB3WipG
         ctzyAB6vD1yozMxlwoKL5d3KFYiumaTbU8hGor+YUr767YTUT6T2I6O7zlWR/1gDElmo
         JyJZ6jFBzOPRY77dAZXc6v+In36YtYgiBALk1S3/EpHsU8WaVBt5QzEXTdIW/wo8mGD+
         +AdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ct+gHTv9M+sZSSdYbof9J8RLkflBsAKZLGIPpxg6dgI=;
        b=R644a0p5kn9VrIqxjv1Jfq3kHMiC78JCxxljlup2Rgt3rmi9xK2vMCcRkWPlAzHjgm
         cVMgPdO1m0ztvpOlwpqcnXjpVRRZNHVgrwo8dKynXlc1j6i/ngDGTRvIspaMEVZeVjdR
         RUNIBrcCQE3bpMzf+eoPwIZed4Cgghp5LvhBIiD35HobjBEioykPle7fKW3rKHiBYOOq
         CViNup2HX/PtepyrPcM96FLTASxBklfOM8PRgq+nN9zw6VisR40aCOhrTeUKWCCQVpCt
         FXR4R8uPRW30qcwo460zyYju+hZT/i+Ben1mM8ydvB1BVoEZVvuzqiyBUaIGoztvEA3g
         DjNQ==
X-Gm-Message-State: AOAM5312sWjKKOaQcuiKT1W/sb3lK2ugfUUAr6rHYDWSuvmkgalUzoDd
        EvpYNcBJSDJ6ympDBnpz8/I=
X-Google-Smtp-Source: ABdhPJzwBKI+NxUmlUAwiAa5OL9m5ftrcNKTrqk5djmuUsyhu3ZTEv5YljCbQ+9Tj6nXLH+bjtPVlw==
X-Received: by 2002:a17:90b:1903:: with SMTP id mp3mr417414pjb.14.1596476465903;
        Mon, 03 Aug 2020 10:41:05 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a24sm19988873pfg.113.2020.08.03.10.41.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2020 10:41:05 -0700 (PDT)
Subject: Re: [PATCH v4 05/11] net: dsa: microchip: ksz8795: dynamic allocate
 memory for flush_dyn_mac_table
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>, andrew@lunn.ch
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kernel@pengutronix.de
References: <20200803054442.20089-1-m.grzeschik@pengutronix.de>
 <20200803054442.20089-6-m.grzeschik@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <0b531a88-acde-07bc-1fa3-b95c5bc08ded@gmail.com>
Date:   Mon, 3 Aug 2020 10:40:59 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200803054442.20089-6-m.grzeschik@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/2/2020 10:44 PM, Michael Grzeschik wrote:
> To get the driver working with other chips using different port counts
> the dyn_mac_table should be flushed depending on the amount of physical
> ports.
> 
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> 
> ---
> v1 -> v4: - extracted this change from bigger previous patch
> 
>  drivers/net/dsa/microchip/ksz8795.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
> index 947ea1e45f5b2c6..ba722f730bf0f7b 100644
> --- a/drivers/net/dsa/microchip/ksz8795.c
> +++ b/drivers/net/dsa/microchip/ksz8795.c
> @@ -750,11 +750,11 @@ static void ksz8795_port_stp_state_set(struct dsa_switch *ds, int port,
>  
>  static void ksz8795_flush_dyn_mac_table(struct ksz_device *dev, int port)
>  {
> -	u8 learn[TOTAL_PORT_NUM];
> +	u8 *learn = kzalloc(dev->mib_port_cnt, GFP_KERNEL);

There is no error checking on this allocation, and you could consider
propagating an allocation failure back to the caller for graceful handling.
-- 
Florian
