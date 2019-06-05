Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B378D36311
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 20:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbfFESBP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 14:01:15 -0400
Received: from mail-pg1-f176.google.com ([209.85.215.176]:37616 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726556AbfFESBP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 14:01:15 -0400
Received: by mail-pg1-f176.google.com with SMTP id 20so12825032pgr.4
        for <netdev@vger.kernel.org>; Wed, 05 Jun 2019 11:01:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nCBpf1kBhCmG4QHupEtuYpq50FOnwRrpCvJOnsjX7kI=;
        b=Tdh/CqqpDRKG/wo3ox8XWC3+ufCK/spg5kUbj1pZuNOWeJ/LomAT62pI4LmGyPcRo8
         u74INxFGVfj/uhfPucPd2rnLIUq5hcHLKsalDI6kn0P3R1qSpczE1RPMYFKzLQHZaU//
         eTkPZaZ7xGr2kTJRILLMezInEuobF3nX3jrhSOd/1sUlZqQ39mrYbh9rO3v7J6WA/xvE
         UYo3dCHivAb03WLQodyp1wNHfHLCU1v7KqWQWpCZ97ob228yH/icdKoR2tprjp+ho8MP
         OG33Hn2LHVnCcTBViZg1/UdZfJpL5SKE7jhhwVjHOKc4c1dzYu2yciofL92Mp6nL9iOd
         dS6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nCBpf1kBhCmG4QHupEtuYpq50FOnwRrpCvJOnsjX7kI=;
        b=OsKs7gSS+t1wxqfQuV0gxil76PRdLlajgog8/sWZVWuMhI+Oc3HMzVj9a3u+ZeSKJ0
         zeHY01IHv+GjOU2Fi57Bde2smNjIiZvbCfRlj4hlOuxW3N/e89vRAyeEilO4/M8jA2Hn
         eEBnpOg9jT1hvKeXn22AxX0i3PsMXpGhkPj1JTBFNWjsKWzFVInPo7xqpodaeetZ8TAQ
         rruFGu1uy9ezMXELsD5wxHeIicZqAI0VYA18EkebY1Jgp/KEyvPfE6du9jW3EL6cFwQs
         /430edfeYpXpyOVP/VeRZzkNR2a9FmLq/RC0PImNZ3LZvqs31yVaAO2a1mUItwag0Ipt
         SByg==
X-Gm-Message-State: APjAAAUIdHWEcRzucyq1z/kU7AJEnJ5q8EC3DVF8se7hBCCYU1n1j+Pb
        oj07WLCERq+F0CfDwUEyaT4=
X-Google-Smtp-Source: APXvYqwhgEJQrmMn6OeplWwvUK8jxBcat6MiHuU4j1pRxXJlkwBJB+rXQ6Ay0D9eWn+G3bNKZ3Su8Q==
X-Received: by 2002:a63:4c1f:: with SMTP id z31mr6442059pga.334.1559757674832;
        Wed, 05 Jun 2019 11:01:14 -0700 (PDT)
Received: from [10.69.78.41] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d3sm17433855pfa.176.2019.06.05.11.01.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Jun 2019 11:01:13 -0700 (PDT)
Subject: Re: Cutting the link on ndo_stop - phy_stop or phy_disconnect?
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
References: <52888d1f-2f7d-bfa1-ca05-73887b68153d@gmail.com>
 <20190604213624.yw72vzdxarksxk33@shell.armlinux.org.uk>
 <33c5afc8-f35a-b586-63a3-8409cd0049a2@gmail.com>
 <20190605084500.pjkq43l4aaepznon@shell.armlinux.org.uk>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <a96c1e26-6b44-7fc4-feab-d381d7d4c3d3@gmail.com>
Date:   Wed, 5 Jun 2019 11:01:10 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190605084500.pjkq43l4aaepznon@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/5/2019 1:45 AM, Russell King - ARM Linux admin wrote:
> On Tue, Jun 04, 2019 at 07:25:46PM -0700, Florian Fainelli wrote:
>> On 6/4/2019 2:36 PM, Russell King - ARM Linux admin wrote:
>>> Normally the PHY receives traffic, and passes it to the MAC which
>>> just ignores the signals it receives from the PHY, so no processing
>>> beyond the PHY receiving the traffic happens.
>>>
>>> Ultimately, whether you want the PHY to stay linked or not linked
>>> is, imho, a policy that should be set by the administrator (consider
>>> where a system needs to become available quickly after boot vs a
>>> system where power saving is important.)  We don't, however, have
>>> a facility to specify that policy though.
>>
>> Maybe that's what we need, something like:
>>
>> ip link set dev eth0 phy [on|off|wake]
>>
>> or whatever we deem appropriate such that people willing to maintain the
>> PHY on can do that.
> 
> How would that work when the PHY isn't bound to the network device until
> the network device is brought up?

There was supposed to be a down somewhere, something like:

ip link set dev eth0 down phy [on|off|wake]

such that we have been guaranteed to be connected to the PHY at some
point. Maybe this is not such a great idea after all, since not all
drivers would be able to support the optional "phy" argument.
-- 
Florian
