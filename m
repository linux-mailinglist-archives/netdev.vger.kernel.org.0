Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1578967AA
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 19:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729833AbfHTRgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 13:36:43 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:39600 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727358AbfHTRgm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 13:36:42 -0400
Received: by mail-pl1-f195.google.com with SMTP id z3so3108116pln.6
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 10:36:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=H77B2+V/6VB1ou4SkcIu6d9E95EPyK96rc6biC9Ium0=;
        b=hVrFyDOdvKqPmiyCnJxq2C8WhPcUV3WaTHQYclCyBXbOzpn5IKf5+eseAKBPojIfRI
         Z1KKdktne3jJUDVaRqdCyZZpXdijfXV6KTQsofCxfCDadGOCOx6DRz7aLgi9jGWBAyoG
         BBfcIQwrCfDDrLH5/Ko2TgMuKWfSJ7xihIumEfwxJfaE0SoTcq0Q5oMastEDAzCSWg6H
         uMay5MqP8ur3TlE0Q8e2MI6JsQIfGPM9Q9D/7YrqXK5Sjg1paLNDZ/gGF+0AS8L2jSjA
         gRU4FdVaCFxwtvstRaBwEc8F7wDwgvBWV3Xybr1zj7NwaphRUAsp+F84kfrv/0yZk1Yi
         GpYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=H77B2+V/6VB1ou4SkcIu6d9E95EPyK96rc6biC9Ium0=;
        b=ctTyhB1400dm17pXiYY3MuPYjrWKTH+drFf3X5KyHPKwa79Hr68txeDhD4qUVTHmfv
         HT1vhEzjy3/7NIQe7YAGnVZp6r4rwI2iJWIpNKhFWcmC7VdZy/cpB2vV8bc6Gwc0yV3M
         imxQQRsXCQAt4W34l9fD/UqVuL4Rk82g4N0byfrWzDRFPZASEsco0529uC/57lAyFxTO
         4sM+B+HUoYmee1n8kIrIZ7koZNn1CWR6Q8nrf8EXxLsF2z4gPh1WvHQtNyqktgBYzee8
         6FtrDUMvc41eUOxDD4Ukjia8N2U+OSaQItTjJAVERGzM3A18x+pCWme38+ns/cJo0v6N
         dnqA==
X-Gm-Message-State: APjAAAUdY83EDIxcYxhM6UNoVRtufeEE1qKH9xfi7pAUNKA8+k7TSeGW
        mpCSduQWHUNHiqwVnc9F8s3M6ZOa
X-Google-Smtp-Source: APXvYqypYMyBQiNJ/E8CkexAHlZEJZYUuRVfTy4AjMEIm1P4S6VVrd3bQgsxfn2mzmqVdJe3CtUYfQ==
X-Received: by 2002:a17:902:e407:: with SMTP id ci7mr15366059plb.326.1566322601515;
        Tue, 20 Aug 2019 10:36:41 -0700 (PDT)
Received: from [10.67.49.31] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id ay7sm516984pjb.4.2019.08.20.10.36.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Aug 2019 10:36:40 -0700 (PDT)
Subject: Re: [PATCH net-next 6/6] net: dsa: tag_8021q: Restore bridge pvid
 when enabling vlan_filtering
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        nikolay@cumulusnetworks.com,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
References: <20190820000002.9776-1-olteanv@gmail.com>
 <20190820000002.9776-7-olteanv@gmail.com>
 <bf0c064e-6304-ba31-8f45-3a6226ed8939@gmail.com>
 <CA+h21hody3hu_6UE9gU4dQ5+BP5HnUi=uw0PDdvtgPjTrbpKbw@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <9a74874b-a932-f0f9-510d-687e4c9353d7@gmail.com>
Date:   Tue, 20 Aug 2019 10:36:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CA+h21hody3hu_6UE9gU4dQ5+BP5HnUi=uw0PDdvtgPjTrbpKbw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/20/19 3:28 AM, Vladimir Oltean wrote:
> Hi Florian,
> 
> On Tue, 20 Aug 2019 at 06:33, Florian Fainelli <f.fainelli@gmail.com> wrote:
>>
>>
>>
>> On 8/19/2019 5:00 PM, Vladimir Oltean wrote:
>>> The bridge core assumes that enabling/disabling vlan_filtering will
>>> translate into the simple toggling of a flag for switchdev drivers.
>>>
>>> That is clearly not the case for sja1105, which alters the VLAN table
>>> and the pvids in order to obtain port separation in standalone mode.
>>>
>>> So, since the bridge will not call any vlan operation through switchdev
>>> after enabling vlan_filtering, we need to ensure we're in a functional
>>> state ourselves.
>>>
>>> Hence read the pvid that the bridge is aware of, and program that into
>>> our ports.
>>
>> That is arguably applicable with DSA at large and not just specifically
>> for tag_8021q.c no? Is there a reason why you are not seeking to solve
>> this on a more global scale?
>>
> 
> Perhaps because I don't have a good feel for what are other DSA
> drivers' struggles with restoring the pvid, even after re-reading the
> "What to do when a bridge port gets its pvid deleted?" thread.
> I understand b53 has a similar need, and for that purpose maybe you
> can EXPORT_SYMBOL_GPL(dsa_port_restore_pvid) and use it, but
> otherwise, what is the more global scale?

I was just referring to all DSA drivers, not just tag_8021q.c which is,
so far a very narrow user base. I don't have a strong feeling against
calling a helper function versus the core DSA layer doing this for you,
but clearly this is something that should plague all drivers, not just
sja1105, even if the effects of not restoring the PVID there may be more
"catastrophic".
-- 
Florian
