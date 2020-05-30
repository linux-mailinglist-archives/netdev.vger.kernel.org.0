Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5CC1E93F2
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 23:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729183AbgE3Vbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 17:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728741AbgE3Vbl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 17:31:41 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6184DC03E969
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 14:31:41 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id h4so7133342wmb.4
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 14:31:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2YhKM/+M9fjpC7H4glNFwLQssnsxrQyrkxqsgQR7Log=;
        b=Ye87w95Mwo9OMYFe91x3yli58lFXp7aoieG5j48lLcs4ttoYTu593mmDfArs06vtip
         ftFvj5jkTzNDm0X7viaFAPrTRB90JPqqwv0l7cIb+shuY+Pbgum4aWJmNJm8p11dkrq1
         eg/HZcd65PLw2FvRBcYujgk5PUcIVFgCK6YiOr219VoqFjbmKETDtseDIFOvMjJgaVOe
         8kIWx6u/c03XwrF6PoA2Xb3ygXKw3p6LPDMzULyjKc90tNEaVo/qRYIqnzeTQ9Tfc+Xn
         RP5/p0XrCiw8L+C5sQvDB7M4r+g/2E+aLd26m31e8ECoNd8lK2tEFYnbSKh5ziVcU8yY
         l8uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2YhKM/+M9fjpC7H4glNFwLQssnsxrQyrkxqsgQR7Log=;
        b=hRy8a4c0cM2z3zJwXO5YL7WyFALMA7o8SowMkDmlplITziSU+uJWPlt1z0UmQwf8e/
         3Ese98ibj6O6xMp9anztPlAqq1hj/zaNi0nro+cD87JpPRzDXYMi7yrLI2zvTqW8uis3
         EhciNHYxDkFhuNkIj+hhhd43lLQDBbyQ8JfjSdJWKPNkmK9NaAO7wlbm6axoasLv+hBL
         As/yzO/7obYcnuGPhoFQ0qu+N9p9v7jF1/sXk5oxKCH3ewNx+3isqWr+NBsaXWEBG275
         pTwnFLYl+8sYapOkl2QEOSeHo0ah39/X9dT8KBAjwHvj+QS/ZhSZ/qoRVJzyFKIXokPA
         Sptg==
X-Gm-Message-State: AOAM53328CW1k/gFfe+hyBtTJ6UzZvax0mXqjr3tTON+sjfx2ywR3AhL
        uohW6dijn2GEiAtx5TitW98=
X-Google-Smtp-Source: ABdhPJyLuSmxKDyudEctU/xCBHeN8ACCnPKi5knxcyubLrBM85juc0gc8wmjckhfHNQz//Vf6/N8Sg==
X-Received: by 2002:a1c:4c8:: with SMTP id 191mr14136390wme.14.1590874299921;
        Sat, 30 May 2020 14:31:39 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id o15sm15484797wrv.48.2020.05.30.14.31.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 May 2020 14:31:39 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 06/13] net: dsa: felix: create a template for
 the DSA tags on xmit
To:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        antoine.tenart@bootlin.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, madalin.bucur@oss.nxp.com,
        radu-andrei.bulie@nxp.com, fido_max@inbox.ru, broonie@kernel.org
References: <20200530115142.707415-1-olteanv@gmail.com>
 <20200530115142.707415-7-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <3ecbfe12-e4da-238e-b999-36fd91a2de5b@gmail.com>
Date:   Sat, 30 May 2020 14:31:35 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200530115142.707415-7-olteanv@gmail.com>
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
> With this patch we try to kill 2 birds with 1 stone.
> 
> First of all, some switches that use tag_ocelot.c don't have the exact
> same bitfield layout for the DSA tags. The destination ports field is
> different for Seville VSC9953 for example. So the choices are to either
> duplicate tag_ocelot.c into a new tag_seville.c (sub-optimal) or somehow
> take into account a supposed ocelot->dest_ports_offset when packing this
> field into the DSA injection header (again not ideal).
> 
> Secondly, tag_ocelot.c already needs to memset a 128-bit area to zero
> and call some packing() functions of dubious performance in the
> fastpath. And most of the values it needs to pack are pretty much
> constant (BYPASS=1, SRC_PORT=CPU, DEST=port index). So it would be good
> if we could improve that.
> 
> The proposed solution is to allocate a memory area per port at probe
> time, initialize that with the statically defined bits as per chip
> hardware revision, and just perform a simpler memcpy in the fastpath.
> 
> Other alternatives have been analyzed, such as:
> - Create a separate tag_seville.c: too much code duplication for just 1
>   bit field difference.

If this is really the only difference, we could have added a device ID
or something that would allow tag_ocelot.c to differentiate Seville from
Felix and just have a conditional for using the right definition.

The solution proposed here is okay and scales beyond a single bit field
difference. Maybe this will open up the door for consolidating the
various Microchip KSZ tag implementations at some point.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
