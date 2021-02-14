Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7B4D31AE9F
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 02:08:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbhBNBHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 20:07:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbhBNBHH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 20:07:07 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3710C061574
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 17:06:26 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id i20so2943681otl.7
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 17:06:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DRXHRCkxzERrs38qCs7uphlsqeR6aJRlRvcvPhsKWsg=;
        b=DIL0j5eRFMqCUzlhrs/3pdGwGldHRCVjROmb9DjkIYjPdSyL0uWk565I6Fu6YnTpKX
         C89M3yhTojen17owMBTzy927b2v0SaM9zsD9pxEhY55FJ4j59Ji0vX630c+8ehP7CbMV
         CRKUUZ469huW1kvow7RHfVQlkuk7h6akNQ5MzrZmKTCqcha2/PZr1WNPXP1cXo4IDgKC
         xN6k73XWanlh8mKpmyUcf4R7oMtKmyliv1gtvdQavwJzBNIEaT/l235JSDlwq+lPlQTM
         0vZfMttnRnWhpTEAu1xjs/PizfbJq+IoXjLIr7uy4GD6DkSKkoVpLyDHZVg8VoBtBvoD
         NBew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DRXHRCkxzERrs38qCs7uphlsqeR6aJRlRvcvPhsKWsg=;
        b=IIbcETGXKlrWVqlUcFF5KN7I01zltBuPa4ghVKGwe+WWVAOP+E6SeuwgOFH8Taqmci
         qMSQoogvP+oTrd0/3llELEJUdUxo7ucsphcEe3XZejYWfB9bDMRkPHpFEumPcB/uGG2D
         xjK9Nk4nVxiAC4Qw9ggS2LBaOrS8lWTWyoBiwbcZfBSkl+tZP6E5i2loCO02uhDZ+jRV
         reUyFLyG4C8hnCl5+PAbsfp+4G+GjMyu+u35OWnnWlqzHkvfsEZ39U/8YqrN2Nccikrw
         hbAR8iTdkq2+zSPAMdPIpPRqeVuV/E4j2WFXbU8iU1HfjvJbboHuIVbLi+ZQzWAM/BvH
         1VyA==
X-Gm-Message-State: AOAM530Zr1WlBxQSchRiaUQax5fbewwYMD00vw98UtgPqxzMti/aQnoG
        1npDDumvCu+SduYPYo380Ik=
X-Google-Smtp-Source: ABdhPJxGHQ8vVd1nFCGLXtb3IJGaKJLmN7BToncgiXI4uHuU0fueUwDeQsf+b5PndvHsQYQlaDRPXQ==
X-Received: by 2002:a9d:75d0:: with SMTP id c16mr7163463otl.261.1613264786231;
        Sat, 13 Feb 2021 17:06:26 -0800 (PST)
Received: from ?IPv6:2600:1700:dfe0:49f0:e93c:cbea:e191:f62a? ([2600:1700:dfe0:49f0:e93c:cbea:e191:f62a])
        by smtp.gmail.com with ESMTPSA id h24sm2586222otl.50.2021.02.13.17.06.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Feb 2021 17:06:25 -0800 (PST)
Subject: Re: [PATCH net-next 2/5] net: bridge: propagate extack through
 store_bridge_parm
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Ido Schimmel <idosch@idosch.org>
References: <20210213204319.1226170-1-olteanv@gmail.com>
 <20210213204319.1226170-3-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <feaa13c8-4dc8-33c7-9b53-2f67ddfba88e@gmail.com>
Date:   Sat, 13 Feb 2021 17:06:22 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210213204319.1226170-3-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/13/2021 12:43, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The bridge sysfs interface stores parameters for the STP, VLAN,
> multicast etc subsystems using a predefined function prototype.
> Sometimes the underlying function being called supports a netlink
> extended ack message, and we ignore it.
> 
> Let's expand the store_bridge_parm function prototype to include the
> extack, and just print it to console, but at least propagate it where
> applicable. Where not applicable, create a shim function in the
> br_sysfs_br.c file that discards the extra function argument.
> 
> This patch allows us to propagate the extack argument to
> br_vlan_set_default_pvid, br_vlan_set_proto and br_vlan_filter_toggle,
> and from there, further up in br_changelink from br_netlink.c.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
