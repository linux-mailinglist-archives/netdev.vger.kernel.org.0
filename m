Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58126402C27
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 17:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345526AbhIGPsu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 11:48:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345338AbhIGPsu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 11:48:50 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C561FC061575
        for <netdev@vger.kernel.org>; Tue,  7 Sep 2021 08:47:43 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id x19so8489199pfu.4
        for <netdev@vger.kernel.org>; Tue, 07 Sep 2021 08:47:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=2+hdbJLCo3hY+E3AfKhU+4y3qJfDuraJtPDf7fMzy0k=;
        b=Xalzwsqp5QZ/ikKzrb2FVhnmXv3m8dQwV0Andm8UYxRQ2zg3XHGo37GHrw6YiZWTlN
         KFzf7WBKBA/SYojggeQtYXfLtt2KczPHzIKyUu5nhcspmIvE3FvRHFfGvd1DkN00ARGp
         W+polQdaXgPlYV3ofs2OJdeCdSV4nnr16Ka9pAE33eQl35t1McFvgBbFJ2d8CTagiExK
         vsWg3DXJWXUqB+vEhaehV/CQK5xXwBDRNOML5+8sZCKbWPUWx87FmrDVianu/gFwIlcm
         GS0lBvXw1ib/UrGK/j2M30QDgJJseXmLThFpGPgc4PYcB4pmO4a+wisIA0fNI3mJ71Kf
         IOcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2+hdbJLCo3hY+E3AfKhU+4y3qJfDuraJtPDf7fMzy0k=;
        b=InuNJY/zN5x9jiKFEZ7a/IasqXT83mxdZr/NZkpMIbRRK73Vh7y/zXUwtMIvVqdO83
         g0VPEe+Gef8tF/2HTLqqfGPe18VNO3CHAeVmiGi/xkIipt1BpDjSPlCnWKqeI4g7XvkJ
         4fifMGFVZPfta58KR142z+SHgislKQGxzhkRlSapiXTrtmxEHXXr8QlK8uLKonz0q3QQ
         c07lwOX47Asxex3GDjY2dFxCNSBHECosne/8Z+W8nagyyx8ly9iFw5E+Rw5zoj+w+uvh
         ZT8JsqElwm5AQxdrQAnRb41Sz1oYf6fkbg55tGi/gPbonYqKxihZKWba++ZecLHwgN6X
         fJfA==
X-Gm-Message-State: AOAM533baNHVbxM9BuNl5yWppawCm7utHUpaFtkb5pHRiFlNLYfHuPHI
        KvWhKx+18rjj3XftgjFXQ40=
X-Google-Smtp-Source: ABdhPJyvSEMsIL7+3S+zzCb5+qJzjV8Fh2jlqAeoNRgVKJ34+AWhoMNAkLTlEEi4wN68yl5BrugAyg==
X-Received: by 2002:a63:7a0e:: with SMTP id v14mr17576679pgc.466.1631029663195;
        Tue, 07 Sep 2021 08:47:43 -0700 (PDT)
Received: from [10.230.31.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a194sm11246540pfa.119.2021.09.07.08.47.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Sep 2021 08:47:42 -0700 (PDT)
Message-ID: <ac8e1c9e-5df2-0af7-2ab4-26f78d5839e3@gmail.com>
Date:   Tue, 7 Sep 2021 08:47:35 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: Re: [RFC PATCH net] net: dsa: tear down devlink port regions when
 tearing down the devlink port on error
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20210902231738.1903476-1-vladimir.oltean@nxp.com>
 <YTRswWukNB0zDRIc@unreal> <20210905084518.emlagw76qmo44rpw@skbuf>
 <YTSa/3XHe9qVz9t7@unreal> <20210905103125.2ulxt2l65frw7bwu@skbuf>
 <YTSgVw7BNK1e4YWY@unreal> <20210905110735.asgsyjygsrxti6jk@skbuf>
 <20210907084431.563ee411@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20210907084431.563ee411@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/7/2021 8:44 AM, Jakub Kicinski wrote:
> On Sun, 5 Sep 2021 14:07:35 +0300 Vladimir Oltean wrote:
>> Again, fallback but not during devlink port register. The devlink port
>> was registered just fine, but our plans changed midway. If you want to
>> create a net device with an associated devlink port, first you need to
>> create the devlink port and then the net device, then you need to link
>> the two using devlink_port_type_eth_set, at least according to my
>> understanding.
>>
>> So the failure is during the creation of the **net device**, we now have a
>> devlink port which was originally intended to be of the Ethernet type
>> and have a physical flavour, but it will not be backed by any net device,
>> because the creation of that just failed. So the question is simply what
>> to do with that devlink port.
> 
> Is the failure you're referring to discovered inside the
> register_netdevice() call?

It is before, at the time we attempt to connect to the PHY device, prior 
to registering the netdev, we may fail that PHY connection, tearing down 
the entire switch because of that is highly undesirable.

Maybe we should re-order things a little bit and try to register devlink 
ports only after we successfully registered with the PHY/SFP and prior 
to registering the netdev?
-- 
Florian
