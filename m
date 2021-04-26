Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B49F236B91C
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 20:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238269AbhDZSkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 14:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238654AbhDZSkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 14:40:16 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70C55C061574;
        Mon, 26 Apr 2021 11:39:33 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id t22so5387371pgu.0;
        Mon, 26 Apr 2021 11:39:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=j9+QSmlBQy3w+PMo2MN3olBIQ1GcC6U1YwHegTMRMOc=;
        b=n6RBy2Jzn/sJ89Aw4e+S15Nwtld1F/fpsNuveRxNz24yl232tPRffDQpbZhYdza5eA
         VOYQR6GvBC8d/3EydDuTRvkEhaC7pzMtVBI8hlUjG3AA77rhs/wgcj73YO3iIEN4RomW
         aV9MRRAY2ZazPgwP/wgh8ADH5O0TAAHEB7Wunr662Q45KY6jKKXQ0sCZMGyJXOHnRQ2Z
         hiKDfytrPancx/Et4dh+AK44o01ivxH93fAHB/SDWSJj6tK2ERUb4F+6LDS2iDfKxr1E
         UuagVKpjgpe2T52sukeEUYJiVSSvivWeYuaKARSMke+CBp/rw/89GLFwfAig5wswkb/i
         chZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j9+QSmlBQy3w+PMo2MN3olBIQ1GcC6U1YwHegTMRMOc=;
        b=W2ZBHlTBSGROStBPSjc0vUu145+aZ8tgxIzvTdv5SKH0MzTwf7wZGATZGoGwVe7bkL
         w+mwmw0HIHU8dXSKiweWfvm5ZCSmkQfk7Vr2XhvIOEYgS9iwU4FZ+wlDqaDPgAFCMhYm
         eQDRfJCcyXbJ+8RD7yKxAk9Y+uM1gkFcp8Y14vR1uaUYrXsxfGF4qLl8YRNKpTuah3BN
         sS4v5rhnTEfWAtw1hnoiyjaCm8BMEYisEAuZccUybjI2NMdanrM4lHAUssU1VUvzRpaJ
         ttFLYyEe3zRrmzZYPIJzGJ4nZCBmciwVn+nlL9LFeFP9IMKW1KrMIQJZixRiwfXNqUh4
         TRuA==
X-Gm-Message-State: AOAM5305KFvjjwD+tFXT8p09h5RJ2JZrUMpeFqL419/oBMJ2Bs++LxKn
        NKkL1w0cU1W575oUUdzTa6IK1dkIDx0=
X-Google-Smtp-Source: ABdhPJy4SABJJ9AzYtj5/qnXFjj9UlLUQAtuBgIJpL8Ih3U1LI7bE+lelVRkJCZUrgcLwNT8Au0HGQ==
X-Received: by 2002:aa7:8a4e:0:b029:263:5a27:e867 with SMTP id n14-20020aa78a4e0000b02902635a27e867mr18882850pfa.55.1619462372631;
        Mon, 26 Apr 2021 11:39:32 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id w6sm384319pfj.85.2021.04.26.11.39.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Apr 2021 11:39:32 -0700 (PDT)
Subject: Re: [net-next, v2, 2/7] net: dsa: no longer identify PTP packet in
 core driver
To:     Yangbo Lu <yangbo.lu@nxp.com>, netdev@vger.kernel.org
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210426093802.38652-1-yangbo.lu@nxp.com>
 <20210426093802.38652-3-yangbo.lu@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <d6cfb1b4-1d04-8a6a-10a4-5e3ced139e3f@gmail.com>
Date:   Mon, 26 Apr 2021 11:39:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210426093802.38652-3-yangbo.lu@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/26/21 2:37 AM, Yangbo Lu wrote:
> Move ptp_classify_raw out of dsa core driver for handling tx
> timestamp request. Let device drivers do this if they want.
> Not all drivers want to limit tx timestamping for only PTP
> packet.
> 
> Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
> Tested-by: Kurt Kanzenbach <kurt@linutronix.de>

This patch does appear to introduce build failures:

https://patchwork.hopto.org/static/nipa/473157/12224031/build_32bit/stderr

https://patchwork.kernel.org/project/netdevbpf/patch/20210426093802.38652-4-yangbo.lu@nxp.com/
-- 
Florian
