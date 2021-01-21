Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC3E52FF61B
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 21:40:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727270AbhAUUj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 15:39:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726963AbhAUUjm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 15:39:42 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E8B8C0613D6
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 12:39:02 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id my11so5348402pjb.1
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 12:39:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BiNtMctoO+MRg0Gqx39Ove7wQZslkwR3SAoMHq0Tey8=;
        b=Y5P1Ubem0WB51fKy++uz90xju9bMP/K8yW8f+W9hcQPABr7zd6RaGtdJDsMWBIKQt4
         GkihKrSEvhV8ZP3UuXJo/ix7hrjTaqoafYDzonv/RTn+2gQJp5kLHLc7m0b8fiU9u5zn
         WA16/5hQKDwxFBatoIAM19mMnYWdNByyYKBNZ1DJcEkx9CrE/I7N8/PqIkvK67IyeGE6
         ZiIQJLNRdLmGZh+28ZOtKpJ7TuZKIun+gZDtv9dsxipX5w0J1puhlyFzJ1IIWoK9ZGXt
         Bh9YZ6Vx7WgmCw5k0UiljKp0B71YG42hnk+qPUoZlV2S2bvrZxHDxdSigKPXCDKqtfzq
         gm/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BiNtMctoO+MRg0Gqx39Ove7wQZslkwR3SAoMHq0Tey8=;
        b=Lyvzx0VzS/hNfxJuiAl7Gzy7+5xWLvOI++c6P7uyVF0e3OPELFycv1pyIthE30KrLO
         qgG5muI741l0gaqCSNMMoKIqfs8GpDVcBqUcRzxVeNmv80pj+KsPRBXLl88aWqyCBLGq
         rANGUp/luKqF/HHjyc8G6w8oUqNxo759Ayv7PgWJoatLmRzeLU1/h1p+tC5Un4asuraJ
         0b2TgSwbOi03CWrky3fauQhJKXzenbq5WywVnpLi6epfgOLKhs/Ywgl11B3QexqvZuQl
         3vS29anqULO7G3avYQHzgy065UJVvF2LE4cPt85WTyE6YLsBya9dNFzowA2RbBbs4SCH
         xcIg==
X-Gm-Message-State: AOAM531JLsLKpBbBuxtHDZNh8X1d141BG1uHjzXAkjl8u21nOfmYTsNc
        Yy35Iz6yEsBz2gyAhGJBLSzLjcdetLw=
X-Google-Smtp-Source: ABdhPJxh2wnlsWI52rWRCbPHZzlTtfPo0LaRACzijpTLtP7hprpJ03iZ6a6WzrBNBz/sIkwy4xVj2w==
X-Received: by 2002:a17:90b:948:: with SMTP id dw8mr1360794pjb.72.1611261541437;
        Thu, 21 Jan 2021 12:39:01 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v1sm6796724pga.63.2021.01.21.12.38.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Jan 2021 12:39:00 -0800 (PST)
Subject: Re: [PATCH v6 net-next 07/10] net: dsa: allow changing the tag
 protocol via the "tagging" device attribute
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
References: <20210121160131.2364236-1-olteanv@gmail.com>
 <20210121160131.2364236-8-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <d77dda2d-c7c6-8d8b-0336-fd5d979a2e2a@gmail.com>
Date:   Thu, 21 Jan 2021 12:38:57 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210121160131.2364236-8-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/21/2021 8:01 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Currently DSA exposes the following sysfs:
> $ cat /sys/class/net/eno2/dsa/tagging
> ocelot
> 
> which is a read-only device attribute, introduced in the kernel as
> commit 98cdb4807123 ("net: dsa: Expose tagging protocol to user-space"),
> and used by libpcap since its commit 993db3800d7d ("Add support for DSA
> link-layer types").
> 
> It would be nice if we could extend this device attribute by making it
> writable:
> $ echo ocelot-8021q > /sys/class/net/eno2/dsa/tagging
> 
> This is useful with DSA switches that can make use of more than one
> tagging protocol. It may be useful in dsa_loop in the future too, to
> perform offline testing of various taggers, or for changing between dsa
> and edsa on Marvell switches, if that is desirable.
> 
> In terms of implementation, drivers can now move their tagging protocol
> configuration outside of .setup/.teardown, and into .set_tag_protocol
> and .del_tag_protocol. The calling order is:
> 
> .setup -> [.set_tag_protocol -> .del_tag_protocol]+ -> .teardown
> 
> There was one more contract between the DSA framework and drivers, which
> is that if a CPU port needs to account for the tagger overhead in its
> MTU configuration, it must do that privately. Which means it needs the
> information about what tagger it uses before we call its MTU
> configuration function. That promise is still held.
> 
> Writing to the tagging sysfs will first tear down the tagging protocol
> for all switches in the tree attached to that DSA master, then will
> attempt setup with the new tagger.
> 
> Writing will fail quickly with -EOPNOTSUPP for drivers that don't
> support .set_tag_protocol, since that is checked during the deletion
> phase. It is assumed that all switches within the same DSA tree use the
> same driver, and therefore either all have .set_tag_protocol implemented,
> or none do.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
