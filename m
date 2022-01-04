Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3CD483BD3
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 07:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232871AbiADGH3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 01:07:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230181AbiADGH2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 01:07:28 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4CD0C061761
        for <netdev@vger.kernel.org>; Mon,  3 Jan 2022 22:07:27 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id u8so42994914iol.5
        for <netdev@vger.kernel.org>; Mon, 03 Jan 2022 22:07:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=egauge.net; s=google;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :organization:user-agent:mime-version:content-transfer-encoding;
        bh=nx5TEoMR327bXdXNPVuwuMbG4iUKlSWKPeyufsnSwk4=;
        b=aPtTkfNCbSTj9HkncfH7DdyXSIT92UhpTJ7nygMD3QFqmJDJ6k+lGIKdsuiMPHQ/uq
         MCW3o0WIUABBSdPKAL8PNN/ZXmCkt57FXRbAWQRtfejIhomx9Mg0wtORq9M0INs1LFVP
         nJ8MMYcuQ80/ODy6r4eh0G/J5H234T6F79mb2w0Gi0WsbaMvMAJecKQQ/Qmd0505FCAG
         +B1YLJnwNsDHsv9cMTNyZ5kKWXoUNyJDijrL8ltqPN/whXIzN2hY9TVx3iSTNA5bhrt2
         2/CSLyObCbwbSP9iNTs0gg52fAwBfu2y5cA9NKY9l1fEaPcdc/eXTo6A2W8J4ndnnj0y
         K0mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=nx5TEoMR327bXdXNPVuwuMbG4iUKlSWKPeyufsnSwk4=;
        b=kcddWl/vH8zmBcrdEKUvjTAIFhgSYwexBw951uomtA082TPGogzrXvzdQP+qZx+CPs
         3ljxm0yA9987sMaEAOW4Md5KmzKADDeIOPsEFAbO9YL1D101O9O5vOPb0QqFVVvN+5/t
         0mEZYBDuK51MDNMNkL5lI/2YBDkaSGsNGGij6zXtctz0MP4mlE5Uodoc4X2zZ0jfQAwg
         2VCmY76iKYAKEiG5XdKW7/WoGTz09x52apecEetTYdCL9oDSrXchZfetOwGqfmvdDkUX
         xK8xaOihVozuujykHNrmFQlOOB7RUpwRruWWtKX8irYVJSwKM7OpCaL/FQOTim09cwdh
         T49w==
X-Gm-Message-State: AOAM530pCJk80FbTeOLOUFAejNS7U8NOZNw/qB0nwi+/Z4A3CyrVCDW6
        JEmIxYdGHPch8D+kh5nrLTFy
X-Google-Smtp-Source: ABdhPJxM7SkcTdr6BLfIsTxkuWhKpEt8bp/Mi6QSizBZDQLTwLvRj6lMEd+ZK+CG0kaJqshHOyGX2g==
X-Received: by 2002:a05:6638:348c:: with SMTP id t12mr22943034jal.269.1641276446974;
        Mon, 03 Jan 2022 22:07:26 -0800 (PST)
Received: from ?IPv6:2601:281:8300:4e0:2ba9:697d:eeec:13b? ([2601:281:8300:4e0:2ba9:697d:eeec:13b])
        by smtp.gmail.com with ESMTPSA id w6sm15483471ilv.18.2022.01.03.22.07.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 22:07:26 -0800 (PST)
Message-ID: <75d5d39874f28b91c5abfff6e6a05421e8529264.camel@egauge.net>
Subject: Re: [PATCH] wilc1000: Allow setting power_save before driver is
 initialized
