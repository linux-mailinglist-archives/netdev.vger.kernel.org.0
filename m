Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA572D8B2B
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 04:31:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391120AbgLMDaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 22:30:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725976AbgLMDaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Dec 2020 22:30:18 -0500
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EE7EC0613CF;
        Sat, 12 Dec 2020 19:29:38 -0800 (PST)
Received: by mail-ot1-x341.google.com with SMTP id y24so12330532otk.3;
        Sat, 12 Dec 2020 19:29:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5A8LBG/0winkhIB+qQknveTCUeenAgAerHH1NCQ2T74=;
        b=WqOZJMT5w2wzqQecct+baorFdZNCF95QdWg2USqadi60RgTMKQKmqz9oa827zluMxC
         dFROYainZKQ1g9Frxqi9Y3CU6kv687nGJ8H2v2/u7lZoGO/7Ve4FqordX6MU34srPqwJ
         UpWGnOJp/UopqTiIWaikBsozE1KTBAbNRPPffEAnfMPfFYWy+w5HjKUOHW/NGIiAnXsS
         4jbmSIf5SJg7bYOWos4A/FpkgfGzuNhy8SzoIyruJ6/ReMlKVI9Y89mFqYLpDAJPu85g
         Juhn02DKmGW1GewGDujDulfjEqR3Ijze5uXMth1bi6t5CPxee7RX7n2Br3wWA8+Uko8r
         gZvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5A8LBG/0winkhIB+qQknveTCUeenAgAerHH1NCQ2T74=;
        b=nKOALnthGzL/L4NgLANngyysjQc8jMyRbvmZC8a/MJh/rg44hg9nxUidsAswrS8MJR
         68TOZb/+SXcMqhbv1UANw0bv3fHuAziyGHb361ss5CBxpq+sjd1VPeGxU6uQ2ih6WmhN
         fIqiK2bsLGNRiTdTg06TGV1lOkFZocgiCvj08bs4TCixfddx26Vj1L7A2husay07Z3TN
         MffZahJo95Zt6e1IIxMe0yrGRkV6kK0lbQ7yJj47vwfSuz3IuEIpJZr+0kuzwHAMt12b
         o4RvQ2L0opz1Duwka/LQaKGvGBEpoesO/PxUEEMwZ34+Rm8wH+tmr0k1u8Jo+nktNIGd
         kSIQ==
X-Gm-Message-State: AOAM530NERG9W7iJVmlUA/RBF5LfYC3YGK4olxKOIu/aLVdGX+JZj58R
        9CEqpAPpXv2O6DKW9Po96lQ=
X-Google-Smtp-Source: ABdhPJzpuqRAa5HPy60eIDvyda21+S66FjuZ3hCtTRg5D7kSMBRO1bIHm9LamVpLyzNqO0ALKYPrTg==
X-Received: by 2002:a05:6830:4036:: with SMTP id i22mr14956285ots.127.1607830177810;
        Sat, 12 Dec 2020 19:29:37 -0800 (PST)
Received: from ?IPv6:2600:1700:dfe0:49f0:5c21:b591:3efd:575e? ([2600:1700:dfe0:49f0:5c21:b591:3efd:575e])
        by smtp.gmail.com with ESMTPSA id f18sm3140580otf.55.2020.12.12.19.29.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Dec 2020 19:29:37 -0800 (PST)
Subject: Re: [PATCH v2 net-next 4/6] net: dsa: exit early in
 dsa_slave_switchdev_event if we can't program the FDB
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Marek Behun <marek.behun@nic.cz>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
References: <20201213024018.772586-1-vladimir.oltean@nxp.com>
 <20201213024018.772586-5-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <972b7427-0efe-118b-5e11-88ea10c2d217@gmail.com>
Date:   Sat, 12 Dec 2020 19:29:34 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201213024018.772586-5-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/12/2020 6:40 PM, Vladimir Oltean wrote:
> Right now, the following would happen for a switch driver that does not
> implement .port_fdb_add or .port_fdb_del.
> 
> dsa_slave_switchdev_event returns NOTIFY_OK and schedules:
> -> dsa_slave_switchdev_event_work
>    -> dsa_port_fdb_add
>       -> dsa_port_notify(DSA_NOTIFIER_FDB_ADD)
>          -> dsa_switch_fdb_add
>             -> if (!ds->ops->port_fdb_add) return -EOPNOTSUPP;
>    -> an error is printed with dev_dbg, and
>       dsa_fdb_offload_notify(switchdev_work) is not called.
> 
> We can avoid scheduling the worker for nothing and say NOTIFY_OK.

Not sure if this comment is intended to describe what is being added,
only if you have to respin, should this be NOTIFY_DONE?

> Because we don't call dsa_fdb_offload_notify, the static FDB entry will
> remain just in the software bridge.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
