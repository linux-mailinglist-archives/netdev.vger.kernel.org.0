Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71578151007
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 19:55:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729830AbgBCSzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 13:55:10 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:36365 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727275AbgBCSzK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 13:55:10 -0500
Received: by mail-ed1-f65.google.com with SMTP id j17so17215053edp.3;
        Mon, 03 Feb 2020 10:55:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YvFTqwttUds2c2yvPTgqGLHv6stUhae3AA7UWrn27bE=;
        b=sTymomBO4gc18ALWjRHGDNilTBSfXEaCFenpRQIVysmfe1A3YkDYBnlgLbg7lrTxhX
         CC7hK15W/mSbrw2GLLRPHqlghVdBQnZ9ZvwtdMbh5ypGGB3NddUo6KPcpBrl8fBMlHy5
         fjXF+A0TWzL2X9jIXSpTjma+NKMBsieH82Bc60967DvQ6e5GVxw4rQOAmchq2/iA8HbH
         Izlh7dWL7PqAJUG146UvEGxOp7/3UlHs0imqZLm3351XX/zgQZDLjBDKtxa2Mvn2SAvb
         PddZ5yacbrPMnWHxPDtetVY39U6AtkknuXCkkyR8EUDOyPzVkKxi47lnv4sdxq4wsnbO
         bq9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=YvFTqwttUds2c2yvPTgqGLHv6stUhae3AA7UWrn27bE=;
        b=B7ABpb86uXRn2W8SmnZX+YrCF3kDu2CRb+J0BRalWyyWbfoMgflvlY2yXPpbX4UBrY
         +iS2d3AvTepECOs1ydn8cl/FE5mxNlZMNlaomHhkXNvXlnq7+QCOZ13mSVRkimTZbSJa
         1R7tj4bhfM5x83qDip8BSN5iZrDmnJDVNJsZDBSDqZaZ6oWl3VzND+zWRxy4/04t7/wF
         j5lRMbKNqPFTsFyWitYC16S0iiy+Oi/62BcVEgUItf28NPM6SiH4qMEVvY3IvOMwMHhG
         qjS/npIncan7/OjdnnoCZd7ySkcskp7q0VWlfTwKDP6cuLne07PuZ4CCxVxG7LkTDaj/
         BvVw==
X-Gm-Message-State: APjAAAWrticeXqdGz72leH2VZ+sjSZB13tDs88zw0/XFyBrfrofZaNSs
        j/BkIDHdNLGknC8sdUiZ4+w=
X-Google-Smtp-Source: APXvYqwUTBvHvHJHLXo6Hr1QstVoP5x3F7pytM2061GpvLIb2x1wFn9PyjpX2e3efLVEHnNzGOKwJg==
X-Received: by 2002:aa7:c241:: with SMTP id y1mr13967518edo.354.1580756107809;
        Mon, 03 Feb 2020 10:55:07 -0800 (PST)
Received: from [10.67.50.115] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id b18sm718064eds.18.2020.02.03.10.55.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Feb 2020 10:55:07 -0800 (PST)
Subject: Re: [PATCH 2/6] net: bcmgenet: refactor phy mode configuration
To:     Jeremy Linton <jeremy.linton@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, opendmb@gmail.com, davem@davemloft.net,
        bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org, wahrenst@gmx.net,
        hkallweit1@gmail.com
References: <20200201074625.8698-1-jeremy.linton@arm.com>
 <20200201074625.8698-3-jeremy.linton@arm.com>
 <b2d45990-af71-60c3-a210-b23dabb9ba32@gmail.com>
 <20200203011732.GB30319@lunn.ch>
 <1146c2fa-0f43-39d2-e6e0-3d255bfd5be3@gmail.com>
 <0d743b51-fd77-db8c-1910-c725c4b2e7b9@arm.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 G10n8gCguORqNGMsVRxrlLs7/himep7MrCc=
Message-ID: <fdb6d522-f207-f002-5d71-8fa541bd745e@gmail.com>
Date:   Mon, 3 Feb 2020 10:55:02 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <0d743b51-fd77-db8c-1910-c725c4b2e7b9@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/3/20 10:46 AM, Jeremy Linton wrote:
> Hi,
> 
> On 2/2/20 9:24 PM, Florian Fainelli wrote:
>>
>>
>> On 2/2/2020 5:17 PM, Andrew Lunn wrote:
>>> On Sat, Feb 01, 2020 at 08:24:14AM -0800, Florian Fainelli wrote:
>>>>
>>>>
>>>> On 1/31/2020 11:46 PM, Jeremy Linton wrote:
>>>>> The DT phy mode is similar to what we want for ACPI
>>>>> lets factor it out of the of path, and change the
>>>>> of_ call to device_. Further if the phy-mode property
>>>>> cannot be found instead of failing the driver load lets
>>>>> just default it to RGMII.
>>>>
>>>> Humm no please do not provide a fallback, if we cannot find a valid
>>>> 'phy-mode' property we error out. This controller can be used with a
>>>> variety of configurations (internal EPHY/GPHY, MoCA, external
>>>> MII/Reverse MII/RGMII) and from a support perspective it is much easier
>>>> for us if the driver errors out if one of those essential properties
>>>> are
>>>> omitted.
>>>
>>> Hi Florian
>>>
>>> Does any of the silicon variants have two or more MACs sharing one
>>> MDIO bus? I'm thinking about the next patch in the series.
>>
>> Have not come across a customer doing that, but the hardware
>> definitively permits it, and so does the top-level chip pinmuxing.
>>
> 
> Does the genet driver?
> 
> I might be missing something in the driver, but it looks like the whole
> thing is 1:1:1:1 with platform dev:mdio:phy:netdev at the moment. Given
> the way bcmgenet_mii_register is throwing a bcmgenet MII bus for every
> device _probe().

Andrew's question was hypothetical, and I answered it the best way I
could. I did not say this was a *currently* supported combination from a
software perspective or that it would work today, but the hardware would
allow it. This question probably belongs to patch #3 which is about
using (or not phy_find_first).
-- 
Florian
