Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0129345F301
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 18:31:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238434AbhKZRem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 12:34:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbhKZRcl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 12:32:41 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17926C0617A5
        for <netdev@vger.kernel.org>; Fri, 26 Nov 2021 09:08:07 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id t4so8713345pgn.9
        for <netdev@vger.kernel.org>; Fri, 26 Nov 2021 09:08:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zOGB7zW/oonI2FibobIaUfPlQql40BWEzE6mv7OQs4g=;
        b=fdDuYl22mi17e6fRMMiE8yhcOe47UnPH/QKivScsNTQ3aj+M35F5YWRq9bFJz0hign
         qKFGVJFz1q/1OsaF83h7tFZT5m6Z+F1nezNlRR3m+JXo/3DQM0uBuB7FBrwdMpS4Lh21
         lWmMITtTOisplrLTQ5nl6qp0vCX9a39NHaKNn72SDXxY/jhcLU1lZTXcfQoOOlw1P/P/
         r9hx68u4jl5mVjsHCE8SgoR+ai0fKXiojqZXgJD5Gi0xTdCSbSBzQROpnxPdSQ+iNRqK
         G4fiQdC/jEzPXm/m+ZY6gRkuERSLzjdW8BtFLzCeBkgUthqxVMg+BDCQvOGDtMZk2snZ
         UjeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=zOGB7zW/oonI2FibobIaUfPlQql40BWEzE6mv7OQs4g=;
        b=yOaZ9yfxaQ3jf2KF4YBLiT8MM3/l3zc3Xk4Zc9cSqtevObQ1WrZWwn7a7ILLXYAjZO
         X8A2ntSh0jcp4g6cBTkUsPHBf/A1vYqbUrqrN+l4u4m01lXeK2lKWUHsW4d0EIw/sP09
         3h/jK48X9lJGKkYuNsOTGobbvBQZeX4zsy/xfzPolY3zdVaksMnT82hXpDHIkcdZ4bQA
         ihGTxKs5lQKMaXUxjiCzKm0OftMkLlW4GLHVMj1X/n9irnhpVcrRWSG1bB17fzBzn/vZ
         lWcoB+mqcVdQrWfoH2T3f1CJ03ZB8lCQ3mHJsDicEH0j0cl303Sn7vpXHAaBgvQLhzaS
         0LvA==
X-Gm-Message-State: AOAM531BuMLnnYA7aRwSwccBt0S4cvNoCoaJ+JyFJ/8HHzB3+YPE4Ql7
        N/ztic7lM0+T7U8Y3+vDnJs=
X-Google-Smtp-Source: ABdhPJzKfWHLb8jiBhP7O1SvqGWeE1dxvyEMRMTPkgn4PLIM4ovfwLZ76iaF5yJusIOnHo0+d9rWwg==
X-Received: by 2002:a62:9202:0:b0:4a4:f09e:7d75 with SMTP id o2-20020a629202000000b004a4f09e7d75mr22449603pfd.33.1637946484363;
        Fri, 26 Nov 2021 09:08:04 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id p2sm6148859pja.55.2021.11.26.09.08.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Nov 2021 09:08:03 -0800 (PST)
Date:   Fri, 26 Nov 2021 09:08:01 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Po Liu <po.liu@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Antoine Tenart <atenart@kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "Y.B. Lu" <yangbo.lu@nxp.com>, Rui Sousa <rui.sousa@nxp.com>,
        "Allan W . Nielsen" <allan.nielsen@microchip.com>
Subject: Re: [PATCH net-next 4/4] net: mscc: ocelot: set up traps for PTP
 packets
Message-ID: <20211126170801.GF27081@hoboy.vegasvil.org>
References: <20211125232118.2644060-1-vladimir.oltean@nxp.com>
 <20211125232118.2644060-5-vladimir.oltean@nxp.com>
 <20211126165847.GD27081@hoboy.vegasvil.org>
 <20211126170112.cw53nmeb6usv63bl@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211126170112.cw53nmeb6usv63bl@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 26, 2021 at 05:01:13PM +0000, Vladimir Oltean wrote:

> This, to me, sounds more like the bridge trapping the packets on br0
> instead of letting them flow on the port netdevices, which is solved by
> some netfilter rules? Or is it really a driver/hardware issue?
> 
> https://lore.kernel.org/netdev/20211116102138.26vkpeh23el6akya@skbuf/

Yeah, thanks for the link.  I had seen it, but alas it came too late
for me to try on actual working HW.  Maybe it fixes the issue.

If someone out there has a Marvell switch, please try it and let us
know...

Thanks,
Richard
