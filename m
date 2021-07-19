Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A92D3CCC61
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 04:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233898AbhGSCuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 22:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233720AbhGSCuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Jul 2021 22:50:24 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5376EC061762
        for <netdev@vger.kernel.org>; Sun, 18 Jul 2021 19:47:24 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id 42-20020a9d012d0000b02904b98d90c82cso16761889otu.5
        for <netdev@vger.kernel.org>; Sun, 18 Jul 2021 19:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jNyhd+T/9d9anCSoGKOeiOQZUa2KbCVT/Y/R829odA0=;
        b=kd/pME7pXs/YdCnqRxrbKWW2Gqhh4kDLHBsOyRE8A6RrQ4YCNnLEY8zQpEReVUMEL6
         32d7JKq2Ik57CpKb5yj4J4ir46O6OlRuw9a6txjY/gXQebtX/JQ2Z/eK/AbTzyixQH46
         9QD+WkAvH6nzjE6vnvHWZly7cMi1PYLIL5Cg7ulFOQ/R1DmyQ7nljIXBOP7c9nz+YJNT
         jtgmuguBRRu1PVkqPcaxNOUFMxrYm2T1yTZfFxQhsCvdrgoriH6lC2XZSuB3mHqSmAu1
         QnzJHTH5fYBIaafDUTK60wUDyyHCWKcE94NDgNHr7mCrA7D3dMTAhbbDIrFeKX+W1AAO
         jLNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jNyhd+T/9d9anCSoGKOeiOQZUa2KbCVT/Y/R829odA0=;
        b=KQqKCNuf5aNswbLfpaAdTcFFiBtSHocW6BTQKBJMkwNc6KmT4ld4nVwJsvB1b21u/Z
         06SnwQoU/DgVRA0ZgmuXtMoI66eUPuFMtjnG0luVuI+0aAf/TjADQ5BDhcF+yY3Xfwi5
         R4ur2Y1LYZHom2hLS7zmCh7aJKf5AYMbVg38v07B4oqbR8dLrw6Y2NfmDSFo2SIYXS9t
         CdeSkL2tIDwKDTo0AOghZT6GLidlC9CILx2z51IX6J5ERH/zB6BG2PdK8fj73j4DFKpr
         dSrpIEMxKNjXfXULET6ndh77wkxIj0Pkvp5lhZh2Zueg9C5s6eW2nZEjLQV15soMbOQV
         oW4w==
X-Gm-Message-State: AOAM533oi+cr4gG5CYL7LhW4CMalNwPF0f9MwnDFd5qlcA5/8GFFlNbJ
        w4Gf63ouD9HiIpAL1FxvGcY=
X-Google-Smtp-Source: ABdhPJxZjIgSUOEIBImnKslPHGflgNXmVhhyARyOtRSwH9zyUg9eUuJLvfGeybKJI8uvKkCf+X5PvA==
X-Received: by 2002:a9d:7e3:: with SMTP id 90mr16597425oto.40.1626662843696;
        Sun, 18 Jul 2021 19:47:23 -0700 (PDT)
Received: from ?IPv6:2600:1700:dfe0:49f0:49e1:751f:b992:b4f3? ([2600:1700:dfe0:49f0:49e1:751f:b992:b4f3])
        by smtp.gmail.com with ESMTPSA id l11sm892411otf.1.2021.07.18.19.47.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Jul 2021 19:47:23 -0700 (PDT)
Subject: Re: [PATCH v4 net-next 15/15] net: dsa: tag_dsa: offload the bridge
 forwarding process
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>
References: <20210718214434.3938850-1-vladimir.oltean@nxp.com>
 <20210718214434.3938850-16-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <7c2b81e8-db72-4665-fe81-7254cba1e797@gmail.com>
Date:   Sun, 18 Jul 2021 19:47:22 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210718214434.3938850-16-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/18/2021 2:44 PM, Vladimir Oltean wrote:
> From: Tobias Waldekranz <tobias@waldekranz.com>
> 
> Allow the DSA tagger to generate FORWARD frames for offloaded skbs
> sent from a bridge that we offload, allowing the switch to handle any
> frame replication that may be required. This also means that source
> address learning takes place on packets sent from the CPU, meaning
> that return traffic no longer needs to be flooded as unknown unicast.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

This looks pretty complicated to but if this is how it has to work, it 
has to. For tag_brcm.c we can simply indicate that the frame to be 
transmitted should have a specific bitmask of egress ports.
-- 
Florian
