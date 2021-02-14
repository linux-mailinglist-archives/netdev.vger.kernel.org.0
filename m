Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3E5A31AEA2
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 02:17:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbhBNBRH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 20:17:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbhBNBRF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 20:17:05 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06AFDC061574
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 17:16:24 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id c16so2992870otp.0
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 17:16:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kTlS/CgCIhXeIqHYUcbEsUoSxsuxVyw4cxgMe68nPaE=;
        b=RJzDJD/LN+AHmz9TaQ7iHZZjbu0tBYBmpEoMtCLuWWtAmgo8iAdkBZHk/wH5xvqwPI
         idzFkFq++7QSozQVBvgtQ2W5cKg+nEfGuHv1UDmCy2FUSI9TLPcBFoWn47G2D0Hd/19W
         t/2A6blVuoYI+o6vweLW32jdZ9D6xLgsguvITvXgFikML2i49y/0AMOukDlLAprpH15r
         IlO6ch5a+ciNS9NAxFkAeYRM/Oa6ru57QfGnqtkZQt2YHDEzhAr77zDc1ODwEXgwd90f
         OCPqcnzo1ADAC1hyerm3B+fvn3NVlfTIG3S4eXRmgrK8H5tBEOtf6XvmRkzH8IXK65d/
         dweQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kTlS/CgCIhXeIqHYUcbEsUoSxsuxVyw4cxgMe68nPaE=;
        b=VCLStBbI0hCwfzNef8VI+bvXgUehSmaHcboxuE8J8f5hSjmC7cvkd3K3xaiCbQCzGB
         hMJbnhcGNyeXx96Ws/L7OiAtfueSrVq+o3Sd1Y4SHrdY6S7kx4hFkIv+fR/aLLWFSIhr
         tiSlLjy257XJZm4dE4i5MW+abboKaGpE7F/7nFJm9E6OLFCXDc3Vnc/nw2jLkl838924
         fSgVJElhnipdpPH0iO4iuUl4yCFBs1PC8G1xCgqBnlT6zoBaISy8fVAEKdeGwBYX6077
         t37RQc8jIyCC0HdJb2Zcdfe5eo+kD8zMJIezEMwHfITF1UU+5i9Y8KpBEyD9t4gpVGkx
         dvgQ==
X-Gm-Message-State: AOAM532XcQRqZ+NaVqxeYOrumZJXXsBRu3jLOaUPBnft675fTF/+iLvz
        vnCfA++oc7oPp1fkWku40xccyYfKkTs=
X-Google-Smtp-Source: ABdhPJwKVVmaqjrBNAHBVsO/RRk8muM/42FU8DM1SgU25ymV7LLALdD5NXCnQX2yPjNNtQo9my6vvQ==
X-Received: by 2002:a05:6830:1088:: with SMTP id y8mr1184154oto.372.1613265384263;
        Sat, 13 Feb 2021 17:16:24 -0800 (PST)
Received: from ?IPv6:2600:1700:dfe0:49f0:e93c:cbea:e191:f62a? ([2600:1700:dfe0:49f0:e93c:cbea:e191:f62a])
        by smtp.gmail.com with ESMTPSA id a23sm2828578oii.16.2021.02.13.17.16.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Feb 2021 17:16:23 -0800 (PST)
Subject: Re: [PATCH net-next 4/5] net: dsa: propagate extack to .port_vlan_add
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
 <20210213204319.1226170-5-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <848592e3-4824-8369-c75f-5ade994973bd@gmail.com>
Date:   Sat, 13 Feb 2021 17:16:19 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210213204319.1226170-5-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/13/2021 12:43, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Allow drivers to communicate their restrictions to user space directly,
> instead of printing to the kernel log. Where the conversion would have
> been lossy and things like VLAN ID could no longer be conveyed (due to
> the lack of support for printf format specifier in netlink extack), I
> chose to keep the messages in full form to the kernel log only, and
> leave it up to individual driver maintainers to move more messages to
> extack.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
