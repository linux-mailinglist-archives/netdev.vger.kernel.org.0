Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75E972EFCEA
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 02:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbhAIByo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 20:54:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725916AbhAIByo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 20:54:44 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D78AC061573
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 17:54:04 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id x126so7381499pfc.7
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 17:54:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dx4BOjBslD2NuvQxaY0KECGweFkuIWQqdcf7erqSIQs=;
        b=FHmgA0QuodbJHxF+qMiBE9hm9xvZKljqxblHdwf/0bC6mwqIqqozJUbhf472rFTgv1
         epuYAk4OHx9YHMiSSwtxWzE5bTogy49kcZWwynWJrcBCRuVL5MOw+x/5ejgbUBciMOHC
         wPAGIWqPRg3vgczpikqU0YKqo5F7LSjiRi5esqYXvyXNjkpzkOqpeqW+Xh1n9BnxZE2Y
         ats1J+5tw4VS4w59OpuKo19kn/3uglMBUJUcWo6DOWYdWl+w6eg8ivI1M3ycpEaT5X9B
         Mbv7hf16YVkLNJjWji2zh9JfiHj3yHWrTgWcsy5Q/y4v4vSXAR+Zixum18aOK5swv++q
         ZfMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dx4BOjBslD2NuvQxaY0KECGweFkuIWQqdcf7erqSIQs=;
        b=dSTSDBDk57jaYh97h8h9A6/To4HBtKkNvhy3XtFNUSYpOxiHkM46uKjqMRgGVlR7MI
         ZmEY/vZgGGJQUVNpgdYC2H2gS8bFY7Y+2lP3wygxs6fRLJT5nMCbPCaaEjOeDufsgNOz
         DHiE3G8UdL4Lq+NUZ9COuHBS8okOJNkOuTPrAFmRz7db8Xc+3q42l/aWxtZOq4nyvVnk
         MzwIAoTKz7/kxndLUukj+K0Pyx8q6eoeqvUQRkb3r/irYZ96vvXOSQUMHKpyWr6TaH28
         ewuF6h0H9uEoOqdA1Ohf0E5d2wyoIDwG78YgWSH975WzG4qx2VSL3rd3VIyBdIE0mqcm
         YaXQ==
X-Gm-Message-State: AOAM532XmVefmoestcBKxsnJU77DQVgjqjunhrZhfVRMZx4GhrELya+z
        agEnfxsZ6PrTM5W20Ijvsew=
X-Google-Smtp-Source: ABdhPJxjqE1vfvDPNRUOvktuU+L2yJ8SbB8kDvJmZf2d01v7dVWQLHE7CqbZ9Qbmj4Wn0gWjs00gzQ==
X-Received: by 2002:aa7:93cf:0:b029:19d:e287:b02b with SMTP id y15-20020aa793cf0000b029019de287b02bmr6475362pff.66.1610157243597;
        Fri, 08 Jan 2021 17:54:03 -0800 (PST)
Received: from [10.230.29.29] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o193sm10507393pfg.27.2021.01.08.17.53.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Jan 2021 17:54:02 -0800 (PST)
Subject: Re: [PATCH v4 net-next 05/11] net: switchdev: remove the transaction
 structure from port attributes
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
 <20210109000156.1246735-6-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <a8943b5a-63d4-e4d4-a08c-f4b2fd955ffc@gmail.com>
Date:   Fri, 8 Jan 2021 17:53:58 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210109000156.1246735-6-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/8/2021 4:01 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Since the introduction of the switchdev API, port attributes were
> transmitted to drivers for offloading using a two-step transactional
> model, with a prepare phase that was supposed to catch all errors, and a
> commit phase that was supposed to never fail.
> 
> Some classes of failures can never be avoided, like hardware access, or
> memory allocation. In the latter case, merely attempting to move the
> memory allocation to the preparation phase makes it impossible to avoid
> memory leaks, since commit 91cf8eceffc1 ("switchdev: Remove unused
> transaction item queue") which has removed the unused mechanism of
> passing on the allocated memory between one phase and another.
> 
> It is time we admit that separating the preparation from the commit
> phase is something that is best left for the driver to decide, and not
> something that should be baked into the API, especially since there are
> no switchdev callers that depend on this.
> 
> This patch removes the struct switchdev_trans member from switchdev port
> attribute notifier structures, and converts drivers to not look at this
> member.
> 
> In part, this patch contains a revert of my previous commit 2e554a7a5d8a
> ("net: dsa: propagate switchdev vlan_filtering prepare phase to
> drivers").
> 
> For the most part, the conversion was trivial except for:
> - Rocker's world implementation based on Broadcom OF-DPA had an odd
>   implementation of ofdpa_port_attr_bridge_flags_set. The conversion was
>   done mechanically, by pasting the implementation twice, then only
>   keeping the code that would get executed during prepare phase on top,
>   then only keeping the code that gets executed during the commit phase
>   on bottom, then simplifying the resulting code until this was obtained.
> - DSA's offloading of STP state, bridge flags, VLAN filtering and
>   multicast router could be converted right away. But the ageing time
>   could not, so a shim was introduced and this was left for a further
>   commit.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Acked-by: Jiri Pirko <jiri@nvidia.com>
> Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de> # hellcreek
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org> # RTL8366RB
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
