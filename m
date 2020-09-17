Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C08726E49D
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 20:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728442AbgIQQUl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 12:20:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728409AbgIQQUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 12:20:15 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09E27C061756;
        Thu, 17 Sep 2020 09:19:07 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id f18so1510198pfa.10;
        Thu, 17 Sep 2020 09:19:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=igiQ5JmS/cZQA1RCpu2Wa1Xr/x0ZU1VRDuvNFsuCJEA=;
        b=kXGdctaPtSBO4/eiipRRwnvwnDhU0nYpt2C9EaVBD7aF3W/Bn+sbezVsJ+q50FjwAv
         3PE+teijCjpcwvcj1jFFgWvcFmDD3BBt8A88b55n2lRUzA/LdM2ZxsyE/ejmDD8vsQOw
         tL1jjYlWw7BKGSafrhsGaOlm2ioy/o2590DdT5gXGXLpEDyi+B6ceMcXhLKvXBVdbob/
         9+DQPTIiwyPGhCKuDLoJ1Ofz0ja6nmIIXjWu4EZkUKT+0OGI9bpJbgHFSmDbiXPtjBq9
         /dZrNQ/zXaSfvJezLb2/VFiF5vkkh5dblvMxmoX2qf3WS0eYsHgtIBorytSTidA3L88a
         6azw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=igiQ5JmS/cZQA1RCpu2Wa1Xr/x0ZU1VRDuvNFsuCJEA=;
        b=mXaVEJ3D8wjpqvfRcvErXMZab8C2YnAmGrnYln0fPJdI2s8OzaeiVFK+ZJ4Xf6Hozr
         nL4/t8ygUFzpcja40j/T23AkLSso4Xlztxnmn/jefOG+4Bb7wGHoaLIcGxZo3Dw3rnWm
         +a3cifqMLvfsfyzhzLdRqKBEErQof6ZsighOpE/JDLr4dyG17rHqX3TikvoENYE2P55Q
         /wM8xAt+GdqnZ/8R4/Xrhh6GP3zxYHEG5/+Rliyb6RgrCbGueKlCl00kKzppPiWPbYLy
         10VjuH+EIfm9nS6jcuQ+8wlS95PfCsOebXPhWL5daTCy1YvWDYcodrUEUf7pdGIoHchI
         i9QA==
X-Gm-Message-State: AOAM532iKL2EUporjTptCAivkNEMia37ZhV2uGQEIV82SeE9IMjXzzqW
        c4q93CP29L1hZE0mTDYR7176oFE98UWTQg==
X-Google-Smtp-Source: ABdhPJwI2BNaXOemPWMimeOvliVMWNuwsEUSrBGW0+jT12LVjHVWi4drigx3HYYCP/xDNSXUYG0xBQ==
X-Received: by 2002:a62:5f02:0:b029:13c:1611:6536 with SMTP id t2-20020a625f020000b029013c16116536mr26658330pfb.8.1600359545856;
        Thu, 17 Sep 2020 09:19:05 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id r6sm99028pfq.11.2020.09.17.09.19.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2020 09:19:05 -0700 (PDT)
Subject: Re: [PATCH net-next v2] net: phy: bcm7xxx: request and manage GPHY
 clock
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, opendmb@gmail.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:BROADCOM ETHERNET PHY DRIVERS" 
        <bcm-kernel-feedback-list@broadcom.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20200917020413.2313461-1-f.fainelli@gmail.com>
 <20200917131128.GK3526428@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <ce0bb513-045c-aa7f-6437-fdc77e9ecab1@gmail.com>
Date:   Thu, 17 Sep 2020 09:19:03 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200917131128.GK3526428@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/17/2020 6:11 AM, Andrew Lunn wrote:
> On Wed, Sep 16, 2020 at 07:04:13PM -0700, Florian Fainelli wrote:
>> The internal Gigabit PHY on Broadcom STB chips has a digital clock which
>> drives its MDIO interface among other things, the driver now requests
>> and manage that clock during .probe() and .remove() accordingly.
>>
>> Because the PHY driver can be probed with the clocks turned off we need
>> to apply the dummy BMSR workaround during the driver probe function to
>> ensure subsequent MDIO read or write towards the PHY will succeed.
> 
> Hi Florian
> 
> Is it worth mentioning this in the DT binding? It is all pretty much
> standard lego pieces, but it has taken you a while to assemble them in
> the correct way. So giving hits to others who might want to uses these
> STB chips could be nice.

In some respect this does not really belong in the DT binding because we 
are describing how Linux will be matching a given compatible string with 
its driver, but it is certainly worth mentioning somewhere, like in the 
PHY document.

Are you fine with the changes though?
-- 
Florian
