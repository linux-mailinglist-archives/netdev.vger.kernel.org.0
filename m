Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0C6217A22
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 23:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728901AbgGGVRs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 17:17:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728663AbgGGVRs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 17:17:48 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B069C061755
        for <netdev@vger.kernel.org>; Tue,  7 Jul 2020 14:17:48 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id s10so46730384wrw.12
        for <netdev@vger.kernel.org>; Tue, 07 Jul 2020 14:17:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8+RPmnPHvbLQIdPl3oh6Z+ou1fVhYtOa2CUyLJXjRJs=;
        b=vQ+P64e4Q3Y0tvD3ndKVLINr9h6Jy+mcgWZZdfimnRhbMjhdMCGRfkS/OVb/4PuBgF
         G5aY8juE/2nDfPCzetiW9YUHX+jDRESwiEuThqKbwPy1Vzdq0c57zqz165qYHNrmY4ld
         ilnwMm4S/IktuDxOAGHndZ2QwNOzUPf57IZrJGYANdDUfyCqKMCzcJLpbYq0tXOgDzA1
         WtUNHec6DCU4E9sCGFPtt4SLuLjkYfDN5boOzql6VYjPO0w1t1vymj88C1VkYmLVaOzn
         aytuZhb2U1DA9dSNopibhpNEEs9KbZ8Zz76NKl1b4dW0l7M7qUIfO72WUrLI64H56j2E
         hUDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8+RPmnPHvbLQIdPl3oh6Z+ou1fVhYtOa2CUyLJXjRJs=;
        b=DlHSWfd8uEs70XZyxqPKXZbYbP4yjJuGfK5IYnyZUp2wuwM4ko5wlVWzTVvJ9VJUQE
         mgCJ07FZdZ0aeYSxh8QCm85s+9/bOWnZeehgFubP7bPoN7MOBAoEXfG0NzKYV6NuAGha
         B0K46r7FlpCT1RFh5Ma2EczUT1t9kSdhqBCYhPs10DIOs4RMILEsudUQEtRncq9SKh96
         NNZF1ujiQi8dwUOiCKNGsJO80n2QEKa8O0ynUvPffV7+Azh41UB9l3KtQCh/mkmgxIRt
         xEjFfXI+tnAK9Cw2qjmeX6p3P7maupQWYGTYgnFkXQNMTtv2NiQjP6AiH05VxHELMIyV
         veJg==
X-Gm-Message-State: AOAM531y/zDSFIZTyHOGz88RFbldK5elRSvw+ih6GtI0KAFbpMHhZj9P
        Z+EKJ5IyxdrngB9GC1KLlp5YraY0
X-Google-Smtp-Source: ABdhPJyipBanFxs8uneRXiBGvyVxfX5N7RXifejZlebBT7/4lbxacVsmQ3u+mukMBAWiHUHtW/CI5g==
X-Received: by 2002:adf:e38b:: with SMTP id e11mr54839326wrm.65.1594156666489;
        Tue, 07 Jul 2020 14:17:46 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id u20sm2376550wmm.15.2020.07.07.14.17.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jul 2020 14:17:45 -0700 (PDT)
Subject: Re: [PATCH] amd-xgbe: add module param for auto negotiation
To:     Shyam Sundar S K <ssundark@amd.com>, Andrew Lunn <andrew@lunn.ch>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
References: <20200707173254.1564625-1-Shyam-sundar.S-k@amd.com>
 <20200707175541.GB938746@lunn.ch>
 <a9e5c55f-55cf-439e-30aa-6cf70e44dffd@amd.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <a75c0af6-d9da-32ee-6f5b-efade9fc3cfd@gmail.com>
Date:   Tue, 7 Jul 2020 14:17:42 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <a9e5c55f-55cf-439e-30aa-6cf70e44dffd@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/7/2020 12:01 PM, Shyam Sundar S K wrote:
> 
> On 7/7/2020 11:25 PM, Andrew Lunn wrote:
>> [CAUTION: External Email]
>>
>> On Tue, Jul 07, 2020 at 05:32:54PM +0000, Shyam Sundar S K wrote:
>>> In embedded environments, ethtool may not be available to toggle between
>>> auto negotiation on/off.
>>>
>>> Add a module parameter to control auto negotiation for these situations.
> Hi Andrew
>> Where does this end? You can set the link speed via module parameters?
>> Pause? Duplex?
>>
>>         Andrew
> 
> Agree to your feedback. Most of the information required to control the
> connection is already present in the
> 
> driver and this piece of information is missing. Customers who run a
> minimal Linux do not have the flexibility
> 
> to add userspace applications like ethtool to control the connection
> information. Please consider this as expectional

You do not need to have the ethtool application proper, you can have a
small binary that only implements the right amount of ioctl() (or now
netlink) interface so as to restart or disable auto-negotiation. We are
talking about ~200 LOCs or something along those lines.
-- 
Florian
