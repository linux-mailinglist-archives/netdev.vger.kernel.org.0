Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 555302A3550
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 21:44:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727225AbgKBUoP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 15:44:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727175AbgKBUoN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 15:44:13 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0615CC061A47
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 12:44:13 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id b19so7442532pld.0
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 12:44:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gB0p33pgzGNNsw2aXKYvPLwWgY4mdMPfvyKiVdGX/Bc=;
        b=ljY7MzoNyPyohpuFuyzwS9GKztfvtS77MDJXutumvwq2Nf1aaCjfnAWec1r7A1qDva
         wA4Yl8mRcRTVBr4yZH2kdKoUQsyBz8bCvTYgU8G58evfDjxjTlSRHUrauhdd/mGkJCKa
         4IAjXOspA8M+LHV5WfhP7wM0FzUVGRVLlO6OjIj8FewYQq5f14WIXPFtnKfalForT9Ux
         oVSjNCbQNbvrO+HEMESmB0fT1OenyK9PCEOZ9dDNyAp6ijKyfxCdgMaHmRfSUIt/QZnh
         S1OXS8WGWZGM0ikQaFWwpYldXzQt5bKInkoptLWiLyM9nHoZ3WxhXp2OCTqsw7jFiEeC
         Ea+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gB0p33pgzGNNsw2aXKYvPLwWgY4mdMPfvyKiVdGX/Bc=;
        b=hLjfgPlUBeuftcVFEWKunFzemKuiQHgrc9ijzyk57gTrhb4zcR1CbPn3WPDhfF4ayZ
         4SGvWQJSN30nJB6Cs/CcCmct1zo/gwYqPwCbXhyHWoX6xS472cUxyx7+DXYcQ6bz+Gw7
         E8QlZGTDWgxfZAH4g6JY6cSxez+Qrlgyy98LfyGeLz/I+/kvQU04I0nOKVNv3wcolllv
         9Q3Pj8CAucmOuDnMQp6aH9lEzbwYI1256Wl8a7PpJrmrrqXo4RitX/CgpqbfhPXruCHR
         DZBC9FG14J0KVHFTYC42GuaD0Vjr56+FRZfeaYDDziIE9Dizkr1lJ5Ttz8MDQmCbZo1H
         LG0w==
X-Gm-Message-State: AOAM530BpVmHIi/FzpnwLJ/pI8XdNyXjLFE1VLTkURJtrpQ2O2E/HYCu
        BkVF33NP7F5L8EHj16LyngldBzByzKk=
X-Google-Smtp-Source: ABdhPJxjFRWokp+n2lCfhx+8i5NEY37sKYN4y4FV7pHlhtnw0ekMR3mOXxZHKHU07btH627aaT/q+w==
X-Received: by 2002:a17:902:9890:b029:d5:e447:6b32 with SMTP id s16-20020a1709029890b02900d5e4476b32mr22214728plp.51.1604349852569;
        Mon, 02 Nov 2020 12:44:12 -0800 (PST)
Received: from [10.230.28.234] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i10sm5140997pfd.60.2020.11.02.12.44.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2020 12:44:11 -0800 (PST)
Subject: Re: [PATCH v3 net-next 02/12] net: dsa: tag_ksz: don't allocate
 additional memory for padding/tagging
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, kuba@kernel.org,
        Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
References: <20201101191620.589272-1-vladimir.oltean@nxp.com>
 <20201101191620.589272-3-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <6ceb6d0b-b36e-c23b-a97b-58ccf2da717a@gmail.com>
Date:   Mon, 2 Nov 2020 12:44:10 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201101191620.589272-3-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/1/2020 11:16 AM, Vladimir Oltean wrote:
> From: Christian Eggers <ceggers@arri.de>
> 
> The caller (dsa_slave_xmit) guarantees that the frame length is at least
> ETH_ZLEN and that enough memory for tail tagging is available.
> 
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
