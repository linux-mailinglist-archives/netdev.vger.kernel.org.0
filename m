Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21C902711CB
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 04:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbgITCn2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 22:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726760AbgITCn2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Sep 2020 22:43:28 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4E22C061755
        for <netdev@vger.kernel.org>; Sat, 19 Sep 2020 19:43:27 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id mm21so5349845pjb.4
        for <netdev@vger.kernel.org>; Sat, 19 Sep 2020 19:43:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lNd8vGnTeZKjkVtzNW4Eb5p6I7n+pFV5U9I4sZXuGEs=;
        b=Pil8DNyDRd6jfmjfPtrDHnt4TOYzPEIucRQHpgjeRzWNqWcAOAoRh3KcfIyXcuOzzG
         hPhiSEfG6KDfewq91e87z60OuRp5oTBEUHwlvABiguHgP3lh/0bo0ih0ouiQZgo630Zx
         1zxKqZNH3QfFh1AreRalV11B6SV9I5hP/CNC6JzTjdZPufI2YH1ZVeaZXv/bIIFQtjxx
         LDcn0gdBiFGn/dTJ4GgAGDKBPhjdjBzVGnYTneNiwk4ADyaCmWBIWeaicF7uXp7+f0gi
         bMiZG2SjMxoLYuZJN7d3j4vklc1T2kTbiaL8gxYAgL5xS2Qvd9g1X+tWMVk9Yppqj1LZ
         Z1wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lNd8vGnTeZKjkVtzNW4Eb5p6I7n+pFV5U9I4sZXuGEs=;
        b=iB2NUNcYx5prp+fI1piQk84irDfUcV5dFQ7t9Phtqbo9DRcNC1LzrOEdIwHpB8sN0c
         LG7tzEoHOkHLHqYpC5zsRfjEjU5HJ477bY45O+fdpvse0JuqP9hSrB0hmxFWURIk+tCE
         cMB+Zc2YmUFygnroQWEEor3+ZVEwWrNKEwOBXLziq+MSTAxQxJ4PO/BEoPR9OqUjkMHk
         lNdaK/cf+dv/ezTKYqM74w4VQVLyO69khLCr47l88T1+Nyi0L54jGVvrVoUfsuhPQCb5
         xI5kLZpxLcP1EIEUIIQw3fNh13e561Vsbb+aS1W+Yzwt5pwzNrxWbXk50aNnqDK1UrGd
         xsGw==
X-Gm-Message-State: AOAM533bDppeFBp+n58+GCWCCE70luEXPWtcjNShbX8HPNt7+hpLnqFC
        0fjaom0wDVg9b5f37HlVi+0=
X-Google-Smtp-Source: ABdhPJyYEF3GG02z1mGdKv1/t96/u2wqX3gAviR/j++JEQKKLlMxXZtdOZUXbt5n2bCM7V28cfCj6w==
X-Received: by 2002:a17:902:c084:b029:d1:e598:4019 with SMTP id j4-20020a170902c084b02900d1e5984019mr21862606pld.83.1600569807422;
        Sat, 19 Sep 2020 19:43:27 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id r3sm7877491pfh.88.2020.09.19.19.43.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Sep 2020 19:43:26 -0700 (PDT)
Subject: Re: [RFC PATCH 7/9] net: dsa: install VLANs into the master's RX
 filter too
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        davem@davemloft.net
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, idosch@idosch.org,
        jiri@resnulli.us, kurt.kanzenbach@linutronix.de, kuba@kernel.org
References: <20200920014727.2754928-1-vladimir.oltean@nxp.com>
 <20200920014727.2754928-8-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <eee4158c-fa0b-eb1e-1a3e-1b81341ebca4@gmail.com>
Date:   Sat, 19 Sep 2020 19:43:25 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200920014727.2754928-8-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/19/2020 6:47 PM, Vladimir Oltean wrote:
> Most DSA switch tags shift the EtherType to the right, causing the
> master to not parse the VLAN as VLAN.
> However, not all switches do that (example: tail tags, tag_8021q etc),
> and if the DSA master has "rx-vlan-filter: on" in ethtool -k, then we
> have a problem.
> 
> Therefore, we could populate the VLAN table of the master, just in case
> (for some switches it will not make a difference), so that network I/O
> can work even with a VLAN filtering master.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
