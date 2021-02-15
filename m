Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2CB531BA33
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 14:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230302AbhBONUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 08:20:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbhBONUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 08:20:16 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A030EC061756
        for <netdev@vger.kernel.org>; Mon, 15 Feb 2021 05:19:34 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id h10so3276330edl.6
        for <netdev@vger.kernel.org>; Mon, 15 Feb 2021 05:19:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MUzYkPBkTVBlPnt13V38jO4yFXxrGKCxG7F8rcnFDX8=;
        b=kjzD9Nb6qKMhFHo2SNnt/ZGnN3yrNB3UXM8ApK9hCAUqY1tUiyLdxUCs5XVakn2q58
         a++canqbs7k0cpDkCEQDVHNBelshi5tx6BvlIKy7Ga9XRC5tvJZvoDCoaNGaVMsuA+uP
         SWR0jreIn7jLwr/3PdOQU/sKLPvfa6yoV1FRdXyPWafyMUlEI1VFXVOv+MZq9Gr9yUJh
         tACQNlVkyXl7f22OehYWU/GNvE0Vxjhee96tUx8lmQac2PR+tT5QCf1SN7+JC3CLRlcV
         vPoJgeuR9AGwQYiZZibPHcLttCyFPw9qLDJj/Gf5jFUDti9JIxfBfhGMdt7YySYi8U5b
         31Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MUzYkPBkTVBlPnt13V38jO4yFXxrGKCxG7F8rcnFDX8=;
        b=JG/DGB/WracoAJWadvD71C1RmY7nz3phs3zc3e0RXzcXEKp5dAdikwClKem5I6DKq/
         i/81HDOmEswhJYI/sN3KdzXUizDZU0eFV0zgWsiunR1HpF5Ja4Jo/Ubv17DJFF2gvnEf
         OdzGTT+f80u1IXk9SnWT9F6szpuM1o0A1NWB+dazNdq+UCcwxgh2B33MsdM5I6amK23g
         9fHd5Qrmgzx2h2gXQvWHLWiON+hbB4g6A2o5t5ZbPZwj5sZh2LzH95qGzGZnBrAhaEnQ
         b21vkYiWScN0htKFCjCjdS1I6QRoiiTYDchqWzkpHUVOo8XchuYsbA7/I2I64dJ8jAdB
         Sxcw==
X-Gm-Message-State: AOAM530TFg5b7SFG9bsNfnjjQhIPbM+WGDX855Kw6cIhrr/ngiV4RNCT
        INA4pvNmgjqQRXX4r1GOkXU=
X-Google-Smtp-Source: ABdhPJys6tyEp7Tl9TgpAYlRncnm6fRSGKbRybeVzpnB44XIf7cg4RwKYeOfVgWferlEFu2mCs+p5A==
X-Received: by 2002:a50:d307:: with SMTP id g7mr15617782edh.204.1613395173413;
        Mon, 15 Feb 2021 05:19:33 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id kv24sm10263134ejc.117.2021.02.15.05.19.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Feb 2021 05:19:33 -0800 (PST)
Date:   Mon, 15 Feb 2021 15:19:31 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     kbuild@lists.01.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        lkp@intel.com, kbuild-all@lists.01.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 09/12] net: dsa: tag_ocelot: create separate
 tagger for Seville
Message-ID: <20210215131931.4nibzc53doqiignb@skbuf>
References: <20210213001412.4154051-10-olteanv@gmail.com>
 <20210215130003.GL2087@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210215130003.GL2087@kadam>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dan,

On Mon, Feb 15, 2021 at 04:00:04PM +0300, Dan Carpenter wrote:
> db->index is less than db->num_ports which 32 or less but sometimes it
> comes from the device tree so who knows.

The destination port mask is copied into a 12-bit field of the packet,
starting at bit offset 67 and ending at 56:

static inline void ocelot_ifh_set_dest(void *injection, u64 dest)
{
	packing(injection, &dest, 67, 56, OCELOT_TAG_LEN, PACK, 0);
}

So this DSA tagging protocol supports at most 12 bits, which is clearly
less than 32. Attempting to send to a port number > 12 will cause the
packing() call to truncate way before there will be 32-bit truncation
due to type promotion of the BIT(port) argument towards u64.

> The ocelot_ifh_set_dest() function takes a u64 though and that
> suggests that BIT() should be changed to BIT_ULL().

I understand that you want to silence the warning, which fundamentally
comes from the packing() API which works with u64 values and nothing of
a smaller size. So I can send a patch which replaces BIT(port) with
BIT_ULL(port), even if in practice both are equally fine.
