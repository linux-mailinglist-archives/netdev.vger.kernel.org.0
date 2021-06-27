Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6A563B50DB
	for <lists+netdev@lfdr.de>; Sun, 27 Jun 2021 05:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbhF0DD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Jun 2021 23:03:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbhF0DD4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Jun 2021 23:03:56 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B31E9C061574
        for <netdev@vger.kernel.org>; Sat, 26 Jun 2021 20:01:33 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id m17so6864236plx.7
        for <netdev@vger.kernel.org>; Sat, 26 Jun 2021 20:01:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BD8FXNOGL6nLxco6A1aTNYWsjM2mSp0cjQxg/+vjerc=;
        b=Zc6I/9v+YH21NYGPNNsjRF/wWUKpwtjPkgvb4WAaGZTVQaDNHLPa0iPXYqW1UPAVLM
         oi9QBsN9rDasuihT5Bxrnja79+jkzEFiEzwdh8mFg/GOEOLOtcA2V/x6RaoTOGtLJqeJ
         yHz6uiJhjQu6cjiCy1NugE9D1kxRTczykObYWz+VyTXU3xMl2RrpyxI4wcUSbTl6tcZk
         oblvzjzpaycwx/d8wasQyj9sZMl06WyzGTqycN5fDn1n3UAW6NT+0rTQYoEIu3pQ7mU8
         Vuj3AnZihFEqbh2wkQuQa6ksK50XvRt5zMYa2yJjq0i2flx9QAYODh0y3rjWkxDihyii
         WBcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BD8FXNOGL6nLxco6A1aTNYWsjM2mSp0cjQxg/+vjerc=;
        b=pNw6lciPsVQ5E1G8+n+9G8xAR3tHjJBI6S4GlA0S3k+BmyK7uEy2Awx0EcuuWFsxd/
         IKDep2hvOnls43oCIenHwGeaxeZE58kbPkdffcWXTl83bYnpqidNztZnIj7Jxs4ZPaC7
         G2tozM2FDLzk0gMoEreyL2bMew2QYfgkhGh46sb2dti0/qZ99J5WB94bwtuc3WGKnFJm
         vDLOHfNgy17fV3B6SVIZ/UYnnZ166AtBGH3tGAi63dQbsyBd9GYE/X4rVBUY6E+brTbk
         xfGXgkTXjMezlnz1y6nnZufKTkdzEeXCL0x7rbxnjCfc+lZvYX+g/rUnmFggICjM8daI
         jcWw==
X-Gm-Message-State: AOAM530oN5t5KSTiIjavqyQdUsNqGfGgv/aS5hwkoCmf+3sE1OX8CLkz
        L26kqdN0IbF3wbSm8n//o/I=
X-Google-Smtp-Source: ABdhPJzZ5rwDWJD774hnVJgGBShOVk2VC0NJOqvsXv9SU+g4t3/H68IFJnamBbD6X9Wa1aSCgzskiQ==
X-Received: by 2002:a17:90a:b28a:: with SMTP id c10mr28559945pjr.59.1624762893262;
        Sat, 26 Jun 2021 20:01:33 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id k63sm14810575pjh.13.2021.06.26.20.01.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Jun 2021 20:01:32 -0700 (PDT)
Subject: Re: [PATCH net-next 6/7] net: bridge: allow the switchdev replay
 functions to be called for deletion
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20210625185321.626325-1-olteanv@gmail.com>
 <20210625185321.626325-7-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <42b36391-a496-41f0-18bf-7427211c0117@gmail.com>
Date:   Sat, 26 Jun 2021 20:01:30 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210625185321.626325-7-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/25/2021 11:53 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> When a switchdev port leaves a LAG that is a bridge port, the switchdev
> objects and port attributes offloaded to that port are not removed:
> 
> ip link add br0 type bridge
> ip link add bond0 type bond mode 802.3ad
> ip link set swp0 master bond0
> ip link set bond0 master br0
> bridge vlan add dev bond0 vid 100
> ip link set swp0 nomaster
> 
> VLAN 100 will remain installed on swp0 despite it going into standalone
> mode, because as far as the bridge is concerned, nothing ever happened
> to its bridge port.
> 
> Let's extend the bridge vlan, fdb and mdb replay functions to take a
> 'bool adding' argument, and make DSA and ocelot call the replay
> functions with 'adding' as false from the switchdev unsync path, for the
> switch port that leaves the bridge.
> 
> Note that this patch in itself does not salvage anything, because in the
> current pull mode of operation, DSA still needs to call the replay
> helpers with adding=false. This will be done in another patch.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
