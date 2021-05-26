Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2AEF39180C
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 14:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234826AbhEZMz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 08:55:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235017AbhEZMyQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 08:54:16 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 010D1C061760
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 05:51:14 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id b9so2232575ejc.13
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 05:51:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TdyJvF/1jc+NKmdr8O4rCe0mTmfEyfT2nU8q4pDIBq0=;
        b=GIpI3+i2RENMk32p/oyPj5vM/6VbBNnmAd0E/zUqCVrs3136Lu1PguG9oADq77wctO
         W5VGZRYzAeHHi6mXL0sUMA71BEG2F2ykDhXnJ4XWB2MoPlpC2jiNOjBoVcEURBego4Fq
         Js4gplr/gaKTX7arWvR6uwVlasGafhBNuB64g028o6O+leU00lUPsRCtSaojqBSExeqG
         7CLAivcwa0818fHF+wxowbV7IpVt7IwdMRksBya+zdDb5HC6OusZXjLTFpmwbs4sUaEN
         Nbfjc8KGdb8UIZFu8iVv0iDajuvX3ZPGHDn7hWZ99Ito4lKg4P10EyE+CQuM0M4THLmu
         gaXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TdyJvF/1jc+NKmdr8O4rCe0mTmfEyfT2nU8q4pDIBq0=;
        b=lsAQUhug0C+T8t+eLVdUl8bIDRmecGtn/YLLeAQ8i3zxhAxL5mBvjv1Gv6rKCoXE2g
         M9foRUI94ugYBZ09yfDEM23mwxWPRIHCXRNFy6+lOVd7w0F9niUW3L0SMl2zXsJuPp2N
         MfWuAzoidmZtNpRTaN21/Q1tM9xRw6whiszrt7EE8ZwPTdOqK3azBoTTXRgBJrn2tqAN
         vkWeaUgV07muqhmQgZlNrStRrakT+TBZV1sqr/60PpMWWlKvDqLSyA+57hEFR9CiPPvt
         dRizymnIIUPyE7Y81Pqbl1Jg1sqgbP6xV3XUjiMW4Jbl+DoY3Byhk0zqz0u3VSCmLpb4
         drSQ==
X-Gm-Message-State: AOAM532iYDzXEHfrN2wCUFAz6oJCCUuIBFJkyD+1BrH5XcDuA81TLnjR
        +7gG8lsgPhQsYZ2YaoWb5lA=
X-Google-Smtp-Source: ABdhPJxY1aLj4vfrPuPlMdzWv5hnANOKywY4qp5DzLuM6ERCZ+Q/5RT1AXgo2/ef4rm2bBtbRjXWCg==
X-Received: by 2002:a17:906:3f86:: with SMTP id b6mr33794194ejj.530.1622033472581;
        Wed, 26 May 2021 05:51:12 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id h9sm12406569edt.18.2021.05.26.05.51.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 05:51:12 -0700 (PDT)
Date:   Wed, 26 May 2021 15:51:10 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next 00/13] Add NXP SJA1110 support to the sja1105
 DSA driver
Message-ID: <20210526125110.legnhxrlq4r6hsym@skbuf>
References: <20210524232214.1378937-1-olteanv@gmail.com>
 <YKxbA86Ci0Ll7RjE@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YKxbA86Ci0Ll7RjE@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 25, 2021 at 04:03:47AM +0200, Andrew Lunn wrote:
> > There are some integrated NXP PHYs (100base-T1 and 100base-TX). Their
> > initialization is handled by their own PHY drivers, the switch is only
> > concerned with enabling register accesses to them, by registering two
> > MDIO buses.
> > 
> > PHY interrupts might be possible, however I believe that the board I am
> > working on does not have them wired, which makes things a bit more
> > difficult to test.
> 
> In general, internal PHYs have an internal interrupt controller, often
> in the switch register space. There then might be one interrupt from
> the switch to the host. It could be this one interrupt is missing on
> your board. But this is also quite common with mv88e6xxx boards. So i
> added code to poll the interrupt bit, i think 10 times per
> second. Polling one bit 10 times a second is more efficient than
> having phylib poll each PHY every second when it needs to read a
> number of registers. And the latency is better.

That is a good suggestion and probably what I'll end up doing, but not
in this patch series since it is already on the heavy side, and getting
access to the interrupt status registers isn't easy-peasy.
