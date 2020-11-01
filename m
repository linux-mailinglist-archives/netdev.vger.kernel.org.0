Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 265572A1F72
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 17:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbgKAQNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 11:13:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726549AbgKAQNL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 11:13:11 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 842ACC0617A6
        for <netdev@vger.kernel.org>; Sun,  1 Nov 2020 08:13:11 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id s25so1321874ejy.6
        for <netdev@vger.kernel.org>; Sun, 01 Nov 2020 08:13:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hizFxO5U0R8tcU3bvgZkjY3egegl9PWrXYvABp6hN6g=;
        b=X0ABP5Fvc8zR/kf8BBDwaCXXTBvEM7u/7V8pkG2WghFucTySJ/SEMF4O/UUNBHEtLp
         7rzy/bWDKiOUApv9AR2mSsDxxivSljLC/6szg5DFqgeKN8wC+nT7xaWpzJUk/YoNo0NT
         G9T8jJzHw2aJzH8CfOocqu7jjEHac5LB57P3JUQymWFseNVioAx54mp1sFfWGgZU+ViZ
         XBJNnk8ByUoyyQq03RLzJ4HAUN3OSdZTREP/FyfVUD2VteVjPG1GWAUl8+jgrhcvZ90H
         aHGJHeDxSwlooWERTxBYnZ5m/kcHsH8kUY/DU/T6AHO2PV3UfXrz/n8sad+DLBb/ex99
         5ZYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hizFxO5U0R8tcU3bvgZkjY3egegl9PWrXYvABp6hN6g=;
        b=gqL5sdMUFT+HTt8kJI3I1SAnHnS5OvLDCHMNbXqyBsihqQqsu2jYS45w9QHdO8PWMm
         83YCgRomx0xn1m3BbjeDa36bN8bAY+h0RAvO+ObCkqoykUoBXPVbu80VwBICZL5y3b9k
         XuUAFQW4lYo7EsLGzyJlX/+0po4+Dx+D2lxfy3RefO4BBZTDpzig8SXYY3MpjGPo646s
         8vCRMjWwfhIszc7QqxDSo3vzqkuXly5sS3B0fttL96vvrfpeb6HHnOnnmBxiNL1I2b0I
         OTKaiwz6BhKufZD6jyApueaFpDTuRcJsM15wTBr6F+0l/CpUGQxKfbijmt46pcCYQxkS
         kkVg==
X-Gm-Message-State: AOAM532vhjzUkoeL4a/xeucJfky12NLi3IRBFXW38u+UmVa/PdgFmpjt
        4+N+pneMIwxe89YXfAtOzCc=
X-Google-Smtp-Source: ABdhPJz4a0W3SBrV010Uxrgi4BGy8e1HcKco1YYn+qZ0rsb4UUXoEvfj7Rs8gDb6xrWbx6f3cpl55Q==
X-Received: by 2002:a17:906:bcd4:: with SMTP id lw20mr5072706ejb.527.1604247190152;
        Sun, 01 Nov 2020 08:13:10 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id k11sm7691566eji.72.2020.11.01.08.13.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2020 08:13:09 -0800 (PST)
Date:   Sun, 1 Nov 2020 18:13:08 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        Ivan Vecera <ivecera@redhat.com>, vyasevich@gmail.com,
        netdev <netdev@vger.kernel.org>, UNGLinuxDriver@microchip.com,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>
Subject: Re: [PATCH RFC net-next 00/13] RX filtering for DSA switches
Message-ID: <20201101161308.qt3i72e37qydtpwz@skbuf>
References: <20200720100037.vsb4kqcgytyacyhz@skbuf>
 <20200727165638.GA1910935@shredder>
 <20201027115249.hghcrzomx7oknmoq@skbuf>
 <20201028144338.GA487915@shredder>
 <20201028184644.p6zm4apo7v4g2xqn@skbuf>
 <20201101112731.GA698347@shredder>
 <20201101120644.c23mfjty562t5xue@skbuf>
 <20201101144217.GA714146@shredder>
 <20201101150442.as7qfa2qh7figmsn@skbuf>
 <20201101153906.GA720451@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201101153906.GA720451@shredder>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 01, 2020 at 05:39:06PM +0200, Ido Schimmel wrote:
> You also wondered which indication you would get down to the driver that
> eventually needs to program the hardware to get the packets:
> 
> "Who will notify me of these multicast addresses if I'm bridged and I
> need to terminate L2 or L4 PTP through the data path of the slave
> interfaces and not of the bridge."
> 
> Which kernel entity you want to get the notification from? The packet
> socket wants the packets, so it should notify you. The kernel is aware
> that traffic is offloaded and can do whatever it needs (e.g., calling
> the ndo) in order to extract packets from the hardware data path to the
> CPU and to the socket.

Honestly, just as I was saying, I was thinking about using the
dev_mc_add call that is emitted today, and simply auditing the
dev_mc_add and dev_uc_add calls which are unnecessary (like in the case
of non-automatic bridge interfaces), for example like this:

if (!(dev->features & NETIF_F_PROMISC_BY_DEFAULT))
	dev_uc_add(dev, static bridge fdb entry);

To me this would be the least painful way forward.
