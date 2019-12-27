Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2990E12B58E
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 16:19:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbfL0PTU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 10:19:20 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:55345 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbfL0PTU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 10:19:20 -0500
Received: by mail-pj1-f65.google.com with SMTP id d5so4838940pjz.5
        for <netdev@vger.kernel.org>; Fri, 27 Dec 2019 07:19:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Znol3kg0JlR03ZUz2YyX4hHXtDk0RGpI07KUCsdmFpc=;
        b=m3Lqpx0bg0ieKy2WxQ70lgZk4BJ5WIQdARc3J++5OqJ5jdNKba8Ll7p3K5sEdzaKrA
         HtiWUiaVUFrmJVir4tvRW8nmXJtjJ8YPuxZaktEPjM6VKt7vpKrf1Ui/heg0EuF/MF3w
         DMpQzOta+ajXZtqFIKS1vFgsNJhrmvyGS4FrtMCU3ShiTod80lJooHwY8Z+kc8uvhmIv
         pehWIA/zRY7MZwwCdrmoSXTJ2VkB5HDqxpda6Trxj+aqqOfbB+1YGNtNZEEVKbQ8m9BE
         y2VxSO+7BlgfkzcrTOrSlZWTj0VW3a+iwCNrNkSe2ucH4lqiN8AzDZUGxabBHpPSwDwA
         khXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Znol3kg0JlR03ZUz2YyX4hHXtDk0RGpI07KUCsdmFpc=;
        b=mzfbmgTUJUEUzo/4/GgAHWmWN9S3MXhNJkQujKlPfENajtVXpuoexwELgI06RJ4L5s
         9yWqhxeeo1Dqj7DaMcnrKiwgM7gcUQdUR1j4QDThBLsJIwlndjg+H8csz26kBVxdPzi6
         xweLSMmACWCChceyaqP60dyhoaWvkgiGiiwsBb9bk16quKXc4iHuARkj4sWDiT3LGPqs
         pHOtlcy4/ytCmpOr/vqofX4vcKyKPH38ZOGg+FEtZxG6S6TU3/b4Er/jZsfF4oZ6Zg7S
         LeSjdrXhXj/L1zGVwGCTXDbqFJl+A5l05BuFLMpSuaVPcsQ+QbH9q3bYAQr45iEeVq03
         X5Dg==
X-Gm-Message-State: APjAAAWNS73Tz3Q/lP24lQTxhBzJi8YPDiNMJ/wySsGSIw1xlF9CWrWv
        aOYjUC+Ld9UqvUzlUdbqZ5k=
X-Google-Smtp-Source: APXvYqz32XXHaJSpU84D7z0B6slGOApj0RKNGc3nmnUBQ39TkmmEw0XopCINPyiZlDLyBdqWS146dw==
X-Received: by 2002:a17:902:8646:: with SMTP id y6mr51869325plt.191.1577459959561;
        Fri, 27 Dec 2019 07:19:19 -0800 (PST)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id a18sm6015463pjq.30.2019.12.27.07.19.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Dec 2019 07:19:18 -0800 (PST)
Date:   Fri, 27 Dec 2019 07:19:16 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "Keller, Jacob E" <jacob.e.keller@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net] net: dsa: sja1105: Fix double delivery of TX
 timestamps to socket error queue
Message-ID: <20191227151916.GC1435@localhost>
References: <20191216223344.2261-1-olteanv@gmail.com>
 <02874ECE860811409154E81DA85FBB58B26DEDC3@fmsmsx101.amr.corp.intel.com>
 <CA+h21hob3FmbQYyXMeLTtbHF1SeFO=LZVGyQt4jniS9-VXEO-w@mail.gmail.com>
 <02874ECE860811409154E81DA85FBB58B26DF1C9@fmsmsx101.amr.corp.intel.com>
 <20191224190531.GA426@localhost>
 <CA+h21hrBLedLHCfP3oY2U96BJXqMQO=Uof3tsjji_Fp-b0smHQ@mail.gmail.com>
 <20191227015232.GA6436@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191227015232.GA6436@localhost>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 26, 2019 at 05:52:32PM -0800, Richard Cochran wrote:
> On Thu, Dec 26, 2019 at 08:24:19PM +0200, Vladimir Oltean wrote:
> > How will these drivers not transmit a second hw TX timestamp to the
> > stack, if they don't check whether TX timestamping is enabled for
> > their netdev?
> 
> Ah, so they are checking SKBTX_HW_TSTAMP on the socket without
> checking for HWTSTAMP first?

Thinking a bit more about this, MAC drivers should not attempt any
time stamping unless that functionality has been enabled at the device
level using HWTSTAMP.  This is the user space API.

So, if you want to fix those drivers, you can submit patches with the
above justification.  That is a stronger argument than saying it
breaks DSA drivers!

Thanks,
Richard
