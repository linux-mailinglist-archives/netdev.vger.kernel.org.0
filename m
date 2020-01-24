Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0E0149223
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 00:49:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729578AbgAXXtT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 18:49:19 -0500
Received: from mail-pj1-f48.google.com ([209.85.216.48]:55372 "EHLO
        mail-pj1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729147AbgAXXtT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 18:49:19 -0500
Received: by mail-pj1-f48.google.com with SMTP id d5so484091pjz.5;
        Fri, 24 Jan 2020 15:49:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=moF1ZyovcBBfBqfEzcD3uJdsfAd0Eoiy0NYti5D6FQc=;
        b=Q1qOuG3k6bI3d/sCC2ZVVn2pJoWJtNLYmP4OXgGSr0giyUBORK+Am55nXdFYPsUEI9
         cp3Ln8GxX6LtYRthuR5vHomz/0FbeRaCrXI9pXVa4+4LPoSUjdgQ1IbIeXt7ludyQzEF
         WhBX7nDOza8c6kIYutDlnpgLkccWeNg+Q+ayiBF77/KyCXToQ6mlEi0x2NZDoXlCJLPZ
         7zQwekXBfHDL17IMF2bwullqv/DRGlxPQvZ77GiVqdEE/kYlT/+DZpAIqQUbJMJGGwEg
         QlIl0f6LmtHNR2ikhPnM7Gw4oSjKld57n3IQYRN3CCc8OsrimRjAhT3Ke74FiasQg58z
         uEgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=moF1ZyovcBBfBqfEzcD3uJdsfAd0Eoiy0NYti5D6FQc=;
        b=LRz0qekEZYPkjv3119TI7dzfqwZepO/7F/s9j/+NfXdHLQGcwRqHho6nwPRPhp9zlF
         9tf3jM9pwm6kvqMmu4yleod1LEaSUhcvaXXnfI8YHSh647fyZEroX2r3wHG3liXLbrSo
         MZxrZMDJoyZLB5IhMgX05jYK7B7Ks65z4S7E1MbiGhmQG43iS2LK86Qjf90P9k4bmLR9
         5N67b3Xk7OidUep4ypchVQw6SlQ0lk2YP0to1B+ruznN91I5zz/mABHJ7KLPSEmWaSpH
         f5+ZQuDgSHUqjLC6Gf77N4PVrTqkV/juRFtO62g/csTOpuR10Q175OZ4GhKOPzCjU4If
         TAlw==
X-Gm-Message-State: APjAAAUFXjPHg9+Qeo5SvSAYoVNUlllWDQqv5jgQagJywXYgO0Y1bi3v
        NdQwGi/NrDkOUNfq+57CkbHnXd6m
X-Google-Smtp-Source: APXvYqxTW0slf51CuFlMiJmQhPi96oNyuyV7QrWsyHdag6d6GXN16mePt8TkbLB82ynjoale57lz4A==
X-Received: by 2002:a17:90a:fe8:: with SMTP id 95mr1938251pjz.98.1579909758046;
        Fri, 24 Jan 2020 15:49:18 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id e16sm7577660pgk.77.2020.01.24.15.49.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jan 2020 15:49:17 -0800 (PST)
Subject: Re: debugging TCP stalls on high-speed wifi
To:     Johannes Berg <johannes@sipsolutions.net>,
        Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc:     Neal Cardwell <ncardwell@google.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
References: <14cedbb9300f887fecc399ebcdb70c153955f876.camel@sipsolutions.net>
 <CADVnQym_CNktZ917q0-9dVY9dhtiJVRRotGTrPNdZUpkjd3vyw@mail.gmail.com>
 <f4670ce0f4399fe82e7168fb9c491d8eb718e8d8.camel@sipsolutions.net>
 <99748db5-7898-534b-d407-ed819f07f939@gmail.com>
 <ff6b35ad589d7cf0710cb9fca4c799538da2e653.camel@sipsolutions.net>
 <CABPxzYJZLHBvtjN7=-hPiUK1XU_b60m8Wpw4tHsT7zOQwZWRVw@mail.gmail.com>
 <ef348261c1edd9892b09ed017a59be23aa2be688.camel@sipsolutions.net>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <9f984cda-2209-fa07-569e-2555ef2aa78d@gmail.com>
Date:   Fri, 24 Jan 2020 15:49:15 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <ef348261c1edd9892b09ed017a59be23aa2be688.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/24/20 2:34 AM, Johannes Berg wrote:
> On Fri, 2019-12-13 at 14:40 +0530, Krishna Chaitanya wrote:
>>
>> Maybe try 'reno' instead of 'cubic' to see if congestion control is
>> being too careful?
> 
> I played around with this a bit now, but apart from a few outliers, the
> congestion control algorithm doesn't have much effect. The outliers are
> 
>  * vegas with ~120 Mbps
>  * nv with ~300 Mbps
>  * cdg with ~600 Mbps
> 
> All the others from my list (reno cubic bbr bic cdg dctcp highspeed htcp
> hybla illinois lp nv scalable vegas veno westwood yeah) are within 50
> Mbps or so from each other (around 1.45Gbps).
> 

When the stalls happens, what is causing TCP to resume the xmit ?

Some tcpdump traces could help.

(-s 100 to only capture headers)



