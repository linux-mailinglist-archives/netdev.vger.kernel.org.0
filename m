Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 535953CCC6D
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 04:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234097AbhGSC5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 22:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233720AbhGSC5N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Jul 2021 22:57:13 -0400
Received: from mail-oo1-xc36.google.com (mail-oo1-xc36.google.com [IPv6:2607:f8b0:4864:20::c36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0E9DC061762
        for <netdev@vger.kernel.org>; Sun, 18 Jul 2021 19:54:13 -0700 (PDT)
Received: by mail-oo1-xc36.google.com with SMTP id t46-20020a4a96f10000b02902618ad2ea55so4100501ooi.4
        for <netdev@vger.kernel.org>; Sun, 18 Jul 2021 19:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aoEErOZcjbmHWVyzLSCzQUjB6elXDaTEJvEABHsrA1M=;
        b=bzvxh2eiwKELuviYlOC1eGgVdhFqWCsqPbiUXmpkLc0D1ZacxIwLvPrxY8Fp7R5m5N
         ttgFG+u4izjrVKW92j7JDSkyzhUS88RHmNMS5mSCDWaiDcIaZMlrgNaO90mxBxBWEe58
         YjI56tfnQwEjPpweuWe1b1228SZXkGJPkCEqX1VD3P1H7b0Dtxy4rSNq6qdyEVfVuM9I
         bqlyGVb+S/8bVlXftiLUAbT1agg7toIjPSz70zEZFndGxumwEDS4gceMXXdiDWGY6MXD
         MX3fDo+LcPHlh+Q0Tt3tkJVIsq80h+umUkUg/If5lGkQM+e1iStBT8DTQMS564KoW5+6
         3v2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aoEErOZcjbmHWVyzLSCzQUjB6elXDaTEJvEABHsrA1M=;
        b=rl0KzOOMxp6sMdFPDi9fd333akdV6SHho5Hqqhaf7DjQU2U/ir2Kvx6lxindboh6rP
         uDXNYxHQFg7b2onJCUdFN2se5gH+Rx7z6wXYPtv737lTpM/0Vp5fEsFG0At77nobVQpk
         UHIpWfautxJuhOYV3WBkOVl6yWfUrrXbpT7ACxp41+W3AEU7rePEYZj4alrJpNA8btqT
         5VoOnwuODsNdim9NKbMzFuy51Ttv+LVEyOTz54PdEK1wqnaq5mt1545hdQbWAhWSo5ol
         hN4mIX6FHHQzVvwSWaZksbogCt2hoSijGVgjmRk58A020KFWNM10pt+1+NndUQDuetCG
         6oNA==
X-Gm-Message-State: AOAM5310A+MClRkCfLgqE/xTu2+atsJtoJiVYRxcGvgVxzJgZ3jSfJlQ
        xn4+8LNtRjQhjo2xwoBfyoY=
X-Google-Smtp-Source: ABdhPJwgvui7h/jXyqlyejb8ID/mJ4ZU1zrO0ee9y2jIjkyueouM+NIB6UK+0y9vdrV/QSKEWIQfRQ==
X-Received: by 2002:a4a:5dc6:: with SMTP id w189mr16122485ooa.1.1626663252697;
        Sun, 18 Jul 2021 19:54:12 -0700 (PDT)
Received: from ?IPv6:2600:1700:dfe0:49f0:49e1:751f:b992:b4f3? ([2600:1700:dfe0:49f0:49e1:751f:b992:b4f3])
        by smtp.gmail.com with ESMTPSA id c64sm3650155oif.30.2021.07.18.19.54.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Jul 2021 19:54:12 -0700 (PDT)
Subject: Re: [PATCH v4 net-next 12/15] net: dsa: track the number of switches
 in a tree
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>
References: <20210718214434.3938850-1-vladimir.oltean@nxp.com>
 <20210718214434.3938850-13-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <42519a8c-65e8-34c6-6513-21e115b08005@gmail.com>
Date:   Sun, 18 Jul 2021 19:54:11 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210718214434.3938850-13-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/18/2021 2:44 PM, Vladimir Oltean wrote:
> In preparation of supporting data plane forwarding on behalf of a
> software bridge, some drivers might need to view bridges as virtual
> switches behind the CPU port in a cross-chip topology.
> 
> Give them some help and let them know how many physical switches there
> are in the tree, so that they can count the virtual switches starting
> from that number on.
> 
> Note that the first dsa_switch_ops method where this information is
> reliably available is .setup(). This is because of how DSA works:
> in a tree with 3 switches, each calling dsa_register_switch(), the first
> 2 will advance until dsa_tree_setup() -> dsa_tree_setup_routing_table()
> and exit with error code 0 because the topology is not complete. Since
> probing is parallel at this point, one switch does not know about the
> existence of the other. Then the third switch comes, and for it,
> dsa_tree_setup_routing_table() returns complete = true. This switch goes
> ahead and calls dsa_tree_setup_switches() for everybody else, calling
> their .setup() methods too. This acts as the synchronization point.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
