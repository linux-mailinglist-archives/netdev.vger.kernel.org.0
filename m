Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6602D2711C8
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 04:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbgITCi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 22:38:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726760AbgITCi5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Sep 2020 22:38:57 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28656C061755
        for <netdev@vger.kernel.org>; Sat, 19 Sep 2020 19:38:57 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id k133so1168942pgc.7
        for <netdev@vger.kernel.org>; Sat, 19 Sep 2020 19:38:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Gk0/fLrTDHe2DmPfOPfpDLhusS6VXLhRMjZwcUaGFy4=;
        b=C6sNMn2o5m0QfmyAOmPIYlwS0NHJtjZYZ5VPT9wXz8xZlEp0lV/X+EFOQroUkILyng
         xcbmFBdwI7OeGScyMkqQIle1PGzQDG2Zbnxx2tQkC9TtlPj+roDmOa/LgllGIYaOfF7Q
         e5Ek2A86G0dIJDujA9vr0lgEq7H2ns0WZ8E9ISUi9ozXQCdFm3DWqA777TI00psXXdq/
         seSzQPWoLBGYR3Sj88At9gCuPUhpR23Pe14EUHdeefxakEL7fDwVR4Slv8mvTfLyEdCe
         SNvbQfDNHpFSXWLJ3AjMF2rAO91t13PmD1MT1pEgKVyQuB6j/gqVYj3Ga7ivO2gvjPwA
         8p9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Gk0/fLrTDHe2DmPfOPfpDLhusS6VXLhRMjZwcUaGFy4=;
        b=QqAo62aaE8b6tMrNwdjCkkKUQah9L9IbW96yPIomtOf3bLx9o1JYwNgFyxOuHrQPyI
         ADDI+655L6kA61qqFlLj3a/BO9B7mLna6SPrQ1Ym1j7vzgwUMc/eGBMaqkHYasHqGkUQ
         iN9DJHCSEmQ6fmghJ17gBPi7SBHmIYQxFgPHxkBxUUZD77IBV33IezoP4zivNV50I6Wt
         dknOsyOhWDfP8vlGrhDYZsR2z4PKN3gmluVM6OzHtIuwmFTl8kUX/9RIHumfsjxlyZLF
         GbDP628o+PEWYeWF0Q+LdAopTqRthkQ+P1UA/4z56vuD8A3j+iuu+1PYN/cDfLHrvENM
         M5ig==
X-Gm-Message-State: AOAM533FRcS1+znOefGh4TUjLxJEigfaW8S5jYZKvtbgZl+WBshLclOZ
        xvxiQb6joE/kcftY0vEeNynQf7+eVLjfhw==
X-Google-Smtp-Source: ABdhPJx53z1zI6asfIW9oJclryG1sAU/OzkzkaDU7oHKKNzUeessooaUxuBydn/T2ZDQLSm10Uo6hg==
X-Received: by 2002:a63:f812:: with SMTP id n18mr30107583pgh.438.1600569536558;
        Sat, 19 Sep 2020 19:38:56 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id e2sm7631142pgl.38.2020.09.19.19.38.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Sep 2020 19:38:55 -0700 (PDT)
Subject: Re: [RFC PATCH 5/9] net: dsa: refuse configuration in prepare phase
 of dsa_port_vlan_filtering()
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        davem@davemloft.net
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, idosch@idosch.org,
        jiri@resnulli.us, kurt.kanzenbach@linutronix.de, kuba@kernel.org
References: <20200920014727.2754928-1-vladimir.oltean@nxp.com>
 <20200920014727.2754928-6-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <62d7a16c-1678-d6d2-d446-7f8ae392ab48@gmail.com>
Date:   Sat, 19 Sep 2020 19:38:54 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200920014727.2754928-6-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/19/2020 6:47 PM, Vladimir Oltean wrote:
> The current logic beats me a little bit. The comment that "bridge skips
> -EOPNOTSUPP, so skip the prepare phase" was introduced in commit
> fb2dabad69f0 ("net: dsa: support VLAN filtering switchdev attr").
> 
> I'm not sure:
> (a) ok, the bridge skips -EOPNOTSUPP, but, so what, where are we
>      returning -EOPNOTSUPP?
> (b) even if we are, and I'm just not seeing it, what is the causality
>      relationship between the bridge skipping -EOPNOTSUPP and DSA
>      skipping the prepare phase, and just returning zero?
> 
> One thing is certain beyond doubt though, and that is that DSA currently
> refuses VLAN filtering from the "commit" phase instead of "prepare", and
> that this is not a good thing:
> 
> ip link add br0 type bridge
> ip link add br1 type bridge vlan_filtering 1
> ip link set swp2 master br0
> ip link set swp3 master br1
> [ 3790.379389] 001: sja1105 spi0.1: VLAN filtering is a global setting
> [ 3790.379399] 001: ------------[ cut here ]------------
> [ 3790.379403] 001: WARNING: CPU: 1 PID: 515 at net/switchdev/switchdev.c:157 switchdev_port_attr_set_now+0x9c/0xa4
> [ 3790.379420] 001: swp3: Commit of attribute (id=6) failed.
> [ 3790.379533] 001: [<c11ff588>] (switchdev_port_attr_set_now) from [<c11b62e4>] (nbp_vlan_init+0x84/0x148)
> [ 3790.379544] 001: [<c11b62e4>] (nbp_vlan_init) from [<c11a2ff0>] (br_add_if+0x514/0x670)
> [ 3790.379554] 001: [<c11a2ff0>] (br_add_if) from [<c1031b5c>] (do_setlink+0x38c/0xab0)
> [ 3790.379565] 001: [<c1031b5c>] (do_setlink) from [<c1036fe8>] (__rtnl_newlink+0x44c/0x748)
> [ 3790.379573] 001: [<c1036fe8>] (__rtnl_newlink) from [<c1037328>] (rtnl_newlink+0x44/0x60)
> [ 3790.379580] 001: [<c1037328>] (rtnl_newlink) from [<c10315fc>] (rtnetlink_rcv_msg+0x124/0x2f8)
> [ 3790.379590] 001: [<c10315fc>] (rtnetlink_rcv_msg) from [<c10926b8>] (netlink_rcv_skb+0xb8/0x110)
> [ 3790.379806] 001: ---[ end trace 0000000000000002 ]---
> [ 3790.379819] 001: sja1105 spi0.1 swp3: failed to initialize vlan filtering on this port
> 
> So move the current logic that may fail (except ds->ops->port_vlan_filtering,
> that is way harder) into the prepare stage of the switchdev transaction.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
