Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E336E3221D2
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 22:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231142AbhBVVxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 16:53:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbhBVVxJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 16:53:09 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C30DC061574;
        Mon, 22 Feb 2021 13:52:29 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id l18so495565pji.3;
        Mon, 22 Feb 2021 13:52:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CeHo01FO2/lXjcBRzmhV/bA76W0zUEml2xf0qCDZyH0=;
        b=ZWron18OZ0PXH57hJ5WF3bgavTUGBpReN9/PTt9OTHbxZN/LdMOGdYsalXCI+JEhyC
         sK1lRzY13FocYVVznWLQHM/H6QdRosCMw0pLrDJWoKjvVjarWoZJdQcwcP02ax/s+E1Z
         vMZPCCHHpLsOCB/b/1RvuLyNbfw3RyazLYLanrtbk7wmoydSi3b8kV9OFotdjlb6vglH
         BL5+NcS/tj3y7WT8WwE6QMEu9Sf5lN7Lz9WLBgrd10DLX7QeNsFHEaOBoXpW2zRnoXjF
         vv587cY04ulWTHD07KMZEOYkDyCBtiKFfBXnRDbVhrTRn7ueRyFijbonFfB0QwW84fOL
         ATwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CeHo01FO2/lXjcBRzmhV/bA76W0zUEml2xf0qCDZyH0=;
        b=mKFUcdUho3BhxBb4Xs94MAOQmSPMC+IQxy7QX1qelycsK5up8RBepM3Qgmih1BYw/t
         3RUJjPHB8e9oDq3M70FubFvJnEOFzrt2yh/S7ih56uK775KmuucAfh0AMA226QbYkBhf
         hr7+E+HXX+VbUVG3OCqa63JeXVjPmSCG/CPkDhXEhxZK6hs3VWBmetBQEXNO+Tj3WDaE
         ESN8enGsu58x+Cz+j2UTj1mXQyLGtCCHyAHsx4jOXq/T7xRlvCoZkicESRnEt30RbXp0
         an9HU60pJZpll2Z5suOK05PRAK6CfaSeEXzD3b/D7guvDmw1YSMiaidayjuuiN4vET/v
         O1EQ==
X-Gm-Message-State: AOAM5333xa9WgLwKUvoVHYnPhCI3wnPymK+VoSZnlRyURxfGRnA9y1BP
        RfHGEYelrN6M0y6COa/BPm6eVM6n3jM=
X-Google-Smtp-Source: ABdhPJzfB+GrfFaRAOSJyTmTxBkU9KTtuwDfZQrjpFlWkbnT/felR153DOeBLVzLoWjA4adsPvrDoQ==
X-Received: by 2002:a17:90a:8b93:: with SMTP id z19mr23448318pjn.222.1614030748590;
        Mon, 22 Feb 2021 13:52:28 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w25sm3277278pfn.106.2021.02.22.13.52.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Feb 2021 13:52:28 -0800 (PST)
Subject: Re: [PATCH net] net: dsa: b53: Support setting learning on port
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20210222214641.2865493-1-f.fainelli@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <a9b9a186-9c9d-b2bc-82cc-c99e2012061f@gmail.com>
Date:   Mon, 22 Feb 2021 13:52:25 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210222214641.2865493-1-f.fainelli@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/22/2021 1:46 PM, Florian Fainelli wrote:
> Add support for being able to set the learning attribute on port, and
> make sure that the standalone ports start up with learning disabled.
> 
> We can remove the code in bcm_sf2 that configured the ports learning
> attribute because we want the standalone ports to have learning disabled
> by default and port 7 cannot be bridged, so its learning attribute will
> not change past its initial configuration.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
> David, Jakub,
> 
> This is submitted against "net" because this is technically a bug fix
> since ports should not have had learning enabled by default but given
> this is dependent upon Vladimir's recent br_flags series, there is no
> Fixes tag provided.
> 
> I will be providing targeted stable backports that look a bit
> difference.

This is incorrect because I did not update the supported mask of BR_*
bits that we support, v2 coming shortly.
-- 
Florian
