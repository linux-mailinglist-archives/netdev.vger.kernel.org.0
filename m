Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D752127F607
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 01:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731673AbgI3X31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 19:29:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgI3X3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 19:29:18 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B50AC061755;
        Wed, 30 Sep 2020 16:29:18 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id n14so2537563pff.6;
        Wed, 30 Sep 2020 16:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XbE/IiUIEW5o7Z4MwXSn4tGipckljHwIwHeNPg/Be+A=;
        b=mKM+voMiojuhqyXl1L4YxWVMx3lZp66awoSFHeh0qjpxChKk8jreUXBM0eSOrh1fB4
         FViHVmZrtSd2PbLiwtdZPar5vE/I0xyJldCJL7kJb7P7/cLwdd2qkGFTeAF8y4tsh4xn
         fNw3nmha1vuhTSTWppoPqa1MSB5Tf47kCuCy86qu35F5VACu2yPMzmw0MFSX5GcrujH9
         cNVNvx3zfOaxP2YbFI0sIRbeDtpuoJEi1vwLMWhdw8dAWxVE84VCmhSjP0JyHap7riGt
         EhC+0+GRsCwRHCZ0G+y53l5+jEy6dudNqdhsigPbC9G4tcV3nvUCf2brvHd5zQi0J7pC
         TUcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XbE/IiUIEW5o7Z4MwXSn4tGipckljHwIwHeNPg/Be+A=;
        b=SwEwUYOAvrmB6lPQo+ry4Oel93Qj4VOHQ0us6bQch6IXlLv3gGSDKm0QmqZyWzi77/
         j7uPY/Ss4DeZfbcw61xWcn9lZ+wJYVKRduxklawQE6xV7OTlwZtQ4+IlwajzdCYEbPyG
         HBJcnW20911yfg6qznOo2DgcVruwY26f2KfdYRZO9pT7WClMSYrtT2pY6KaIHDTj3D+z
         4xtyPPXM4MPjg4EApQ8ZyKx8dAXz9flH+ytTuFxzXX9aqXF5IZpjLoAA2A2AHQxW+pOY
         qsKQQ8xhiv3negmOUhyVIsceI2BnzY6M/Ed25vXMTuW9EdEUlRdF13Z/z29UV2TLUPtt
         6PEQ==
X-Gm-Message-State: AOAM530UPXdKmjb7otBNZslAIybPiKv8yB8Sp/qR9nPB0bu1JlluAROf
        0bYlGj/aV0n7sVxdwrXxAAV5pxeqpQCG0A==
X-Google-Smtp-Source: ABdhPJwLxValTtWFQcMJE/gbtsBuvs6d8vlnY6riL5B1HvZ9hfZaZU77KD00fLKGPJZFXM4VzYG25Q==
X-Received: by 2002:a17:902:6f08:b029:d2:ab80:4ac4 with SMTP id w8-20020a1709026f08b02900d2ab804ac4mr4365611plk.72.1601508557302;
        Wed, 30 Sep 2020 16:29:17 -0700 (PDT)
Received: from [10.230.29.112] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z7sm3700421pfj.75.2020.09.30.16.29.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2020 16:29:16 -0700 (PDT)
Subject: Re: [PATCH net-next] net: dsa: Support bridge 802.1Q while untagging
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20200930203103.225677-1-f.fainelli@gmail.com>
 <20200930204358.574xxijrrciiwh6h@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <89404248-f8ea-b5f5-12c5-a19392397222@gmail.com>
Date:   Wed, 30 Sep 2020 16:29:13 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20200930204358.574xxijrrciiwh6h@skbuf>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/30/2020 1:43 PM, Vladimir Oltean wrote:
> On Wed, Sep 30, 2020 at 01:31:03PM -0700, Florian Fainelli wrote:
>> While we are it, call __vlan_find_dev_deep_rcu() which makes use the
>> VLAN group array which is faster.
> 
> Not just "while at it", but I do wonder whether it isn't, in fact,
> called "deep" for a reason:
> 
> 		/*
> 		 * Lower devices of master uppers (bonding, team) do not have
> 		 * grp assigned to themselves. Grp is assigned to upper device
> 		 * instead.
> 		 */
> 
> I haven't tested this, but I wonder if you could actually call
> __vlan_find_dev_deep_rcu() on the switch port interface and it would
> cover both this and the bridge having an 8021q upper automatically?

Let me give this a try.
-- 
Florian
