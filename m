Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3EF2D8B2D
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 04:32:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392486AbgLMDbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 22:31:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725976AbgLMDbp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Dec 2020 22:31:45 -0500
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E2EFC0613CF;
        Sat, 12 Dec 2020 19:31:05 -0800 (PST)
Received: by mail-ot1-x341.google.com with SMTP id q25so12318611otn.10;
        Sat, 12 Dec 2020 19:31:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+BjOxXb7d/HLHo33woNIMHOuryX58MLy5NrBZNm8XrM=;
        b=i04BhdscTr016PH0OMI+WWHAM/R2dj9iJUnwPbU3rPrn6HdYipyJQbR5wMokIuUwLA
         pxlOmDLFP71D8YWI6bPenb79Tz/UYM1UlMgdLO+sKXB8mhi7GV9vTz2V7npiAM8OqVXd
         b3QX/U4zo9bHWvD+04ErPAWgPbzIQZt+uhZATWEraY1T2QzgGmULeUaC1Z+nzg3O6VZ1
         Um7d52uQLL1f0UkJdle4QXc7R9IJ5GTnF8rUKZ8mXSs/TPCdAjT8UIsEvSanZBAWN2TX
         VZkG4JYBZZN4mlJKZZf+I9yvf6xDlCsEFnjwO9iYvCN/AL8MosEKX0jANf+oPjEngq2Q
         XIQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+BjOxXb7d/HLHo33woNIMHOuryX58MLy5NrBZNm8XrM=;
        b=Q5uzdYJJpVurthypecHRH9EosiOh1OuNaMZdt2aX7WiFAu+rtmzhQ0mRUq59qb6FYR
         HbwAEIFV9Zk9Ibf7FKxgnHxaKPEIyPZ8kmecmDYW1xtwK4lTCzy8VtxEkD/0RVuO4Ptu
         6IRLX56vMTzbZNL/q1t70029suMUL53fM7BQvDcxvxJfk9jMhg/of6nK/i3i+5l8LB6g
         Ej0AqOCqDJAyYmOjnJAwxI/QILZXYbev5WdQuis6VqaoDD7CgaMvAI3XjJhdxRmfBSWG
         pK+F0GlT7s8ywGlvNd4a8u4HPdnq3uZKLwKS+5ZuZpz7WWTRORqjKATiGZjkIhxVT3dU
         xxlA==
X-Gm-Message-State: AOAM533h/l0r3ZMBSzyqAbqv+oUtaQBnfkp5LBzkDNvpwAn6+2yMniaq
        P9ah9NM7jih9jyGaxXm9B/U=
X-Google-Smtp-Source: ABdhPJxVF/+hDNcFK1VNuN477dC2vbBJ+kIVFa7ffqsU3bxSQXVdXCUJUIXPszH41PXwKyTFyvqWtA==
X-Received: by 2002:a05:6830:1be9:: with SMTP id k9mr15275563otb.226.1607830264945;
        Sat, 12 Dec 2020 19:31:04 -0800 (PST)
Received: from ?IPv6:2600:1700:dfe0:49f0:5c21:b591:3efd:575e? ([2600:1700:dfe0:49f0:5c21:b591:3efd:575e])
        by smtp.gmail.com with ESMTPSA id d20sm2339764otl.64.2020.12.12.19.31.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Dec 2020 19:31:04 -0800 (PST)
Subject: Re: [PATCH v2 net-next 3/6] net: dsa: move switchdev event
 implementation under the same switch/case statement
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Marek Behun <marek.behun@nic.cz>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
References: <20201213024018.772586-1-vladimir.oltean@nxp.com>
 <20201213024018.772586-4-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <27e7d73b-1200-a9f1-94e3-5e494f54e49e@gmail.com>
Date:   Sat, 12 Dec 2020 19:31:01 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201213024018.772586-4-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/12/2020 6:40 PM, Vladimir Oltean wrote:
> We'll need to start listening to SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE
> events even for interfaces where dsa_slave_dev_check returns false, so
> we need that check inside the switch-case statement for SWITCHDEV_FDB_*.
> 
> This movement also avoids a useless allocation / free of switchdev_work
> on the untreated "default event" case.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
