Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D97EF301958
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 04:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbhAXDZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 22:25:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726375AbhAXDZS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 22:25:18 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA4A4C0613D6
        for <netdev@vger.kernel.org>; Sat, 23 Jan 2021 19:24:37 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id n10so6611188pgl.10
        for <netdev@vger.kernel.org>; Sat, 23 Jan 2021 19:24:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1wZmFd+UTw7qSlBsCJ6JeXgwuSkwf74vQ3ga3KxG68c=;
        b=XxaILu0AWARgOu12SrpUrwfF6bwaZEpDGpbHMuULvxiM5nr15w3ScUvDdvjtRPCxsO
         PZrZ6FJBZvB8Q2ifP1adlzTH0MrhaUh85RcwOSyotZcTBWZ/fsmIcFM2XjYQqoqlDB9p
         YxhsaL1r28zCRGUr5wMiUbVk2K/3OwCu+IjE30fFI+kxZQBMPipx24mYDEY3uaFteKds
         Ek/2mtUmbzbToIDt/DHm/EcjNBJ5M/GUMn4LuELQrdtMk1IRbzCkKwtAkBfR8XMevSXy
         1qiW3Juo2bs9iSZwjU7IaEhZfQ9ttPAgdKXhVxmU6FSJscbcjbb6fMUo+q7qRyap2w6V
         TiqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1wZmFd+UTw7qSlBsCJ6JeXgwuSkwf74vQ3ga3KxG68c=;
        b=ftHLpE6T0ftWlGTwUTjRFv7EwBX9H9Wp/hNily6QL5B0Z2cylPInscAOtR5zAZVasZ
         WtXkiP4pgtaiwn5Q7zj0YLpV2C9QTZbruDwy4tbtvpsnf1z717V1tvf/X9zNk/VNVW0K
         7qZHn8/g4jgbW8L5dBc/LaHwi+RZ/im6YIILx7kxU4rV9PPF+X1397X/k+nZr15BJ9QX
         Ld8bDV+NzMKEsPEta3B/zZoSbhAHX6xqO0fJeRjV8YRUYin4RRCgDjEazEJ0LJDBxBsP
         vdG2ZhITUlCpfg34SKiMLSSnZU5Xk3vi29ca0xGmGWCfTje6+0LMcaoSa3Ix9Dun/Z0X
         OONg==
X-Gm-Message-State: AOAM5309xAQpINOKjErc9R8f9dbDQX53YcAkTBduwNfokJV+BGOS/6jJ
        vZrWq0PXPh9q6B7yNt50P6s=
X-Google-Smtp-Source: ABdhPJzrhlCDdRCj8uwX/PhzECpn0m+xh021GUjSLU1rbEwrcA5pa45+9fJH04rgkN7wSftB8t3ZVw==
X-Received: by 2002:a63:1602:: with SMTP id w2mr12477379pgl.128.1611458676997;
        Sat, 23 Jan 2021 19:24:36 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id m4sm12657450pfa.53.2021.01.23.19.24.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Jan 2021 19:24:36 -0800 (PST)
Subject: Re: [PATCH] dsa: mv88e6xxx: Make global2 support mandatory
To:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        tobias@waldekranz.com
References: <20210123205148.545214-1-andrew@lunn.ch>
 <20210123190637.42dad133@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <234a7b27-da8b-b224-26f7-d8ff1c03b10a@gmail.com>
Date:   Sat, 23 Jan 2021 19:24:34 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210123190637.42dad133@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/23/2021 7:06 PM, Jakub Kicinski wrote:
> On Sat, 23 Jan 2021 21:51:48 +0100 Andrew Lunn wrote:
>> Early generations of the mv88e6xxx did not have the global 2
>> registers. In order to keep the driver slim, it was decided to make
>> the code for these registers optional. Over time, more generations of
>> switches have been added, always supporting global 2 and adding more
>> and more registers. No effort has been made to keep these additional
>> registers also optional to slim the driver down when used for older
>> generations. Optional global 2 now just gives additional development
>> and maintenance burden for no real gain.
>>
>> Make global 2 support always compiled in.
>>
>> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> 
> FWIW doesn't seem to apply to net-next.

Andrew, when you resubmit, can you make the subject be: net: dsa: ... to
be consistent with prior changes? Thanks!
-- 
Florian
