Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8C725D3DE
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 10:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729871AbgIDIn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 04:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbgIDInY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 04:43:24 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14050C061244
        for <netdev@vger.kernel.org>; Fri,  4 Sep 2020 01:43:24 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id e17so5312185wme.0
        for <netdev@vger.kernel.org>; Fri, 04 Sep 2020 01:43:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6SKwu6Eibs212Rdq11zmRwvRtoW4kk7dkuIPJQIWHmU=;
        b=DxWNSO1fE5O29mnnatElVFApcKIhPLw24p5I4FNwwIAKatQHMOu1/Bw+t6AF7ZbaeR
         sscb2CES2fQWcvWP3x7Y/SOFoG2rRlOOPYncfriXNzzdEgbSZ0SeKy5QRQN21WaWN6BV
         5Agyp8ZvGkqzzSa5XOoQK0y1wbD2/QHHD87rKFsmlfUIUF+dEdu/j+o1w7K91E/keu0Z
         KMELayiUrWKKYV3Di8nxoBTk/S+zRpheykB0PySmFboSnGANfw18anTUJ65oclzcpPfF
         YRWGZ9JLlgZ9iAKM9TSZ5uP3Bk4KqggDBrWP+2FK+L1sFRAYAbWH44w3Mt4RAC2kq258
         wztA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6SKwu6Eibs212Rdq11zmRwvRtoW4kk7dkuIPJQIWHmU=;
        b=ueEv6kyusaZR6P3ps18WZEuJl2iVy3dQUSIBWRa1DfICeF0oOppHaiHeEWRS1DOtla
         BWpBo2f0xzE1KyMpyetKZlAj60YHNAvhSRrCGKTC4HU4ZuDMxEJxuhTVNNTqrDxpfEdM
         ly5+irkT7QOBXG1jPaHaW8EZ9/5Nm3vOSkKLCiwrzrTqwnxGc9uHVECu/zAktMYa88xB
         7XrhUFSjQiPTjT+Ls1WhRUOOhDZKaGZ1QeOB1zJtVpO54BTmmSlDNSs0PnGRehh5oT8Y
         LaV9/f2Jb94f3szqvlL3pKkHJEn/3lkU38Z0DfLhXVL0ve9umwOlRX+vijCrGD1U6srS
         xOkg==
X-Gm-Message-State: AOAM533YddHMN+KpqkvJQ/XIZFA2MONDNZeUKNqL8BukZOoQuxOlCPvT
        D31NVDzgWcJdq0z15/qElSbzVA==
X-Google-Smtp-Source: ABdhPJz2pC+pDuyeIejSOWBkXTWDNGGQ0JH7nSTDvUZeLrDNZlztq5rGPV/moMaHqtJaJdoYmak8Mg==
X-Received: by 2002:a1c:6346:: with SMTP id x67mr6278740wmb.42.1599209002682;
        Fri, 04 Sep 2020 01:43:22 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id t188sm10474168wmf.41.2020.09.04.01.43.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2020 01:43:22 -0700 (PDT)
Date:   Fri, 4 Sep 2020 10:43:21 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Parav Pandit <parav@nvidia.com>, Parav Pandit <parav@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "roid@mellanox.com" <roid@mellanox.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next 2/3] devlink: Consider other controller while
 building phys_port_name
Message-ID: <20200904084321.GG2997@nanopsycho.orion>
References: <BY5PR12MB43220099C235E238D6AF89EADC530@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20200901081906.GE3794@nanopsycho.orion>
 <BY5PR12MB43229CA19D3D8215BC9BEFECDC2E0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20200901091742.GF3794@nanopsycho.orion>
 <20200901142840.25b6b58f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BY5PR12MB43228D0A9B1EF43C061A5A3BDC2F0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20200902080011.GI3794@nanopsycho.orion>
 <20200902082358.6b0c69b1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200903055439.GA2997@nanopsycho.orion>
 <20200903123123.7e6025ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200903123123.7e6025ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Sep 03, 2020 at 09:31:23PM CEST, kuba@kernel.org wrote:
>On Thu, 3 Sep 2020 07:54:39 +0200 Jiri Pirko wrote:
>> Wed, Sep 02, 2020 at 05:23:58PM CEST, kuba@kernel.org wrote:
>> >On Wed, 2 Sep 2020 10:00:11 +0200 Jiri Pirko wrote:  
>> >>>> I didn't quite get the fact that you want to not show controller ID on the local
>> >>>> port, initially.    
>> >>> Mainly to not_break current users.    
>> >> 
>> >> You don't have to take it to the name, unless "external" flag is set.
>> >> 
>> >> But I don't really see the point of showing !external, cause such
>> >> controller number would be always 0. Jakub, why do you think it is
>> >> needed?  
>> >
>> >It may seem reasonable for a smartNIC where there are only two
>> >controllers, and all you really need is that external flag. 
>> >
>> >In a general case when users are trying to figure out the topology
>> >not knowing which controller they are sitting at looks like a serious
>> >limitation.  
>> 
>> I think we misunderstood each other. I never proposed just "external"
>> flag.
>
>Sorry, I was just saying that assuming a single host SmartNIC the
>controller ID is not necessary at all. You never suggested that, I did. 
>Looks like I just confused everyone with that comment :(
>
>Different controller ID for different PFs but the same PCIe link would
>be very wrong. So please clarify - if I have a 2 port smartNIC, with on
>PCIe link to the host, and the embedded controller - what would I see?

Parav?


>
>> What I propose is either:
>> 1) ecnum attribute absent for local
>>    ecnum attribute absent set to 0 for external controller X
>>    ecnum attribute absent set to 1 for external controller Y
>>    ...
>> 
>> or:
>> 2) ecnum attribute absent for local, external flag set to false
>>    ecnum attribute absent set to 0 for external controller X, external flag set to true
>>    ecnum attribute absent set to 1 for external controller Y, external flag set to true
>
>I'm saying that I do want to see the the controller ID for all ports.
>
>So:
>
>3) local:   { "controller ID": x }
>   remote1: { "controller ID": y, "external": true }
>   remote1: { "controller ID": z, "external": true }
>
>We don't have to put the controller ID in the name for local ports, but
>the attribute should be reported. AFAIU name was your main concern, no?

Okay. Sounds fine. Let's put the controller number there for all ports.
ctrlnum X external true
ctrlnum Y external false

if (!external)
	ignore the ctrlnum when generating the name


>
>> >Example - multi-host system and you want to know which controller you
>> >are to run power cycle from the BMC side.
>> >
>> >We won't be able to change that because it'd change the names for you.  
