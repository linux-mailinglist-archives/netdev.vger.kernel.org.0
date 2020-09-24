Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E03BE27762F
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 18:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728645AbgIXQE4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 24 Sep 2020 12:04:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34399 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728496AbgIXQEz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 12:04:55 -0400
Received: from mail-pj1-f72.google.com ([209.85.216.72])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1kLTjp-0001ZY-3d
        for netdev@vger.kernel.org; Thu, 24 Sep 2020 16:04:53 +0000
Received: by mail-pj1-f72.google.com with SMTP id f9so5367540pjp.1
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 09:04:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=nX0zpP5nDZf1hQGaqFM3MqAFuvNA8lFVZJI9qMupKJw=;
        b=Pkvkmi0sqV2CHzDjVJA+QyqmF13ufoiVeyHmAQ6MJ/vF+LLy/oomuS2qisFHUP3I0H
         qV0PMqLlDfU5MtlfieA9DGZKoDQMiubmqVGRPT6BxCdK++HKpLE0r0P09pLwrh7nGGjy
         d7lnbbHU3KLRuXzJIejVwLcTzud5Jd3eN+pz3BLqkelPpEbqsAIyiZP7g46Z53XC56E8
         bmQKgdRFhe130I79vfC8EjXr0oqkSYRRtFAbuBKXTigS5u5NGH0Jc7INjnTw3xY9cpQu
         H33NQCz9H0qfOFotIpTvi5L8bNSspOKP/9kPe8DNz9IRgX8KGvDNeJw3rCiN5ghTbTYo
         eK/Q==
X-Gm-Message-State: AOAM5308+hXcMzqUjL9mWNMnyBsx/oYyQJphofTS1cPENjax4lbRE07G
        ZLVO98z+nDjuvDozOUafg+Ja4e5uI/xYYYmO67HGuIXFt5YFNsfaJOmFdOjLH7TzARlRFrZVrWm
        2RGuWSNnphg3E+Z7WoH1RDmL26Gx6ix2A1Q==
X-Received: by 2002:a63:5d66:: with SMTP id o38mr288814pgm.366.1600963486507;
        Thu, 24 Sep 2020 09:04:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx/Z6+blTP/nNHPLJX3sXwCCgS+0nZJs30Wu1jnBGl3cA5mTL3aXN2iwDQxwt8FGjPWygNqSQ==
X-Received: by 2002:a63:5d66:: with SMTP id o38mr288785pgm.366.1600963486116;
        Thu, 24 Sep 2020 09:04:46 -0700 (PDT)
Received: from [192.168.1.208] (220-133-187-190.HINET-IP.hinet.net. [220.133.187.190])
        by smtp.gmail.com with ESMTPSA id x4sm3268556pff.57.2020.09.24.09.04.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Sep 2020 09:04:37 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH v2] e1000e: Increase iteration on polling MDIC ready bit
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
In-Reply-To: <20200924155355.GC3821492@lunn.ch>
Date:   Fri, 25 Sep 2020 00:04:25 +0800
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <8A08B3A7-8368-48EC-A2DD-B5D5F3EA94C5@canonical.com>
References: <20200923074751.10527-1-kai.heng.feng@canonical.com>
 <20200924150958.18016-1-kai.heng.feng@canonical.com>
 <20200924155355.GC3821492@lunn.ch>
To:     Andrew Lunn <andrew@lunn.ch>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

> On Sep 24, 2020, at 23:53, Andrew Lunn <andrew@lunn.ch> wrote:
> 
> On Thu, Sep 24, 2020 at 11:09:58PM +0800, Kai-Heng Feng wrote:
>> We are seeing the following error after S3 resume:
>> [  704.746874] e1000e 0000:00:1f.6 eno1: Setting page 0x6020
>> [  704.844232] e1000e 0000:00:1f.6 eno1: MDI Write did not complete
>> [  704.902817] e1000e 0000:00:1f.6 eno1: Setting page 0x6020
>> [  704.903075] e1000e 0000:00:1f.6 eno1: reading PHY page 769 (or 0x6020 shifted) reg 0x17
>> [  704.903281] e1000e 0000:00:1f.6 eno1: Setting page 0x6020
>> [  704.903486] e1000e 0000:00:1f.6 eno1: writing PHY page 769 (or 0x6020 shifted) reg 0x17
>> [  704.943155] e1000e 0000:00:1f.6 eno1: MDI Error
>> ...
>> [  705.108161] e1000e 0000:00:1f.6 eno1: Hardware Error
>> 
>> As Andrew Lunn pointed out, MDIO has nothing to do with phy, and indeed
>> increase polling iteration can resolve the issue.
>> 
>> While at it, also move the delay to the end of loop, to potentially save
>> 50 us.
> 
> You are unlikely to save any time. 64 bits at 2.5MHz is 25.6uS. So it
> is very unlikely doing a read directly after setting is going is going
> to have E1000_MDIC_READY set. So this change likely causes an addition
> read on MDIC. Did you profile this at all, for the normal case?

You are right, it's actually may add an additional read.
Let me send a v3.

> 
> I also don't fully understand the fix. You are now looping up to 6400
> times, each with a delay of 50uS. So that is around 12800 times more
> than it actually needs to transfer the 64 bits! I've no idea how this
> hardware works, but my guess would be, something is wrong with the
> clock setup?

It's probably caused by Intel ME. This is not something new, you can find many polling codes in e1000e driver are for ME, especially after S3 resume.

Unless Intel is willing to open up ME, being patient and wait for a longer while is the best approach we got.

Kai-Heng

> 
>     Andrew

