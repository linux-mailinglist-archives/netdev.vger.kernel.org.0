Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45F9614F67A
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 05:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbgBAE5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 23:57:18 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:45406 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727039AbgBAE5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 23:57:17 -0500
Received: by mail-pl1-f193.google.com with SMTP id b22so3610327pls.12;
        Fri, 31 Jan 2020 20:57:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EEbkdoC4Qq9zv44RujCsO0gXYN6YVpJYXDntTZweWtE=;
        b=QxwY8XNrnxJYlVy+wiepUO4L+hNBWWXPCT6HPsk4aQiUBnO5PHI4XmG5eetzVOI7FJ
         dZn/m0UjhNpTKOpSsyXtGTEAc+yVm30/3izzS1RwxQNJpZDaEYGYRVH5x2xlhkSwqy5R
         qcbXxjocatu/3zXp4Hriw2mExpGn9WX1lOH3+P1QLmBEsnXBLX7BYA2H5Lbqmkhkz5s0
         KgYx/Du3GZFKIbk+9LJtNqa+JUVM1SFLMPQgxF1OLmbtDnyeEZkS2p/6VbFkKrG9N/K5
         40Nd/SnFEsTr5PHYXkLx/BYhBHbbxR+Nye1xLSGcTE9Ir0CMNcSqQhyJsuYq2FUIarew
         XLiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=EEbkdoC4Qq9zv44RujCsO0gXYN6YVpJYXDntTZweWtE=;
        b=OcQvkD8uSyn6EpcAQfp8kZhhkioxSkPZ20ndNHcEmpKpvNKTnyrA0ZEqUJdUiRe4Qz
         e4HxBaImQIMuskmg8JwnhxeV5ZP7DqxHBvD37OHC/ET9vmVPFKSupbeSeGBjyIkuGxaD
         XPED1ULnWsTK0+h0WT2BIMEMaNZV4W7vTxYuXZAnps7emJdStmQ6mnSXRvz2zYmf/Tkd
         R29HtXzB2XbzK6SBBpmbQnUEEZxY3c2L7I0dC7cfi13xHhD8nX6oXfcBOslrJLcFOBj0
         FVlP4R9jY3tTLmPuuF7QZY8Sw9Zrel7Llkq7d5c4cjG/nGbGr3iCksVUbMSth6Ypromq
         61Nw==
X-Gm-Message-State: APjAAAWG+S7ET0W3fVeLZRXVSD8MKAgDXaYNpGhityl36CCcRsLxRLkc
        h7hnyaZItnkckSJWxF2YVsU=
X-Google-Smtp-Source: APXvYqz6kEGd8castAX7cPqYJcmta9uYhoqSIAdICwQUXZPMm8wHSIdVlIWRWSoZ+iiBujRpIuLkWw==
X-Received: by 2002:a17:90a:f84:: with SMTP id 4mr16771215pjz.74.1580533036924;
        Fri, 31 Jan 2020 20:57:16 -0800 (PST)
Received: from [10.230.28.123] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t187sm12332098pfd.21.2020.01.31.20.57.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jan 2020 20:57:16 -0800 (PST)
Subject: Re: [PATCH net-master 1/1] net: phy: dp83867: Add speed optimization
 feature
To:     Dan Murphy <dmurphy@ti.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, andrew@lunn.ch,
        bunk@kernel.org
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, grygorii.strashko@ti.com
References: <20200131151110.31642-1-dmurphy@ti.com>
 <20200131151110.31642-2-dmurphy@ti.com>
 <7e8080f7-3825-98f5-2465-c536ecbb8146@gmail.com>
 <27ab4feb-fe84-4d3b-1779-25a25065a9fa@ti.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 a9BQwACgnzGuH1BVeT2J0Ra+ZYgkx7DaPR0=
Message-ID: <2116231e-2373-6511-da06-32ea01266b49@gmail.com>
Date:   Fri, 31 Jan 2020 20:57:14 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <27ab4feb-fe84-4d3b-1779-25a25065a9fa@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/31/2020 5:30 PM, Dan Murphy wrote:
> Heiner
> 
> On 1/31/20 2:56 PM, Heiner Kallweit wrote:
>> On 31.01.2020 16:11, Dan Murphy wrote:
>>> Set the speed optimization bit on the DP83867 PHY.
>>> This feature can also be strapped on the 64 pin PHY devices
>>> but the 48 pin devices do not have the strap pin available to enable
>>> this feature in the hardware.  PHY team suggests to have this bit set.
>>>
>> It's ok to enable downshift by default, however it would be good to
>> make it configurable. Best implement the downshift tunable, you can
>> use the Marvell PHY driver as reference.
>> Can the number of attempts until downshifts happens be configured?
> 
> Yes we can tune the number of attempts it makes to negotiate 1000Mbps
> before enabling the speed optimization.  But why would we need to
> configure the number of attempts currently it is defaulted to 4.  Is
> there a use case for this level of configurability?

Some customers may prefer a fast(er) link re-negotiation once they know
the cabling is faulty or sub-optimal. The default is usually fine, and
if you want to support the downshift ethtool tunable when net-next opens
back up, that would be a welcome addition.
-- 
Florian
