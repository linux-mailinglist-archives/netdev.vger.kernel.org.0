Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5811E93C2
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 22:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729357AbgE3U73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 16:59:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728741AbgE3U72 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 16:59:28 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 159A0C03E969
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 13:59:27 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id x6so7525766wrm.13
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 13:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ajFcEQMKvFILzJUdEqPJc2OSipVvw/Pjk43dnXL29ZM=;
        b=GLmB5zBcvo5gFNIj+0VyefaC2Hn0+Sdlm3PokDB+P5bD/U9M/3RP7yQxP1q3M9Q0xD
         KUzyPoUrjVLHJwC+SOLDbg2JpBeF5tnAzuCY74rf4iXMK6bwgUY2XI+FTm71Ldd3UXqi
         pg3VCVwVsRVVoEnYBND4IXNl/4OW8pNrKEdSd4TfuduHOvY1EoJ4y0T2lbWVeffDVyJc
         S4qnsMQt67U1i9ghpZbA8i+BKfj3Ly3fapogTXamTHWE0AlIRIFerHfLzUtToJXrgLeq
         PU99FhvRawbtshEmBY9wd+9H1vN8EgV0C9CS+yf279jCGptFkeazHypFbKfRxQyu8qdq
         PZ0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ajFcEQMKvFILzJUdEqPJc2OSipVvw/Pjk43dnXL29ZM=;
        b=I+Mpc06VGQfp6xB+Ny8W7b88FcTaGbwpGTJLHs3xRfMK4I75xaeXEF37O4JDX+fV96
         66N4hSP9VUiDMU44p86BymYqCW4A1noy1/d7NyGCW7AYr/dccAYfVcIUZ7mPOnajsjpH
         gdyDQ/HGbek/G14QxUTHT3AZmW6GJOjTykqMy+77AUQukPoYe5Q6XzqFaiG8dXRz/t3W
         80zaymJtgLDyVrf0tgOZTg5AKEdNmEO5kgz4m4J++jQOcUZMQ37UeN14cw7/TxkldV0j
         tkM00K+jYeWt0aWGojJKIEpn0PfVwwaNOHN/pyOk/V/rtq99NthYlvE2/X0cv+PCgW1a
         dKkw==
X-Gm-Message-State: AOAM531Nu/qI9cK8x2y3tDrONFxt5Yrh2a6kUKN4BpN11Cs9FfO7YK8V
        99aXpcFO/rIeboiEvNHq7uE=
X-Google-Smtp-Source: ABdhPJzUNj7aepsi6hTDZVbJrXz6L32SW4gqiMvgwP4yVe4Zyi6kurRG9+k+MomL1WVbMRSWUcTRFw==
X-Received: by 2002:adf:eb47:: with SMTP id u7mr14617560wrn.14.1590872365840;
        Sat, 30 May 2020 13:59:25 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u3sm5853615wmg.38.2020.05.30.13.59.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 May 2020 13:59:25 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 07/13] net: mscc: ocelot: split writes to
 pause frame enable bit and to thresholds
To:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        antoine.tenart@bootlin.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, madalin.bucur@oss.nxp.com,
        radu-andrei.bulie@nxp.com, fido_max@inbox.ru, broonie@kernel.org
References: <20200530115142.707415-1-olteanv@gmail.com>
 <20200530115142.707415-8-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <3588b0ab-cc14-a2c0-fadd-74e8c021c9be@gmail.com>
Date:   Sat, 30 May 2020 13:59:21 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200530115142.707415-8-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/30/2020 4:51 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> We don't want ocelot_port_set_maxlen to enable pause frame TX, just to
> adjust the pause thresholds.
> 
> Move the unconditional enabling of pause TX to ocelot_init_port. There
> is no good place to put such setting because it shouldn't be
> unconditional. But at the moment it is, we're not changing that.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
