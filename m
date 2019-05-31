Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4250311F9
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 18:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726835AbfEaQJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 12:09:14 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:37791 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726774AbfEaQJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 12:09:13 -0400
Received: by mail-pf1-f193.google.com with SMTP id a23so6492629pff.4;
        Fri, 31 May 2019 09:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=z/RgCzJSEHMAir5ujFpg5rPcb9HWXDTiA2qf/D1dWKs=;
        b=AgBCH0mF8vGGY3a4ElXuzBF5oJFQxIVCYpQKgewAzxF/VKnOJd4nHqAD6+WhZLHuUP
         zFdIcjKkMai+c34XKv3eceJcR2fYf0m4wzLJTibA8LWyRkuXuovkSQYMHOB/Pot5HRKk
         SPF+wqNgs+NyQsBon2j+Kw3/4WRp+NYQo3SEdoKanzQiUN0PiTQN2teFD0muUiZZQHPw
         24pTEkxYBRgGZMxgzYCJA7/qmLtADPGQXcD2jSGhp/YA5NPULXWzh12t8yDd1a/PY92A
         XmhluJYx6Wkt66KwzIAfph7d6p5AC2iU0gWtu3F50V+L30AAOyv6arEhaMam2e2BT5tM
         IU0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=z/RgCzJSEHMAir5ujFpg5rPcb9HWXDTiA2qf/D1dWKs=;
        b=V702skxRVusinHZN+L2Dz2NmJCNmYG/sycc6kS8oo0l9qUF1rdQMo0HMyjcOaKcYjB
         CmbC0PeI6J0+L6lQl9kurGBPFvr61k3Xbc4e9QPQTXXUl4qtX93yXMCJ5F4+NJ9JMRSO
         M701HAHfpOzrU2fH4DjkqY+8YFRraE3zV23FvNcHFwCtv12d59EdT+uWm8qzar469U34
         3ZXJgriwvueevCeVSx9WBjJD52/WG76wzSIDwriiORi079cHnosOn6HOOKBmi9cRJN36
         DxVqRKiZmKedOeqKKgzT0Jce1QCV726VmfPC9MrQNjVue9gVaFqXD0aSX0h887KBOeHm
         VGtA==
X-Gm-Message-State: APjAAAXmtcw3K6n8iVsL9STzdlyM2Ht88r2BZyjmAPUfAApGuOchtt/Y
        ptNPepK8I3RYzemAHSBPg7g=
X-Google-Smtp-Source: APXvYqw7B8ATADxnQAQTD6Z6CyqYTv+plBt1DoWcOXcq8ws+P7duyIFver5dQNrUF8Y9qFK5nymAlg==
X-Received: by 2002:a63:205b:: with SMTP id r27mr10323216pgm.330.1559318953074;
        Fri, 31 May 2019 09:09:13 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id x18sm7423076pfo.8.2019.05.31.09.09.11
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 31 May 2019 09:09:12 -0700 (PDT)
Date:   Fri, 31 May 2019 09:09:09 -0700
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
Message-ID: <20190531160909.jh43saqvichukv7p@localhost>
References: <20190530143037.iky5kk3h4ssmec3f@localhost>
 <CA+h21hpp68AEEykxr8bJB=uJ+b0tg881Z7Ao_OfbTAXNxS8WgQ@mail.gmail.com>
 <20190530150557.iur7fruhyf5bs3qw@localhost>
 <CA+h21hrBwR4Sow7q0_rS1u2md1M4bSAJt8FO5+VLFiu9UGnvjA@mail.gmail.com>
 <20190531043417.6phscbpmo6krvxam@localhost>
 <CA+h21hp9DfW3wFy4YbHMU31rBHyrnUTdF4kKwX36h9vHOW2COw@mail.gmail.com>
 <20190531140841.j4f72rlojmaayqr5@localhost>
 <CA+h21hroywaij3gyO0u6v+GFVO2Fv_dP_a+L3oMGpQH8mQgJ5g@mail.gmail.com>
 <20190531151151.k3a2wdf5f334qmqh@localhost>
 <CA+h21hpHKbTc8toPZf0iprW1b4v6ErnRaSM=C6vk-GCiXM8NvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hpHKbTc8toPZf0iprW1b4v6ErnRaSM=C6vk-GCiXM8NvA@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 06:23:34PM +0300, Vladimir Oltean wrote:
> You mean to queue it and subvert DSA's own RX timestamping callback?

No, use the callback.

> Why would I do that? Just so as not to introduce my .can_timestamp
> callback?

Right, the .can_timestamp is unneeded, AFAICT.
 
> > Now I'm starting to understand your series.  I think it can be done in
> > simpler way...
> >
> > sja1105_rcv_meta_state_machine - can and should be at the driver level
> > and not at the port level.
> >
> 
> Can: yes. Should: why?

To keep it simple and robust.
 
> One important aspect makes this need be a little bit more complicated:
> reconstructing these RX timestamps.
> You see, there is a mutex on the SPI bus, so in practice I do need the
> sja1105_port_rxtstamp_work for exactly this purpose - to read the
> timestamping clock over SPI.

Sure.  But you schedule the work after a META frame.  And no busy
waiting is needed.
 
Thanks,
Richard
