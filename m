Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7F4141F3C
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 18:49:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727403AbgASRs3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 12:48:29 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:44980 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727111AbgASRs3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 12:48:29 -0500
Received: by mail-pf1-f193.google.com with SMTP id 62so7952199pfu.11;
        Sun, 19 Jan 2020 09:48:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fwM9jvrLVivTnTTryLGDynu7IYkovnhViSeBPBfbLpo=;
        b=iXLe10eYMxEVKcDdFJtze6fv6c+ywkL8bAHUJDNC+HYUixwv4JvCuZhYBFN9SNxqSN
         //JCFLWzjKrYWGrJCnj6cChKUdl1Winc65BCahaSGkKY76CxKvBkDWO7qNfunDuKDveF
         yhSCySUcfSc2XBSlpBXLfNYKW5952K2+tZl3EcHEAXKwdrf63sU+YGhcESXPc98wFXbI
         aU/jiD9+tPLcidLcKfy4ow//SIWPyGYLvTIyHC5Obihl6b/ri2FlAjnu5snEX8Ax5Ak1
         skFBUYg2cC/AjSXjxA6dVxMr/icQp3B+u5ZHXxHuHJOxEBBdc4PePv5gKjAJGQkaAldO
         eqAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=fwM9jvrLVivTnTTryLGDynu7IYkovnhViSeBPBfbLpo=;
        b=e+L29wESikX5/bix4jAIHu4fjFki7D6bKtT/Yv7IYzMfIVyAPMFQxIPogIqk7DL8Bx
         Iri4t23tzXi4FKdgE4vK0g48NmLKPbB5W2bthSiBMC7ZnwE1Wkd0h/3Z22bH/U3yupRI
         Xyl6q1mRtuEVZ6Vk2fvqf0d62i/VX4kXW1OuAKg1SSM5f4DiP2LcBcS2h2ZETCd7EOLE
         pVln8ien768jWMBDpc116vbjswER/TaDt3/XZFNgAU+myLdFgNiUYxzGBgpef29ViuUJ
         LInyXIwb+9gGYn0EE6grQWwJwINIdGzNcRki7zxtFr6V+lI/k1cUZeKEuXdtKi+u8DWB
         OhjQ==
X-Gm-Message-State: APjAAAVL8yplSjPIXVZzJemQEDCDc62DfT/7TZCIiltvZEd2PH8DNStp
        thcTghI2m6ruvM5MyTlVt8nMcYdk
X-Google-Smtp-Source: APXvYqw3HQdPHj4LV9LJ377/224pli2FZbfW9rJwdEmvNrLEKqobL+S8cYb1v0xekOI4T18LD2QIEw==
X-Received: by 2002:a62:e318:: with SMTP id g24mr13193066pfh.218.1579456108344;
        Sun, 19 Jan 2020 09:48:28 -0800 (PST)
Received: from [10.230.28.123] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e10sm37084441pfj.7.2020.01.19.09.48.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Jan 2020 09:48:27 -0800 (PST)
Subject: Re: [PATCH net] net: systemport: Fixed queue mapping in internal ring
 map
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org
References: <20200116210859.7376-1-f.fainelli@gmail.com>
 <20200117.043219.1348996138082295599.davem@davemloft.net>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 a9BQwACgnzGuH1BVeT2J0Ra+ZYgkx7DaPR0=
Message-ID: <51eac93a-15b7-2645-64ad-943d872dfe7c@gmail.com>
Date:   Sun, 19 Jan 2020 09:48:27 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200117.043219.1348996138082295599.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/17/2020 4:32 AM, David Miller wrote:
> From: Florian Fainelli <f.fainelli@gmail.com>
> Date: Thu, 16 Jan 2020 13:08:58 -0800
> 
>> We would not be transmitting using the correct SYSTEMPORT transmit queue
>> during ndo_select_queue() which looks up the internal TX ring map
>> because while establishing the mapping we would be off by 4, so for
>> instance, when we populate switch port mappings we would be doing:
>>
>> switch port 0, queue 0 -> ring index #0
>> switch port 0, queue 1 -> ring index #1
>> ...
>> switch port 0, queue 3 -> ring index #3
>> switch port 1, queue 0 -> ring index #8 (4 + 4 * 1)
>> ...
>>
>> instead of using ring index #4. This would cause our ndo_select_queue()
>> to use the fallback queue mechanism which would pick up an incorrect
>> ring for that switch port. Fix this by using the correct switch queue
>> number instead of SYSTEMPORT queue number.
>>
>> Fixes: 3ed67ca243b3 ("net: systemport: Simplify queue mapping logic")
>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> Applied, but I had to fix the SHA1-ID of the Fixes tag to be:
> 
>     Fixes: 25c440704661 ("net: systemport: Simplify queue mapping logic")

Just like the other patch what happened is that the check_fixes script
from Stephen was able to resolve this incorrect SHA1 because I have both
the Broadcom STB downstream remote configured as well as upstream and
the script was not yet updated to make sure this was an object that can
be reached in the upstream remotes (yours, Linus...). This should be
corrected now, sorry about that.
-- 
Florian
