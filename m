Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D70E1E4AF9
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 18:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730471AbgE0Qur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 12:50:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728125AbgE0Qur (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 12:50:47 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FD38C05BD1E
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 09:50:47 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id nu7so1759762pjb.0
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 09:50:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Lwf0d5mtOgfxseAmemF3uEZZhdnQZ1v4sq0GZ+NLQCk=;
        b=rdkT8MbG81B/czmFZUipsiLkgwvRfhy1bpsHaSltvJrwuFjhvnuIuQdrUnYSHVuxoS
         VTpap0k1eew9vTkIBvfM+UvWTbwE0qMopIMbaYEVyI1pTYStk4wEvvZGGIH9SjcwAUps
         iuTkNAAAzCVlk92/W4d6UQrp5JOKVZn5D9+FZu9YILe+5A0lTm3p9ifpbla+nMibsj1U
         i26bNqjiDl3dZ/iR0ZnM1LlwUyjH8V0UjCqjv/v+wSR/rvWNhAfoNkMfzcucYbGrCjGG
         8VxmCWu0b0Sk9lCgRkF0i6zRRHK3K8kz1fppfNyJSbkqkUh/8dBfoBS8QKaVN/zp1Ap9
         mTJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Lwf0d5mtOgfxseAmemF3uEZZhdnQZ1v4sq0GZ+NLQCk=;
        b=rCj/1uwwgfoeCyb5NnT7jYhqdar0JVeBwg5raUqtZ0Rpmj+yRHuf57kXIqJEqLuK0W
         6ASYc0O8r6E0YrRwkOTRWbxdRNE/hjQvOabjEGOt2U+8qcsIY6/cMfGZZwwAFWeshNk2
         3qHb+lFXx/Ylu9KO7bfH7xoYHnJMwIahIXa+WADGghM5r1QUsufsftICYy+qZ58vaR38
         0nOgfqm/oX7GD1S8rqJ6rXUV1C3fKaBaeuNs9wu3ZbYhmyjV8tjgnVcr6SPxt4Vu+tCn
         lqIwgHTbDOd8CXCyWDGpmsLApE2cDrWzT8FBdELqthHVGlwp7rTRr/gXK+ig3/GYa7rP
         uIWQ==
X-Gm-Message-State: AOAM531DmFX/u+x4chClm2TDJYOA3umhtfSVEFMQc63ebnob49GSHSOA
        yOWZNNO5FPBja43ZmZXt9h+OC1yi
X-Google-Smtp-Source: ABdhPJz489S/YELvwr61gqjYneG4VAEm9QI+gOM6TJiqep0BtoxcDu8EFmpx5fDtiYYbVSkcQiWCog==
X-Received: by 2002:a17:90a:4e07:: with SMTP id n7mr6381278pjh.34.1590598246062;
        Wed, 27 May 2020 09:50:46 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x2sm2369783pfc.106.2020.05.27.09.50.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2020 09:50:45 -0700 (PDT)
Subject: Re: [PATCH net-next] net: dsa: felix: accept VLAN config regardless
 of bridge VLAN awareness state
To:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com,
        rmk+kernel@armlinux.org.uk, netdev@vger.kernel.org
References: <20200527164538.1082478-1-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <7abd5391-8668-bb45-0ca2-883e949620a9@gmail.com>
Date:   Wed, 27 May 2020 09:50:43 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200527164538.1082478-1-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/27/2020 9:45 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The ocelot core library is written with the idea in mind that the VLAN
> table is populated by the bridge. Otherwise, not even a sane default
> pvid is provided: in standalone mode, the default pvid is 0, and the
> core expects the bridge layer to change it to 1.
> 
> So without this patch, the VLAN table is completely empty at the end of
> the commands below, and traffic is broken as a result:
> 
> ip link add dev br0 type bridge vlan_filtering 0 && ip link set dev br0 up
> for eth in $(ls /sys/bus/pci/devices/0000\:00\:00.5/net/); do
> 	ip link set dev $eth master br0
> 	ip link set dev $eth up
> done
> ip link set dev br0 type bridge vlan_filtering 1
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
