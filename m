Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22BC3264D79
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 20:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbgIJSnU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 14:43:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbgIJSlK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 14:41:10 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75601C061756
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 11:41:10 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id m5so4706695pgj.9
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 11:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:subject:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=20QtWjHTicadZytBmx0ukWpEv8BZNvcSu07qsLHoS+k=;
        b=HqjbRO8agJrYYRuusrZIzAKnHSGCutZGbbuMwrXoEN9re6M1AgBwQxGnlqK/T7MZKI
         UFXrBep61e+x7tYhyoV0tvBX2ZEl/zYTC38yzn8ijtujFNdWbRijf/e1gZ8eI2VQv392
         rbn4LsHY7a1fwKGdebGN2bnRQHUjhKU1h4MxqUWgarZTW6wE2To8Lb7Kv4twWgLX4i6M
         xi74Pn8Ru9hZEgp0ksuYagewAhuRu+1tq/0xB7hGrzBZuMsLHegKbOZGamtRcaRi5xKg
         w+lL4hNYOCYYoCV4FDEw3C8O/ZbOS7mBgewPsTsChJ1tcPSfAA/B96zAGBRdc98opXpW
         u65g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=20QtWjHTicadZytBmx0ukWpEv8BZNvcSu07qsLHoS+k=;
        b=HyeKLnZOfq8BO6x2M5OKiUmJ8Phhe98kTWy6HFKBfdtpiNc48tCaPBVSX3T5CmYDm1
         idC/4vRy63Q6hW1Bi0PND2Yb8XokLLKrp6vQCYW8x3buA08p5C1cAyB8OvEP20KVzf/s
         ++q2ivVBV5MvPM+9cYVqwhBdv7XIFzNcpYTVoHFt/dKs4ogFsYlBEqek6F9jcVLb7x2r
         BoSZ3fARYz/C6/KbnTJbfKDZSVvXUKdMZTBGH7dD0AlFgXWZtR7Zv3o/E7eQCf5TuMrW
         HR9RJTtdjyC2n5K69oegkjftF0t41P8Ka8+vvqxzzpP3+JmnfG6Oc8Tvs082Ug678gvq
         Qcqg==
X-Gm-Message-State: AOAM5303eoS9uYIbmSkPjdBCPbceuU/z+OQ8Qeep0fifi5EslevWTxl1
        2zTzZih9E8qYsEuaXVD3Rj4=
X-Google-Smtp-Source: ABdhPJz0h50Of/XpDbgHbyLPb8MrBcJEb7hdYS29wKVdCXv56YMMe1IdciSUsOvwDWrBNdpYAVHICQ==
X-Received: by 2002:a05:6a00:8ca:: with SMTP id s10mr6604816pfu.30.1599763269914;
        Thu, 10 Sep 2020 11:41:09 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id k7sm2572211pjs.9.2020.09.10.11.41.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Sep 2020 11:41:09 -0700 (PDT)
To:     Vladimir Oltean <olteanv@gmail.com>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>
References: <20200910150738.mwhh2i6j2qgacqev@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: VLAN filtering with DSA
Message-ID: <a5e0a066-0193-beca-7773-5933d48696e8@gmail.com>
Date:   Thu, 10 Sep 2020 11:41:04 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <20200910150738.mwhh2i6j2qgacqev@skbuf>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+Ido,

On 9/10/2020 8:07 AM, Vladimir Oltean wrote:
> Florian, can you please reiterate what is the problem with calling
> vlan_vid_add() with a VLAN that is installed by the bridge?
> 
> The effect of vlan_vid_add(), to my knowledge, is that the network
> interface should add this VLAN to its filtering table, and not drop it.
> So why return -EBUSY?

I suppose that if you wanted to have an 802.1Q just for the sake of 
receiving VLAN tagged frames but not have them ingress the to the CPU, 
you could install an 802.1Q upper, but why would you do that unless the 
CPU should also receive that traffic?

The case that I wanted to cover was to avoid the two programming 
interfaces or the same VLAN, and prefer the bridge VLAN management over 
the 802.1Q upper, because once the switch port is in a bridge, that is 
what an user would expect to use.

If you have a bridge that is VLAN aware, it will manage the data and 
control path for us and that is all good since it is capable of dealing 
with VLAN tagged frames.

A non-VLAN aware bridge's data path is only allowed to see untagged 
traffic, so if you wanted somehow to inject untagged traffic into the 
bridge data path, then you would add a 802.1Q upper to that switch port, 
and somehow add that device into the bridge. There is a problem with 
that though, if you have mutliple bridge devices spanning the same 
switch, and you do the same thing on another switch port, with another 
802.1Q upper, I believe you could break isolation between bridges for 
that particular VID.

Most of this was based on discussions we had with Ido and him explaining 
to me how they were doing it in mlxsw.

AFAIR the other case which is that you already have a 802.1Q upper, and 
then you add the switch port to the bridge is permitted and the bridge 
would inherit the VLAN into its local database.

I did not put much thoughts back then into a cascading set-up, so some 
assumptions can certainly be broken, and in fact, are broken today as 
you experimented.
-- 
Florian
