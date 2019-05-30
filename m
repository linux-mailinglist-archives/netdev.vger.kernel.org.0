Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9591E2EEF0
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 05:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732996AbfE3DvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 23:51:16 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44268 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729901AbfE3DvQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 23:51:16 -0400
Received: by mail-pf1-f196.google.com with SMTP id g9so3017340pfo.11;
        Wed, 29 May 2019 20:51:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3ZN60qwibmbZGc7THAFZZ2/hms+fJLyOqOJKZuQflBE=;
        b=ZwE5b0ZFm4ynttpd5kMK35jDuC/dWIl6rZ0AxFpXFbRUHfeUb3Ml4ENGatP4aD5RYY
         23QXnN+HULJJo7Z0UhYGmuaxLPnpaRVa1K6vrK7hBSYlYRoPf3+MRGMrcHZctNVs2l7s
         MWnplg0pNOxJyuwEHim48WgIsJ8M34bNmyeWk77XoRJMgZ7hYTE29jVGu7e52b6cyvuY
         85NFO7nLtWYbAWcqCcdsXVQDcE42kdoeBG6an2HXAE2yfDQB/mDnsJH19IzaFxI4Dztz
         evh3apIabkns36LhHDLSdQuHyDDRE5vAqSe6IXSbg7XWRvLelGBRmVcEwgDSIOAe+gLK
         fawQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=3ZN60qwibmbZGc7THAFZZ2/hms+fJLyOqOJKZuQflBE=;
        b=JyqgRdABbw4vJfzfKBxLEHXev6urFxjQO0rQvzqJWOqgBOGtgkZBwxx66gTkrxc6jS
         bleT4+M2td3xXGMK8jFsuH+oCPCGetlpbOHSqpD85mEdU6yJmAcGcBef6U2RlhVhgMLI
         FF3lb38wF+R6bKLhwB/mN8MzQJKqasfdE73QZaQwB1SbKHGK6Syxf1K+aUnWISIQ4NfG
         4Co3YaZMejtbWAMHdddDQEZ/fPV1aPSD0R3dfOAf7TJwgJPz1uJWrZ+MVBW3CE/RkE09
         2ifBUXnUylOoIAUfSn35X06ubZ/rWp4zRFFlca1D/Uo1i467EYJOn2S0Nvcc06hqlKJn
         LlRg==
X-Gm-Message-State: APjAAAVjoaFMtSpl6zItSe+LQxIUiSDSxDAlKKUgRr9jF4P6jTjAZt46
        EdohhNYGa9l+8PkMURe99rw=
X-Google-Smtp-Source: APXvYqytd5fkdlkjvOUabmuc2c4XXV8pyR+vCkOalg3TJkjUC1ShJDnM9GkbvULv9oAxmWggsceYnw==
X-Received: by 2002:a63:d150:: with SMTP id c16mr1778481pgj.439.1559188275085;
        Wed, 29 May 2019 20:51:15 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id t124sm989859pfb.80.2019.05.29.20.51.13
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 29 May 2019 20:51:14 -0700 (PDT)
Date:   Wed, 29 May 2019 20:51:12 -0700
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
Subject: Re: [PATCH net-next 3/5] net: dsa: mv88e6xxx: Let taggers specify a
 can_timestamp function
Message-ID: <20190530035112.qbn3nnoxrgum7anz@localhost>
References: <20190528235627.1315-1-olteanv@gmail.com>
 <20190528235627.1315-4-olteanv@gmail.com>
 <20190529044912.cyg44rqvdo73oeiu@localhost>
 <CA+h21hoNrhcpAONTvJra5Ekk+yJ6xP0VAaPSygaLOw31qsGPTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hoNrhcpAONTvJra5Ekk+yJ6xP0VAaPSygaLOw31qsGPTg@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 29, 2019 at 11:33:31PM +0300, Vladimir Oltean wrote:
> I would like to avoid keeping meta frames in their own RX queue,
> because then I'm complicating (or rather put, making impossible) the
> association between a meta frame and the frame it holds a timestamp
> of.

We have an example of how a driver can match meta time stamp packets
with received packets.  See drivers/net/phy/dp83640.c to see how it
can be done completely within the driver.

Thanks,
Richard
