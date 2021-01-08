Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0BA2EF77B
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 19:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728841AbhAHSfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 13:35:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728835AbhAHSfL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 13:35:11 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72E36C061381
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 10:34:31 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id be12so6105434plb.4
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 10:34:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rQKdLpDnfndQC4dmX5fHwQ5GrD9QfpZM5UTrY6WQWzQ=;
        b=R9qm2RNK1NKnFiiR2Tb4EbE9IbYGxoY9YnQOzTSMWMOZF21RoW76I/xU4E4xkaYCYS
         s6d6zp2Rcl8jDp+UxuvyQesq3ugPgCdF8YC1fpNFOWVpWijQwCbBTTB4TH/DWmH7383p
         eEAVDvC53fBksdU9kEm3GJHmyv4vLnjUlK5mKOIwv08WwDxMtmtxAlAJ0N4xWHc5Ik1U
         5fTWWCPzGwdLkoVu4GsKze+jGN3fo/dyxtPPRTq3ENkyRlqZZOjxHeoQM7hRHZjTmRtU
         b0nqXGvoSo39ZFQiTKxMZFwSVF3MPoclFcTg3zGiMmJoWWd4C0OE9FHoMeisXpK+zxF8
         5oNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rQKdLpDnfndQC4dmX5fHwQ5GrD9QfpZM5UTrY6WQWzQ=;
        b=UgtThrG0fNJwtbDcchqnxDbbwv7C1x48nrzQMlkIUIXQ1Whs4+gaxAjiq5vV0o9HzO
         zxc4TmQs1oKGPjgPl7jv2ZGAo+Fx9ydtkbuL3NgbmF/UMDmBl4fqD63iyD34qwrCnQiu
         EpGYnK8jNpcDdI94JDWF+WWKoP++q4L+Fhx4moYIgevNTNZNHjvxHoEENAgo+me1nK38
         2gAQLBv/fuJkfqxY9VC7OIevuyYmuFiGIUI1530QoOVhrvfo3OCAZ41c2lw7/0Q3+CrG
         2g/tq6q01JZ/6yvlkD+kc0YGv7zdk4VIDKQxOCCkQwNRQTfHAahwx5ji6xz2wSFCBiTt
         A+xQ==
X-Gm-Message-State: AOAM531uwfsXzUFeHbFs2AvlhXXasI3XlMyUxO83JDedwwAd++VV0eOB
        AS2nVkbzuAFSV9vwvk+uLSY=
X-Google-Smtp-Source: ABdhPJznAtqBHXlarlsno3p9LZbR3Cey+YlfxMq5PV3nKqbrNLZWqybxcRk5VmCmUgmU40ALiio/ig==
X-Received: by 2002:a17:902:9881:b029:dc:3419:c016 with SMTP id s1-20020a1709029881b02900dc3419c016mr5013347plp.83.1610130870997;
        Fri, 08 Jan 2021 10:34:30 -0800 (PST)
Received: from [10.230.29.29] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b4sm8607423pju.33.2021.01.08.10.34.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Jan 2021 10:34:29 -0800 (PST)
Subject: Re: [PATCH v3 net-next 05/10] net: dsa: felix: perform teardown in
 reverse order of setup
To:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, xiaoliang.yang_1@nxp.com,
        hongbo.wang@nxp.com, kuba@kernel.org, jiri@resnulli.us,
        idosch@idosch.org, UNGLinuxDriver@microchip.com
References: <20210108175950.484854-1-olteanv@gmail.com>
 <20210108175950.484854-6-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <f8248e42-69e5-be96-0e07-0bdf356da2bc@gmail.com>
Date:   Fri, 8 Jan 2021 10:34:26 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210108175950.484854-6-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/8/2021 9:59 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> In general it is desirable that cleanup is the reverse process of setup.
> In this case I am not seeing any particular issue, but with the
> introduction of devlink-sb for felix, a non-obvious decision had to be
> made as to where to put its cleanup method. When there's a convention in
> place, that decision becomes obvious.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
