Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FFC6423619
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 04:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbhJFCwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 22:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbhJFCwj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 22:52:39 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70CE6C061749
        for <netdev@vger.kernel.org>; Tue,  5 Oct 2021 19:50:47 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id l6so693628plh.9
        for <netdev@vger.kernel.org>; Tue, 05 Oct 2021 19:50:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=+4/zm+s+YUXMP3Mvx4RRo6JUXkxUDHW6lOEhcuaaLF4=;
        b=bwVO6cCxWLlDjXBX+BFzwQ+V3gSRiz2rS8Ry9hyVkOiFAMBJPkl+3wVM3obRI4HN1v
         8OR2TFc+fAikVo5koMXu2XogZoxcC9AdozM169niE6GiOR2FR5uQwQQoVQ/doVBcJy97
         Yt+cOMvOKFl93k5cjrNh6/CQFIk27iiQ65hByne5L0eLtqWY52pQdB/BIMKRgvzljh7n
         dK6eHgnRaof8Lxfn1DldJO5RBj6KDQEtuETT1mAo0qyD9XZAxnQT+EwTo+VBUr08OZzt
         wYFcsmu9KEGTAnbWITCa+E5VEavFYTc5ERhoMNiMlXusLlmH4Ln7MZj7SgxbmC+u3jlH
         X9cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+4/zm+s+YUXMP3Mvx4RRo6JUXkxUDHW6lOEhcuaaLF4=;
        b=it/9R5g2Gy6mhZFnJEWl6eS+f4HnnS7tbk80CtIircSZTj2gi+roeXNKSNbnZh+0of
         LEYvqYSHb4/InpgG0LgDiTjQyOBcGv4qW9gYVa5KEJsScxTJ8SgYFjJjbSXX3NcdmYPk
         oMk2NIQ9ctaGMKLL1WDPdthC3wnSKIQjuLTPPRCQyqWtVo/TvDcx46zYCk4wDRWvLqDc
         uVcnHML+65wzu3+jbTLpDmplrT7+XXa1NqFSsssGdn61SgSl2ZtFMf+rushCPg5Txegs
         6k2SPEX0fX/KBtLT3d3UQoY6AQBj2TcxsjpSsEIz+H0AaxhAornzx5gh6uaDBv7w/06p
         h33Q==
X-Gm-Message-State: AOAM531bwxNgZ7y+uQgTvI3LIBCGq+jocSIgcSQ8Fs3b5hB8bvSaOqMb
        BiC1D9nKWaYo3MD7PJs5k5w0xUTJjEQ=
X-Google-Smtp-Source: ABdhPJxoQ+RA+hkpOZy4sJhMmxbwrnEm79Kyf6I+lbH2KRHYcdhEyeVfVjcwEUFcQt/7j11DuJnnsQ==
X-Received: by 2002:a17:902:bf07:b0:138:e32d:9f2e with SMTP id bi7-20020a170902bf0700b00138e32d9f2emr8354148plb.59.1633488646809;
        Tue, 05 Oct 2021 19:50:46 -0700 (PDT)
Received: from [10.230.29.7] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a20sm41432pfn.136.2021.10.05.19.50.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Oct 2021 19:50:46 -0700 (PDT)
Message-ID: <fdd15403-47b5-fcb5-6fec-870347a8480d@gmail.com>
Date:   Tue, 5 Oct 2021 19:50:40 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Subject: Re: DSA: some questions regarding TX forwarding offload
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
References: <04d700b6-a4f7-b108-e711-d400ef01cc2e@bang-olufsen.dk>
 <20211005101253.sqvsvk53k34atjwt@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20211005101253.sqvsvk53k34atjwt@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/5/2021 3:12 AM, Vladimir Oltean wrote:
> I don't want to answer any of these questions until I understand how
> does your hardware intend the FID and FID_EN bits from the DSA header to
> be used. The FID only has 2 bits, so it is clear to me that it doesn't
> have the same understanding of the term as mv88e6xxx, if the Realtek
> switch has up to 4 FIDs while Marvell up to 4K.
> 
> You should ask yourself not only how to prevent leakage, but also the
> flip side, how should I pass the packet to the switch in such a way that
> it will learn its MAC SA in the right FID, assuming that you go with FDB
> isolation first and figure that out. Once that question is answered, you
> can in premise specify an allowance port mask which is larger than
> needed (the entire mask of user ports) and the switch should only
> forward it towards the ports belonging to the same FID, which are
> roughly equivalent with the ports under a specific bridge. You can
> create a mapping between a FID and dp->bridge_num. Makes sense or am I
> completely off?
> 

Sorry for sort of hijacking this discussion.

Broadcom switches do not have FIDs however using Alvin's topology, and 
given the existing bridge support in b53, it also does not look like 
there is leaking from one bridge to other because of the port matrix 
configuration which is enforced in addition to the VLAN membership. 
However based on what I see in tag_dsa.c for the transmit case with 
skb->offload_fwd_mark, I would have to dig into the bridge's members in 
order to construct a bitmask of ports to provide to tag_brcm.c, so that 
does not really get me anywhere, does it?

Those switches also always do double VLAN tag (802.1ad) normalization 
within their data path whenever VLAN is globally enabled within the 
switch, so in premise you could achieve the same isolation by reserving 
one of the outer VLAN tags per bridge, enabling IVL and hope that the 
FDB is looked including the outer and inner VLAN tags and not just the 
inner VLAN tag.

If we don't have a FID concept, and not all switches do, how we can 
still support tx forwarding offload here?
-- 
Florian
