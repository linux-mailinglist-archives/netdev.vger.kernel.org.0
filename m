Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03A5FB4A3B
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 11:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbfIQJT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 05:19:56 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33060 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbfIQJTz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 05:19:55 -0400
Received: by mail-wr1-f68.google.com with SMTP id b9so2347378wrs.0;
        Tue, 17 Sep 2019 02:19:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cH+s/kHcFZjXMywBYraBVrnuYyRHILXFQppb3FCUAR4=;
        b=dnXgnpvMud+Kgdk29IiRRvcDZ/FUPLeg/f5MNJLbSwqf2cnk8P4PJnnDCmP1Whdnrt
         UPgDF74ineZ0EYbMHlwCv2CHtopdu4/mdSej5aDoJPH5Y5FP8OGxnTk+rAmOZ+5IcK/m
         +tDkLukdbXhS6/BKmwIDB0gO00sXVgx78YycgVpov7RO9LICXEvGqvmG8FXrYer77sZi
         7Kr0+kyNFk2rR3vkN4f2BliYpBJEqIpOaTfKz/V2UBSYPigghW0e1gYFHpT38/+Zk7/F
         S60xtlLylM7FeeN70hBpHSaEQmbXZrQ24eFsaqQs1ijnhOPvq/WZL2+b7YV2RBwcdir/
         +YQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=cH+s/kHcFZjXMywBYraBVrnuYyRHILXFQppb3FCUAR4=;
        b=UO4gPnxMtUKKxQ5GKFZvdPIT3k9xuqonwhhMtv5U2FdKO70oURk+nDCukzVQ7EzfF6
         9cXBk2ttl1B5Yo4SVL05frLsw4IQkHb7NgyiNWjrThCC61cunbeFlxH02veqeC7PHjLY
         Pd5XDm4CkZYHvyo2L3qoNHAxJCchK3d8Pmm4QUIr1x75+3N+CjS6AKZz1qxf1iLUe/B2
         CsWgqcvTK3vkd90/qiMJjZUZkdDNzlfVpQuCgUpaEC3PJ6EPk4YUUQ4w6Won8oVJZsoH
         xPEh+OX7AmMGtNVIJMMEmtB6JOAjATx2pxQqghe9KDCQ5llnlhYFxi2bjv78DzCGNYw5
         /I3Q==
X-Gm-Message-State: APjAAAVIG4Dx/6gRYDQWZER/FgWuUNv840u6Cpwvc4Hyu+MOMUavW2pZ
        MoWM1d+wLAtY0gavtaX9n/uG/7MOeG1Qpg==
X-Google-Smtp-Source: APXvYqyKlEN7eysKohRJe0S3TYLZFJtJdo//7bwiKYcUmnw12634GiHOTdkNGwwKx/LoRFS20jjmug==
X-Received: by 2002:a5d:6951:: with SMTP id r17mr2082477wrw.208.1568711992227;
        Tue, 17 Sep 2019 02:19:52 -0700 (PDT)
Received: from ?IPv6:2620:10d:c0c1:1609::e5b? ([2620:10d:c092:200::1:c5da])
        by smtp.gmail.com with ESMTPSA id r28sm2027569wrr.94.2019.09.17.02.19.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Sep 2019 02:19:50 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
Subject: Re: [PATCH v7] rtl8xxxu: Improve TX performance of RTL8723BU on
 rtl8xxxu driver
To:     Chris Chiu <chiu@endlessm.com>, kvalo@codeaurora.org,
        davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessm.com,
        Daniel Drake <drake@endlessm.com>
References: <20190917074007.92259-1-chiu@endlessm.com>
Openpgp: preference=signencrypt
Autocrypt: addr=Jes.Sorensen@gmail.com; keydata=
 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 WQ==
Message-ID: <50692e0b-2d46-de04-b277-0aefd2041669@gmail.com>
Date:   Tue, 17 Sep 2019 05:19:50 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190917074007.92259-1-chiu@endlessm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/17/19 3:40 AM, Chris Chiu wrote:
> We have 3 laptops which connect the wifi by the same RTL8723BU.
> The PCI VID/PID of the wifi chip is 10EC:B720 which is supported.
> They have the same problem with the in-kernel rtl8xxxu driver, the
> iperf (as a client to an ethernet-connected server) gets ~1Mbps.
> Nevertheless, the signal strength is reported as around -40dBm,
> which is quite good. From the wireshark capture, the tx rate for each
> data and qos data packet is only 1Mbps. Compare to the Realtek driver
> at https://github.com/lwfinger/rtl8723bu, the same iperf test gets
> ~12Mbps or better. The signal strength is reported similarly around
> -40dBm. That's why we want to improve.
> 
> After reading the source code of the rtl8xxxu driver and Realtek's, the
> major difference is that Realtek's driver has a watchdog which will keep
> monitoring the signal quality and updating the rate mask just like the
> rtl8xxxu_gen2_update_rate_mask() does if signal quality changes.
> And this kind of watchdog also exists in rtlwifi driver of some specific
> chips, ex rtl8192ee, rtl8188ee, rtl8723ae, rtl8821ae...etc. They have
> the same member function named dm_watchdog and will invoke the
> corresponding dm_refresh_rate_adaptive_mask to adjust the tx rate
> mask.
> 
> With this commit, the tx rate of each data and qos data packet will
> be 39Mbps (MCS4) with the 0xF00000 as the tx rate mask. The 20th bit
> to 23th bit means MCS4 to MCS7. It means that the firmware still picks
> the lowest rate from the rate mask and explains why the tx rate of
> data and qos data is always lowest 1Mbps because the default rate mask
> passed is always 0xFFFFFFF ranges from the basic CCK rate, OFDM rate,
> and MCS rate. However, with Realtek's driver, the tx rate observed from
> wireshark under the same condition is almost 65Mbps or 72Mbps, which
> indicating that rtl8xxxu could still be further improved.
> 
> Signed-off-by: Chris Chiu <chiu@endlessm.com>
> Reviewed-by: Daniel Drake <drake@endlessm.com>

I am still traveling after Plumbers and don't have my 8723bu dongles
with me, but I'd say this looks good.

Acked-by: Jes Sorensen <Jes.Sorensen@gmail.com>

Jes
