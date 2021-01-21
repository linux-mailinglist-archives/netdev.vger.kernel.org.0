Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B65BD2FE1FF
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 06:48:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728075AbhAUFq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 00:46:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726492AbhAUDoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 22:44:04 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91679C0617A4
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 19:41:34 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id e6so743601pjj.1
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 19:41:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rmcKLhiK7juRjxpsdZqW6CScpTpwD2Jdlwl3kIOClLk=;
        b=C9sUiLuhT6sxL+qJnwUBzuJWbWdHqRnqRJuN2YWOr95jmLJ3hN9KRP5m/feG/VGyKD
         BYlPyyiWnLYut/srntRp0SXvFb3WpCDZqKPw5+KR9g7mOpEZfcpVye4VgfAXZJ4bhdwf
         rlQqUaSh7hD0hp1k32V+F1S7F95xd9h8zmUOMa8VVIFgoZacuv1hP0DUMiH/+lcfDNal
         Y6Mem/jZKyG0hsmtIoCskJQkR4oueriLUtXk0v3OYSjmjvY/QfvPJXEh0j3nmQzo8CfA
         lPygvKHy04YznkeYJwVae155yKm3tjeICQmpW/PIWjaPNPE7wbEYIAfpDtOC/lPcLVDb
         2pBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rmcKLhiK7juRjxpsdZqW6CScpTpwD2Jdlwl3kIOClLk=;
        b=Pk9g6XliRtEfyRf7Wzfj2zJ1uTXfsMs83wKl+A4sAYHISBP/x/M1lXdm4HjMlqpZcc
         NBZzeDAXgLGvt+j4HQuPn6Z3a5XYb56ZQQe59DSU7mVEj0rlE9eVeDeu+4oqy5EK/5el
         dmID/LetFo+WAuXVVam8XR7wAQE4Bv59d58DJ1KzoCmq1epXsdWDELpipIlntnktN8co
         9kMiU1dYq+MQ9vLA7ARGNA+G9365fXpuLCq+2i0DccIJiOjKIDfV8A3AeYC5gi3DHLXf
         /AplhXKFvvxAOBCsuTY5UdLyh9PkmV58ecuC7ZPu42YPXWXnxbfSau3fhDbMOYDEpAla
         nHHA==
X-Gm-Message-State: AOAM530+IPhQCyC67JrPpEHOLff5Hkz7/JQHEBCJDL06YhTEbycWVXMA
        ZJ81yKVds/ekycQdoiGl6Zs=
X-Google-Smtp-Source: ABdhPJxZ7mrWoJCalNV8oBnnmj6sFjzMRVmULT5WH3BJZx7Q1km1u474X8LEcnXwZdvMaI0RDN4akg==
X-Received: by 2002:a17:902:b693:b029:da:e92c:fc23 with SMTP id c19-20020a170902b693b02900dae92cfc23mr12837764pls.55.1611200494054;
        Wed, 20 Jan 2021 19:41:34 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id gk2sm3832488pjb.6.2021.01.20.19.41.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Jan 2021 19:41:33 -0800 (PST)
Subject: Re: [PATCH v5 net-next 05/10] net: mscc: ocelot: don't use NPI tag
 prefix for the CPU port module
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
        Hongbo Wang <hongbo.wang@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Po Liu <po.liu@nxp.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Eldar Gasanov <eldargasanov2@gmail.com>,
        Andrey L <al@b4comtech.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        UNGLinuxDriver@microchip.com
References: <20210121023616.1696021-1-olteanv@gmail.com>
 <20210121023616.1696021-6-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <ac20223a-d08f-b9ac-5648-6f15c844dbdd@gmail.com>
Date:   Wed, 20 Jan 2021 19:41:30 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210121023616.1696021-6-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/20/2021 6:36 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Context: Ocelot switches put the injection/extraction frame header in
> front of the Ethernet header. When used in NPI mode, a DSA master would
> see junk instead of the destination MAC address, and it would most
> likely drop the packets. So the Ocelot frame header can have an optional
> prefix, which is just "ff:ff:ff:ff:ff:fe > ff:ff:ff:ff:ff:ff" padding
> put before the actual tag (still before the real Ethernet header) such
> that the DSA master thinks it's looking at a broadcast frame with a
> strange EtherType.
> 
> Unfortunately, a lesson learned in commit 69df578c5f4b ("net: mscc:
> ocelot: eliminate confusion between CPU and NPI port") seems to have
> been forgotten in the meanwhile.
> 
> The CPU port module and the NPI port have independent settings for the
> length of the tag prefix. However, the driver is using the same variable
> to program both of them.
> 
> There is no reason really to use any tag prefix with the CPU port
> module, since that is not connected to any Ethernet port. So this patch
> makes the inj_prefix and xtr_prefix variables apply only to the NPI
> port (which the switchdev ocelot_vsc7514 driver does not use).
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
