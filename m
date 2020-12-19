Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2E32DEC52
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 01:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbgLSAVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 19:21:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbgLSAVC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 19:21:02 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C932AC0617B0
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 16:20:21 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id g3so2282247plp.2
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 16:20:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=8XwQfNsR0VqvYJXV/Cniop9uXOdhjkemWZinyR4lNns=;
        b=OpUgMMN/XUHnqxT88ooZ+NCkRNREDljb/qb0y6GvjeC9KC/8DGNFS+AchZ1J62H9D5
         KTSCwPWTQVjvVH1CBgl28mAiqeeWZixuQ7WsazH7oY4bwet262oVeUtlr8Tb+D4A7cDH
         Bt5cX0lCShDBgjYeAJzo8Z8EExxNtQvJQIf2ZYcKaP4Bwtf9FKeUjfYXiorCxFFY63gN
         23DSWgydmiFmQmnc73V4A3LbYBH2NX2I8bswt4DnaYbJ9sJu6jL29bftbgupElItvkbJ
         CBfxOt3tX5Aq4aDzjZ054DAfG7fK+ZBCTHWBujDk33LOFaCSKsTmJ28XLIvZq2Z9/WQR
         SvHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8XwQfNsR0VqvYJXV/Cniop9uXOdhjkemWZinyR4lNns=;
        b=aDqvqXES9zb7OAJjUA2g2NVtfioc+urCSBXORGO7XH/Ajda3pAaW0lcxu5om3BepqO
         xEXPmzHwa/zFJ7CE7cJZPdnxxxQNhdkokREmPMRU6o16Lvb2xuw2CmQCYEjC1digyVSe
         wfkWasdM/fizaAnuEsolrJhYm2zH0hyrC1Q18UFDixH5W9Qx3ld/HGbxmiiXRFw/RKhY
         mgAP2W+mHYzFP/TOvOTR4ZM+rf/XZSMmEbDtrOGw9phvuTqrErdQ4KtNCNFs2N8XSie2
         LHndh5IMnOgSoJuMrBAbzGKwg4dsElMuzRlTsnypFilmc3LbmOIdVDaSxE63f821QKcg
         a5Gw==
X-Gm-Message-State: AOAM533YRLM1dXaFMFVBzfnIqzHh2eC//GZfTz5TkgHivjNheg2WTvyq
        +muplKnw76Kg7exOjm06/zCXFc+y+sM=
X-Google-Smtp-Source: ABdhPJzlL/a5aPVjnk1IiE2og+qeXZzP5a8Mf75JyaeFX4d319n4U6QMJ0f0VU3FSHQt7ZXMCZnq4w==
X-Received: by 2002:a17:90a:6ba4:: with SMTP id w33mr6888983pjj.32.1608337220703;
        Fri, 18 Dec 2020 16:20:20 -0800 (PST)
Received: from [10.230.29.166] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id c24sm10007715pgi.71.2020.12.18.16.20.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Dec 2020 16:20:19 -0800 (PST)
Subject: Re: [RFC PATCH net-next 1/4] net: dsa: move the Broadcom tag
 information in a separate header file
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org
References: <20201218223852.2717102-1-vladimir.oltean@nxp.com>
 <20201218223852.2717102-2-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <431216d3-6840-cfeb-ba80-b8e4baf6d311@gmail.com>
Date:   Fri, 18 Dec 2020 16:20:17 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201218223852.2717102-2-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/18/2020 2:38 PM, Vladimir Oltean wrote:
> It is a bit strange to see something as specific as Broadcom SYSTEMPORT
> bits in the main DSA include file. Move these away into a separate
> header, and have the tagger and the SYSTEMPORT driver include them.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
