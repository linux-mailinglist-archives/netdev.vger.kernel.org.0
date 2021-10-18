Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5BA64325A8
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 19:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232040AbhJRR5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 13:57:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231917AbhJRR5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 13:57:10 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF2DEC06161C
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 10:54:58 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id b14so2021712plg.2
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 10:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=LnpED6++mK94BinvdVrVpdZETDLLc8Z/JEWb2PxEAqU=;
        b=dONSw0WXD0Lb4b8PB8zNKcfHXhhjdMntCrUSOOwdwgqmfupVeC3j+M3UG2xsC2uB9g
         vbYb91xV1NtDkRP2M5plLWSjjY1Eh/XesxqkdSVuPT46dsJbiiF5WKiaA2csUW8VVR5k
         FzbkKaFdcAmi9Ma9jDknKp1ZVZklCoZHJMLzWKoA7YEIw3NaPgXbtHi3aDxiVzd/yeHj
         NDgeiSv8zdq/WMM8mZFo7fg8qOsrfZSbPNd9egQunOvxj+RadGIBEFkUIvblNn+ktBoM
         94sG9S87UG5N51lcqDlLUiR/0OS0xoNympCp4tOEKRmGM85/Wyca6pTnCH2jbkjksIWB
         zvnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=LnpED6++mK94BinvdVrVpdZETDLLc8Z/JEWb2PxEAqU=;
        b=yYiXdgYicyzYoZwBjIzuK3N555hVgHfNFVHPkPMEO4SRXyYus08vG7SUe75my/z9OR
         blsD0YbaqcSY7ytvr66hNQZh8QTIdrG2VSpoNEcsjhnmlrIV6dzjGGkzeP3z/Y4b+lU7
         s0/m3KlwFoBL05nH5w/+ZNgY6R3bEOnmNRf3yDqoBtuZQoEMwwwkgpzwU/3bRNneysrJ
         /P6C9xXTj+q4JkId7ZJTmPx4paXNtb/GXTlS61jslYFNu7sQME4zduf+qaDun31y8YtA
         spygewgSYa/prWt+h+ewFbdDhs2mcoE5KScvWNz+ENeuhwsgbNZu3CzM5S7JW2e7LaeQ
         nmTQ==
X-Gm-Message-State: AOAM532yZIg/U3y6U67V3JafjqON90dEk1GasM9D7f++Coiqevv97spL
        Q0f2Mo7HK3Ncqn68yqLW3A5SPw==
X-Google-Smtp-Source: ABdhPJyd/gYmFUdEEHyU3r2DVKMQ47/1+FRKVdhpN80QAaqWej/SL2U6jw0r6aRiprXchT6JdBbP0g==
X-Received: by 2002:a17:902:6ac5:b0:13f:ca85:3d97 with SMTP id i5-20020a1709026ac500b0013fca853d97mr2424464plt.73.1634579698238;
        Mon, 18 Oct 2021 10:54:58 -0700 (PDT)
Received: from [192.168.0.14] ([50.53.47.17])
        by smtp.gmail.com with ESMTPSA id z5sm4234465pge.2.2021.10.18.10.54.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Oct 2021 10:54:57 -0700 (PDT)
Message-ID: <443e4671-bc84-b4a9-7198-7de301a03d52@pensando.io>
Date:   Mon, 18 Oct 2021 10:54:56 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.0
Subject: Re: [RFC net-next 3/6] ethernet: prestera: use eth_hw_addr_set_port()
Content-Language: en-US
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        olteanv@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com,
        vkochan@marvell.com, tchornyi@marvell.com
References: <20211015193848.779420-1-kuba@kernel.org>
 <20211015193848.779420-4-kuba@kernel.org>
 <186dd3ec-6bab-fe3c-cbab-a54898d51f57@pensando.io>
 <20211018071915.2e2afdd3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <6dc4c0b4-8eaa-800a-a06c-a16cbee5a22e@pensando.io>
 <YW2wBJ7yoUaLkYVv@shredder>
From:   Shannon Nelson <snelson@pensando.io>
In-Reply-To: <YW2wBJ7yoUaLkYVv@shredder>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/18/21 10:33 AM, Ido Schimmel wrote:
> On Mon, Oct 18, 2021 at 09:26:21AM -0700, Shannon Nelson wrote:
>> On 10/18/21 7:19 AM, Jakub Kicinski wrote:
>>> On Sat, 16 Oct 2021 14:19:18 -0700 Shannon Nelson wrote:
>>>> As a potential consumer of these helpers, I'd rather do my own mac
>>>> address byte twiddling and then use eth_hw_addr_set() to put it into place.
>>> This is disproved by many upstream drivers, I only converted the ones
>>> that jumped out at me on Friday, but I'm sure there is more. If your
>>> driver is _really_ doing something questionable^W I mean "special"
>>> nothing is stopping you from open coding it. For others the helper will
>>> be useful.
>>>
>>> IOW I don't understand your comment.
>> To try to answer your RFC more clearly: I feel that this particular helper
>> obfuscates the operation more than it helps.
> FWIW, it at least helped me realize that we are going to have a bug with
> Spectrum-4. Currently we have:
>
> ether_addr_copy(addr, mlxsw_sp->base_mac);
> addr[ETH_ALEN - 1] += mlxsw_sp_port->local_port;
>
> As a preparation for Spectrum-4 we are promoting 'local_port' to u16
> since at least 257 and 258 are valid local port values.
>
> With the current code, the netdev corresponding to local port 1 will
> have the same MAC as the netdev corresponding to local port 257.
>
> After Jakub's conversion and changing the 'id' argument to 'unsigned
> int' [1], it should work correctly.
>
> [1] https://lore.kernel.org/netdev/20211018070845.68ba815d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com/

I would think that it might be clearer to do something like

     u64 addr64;

     addr64 = ether_addr_to_64(mlxsw_sp->base_mac);
     addr64 += mlxsw_sp_port->local_port;
     u64_to_ether_addr(addr64, addr);
     eth_hw_addr_set(dev, addr);

This uses our helpers to keep common actions safe, but also keeps the 
vendor specific logic (add N to the base_mac) in the driver.

sln

