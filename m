Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B505239E889
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 22:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbhFGUlV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 16:41:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231124AbhFGUlT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 16:41:19 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 522CEC061574
        for <netdev@vger.kernel.org>; Mon,  7 Jun 2021 13:39:18 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id h11-20020a05600c350bb02901b59c28e8b4so34126wmq.1
        for <netdev@vger.kernel.org>; Mon, 07 Jun 2021 13:39:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:cc:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FUxQR8UrVlgtTThlzDmQWSkbVVbnFOI5751R30+y1qM=;
        b=ESqKebZahuT1SIc6AihoOWZnKRreB2DQIZ6XGGXrFdlx+nIoeV8WY2YtYnOt2QffDF
         Bu2rix9Wsdb3S8sEjS16IJ3psiP2R/WIdxn65F0pTw9W7EGiRyrH/UPx23V7M5dXAFkg
         Qductbs+nYsEg1C/3IXnWXSFWi6eSy01ehYhOR5zMGpGwSx9xc2PM5vaLgGi8edhB/qG
         G33EgIZMPGIt2lormxN8ukq2gBrn8TONUIiXI6bJnrwnRSk5/XoisDfkKzEy/y0fwfkA
         MBL5k3pn3ip2ssWGIKcKJcWbqdfSE8b+Z0pO7dXtb673UP7N/aSkSDdfYUAq4yuxlCYY
         AZ1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:cc:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FUxQR8UrVlgtTThlzDmQWSkbVVbnFOI5751R30+y1qM=;
        b=S1al21h6u1MowlqjPzz8Yg0fB+LwH8++x6gSfOtTzZaPyoAspSfBbDRj07DHP8Irts
         VWiVxqI7VkyRP+lrgMzbWpGMbwgsvrObgp9BCEDXbqE5QHltJ1nntOJZzsb/zpbxSDIT
         Hm2o6Ki/u3vigQ5/tcJpUj5k2+tKfgmMB7eaYme5/fi1AqgkjMheggJxT8pFR+e6LKWm
         Rqd4vEygIzMVDkoW+zfbHK+HwAgDsPoEK/XsUCuNeRggq0rZU8m7vSCiXSn4YB8bJXL/
         14LtNTbCYNlAgStoBSLFNRntfTQaKXPOcS1sULmxIkI8E0N9PsPT17+YXGTeajyO9SIO
         WttQ==
X-Gm-Message-State: AOAM530R0TwqLLLu3blX25zZA/YErA1UUUWhMhIJOa5ORAvcljS8oDte
        WlZerL2tpeFlVA3jhkJmKcPcdZik0aE=
X-Google-Smtp-Source: ABdhPJzipd/EkKZbioZq+wT5vWkIKOJcENObObOaLB1spLPBA5UpcG90oSYRHFty6OVupLNw1ARcPg==
X-Received: by 2002:a1c:9dcd:: with SMTP id g196mr816841wme.135.1623098356355;
        Mon, 07 Jun 2021 13:39:16 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:c00:6021:9b38:9cf3:356a? (p200300ea8f2f0c0060219b389cf3356a.dip0.t-ipconnect.de. [2003:ea:8f2f:c00:6021:9b38:9cf3:356a])
        by smtp.googlemail.com with ESMTPSA id m3sm18068802wrr.32.2021.06.07.13.39.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Jun 2021 13:39:15 -0700 (PDT)
To:     =?UTF-8?Q?Johannes_Brandst=c3=a4tter?= <jbrandst@2ds.eu>
References: <5b08afe02cb0baa7ae3e19fd0bc9d1cbe9ea89c9.camel@2ds.eu>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: Load on RTL8168g/8111g stalls network for multiple seconds
Message-ID: <a4e4902d-5534-6c66-63f5-d88059604c78@gmail.com>
Date:   Mon, 7 Jun 2021 22:39:06 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <5b08afe02cb0baa7ae3e19fd0bc9d1cbe9ea89c9.camel@2ds.eu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07.06.2021 15:11, Johannes Brandstätter wrote:
> Hi,
> 
> just the other day I wanted to set up a bridge between an external 2.5G
> RTL8156 USB Ethernet adapter (using r8152) and the built in dual
> RTL8168g/8111g Ethernet chip (using r8169).
> I compiled the kernel as of 5.13.0-rc4 because of the r8125 supporting
> the RTL8156.
> This was done using the Debian kernel config of 5.10.0-4 as a base and
> left the rest as default.
> 
> So this setup was working the way I wanted it to, but unfortunately
> when running iperf3 against the machine it would rather quickly stall
> all communications on the internal RTL8168g.
> I was still able to communicate fine over the external RTL8156 link
> with the machine.
> Even without the generated network load, it would occasionally become
> stalled.
> 
> The only information I could really gather were that the rx_missed
> counter was going up, and this kernel message some time after the stall
> was happening:
> 
> [81853.129107] r8169 0000:02:00.0 enp2s0: rtl_rxtx_empty_cond == 0
> (loop: 42, delay: 100).
> 
> Which has apparently to do with the wait for an empty fifo within the
> r8169 driver.
> 
> Until that the machine (an UP² board) using the RTL8168g ran without
> any issues for multiple years in different configurations.
> Only bridging immediately showed the issue when given enough network
> load.
> 
> After many hours of trying out different things, nothing of which
> showed any difference whatsoever, I tried to replace the internal
> RTL8168g with an additional external USB Ethernet adapter which I had
> laying around, having a RTL8153 inside.
> 
> Once the RTL8168g was removed and the RTL8153 added to the bridge, I
> was unable to reproduce the issue.
> Of course I'd rather like to make use of the two internal Ethernet
> ports if I somehow can.
> 
> So is there anything I could try to do?
> 
Do you have flow control enabled? From 5.13-rc r8169 supports adjusting
pause settings via ethtool. You could play with the settings to see
whether it makes a difference.
Next thing you could check is whether the issue persists when using
the r8168 vendor driver.

However I'm not an expert in bridging and don't know which difference
it could make whether a NIC is operated standalone or as part of a bridge.

> I'm eyeing with a regression test next on the kernel's r8168 driver.
> Though this is without me knowing if there ever was a working version.
> As this is a rather large task, with only limited time I wanted to seek
> out some help before I go down that route.
> 
> Maybe you could point me into the right direction, as to what to try
> next.
> 
> Thanks and best regards,
> Johannes
> 
Heiner
