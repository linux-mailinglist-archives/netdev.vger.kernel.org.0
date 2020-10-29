Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B648729E2AA
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 03:32:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728531AbgJ2CcM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 22:32:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728666AbgJ2Cb4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 22:31:56 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE2D5C0613CF;
        Wed, 28 Oct 2020 19:31:55 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id p17so568804pli.13;
        Wed, 28 Oct 2020 19:31:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=fT5xz0svll+euXEooxtE7KKo/htChgiOqv59g7RkQ8k=;
        b=McaNoG7ZvlMcNEutIFENXjexjaCmrLJfcKa3V9w0zHuZG6XNwHWUhqO0bmVLRnhO5u
         15+OLMYvWfHoBKntiiR5cEFeOqsmRsd7XJrJSJ6ZEvppT3LY9KOtBmQeEHZ/F/Tvk7gm
         WyQyEspMdvhzaQAgUy4fpK/ge706PFj2xKH46XAvPiN02PumR73RSWRetdWGTOUaMSfO
         GW/E2njcAlFl59DNyVX6TFHSt2YKDrCxK/y5PMfvU23G7j3oaBglQAzyzJdcRIzSMtHS
         h3Zjyg3KzthgRzG8w0lSAPCw8CamoyvHncnU0SmHJMPzE1JATlR4jb/H1AOQF/aQ5MgE
         i5Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fT5xz0svll+euXEooxtE7KKo/htChgiOqv59g7RkQ8k=;
        b=SuCRQLOxJie8eLwzE9p+MWuzItrRN20atKRRYRK+SsqaV4s9OAkKmpZpxTMz34BIFg
         qHxfjpPnpkMFDnf9deRMFmISo33LHB7yOik+9iisrfgekCBPAPyyuK/NCg38vTUcyneA
         MU+63jV75vSwyTXw3iYAsl+j+jUMWUHg3/sVfcZVszo2wK1C1wdNLWa00go1szzINPUo
         0V6yCYt028YK5vgfnfPEK99xFnClLKwnsiIFRJGUehF/uAuMwTCqNJjUE/XUA9E/ARWY
         bQLuw3khckN+tZvEjmNCdxX83hsTKE4Jd5rziuNT8sfMk5WRr7+sIW2SABarCDrYya/c
         dwSg==
X-Gm-Message-State: AOAM531fI+MI4IkwvmKX10r3SqsXx771kH2rnF5mR97tmm72iiEw1KMf
        eaKeKQgWhUYCKC6FFtktAKh1mIuxau0=
X-Google-Smtp-Source: ABdhPJyNNJkmxyVyzrxARxpg+uv/0z7/EE9M6PCXChPjmBeJwZWlK9p7gkTZsooH1ONyLbMrWy485A==
X-Received: by 2002:a17:902:6b44:b029:d3:e78a:8ab6 with SMTP id g4-20020a1709026b44b02900d3e78a8ab6mr1787167plt.72.1603938714766;
        Wed, 28 Oct 2020 19:31:54 -0700 (PDT)
Received: from [10.230.28.251] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w135sm910739pfc.103.2020.10.28.19.31.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2020 19:31:54 -0700 (PDT)
Subject: Re: [PATCH net-next 1/5] net: mscc: ocelot: classify L2 mdb entries
 as LOCKED
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20201029022738.722794-1-vladimir.oltean@nxp.com>
 <20201029022738.722794-2-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <7d98669c-adf1-1f62-6f18-d39379eae3d7@gmail.com>
Date:   Wed, 28 Oct 2020 19:31:52 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201029022738.722794-2-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/28/2020 7:27 PM, Vladimir Oltean wrote:
> ocelot.h says:
> 
> /* MAC table entry types.
>  * ENTRYTYPE_NORMAL is subject to aging.
>  * ENTRYTYPE_LOCKED is not subject to aging.
>  * ENTRYTYPE_MACv4 is not subject to aging. For IPv4 multicast.
>  * ENTRYTYPE_MACv6 is not subject to aging. For IPv6 multicast.
>  */
> 
> We don't want the permanent entries added with 'bridge mdb' to be
> subject to aging.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
