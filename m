Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7730B2AE72E
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 04:45:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725976AbgKKDpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 22:45:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725849AbgKKDpC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 22:45:02 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A2B0C0613D1;
        Tue, 10 Nov 2020 19:45:02 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id v12so767320pfm.13;
        Tue, 10 Nov 2020 19:45:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rnbLMNtHljBapvM78K/ufrArsOT1Tj93sPuGgYeOtEE=;
        b=Y5oCbCrfM+Pt96bcFo5KZ/gZRkyWbLRb2GfC6zVEPxyr2HExZgkg7DLoRmG0zvdgcP
         tC9F/BD2B4Qe8gTOUn7bhcxV69qCmsdOgup+WWtnQ5qJCLVv9RkhbsXkTW1MJstDCIZS
         Lfc1FBZO+f+7xBHVgsXDEUxGao1HD7BdQMuODda+axxweZfpY7iISBXTxy7FhBJoLFNq
         Sd/Mdfnetx217r4oRy1V2tLWaMNhDnwM9VB68NtIZ9LFG1+dwbWmiXEFR7iufQpdABrc
         4/EFH/3DFHDGmPCuVZVwXnFIE2Sa2Vkx4oANi2P2IKNMeAYN9ihxcyXJbeG4+eiCfdI1
         QYYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rnbLMNtHljBapvM78K/ufrArsOT1Tj93sPuGgYeOtEE=;
        b=RN2kTQOgapuemCbuGvSVhcXyqwS0lUy8PuBrMvt6pDAkiNQRyPdE0yOG8utueMfw+M
         pxGJt38CU7DqGd3CwtdKXZ9eOVnQfYzSgnbpX3KPluVn3juF02nkhj2LRKti4qGFqzfe
         M3W2aCKTYqLTRYfbnDYz0qCQq+Wc/5v8UlN/aywJ88nPPiLDReEdwBz/9478TX/iclJ6
         6BCDGzm/hwZX35ZSk7Ng8EdZsdiRMp+w4HMEq1gHbgqVXgy+vt32LAuKyp3WwQ6dTJ2p
         +I6zAASPBLU3KtKJR1+wmZQ0iZZO/9uh2RiD4MRWzvPFsNI5kvQ3JHhv2kGrcWQaU1yt
         LZ7g==
X-Gm-Message-State: AOAM533pLKJQXJjuFynVuKI8us/1Csp/P1kFFjDawPzJcprWAjlRv5ks
        U2n0MpQUCdilpQFcgYe5olI=
X-Google-Smtp-Source: ABdhPJyQXfdALt9USvkJWka5bDoiURyvSCB8OLjcS0Y62X0s524S2msg1o4hUB9C2SiD4pxWqSlyrw==
X-Received: by 2002:aa7:9888:0:b029:18b:a9e2:dc7a with SMTP id r8-20020aa798880000b029018ba9e2dc7amr20808115pfl.67.1605066301975;
        Tue, 10 Nov 2020 19:45:01 -0800 (PST)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id c28sm619137pfj.108.2020.11.10.19.45.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2020 19:45:01 -0800 (PST)
Subject: Re: [RFC PATCH net-next 2/3] net: dsa: move switchdev event
 implementation under the same switch/case statement
To:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Marek Behun <marek.behun@nic.cz>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
References: <20201108131953.2462644-1-olteanv@gmail.com>
 <20201108131953.2462644-3-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <650cc6e2-8bf7-57b9-595d-08624f545a07@gmail.com>
Date:   Tue, 10 Nov 2020 19:44:59 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.4.2
MIME-Version: 1.0
In-Reply-To: <20201108131953.2462644-3-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/8/2020 5:19 AM, Vladimir Oltean wrote:
> We'll need to start listening to SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE
> events even for interfaces where dsa_slave_dev_check returns false, so
> we need that check inside the switch-case statement for SWITCHDEV_FDB_*.
> 
> This movement also avoids two useless allocation / free paths for
> switchdev_work, which were difficult to avoid before, due to the code's
> structure:
> - on the untreated "default event" case.
> - on the case where fdb_info->added_by_user is false.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
