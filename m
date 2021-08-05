Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 675EB3E141C
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 13:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241100AbhHELuE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 07:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232513AbhHELuD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 07:50:03 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2858C061765;
        Thu,  5 Aug 2021 04:49:49 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id z11so7915908edb.11;
        Thu, 05 Aug 2021 04:49:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mOSZkg7FYwdwe0mHrQ/hjMERJjb3MAqRK9bYtfC1anc=;
        b=nZiAuwudRCQI9y5JPyP4ZEWV2/HTaKwn0E0PQ012b3iTZoB4qEF1Tbh/GbAYpMSMdj
         pzvBUrKqfZlQ3PRzNtmXo/j9DkA6UZa6EiqEHk9HfS/ic6eVyNjpilElrtw1iAVqeGw5
         ENHCY2XeckwqJ7BAa6LJQnMlZlW5GRGe/af6YKFf2AZVpp3dDguXrbiSZIVQDOsxBWsu
         nLLGbEM2k3w7/YdEb3xwUXwe8IIhQ7KBYne4LhsO4+MT/QOSx+T5dBJGAb4Pr6VhPjq1
         rICEL8MMOkn4ANYhUb2MLp/F9xJzBMGFqZJH1Qgdg1zvNVwVIYA+U0mghegGwlTl/L1D
         ofgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mOSZkg7FYwdwe0mHrQ/hjMERJjb3MAqRK9bYtfC1anc=;
        b=m3wZfktuurqzmyNkiQUNQrGUGXjMbG54eCCF8meC7diLWEUQGvTh9oDP2JupxMBkD0
         CLXhnYKnxNR1ILnDUB0Pq4jc+haUTtoOjn/CMl0Duu8BHMKaO1HUaLmaD+o06foZKFFZ
         7eTVUXm7oAtnTZdUWGzY9gTHRAjRO0moGJBaM06FLE7g8aTP4nPhS2Ofd/pKQKMJ1PNU
         TT9PZl86AVRywKZplnD7DHeRCmZbor7A2qzMhHWQzKd2yt0YwIpJx1PWOVuNMMwk/xFC
         SDX3WUl1Jh+CRNQ+fXbcwk6UnWS0CskSQ2SNVbXqYRVo+6krhCkjXDf6YbKVtFSldCq8
         20uw==
X-Gm-Message-State: AOAM532vKict3GesOHpsW4B87Oavvz4GHUjw4HgTEB8ZEzQaCO1jA1iN
        IwwyXVvJzjWuGUDY0yBA7NU=
X-Google-Smtp-Source: ABdhPJyyT7Ht/n561kq2TwbGlX8RLpEBLh2u19s32pgmzz9Cxwu6K84tSZsVs4fnrW45GOBlpemYhQ==
X-Received: by 2002:aa7:c7d0:: with SMTP id o16mr5950266eds.75.1628164188385;
        Thu, 05 Aug 2021 04:49:48 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id s3sm1634436ejm.49.2021.08.05.04.49.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 04:49:48 -0700 (PDT)
Date:   Thu, 5 Aug 2021 14:49:46 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] dsa: sja1105: fix reverse dependency
Message-ID: <20210805114946.n46mumz2re7fxdto@skbuf>
References: <20210805110048.1696362-1-arnd@kernel.org>
 <20210805112546.gitosuu7bzogbzyf@skbuf>
 <CAK8P3a0w95+3dBo5OLeCsEi8gjmFqabnSeqeNPQq49=rPeRm=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a0w95+3dBo5OLeCsEi8gjmFqabnSeqeNPQq49=rPeRm=A@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 05, 2021 at 01:39:34PM +0200, Arnd Bergmann wrote:
> Do you have any opinion on whether that 'select' going the other way is still
> relevant?

Yes, of course it is. It also has nothing to do with build dependencies.
With the original DSA design from 2008, an Ethernet switch has separate
drivers for
(a) accessing its registers
(b) manipulating the packets that the switch sends towards a host
    Ethernet controller ("DSA master")

The register access drivers are in drivers/net/dsa/*, the packet
manipulation ("tagging protocol") drivers are in net/dsa/tag_*.c.

[ This is because it was originally thought that a "tagging protocol" is
  completely stateless and you should never need to access a hardware
  register when manipulating a packet. ]

When you enable a driver for a switch, you absolutely want to ping
through it too, so all register access drivers enable the tagging
protocol driver specific to their hardware as well, using 'select'.
This works just fine because tagging protocol drivers generally have no
dependencies, or if they do, the register access driver inherits them too.
So a user does not need to manually enable the tagging protocol driver.
