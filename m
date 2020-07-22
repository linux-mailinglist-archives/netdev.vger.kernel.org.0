Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5F9022A1CE
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 00:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733040AbgGVWLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 18:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726642AbgGVWLU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 18:11:20 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA378C0619DC
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 15:11:19 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id r12so3286226wrj.13
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 15:11:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4FR8yxqlzkgUKt1ko5eGa3wwnzHjGmidFxw0sTOb7is=;
        b=s0G1JH4IYKsmQdJwgtdYrM7qnTVyV2EPRLnvGpbaF+srgNzugmsA+2YWh5FKZq4Mvw
         wmAD/Xhj59SSRaXaVmpDvG1WQ1Ypn1H/6FjXbQlWoDiXO11cx5HPk2+McQlMa7zGEWVo
         WdNwBf66L2MHZF+DhlgpLj5q4W+6BtIFGQftv66p4WrxpwEn8y8hEqSPgHpRQCIKJiYr
         yKGg5ZzpwiAzsSPRKG9T7wipnqt1hEY51D0x+kGR8cNusDZTV/ejgPL00xhhntcADvEo
         MhVN5l3Ui0/gNo3qu1aY6kgelYfjwczfTOAkXh4sFC6HWWPR3oGsK0K4P51bZihKy6ro
         TfSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=4FR8yxqlzkgUKt1ko5eGa3wwnzHjGmidFxw0sTOb7is=;
        b=g+8O7olEiJeTCQ0l1Ur5tH6et31KVYKp/bEoIKXonnJS3f/JIsqkcCYbivG3ZwJvwm
         yglVIue+aSx3UVzUB7n4Cbzsv0qqxiZ4/6rqimqT9w26jXoMeyyraldHfbkyK0FlpDAK
         XNn4QPN2sxOAhwo9+QDquAfcxpI+dz2QRAPdK2HPruPZWsbK/kH72UMeEPTNXCHnm6a9
         U//vkpHY29jJnstULPfArO38v6I06Iu39S0LBnqt3KvJZWTJOCRhxkXl7Kpn1AOkNiEw
         15AeUNIElpL0/qUCo75aSyPGtm9HZHAAT/jciz1lbqjRvFIs34JEnqnHnYb/7HqT1TRX
         r4rA==
X-Gm-Message-State: AOAM5319/e/5eZ09D3cwsjKd9xVW0PUiKnaWg6NFzRZOzYsFS3nYMFwv
        Xec7jr0FlPRxUoEr57wY06ewpzWN
X-Google-Smtp-Source: ABdhPJyvg62uoyg6yh0RM9kIYJnzTTcU0kGlMQh9i7UQphf2/9d0IrDPs0TE9miwZNbZPv8IX5cIOg==
X-Received: by 2002:a05:6000:c:: with SMTP id h12mr1281048wrx.49.1595455878447;
        Wed, 22 Jul 2020 15:11:18 -0700 (PDT)
Received: from [10.67.50.75] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id g16sm1293225wrs.88.2020.07.22.15.11.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jul 2020 15:11:17 -0700 (PDT)
Subject: Re: [PATCH net-next] net: restore DSA behavior of not overriding
 ndo_get_phys_port_name if present
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        andrew@lunn.ch, vivien.didelot@gmail.com, jiri@mellanox.com,
        edumazet@google.com, ap420073@gmail.com, xiyou.wangcong@gmail.com,
        maximmi@mellanox.com, mkubecek@suse.cz, richardcochran@gmail.com
References: <20200722205348.2688142-1-olteanv@gmail.com>
 <98325906-b8a5-fb0c-294d-b03c448ba596@gmail.com>
 <20200722220650.dobse2zniylfyhs6@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 G10n8gCguORqNGMsVRxrlLs7/himep7MrCc=
Message-ID: <6db74106-af90-deac-907d-9f0c971ec698@gmail.com>
Date:   Wed, 22 Jul 2020 15:11:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200722220650.dobse2zniylfyhs6@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/22/20 3:06 PM, Vladimir Oltean wrote:
> On Wed, Jul 22, 2020 at 02:53:28PM -0700, Florian Fainelli wrote:
>> On 7/22/20 1:53 PM, Vladimir Oltean wrote:
>>> Prior to the commit below, dsa_master_ndo_setup() used to avoid
>>> overriding .ndo_get_phys_port_name() unless the callback was empty.
>>>
>>> https://elixir.bootlin.com/linux/v5.7.7/source/net/dsa/master.c#L269
>>>
>>> Now, it overrides it unconditionally.
>>>
>>> This matters for boards where DSA switches are hanging off of other DSA
>>> switches, or switchdev interfaces.
>>> Say a user has these udev rules for the top-level switch:
>>>
>>> ACTION=="add", SUBSYSTEM=="net", KERNELS=="0000:00:00.5", DRIVERS=="mscc_felix", ATTR{phys_port_name}=="p0", NAME="swp0"
>>> ACTION=="add", SUBSYSTEM=="net", KERNELS=="0000:00:00.5", DRIVERS=="mscc_felix", ATTR{phys_port_name}=="p1", NAME="swp1"
>>> ACTION=="add", SUBSYSTEM=="net", KERNELS=="0000:00:00.5", DRIVERS=="mscc_felix", ATTR{phys_port_name}=="p2", NAME="swp2"
>>> ACTION=="add", SUBSYSTEM=="net", KERNELS=="0000:00:00.5", DRIVERS=="mscc_felix", ATTR{phys_port_name}=="p3", NAME="swp3"
>>> ACTION=="add", SUBSYSTEM=="net", KERNELS=="0000:00:00.5", DRIVERS=="mscc_felix", ATTR{phys_port_name}=="p4", NAME="swp4"
>>> ACTION=="add", SUBSYSTEM=="net", KERNELS=="0000:00:00.5", DRIVERS=="mscc_felix", ATTR{phys_port_name}=="p5", NAME="swp5"
>>>
>>> If the DSA switches below start randomly overriding
>>> ndo_get_phys_port_name with their own CPU port, bad things can happen.
>>> Not only may the CPU port number be not unique among different
>>> downstream DSA switches, but one of the upstream switchdev interfaces
>>> may also happen to have a port with the same number. So, we may even end
>>> up in a situation where all interfaces of the top-level switch end up
>>> having a phys_port_name attribute of "p0". Clearly not ok if the purpose
>>> of the udev rules is to assign unique names.
>>>
>>> Fix this by restoring the old behavior, which did not overlay this
>>> operation on top of the DSA master logic, if there was one in place
>>> already.
>>>
>>> Fixes: 3369afba1e46 ("net: Call into DSA netdevice_ops wrappers")
>>> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
>>> ---
>>> This is brain-dead, please consider killing this and retrieving the CPU
>>> port number from "devlink port"...
>>
>> That is fair enough. Do you want to submit such a change while you are
>> at it?
>>
> 
> If I'm getting you right, you mean I should be dropping this patch, and
> send another one that deletes dsa_ndo_get_phys_port_name()?
> I would expect that to be so - the problem is the fact that we're
> retrieving the number of the CPU port through an ndo of the master
> interface, it's not something we can fix by just calling into devlink
> from kernel side. The user has to call into devlink.

Yes, that is what I meant, that an user should call the appropriate
devlink command to obtain the port number, this particular change has
caused more harm than good, and the justification for doing it in the
first place was weak to begin with.
-- 
Florian
