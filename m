Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00C0826EF86
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 04:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729084AbgIRCgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 22:36:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728086AbgIRCgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 22:36:11 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0717C06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 19:36:10 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id t14so2543208pgl.10
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 19:36:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TpX+MWmf8lHT6yzvVVTgauRFPyd+HhVEZd1wAr1I8fg=;
        b=MF2hVtW7zARsHY81yVpUspgVZ3Z0FsXY5TyE6r6m/JTOcD9oIttTCAZbPeqCjvsZag
         mqSIYbNt10SlMy/bpsgupkrsaDb1pYR3c3lNXaScqb8A8WP/fDT6wNiMW70w//emP/h2
         zBZExVyaX8WJOaZNpX0IdedmVgZd4kfUd5BuxiQZxxUbaTC1B1z2PbTTdqRnidVJw3wE
         v71/CbO/ZMTY2TAk00reSyvw5YglZvj+LnJIo/fvhGVyd7QUslwjOy8rIr1GVMptwiyQ
         dfPEnQQV/S2ag9X1+mGBPcK9AhsYK/SP1iVlGUrX76d3C8jla2WOkq5wy3xirJY50hVc
         LIRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TpX+MWmf8lHT6yzvVVTgauRFPyd+HhVEZd1wAr1I8fg=;
        b=L/IPlEVyFxvaYEh6/3KZ8zMzBBqyhAO67T6Rwfmg3XUW3g3p/CxYhxGp0L0cV9gLjH
         fLRSBoDeLDBu9KvheD81IjQopc02uAZFxYEGU0/PHPW9eCvlxzz/2WwAa3okUCVFwhO2
         ODHeZY8zGO1J2fjaxrHX4hmlW14f7aKWXSXczx0Dxs6zwFm7tJ1EF2kazPzQ93TsvgDZ
         s69izvojgcJbN/T90kg1xQszGOTPtvZL3FGMeOWsRxUrsmZxAaOsO3+OQPVLDmXeCq1l
         pnImQm/4Uka04HSnLttlWwJ8BQdPS5ILsbJOqLS+uZDunfXMM5rUjADxCQWxRhEeTb0i
         GgmA==
X-Gm-Message-State: AOAM533l2HYlqsQeKOVUXq4siliFxxiWV0o2mBcFY8SFXiabNtBLSABv
        01dSaKczycE5GOhsZ/Y0ElA=
X-Google-Smtp-Source: ABdhPJy5bEy+hhpKd9CUt7q7FKPOOPw1nJy3y19BrcQoeqG7hXbSltex2RpTEdI+RX7+Q4uZLRfZJw==
X-Received: by 2002:a62:3812:0:b029:13e:d13d:a062 with SMTP id f18-20020a6238120000b029013ed13da062mr28086812pfa.40.1600396570398;
        Thu, 17 Sep 2020 19:36:10 -0700 (PDT)
Received: from [10.230.28.120] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id m25sm1042139pfa.32.2020.09.17.19.36.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2020 19:36:09 -0700 (PDT)
Subject: Re: [PATCH v2 net 8/8] net: mscc: ocelot: deinitialize only
 initialized ports
To:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org
Cc:     yangbo.lu@nxp.com, xiaoliang.yang_1@nxp.com,
        UNGLinuxDriver@microchip.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, kuba@kernel.org
References: <20200918010730.2911234-1-olteanv@gmail.com>
 <20200918010730.2911234-9-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <464d0a80-5117-85a9-71aa-41c75ed5467c@gmail.com>
Date:   Thu, 17 Sep 2020 19:36:07 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200918010730.2911234-9-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/17/2020 6:07 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Currently mscc_ocelot_init_ports() will skip initializing a port when it
> doesn't have a phy-handle, so the ocelot->ports[port] pointer will be
> NULL. Take this into consideration when tearing down the driver, and add
> a new function ocelot_deinit_port() to the switch library, mirror of
> ocelot_init_port(), which needs to be called by the driver for all ports
> it has initialized.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
