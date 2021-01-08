Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32B752EF763
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 19:33:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728696AbhAHSbe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 13:31:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728619AbhAHSbe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 13:31:34 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05515C061381
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 10:30:54 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id 11so6772299pfu.4
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 10:30:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5KGmEXqUxHrUb31g9/ZOQ397ige7zLD/Oab0v0FKitE=;
        b=XweYSvcBb94UMmhrnQoW8W0hrfvo1xr/sJo5ITz7lwzcYcQz9B7CpxuizeYUwR1jC+
         5f2OAeBEOWcqZiitg0xIJ71Y0eTPl1RXDMrk0A8GuJLUcDloWuWEIJelsOAL4WtzjnKQ
         Xjcs9joNuLtPIdY5+TZsVm5FZRMpDxHmN59Vhw5DPGxbWCrCMiOXbgUpbCNsbU73hxjb
         ThqjYmM0ioiWPhyDBRDLOEJAt0pzF5N8bAruK9lbFStgcKHnGG1q2Yo2bly6qdj2COUC
         wvgmejs687CU4bqMylUXSQQ0OZeHkMzGZCRhaVTeMuKxpDDVnAga7ee38oasBx5BfSgR
         tGjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5KGmEXqUxHrUb31g9/ZOQ397ige7zLD/Oab0v0FKitE=;
        b=ODd4YErs4b4PCsFSBeRGvhGnsSI8i98VLNBx1swVUyAKV23vYjJCC08CdUz6/swi/m
         /fLvlndmZh+keApALN98JBOtHTwAShMGeW/Vyb7VkzBP20KFx0jX9JheDSugSOEwzEYx
         w01gB2y+FscTHzh8Mz4MdcDg7aoajm+DWErwnuFUqvlKopmNZDp/fQgKvb1jUsSL6IDu
         ZeDzKP/7qofsvK1KQEtdObt2MpWk2/Gbey75r6UN7w94zrSd8yV7jQYaQnRTmxfmql2h
         0L9OD9GLr4S6YN+6DQDV+YkI21KlFT3FaRi68fkefbmkrhNNALI4Cul6V7HeukjgWq0R
         oCbA==
X-Gm-Message-State: AOAM531hWosSjPQ3d3Inhb1XlQGqQRMIyAbuQ5WCDHIR88PIYKx7rLSh
        /XH15jXnfNFkOVdz3HvRefM=
X-Google-Smtp-Source: ABdhPJzvTeNv9j6WKOloQE8hwJMEqey0vUJgmWruO5kN9jVaPJT3sQjvTi26FQdY91JrLMD6Bd6gmw==
X-Received: by 2002:a63:ce42:: with SMTP id r2mr8377924pgi.8.1610130653445;
        Fri, 08 Jan 2021 10:30:53 -0800 (PST)
Received: from [10.230.29.29] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d4sm5546661pjz.28.2021.01.08.10.30.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Jan 2021 10:30:52 -0800 (PST)
Subject: Re: [PATCH v3 net-next 02/10] net: mscc: ocelot: add ops for decoding
 watermark threshold and occupancy
To:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, xiaoliang.yang_1@nxp.com,
        hongbo.wang@nxp.com, kuba@kernel.org, jiri@resnulli.us,
        idosch@idosch.org, UNGLinuxDriver@microchip.com
References: <20210108175950.484854-1-olteanv@gmail.com>
 <20210108175950.484854-3-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <2fcd8772-b664-d1ed-0206-3a8b51f6e03a@gmail.com>
Date:   Fri, 8 Jan 2021 10:30:49 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210108175950.484854-3-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/8/2021 9:59 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> We'll need to read back the watermark thresholds and occupancy from
> hardware (for devlink-sb integration), not only to write them as we did
> so far in ocelot_port_set_maxlen. So introduce 2 new functions in struct
> ocelot_ops, similar to wm_enc, and implement them for the 3 supported
> mscc_ocelot switches.
> 
> Remove the INUSE and MAXUSE unpacking helpers for the QSYS_RES_STAT
> register, because that doesn't scale with the number of switches that
> mscc_ocelot supports now. They have different bit widths for the
> watermarks, and we need function pointers to abstract that difference
> away.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
