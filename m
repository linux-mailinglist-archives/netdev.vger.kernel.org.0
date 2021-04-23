Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 149B2368ABC
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 04:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240048AbhDWBvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 21:51:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230367AbhDWBvl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 21:51:41 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73AAAC061574;
        Thu, 22 Apr 2021 18:51:05 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id f11-20020a17090a638bb02901524d3a3d48so349781pjj.3;
        Thu, 22 Apr 2021 18:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IbrCUvCRE4PwO6vQoYdMCJZi3mAylgPtBh9g8Cx0Ezo=;
        b=AAx81oBKdtsFsUmecJuhYm5gmCEy84Rp+TyqfHbxsq70SZyv7vlsooDw4QMAABGGvh
         +ZsHN0TIZikEw/REku/IHBAJau7MODoyNz/6ZkjzCQvlUX+TFo+/VK2OBrZ59Na4ougu
         Hqq4SAjgr8GjvQYHfIMJdOrDWAWznRMmv8rtwTJCDbnQQzDNx+HVfoDSDTT48Hz/7z8W
         E5kBd7sloMcK7kSvNrrJFBv3Tjwk3GTVOVIE/zp2AL7yyWp9OKpzcnBoRibv1m9RHYll
         pmbNGbZiqpt0lbKkIo0a2VlA/s0e8BOKyqGseRVUbaRA/44hNAVQ0BMyTSyvcQYGVQc7
         7PZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IbrCUvCRE4PwO6vQoYdMCJZi3mAylgPtBh9g8Cx0Ezo=;
        b=rZx/lbLGRWqa+LiaRY4GLY+erVt/l+aIzRn90WI7P9EYtrd1Ulg58XRr2nAdAYTCE9
         lQsLYSprPf+9VHwzzbubFSf6Om8BM+mf/dF+SSGnqqTNm743WqoDEqzvmxrYV57DGiXf
         bT8xVyuWAmvqHapkAvo35C4kv0nK28+2bmsnlbusS3W1JYbBPqQcK58D6/BfOnJ9fvt5
         8EuIdkY5gZ/PpEIQlUAtO54rG6WxJ6Hr+H6SF76/Yi1RrDnP87Estaq6y4yDBRH99Ely
         rlGIPNQpAg+JfNgbFXs56Bo6DgsmkrcTO97C9N/pMx3N6FEidL0LeACIM2Bji2wK6NV0
         hSog==
X-Gm-Message-State: AOAM532/oGwA0guPjK5XUVv0JlCcmG8PVshNt6pQdoFSEZr/lWxmAI9x
        hxtBHzcgsoiiWQMkrBu42IJpoGN8YIc=
X-Google-Smtp-Source: ABdhPJz1q8klpD8dvvxoq8YepB5hFB7ppN4Tym0YEP4iQTM7qdAilm6yIvnJm16Wb1i75fCj+sVCPg==
X-Received: by 2002:a17:90b:e8e:: with SMTP id fv14mr2882853pjb.5.1619142664633;
        Thu, 22 Apr 2021 18:51:04 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f20sm3310202pgb.47.2021.04.22.18.51.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Apr 2021 18:51:04 -0700 (PDT)
Subject: Re: [PATCH 00/14] Multiple improvement to qca8k stability
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210423014741.11858-1-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <e8abff3d-99a8-3ada-9fef-103ce0f7659b@gmail.com>
Date:   Thu, 22 Apr 2021 18:51:02 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210423014741.11858-1-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/22/2021 6:47 PM, Ansuel Smith wrote:
> Currently qca8337 switch are widely used on ipq8064 based router.
> On these particular router it was notice a very unstable switch with
> port not link detected as link with unknown speed, port dropping
> randomly and general unreliability. Lots of testing and comparison
> between this dsa driver and the original qsdk driver showed lack of some
> additional delay and values. A main difference arised from the original
> driver and the dsa one. The original driver didn't use MASTER regs to
> read phy status and the dedicated mdio driver worked correctly. Now that
> the dsa driver actually use these regs, it was found that these special
> read/write operation required mutual exclusion to normal
> qca8k_read/write operation. The add of mutex for these operation fixed
> the random port dropping and now only the actual linked port randomly
> dropped. Adding additional delay for set_page operation and fixing a bug
> in the mdio dedicated driver fixed also this problem. The current driver
> requires also more time to apply vlan switch. All of these changes and
> tweak permit a now very stable and reliable dsa driver and 0 port
> dropping. This series is currently tested by at least 5 user with
> different routers and all reports positive results and no problems.

Since all of these changes are improvements and not really bug fixes,
please target them at the net-next tree:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/networking/netdev-FAQ.rst#n40

also, the subject for your patches should just be:

net: dsa: qca8k:
net: mdio: mdio-ipq8064:

to be consistent with previous submissions in these files.

> 
> Ansuel Smith (14):
>   drivers: net: dsa: qca8k: handle error with set_page
>   drivers: net: dsa: qca8k: tweak internal delay to oem spec
>   drivers: net: mdio: mdio-ip8064: improve busy wait delay
>   drivers: net: dsa: qca8k: apply suggested packet priority
>   drivers: net: dsa: qca8k: add support for qca8327 switch
>   devicetree: net: dsa: qca8k: Document new compatible qca8327
>   drivers: net: dsa: qca8k: limit priority tweak to qca8337 switch
>   drivers: net: dsa: qca8k: add GLOBAL_FC settings needed for qca8327
>   drivers: net: dsa: qca8k: add support for switch rev
>   drivers: net: dsa: qca8k: add support for specific QCA access function
>   drivers: net: dsa: qca8k: apply switch revision fix
>   drivers: net: dsa: qca8k: clear MASTER_EN after phy read/write
>   drivers: net: dsa: qca8k: protect MASTER busy_wait with mdio mutex
>   drivers: net: dsa: qca8k: enlarge mdio delay and timeout
> 
>  .../devicetree/bindings/net/dsa/qca8k.txt     |   1 +
>  drivers/net/dsa/qca8k.c                       | 256 ++++++++++++++++--
>  drivers/net/dsa/qca8k.h                       |  54 +++-
>  drivers/net/mdio/mdio-ipq8064.c               |  36 ++-
>  4 files changed, 304 insertions(+), 43 deletions(-)
> 

-- 
Florian
