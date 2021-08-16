Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A95F93EE06D
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 01:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234373AbhHPX30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 19:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232618AbhHPX3Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 19:29:25 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1917DC061764
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 16:28:53 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id r26so3215178oij.2
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 16:28:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nmCLMn2P55xtJTPoRJrmzPxbXh28AvLZqgEcmssugzA=;
        b=oDetirFtVVVJ3eZZxO2r3F1IuNKmUwoayHjp6hjMhQ+DBXZo6Yp9dlckJeMqGwN2/Z
         bhxOpVw4LUS8ZR1XHhiX13Sv3kHE18Se63q8ptxHWjwXsGgW5IhrlGTBT3Kl5a2MhBOh
         EWFNpjWfjHrf5FH9AjNhRc32mBEZl2vJR4qYFRBc/NUsYu94PsP/whrmApvHeuaMQiJw
         D2OuUlKU5Lhsr6ZNFYgjiaTrw7WfMh5j2MqUSBr2rtYPTuKUsIpunnWbpRh7EjvC4dT2
         UP4uGi4X3efxDyk53EITb9AtrZ8hjTCZ7C21XiP+hYtb+/GS1gy++c38CqofA+n7KIVD
         EDhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nmCLMn2P55xtJTPoRJrmzPxbXh28AvLZqgEcmssugzA=;
        b=UzkLMSjle/48h/yTKZpgncHF52u35lFjp/lRavBX1oyI5168q8F8eHbgqrikRdPkZX
         6UIUk65w5p+axcsJ0pyIevG38eSuRIBBc3j7CYxCXnGDcSwOpkVgK7UUg+4aDa1VuyHF
         UfaQDvk6NkX0gHcq2SqVV4iZWNmrI5KGuQ52xRs0WoLcNz46yUn2ZG3IittBBinl5b9z
         RD7ke0eccwAAWbHMoMZHdGEuDK5xEwG/c2eBdl/k3WRimtn2VgCTy0biTkHMZdpljktK
         aXDmyKIjb3K4/brO4RvY+6lXU2/mCaRYhdo3tt47B4n4tFJ5vguZzBkBCrGrdD/+za+H
         ciOw==
X-Gm-Message-State: AOAM531HOlDbG0Yy7hVMBh9J3tz+Q5LYGmpk5BG1sEZN6UjDpXTzRl5k
        2efIiJCgysjiKZZDiqRbO84X8IKFC84=
X-Google-Smtp-Source: ABdhPJyr//1dedvsgK6zo3gEcqixU76TAOVoRTFU/mC85hyVe4FDjNl8hgzf52dx8aOuTqqETmizKQ==
X-Received: by 2002:a05:6808:b21:: with SMTP id t1mr242123oij.165.1629156532539;
        Mon, 16 Aug 2021 16:28:52 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.45])
        by smtp.googlemail.com with ESMTPSA id 17sm91500oiy.50.2021.08.16.16.28.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Aug 2021 16:28:52 -0700 (PDT)
Subject: Re: [PATCH] vrf: Reset skb conntrack connection on VRF rcv
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Lahav Schlesinger <lschlesinger@drivenets.com>,
        netdev@vger.kernel.org, dsahern@kernel.org, davem@davemloft.net
References: <20210815120002.2787653-1-lschlesinger@drivenets.com>
 <d38916e3-c6d7-d5f4-4815-8877efc50a2a@gmail.com>
 <20210816144119.6f4ae667@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <58456069-ede2-bd22-e219-807c21a646fc@gmail.com>
Date:   Mon, 16 Aug 2021 17:28:49 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210816144119.6f4ae667@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/16/21 3:41 PM, Jakub Kicinski wrote:
> On Mon, 16 Aug 2021 12:08:00 -0600 David Ahern wrote:
>> On 8/15/21 6:00 AM, Lahav Schlesinger wrote:
>>> To fix the "reverse-NAT" for replies.
>>
>> Thanks for the detailed explanation and use case.
>>
>> Looks correct to me.
>> Reviewed-by: David Ahern <dsahern@kernel.org>
> 
> I get a sense this is a fix.

It is. I missed the lack of Fixes tag.

> 
> Fixes: 73e20b761acf ("net: vrf: Add support for PREROUTING rules on vrf device")
> ?

This one.

Thanks,

> 
> Or maybe it fixes commit a0f37efa8225 ("net: vrf: Fix NAT within a
> VRF")?
> 

