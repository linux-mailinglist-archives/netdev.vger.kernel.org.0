Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88FE44775ED
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 16:30:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238540AbhLPPab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 10:30:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbhLPPab (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 10:30:31 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08075C06173F
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 07:30:31 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id y16so35677789ioc.8
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 07:30:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=egauge.net; s=google;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :organization:user-agent:mime-version:content-transfer-encoding;
        bh=jGnQ+OPrwZnzJ8pyH0xcyxgi+zeh7zrbZx5puPpeqp0=;
        b=QVklmRMQ0JGDggaCYuzwfz1eEj0x1VCMw8SWiA4SxuTg7pcKLnX1ZDEt12qAVXZB6x
         cNL6PrMlUuJgbVvUDaE+pMbp6+fXmYgmJ11Fjo4lqDWj81gSjwurjg2k1rCLeDAPj7XG
         66X5CKzvdT7SxpluJPG9/sfFU3zAFlVaT3ilubedOHkRJRZW5GCy8GuEvyVXL4KVsbS6
         VaXpFl47Llvp6ZuaveGZpC3DqjaVC3TRv3MmcjV8Kv0h7bJ5DorpTY4dKDEQQQ8C4aLn
         cnrW1ZiTmmS+WfoPBFRuPPpQ79p4XUIRynHaW4zkAnThOoTBAsfGgv4OTH5WTTvQyoMq
         /K+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=jGnQ+OPrwZnzJ8pyH0xcyxgi+zeh7zrbZx5puPpeqp0=;
        b=cLYkzuY+Rio0E0PxfTMM6C2Ej8+mdF7EXniMA2SSkefacOaoZUn9/olwNLdlxr/9zc
         Xv/OsbR531SjY9A4EgZX6/DpnEuxel445b/ki/8+PVn1hSX2plhq95YIXMJVFKMoBorm
         iDp+4EaHMMPkXv/aZaoO2EtmWvu+k+PslNX2QSrgWXYt/1geBwMswE/5XN3muqvivljQ
         Y4yOMWwbkaUWEwuv+MqHClNpJoSGPUh5gWwqLbpJqzhbzO8uSZiwmyv3zIqB0YX2dOry
         EMKx42Jdj5DT+4LyTWPUUsSqjMsdbV1Kam0H0NGFZkrIZeNYuXc/i5aKbojyXHhfjxf7
         ogZQ==
X-Gm-Message-State: AOAM532mLqGn4SN6lg+5xYC+ygJuxmaW/UiFNOCXivYuC6M4LQWAI6AQ
        6RZRteFlB0GSWBkhG2J25Hcp
X-Google-Smtp-Source: ABdhPJwSNxt4l43qiKVjKknNIohi54ACnOdcombw2k7cHxehnYilM+rc/JX0noSMD8O0Ufbh0WUvdw==
X-Received: by 2002:a05:6602:27cc:: with SMTP id l12mr9797623ios.59.1639668630279;
        Thu, 16 Dec 2021 07:30:30 -0800 (PST)
Received: from bixby.lan (c-73-181-115-211.hsd1.co.comcast.net. [73.181.115.211])
        by smtp.gmail.com with ESMTPSA id x11sm2829669iop.55.2021.12.16.07.30.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 07:30:29 -0800 (PST)
Message-ID: <523698d845e0b235e4cbb2a0f3cfaa0f5ed98ec0.camel@egauge.net>
Subject: Re: [PATCH] wilc1000: Allow setting power_save before driver is
 initialized
From:   David Mosberger-Tang <davidm@egauge.net>
To:     Ajay.Kathat@microchip.com
Cc:     Claudiu.Beznea@microchip.com, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 16 Dec 2021 08:30:28 -0700
In-Reply-To: <49a5456d-6a63-652e-d356-9678f6a9b266@microchip.com>
References: <20211212011835.3719001-1-davidm@egauge.net>
         <6fc9f00aa0b0867029fb6406a55c1e72d4c13af6.camel@egauge.net>
         <5378e756-8173-4c63-1f0d-e5836b235a48@microchip.com>
         <31d5e7447e4574d0fcfc46019d7ca96a3db4ecb6.camel@egauge.net>
         <49a5456d-6a63-652e-d356-9678f6a9b266@microchip.com>
Organization: eGauge Systems LLC
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-12-16 at 13:01 +0000, Ajay.Kathat@microchip.com wrote:
> On 16/12/21 11:07, David Mosberger-Tang wrote:
> > EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> > 
> > On Wed, 2021-12-15 at 13:01 +0000, Ajay.Kathat@microchip.com wrote:
> > > On 13/12/21 02:50, David Mosberger-Tang wrote:
> > > > EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> > > > 
> > > > Unfortunately, this patch doesn't seem to be sufficient.  From what I
> > > > can tell, if power-save mode is turned on before a station is
> > > > associated with an access-point, there is no actual power savings.  If
> > > > I issue the command after the station is associated, it works perfectly
> > > > fine.
> > > > 
> > > > Ajay, does this make sense to you?
> > > 
> > >   <snip>
> > > Power-save mode is allowed to be enabled irrespective of station
> > > association state. Before association, the power consumption should be
> > > less with PSM enabled compared to PSM disabled. The WLAN automatic power
> > > save delivery gets enabled after the association with AP.
> > > 
> > > To check the power measurement before association,  test without
> > > wpa_supplicant.
> > > 
> > > 
> > > Steps:
> > > - load the module
> > > - ifconfig wlan0 up
> > > - iw dev wlan0 set power_save off (check the pwr measurement after PS
> > > mode disabled)
> > > - iw dev wlan0 set power_save on (check the pwr measurement after PS
> > > mode enable)
> > 
> > It appears wpa_supplicant consistently renders PSM ineffective:
> > 
> >                                 (current draw, 1 min avg):
> > ------------------------------  --------------------------
> > - base case (no module loaded): 16.8 mA
> > - module loaded & PSM on      : 16.8 mA
> > - wpa_supplicant started      : 19.6 mA
> > - PSM on                      : 19.6 mA (no change)
> > - PSM off                     : 19.6 mA (no change)
> > - PSM on                      : 15.4 mA
>  
> From the above data, it looks like there is no difference with or without PSM
> in your setup. I am not sure if the values are captured correctly. Did you use
> power measurement ports in WILC extension for the current measurements.

Oh, no, not at all!  There is a nice power savings when PSM actually takes hold.
 Current drops from 19.6mA to 15.4mA as shown by the last two lines.

This is average current draw at 120V for the entire board, as my board is not
set up to measure chip current draw alone.

> 
> > What's strange is when I try this sequence a couple of times in a row,
> > the device gets into a state where after starting wpa_supplicant, no
> > amount of PSM on/off commands will get it to enter power-savings mode
> > any more.  When in that state, only removing wilc1000-spi.ko and adding
> > it back gets it out of that state.  A power-cycle does not.  Very
> > confusing.
> 
> Btw, I did a quick test to verify current measurement with PS mode off/on and observed numbers like below
> 
> Tested by making the interface up(ifconfig wlan0 up) then issued 'iw' command to enable/disable PS mode. 
> 
>                               (current draw)
> ------------------------------------------------------
> - PSM off                    : 75.5 mA
> - PSM on                     : 1.28 mA
> 
> 
> I have verified for SPI module with the setup mentioned in link[1] and used power debugger[2]
> 
> 1. https://ww1.microchip.com/downloads/en/Appnotes/ATWILC1000-Power-Measurement-for-Wi-Fi-Link-Controller-00002797A.pdf
> 2. https://www.microchip.com/en-us/development-tool/ATPOWERDEBUGGER

Sure, I assume your measurements are at 3.3V for the chip alone.

But the question is: what happens once you start wpa_supplicant?

  --david