From:   David Mosberger-Tang <davidm@egauge.net>
To:     Ajay.Kathat@microchip.com
Cc:     Claudiu.Beznea@microchip.com, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 03 Jan 2022 23:07:24 -0700
In-Reply-To: <f961481a-3f4c-5fd2-c46a-037d923fea4c@microchip.com>
References: <20211212011835.3719001-1-davidm@egauge.net>
         <6fc9f00aa0b0867029fb6406a55c1e72d4c13af6.camel@egauge.net>
         <5378e756-8173-4c63-1f0d-e5836b235a48@microchip.com>
         <31d5e7447e4574d0fcfc46019d7ca96a3db4ecb6.camel@egauge.net>
         <49a5456d-6a63-652e-d356-9678f6a9b266@microchip.com>
         <523698d845e0b235e4cbb2a0f3cfaa0f5ed98ec0.camel@egauge.net>
         <122f79b7-7936-325c-b2d9-e15db6642d0f@microchip.com>
         <be3c95c8310504222e88c602a937b7f05cc01286.camel@egauge.net>
         <9272b86e-61ab-1c25-0efb-3cdd2c590db8@microchip.com>
         <e7247265d5309165140d7a9a3af646129a789d58.camel@egauge.net>
         <f961481a-3f4c-5fd2-c46a-037d923fea4c@microchip.com>
Organization: eGauge Systems LLC
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ajay,

On Thu, 2021-12-30 at 16:24 +0000, Ajay.Kathat@microchip.com wrote:
> On 24/12/21 23:08, David Mosberger-Tang wrote:
> > On Fri, 2021-12-24 at 16:20 +0000, Ajay.Kathat@microchip.com wrote:
> > > On 23/12/21 22:38, David Mosberger-Tang wrote:
> > > > First, on a freshly booted system and with wilc1000-spi autoloaded by
> > > > the kernel, try this sequence (copy & paste the commands):
> > > > 
> > > >     /usr/sbin/wpa_supplicant -Bs -iwlan0 -c/etc/wpa_supplicant.conf
> > > >     sleep 10
> > > >     iw dev wlan0 set power_save on
> > > > 
> > > > The above yields a power consumption of 1.4W reliably.  The "sleep 10"
> > > > doesn't matter here; the behavior is the same with or without it.  I
> > > > tried waiting up to 120 seconds with no difference.
> > > 
> > > I have tested by making the WILC as build-in module to insert driver
> > > automatically at boot-up. I hope it should be fine. Because I have
> > > already tested as loadable module earlier.
> > > 
> > > Below are the number observed
> > > ------------------------------ --------------------------
> > > - before starting wpa_supplicant             : ~16.3 mA
> > > - wpa_supplicant started                         : ~40 mA
> > > - PSM on                                                  :  ~6 mA
> > > 
> > > 
> > > The 'sleep 10' would have no impact in my setup because I have measured
> > > the current consumption for wilc1000 chip.
> > > 
> > > I have shared the screenshot at https://postimg.cc/67S41dkb
> > 
> > Huh, that's curious.  I definitely cannot reproduce this.  To match
> > your setup as closely as possibly, I also built wilc1000-spi into the
> > kernel, but that makes no difference (as expected).
> > 
> > What kernel version are you on?  I switched to wireless-drivers-next as
> > of today (latest commit d430dffbe9dd30759f3c64b65bf85b0245c8d8ab).
> 
> I have tested with 5.10 as well as with 5.16-rc1(commit#
> fa55b7dcdc43). I don't think WILC1000 chip PS gets affected because
> of a specific kernel version. 
> 
> > With this kernel, the numbers are about 100mW lower than reported
> > before, but the relative behavior is the same: about 300mW higher
> > power-consumption when PSM is not taking effect properly.
> > 
> > To recap, back with wilc1000-spi being a module again, after freshly
> > booting the system and issuing this commands:
> > 
> >    /usr/sbin/wpa_supplicant -Bs -iwlan0 -c/etc/wpa_supplicant.conf
> >    /usr/sbin/iw dev wlan0 set power_save on
> > 
> > I see a power-consumption of about 1.25W.  PSM on/off makes no
> > difference in this state.  Then, if I issue the commands:
> > 
> > rmmod wilc1000-spi
> > modprobe wilc1000-spi
> > sleep 10
> > iw dev wlan0 set power_save on
> > 
> > power-consumption drops to about 0.9W.
> > 
> > Here is a screenshot that shows the annotated power-measurements:
> > 
> >    https://postimg.cc/3dbKSGht
> > 
> > Apart from kernel version, the only things that I can think of that'd
> > be different is that we don't have the ENABLE pin wired to a GPIO.
> >  Instead, the chip is always enabled.  I doubt this would explain the
> > difference (~RESET is wired to a GPIO).
> 
> When PS mode is enabled, the host can wake-up the chip, if there is
> some data to transfer. Just check, if there is any network
> application trying to access WILC (send continuous data) in your
> setup.

