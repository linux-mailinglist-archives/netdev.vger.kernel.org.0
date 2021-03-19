Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAFAA34288A
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 23:12:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbhCSWMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 18:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231144AbhCSWME (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 18:12:04 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79A76C06175F;
        Fri, 19 Mar 2021 15:12:04 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id v23so3572770ple.9;
        Fri, 19 Mar 2021 15:12:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Sgkq5WwYPyoO/k0xiFkUsYOm/YM4fkCjsxZ33PIGI9o=;
        b=hd7Uco0miADpPCwgqYrjZWwByH/Uk8yEzeVj5kUOaIOEFR5942OUHfvltxu4R7zLKv
         Kk4QSuShS4n2CrAWIYQakZhMcrQ9q1KAlfTo/d/1wTESzQM3OMNTQ6+JfMlYJmXpHVFo
         7tuR2MqnZjTuIBm+fkeKwV3OpoZlQVCQdvcuTJoPyL+eEJnIkMMcgbLMqPTL7i/cof87
         ioAM/xwc8WmJj10gEmcIhlYeiwMkVfXnb/35aEkb01J+YYP01SrBVfNzO3uU7Tny3hFl
         CcBymMcdQpgaYbrQj7q8bHm5P/dVk60MwHep2x7+U/iz/SDyeLJLyGFSTeKwr0MJlZNS
         FyAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Sgkq5WwYPyoO/k0xiFkUsYOm/YM4fkCjsxZ33PIGI9o=;
        b=Ck7GM7voFIIAdRec7RcmwxZQ5sLdPvT4fmVuM+oQgJPrxTTgyKz32fjrProu3CnaUU
         pQxv5XIDjkqs7yR+PPYPOznVIvrmTZmGwokVsH7MkwEHlhkRi99Eyv+99De0240YMiiq
         AAB+VaqrY+3F6tHX7D//0Lg+t+hN3UlHaxRZN3lToPHn+NiBSr3YpQDyvQKyDZ2VCQSB
         658nIUfkYwBua7uh61RffgFjLScTy3arAUFdn5wxE6m1DXHU0o3uju/SaqHcnuQWMX8M
         qFFJQO5MqrZoKqliosA4E/7uI+Gxfn7V1NAammC7cu+r2xUiVzUJfwTMIq33J2sXejaP
         n2mA==
X-Gm-Message-State: AOAM5315ohJ4pdnOx9dGCWgMKCFBOp9NGpWFDPGebbBAymSj89DmxrbZ
        N9gOE9hjSg8rNxa9hGX5NwY=
X-Google-Smtp-Source: ABdhPJwaaqT4J0hsDcuyhLfN35bvAx3/o0qdd3ZCoCdyWfa+a/YHe5DCM01ihyvzaF5kzWlioL39vg==
X-Received: by 2002:a17:90a:8c08:: with SMTP id a8mr636932pjo.136.1616191924080;
        Fri, 19 Mar 2021 15:12:04 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g7sm5624480pgb.10.2021.03.19.15.12.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Mar 2021 15:12:03 -0700 (PDT)
Subject: Re: [RFC PATCH v2 net-next 06/16] net: dsa: sync multicast router
 state when joining the bridge
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20210318231829.3892920-1-olteanv@gmail.com>
 <20210318231829.3892920-7-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <428e990c-de94-f4e3-c32b-e39df381ab60@gmail.com>
Date:   Fri, 19 Mar 2021 15:12:00 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210318231829.3892920-7-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/18/2021 4:18 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Make sure that the multicast router setting of the bridge is picked up
> correctly by DSA when joining, regardless of whether there are
> sandwiched interfaces or not. The SWITCHDEV_ATTR_ID_BRIDGE_MROUTER port
> attribute is only emitted from br_mc_router_state_change.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
