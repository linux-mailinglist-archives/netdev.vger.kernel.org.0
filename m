Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 837A32FEE1
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 17:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727521AbfE3PGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 11:06:01 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:46890 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725440AbfE3PGA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 11:06:00 -0400
Received: by mail-pf1-f196.google.com with SMTP id y11so4119376pfm.13;
        Thu, 30 May 2019 08:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=V8q1uSPbWLjulZczFMArxlG+Rc8bRU4dU5fPX9uUB/Y=;
        b=T5l0F168cAQhA00t3HCVh/oLVOEqrFFeDNjkLFV79a7R2SYZiBYyJtT3G7gZi72hr+
         uVrLkPwyrtYC9ZPESLwraVIfnhLAp5UertJjpiGrTzYZxnDqVYmShBhFwJDWJwGXtskE
         IM5B3m9lMGWIXb+B64rHMGv1Eb/zw7105HDQJJTsiTBnoTZw63mPipnSkZULbPManvFp
         WLxMnGNQGNJj8I786s3SczMjpR719F/MZ1WtW278ktmOPYSt8WRjeZmgcDgvCltFpzfc
         5Kwf5ZlVFqqyjrBw43a97SWxDlVPNdH/skY8xHmE3Puwyul0+fxdcFeTKNBaP90e9cYn
         kqkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=V8q1uSPbWLjulZczFMArxlG+Rc8bRU4dU5fPX9uUB/Y=;
        b=YReiGOEUwjzn+z7j6HT3ze+f+2WRJe2EXwtH32eD+PUMmULDk6yBO5N0GjyBKDpuym
         3y47hn7btpndtTTZCWnZZCwpY07/S6D2Nq22PI6IkP8Er9rPeCyngjLzt62slmVfZ3ZE
         hhfPajSRKbOHER9LKNAwqOiE/LGoxtMUVegCa4COEypyP4msYYLY12vNZrHQ2r7Bqr0h
         Pr9xmhIhpnCFZ7/LHQf54MuvjzYGynrYS9VjqqMQdsezgOXTf5uJhcmsmszMyVzoOEc6
         8Czp4tepu3vmcp1Q9HDPkQLatYE0fUHR41X2xBmCRymEvrbVnByufof/TWNI+z5t25FL
         0h2w==
X-Gm-Message-State: APjAAAUlWlembyPMXxFyyxg5aG9SSv8hvU1ShDK9EiQjgAaXdZ7EFy7v
        qOIiL61ZbWZGLHf6AoaO2Lw=
X-Google-Smtp-Source: APXvYqxJGsULWLIA7X9CQEJRFwoucyFeVDPVZvQBlTXibAyCIe0La5fViUkFQVWus5q6WGH5tq+G8A==
X-Received: by 2002:a17:90a:e393:: with SMTP id b19mr3922035pjz.119.1559228760241;
        Thu, 30 May 2019 08:06:00 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id x28sm3733624pfo.78.2019.05.30.08.05.58
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 30 May 2019 08:05:59 -0700 (PDT)
Date:   Thu, 30 May 2019 08:05:57 -0700
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
Message-ID: <20190530150557.iur7fruhyf5bs3qw@localhost>
References: <20190528235627.1315-1-olteanv@gmail.com>
 <20190529045207.fzvhuu6d6jf5p65t@localhost>
 <dbe0a38f-8b48-06dd-cc2c-676e92ba0e74@gmail.com>
 <20190530034555.wv35efen3igwwzjq@localhost>
 <CA+h21hpjsC=ie5G7Gx3EcPpazyxze6X_k+8eC+vw7JBvEO2zNg@mail.gmail.com>
 <20190530143037.iky5kk3h4ssmec3f@localhost>
 <CA+h21hpp68AEEykxr8bJB=uJ+b0tg881Z7Ao_OfbTAXNxS8WgQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hpp68AEEykxr8bJB=uJ+b0tg881Z7Ao_OfbTAXNxS8WgQ@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 30, 2019 at 05:57:30PM +0300, Vladimir Oltean wrote:
> On Thu, 30 May 2019 at 17:30, Richard Cochran <richardcochran@gmail.com> wrote:
> >
> > Not necessarily.  If two frames that arrive at nearly the same time
> > get their timestamps mixed up, that would be enough to break the time
> > values but without breaking your state machine.
> >
> 
> This doesn't exactly sound like the type of thing I can check for.

And that is why it cannot work.

> The RX and TX timestamps *are* monotonically increasing with time for
> all frames when I'm printing them in the {rx,tx}tstamp callbacks.

But are the frames received in the same order?  What happens your MAC
drops a frame?
 
> The driver returns free-running timestamps altered with a timecounter
> frequency set by adjfine and offset set by adjtime.

That should be correct.

Thanks,
Richard
