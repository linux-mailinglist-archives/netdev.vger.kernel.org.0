Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82CE12FAC4E
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 22:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437949AbhARVLy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 16:11:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388083AbhARVKb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 16:10:31 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36420C0613CF
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 13:09:47 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id n25so11709146pgb.0
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 13:09:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RQfbZVp6OIgjf2TYGhscw0sRVXCovP/nXa/vEFcNt/w=;
        b=HjSdlOYQyURi7cfM34YIWtghvLR21F5XJ1rC6BWrwnKVoiSniC69M9r5CKZ01T6cZb
         cj0V2mYKpC8NXGJ4JHYjPdvSeylBFHFz6QmiNtYRWol79Mr5gIRpP/waFvoH4EcmCqzW
         RE12hkHVuB/2WnZ4EynbP/YAhnYV8PcP2cnoby1ZUxpo/3AmZoKQSMMfAUonzvbBqotO
         fkVa1UW7Rmo4yEQKIJJKY8K5VcBZdSY08E4W08ixx8xzJz6weAnol9DXDkI6yr+19G1L
         0murtSIUugM/0teaYNrufU+/h125BBxpftKGxs3eEtwxdSnX2ItmHPd1Zvj3HAinSXeM
         jojw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RQfbZVp6OIgjf2TYGhscw0sRVXCovP/nXa/vEFcNt/w=;
        b=eEmgTORvajRihugKrNB0cQ7pa5ebX7MhLYs6JZwz+8dc6do5f9K9xrQEImqD9IU0VJ
         65noOJYbVX7+pmNnHFnswiFesqM+DklQhe42njqY21fECTHW6aRbAtWb8kcDHx1pG4j+
         a00lqDI6UDwjbdMdv8vTNwHvbLylVCsmSOdaiPK9b0shds8q7uukkhd08MOLPq6+n2A8
         18wLSq7x9Slep51AeWix4pzwB/mBK18sR/4geUTqUR7KdSq09suQHiFZKYgBvWISfAoU
         B5uXKJdt62FC5ksw5vOofDD4I9ALRXcaSc9vzbjaP09mhjWL0WUl79FWS09ynSOwhOFO
         YluA==
X-Gm-Message-State: AOAM532Zbt6IaLuUmv1YQvdlt0qJrC+8WvvpQS1dE+CvdNxEZOZA3yZ4
        mRHAgutF+EYG4vGDYniX2s0=
X-Google-Smtp-Source: ABdhPJwerl/hFiPIc2mmAYJRRc1kGX/DAvJtBF1oCa9B+ZpQ0FLtsSzdBD0cW8kQffREdU8MDScC9Q==
X-Received: by 2002:a65:5244:: with SMTP id q4mr1464840pgp.50.1611004186750;
        Mon, 18 Jan 2021 13:09:46 -0800 (PST)
Received: from [10.230.29.29] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z3sm16341213pgs.61.2021.01.18.13.09.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jan 2021 13:09:45 -0800 (PST)
Subject: Re: [PATCH v3 net-next 05/15] net: mscc: ocelot: stop returning
 IRQ_NONE in ocelot_xtr_irq_handler
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>, Po Liu <po.liu@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Eldar Gasanov <eldargasanov2@gmail.com>,
        Andrey L <al@b4comtech.com>, UNGLinuxDriver@microchip.com
References: <20210118161731.2837700-1-olteanv@gmail.com>
 <20210118161731.2837700-6-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <ecec329a-6cbf-2fab-1dac-c2337b8b1327@gmail.com>
Date:   Mon, 18 Jan 2021 13:09:42 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210118161731.2837700-6-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/18/2021 8:17 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Since the xtr (extraction) IRQ of the ocelot switch is not shared, then
> if it fired, it means that some data must be present in the queues of
> the CPU port module. So simplify the code.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
