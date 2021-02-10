Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 232A13162A0
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 10:47:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbhBJJqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 04:46:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbhBJJon (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 04:44:43 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74B56C0613D6
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 01:44:03 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id f14so2917550ejc.8
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 01:44:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GVHPNGTldDZ1CaiYnTkoTn8mqIcw28qlZiJxKrQnkfE=;
        b=W21467626Zavi0rzAxxHmV7MI0Wbicf9+CBLCh9FGT1wB1k2UraP2nnOcroaktxDui
         VGxVfWj0Fb1MHnQYiSkOjtFSG1Rr3E5SDTd65kooLJ5VWrIj96RfGrnWG0cW94/tsjVf
         nY/+/T9OVIr8sGpnS2HcXMxwtus2a1CJSH9ffuR1yGgYRSTQA7yvfynKYzpQ9qVjxXNf
         lsXeLP6/G02KlSaeDBDVt1pzzcXgWjAwQtK1TvbF9PP6fgND0imj3wyp66IbjSUxM4vj
         K6of3I4WB57d1CMz4H/uTgMfNlsIjEZybTkCzI4PBx+eU28ieN25k2p4QkXCx8EeZeaT
         U7LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GVHPNGTldDZ1CaiYnTkoTn8mqIcw28qlZiJxKrQnkfE=;
        b=Pd4AilPOgAjzWAn/I5QOOL5lDyXYf1ON8xXOO99gKeSlwKPLMfYyqQ5Lbz7ggHjfGo
         Sdozj090DMxSyWKq9r1Uk9/weEUMg6Cm2OTFdXCCxWIPC4OlAzSXKvmHlyiF7OXe/szi
         8V6crOQLx1dirXEISVrW4UzaBRO5UHpV+bHyyEdjSI15QETEPQyyzK3MhPT1Qs6qYt5a
         aWvWOb5ZA3e8caBsPUdTwUQedUZ5Y/UoMuq9sSBkK4NtZA9RbKA7otUiYIw5fTBT2ulA
         s6Rw014UvRf96oXZEbtrM98FWeg4kY4vJTrffYek9/aJcQ066Q9S9XLFKYbU+oP9C9K4
         LS/A==
X-Gm-Message-State: AOAM5309x3wjyy75fx2BV7ncpPMDyEjE8bK5cJL0z15BwCrIJvLWiytB
        0Qr1+nJr/uFldq7cGc+AXNQ=
X-Google-Smtp-Source: ABdhPJy0V0C6Av1mhxjCU/T9XhiiB1AXb6no3VMlDH0TWoLInAvVZXyompY04chgs/1Cl+FikS5wxQ==
X-Received: by 2002:a17:906:30c4:: with SMTP id b4mr2096252ejb.456.1612950242204;
        Wed, 10 Feb 2021 01:44:02 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id h3sm729914ejl.111.2021.02.10.01.44.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 01:44:01 -0800 (PST)
Date:   Wed, 10 Feb 2021 11:44:00 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 3/4] net: dsa: add support for offloading HSR
Message-ID: <20210210094400.h5xtpcimjidzdl5s@skbuf>
References: <20210210010213.27553-1-george.mccollister@gmail.com>
 <20210210010213.27553-4-george.mccollister@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210210010213.27553-4-george.mccollister@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 09, 2021 at 07:02:12PM -0600, George McCollister wrote:
> Add support for offloading of HSR/PRP (IEC 62439-3) tag insertion
> tag removal, duplicate generation and forwarding on DSA switches.
> 
> Add DSA_NOTIFIER_HSR_JOIN and DSA_NOTIFIER_HSR_LEAVE which trigger calls
> to .port_hsr_join and .port_hsr_leave in the DSA driver for the switch.
> 
> The DSA switch driver should then set netdev feature flags for the
> HSR/PRP operation that it offloads.
>     NETIF_F_HW_HSR_TAG_INS
>     NETIF_F_HW_HSR_TAG_RM
>     NETIF_F_HW_HSR_FWD
>     NETIF_F_HW_HSR_DUP
> 
> Signed-off-by: George McCollister <george.mccollister@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
