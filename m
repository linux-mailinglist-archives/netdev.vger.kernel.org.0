Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 077F7462D0F
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 07:46:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238791AbhK3Gtz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 01:49:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238795AbhK3Gty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 01:49:54 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0752C061574
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 22:46:35 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id o29so16502164wms.2
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 22:46:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=QNJ3t2LB0sVoFXWxdLfGbSoudvZqAR4Hf/OZxVoLW8g=;
        b=CTPzcDAFFzMDcTf10D1b0MkhNAXpcox4qEAnlhzyPZf2RrDe6yWNLySHOk/UIx2DPi
         yEgYI/uj4Ayf/E5FFSpfbxYWcWNs76l/K9OulOMXjbxDqaldlyaC8e81u/8xklykOX6m
         TmUEfBy4tOOKcR/N81SpaxDWQvpoWPnfK5k9LH1j7dDYXfeKnX0mRGu9F4xbEcVd+lEu
         LJjoIpe9XY5gtdPYLKbff07o+gKJJqBCESJFmXP1ZZ5R6FP2RCtRVP9RFCQmLeEuRdz1
         SbL+a0JzlHsYGLe/QSBfRhkLW3/1m490lj2swn0Cv3qKYmJwHkJ6mKawIoiOxRfOhlRC
         cnIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=QNJ3t2LB0sVoFXWxdLfGbSoudvZqAR4Hf/OZxVoLW8g=;
        b=XNkAlj3EWsY+iXgnObt9nQ/oJpiLmWDQARPxNsuYsKkFduNSNIDUGdUz+JhSGjC1TY
         f1JeD7BpAeWwZ1dBZdT8IWrfXHVaHxpWBFeXDJlTkRJeLu89ENgNck1h2qcjSbq4vLMh
         P6ZyoSXGqWsW5yXLWPWBT3mkGU12rTcJR4BcJmEA0i47ZCGbYuWuzRKYiTQwFibGWCsW
         WG1v5oVSNqbZDyGJD8WEZybPDkXX6V0DVhv+o5XlOzFUXc8J6TjLy5GOYlvVZC9K9yq7
         1Y1fFvwyioW5OMFZeJHinOO7LhGpp3MEwCalnY1VfPXc4xUUB4OeMWjUdPx77sNNYdOJ
         esSQ==
X-Gm-Message-State: AOAM531ELtCAlF56PE1HYJhBmmC6HY3vsVmvGH0SGCBbdhPBAraaQaM0
        ScpL8BZIHLpgRICzFGaSHOg=
X-Google-Smtp-Source: ABdhPJw+c4hM9/DCdQfJc6aOhvhbMHsdbwRZZC1Y7Z1T28cEaf4lRQ9m6jK3ppm+GJm+t5ZEn36hmA==
X-Received: by 2002:a05:600c:1f0c:: with SMTP id bd12mr2835941wmb.56.1638254794334;
        Mon, 29 Nov 2021 22:46:34 -0800 (PST)
Received: from ?IPV6:2003:ea:8f1a:f00:982e:c052:6f5c:d61f? (p200300ea8f1a0f00982ec0526f5cd61f.dip0.t-ipconnect.de. [2003:ea:8f1a:f00:982e:c052:6f5c:d61f])
        by smtp.googlemail.com with ESMTPSA id g18sm1658229wmq.4.2021.11.29.22.46.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Nov 2021 22:46:33 -0800 (PST)
Message-ID: <6edc23a1-5907-3a41-7b46-8d53c5664a56@gmail.com>
Date:   Tue, 30 Nov 2021 07:46:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>
References: <6bb28d2f-4884-7696-0582-c26c35534bae@gmail.com>
 <20211129171712.500e37cb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net] igb: fix deadlock caused by taking RTNL in RPM resume
 path
In-Reply-To: <20211129171712.500e37cb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30.11.2021 02:17, Jakub Kicinski wrote:
> On Mon, 29 Nov 2021 22:14:06 +0100 Heiner Kallweit wrote:
>> -	rtnl_lock();
>> +	if (!rpm)
>> +		rtnl_lock();
> 
> Is there an ASSERT_RTNL() hidden in any of the below? Can we add one?
> Unless we're 100% confident nobody will RPM resume without rtnl held..
> 

Not sure whether igb uses RPM the same way as r8169. There the device
is runtime-suspended (D3hot) w/o link. Once cable is plugged in the PHY
triggers a PME, and PCI core runtime-resumes the device (MAC).
In this case RTNL isn't held by the caller. Therefore I don't think
it's safe to assume that all callers hold RTNL.

>>  	if (!err && netif_running(netdev))
>>  		err = __igb_open(netdev, true);
>>  
>>  	if (!err)
>>  		netif_device_attach(netdev);
>> -	rtnl_unlock();
>> +	if (!rpm)
>> +		rtnl_unlock();

