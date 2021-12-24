Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB3A47F069
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 18:38:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353351AbhLXRin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Dec 2021 12:38:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353339AbhLXRil (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Dec 2021 12:38:41 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72FA4C061759
        for <netdev@vger.kernel.org>; Fri, 24 Dec 2021 09:38:41 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id d14so7054464ila.1
        for <netdev@vger.kernel.org>; Fri, 24 Dec 2021 09:38:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=egauge.net; s=google;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :organization:user-agent:mime-version:content-transfer-encoding;
        bh=U47rTAPXH+aLFRV5bwaR5qoQIKBvtt8C4VdyaJsNXDc=;
        b=YT53nncZQkXbKVlUkM490Q/adPXhTSoawpsSGMxPGkw2Hgz3QHlCS1hD0/tBG8zQ6F
         AzWS4093FHsc897g452gLe9pUqRHXitZTCZlvI5JxM3q8u8pJOh+2NwoRrGFDJaZ1Enu
         H/+a45kB87oTu99tP/wh+ZfDY1OzWMiVSGnINGplU55dQb3PL/m9f7nU+l5BUhv3DgTo
         lYm8a/wz8HQ33jpBwaUtUhMupOb2aaCt9NNwt9JMXXgD5INW2HhLZQ3NgiYqtcw0dFpn
         EFFSlA7DT+qm1aigkwJsXgMuRZQpaYU4bsJEWyM1YvFS5E11kQ+RyzEpN3q9cJGxvA9/
         Q9Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=U47rTAPXH+aLFRV5bwaR5qoQIKBvtt8C4VdyaJsNXDc=;
        b=NIQyenUomFxaP0tw7ZOF6+8NUMc2Q/X0j0vtiNLUcFYjS2018PDSP4dJZ5tCm19M1B
         BluB18J/GaUbv3unKZFClCwdp+Lduc58Gos+bOI5B3LKC2xlIHbRnVQLe0GJheuaN1Gp
         TrPi/HT0bF2172ucbvvH9BOHz33UHB6XYsSJ6DclRKKiiNr46J18kjokaxMqi6vUd4gi
         nIyrDA3h5APwZwsoBAEZmAYP1EVTBApoeOJ9uVaCb1ApoIwsg8pUp7XxblrtO54XM4MI
         jCGgXyE+2f6x4tbSgYihdCD12vl6jQh/grYt7gxkmW6R88eqFzr5YNzR0u0kkQEJ2WuV
         YOGw==
X-Gm-Message-State: AOAM532lcc5NQ6q7fU28g5VB41jZc2iwZ/O2QlXq99uddbcQivm+YKuV
        jqjO8TpNP4NTt//MiTRGfk/z
X-Google-Smtp-Source: ABdhPJwsSrpQmBjHLE7h+SrvCAYWvXBcLL6X7fPC9nsRP+9XodzueLnH/Y5A0hSfBSPJLAhheZn6xg==
X-Received: by 2002:a92:c681:: with SMTP id o1mr3342064ilg.23.1640367520820;
        Fri, 24 Dec 2021 09:38:40 -0800 (PST)
Received: from ?IPv6:2601:281:8300:4e0:2ba9:697d:eeec:13b? ([2601:281:8300:4e0:2ba9:697d:eeec:13b])
        by smtp.gmail.com with ESMTPSA id j5sm4687504ilo.77.2021.12.24.09.38.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Dec 2021 09:38:40 -0800 (PST)
Message-ID: <e7247265d5309165140d7a9a3af646129a789d58.camel@egauge.net>
Subject: Re: [PATCH] wilc1000: Allow setting power_save before driver is
 initialized
From:   David Mosberger-Tang <davidm@egauge.net>
To:     Ajay.Kathat@microchip.com
Cc:     Claudiu.Beznea@microchip.com, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Fri, 24 Dec 2021 10:38:37 -0700
In-Reply-To: <9272b86e-61ab-1c25-0efb-3cdd2c590db8@microchip.com>
References: <20211212011835.3719001-1-davidm@egauge.net>
         <6fc9f00aa0b0867029fb6406a55c1e72d4c13af6.camel@egauge.net>
         <5378e756-8173-4c63-1f0d-e5836b235a48@microchip.com>
         <31d5e7447e4574d0fcfc46019d7ca96a3db4ecb6.camel@egauge.net>
         <49a5456d-6a63-652e-d356-9678f6a9b266@microchip.com>
         <523698d845e0b235e4cbb2a0f3cfaa0f5ed98ec0.camel@egauge.net>
         <122f79b7-7936-325c-b2d9-e15db6642d0f@microchip.com>
         <be3c95c8310504222e88c602a937b7f05cc01286.camel@egauge.net>
         <9272b86e-61ab-1c25-0efb-3cdd2c590db8@microchip.com>
Organization: eGauge Systems LLC
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ajay,

On Fri, 2021-12-24 at 16:20 +0000, Ajay.Kathat@microchip.com wrote:
> On 23/12/21 22:38, David Mosberger-Tang wrote:
> > First, on a freshly booted system and with wilc1000-spi autoloaded by
> > the kernel, try this sequence (copy & paste the commands):
> > 
> >     /usr/sbin/wpa_supplicant -Bs -iwlan0 -c/etc/wpa_supplicant.conf
> >     sleep 10
> >     iw dev wlan0 set power_save on
> > 
> > The above yields a power consumption of 1.4W reliably.  The "sleep 10"
> > doesn't matter here; the behavior is the same with or without it.  I
> > tried waiting up to 120 seconds with no difference.
> 
> I have tested by making the WILC as build-in module to insert driver 
> automatically at boot-up. I hope it should be fine. Because I have 
> already tested as loadable module earlier.
> 
> Below are the number observed
> ------------------------------ --------------------------
> - before starting wpa_supplicant             : ~16.3 mA
> - wpa_supplicant started                         : ~40 mA
> - PSM on                                                  :  ~6 mA
> 
> 
> The 'sleep 10' would have no impact in my setup because I have measured 
> the current consumption for wilc1000 chip.
> 
> I have shared the screenshot at https://postimg.cc/67S41dkb

Huh, that's curious.  I definitely cannot reproduce this.  To match
your setup as closely as possibly, I also built wilc1000-spi into the
kernel, but that makes no difference (as expected).

What kernel version are you on?  I switched to wireless-drivers-next as
of today (latest commit d430dffbe9dd30759f3c64b65bf85b0245c8d8ab).

With this kernel, the numbers are about 100mW lower than reported
before, but the relative behavior is the same: about 300mW higher
power-consumption when PSM is not taking effect properly.

To recap, back with wilc1000-spi being a module again, after freshly
booting the system and issuing this commands:

   /usr/sbin/wpa_supplicant -Bs -iwlan0 -c/etc/wpa_supplicant.conf
   /usr/sbin/iw dev wlan0 set power_save on

I see a power-consumption of about 1.25W.  PSM on/off makes no
difference in this state.  Then, if I issue the commands:

rmmod wilc1000-spi
modprobe wilc1000-spi
sleep 10
iw dev wlan0 set power_save on

power-consumption drops to about 0.9W.

Here is a screenshot that shows the annotated power-measurements:

   https://postimg.cc/3dbKSGht

Apart from kernel version, the only things that I can think of that'd
be different is that we don't have the ENABLE pin wired to a GPIO.
 Instead, the chip is always enabled.  I doubt this would explain the
difference (~RESET is wired to a GPIO).


  --david


