Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24ED72A1DC1
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 13:06:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbgKAMGs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 07:06:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726442AbgKAMGr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 07:06:47 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F06DC0617A6
        for <netdev@vger.kernel.org>; Sun,  1 Nov 2020 04:06:47 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id a15so2490529edy.1
        for <netdev@vger.kernel.org>; Sun, 01 Nov 2020 04:06:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zrv82RtMOzVdOBkfEOuV9mbqf3bEcXIP0yk81pQoVGw=;
        b=h51ouuEZdRYysfqMT6kiA4y9y6kTN12QWr5wNDLtr5EqGMpAWgYJhDMGupAmRU0xa4
         R009vi5uuXUjCxxoGs6t4lNJoa8RS0pui5Aa3rCpQcYmCCWspFHzAAetEPvTtzvnrWyA
         aOM0lOTNLAGtpvoo/Yy7ejUpB9IBgcj4r4HK3Qz4WIIJqXuWyxCGAIqkwc28gVN2laEM
         gXNYG4o+VkipV5Xn9CSLW/JykCtVd67hK12Drk46GUR5C0+pFXrrqXQoqJy029TGpJay
         6oT331an0s64Ty5nYvKxLZGuDYGIy1Piz9/NId4GrK8sRmNx22YHoohzMqQgUF4nlSRK
         OO+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zrv82RtMOzVdOBkfEOuV9mbqf3bEcXIP0yk81pQoVGw=;
        b=TGh81JP2ID6lcwzi4Wwho/yxgtRSKi1PXbtUhW+4zVzjivqIMagIp9D3M+Zlco2l/E
         sfWs+qnMyQmKe9alq82zfZ3kEoxNOMv4nk0Ne1M7wd8UflKtkxFzOUKUuVp9Mg+gIjcC
         U+2Um+f0H+taLlFc8DzgiqQxM1ugAtBIB6hOWZJO1jkz875DFGqlZE2ZGN2kiuefHKJE
         Mb4B1HZwkCIMMbH3QdMy0A7wgHnGEZk3yXLgP/HUokaxipUa8wfv1zAbFvspsB9rmaOp
         AqZpB0ZHVEIxfXuO7eBoCyCdD3LqlAsE/FLhcL5h8A2HSz/YeE5GVOwLhr9Z+BXsIuvC
         V2LQ==
X-Gm-Message-State: AOAM5325WoLcsBrxc8EphobnYBfPCPuhZG6b+sTaMo94DRRI786R/hmR
        fXLpd/DYLn2UDMviL/4Ww/A=
X-Google-Smtp-Source: ABdhPJyGs675v26cuOP0OfBo0E3ohso1W3j7Vz1l9y8BmMVWUB6CUxSRS8ci/fw5TyAWnnb6kmxH5Q==
X-Received: by 2002:a05:6402:3064:: with SMTP id bs4mr11870285edb.140.1604232406013;
        Sun, 01 Nov 2020 04:06:46 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id mc2sm1104591ejb.1.2020.11.01.04.06.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2020 04:06:45 -0800 (PST)
Date:   Sun, 1 Nov 2020 14:06:44 +0200
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
Message-ID: <20201101120644.c23mfjty562t5xue@skbuf>
References: <CA+h21hq+TULBNRHJRN-_UwR8weBxgzT5v762yNzzkRaM2iGx9A@mail.gmail.com>
 <20200526140159.GA1485802@splinter>
 <CA+h21hqTxbPyQGcfm3qWeD80qAZ_c3xf2FNdSBBdtOu2Hz9FTw@mail.gmail.com>
 <20200528143718.GA1569168@splinter>
 <20200720100037.vsb4kqcgytyacyhz@skbuf>
 <20200727165638.GA1910935@shredder>
 <20201027115249.hghcrzomx7oknmoq@skbuf>
 <20201028144338.GA487915@shredder>
 <20201028184644.p6zm4apo7v4g2xqn@skbuf>
 <20201101112731.GA698347@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201101112731.GA698347@shredder>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 01, 2020 at 01:27:31PM +0200, Ido Schimmel wrote:
> IIRC, getting PTP to work on bridged interfaces is tricky and this is
> something that is not currently supported by mlxsw or Cumulus:
> https://github.com/Mellanox/mlxsw/wiki/Precision-Time-Protocol#configuring-ptp
> https://docs.cumulusnetworks.com/cumulus-linux-42/System-Configuration/Setting-Date-and-Time/#configure-the-ptp-boundary-clock
> 
> If the purpose of this discussion is to get PTP working in this
> scenario, then lets have a separate discussion about that. This is
> something we looked at in the past, but didn't make any progress (mainly
> because we only got requirements for PTP over routed ports).
> 
> Anyway, opening packet sockets on interfaces (bridged or not) that pass
> offloaded traffic will not get you this traffic to the packet sockets.

I don't think it's a different discussion, I think my issues with what
you're proposing are coming exactly from there. I think that user space
today is expecting that when it uses the *_ADD_MEMBERSHIP API, it is
sufficient in order to see that traffic over a socket. Switchdev and DSA
are kernel-only concepts, they have no user-facing API. I am not sure
that it is desirable to change that. I hope you aren't telling me that
we should add a --please argument to the PACKET_ADD_MEMBERSHIP /
IP_ADD_MEMBERSHIP UAPI just in case the network interface is a switchdev
port...

> There was already a discussion about this last year (I think Microchip
> guys started it) in the context of tcpdump.

The discussion with Microchip people was slightly different, as it was
tackling the notion of promiscuity on switchdev interfaces.
