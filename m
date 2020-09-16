Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05D5726B65A
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 02:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727391AbgIPADJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 20:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727353AbgIPADF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 20:03:05 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ED93C06174A;
        Tue, 15 Sep 2020 17:03:05 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id d19so2190481pld.0;
        Tue, 15 Sep 2020 17:03:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/9YC3jzxgXrgHNvLV2DgKLu9vRPOEeUndPKkcJPjDSI=;
        b=jf9mDfg00fVj/EphFCM3fHgNMnH5rlkZ88FTfEbdsiXbD3jHObKr2feFEkpxgSqHgM
         w8xtcPHIrz5QxSdbj68FYVkzfR6KXWRiXFiu3RqGA4lkgv8z+iENnMEf5h2UPCdcbY41
         de6Urh5A4PvZ9ztobefpx8bA0PsGBQ4Yl+JMjPiJblHEEsBSq2CLiRzEURv0W5jXdMes
         gDmvm5JB+JRMI1bFPWDQ7Q9TdJ9U7fF2WPm6Z3rCPM+IaPBFqxWMjgBUnkWLclRI8z7O
         Kx40EhJyj6I7q9wINksgDQIIuUz8aXeiSY9riKg+FKD+c1Ul1Cl/u7lwNYnG0uJamBoy
         xagw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/9YC3jzxgXrgHNvLV2DgKLu9vRPOEeUndPKkcJPjDSI=;
        b=QOIrdmnAt7pUxFLsR+wLFXpeyKpRX5A7NTzFnjN6F+Ibx4ALEebXhiKpctyCDfx3iy
         1ZKZzQ0Nvr/3GnnT5uC0+PU94Ru0xa5F+rbMCgSMhb2X/p35528kVe8gDZ6/BdFZMJhm
         VuTo+J5gYkp6Gnr/twhGnExRtFHtqaUrj37l/LNPOT1PDb3ohlhsJygq9VdfLw0fKuh4
         fXq1GUUNwv56/lcsaTQxLcDkbfPeMMv3M50E0y2u91rcmPOA9ZwUszlrxpTxBw+w7P5b
         wPv+B2xmQKTJk1jHmHTCb/op9OJTX0TqnfOVDqzfrKcPZqiDToJ/MqSL/uKPd+oaBqeo
         jQKg==
X-Gm-Message-State: AOAM533MPKiWx0EG8v38nfiXRXFjLBcJBoUYpq5Qpr1xhlOVeO4t8PYL
        e5L0Cu89F/wiCGEFk+uc1lM=
X-Google-Smtp-Source: ABdhPJwXZLREEPePNQ09vlrQA/w6bnVK1+xr2DoofOoKKiFD/yJFWzHp7fSEVmNoHeMMrfNyXMrCgw==
X-Received: by 2002:a17:90a:db0f:: with SMTP id g15mr1569754pjv.145.1600214584632;
        Tue, 15 Sep 2020 17:03:04 -0700 (PDT)
Received: from [10.230.28.120] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o17sm12100848pgb.46.2020.09.15.17.02.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Sep 2020 17:03:03 -0700 (PDT)
Subject: Re: [PATCH net-next 0/3] net: stmmac: Add ethtool support for get|set
 channels
To:     "Wong, Vee Khee" <vee.khee.wong@intel.com>,
        David Miller <davem@davemloft.net>
Cc:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Joao.Pinto@synopsys.com" <Joao.Pinto@synopsys.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "Voon, Weifeng" <weifeng.voon@intel.com>,
        "Vijaya Balan, Sadhishkhanna" <sadhishkhanna.vijaya.balan@intel.com>,
        "Seow, Chen Yong" <chen.yong.seow@intel.com>
References: <20200915012840.31841-1-vee.khee.wong@intel.com>
 <20200915.154302.373083705277550666.davem@davemloft.net>
 <b945fcc5-e287-73e2-8e37-bd78559944ab@gmail.com>
 <BYAPR11MB287046044CA144193135B0E7AB200@BYAPR11MB2870.namprd11.prod.outlook.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <16a0dc9e-4e08-6d71-6be4-13c2fc8c53dd@gmail.com>
Date:   Tue, 15 Sep 2020 17:02:54 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <BYAPR11MB287046044CA144193135B0E7AB200@BYAPR11MB2870.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/15/2020 4:59 PM, Wong, Vee Khee wrote:
> My bad...
> 
> Hi David Miller,

(please don't top post)

> 
> Can you help with the commit message fix or do you want to to send a new patch with the fix since the patches are applied on net-next?

It has already been applied, so this is too late, just telling you so 
you can avoid it next time. And it should be part of David's CI while 
applying patching, too.
-- 
Florian
