Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5061EB79E
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 19:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729463AbfJaS5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 14:57:23 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51922 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729444AbfJaS5W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 14:57:22 -0400
Received: by mail-wm1-f68.google.com with SMTP id q70so7087823wme.1;
        Thu, 31 Oct 2019 11:57:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6sNK0GnkALxg6Lm9PdVrgkH3S8XIei9TfZL+fReqUHc=;
        b=FbOWUF6VW8HdNEtIjfT4K6xkOu4m7KXFMQCqcgEu/mbBW3OT8GGxdkgSTwouLn/Bck
         AyV4yBhD+O0de/frV5L1HmfjawYhYEbWeqY0nUD1BGaxwf2Mj/JdzFZn1s4aAEWEVhns
         tOtqnEyF7DYmj3FBiYbzOq0NzYV9gkUBnyHpGe3xNk28rC72Hn+YMJvezMid2ZGdqAKb
         dDyfXGnoPjsvLC9BZhnhvl+ZBJTuGwJIra5tWurj/uN34c0NvuWxQfeRwkXoCzw7BEtC
         XF2siWfMoY6KjvLuFUlIdoJq+JuPpUGLiU5jog7USICBLwD7eu/QC62fCNHlaT0laNuF
         p3BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=6sNK0GnkALxg6Lm9PdVrgkH3S8XIei9TfZL+fReqUHc=;
        b=k97Qeaqnoo+2q5AFLSscD6LG+UJ4dsD/WhVowN3IZKZuS2a7bzW2vplOSHfpMgpjdE
         h/3LpcxDvgH8YHlWvi62IQOYUkqUdCJa7K86BP8yHr81mIYM0SrQHMxi9aauFhFHGb3o
         ScQvvwP+VIUpSt43Tj5fgal6HMTFodR9K5lWtyv+AYJSYTqchmmdL7SSDJI+Stbig236
         utxqk/GMsi1M6MI9MVkYwt7miJAIZLh9e3ur8NdCUYE9cNztftLUJhO64ywVkc0JG8FP
         RFGlh5hs8uGoP9jVbIzjO2iTzWv4QZ9GfRmV0X3thcMgQPtsIshNG8va02VTIgi52kEv
         SiMw==
X-Gm-Message-State: APjAAAUz0qU1C9yBIzVYo45on+00hv+NeQi8tq2y0lyZCceWbqMudgk7
        G3FBdO9AglkwfSuihSz145MwYnzv
X-Google-Smtp-Source: APXvYqxG+wupgQQrW9egKG3NJh1MvQp79icnnFwhgkIR5s/c8Juzz1zlrUhMafiYxX8TFjjkZNm9eQ==
X-Received: by 2002:a1c:4089:: with SMTP id n131mr6857266wma.86.1572548239937;
        Thu, 31 Oct 2019 11:57:19 -0700 (PDT)
Received: from [10.67.51.137] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j19sm5715835wre.0.2019.10.31.11.57.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 31 Oct 2019 11:57:19 -0700 (PDT)
Subject: Re: [PATCH net 3/4] net: bcmgenet: soft reset 40nm EPHYs before MAC
 init
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1571267192-16720-1-git-send-email-opendmb@gmail.com>
 <1571267192-16720-4-git-send-email-opendmb@gmail.com>
 <3dbd4dbd-2ea5-e234-0cdc-81f0f3126173@gmail.com>
From:   Doug Berger <opendmb@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=opendmb@gmail.com; prefer-encrypt=mutual; keydata=
 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 YVs=
Message-ID: <4f1c2d73-66b8-62c3-d1bd-8b4aec2cf1d7@gmail.com>
Date:   Thu, 31 Oct 2019 11:57:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <3dbd4dbd-2ea5-e234-0cdc-81f0f3126173@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/16/19 8:53 PM, Florian Fainelli wrote:
> 
> 
> On 10/16/2019 4:06 PM, Doug Berger wrote:
>> It turns out that the "Workaround for putting the PHY in IDDQ mode"
>> used by the internal EPHYs on 40nm Set-Top Box chips when powering
>> down puts the interface to the GENET MAC in a state that can cause
>> subsequent MAC resets to be incomplete.
>>
>> Rather than restore the forced soft reset when powering up internal
>> PHYs, this commit moves the invocation of phy_init_hw earlier in
>> the MAC initialization sequence to just before the MAC reset in the
>> open and resume functions. This allows the interface to be stable
>> and allows the MAC resets to be successful.
>>
>> The bcmgenet_mii_probe() function is split in two to accommodate
>> this. The new function bcmgenet_mii_connect() handles the first
>> half of the functionality before the MAC initialization, and the
>> bcmgenet_mii_config() function is extended to provide the remaining
>> PHY configuration following the MAC initialization.
>>
>> Fixes: 484bfa1507bf ("Revert "net: bcmgenet: Software reset EPHY after power on"")
>> Signed-off-by: Doug Berger <opendmb@gmail.com>
> 
> Acked-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> We will have to see how difficult it might be to back port towards
> stable trees of interest, hopefully not too difficult.
> 

There is more going on here with the MAC reset than this commit resolves
and I am actively investigating a different approach that may include
the reversion of this commit.

Therefore, I would recommend not spending effort attempting to backport
this specific commit until I have submitted a more complete solution
(hopefully in the near future :).

Sorry for any confusion this creates.
    Doug
