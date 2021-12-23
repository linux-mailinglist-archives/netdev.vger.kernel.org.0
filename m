Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0044847E6A3
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 18:08:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349399AbhLWRIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 12:08:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349389AbhLWRIP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 12:08:15 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65B8CC061757
        for <netdev@vger.kernel.org>; Thu, 23 Dec 2021 09:08:15 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id q5so7925377ioj.7
        for <netdev@vger.kernel.org>; Thu, 23 Dec 2021 09:08:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=egauge.net; s=google;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :organization:user-agent:mime-version:content-transfer-encoding;
        bh=PzfSZJy8ajTV/2XbEqy1MLSEgJlZI8gZuq+wRbOaiRg=;
        b=PQRdFby9pRqTbr0Zrbw9wcgKwLdE/9oMpZAOIieE5xMsn0ap5seUNCjEY46osZOnaE
         EZqjOLOnwv+8ygjSqlWY4eFNa2/EUIPfegnXCfX7oee1+jUvE3a2c0l4Yhyym7Ys/e8I
         pHQHLLmPcCevTHihkodXMVpy0EcttCSATcqlbDsdca832vN6vxJaewCv8V/CBnayIW3j
         JIv0ASgiyIN7frOyhCSCrAFAG4VsuCYv+LwA8ucurPbVFpffwSCtYHx8dP3Z5XpIZflz
         FuWaHDM0W02tzaADDvfGNJK03XcspLf/WNHAAV/8LbjAtqL7bk3y/WjOjikEbLKU6cnm
         3+PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=PzfSZJy8ajTV/2XbEqy1MLSEgJlZI8gZuq+wRbOaiRg=;
        b=70qxy2puy/bUFDtAxUHOpYKECa5645++oF24hNsiv2AA4yMNs+e8iobGvtKYll7QNg
         tvjuEB0JtnXkk0VtOj6glmos43O+r7rhKqytpTrXFDq45gZGBnZWhNGjHJrLmP2DHfjq
         oJDVXrnlWzNbbNatoTLT62afPa9eLpcJJriZfTvrFvhqFlVjSDAab1AUsiswj6mz14XB
         TUM7RvZ5dJnoqorsSqg8+kRxjw3dXLgDcLk3vwgWIgfcxxS+Bp1ABxWD2sErbgT0taMG
         LfUpzxE5hRYb3eESPSjs3Jwe04QnQH2SS0RADMZpLqKDP6iWvtDliLJZot8//8fC3kba
         Mv2A==
X-Gm-Message-State: AOAM5336nxgY5r04rWFrcZXr9lBsbD4ZKJEEd+/tH/kMk9MDvRHs6FhO
        XMjB2LXr2FKTisbMYBrY1dxg
X-Google-Smtp-Source: ABdhPJxGpst4+/jbJwU1+mvGQv2UaVuoO9ZbYFgY8six5q23KZzfatw/zpE0uwLkXdYsuJHqKRp5AQ==
X-Received: by 2002:a05:6638:4089:: with SMTP id m9mr1719379jam.189.1640279294737;
        Thu, 23 Dec 2021 09:08:14 -0800 (PST)
Received: from ?IPv6:2601:281:8300:4e0:2ba9:697d:eeec:13b? ([2601:281:8300:4e0:2ba9:697d:eeec:13b])
        by smtp.gmail.com with ESMTPSA id d16sm2807786ila.51.2021.12.23.09.08.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Dec 2021 09:08:14 -0800 (PST)
Message-ID: <be3c95c8310504222e88c602a937b7f05cc01286.camel@egauge.net>
Subject: Re: [PATCH] wilc1000: Allow setting power_save before driver is
 initialized
From:   David Mosberger-Tang <davidm@egauge.net>
To:     Ajay.Kathat@microchip.com
Cc:     Claudiu.Beznea@microchip.com, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 23 Dec 2021 10:08:00 -0700
In-Reply-To: <122f79b7-7936-325c-b2d9-e15db6642d0f@microchip.com>
References: <20211212011835.3719001-1-davidm@egauge.net>
         <6fc9f00aa0b0867029fb6406a55c1e72d4c13af6.camel@egauge.net>
         <5378e756-8173-4c63-1f0d-e5836b235a48@microchip.com>
         <31d5e7447e4574d0fcfc46019d7ca96a3db4ecb6.camel@egauge.net>
         <49a5456d-6a63-652e-d356-9678f6a9b266@microchip.com>
         <523698d845e0b235e4cbb2a0f3cfaa0f5ed98ec0.camel@egauge.net>
         <122f79b7-7936-325c-b2d9-e15db6642d0f@microchip.com>
Organization: eGauge Systems LLC
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-12-23 at 14:02 +0000, Ajay.Kathat@microchip.com wrote:
> 
> I verified with wpa_supplicant and it seems the power save mode is 
> working fine. Tested multiple times with wpa_supplicant running. I 
> didn't observe any issue in entering or exiting the power-save mode with 
> wpa_supplicant.
> 
> Try to verify without wpa_supplicant in your setup to observe if we are 
> seeing this same results in that case.

It doesn't help me if it works without wpa_supplicant.  I need a
reliable way to have power-savings mode in effect when using
wpa_supplicant.

> With wpa_supplicant, the current consumption is less when PS mode is 
> enabled but it would be more compared to without wpa_supplicant.

That's not what I'm talking about though.  The problem is that it seems
to be rather erratic whether issuing the iw power_save command makes a
difference in power-consumption.

I fixed my setup so I can directly measure power consumed rather than
just current (power factor matters).  Again, this is for the entire
device (not just WILC1000).

What I find that when power-saving mode is working as expected, the
device uses an average of 1.1W.  When power-saving mode is not working,
power consumption is about 1.4W, or about 300mW higher.

I tried again *without* the patch applied and, as expected, the patch
doesn't really affect this behavior.

After playing with this for a while, I think I found two sequences that
reliably reproduce the difference.

First, on a freshly booted system and with wilc1000-spi autoloaded by
the kernel, try this sequence (copy & paste the commands):

   /usr/sbin/wpa_supplicant -Bs -iwlan0 -c/etc/wpa_supplicant.conf
   sleep 10
   iw dev wlan0 set power_save on

The above yields a power consumption of 1.4W reliably.  The "sleep 10"
doesn't matter here; the behavior is the same with or without it.  I
tried waiting up to 120 seconds with no difference.

Second, on a freshly booted system and with wilc1000-spi autoloaded by
the kernel, try this sequence (copy & paste the commands):

   /usr/sbin/wpa_supplicant -Bs -iwlan0 -c/etc/wpa_supplicant.conf
   sleep 10
   rmmod wilc1000-spi
   modprobe wilc1000-spi
   sleep 10
   iw dev wlan0 set power_save on

The above yields a power consumption of 1.1W reliably.

Can you reproduce this, or, if not, share the power consumption you see
for the two cases?

  --david


