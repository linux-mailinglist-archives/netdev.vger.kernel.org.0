Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B70302E45B
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 20:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727364AbfE2SW0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 14:22:26 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:44842 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726947AbfE2SW0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 14:22:26 -0400
Received: by mail-ot1-f66.google.com with SMTP id g18so2993114otj.11;
        Wed, 29 May 2019 11:22:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=amJi0jbjD9M6vUHKgUTYZgac6U4sNICfW2Wh2jnSQXI=;
        b=R8c2oA5Fl36xHbwRZd3mPECu98msS2gC5wxHUo1gjNyD42EJWz14QKvHjGofU1qbos
         snZb+IxY8/sp9K3ckuwl7SAOOde9Lc9Bd/0Ju1zOgMki4HJZ/W7+GEOw+/6nFV9Shc7N
         tdzmCJifBTO8UHIPOnv9S3TIo05p8AA4gOML2aZD49Oj06qsQT0cYgHTGcl/oJuEeqpA
         TzHC+Z32hjbRXqaMM3ZqP3gw33B5+wc/keNRFb7SJgLZTeEP3UvQinmq9pyfzCiYHaUs
         uNqV8278AmSpyNisgMzDNToAR0XdeDErauSyPCdVZSG6nW206TH7+VrwdH8uz5zxkpfh
         9BzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=amJi0jbjD9M6vUHKgUTYZgac6U4sNICfW2Wh2jnSQXI=;
        b=ZlDPOTSo0GriI009l4yAIJSsOSnFCQpp5pSg9hsUAB9xfOZxtN/S1padtRb6D/7WWG
         CNMXemGwShM8kYMXEi+g70cktzxyHdsUP/9mYtiShUhQUJWW1r3htq0H6HX8oGQTZggw
         RrZycFDKrZZV1nzOwofpnrvx1aa0B1vREoDqsP5JQRYzlmbYGtWJLHhp3718GnRTWitX
         ubeQ2PMHrhJOnLs3D1YLN7c1fLnx/dMJ+pBU0ca6mS3AxoD/Hp0YXAzTOZ8b8h3z5c1d
         O52H8UH7dZHnKdG587SwFmQkkdFuCiD/R9wAUZRg4eydXg6egDinv6/UVAtkJm1DCbJQ
         7bzg==
X-Gm-Message-State: APjAAAX4tZMj+tAa+sB+n09WZ240zkqjTjnA4zt6vhVeVVlJ3e7QqGOO
        RXqkIuhF7O1BL8r6pZZdbKA=
X-Google-Smtp-Source: APXvYqy6PhVo7GdXSqPk35HHEzvt77Cl8Mfv8o7XWp1rLaQgOadm5LbsmmBsvUWFA4R59/KnVTZeHQ==
X-Received: by 2002:a9d:7a4d:: with SMTP id z13mr172718otm.246.1559154145557;
        Wed, 29 May 2019 11:22:25 -0700 (PDT)
Received: from [192.168.1.112] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id t139sm122687oie.21.2019.05.29.11.22.24
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 May 2019 11:22:24 -0700 (PDT)
Subject: Re: [RFC PATCH v3] rtl8xxxu: Improve TX performance of RTL8723BU on
 rtl8xxxu driver
To:     Chris Chiu <chiu@endlessm.com>, jes.sorensen@gmail.com,
        kvalo@codeaurora.org, davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessm.com
References: <20190529050335.72061-1-chiu@endlessm.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <5f5e262d-aadb-cca0-8576-879735366a73@lwfinger.net>
Date:   Wed, 29 May 2019 13:22:23 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190529050335.72061-1-chiu@endlessm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/29/19 12:03 AM, Chris Chiu wrote:
> We have 3 laptops which connect the wifi by the same RTL8723BU.
> The PCI VID/PID of the wifi chip is 10EC:B720 which is supported.
> They have the same problem with the in-kernel rtl8xxxu driver, the
> iperf (as a client to an ethernet-connected server) gets ~1Mbps.
> Nevertheless, the signal strength is reported as around -40dBm,
> which is quite good. From the wireshark capture, the tx rate for each
> data and qos data packet is only 1Mbps. Compare to the driver from
> https://github.com/lwfinger/rtl8723bu, the same iperf test gets ~12
> Mbps or more. The signal strength is reported similarly around
> -40dBm. That's why we want to improve.

The driver at GitHub was written by Realtek. I only published it in a prominent 
location, and fix it for kernel API changes. I would say "the Realtek driver at 
https://...", and every mention of "Larry's driver" should say "Realtek's 
driver". That attribution is more correct.
> 
> After reading the source code of the rtl8xxxu driver and Larry's, the
> major difference is that Larry's driver has a watchdog which will keep
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
> and MCS rate. However, with Larry's driver, the tx rate observed from
> wireshark under the same condition is almost 65Mbps or 72Mbps.
> 
> I believe the firmware of RTL8723BU may need fix. And I think we
> can still bring in the dm_watchdog as rtlwifi to improve from the
> driver side. Please leave precious comments for my commits and
> suggest what I can do better. Or suggest if there's any better idea
> to fix this. Thanks.
> 
> Signed-off-by: Chris Chiu <chiu@endlessm.com>

I have not tested this patch, but I plan to soon.

Larry


