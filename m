Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6ACB201A94
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 20:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387574AbgFSSmU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 14:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732225AbgFSSmT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 14:42:19 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4649FC06174E;
        Fri, 19 Jun 2020 11:42:19 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id q2so8214648wrv.8;
        Fri, 19 Jun 2020 11:42:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MNm1CnwZrFO2mvjUBiafw7ipP7ZTQoFPPdWHFYBOrDQ=;
        b=a7VtcujBPD1u71MR8w7u7CwwvMwbSVlppAAFJNCkr7D7sMZLRAgXDGpVkHlnhjjsNz
         2hhjUht4VpXc0wjRnzG9x2fOSur6pvQs3BQlMy2/J+6QmSOmPR/8dYLMDbodYHZThLkM
         sBV1IYli7e4SZQ1YqtE9P5SkhBKj6sViwOpwY6wtRxQA6QBIs0/FRAe8/VuF2MUDvM6s
         OxCW05JNaOYd6mZGhNAsAa+WSLPS2zxYa9RkXgGyGPIFL+cSXpScUUbEJ6wfLBb7Vv7s
         aPq9PSSD9vZg3mKoq3SR7qCtg05nLE96KT8wA7r148qdhNUbdRoVaLWqPlofj0wDbVdJ
         myrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MNm1CnwZrFO2mvjUBiafw7ipP7ZTQoFPPdWHFYBOrDQ=;
        b=s3LmdaxGpPYuZENPcXqMzO0VhNy5S98C+DHFlGPReS/SCE1271NER6mRS0FM3gSG0w
         +6IuEqOa6BzciX33qvFdVraZe4xle03I5JENaGNiZfC1cD/c+7AbNua0xf/6BEOfAXd2
         DfZZIcI3spSUbk8sezfiLTx0usR+l+p7OU+Y1tbexbKSclMl7za0sNsVu0J8v8fm7MP6
         5rfgJRtUOSr+sob5Bxwioi4nC+Q0Pu847anLKJf3fUL0oksDsTW9p4x/D6L7bFJRxwzW
         jZkonbDDdlmS1O1FCzNRZqn3AOnNDRHdW56KTrDd77b5TRm9HDX74AF5b6nHIJaWO+Ot
         69eA==
X-Gm-Message-State: AOAM532HgLI8W8Bnwv1kSA3q5wVHoonYQdHHipZ+hOvfjHI2C8Zt0tDy
        c5dV501dwHM8s6FpWP8q+CEz5YNS
X-Google-Smtp-Source: ABdhPJz62qryuAI/ZwVAvcmq1vKaNbn/CDhOYxhW6qNyEBu+QsDUPMbNkz3NCvQrz8tvBMZ2WzpKXQ==
X-Received: by 2002:a5d:6a01:: with SMTP id m1mr5744602wru.115.1592592137729;
        Fri, 19 Jun 2020 11:42:17 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s8sm8176146wrm.96.2020.06.19.11.42.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Jun 2020 11:42:16 -0700 (PDT)
Subject: Re: [PATCH net 2/2] net: phy: Check harder for errors in get_phy_id()
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Dajun Jin <adajunjin@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE" 
        <devicetree@vger.kernel.org>
References: <20200619044759.11387-1-f.fainelli@gmail.com>
 <20200619044759.11387-3-f.fainelli@gmail.com>
 <20200619132659.GB304147@lunn.ch>
 <20200619133040.GO1551@shell.armlinux.org.uk>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <91659f09-44e9-2382-f9ac-e9ac32a85e4b@gmail.com>
Date:   Fri, 19 Jun 2020 11:42:12 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200619133040.GO1551@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/19/2020 6:30 AM, Russell King - ARM Linux admin wrote:
> On Fri, Jun 19, 2020 at 03:26:59PM +0200, Andrew Lunn wrote:
>> On Thu, Jun 18, 2020 at 09:47:59PM -0700, Florian Fainelli wrote:
>>> Commit 02a6efcab675 ("net: phy: allow scanning busses with missing
>>> phys") added a special condition to return -ENODEV in case -ENODEV or
>>> -EIO was returned from the first read of the MII_PHYSID1 register.
>>>
>>> In case the MDIO bus data line pull-up is not strong enough, the MDIO
>>> bus controller will not flag this as a read error. This can happen when
>>> a pluggable daughter card is not connected and weak internal pull-ups
>>> are used (since that is the only option, otherwise the pins are
>>> floating).
>>>
>>> The second read of MII_PHYSID2 will be correctly flagged an error
>>> though, but now we will return -EIO which will be treated as a hard
>>> error, thus preventing MDIO bus scanning loops to continue succesfully.
>>>
>>> Apply the same logic to both register reads, thus allowing the scanning
>>> logic to proceed.
>>
>> Hi Florian
>>
>> Maybe extend the kerneldoc for this function to document the return
>> values and there special meanings?
> 
> You mean like the patch I sent yesterday?
> 
>> BTW: Did you look at get_phy_c45_ids()? Is it using the correct return
>> value? Given the current work being done to extend scanning to C45,
>> maybe it needs reviewing for issues like this.
> 
> And the updates I sent for this yesterday? ;)

When Russell's patches land, they will address this correctly and
because I did not want to introduce any conflicts, this is not addressed
by this two patch series.
-- 
Florian
