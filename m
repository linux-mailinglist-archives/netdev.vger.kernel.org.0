Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94234310FE
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 17:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbfEaPLz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 11:11:55 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35265 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726576AbfEaPLy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 11:11:54 -0400
Received: by mail-pg1-f195.google.com with SMTP id t1so691492pgc.2;
        Fri, 31 May 2019 08:11:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=XQFgCSgBXdly7Jwoud0ulr5doGwTC08ZXMU22H/Fyy4=;
        b=tkGBxzHrA6ZDvVbAj49mnNeXHv/h18Avk7DFUK35QgHe/I3CRs1s74PzpJdVsgP34E
         mB2DekUdQ+50mRYh70bNT2Y8pr/rhpRsPgZYlW5b9YzZBBFrxhIj/dL4r3kywJNH6DGe
         O82QDJs38Oge0NJnXnvgFE7R0KrQDh8JGlvA7NmHkhZcwNl4t/R1DOPVUSf5m7RTm5fV
         4bhTwxBSBnHwRlfBqemQOPXBErYLLSS+DpJamzySjlWZPgXGS4bIx1TeqG5u3VunASZw
         uJX7f2Rc7lLVWm8dSAuWnsyNKXGFft9i+1wxx/goKQoUM0KBFHen/8qyJsEY+rocVgVc
         e5Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=XQFgCSgBXdly7Jwoud0ulr5doGwTC08ZXMU22H/Fyy4=;
        b=dTSaNxmKGzGaxr6er/oMs9yEMvvpww3qeAfQJnnlVSwGulvBInfh8Cg04D/TqpEv8V
         P5mWcnD37VTT4gLVekWk4s4hMS5MZuNuUz4lycU0SgV9ULYvjkPS443DL+lOJ96hIF3z
         MllNybjtrvXEtsKBwePwu6IqeIEtEN942KTRunBWs/hnbQb8IHjZ73HjzLxhGfT8XIY5
         gAAQt18JHMZzFhU/GuOaJYdz0UJQiDnzgZ1X11e6mWOCc+IfINNi8Z2pdddwShPc3sEQ
         3RX3d8fhA3blS+TB0qL+bDhGloSX5XDsVlOdjPa1RRxAeFRUpnqsVsmtBvfR8MpRUZ+j
         fdTw==
X-Gm-Message-State: APjAAAWMkTogwF65FxTNggmQJ7tBSRiqEZT3jBmum7mGZpCu1z5qkIe9
        nUvZO/UGQsYKY6Z8Xbhq8eI=
X-Google-Smtp-Source: APXvYqz/1OrAOHSHucIJeec4D1yn1g1/8uOEE2bgzF4H8FNz0Y8vZiRpYnTxT5CU9CiWPgTBCZnqXA==
X-Received: by 2002:a62:5e42:: with SMTP id s63mr10359349pfb.78.1559315514384;
        Fri, 31 May 2019 08:11:54 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id d2sm5342870pfh.115.2019.05.31.08.11.52
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 31 May 2019 08:11:53 -0700 (PDT)
Date:   Fri, 31 May 2019 08:11:51 -0700
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
Message-ID: <20190531151151.k3a2wdf5f334qmqh@localhost>
References: <20190530034555.wv35efen3igwwzjq@localhost>
 <CA+h21hpjsC=ie5G7Gx3EcPpazyxze6X_k+8eC+vw7JBvEO2zNg@mail.gmail.com>
 <20190530143037.iky5kk3h4ssmec3f@localhost>
 <CA+h21hpp68AEEykxr8bJB=uJ+b0tg881Z7Ao_OfbTAXNxS8WgQ@mail.gmail.com>
 <20190530150557.iur7fruhyf5bs3qw@localhost>
 <CA+h21hrBwR4Sow7q0_rS1u2md1M4bSAJt8FO5+VLFiu9UGnvjA@mail.gmail.com>
 <20190531043417.6phscbpmo6krvxam@localhost>
 <CA+h21hp9DfW3wFy4YbHMU31rBHyrnUTdF4kKwX36h9vHOW2COw@mail.gmail.com>
 <20190531140841.j4f72rlojmaayqr5@localhost>
 <CA+h21hroywaij3gyO0u6v+GFVO2Fv_dP_a+L3oMGpQH8mQgJ5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hroywaij3gyO0u6v+GFVO2Fv_dP_a+L3oMGpQH8mQgJ5g@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 05:27:15PM +0300, Vladimir Oltean wrote:
> On Fri, 31 May 2019 at 17:08, Richard Cochran <richardcochran@gmail.com> wrote:
> > This can be done simply using a data structure in the driver with an
> > appropriate locking mechanism.  Then you don't have to worry which
> > core the driver code runs on.
> >
> 
> Actually you do. DSA is special because it is not the first net device
> in the RX path that processes the frames. Something needs to be done
> on the master port.

Before you said,

	the switch in its great wisdom mangles bytes 01-1B-19-xx-xx-00
	of the DMAC to place the switch id and source port there (a
	rudimentary tagging mechanism).

So why not simply save each frame in a per-switch/port data structure?

Now I'm starting to understand your series.  I think it can be done in
simpler way...

sja1105_rcv_meta_state_machine - can and should be at the driver level
and not at the port level.

sja1105_port_rxtstamp_work - isn't needed at all.

How about this?

1. When the driver receives a deferred PTP frame, save it into a
   per-switch,port slot at the driver (not port) level.

2. When the driver receives a META frame, match it to the
   per-switch,port slot.  If there is a PTP frame in that slot, then
   deliver it with the time stamp from the META frame.

Thanks,
Richard
