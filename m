Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50BFD3449C7
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 16:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbhCVPwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 11:52:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbhCVPvz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 11:51:55 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DF0AC061756;
        Mon, 22 Mar 2021 08:51:54 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id u5so22112812ejn.8;
        Mon, 22 Mar 2021 08:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=P1zx+gVi7eurX/wcAygqpr2CDWPeDaHcriTmolTK1xU=;
        b=bEVgUuuP2bE/VUwwNcXpOB8inqXkeiuv962axrmdI8HNdb7nsPC8GR9qU1QZnSFHza
         ngF/NRyQYX1fC7j48cA17HVy8OGoo2tP7YfdDw78JRyku6TBzgftBdYmx5AGkZaDLv9/
         /+P4TWV3He3gzQyR7m/IAtJ63lzrNO8Kv7mV/XGcJkmkcXfMMbd5dHmv5RQ9VbbRLhfg
         3Gi2eCSzGLyagAsRVVJ78W+IMsquRwt0fR6tozGR7f6YXg4MPaEi3TqpM8m8jLzArlU0
         LYZTYbQ6w65YmFl9FRTQaC4hzIqIkB7JiACRNlUG5ocM93u6XillPx8D8Lfxv3OCi8kP
         pQQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=P1zx+gVi7eurX/wcAygqpr2CDWPeDaHcriTmolTK1xU=;
        b=EaXeB+Gj/ydh34M7sGPJqvDuRAGJdQulbB/4k/enErOm/RPo4uwu6xTSrNI9s+G3XE
         cUbCk+Pi9xOsgY9jLtbGmMe+aFP33De8poz2cB9WxNQOEVXhuzlLF9uPMgTx/UFT4und
         zfrgsfOlcEgCPSt0ONRQ7xnFx0Gt83Z0O4CUE6ju0EKP7+4ucMWDf4YZZKkEmYLcF4IX
         /QMIH5ZzsB4Zxhs+Ay1zYwPOdMyAHMTdzWoP0ujDvH3mS4EafHYDcbgYJBoEHM08z7U5
         q+igupOXA8TSiEw759quumGAKntIF7DxrYDH8SkR6IWsp7vVapNe2W/poA4LuVaxVwem
         dtUA==
X-Gm-Message-State: AOAM532a2tAdrCPPF83ZSnWTpmzbfG1K/IuUylXoN1dDWCT4RkIGmO/N
        Xd38G0rKm9wWUICtp6LOVfs=
X-Google-Smtp-Source: ABdhPJy/+WldZr1xoAOT8UD3w9feWEH8m3O5OU4AeeHQIclNDI0LngFZ3brViaqYNrubVogfwyu+NQ==
X-Received: by 2002:a17:906:a413:: with SMTP id l19mr396813ejz.421.1616428312836;
        Mon, 22 Mar 2021 08:51:52 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s9sm11054640edd.16.2021.03.22.08.51.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Mar 2021 08:51:52 -0700 (PDT)
Subject: Re: [RFC PATCH v2 net-next 15/16] net: dsa: return -EOPNOTSUPP when
 driver does not implement .port_lag_join
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
 <20210318231829.3892920-16-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <c4e371e9-4b4a-0236-c05d-c9a7b94bfc64@gmail.com>
Date:   Mon, 22 Mar 2021 08:51:45 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210318231829.3892920-16-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/18/2021 4:18 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The DSA core has a layered structure, and even though we end up
> returning 0 (success) to user space when setting a bonding/team upper
> that can't be offloaded, some parts of the framework actually need to
> know that we couldn't offload that.
> 
> For example, if dsa_switch_lag_join returns 0 as it currently does,
> dsa_port_lag_join has no way to tell a successful offload from a
> software fallback, and it will call dsa_port_bridge_join afterwards.
> Then we'll think we're offloading the bridge master of the LAG, when in
> fact we're not even offloading the LAG. In turn, this will make us set
> skb->offload_fwd_mark = true, which is incorrect and the bridge doesn't
> like it.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
