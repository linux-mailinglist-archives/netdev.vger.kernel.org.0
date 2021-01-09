Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6E232EFCDA
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 02:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726447AbhAIBtS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 20:49:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725817AbhAIBtR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 20:49:17 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EFDDC061573
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 17:48:37 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id j1so6621191pld.3
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 17:48:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7p2sw27lGTp4F9pS1WI2ckYqNicAJkUNd6I1iAAq2rE=;
        b=kMbatxPzTGeV1ikTScrlaB7tPEoOj+Y2CbVZg1awYcVJRtwx8KZKJTBbl0nAB5OYUB
         JoKCXOoG9bD9bas+K87g2KH2QDVp9DssFwJ7u/vmZZDySxEJZTEwozHFseWEtz79H0pw
         PL3OQE1y5Ku4HpMTj39/X0NnG0R5GTxW+xYal4fgwQjOXfg1Y3DtfHHohxd4X20ywK+c
         x0f4HMpl7r8pmmtYUm5Tm13FqILTRsaZMDBrsRhb/QA08wpyvTnoSSbycFm2leaZ+n/G
         a6qwn9ixJWlPiNq+VsluVINEFFfl0X4uGtSA2bkTV2pHkHBw8qwTRpVJCqaVprpsHKzd
         tWlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7p2sw27lGTp4F9pS1WI2ckYqNicAJkUNd6I1iAAq2rE=;
        b=KHs4Ghyr9pUDxBF6KsBUG9P7bC9jNxNf1blQhtTOSIQc4Fh0PgIQ74Q5sm1uq35fl0
         KIle89C9FzKvLeJsQq9AvVld/KbodU4GPoxvQqk1TcdndR8Aabk4oXz1IpCx5H8HJt0I
         AFsgny4FBQ6nBzv02llEUzPpUzc23QyWAic+mTU0sAKYSm4KOsklqAe8qKl2gk/uGX8p
         tAPgPySqHiZZm6KuQbQ+CKkajIqnjwoLMXiJEj03ssXNJJZj+e4wjQcspdIS8+Iy2df3
         xmPyqE3iY7FNglnX/dp1FYfP2MLL9H1TulFi7wjV3PBcJgUigSJFTrtA+wN/gX7VMreV
         IvqQ==
X-Gm-Message-State: AOAM532XuYTwxqO08ihqIMmGFgh4ZHs2J7/b9udwIW8O1vCDE91n9WW1
        HBPWiNzfgfPyTFzfJZOudL4=
X-Google-Smtp-Source: ABdhPJy6F05fmfkRq/XJtIVBlnH1Tg57oY4s1SAk4sgwZ1X6ZkUERYE9jZUfQ8+4lk1WSM/DVmKvwA==
X-Received: by 2002:a17:902:8306:b029:da:d7f0:9e16 with SMTP id bd6-20020a1709028306b02900dad7f09e16mr6660670plb.53.1610156917171;
        Fri, 08 Jan 2021 17:48:37 -0800 (PST)
Received: from [10.230.29.29] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 77sm10314678pfv.16.2021.01.08.17.48.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Jan 2021 17:48:36 -0800 (PST)
Subject: Re: [PATCH v4 net-next 10/11] mlxsw: spectrum_switchdev: remove
 transactional logic for VLAN objects
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Petr Machata <petrm@nvidia.com>
References: <20210109000156.1246735-1-olteanv@gmail.com>
 <20210109000156.1246735-11-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <24c6ef2f-36a6-8531-c7aa-d1a654f198af@gmail.com>
Date:   Fri, 8 Jan 2021 17:48:32 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210109000156.1246735-11-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/8/2021 4:01 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> As of commit 457e20d65924 ("mlxsw: spectrum_switchdev: Avoid returning
> errors in commit phase"), the mlxsw driver performs the VLAN object
> offloading during the prepare phase. So conversion just seems to be a
> matter of removing the code that was running in the commit phase.
> 
> Ido Schimmel explains that the reason why mlxsw_sp_span_respin is called
> unconditionally is because the bridge driver will ignore -EOPNOTSUPP and
> actually add the VLAN on the bridge device - see commit 9c86ce2c1ae3
> ("net: bridge: Notify about bridge VLANs") and commit ea4721751977
> ("mlxsw: spectrum_switchdev: Ignore bridge VLAN events"). Since the VLAN
> was successfully added on the bridge device, mlxsw_sp_span_respin_work()
> should be able to resolve the egress port for a packet that is mirrored
> to a gre tap and passes through the bridge device. Therefore keep the
> logic as it is.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Acked-by: Jiri Pirko <jiri@nvidia.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
