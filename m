Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A967D1E93B5
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 22:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729340AbgE3Uu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 16:50:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728741AbgE3Uu3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 16:50:29 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14264C03E969
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 13:50:29 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id r9so7096789wmh.2
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 13:50:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oMasJywGtBcsLND4NanLZbYZnsnkvN0RElD+lxuDDr4=;
        b=fI4UfGM+CzMbgvL+Ku8B0guNDSa0MmdR8W4qNHWXo6x00cQLHI4FjIKgjGtYF1dcyF
         uOhZONCvom9XTVSsKHnXC+X1F7O82Liurk0NHWYA54iemm0h+Kv6mt9MJI0zZy9GdU12
         F4wSQaL8dpU9/JCmEfUarUnwKuHTn6SMoqp94g8c7LAT0a1YH5vySGN5TD03D4JcBbZ+
         55e7SqBVZLRHA15SOTQfYsWb7mrhBUkFckrDn+Bod6oFgfKF79F5Rm6mPY95NX8jtqFK
         Mc0gwFNapIm9q5392kf7w3k4Hbhkf4rpFu4ePVUeC/HaveLTkmln4dTw+5hq+nbx24yX
         Gxlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oMasJywGtBcsLND4NanLZbYZnsnkvN0RElD+lxuDDr4=;
        b=IYmFYG0uSqi0mYko9RSyQJtU9jSpeVRfO0WuNozBH66pz0gc95cbmGCxNNT3EQk+TJ
         PnxyEPh1/E73hFFwZce34UQwTufx/75+BvoPZCnH9hPavPHg8/Fx5jpATCWCIuK2E9oy
         3hvyduziWVlA77RYCb4MYyN3meN25yTeGK5Ls7gfAlYjJmTvgcddRQqkzKF+lfVaySew
         ddcGcDHo9YkHt3jISUVZppPTWMy3e9GI0IOzjgdv9Fuvo6kkrsNYrSG7j5fko2vQChJu
         jyey/a5cNvKiJEEAp14NOzYXLr7Ij3lgRmLdqlDKgKzwMz/bBabS4Z0Z3OJxhYiDCrpS
         gT8Q==
X-Gm-Message-State: AOAM5335Nz8d7atRDpB2X4MFPgXqjaXMuvr9FLEa1INbsC7AjJs9fWRs
        VCewwWJjPHuDDVI+5ltAGQg=
X-Google-Smtp-Source: ABdhPJy7+ICQmKoMkTnq1LFvEPpALOeUJ0L0NqxBfXcQOg73x2+Di2qlqfCvsYRhg3AxZfayT8+Kgg==
X-Received: by 2002:a1c:f207:: with SMTP id s7mr14337988wmc.123.1590871827759;
        Sat, 30 May 2020 13:50:27 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id w10sm15145346wrp.16.2020.05.30.13.50.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 May 2020 13:50:27 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 11/13] net: dsa: felix: support half-duplex
 link modes
To:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        antoine.tenart@bootlin.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, madalin.bucur@oss.nxp.com,
        radu-andrei.bulie@nxp.com, fido_max@inbox.ru, broonie@kernel.org
References: <20200530115142.707415-1-olteanv@gmail.com>
 <20200530115142.707415-12-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <48f202fb-c9cf-f872-0b62-8cc96a36f340@gmail.com>
Date:   Sat, 30 May 2020 13:50:23 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200530115142.707415-12-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/30/2020 4:51 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Ping tested:
> 
>   [   11.808455] mscc_felix 0000:00:00.5 swp0: Link is Up - 1Gbps/Full - flow control rx/tx
>   [   11.816497] IPv6: ADDRCONF(NETDEV_CHANGE): swp0: link becomes ready
> 
>   [root@LS1028ARDB ~] # ethtool -s swp0 advertise 0x4
>   [   18.844591] mscc_felix 0000:00:00.5 swp0: Link is Down
>   [   22.048337] mscc_felix 0000:00:00.5 swp0: Link is Up - 100Mbps/Half - flow control off
> 
>   [root@LS1028ARDB ~] # ip addr add 192.168.1.1/24 dev swp0
> 
>   [root@LS1028ARDB ~] # ping 192.168.1.2
>   PING 192.168.1.2 (192.168.1.2): 56 data bytes
>   (...)
>   ^C--- 192.168.1.2 ping statistics ---
>   3 packets transmitted, 3 packets received, 0% packet loss
>   round-trip min/avg/max = 0.383/0.611/1.051 ms
> 
>   [root@LS1028ARDB ~] # ethtool -s swp0 advertise 0x10
>   [  355.637747] mscc_felix 0000:00:00.5 swp0: Link is Down
>   [  358.788034] mscc_felix 0000:00:00.5 swp0: Link is Up - 1Gbps/Half - flow control off
> 
>   [root@LS1028ARDB ~] # ping 192.168.1.2
>   PING 192.168.1.2 (192.168.1.2): 56 data bytes
>   (...)
>   ^C
>   --- 192.168.1.2 ping statistics ---
>   16 packets transmitted, 16 packets received, 0% packet loss
>   round-trip min/avg/max = 0.301/0.384/1.138 ms
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
