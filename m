Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 334A510A5C2
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 22:04:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbfKZVEI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 16:04:08 -0500
Received: from mail-pg1-f176.google.com ([209.85.215.176]:42997 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726072AbfKZVEH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 16:04:07 -0500
Received: by mail-pg1-f176.google.com with SMTP id i5so1337212pgj.9
        for <netdev@vger.kernel.org>; Tue, 26 Nov 2019 13:04:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=MgDaFYIl+nmxcF1ttpkfkxYZysv26OGhpi/Bg8X3YIc=;
        b=OLZ8Ck6MXeyMgLph8V4PrhVZphYdAlcs3nof6TdxjUzEqImXbrNxyeFKPg4H/TE5Q/
         Ja2/a/EBUvP1rS/yVs6LflBwyUaTkgiaU/6uay7k5zVjkq/5IsQkhO2kQI0gmG+gtxom
         hs2M4LiDx6VzN9W5qYGHflh918vSEoYIFLMKLgtemnPL6OoyNgcX4RIny55Wr/NLAPoi
         Bbx+CF3faxOr9c07fxpJBowbBToqRsD+FlCjJQjFZ5QzzLr2/Vv89Y2z2DICtjtJyijK
         h5BnL8HBCBIwSe8QKpFZxwrIKXMYELvy5w1aoLJfRq1xLoYXdihLUkzQA/9cfa+v7jE3
         rb2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=MgDaFYIl+nmxcF1ttpkfkxYZysv26OGhpi/Bg8X3YIc=;
        b=nNUc8KZzPcCl+wYGffDnkWIQLc/gNvx7dgBwItyeFTmDgn5yFcI2RM+lhINlW6M5mr
         oZgA+sayNeqAywAMCgYDDXCuOFXsc+rAxLRaHNNU2kHqQw5UPA4ARpRomrpoLDKwfY4f
         OCEsDuxaHmct6b43t+cwW3Ici8POK1rw08SEKBkqYDz1Gon2snxUfrQYhSmzv3LXmBsb
         lMiMnP4v4j3sEQJpVVczU9GtfgL/w6Hfc5UFSL0t3378gDDlSSp3bg1Byi3dCbtIE6uv
         uh6oli+jXOXp6cwCrun7yrKmp1N4APZM/nQG2UwHTlK1cCFjNQrpJCe0/oMNifdllGuF
         bCNA==
X-Gm-Message-State: APjAAAX6ax2i6EDIL8jx/73qa3XRsQ+chXrhd7n1E90ispbJ+WQIQ1RM
        OIpAVLu8EYNcXp4cBqP2hImIyJlYymy5aQ==
X-Google-Smtp-Source: APXvYqwUoUt7xXJ4U7rxhpnrlJVIPuCcAfTFSnIOfpQ5FSJHlURR5QVkFi6x5UYg09nTVWJ1CHRbHA==
X-Received: by 2002:a65:4085:: with SMTP id t5mr489221pgp.335.1574802244799;
        Tue, 26 Nov 2019 13:04:04 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.79])
        by smtp.gmail.com with ESMTPSA id 16sm13729946pgm.86.2019.11.26.13.04.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Nov 2019 13:04:03 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
Subject: iwlwifi broken in current -git
To:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Message-ID: <49461e53-e2fe-8a7a-47a3-7de966cb1298@kernel.dk>
Date:   Tue, 26 Nov 2019 14:04:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Just upgraded my laptop, and iwlwifi won't connect. Not specific to
the AP, tried a few and no go. Here are the dmesg from loading and
trying to connect, at some point it just gives up and asks me for
a password again. v5.4 works just fine.

The laptop is a gen7 x1 carbon.

[   43.426111] Intel(R) Wireless WiFi driver for Linux
[   43.426112] Copyright(c) 2003- 2015 Intel Corporation
[   43.428039] iwlwifi 0000:00:14.3: Found debug destination: EXTERNAL_DRAM
[   43.428040] iwlwifi 0000:00:14.3: Found debug configuration: 0
[   43.428222] iwlwifi 0000:00:14.3: loaded firmware version 46.6bf1df06.0 op_mode iwlmvm
[   43.491333] iwlwifi 0000:00:14.3: Detected Intel(R) Wireless-AC 9560 160MHz, REV=0x318
[   43.498760] iwlwifi 0000:00:14.3: Applying debug destination EXTERNAL_DRAM
[   43.498899] iwlwifi 0000:00:14.3: Allocated 0x00400000 bytes for firmware monitor.
[   43.541238] iwlwifi 0000:00:14.3: base HW address: dc:fb:48:b8:c6:b7
[   43.609556] ieee80211 phy1: Selected rate control algorithm 'iwl-mvm-rs'
[   43.610718] thermal thermal_zone6: failed to read out thermal zone (-61)
[   43.615027] iwlwifi 0000:00:14.3 wlp0s20f3: renamed from wlan0
[   43.730438] iwlwifi 0000:00:14.3: Applying debug destination EXTERNAL_DRAM
[   43.843856] iwlwifi 0000:00:14.3: Applying debug destination EXTERNAL_DRAM
[   43.909456] iwlwifi 0000:00:14.3: FW already configured (0) - re-configuring
[   47.273349] wlp0s20f3: authenticate with b6:fb:e4:19:db:06
[   47.279427] wlp0s20f3: send auth to b6:fb:e4:19:db:06 (try 1/3)
[   47.319107] wlp0s20f3: authenticated
[   47.328669] wlp0s20f3: associate with b6:fb:e4:19:db:06 (try 1/3)
[   47.332601] wlp0s20f3: RX AssocResp from b6:fb:e4:19:db:06 (capab=0x1011 status=0 aid=2)
[   47.334815] wlp0s20f3: associated
[   51.372005] wlp0s20f3: deauthenticated from b6:fb:e4:19:db:06 (Reason: 2=PREV_AUTH_NOT_VALID)
[   51.759486] wlp0s20f3: authenticate with fe:ec:da:39:00:eb
[   51.766866] wlp0s20f3: send auth to fe:ec:da:39:00:eb (try 1/3)
[   51.812724] wlp0s20f3: authenticated
[   51.818693] wlp0s20f3: associate with fe:ec:da:39:00:eb (try 1/3)
[   51.822934] wlp0s20f3: RX AssocResp from fe:ec:da:39:00:eb (capab=0x1411 status=0 aid=2)
[   51.825218] wlp0s20f3: associated
[   55.828019] wlp0s20f3: deauthenticated from fe:ec:da:39:00:eb (Reason: 2=PREV_AUTH_NOT_VALID)

-- 
Jens Axboe