That shouldn't be an issue.  To confirm, in the output below, I
included the ifconfig stats so you can see that there is virtually no
traffic during the measurement periods.

>  Also, you have mentioned that removing the module(without killing
> the wpa_supplicant) worked so I guess, it might be possible that the
> application got interrupted when the module was removed and didn't
> start when the module was inserted again. 

There are no applications running on the system at all.  I tested the
two command sequences in the exact same setup, with everything that
normally runs on our system disabled.  CPU utilization is basically 0%.

> Try disabling CONFIG_CFG80211_DEFAULT_PS config to check if it has any impact.

I already had CONFIG_CFG80211_DEFAULT_PS disabled.  It makes no
difference, except that with CONFIG_CFG80211_DEFAULT_PS enabled, you
have to issue "power_save off" before "power_save on" to get PSM to
take effect since cfg80211 thinks power-save is already enabled when
it's not.

To mirror your setup more closely, I installed a 1 ohm shunt resistor
on the 3.3V supply to the WILC1000 so I can measure current draw of the
WILC1000 alone.  This is just for paranoia's sake to make sure there is
nothing wonky going on outside of the WILC1000 (there is not).  So the
current draws mentioned below are at 3.3V and DC average measures
across 1 minute.

First test command sequence (power saving fails to take effect):

   ------------------------------------------------------------------
   REBOOT SYSTEM
   # ifconfig wlan0 | tail -5
             RX packets:0 errors:0 dropped:0 overruns:0 frame:0
             TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
             collisions:0 txqueuelen:1000
             RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
   # /usr/sbin/wpa_supplicant -Bs -iwlan0 -c/etc/wpa_supplicant.conf
   # iw dev wlan0 set power_save on
   # sleep 60
   # ifconfig wlan0 | tail -5
             RX packets:51 errors:0 dropped:0 overruns:0 frame:0
             TX packets:37 errors:0 dropped:0 overruns:0 carrier:0
             collisions:0 txqueuelen:1000
             RX bytes:5980 (5.8 KiB)  TX bytes:5425 (5.2 KiB)
   ------------------------------------------------------------------

with the above command sequence, current-draw remains pretty much
constant at 76mA.


Second test command sequence (power saving successfully takes effect):

   ------------------------------------------------------------------
   REBOOT SYSTEM
   # ifconfig wlan0 | tail -5
             RX packets:0 errors:0 dropped:0 overruns:0 frame:0
             TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
             collisions:0 txqueuelen:1000
             RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
   # /usr/sbin/wpa_supplicant -Bs -iwlan0 -c/etc/wpa_supplicant.conf
   # sleep 15
   # iw dev wlan0 set power_save on
   # sleep 60
   # ifconfig wlan0 | tail -5
             RX packets:41 errors:0 dropped:0 overruns:0 frame:0
             TX packets:34 errors:0 dropped:0 overruns:0 carrier:0
             collisions:0 txqueuelen:1000
             RX bytes:5007 (4.8 KiB)  TX bytes:5436 (5.3 KiB)
   ------------------------------------------------------------------

with the above command sequence, current-draw fluctuates quite a bit,
but averages to somewhere around 15mA.

The exact amount of time needed between starting wpa_supplicant and
issuing the PSM on command fluctuates a bit.  Sometimes 9 seconds is
enough, but oftentimes a pause of 10-15 seconds is required.

A screenshot of the current draw for this command sequence is graphed
here:

  https://postimg.cc/bZc1v0jR

Oh, and just at the off-chance that the association details matters:

      # wpa_cli status
      Selected interface 'wlan0'
      bssid=d8:07:b6:af:4b:e4
      freq=2442
      ssid=MOSTANG
      id=0
      mode=station
      pairwise_cipher=CCMP
      group_cipher=CCMP
      key_mgmt=WPA2-PSK
      wpa_state=COMPLETED
      p2p_device_address=f8:f0:05:62:76:48
      address=f8:f0:05:62:76:48
      uuid=22b21bb3-ec5a-5038-aa7f-911a2b012173

  --david

