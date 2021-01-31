Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2E43309F1D
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 22:33:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbhAaVck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 16:32:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbhAaVcg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 16:32:36 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F852C061573
        for <netdev@vger.kernel.org>; Sun, 31 Jan 2021 13:31:56 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id s24so9146186pjp.5
        for <netdev@vger.kernel.org>; Sun, 31 Jan 2021 13:31:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=N+RP4B0mnNRSwCp9apKcm/fkVQ2+ABm7s9L+bxHegkU=;
        b=h1THxKcHLoke31Who4CjjVwWhcZ3h2CIle3fzMM7pLyxrmP5bHnb3u5ysQfcvxJM26
         YPmd7OgobHyN3zX9CYsijS4T/iQt31J5vKyOxgsZTxqBdYtPmcV5fEfV2u/0dc9aZ+j0
         Xfv6spY8IW3sVFf/eOwAusVkAWI2EahC1tXblSFoQL5cBflHvQwh542G+2tjkSFctj0r
         DTfv781a+JT0iIlAXB+kCB8r+LTA403onvsTy6ICFl0EEktRwOVV/z4nHRPkEjVqaiRj
         uXcmz3fmlgpuY4petlfP1BYGhgqyUnYqeu/AVvmW7oCtscr1QZWZWfNyoFxOal+nwLzC
         1lmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=N+RP4B0mnNRSwCp9apKcm/fkVQ2+ABm7s9L+bxHegkU=;
        b=KM0yJIkTvclUuRjyqTsPS8PSSI80GLSd3MSuYp3V3vjyYbmbjL7Kxux5Q3bZ7IWvqe
         xd6J+rfOt2kjad0kfTi6XYKnpHTj0zrjmpNZews4Pjf/gqh4Tjz/nndiQWPvt2U2a5Ld
         q77EFjci7UOwnM7C4zEvpR/YmBBwXImzx97J1GUFwSCmSfG6iBNdj6/1O2ru1YnZaUjk
         a8Gh9KfStTo+iFqKM7o6iGf+l1/T/kdpTH+1g9lNe9CVH+iwrxBqSDb+FJDWkOOCFdQV
         7OzqGEouf8e6CEGmClFqhxPZBJjrfTqSvXw69zNsmdoxHJcVzrr8A51icLEGjUbjz4Le
         uFzw==
X-Gm-Message-State: AOAM531jGT5XVTS3QUS5TUrKWIFrGJFVXYCXBX73p/byBcPcnDdqfBVt
        Z2w794jYpDEX8cdteJAR4jMtizK2NvU=
X-Google-Smtp-Source: ABdhPJwy24YBKPxA4cWYbgyYCSCz3bI1LHa4trVygEE41pX6VmCKiSpEsDIzEQ2A/Dm/BRna3XHRgg==
X-Received: by 2002:a17:90a:4611:: with SMTP id w17mr14376674pjg.18.1612128715609;
        Sun, 31 Jan 2021 13:31:55 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 14sm5395024pgp.83.2021.01.31.13.31.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 Jan 2021 13:31:54 -0800 (PST)
Subject: Re: [PATCH net-next 1/2] net: dsa: hellcreek: Report VLAN table
 occupancy
To:     Kurt Kanzenbach <kurt@kmk-computers.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
References: <20210130135934.22870-1-kurt@kmk-computers.de>
 <20210130135934.22870-2-kurt@kmk-computers.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <5210df7a-9242-7ae1-9f9f-3de99c4402bd@gmail.com>
Date:   Sun, 31 Jan 2021 13:31:48 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210130135934.22870-2-kurt@kmk-computers.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/30/2021 5:59 AM, Kurt Kanzenbach wrote:
> The VLAN membership configuration is cached in software already. So, it can be
> reported via devlink. Add support for it:
> 
> |root@tsn:~# devlink resource show platform/ff240000.switch
> |platform/ff240000.switch:
> |  name VLAN size 4096 occ 4 unit entry dpipe_tables none
> 
> Signed-off-by: Kurt Kanzenbach <kurt@kmk-computers.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
