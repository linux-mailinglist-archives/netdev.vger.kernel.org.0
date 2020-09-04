Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACA3925D01A
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 06:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726114AbgIDEAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 00:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbgIDEAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 00:00:18 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D7AEC061244;
        Thu,  3 Sep 2020 21:00:17 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id d22so3884455pfn.5;
        Thu, 03 Sep 2020 21:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XMFEvqETbtFJPv2+OGPaMexSGTcaNeluPDMod6iYHAQ=;
        b=LivGR0bVhFREqzlrqnvlXldl+u7i+2YHwVAMsmK3mVu5yd8VGGTzNL5N9eCUrzUzAl
         QNgALXD0+LV8Yelg4AuntA/GNHsA91E53A/P/KTU1y+6IMB0kmSfJzNjXPTRX4UOWG4d
         pswGlvQsUGIEGxMkvGkjSVTlSzgXpUiq0NZ0l0psWuLsBJWFCXl8jMgIhmeGsTyDZXBT
         2zQHlVM+k02bpZvMrFp01bGi6gRrwdAIMKQVavpzlOqTSXv2/VDLBK/Vgyl21npTP/YI
         P0Qdpz+8goCA8fRkvAReq1lhznkJUInnCgVz19WjdZLkU7W9RBupXA+7HJbd/uCbVKfe
         xoUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XMFEvqETbtFJPv2+OGPaMexSGTcaNeluPDMod6iYHAQ=;
        b=iBSWyWswcw9B48GI904Q4Kz3Njxuenbjn/Npm+07LlYvQ5vjF6J11aU+SGcO0pcoMN
         jaAvS68FXTfS0vHbXvZl2bw4mkyd3JQJypruuRgUdjzCG2my1JR0mohHB07ogIQs8rIx
         aTC7ZV+T6ZCxGf9/7OiYMpYdEStAhovFgNzVXDL1WPUQBNDD9l0WeX0d3nYU1EUk9EKy
         D9cpojRFJUzQ4J0CAxO41w9E+fTNH8o33iKpBPMEyeo7JNL4EgQ/HzICV83ODUZ2wYE8
         VgQYzRtY/bfMeuKOBa3ziLeZTk3U9jeGDUhYvyeySAMvCvmz8pqo6px0QKnGv+gFsWj2
         gyqw==
X-Gm-Message-State: AOAM533kTaHGnp0mji2fG6G4SIpstfcQUjcuQhbZSBEr1EjL3Ip4S2nJ
        +vsRuXfQx0z1maL2LtUMGjohKZDZeos=
X-Google-Smtp-Source: ABdhPJw63k5HRpzcCRjJ856JUHctr8zFE0JxXvdbdai8EeWZnKchPlwzUU2N+bAzatluHtVJmPjzNg==
X-Received: by 2002:a63:595a:: with SMTP id j26mr5785667pgm.406.1599192016036;
        Thu, 03 Sep 2020 21:00:16 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id n26sm4774618pff.30.2020.09.03.21.00.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Sep 2020 21:00:15 -0700 (PDT)
Subject: Re: [PATCH net-next] net: dsa: bcm_sf2: Ensure that MDIO diversion is
 used
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20200902210328.3131578-1-f.fainelli@gmail.com>
 <20200903011324.GE3071395@lunn.ch>
 <28177f17-1557-bd69-e96b-c11c39d71145@gmail.com>
 <20200903220300.GH3112546@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <4cf621da-c917-bd4c-6d30-e8f145a24628@gmail.com>
Date:   Thu, 3 Sep 2020 21:00:13 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <20200903220300.GH3112546@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/3/2020 3:03 PM, Andrew Lunn wrote:
>> The firmware provides the Device Tree but here is the relevant section for
>> you pasted below. The problematic device is a particular revision of the
>> silicon (D0) which got later fixed (E0) however the Device Tree was created
>> after the fixed platform, not the problematic one. Both revisions of the
>> silicon are in production.
>>
>> There should have been an internal MDIO bus created for that chip revision
>> such that we could have correctly parented phy@0 (bcm53125 below) as child
>> node of the internal MDIO bus, but you have to realize that this was done
>> back in 2014 when DSA was barely revived as an active subsystem. The
>> BCM53125 node should have have been converted to an actual switch node at
>> some point, I use a mdio_boardinfo overlay downstream to support the switch
>> as a proper b53/DSA switch, anyway.
> 
> I was expecting something like that. I think this patch needs a
> comment in the code explaining it is a workaround for a DT blob which
> cannot be changed. Maybe also make it conditional on the board
> compatible string?

It is already targeted at the Broadcom pseudo PHY address (30) which is 
the one that needs diversion, I will update the patch description 
accordingly though.
-- 
Florian
