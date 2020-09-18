Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 874BD26EF40
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 04:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729858AbgIRCeV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 22:34:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728681AbgIRCeT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 22:34:19 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07FA7C06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 19:34:19 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id t7so2345242pjd.3
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 19:34:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=F4zU9UGysSPSDTy9CBkdeeFanBMViADgH87Lv9XeKBo=;
        b=o4L6q/r46kQ1uiXTIhhyDrdrj5LVMUPIkHo8I7Nr2A7aOw66Wp1+1oVpl50Jw4twc+
         1337+KWXSYtK6/fpta5I+vW4Cg7DoEMoCWPt1B5xVPC1U2Cu/ul2ObH67dpTvjXcNRke
         b86J3HrgelZiontvczXJN+Zu/GMOemxAnBsKTIb/hZ/T/mRbm39GB4zaDDQ2ey/lAwcD
         x7/mqBuCTt05TD7Kv6pw3eRgns8ryk4cPGFylBvrBAqeWp3hEhJHgJkO/ofTgyRSFIbO
         Z3U4tvpxFQi6W1KKc7dYTNMm+xh5lwZuN2snmBC7DkH6SHwSnFbF/D5YXfVcUtfLZSDE
         aLbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=F4zU9UGysSPSDTy9CBkdeeFanBMViADgH87Lv9XeKBo=;
        b=NI9Krs27HHnxQfiqD6MrRjNeBgMn0saJ64MwJRAWOaDPbLpGKaH65TTEmGF1NHdE5w
         tRrcJqp18Pfa4VYVNXpjUShCk25CwLWSaxQsYitRSuWovNZK4rpHDe13RiSuB3WIfObS
         x37L0T9FaLhrijA8emD8IlNY/Z5bO6RUn6MrmpFMRrf/rLfsXgqftwFF2dzWEkjY4YHw
         tDOi07x72KQVUP0JGfhqa7P+Rdt5a/MUt4aH0GuLVjN9c9nvWEueE06fsA7dPsFa0WEs
         j9O6/QUy5lsjrki2zDPALcEZxq4o9COke+6foeacw4EDgTl8Ag5NdB/0jlsm6A5f46PU
         o6RA==
X-Gm-Message-State: AOAM533JuLEqulR113ormC6NI05+fjLsb4Yz/vOJ7JvOK6SPj1sDUIf6
        I8vXcZtfFNde4ID+AzRcOm2mTXzHxU35ng==
X-Google-Smtp-Source: ABdhPJwZuTkbi2UNUF25Ms/HHbzMSzxOJ0Ha2hFbuZJtFOwdxVAH9AUlOVigryg+FUyLyVNngeSgZw==
X-Received: by 2002:a17:902:a60f:b029:d1:cbfc:7cec with SMTP id u15-20020a170902a60fb02900d1cbfc7cecmr20006615plq.31.1600396458573;
        Thu, 17 Sep 2020 19:34:18 -0700 (PDT)
Received: from [10.230.28.120] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z129sm1008426pgb.84.2020.09.17.19.34.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2020 19:34:17 -0700 (PDT)
Subject: Re: [PATCH v2 net 7/8] net: mscc: ocelot: unregister net devices on
 unbind
To:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org
Cc:     yangbo.lu@nxp.com, xiaoliang.yang_1@nxp.com,
        UNGLinuxDriver@microchip.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, kuba@kernel.org
References: <20200918010730.2911234-1-olteanv@gmail.com>
 <20200918010730.2911234-8-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <49bc43ce-c48b-a5f0-6b89-8854993ed97a@gmail.com>
Date:   Thu, 17 Sep 2020 19:34:10 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200918010730.2911234-8-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/17/2020 6:07 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This driver was not unregistering its network interfaces on unbind.
> Now it is.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
