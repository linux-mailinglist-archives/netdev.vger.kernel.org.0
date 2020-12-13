Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C455B2D8B39
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 04:51:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393878AbgLMDu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 22:50:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393241AbgLMDuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Dec 2020 22:50:19 -0500
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54AF9C0613CF;
        Sat, 12 Dec 2020 19:49:39 -0800 (PST)
Received: by mail-oi1-x243.google.com with SMTP id q205so2382037oig.13;
        Sat, 12 Dec 2020 19:49:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QE8kvUfJGF+/tFxP2a7cjpaKSjXf6+aoJtP3goq60E8=;
        b=FxDybe6qZY0cVdUS6zEjz2Kig7c/aw/0vQ9uFAhhVTX5qCeQ4PldrHo6OcbKoMO6/c
         wgmGI0A+ypYSkoiG2bZp9LM0wXCzGbldKot7nZ0Ohx7xLenhLUAmoEXG0Zp0hthrKOye
         6ehYmXkOpC6r7CdexxjIPU9/PCFn59uKuMo+ps1vLzMf7MczFknbxs0pgoh4MlLg/Crt
         4MEr764TbawspH662uTEU/w2p+9165jNTSRCmNgLdHVsFQBsI42uTktL3edf/bzm90Ho
         xBxXniDsxjOqy1X9M1JWaYroo2tsf2o5ou8HJJzPd2cB/xm3yHmtvVWHJ67BImvJeiDC
         BYxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QE8kvUfJGF+/tFxP2a7cjpaKSjXf6+aoJtP3goq60E8=;
        b=gX3fP4ZYTJmoi0CyzWQ+1KBwSblprh+4YS+WMcw1GtsWvsmYsgi99b6jDYY41SJ/MJ
         Z6yFihFVNadbh4uruGPW5dR8d0gnqlD21qD+JYkCzhyiA7Sze1geXAyLH6WyRhnSG2gD
         fSuB/2HbsxrVHFR0sElGhUogO8R2zxTKBsPibsT/p6fnrGd67XIAAEEDiWGCYOZR4wxo
         Aa0iv1iqVREqhAVClPCe6LYn2cToCc/CdD9PMoycqRx9mB78f3lLaGuDermD0IUtwdyL
         9YxbqFsepndMgWlJacjNZTSpTF63MUA4rovt6kXM8u3x7IeKs9VEC/g8t+tMRce782LZ
         w36w==
X-Gm-Message-State: AOAM530HqS0nWxgQkg2WaXRZkcHwWfpE+Uvur26GMXGuJZYkbld9gcJJ
        awXIf/eAjZihHN13+U2DG78=
X-Google-Smtp-Source: ABdhPJxE7W1vVg6+OwzP+sCKUSQQ2AzZkPGpfAJs2/BtLTtAfvg4hE+4uWm0lq9fTvrdVaFfMpouJA==
X-Received: by 2002:aca:dc85:: with SMTP id t127mr14560421oig.19.1607831378772;
        Sat, 12 Dec 2020 19:49:38 -0800 (PST)
Received: from ?IPv6:2600:1700:dfe0:49f0:5c21:b591:3efd:575e? ([2600:1700:dfe0:49f0:5c21:b591:3efd:575e])
        by smtp.gmail.com with ESMTPSA id i25sm3158888oto.56.2020.12.12.19.49.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Dec 2020 19:49:38 -0800 (PST)
Subject: Re: [PATCH v2 net-next 6/6] net: dsa: ocelot: request DSA to fix up
 lack of address learning on CPU port
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
 <20201213024018.772586-7-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <77d952ad-0aed-8e79-df03-ee6a7f42ef55@gmail.com>
Date:   Sat, 12 Dec 2020 19:49:34 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201213024018.772586-7-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/12/2020 6:40 PM, Vladimir Oltean wrote:
> Given the following setup:
> 
> ip link add br0 type bridge
> ip link set eno0 master br0
> ip link set swp0 master br0
> ip link set swp1 master br0
> ip link set swp2 master br0
> ip link set swp3 master br0
> 
> Currently, packets received on a DSA slave interface (such as swp0)
> which should be routed by the software bridge towards a non-switch port
> (such as eno0) are also flooded towards the other switch ports (swp1,
> swp2, swp3) because the destination is unknown to the hardware switch.
> 
> This patch addresses the issue by monitoring the addresses learnt by the
> software bridge on eno0, and adding/deleting them as static FDB entries
> on the CPU port accordingly.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
