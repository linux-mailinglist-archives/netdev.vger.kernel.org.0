Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B7FF2EFDA2
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 05:07:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726332AbhAIEAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 23:00:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbhAIEAc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 23:00:32 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F6A2C061573
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 19:59:46 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id i7so8908644pgc.8
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 19:59:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XT8Mf7YG6xfztGWx6dVwiKw92cLaIjXw3YBS3BxU3f8=;
        b=fT8gdria2QylaTEaEcZkftSTzYjAKSUe37SpW+IkFRALhfp03/fD9IBycpf9Zk+M5k
         90SeAYbLOHpPe2mtMCUEAo8urFbXLXNQ5ltJjmID6SeNkh3NdJGh3fBJEJ0NOrrRgsmk
         RHw9+X6HFfZRXZ7kzJ96wg4WQ/NEROiNNDAqKfooAggnWZveGQQeqp6R1FU3Z9B7Xged
         9QXvyQCohSP69IirezuvAnY0h+S5GfPKtqgNY2+1lSVcQLVJNpeI0A7uDGNgDaq/POcP
         VxugQRLwv+pOM408ZtGPR+pxz+XApBsGDjKfem2HEppfFgvsauR86oRU9KRvIp1aO0p2
         nkeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XT8Mf7YG6xfztGWx6dVwiKw92cLaIjXw3YBS3BxU3f8=;
        b=oZGJq7Ylk5jLzdy2XylGQ9feyQ50ulGkpANaVHN4bt6iG088UKpcPnX/U/lnI2E5W0
         cw//LRfPEJm40u8xaaSwtuHOed3uCXo9vTVrOt9iw6JcadkR/EuI84enWg9/KV7EbEpR
         fcUORi2Ut1WzSNTNvXAt25toSacZ8dcg/ezWuOegLfIniVgyjtoSR7uoQzttxgdmkDa1
         J0ulkYVnAq16UlDW1E/Q4G7nCaW5Xwlt3XIwrMUf98cVyde5XX/FoKPiVrsuU2wPDoZx
         SFPebaM/LIfBmpE3+e8NnNzM77kw2udfvuIZZw4oofRouz5o6CW0FPD2qInib9UALQQb
         UWvQ==
X-Gm-Message-State: AOAM533R63w1Iy1IVjbZuyhg8V7TISraxFEZth123NcDc9a+Fag9Y/8M
        OAvshL+US1jt0zh91tfqeEM=
X-Google-Smtp-Source: ABdhPJz0f3LYJTEwx4z/f30RJmz6djtuWOnhCC9k9E8Mv/eayRR9PwKmXe7kXRDKO9MWPgvWb4AEAQ==
X-Received: by 2002:a65:5244:: with SMTP id q4mr10173805pgp.50.1610164785991;
        Fri, 08 Jan 2021 19:59:45 -0800 (PST)
Received: from [10.230.29.29] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x12sm10510098pfj.25.2021.01.08.19.59.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Jan 2021 19:59:44 -0800 (PST)
Subject: Re: [PATCH v3 net-next 09/10] net: mscc: ocelot: initialize
 watermarks to sane defaults
To:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, xiaoliang.yang_1@nxp.com,
        hongbo.wang@nxp.com, kuba@kernel.org, jiri@resnulli.us,
        idosch@idosch.org, UNGLinuxDriver@microchip.com
References: <20210108175950.484854-1-olteanv@gmail.com>
 <20210108175950.484854-10-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <84d6345b-f197-27b5-6201-f678c03ec259@gmail.com>
Date:   Fri, 8 Jan 2021 19:59:36 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210108175950.484854-10-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/8/2021 9:59 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This is meant to be a gentle introduction into the world of watermarks
> on ocelot. The code is placed in ocelot_devlink.c because it will be
> integrated with devlink, even if it isn't right now.
> 
> My first step was intended to be to replicate the default configuration
> of the congestion watermarks programatically, since they are now going
> to be tuned by the user.
> 
> But after studying and understanding through trial and error how they
> work, I now believe that the configuration used out of reset does not do
> justice to the word "reservation", since the sum of all reservations
> exceeds the total amount of resources (otherwise said, all reservations
> cannot be fulfilled at the same time, which means that, contrary to the
> reference manual, they don't guarantee anything).
> 
> As an example, here's a dump of the reservation watermarks for frame
> buffers, for port 0 (for brevity, the ports 1-6 were omitted, but they
> have the same configuration):
> 
> BUF_Q_RSRV_I(port 0, prio 0) = max 3000 bytes
> BUF_Q_RSRV_I(port 0, prio 1) = max 3000 bytes
> BUF_Q_RSRV_I(port 0, prio 2) = max 3000 bytes
> BUF_Q_RSRV_I(port 0, prio 3) = max 3000 bytes
> BUF_Q_RSRV_I(port 0, prio 4) = max 3000 bytes
> BUF_Q_RSRV_I(port 0, prio 5) = max 3000 bytes
> BUF_Q_RSRV_I(port 0, prio 6) = max 3000 bytes
> BUF_Q_RSRV_I(port 0, prio 7) = max 3000 bytes
> 
> Otherwise said, every port-tc has an ingress reservation of 3000 bytes,
> and there are 7 ports in VSC9959 Felix (6 user ports and 1 CPU port).
> Concentrating only on the ingress reservations, there are, in total,
> 8 [traffic classes] x 7 [ports] x 3000 [bytes] = 168,000 bytes of memory
> reserved on ingress.
> But, surprise, Felix only has 128 KB of packet buffer in total...
> A similar thing happens with Seville, which has a larger packet buffer,
> but also more ports, and the default configuration is also overcommitted.
> 
> This patch disables the (apparently) bogus reservations and moves all
> resources to the shared area. This way, real reservations can be set up
> by the user, using devlink-sb.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
