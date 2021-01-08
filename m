Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 528612EF780
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 19:37:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728809AbhAHSgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 13:36:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728705AbhAHSgt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 13:36:49 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC032C061380
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 10:36:09 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id c132so8163351pga.3
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 10:36:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vZU9q821wdfREKHll0t1j/YINkWfXjXQeRM8Bzswykg=;
        b=iQZXkZFHKEabWXYk6TEwGjgWPN8iE+QowA7vHYwfaZVRkD5b+sUWab77mgTQrCtEdU
         4I6VNdbMtaicZnlRFTSE2+WQrb41NF1Ernpa9M04ZUcvl8YJBoUxv8FWvyXfiDyg1QjF
         /5wlBRFUhFpd0fXHTTnBrA1d5ebfRdgu86mwTtqHtfOWqXCOoEbLfW0VuqFXeNVt4uUC
         tRgPJYy8Er8mBn5upCrBP1NArP/ixPkEccs8uRTrfwPeEtiPYfbn50qFhH2odhNmIJaJ
         Ln3buZZfKlFPdwwyTGkP3HPIazmGW2+fSDUw8FKrc51+A84avkPh1JCkAM45hRvNhA83
         BLig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vZU9q821wdfREKHll0t1j/YINkWfXjXQeRM8Bzswykg=;
        b=Z5R020SZV4WFSaWvSKen+dO0FiF6IMHezoSqxEHq6S+jEovxqMadp8XzF8Zprsg/Ub
         VQkzUQGUj7fs6i69aDmCf/Rw3xa7VU5zSZDVgrxqQQXcM4pVJ3tsQFLLmYWAju05POrS
         /JVxtIHHDoEcQu/59q6gqU2sETR5lH9405bd6RPA/XAShPhh4l+kQ2T1lCqsMcRSOPxl
         Fu1yKhNJ5gKi4Ffrob9jHHj83R/qhbiXQ2tOF3H1iTXLIW8Fq/c+E3xjADnV27vvIE4L
         UFBCJyPH93qRY39+x1o+RNHBpKiXiD085e6TUAlTqcjqQn9JQROOoH+QKent0B6xckcJ
         rd2Q==
X-Gm-Message-State: AOAM532Shoc2aiuLPJUTOa2c9PZC8+n2A6v6oVtWa/WPLSggxAhJ2a2m
        d1R+KTTCypAXZypuDHI+x0k=
X-Google-Smtp-Source: ABdhPJyjzNkAUKoiwi01l/9ITFLnFAoAGAZOqf7ElXkZPBSpq28II0MBDmPgryfzw1d/fVTOvt2poQ==
X-Received: by 2002:a63:74b:: with SMTP id 72mr8337169pgh.4.1610130969279;
        Fri, 08 Jan 2021 10:36:09 -0800 (PST)
Received: from [10.230.29.29] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id m4sm9920062pgv.16.2021.01.08.10.36.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Jan 2021 10:36:08 -0800 (PST)
Subject: Re: [PATCH v3 net-next 08/10] net: mscc: ocelot: register devlink
 ports
To:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, xiaoliang.yang_1@nxp.com,
        hongbo.wang@nxp.com, kuba@kernel.org, jiri@resnulli.us,
        idosch@idosch.org, UNGLinuxDriver@microchip.com
References: <20210108175950.484854-1-olteanv@gmail.com>
 <20210108175950.484854-9-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <bd88e415-6f47-9fc8-d55f-dbb057e8610c@gmail.com>
Date:   Fri, 8 Jan 2021 10:36:04 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210108175950.484854-9-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/8/2021 9:59 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Add devlink integration into the mscc_ocelot switchdev driver. Only the
> probed interfaces are registered with devlink, because for convenience,
> struct devlink_port was included into struct ocelot_port_private, which
> is only initialized for the ports that are used.
> 
> Since we use devlink_port_type_eth_set to link the devlink port to the
> net_device, we can as well remove the .ndo_get_phys_port_name and
> .ndo_get_port_parent_id implementations, since devlink takes care of
> retrieving the port name and number automatically, once
> .ndo_get_devlink_port is implemented.
> 
> Note that the felix DSA driver is already integrated with devlink by
> default, since that is a thing that the DSA core takes care of. This is
> the reason why these devlink stubs were put in ocelot_net.c and not in
> the common library.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
