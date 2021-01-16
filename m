Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01E3B2F8B5C
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 06:07:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725994AbhAPFCF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 00:02:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbhAPFCE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jan 2021 00:02:04 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34871C061757;
        Fri, 15 Jan 2021 21:01:24 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id m6so6816657pfm.6;
        Fri, 15 Jan 2021 21:01:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UQsTHlU850lY6rXFJA/cGIMLc4RGqt5SBBQaZHnUyrE=;
        b=fyTM/OqdhQaLck4EtV1Ijs0pXH5yCn2zvFriW5veh9Ko8gYmDN7883P2brNvBDnCu3
         PxYgeLFJ1dUkJAIZ3fesTRlGR8oPNJMs68Y0DgKHg7o3KTf//DbqKCb1gjEBJ1HaYTrb
         QX2yvrzcGwIwUuW4qo7EVCBQWfPLYD/O7+gtjrekmSRxgPhdCrD32CNCrfym7lCfaZ2m
         fXLApEuvI1fKZlMEtJFh11uamYeJppQ6c0I5MtUDkiPaEHULzz5XyqJzU+3HOViOT1b3
         5Wc1jytefZ4yIq1q+T6YvIQmnPNBieauS+jyKRwOd/KpJLI5I+USUIbcEpHkSk49jcDs
         3zVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UQsTHlU850lY6rXFJA/cGIMLc4RGqt5SBBQaZHnUyrE=;
        b=RyS3GqmzDs/yLBdgicqzDEtiRiWYuDUWeGfk4WQSJ+5qERNCzlEHx7JAGUX6GhXrPk
         1nPHTHWeY1z4x4WRmFdsrYTlvYQWLOLNIm9tyyQmNTb7ux3G5MCi6SlmYaA1rg/d7auU
         79OkSUBKH5phbtyPIO9e1pauuRBEVGWvh3Z/c/Rj7rSLJvW+hkHoKJ/rDnQN88JJOZ4c
         U3uDPKL5ZwrKhKMUFiqLDJWBcvixY4Aq8eJCCHtMZ0JtnOvgAfZNqqHNwSNtRsQtm+o9
         UYX8x1nfR5R4hPQObLPMwLSqjspyLfnn5lQRVOgxlwDTqUS8KRBNPoiwJ+VSMkp2nQEO
         0j0w==
X-Gm-Message-State: AOAM5328csPMoSWQYxn7Sc6EJXbGFprIPvE+9iNmQ09XYmZiTqEhEFCr
        KMjqx7Mb7EgJs02ZljkJdQuH5iIGouM=
X-Google-Smtp-Source: ABdhPJyMniZHTYMt8Fpfdcrt56DFz/DSgKUu4hUx+TSSr4Xe1VuxuO7UUV35VybqkQwKmup93uaR9Q==
X-Received: by 2002:a63:e24a:: with SMTP id y10mr1284209pgj.413.1610773283098;
        Fri, 15 Jan 2021 21:01:23 -0800 (PST)
Received: from [10.230.29.29] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k15sm9773330pfp.115.2021.01.15.21.01.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Jan 2021 21:01:22 -0800 (PST)
Subject: Re: [PATCH net 1/2] net: dsa: mv88e6xxx: also read STU state in
 mv88e6250_g1_vtu_getnext
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tobias Waldekranz <tobias@waldekranz.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210116023937.6225-1-rasmus.villemoes@prevas.dk>
 <20210116023937.6225-2-rasmus.villemoes@prevas.dk>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <daec04a4-1b42-cb44-43fd-ebf7723604c3@gmail.com>
Date:   Fri, 15 Jan 2021 21:01:19 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210116023937.6225-2-rasmus.villemoes@prevas.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/15/2021 6:39 PM, Rasmus Villemoes wrote:
> mv88e6xxx_port_vlan_join checks whether the VTU already contains an
> entry for the given vid (via mv88e6xxx_vtu_getnext), and if so, merely
> changes the relevant .member[] element and loads the updated entry
> into the VTU.
> 
> However, at least for the mv88e6250, the on-stack struct
> mv88e6xxx_vtu_entry vlan never has its .state[] array explicitly
> initialized, neither in mv88e6xxx_port_vlan_join() nor inside the
> getnext implementation. So the new entry has random garbage for the
> STU bits, breaking VLAN filtering.
> 
> When the VTU entry is initially created, those bits are all zero, and
> we should make sure to keep them that way when the entry is updated.
> 
> Fixes: 92307069a96c (net: dsa: mv88e6xxx: Avoid VTU corruption on 6097)
> Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
