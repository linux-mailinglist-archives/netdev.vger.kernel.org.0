Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 556C11C485F
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 22:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbgEDUgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 16:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726111AbgEDUgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 16:36:19 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD5ADC061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 13:36:18 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id x4so23476wmj.1
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 13:36:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=n6MW9nnqsBxImqWAIOlcTSOisfe1E4X1cUoRHPwcxI4=;
        b=EEklH6hF0EoknQl0xSEOwsRwF2wCP8BxiCWQcgTlFatLmpDjJDlgPTfpD9k2D6lZRe
         FNng++9Nc4s6n8/B4e2zIN1kKbz1Fu1O5patXGVUsR5AzporuapGzbD6wPgdcu5LLpY6
         ncafB9iRsDc2+peY2xRJdStnpiC9cnrIlMQ9Bo+NDm/mWEGVYwpWMX5CIITQkl9Ry49q
         nVQy92SZ7UmfCFXzgb5/cecIJ0eqUB6t0NmiwvPSai71YrdrdJTEBqycG0FtkUZ0P+1B
         aKeSAQV/JW0NTiN2HjOGnlO+F/HnmkTtyJfLK33rXVCtlXRPqFQTH+xHpAB+Cerul5hk
         3ZkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=n6MW9nnqsBxImqWAIOlcTSOisfe1E4X1cUoRHPwcxI4=;
        b=XR/mmJS8V1C9BrLUYGygaHtU3Bj3RfhjldHbRl36tef8TAiFvRCpLZViWa65rkftSC
         0quZ+sNyp4wQQAzup8zEaPPiz2cN/rKuOyMZGtlGBrCDMF+bckBV8hdFvCUTWoJ5LRuY
         eQ66PDYCW9cMy1d+mnnf3nDRa2qnGDQzIYtyWe3P6rYHqmHE73WJCSMNyW4sXEDhS6b7
         kXMPShcJMo179GDJsjuawShGbFsyAY/Jgz0KlU0z+IyHsZ4yEeNbkHJ/WaSGtb7AIRR5
         Nd9Dkj3eogFp36oavJuy4agX4QMP4zeUZw/OwNDU32FcmUhXQNm/m5T31PSM7MazdPbS
         Tq5w==
X-Gm-Message-State: AGi0Pua4vkiFYu4Yw63kcE1QKW3uJ491hdMMtaldd6Rx+QIw0VH23uIL
        LAacb+OUCUsoriaXgfYzwzMtnLgf
X-Google-Smtp-Source: APiQypIBHDI6oDeVCmRyr/q97qyXYdUp988/2mo2GZeslGWpj+5gCRevavB1CkCnQFNY/MwtUTZAVQ==
X-Received: by 2002:a1c:2b81:: with SMTP id r123mr16460117wmr.34.1588624577376;
        Mon, 04 May 2020 13:36:17 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d7sm20497948wrn.78.2020.05.04.13.36.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 13:36:16 -0700 (PDT)
Subject: Re: bgmac-enet driver broken in 5.7
To:     Jonathan Richardson <jonathan.richardson@broadcom.com>
Cc:     zhengdejin5@gmail.com, davem@davemloft.net,
        Scott Branden <scott.branden@broadcom.com>,
        Ray Jui <ray.jui@broadcom.com>, netdev@vger.kernel.org
References: <CAHrpVsUFBTEj9VB_aURRB+=w68nybiKxkEX+kO2pe+O9GGyzBg@mail.gmail.com>
 <87b7e9f5-39d3-5523-83da-71361cf193f5@gmail.com>
 <CAHrpVsXhNtg7Lt75OZ2+BLkqktO8UnNhxmekij=-Lp35aQkaWw@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <ed1c2d8f-9d92-1258-e15b-ee33acac8859@gmail.com>
Date:   Mon, 4 May 2020 13:36:13 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAHrpVsXhNtg7Lt75OZ2+BLkqktO8UnNhxmekij=-Lp35aQkaWw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/4/2020 1:24 PM, Jonathan Richardson wrote:
> On Mon, May 4, 2020 at 1:20 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
>>
>>
>>
>> On 5/4/2020 12:32 PM, Jonathan Richardson wrote:
>>> Hi,
>>>
>>> Commit d7a5502b0bb8b (net: broadcom: convert to
>>> devm_platform_ioremap_resource_byname()) broke the bgmac-enet driver.
>>> probe fails with -22. idm_base and nicpm_base were optional. Now they
>>> are mandatory. Our upstream dtb doesn't have them defined. I'm not
>>> clear on why this change was made. Can it be reverted?
>>
>> You don't get a change reverted by just asking for it, you have to
>> submit a revert to get that done can you do that?
>> --
>> Florian
> 
> If the author is fine with reverting it yes I will submit the change.

The author clearly submitted this as a drive by contribution, so I would
not expect this to be a problem.
-- 
Florian
