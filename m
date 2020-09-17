Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03AD926E0C9
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 18:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728563AbgIQQdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 12:33:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728359AbgIQQcH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 12:32:07 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C66B3C06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 09:32:06 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id u9so1411046plk.4
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 09:32:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=T50BXHTsMxY1BXgJYVOqihQD0a/bg+J/15Vehb5M1Pw=;
        b=kNVCPSIiPbB0FqFpVPOthcnRh+WymznM1jMTsizqteXXBYLf5aftOuDYOBd33c2kTk
         ktS8I3G2zVhTFnnWlL4zq2l1AUCQHnb7cNbfRnYmDMSML+I9NFN4rOv0jc9s7mMhIWuY
         qH1ga5ykro9duHYJKVC8OYsjDnV6mmLOcNNcMHdwNrDiwSNQBP1UFGMIQ/AY3NBmQyi2
         MQwFkfvsBcQfm3PTFeipG2OnhBt3CrjlsKFfahfq89hq+13J0eGkOS1e+GVjD7mIR2+8
         eS+k90G5JH4YmZf91cBFWyYnM68gLVJYXqjHtuw5Qxy3s9oNq6TCNBey73B3ZXwfYd3G
         eUdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=T50BXHTsMxY1BXgJYVOqihQD0a/bg+J/15Vehb5M1Pw=;
        b=lEciwDkiIUBjIBe8CJqLlHUaHKLh7qUt5ikz+OoMgzRA2Yqq7NWcPz72khxpakad54
         NPBNomnlXR2Wqphzgl9t68Sph+PgDVsGMMhXYoroKOs0Ji2t8uGT8XDPCE0/f+1qhMBT
         +hMV7vJEvEGlfEfjC7iFOg9Nzh8ialYUKljedjICzxCRo4IFeJQN+ihjwuhyryv8Hje4
         mp2bfPXOlSUjgdJYZmSR+L5orUA/SUgrotj90dpM+/zTGkbTwwiLXtiNOeNKqpmKJ0ZR
         TOdcT+3AGitvXxfgKmln9WzEGM3T2PVqKeKBxHhvjpd0z6LMgYbQOdr8VqYVHqZGWNRV
         vx4w==
X-Gm-Message-State: AOAM533YcEKyfj1XK6AZnItKDetatXRxTFbQxAtugjOJwROrw8fwngub
        g1qJLEafYAh/aUWQkiAUVzs=
X-Google-Smtp-Source: ABdhPJzQuDGnOMRmq6N6x61Ut2n4lQph9UTuSheQo63mxcwansGscoXRqbc//rCce04g0wx9lRrGQA==
X-Received: by 2002:a17:90a:d997:: with SMTP id d23mr9447184pjv.171.1600360326176;
        Thu, 17 Sep 2020 09:32:06 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id i9sm107720pfq.53.2020.09.17.09.32.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2020 09:32:05 -0700 (PDT)
Subject: Re: [PATCH net 1/2] net: phy: Avoid NPD upon phy_detach() when driver
 is unbound
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, hkallweit1@gmail.com, kuba@kernel.org,
        davem@davemloft.net
References: <20200917034310.2360488-1-f.fainelli@gmail.com>
 <20200917034310.2360488-2-f.fainelli@gmail.com>
 <20200917131545.GL3526428@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b33da0da-4c6a-ae11-b77e-93d014a90123@gmail.com>
Date:   Thu, 17 Sep 2020 09:32:03 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200917131545.GL3526428@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/17/2020 6:15 AM, Andrew Lunn wrote:
> On Wed, Sep 16, 2020 at 08:43:09PM -0700, Florian Fainelli wrote:
>> If we have unbound the PHY driver prior to calling phy_detach() (often
>> via phy_disconnect()) then we can cause a NULL pointer de-reference
>> accessing the driver owner member. The steps to reproduce are:
>>
>> echo unimac-mdio-0:01 > /sys/class/net/eth0/phydev/driver/unbind
>> ip link set eth0 down
> 
> Hi Florian
> 
> How forceful is this unbind? Can we actually block it while the
> interface is up? Or returning -EBUSY would make sense.

It it not forceful, you can unbind the PHY driver from underneath the 
net_device and nothing bad happens, really. This is not a very realistic 
or practical use case, but several years ago, I went into making sure we 
would not create NPD if that happened.
-- 
Florian
