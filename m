Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6F552316D2
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 02:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730735AbgG2Aew (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 20:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730535AbgG2Aev (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 20:34:51 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC5E2C061794
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 17:34:51 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id f9so1133649pju.4
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 17:34:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vGfvVYAeGjMRxrRCFvaDDy0Z8UyQZ16TbWNd/iXSsrQ=;
        b=QyAAPs2Fc/H/w1PBlOofYT+zRA5qa4bA923hmxV8WgmWJ4Wsjzrg6kZd7xM5VuU+uK
         iFZvQMs5umyoYTeB8cbGyyNIFoXQRBqhLxwGoBlrISSRhMRd077VKMp3ytAdU6cO7ZLq
         PbG0uWIdXdxV0DML/QFR9RUX2nr9cnLw15cstd0rR7zlMf+lkppjYQZxMa7RDZrT9JtF
         +I7jTyrJEOMrp0C2lzenuDmlZPl117pW1NBS1ppaZW+ChafN7n8oiaETAIH5A86HLLe4
         nOxb6xh5l8kH48o+v0z7cykrp3ZLLoAF9I09/UaSTRTMs1aexrX6VGOJjKpMScVDU8yV
         fUUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vGfvVYAeGjMRxrRCFvaDDy0Z8UyQZ16TbWNd/iXSsrQ=;
        b=Y9Y83e+icJH0kupSukq6c2ia6321iVOPmC64JEswRqpOO06esEd88BHTs/l9dPVCYw
         4iOCsb/lKraAcMy3hX7UN62W2nG3Ix0Jz2LVVc2GZlNf4KMER/EKusirPFz8KqIbbMpA
         DQeG7Z3tdhUBGyM4b24IUHglmb/76VMdUXFeLBDTGO7bbOF1puzNMXX9ehB5fAaXVkkn
         MVwNnDLzkqwVBJdNVFJOE2XretcYRieNG8D+vU58jnbS12zWxaSTdP/+bTL5FLHgi0iG
         6xfh0668TKSRu08ejQiK/B9smb04aPjF7JEDgR4MPonqtSpo5tly9LAGyAinR0fZatYz
         WCBA==
X-Gm-Message-State: AOAM530AKFS4va7k95nTOGK57lIIv/meB6t7mFFMbq3tL4B+kyY3l5UQ
        gzY3WSPacfeAZpEK9mw8pxg=
X-Google-Smtp-Source: ABdhPJwbDZSJAhuYVb0SyCP76ns2YmoSAU9riEypVkQo7l8p+KHK4ps3hV2azwR02uzijplZM6npHQ==
X-Received: by 2002:a17:902:547:: with SMTP id 65mr24936355plf.191.1595982891288;
        Tue, 28 Jul 2020 17:34:51 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k92sm243477pje.30.2020.07.28.17.34.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jul 2020 17:34:50 -0700 (PDT)
Subject: Re: [PATCH RFC net-next 0/3] Restructure drivers/net/phy
To:     Doug Berger <opendmb@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>
References: <20200727204731.1705418-1-andrew@lunn.ch>
 <VI1PR0402MB3871906F6381418258CC7AEBE0730@VI1PR0402MB3871.eurprd04.prod.outlook.com>
 <20200728160802.GI1705504@lunn.ch>
 <VI1PR0402MB38714D71435CC4DF99AE5A20E0730@VI1PR0402MB3871.eurprd04.prod.outlook.com>
 <1c484c7b-1988-20dc-9433-3f322e81280c@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <410daead-6956-bb9b-da35-53b93daa6c46@gmail.com>
Date:   Tue, 28 Jul 2020 17:34:44 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1c484c7b-1988-20dc-9433-3f322e81280c@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/28/2020 5:28 PM, Doug Berger wrote:
> On 7/28/2020 9:28 AM, Ioana Ciornei wrote:
>>> Subject: Re: [PATCH RFC net-next 0/3] Restructure drivers/net/phy
>>>
>>>> I think that the MAINTAINERS file should also be updated to mention
>>>> the new path to the drivers. Just did a quick grep after 'drivers/net/phy':
>>>> F:      drivers/net/phy/adin.c
>>>> F:      drivers/net/phy/mdio-xgene.c
>>>> F:      drivers/net/phy/
>>>> F:      drivers/net/phy/marvell10g.c
>>>> F:      drivers/net/phy/mdio-mvusb.c
>>>> F:      drivers/net/phy/dp83640*
>>>> F:      drivers/net/phy/phylink.c
>>>> F:      drivers/net/phy/sfp*
>>>> F:      drivers/net/phy/mdio-xpcs.c
>>>
>>> Hi Ioana
>>>
>>> Thanks, I will take care of that.
>>>
>>>> Other than that, the new 'drivers/net/phy/phy/' path is somewhat
>>>> repetitive but unfortunately I do not have another better suggestion.
>>>
>>> Me neither.
>>>
>>> I wonder if we are looking at the wrong part of the patch.
>>> drivers/net/X/phy/
>>> drivers/net/X/mdio/
>>> drivers/net/X/pcs/
>>>
>>> Question is, what would X be?
>>>
>>>    Andrew
>>
>> It may not be a popular suggestion but can't we take the drivers/net/phy,
>> drivers/net/pcs and drivers/net/mdio route?

+1
-- 
Florian
