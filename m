Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 148E12C6DBB
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 00:42:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731144AbgK0Xl7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 18:41:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731652AbgK0XlC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 18:41:02 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41166C0613D2;
        Fri, 27 Nov 2020 15:39:20 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id k4so7324928edl.0;
        Fri, 27 Nov 2020 15:39:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4PTcGXppTtgtL4n34jHd/JlKxnsgY9Zzpe2NAG5NV0Q=;
        b=P+IO5jSKKJVk1WdJmTiBBvmYOb1uvbqo2hOoZvfT4eseFqXJqWT3a2kLu71iwo5Hzt
         /ETJEM3iyw8/0PxLziEZp1VB8RDwKL8VwNCAt3mgYmXG6VES5CCWjag4fvDrRG1BOQEn
         RgOTLZxjUpuo7sQ3FE3ci+iepsbQb6p/uzBF06BGpdG43mB7ZiHrHJVvJKfURZ8MFlE1
         klZE94VF8I6UclZntgveT4AzvONtpiJU5/K+SlxAVikatmy4jO2SGBvgt4TewkKLuIYP
         dEnir4etkznn5r0bmF2/TzJTeqAM3JJMWD9ODLRjXvQMJPwx6+XY4vJVAOFrCGdh86C0
         wZhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4PTcGXppTtgtL4n34jHd/JlKxnsgY9Zzpe2NAG5NV0Q=;
        b=gehe8yYpPuawBGt4OXF5ezciW1exHdToBCBwlc8c1hBjfTxfzy/E5JxELqeAMAjgqr
         Q8XVgBFJHULPL1Iz3gOtWbth1jUpVp4fwHSRU+F0lQd2rogeJ/KPrydzKzYc2mujaXsa
         d6SYBXK/iDCsDeAW0LwY99s5AKlYwVzO5PkBkMxcoCOjErWeuVzsu5qoIAHq/+hqMxwi
         2RGhdcAsjxnea7dyAxIVGELKOemmg7gdqy4t9wnsp1jZ7vdzmELCUKnaWkNcE/LsIvKK
         zss5NvSZHr3OfyXq20CLryzulOA94gg1sAdsCKcfzpJxihexpI58hgTquqQOTcwDbKtA
         Xutg==
X-Gm-Message-State: AOAM530/dcD7gf1TgkJMdkWCYjGDB8DxmA4wsOyJ6kfTsdAWxMUq3wk1
        Z4AXKhsNou2qlyp1m3zPfH8=
X-Google-Smtp-Source: ABdhPJyGeCt/tgXOV+m+A9KgftHEJUULof7/tNKWq9VwOzZNiO6tmiidTT7S0MmzE1T1trFDLIkYaA==
X-Received: by 2002:a50:e0c9:: with SMTP id j9mr10525326edl.380.1606520358961;
        Fri, 27 Nov 2020 15:39:18 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id d19sm5763035eds.31.2020.11.27.15.39.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 15:39:17 -0800 (PST)
Date:   Sat, 28 Nov 2020 01:39:16 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        George McCollister <george.mccollister@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Subject: Re: [PATCH net-next v2 2/3] net: dsa: add Arrow SpeedChips XRS700x
 driver
Message-ID: <20201127233916.bmhvcep6sjs5so2e@skbuf>
References: <20201126132418.zigx6c2iuc4kmlvy@skbuf>
 <20201126175607.bqmpwbdqbsahtjn2@skbuf>
 <CAFSKS=Ok1FZhKqourHh-ikaia6eNWtXh6VBOhOypsEJAhwu06g@mail.gmail.com>
 <20201126220500.av3clcxbbvogvde5@skbuf>
 <20201127103503.5cda7f24@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <CAFSKS=MAdnR2jzmkQfTnSQZ7GY5x5KJE=oeqPCQdbZdf5n=4ZQ@mail.gmail.com>
 <20201127195057.ac56bimc6z3kpygs@skbuf>
 <CAFSKS=Pf6zqQbNhaY=A_Da9iz9hcyxQ8E1FBp2o7a_KLBbopYw@mail.gmail.com>
 <20201127133753.4cf108cb@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <20201127233048.GB2073444@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201127233048.GB2073444@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 28, 2020 at 12:30:48AM +0100, Andrew Lunn wrote:
> > If there is a better alternative I'm all ears but having /proc and
> > ifconfig return zeros for error counts while ip link doesn't will lead
> > to too much confusion IMO. While delayed update of stats is a fact of
> > life for _years_ now (hence it was backed into the ethtool -C API).
> 
> How about dev_seq_start() issues a netdev notifier chain event, asking
> devices which care to update their cached rtnl_link_stats64 counters.
> They can decide if their cache is too old, and do a blocking read for
> new values.
> 
> Once the notifier has completed, dev_seq_start() can then
> rcu_read_lock() and do the actual collection of stats from the drivers
> non-blocking.

That sounds smart. I can try to prototype that and see how well it
works, or do you want to?
