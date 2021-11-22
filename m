Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E688E4587C4
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 02:33:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232814AbhKVBf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 20:35:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229594AbhKVBf6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Nov 2021 20:35:58 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D167FC061574;
        Sun, 21 Nov 2021 17:32:52 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id v1so36257070edx.2;
        Sun, 21 Nov 2021 17:32:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dtrG122PK/pe3zz7HChwJghF+cpObBxIMhQLI4yJC7U=;
        b=lYM0w4KaMctdfGjG9qHXx/w26dxO6GP/VLkadnKKHZqlxKw7E1zC9Mhkm7/VeJ9xqN
         UcjKM7VWZkvmEkCNplMcByMsvp+0ce1yTD66Dj7Y90GiX/4IGPEF1vkH+riLSCSYEcM3
         yUvt0Vs7iGu0ufAtbWA60kEbpD4gWQEW/98EwtmaLRrbfKOZhyR25rk2MpC6u8TE+geH
         1F0W6pzPn0hZhPfsypBZAMOCq0UtSbhguKui3zhj+eTF7uVuNXdLHKUYYOA9KICr0ZRi
         McVWlOt0Vb3QPyRhdc6knvecJd9nJrnepTADCxDvdcuUtGRLMSfgJHROV4x3mGaK/dZ8
         gkHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dtrG122PK/pe3zz7HChwJghF+cpObBxIMhQLI4yJC7U=;
        b=sdQpVCU0N7BbtAyS6/75ZPB8RQf3J2HsBl6GnbsX98T3zWCfgB4+eeIyfY4Y+gGZLn
         B91YkWht7r2NX4zvddGirdLhtRy1Wl1fHSGi6vmWl2Py86e4C82SOjJLKa1RtJG2Ckm3
         5fGBRddmviYtKCfKMbxNcQWvJJ5Q0U5DDa4jI8vqZD29L8jgPDzP9pK+0cWDNr33YAqL
         CUXL9NY6pwmE2OgW97XJqZA6B3T38d6m/diMz4UgPjRk61FVtYdqz+ClaD4ugbCVQkRm
         zrJKyssDNBcMRGtC0POF5VwOWcU3OuVHZ8wR2VI9oKg8z2aLRjRX4iD3xoxe0ykj34DK
         Hm8g==
X-Gm-Message-State: AOAM530MoQ7dx7HYgrYB30v2z/PWYtEdBL/qzAA0rw5HcEZPPkTdZE7K
        LMeJRrmzWGcrkuCC23Vsk5I=
X-Google-Smtp-Source: ABdhPJy65duGXQysj/LZ6soVlYRMmUPpjtV4qgVilBCptynHiqeswcr7CplQxmoG4k+KetcZFtCYvw==
X-Received: by 2002:a50:c212:: with SMTP id n18mr56040420edf.211.1637544771493;
        Sun, 21 Nov 2021 17:32:51 -0800 (PST)
Received: from skbuf ([188.25.163.189])
        by smtp.gmail.com with ESMTPSA id ho17sm2967325ejc.111.2021.11.21.17.32.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Nov 2021 17:32:51 -0800 (PST)
Date:   Mon, 22 Nov 2021 03:32:50 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH v2 3/9] net: dsa: qca8k: remove extra mutex_init
 in qca8k_setup
Message-ID: <20211122013250.6r5khagqtwipamcv@skbuf>
References: <20211122010313.24944-1-ansuelsmth@gmail.com>
 <20211122010313.24944-4-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211122010313.24944-4-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 22, 2021 at 02:03:07AM +0100, Ansuel Smith wrote:
> Mutex is already init in sw_probe. Remove the extra init in qca8k_setup.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
