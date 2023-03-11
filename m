Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 317A66B57C4
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 03:16:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbjCKCQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 21:16:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbjCKCQK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 21:16:10 -0500
Received: from mail-oa1-x2c.google.com (mail-oa1-x2c.google.com [IPv6:2001:4860:4864:20::2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A2A112B03A;
        Fri, 10 Mar 2023 18:16:09 -0800 (PST)
Received: by mail-oa1-x2c.google.com with SMTP id 586e51a60fabf-176d1a112bfso7952970fac.5;
        Fri, 10 Mar 2023 18:16:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678500968;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=ZwbsJOMHSTUiw2/Pz1GfWok5OJeYHWUXNesvguteUjE=;
        b=NxxqIYULWFzLjQ4ft5Hk6hK8s7I/LyZqI6ItrgbZynMnFrpJBF4B50Wb6NV2C37d+E
         5LdcpqtH5szP9rhMbIaG0IclrBQMRCWdXMJ9+GvZG1VYkt3OcQ712kQbiBOBih1gP15u
         u9X3IjzwtpxygHr+MlBAzbhtlBaXTXLXGamX9d/Ojh2kuCxtXxiaZ72H8mWMMCwx9xKS
         S8i7Oz7tKLbEqIp6rUgMreeZopeLRW+RvkWgCDlTUcL0TQT+IGYan6UkkMtpuaP/kekl
         tOKb3XeZPK6RupJncdHxdJLrHI1shza6PodA0Bw1UhGCPelRLxWj4CXQR9f1xhWFA29w
         FUCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678500968;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZwbsJOMHSTUiw2/Pz1GfWok5OJeYHWUXNesvguteUjE=;
        b=E/rTos4xMj/Yba8UAyGiQMXYq36g52kX51iE0apR669kM4LfMsOZ5l8R0SBhXl1kXR
         eKs7l++J6TKJ5luQFYjEeLfXLX//hXWO7EWSeYLOhf6NaLpYSzjmcFRxJ5YpSaG+4x+P
         6Mrz1ZH1SVba12QlZnFYiUpajGh/J7DS06QKOQWT1a5guzEHADsCbzcaPm2CL7oTA4vu
         ljIMTjJIFw48yBUKplorAgRkUqGfTePlXU8AX/NthlUYoXDKizDiaBqb27cHwD6Jmr8D
         ptBVj0xA3TF1MWVxi/RQXANs1Nv46EAGaKnEfs8R+QVGRcdKW4cD/sSfvKobK6DMIFli
         oyTw==
X-Gm-Message-State: AO0yUKXS/uTu5Xr7BZN4IONnVfHChVLTnku904fLj292y/B8YzNVfrd/
        82ys+8A5rPvApwfMFHDcwdQ=
X-Google-Smtp-Source: AK7set8mwIIcroOqVb0ozzDHUdwzROK06+ShAHLDkAR+Nwr+lUsOQqNxQtGMvnuMwH4LT8KSNOHO4w==
X-Received: by 2002:a05:6870:1602:b0:172:233a:c3da with SMTP id b2-20020a056870160200b00172233ac3damr16689052oae.28.1678500968371;
        Fri, 10 Mar 2023 18:16:08 -0800 (PST)
Received: from [192.168.0.156] ([216.130.59.33])
        by smtp.gmail.com with ESMTPSA id v12-20020a056820100c00b0051d198cf30asm560450oor.48.2023.03.10.18.16.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Mar 2023 18:16:07 -0800 (PST)
Sender: Larry Finger <larry.finger@gmail.com>
Message-ID: <174f91fc-7629-e380-4ca1-56eb39ea24ea@lwfinger.net>
Date:   Fri, 10 Mar 2023 20:16:06 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v2 RFC 0/9] rtw88: Add SDIO support
Content-Language: en-US
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        linux-wireless@vger.kernel.org
Cc:     Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-mmc@vger.kernel.org, Chris Morgan <macroalpha82@gmail.com>,
        Nitin Gupta <nitin.gupta981@gmail.com>,
        Neo Jou <neojou@gmail.com>, Pkshih <pkshih@realtek.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>
References: <20230310202922.2459680-1-martin.blumenstingl@googlemail.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <20230310202922.2459680-1-martin.blumenstingl@googlemail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/10/23 14:29, Martin Blumenstingl wrote:
> Recently the rtw88 driver has gained locking support for the "slow" bus
> types (USB, SDIO) as part of USB support. Thanks to everyone who helped
> make this happen!
> 
> Based on the USB work (especially the locking part and various
> bugfixes) this series adds support for SDIO based cards. It's the
> result of a collaboration between Jernej and myself. Neither of us has
> access to the rtw88 datasheets. All of our work is based on studying
> the RTL8822BS and RTL8822CS vendor drivers and trial and error.
> 
> Jernej and myself have tested this with RTL8822BS and RTL8822CS cards.
> Other users have confirmed that RTL8821CS support is working as well.
> RTL8723DS may also work (we tried our best to handle rtw_chip_wcpu_11n
> where needed) but has not been tested at this point.
> 
> Jernej's results with a RTL8822BS:
> - Main functionality works
> - Had a case where no traffic got across the link until he issued a
>    scan
> 
> My results with a RTL8822CS:
> - 2.4GHz and 5GHz bands are both working
> - TX throughput on a 5GHz network is between 50 Mbit/s and 90 Mbit/s
> - RX throughput on a 5GHz network is at 19 Mbit/s (this seems to be
>    an combination of the location of my board and the cheap antenna
>    which are both hurting RX performance)
> 
> A user shared his results on his own RTL8822CS off-list with me:
> - 50Mbit/s throughput in both directions
> 
> A user shared his results on RTL8821CS off-list with me:
> - 50Mbps down and 25Mbps on a 5GHz network
> 
> Why is this an RFC?
> - I think it's worth to get another round of feedback from the rtw88
>    maintainers
> - As with most patches: testing is very welcome. If things are working
>    fine then a Tested-by is appreciated (with some details about the
>    card, throughput, ...). If something doesn't work for you: please
>    still report back so we can investigate that problem!
> 
> Changes since v1 at [0]:
> - removed patches 1-8 as they have been submitted and separately (they
>    were indepdent and this helped cutting down the size of this series)
> - dropped patch "rtw88: ps: Increase LEAVE_LPS_TRY_CNT for SDIO based
>    chipsets" as the underlying issue has been fixed - most likely with
>    upstream commit 823092a53556eb ("wifi: rtw88: fix race condition
>    when doing H2C command")
> - rework the code so we don't need a new HCI specific power_switch
>    callback by utilizing the RTW_FLAG_POWERON flag which was recently
>    introduced
> - various patches include the feedback from reviewers and build
>    testing robots (see the individual patches for details)
> 
> 
> [0] https://lore.kernel.org/lkml/a2449a2d1e664bcc8962af4667aa1290@realtek.com/T/
> 
> 
> Jernej Skrabec (1):
>    wifi: rtw88: Add support for the SDIO based RTL8822BS chipset
> 
> Martin Blumenstingl (8):
>    wifi: rtw88: Clear RTW_FLAG_POWERON early in rtw_mac_power_switch()
>    wifi: rtw88: sdio: Add HCI implementation for SDIO based chipsets
>    wifi: rtw88: mac: Support SDIO specific bits in the power on sequence
>    wifi: rtw88: main: Add the {cpwm,rpwm}_addr for SDIO based chipsets
>    wifi: rtw88: main: Reserve 8 bytes of extra TX headroom for SDIO cards
>    mmc: sdio: add Realtek SDIO vendor ID and various wifi device IDs
>    wifi: rtw88: Add support for the SDIO based RTL8822CS chipset
>    wifi: rtw88: Add support for the SDIO based RTL8821CS chipset
> 
>   drivers/net/wireless/realtek/rtw88/Kconfig    |   36 +
>   drivers/net/wireless/realtek/rtw88/Makefile   |   12 +
>   drivers/net/wireless/realtek/rtw88/debug.h    |    1 +
>   drivers/net/wireless/realtek/rtw88/mac.c      |   51 +-
>   drivers/net/wireless/realtek/rtw88/mac.h      |    1 -
>   drivers/net/wireless/realtek/rtw88/main.c     |    9 +-
>   drivers/net/wireless/realtek/rtw88/reg.h      |   12 +
>   .../net/wireless/realtek/rtw88/rtw8821cs.c    |   35 +
>   .../net/wireless/realtek/rtw88/rtw8822bs.c    |   35 +
>   .../net/wireless/realtek/rtw88/rtw8822cs.c    |   35 +
>   drivers/net/wireless/realtek/rtw88/sdio.c     | 1251 +++++++++++++++++
>   drivers/net/wireless/realtek/rtw88/sdio.h     |  175 +++
>   include/linux/mmc/sdio_ids.h                  |    9 +
>   13 files changed, 1654 insertions(+), 8 deletions(-)
>   create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8821cs.c
>   create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822bs.c
>   create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822cs.c
>   create mode 100644 drivers/net/wireless/realtek/rtw88/sdio.c
>   create mode 100644 drivers/net/wireless/realtek/rtw88/sdio.h

Martin,

I am not qualified to review the code, but I am integrating this version into my 
rtw88 repo at GitHub.com.

It is essential that a successful build is possible after every patch is applied 
so that an arbitrary bisection will not fail to build. This patch series fails 
after #2 is committed. File mac.c needs symbol SDIO_LOCAL_OFFSET, which was 
moved from mac.h to sdio.h. I resolved this be including sdio.h in mac.c. This 
breaks #3, where you add the include to mac.c. It needs to happen one patch earlier.

The other problem for my repo is that it cannot modify 
include/linux/mmc/sdio_ids.h, thus I have to create a local sdio_ids.h to 
contain the new definitions. Once your patches are in the kernel, I will be able 
to eliminate this work around.

I do not have any rtw88 SDIO devices, thus I will not be able to test, but I 
will pass any information that I get from my users.

Larry


