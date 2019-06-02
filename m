Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3D95321A0
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 04:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbfFBCTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 22:19:00 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:46429 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbfFBCTA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Jun 2019 22:19:00 -0400
Received: by mail-pg1-f195.google.com with SMTP id v9so6193616pgr.13;
        Sat, 01 Jun 2019 19:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Y7mxNk1YSUnRwu3mnvdbX5KJD0RtMIzNYAtPrJiIhws=;
        b=FN/OFcJ52ZLur4QZDmBRZahvKV+4iWRSVNB/zDNkDIjYggFWGZWWCB+eErAzEpb6oo
         UHRECB02ZP0rm8jOaC2vAwztar+4bViEkZiCGtSnB9DBwiLLYXMracWqx3InmWbE3VP+
         nhFlfHWq6m+Q/hVmiUgbBkthuUz34LlIyiHPRXS3jA0Sh1JsAWesHxS2nveoVIDc9a7i
         ZKncnNzi6e1N1MOtISxrlMvAAr2O1EgZpCnzG7UbdPRowoI9t62iPD/ehxI6n2/Op0q7
         agzBU70aeZq6+elEUAV7U7BrwDCCCFMFP82MaUg8MwQYDJjXbe8AmpvlbjPIKUR9hC9C
         VNZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Y7mxNk1YSUnRwu3mnvdbX5KJD0RtMIzNYAtPrJiIhws=;
        b=h2aImtzqlEucrqikpRDW4k0gKnfqjPtvwXaX13DanhNcYfP6AgZmYq2e2OM4T88Khw
         PRtRX5d+u8r5uXzZ/P0ZT/rn9OVpGenDXGvezNVUA+tdbRoEyq8xle7z6xmmX7mUwyry
         O2GgGiyLgAGgRwKYXFqCvuJlRmJsSPJFeQdGbxFPTKz6ETvjEWSsB7sN6jAIS895M3Rk
         KjhiZek34kVpqpzknaz5VWY5FEL7I4bn0+bOdtLN07mfz05Sc227S22jwa6khFWzhKef
         R1r6Pva2dYoCzCIb9xpIppW8vIA96OLQusNxTRU/yTi4bWcXfGXa6J3FpZ6fUBe1OtE7
         gwJw==
X-Gm-Message-State: APjAAAXvRDGdXEf4FBPXv/OZdz8FPjWgcHBPSRXRmihZJ4LKa1lBh5aD
        3+ICqdtZaUHXN8VBcuLEx2Y=
X-Google-Smtp-Source: APXvYqzxi2Uk4oB9g/bbf/8wNSEWOMZJIat4XynuLIeIKdaDEK6bprKNL7pgHKA9T9GJ2n2dxJCUIg==
X-Received: by 2002:aa7:8f16:: with SMTP id x22mr22440325pfr.202.1559441939570;
        Sat, 01 Jun 2019 19:18:59 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id d35sm8236978pgb.55.2019.06.01.19.18.58
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 01 Jun 2019 19:18:58 -0700 (PDT)
Date:   Sat, 1 Jun 2019 19:18:56 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/5] PTP support for the SJA1105 DSA driver
Message-ID: <20190602021856.viayjqiifg4yok6c@localhost>
References: <20190531140841.j4f72rlojmaayqr5@localhost>
 <CA+h21hroywaij3gyO0u6v+GFVO2Fv_dP_a+L3oMGpQH8mQgJ5g@mail.gmail.com>
 <20190531151151.k3a2wdf5f334qmqh@localhost>
 <CA+h21hpHKbTc8toPZf0iprW1b4v6ErnRaSM=C6vk-GCiXM8NvA@mail.gmail.com>
 <20190531160909.jh43saqvichukv7p@localhost>
 <CA+h21hpVrVNJTFj4DHHV+zphs2MjyRO-XZsM3D-STra+BYYHtw@mail.gmail.com>
 <CA+h21houLC7TGJYQ28LxiUxyBE7ju2ZiRcUd41aGo_=uAhgVgQ@mail.gmail.com>
 <20190601050714.xylw5noxka7sa4p3@localhost>
 <CA+h21hr3+vUjS9_m=CtEbFeN9Bgxkg8b-4zuXSMnZXGtfUEOsQ@mail.gmail.com>
 <CA+h21hpoRFCKJZWxS3QwZO6fUHOd=aZDm2A9iqZ-7V9PxCPWVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hpoRFCKJZWxS3QwZO6fUHOd=aZDm2A9iqZ-7V9PxCPWVg@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 01, 2019 at 03:06:59PM +0300, Vladimir Oltean wrote:
> PTP frames will reconstruct the full timestamp without waiting for any
> meta (they are the meta), while other MAC-trapped frames (STP etc)
> will just carry a meaningless skb->cb when passed up the stack.
> In retrospect, it would have been amazing if the switch gave me the
> meta frames *before* the actual link-local frames that needed the
> timestamp.

I didn't follow everything you wrote, but it sounds like you are on
the right track!

Thanks,
Richard
