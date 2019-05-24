Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7FA92992D
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 15:44:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403851AbfEXNoa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 09:44:30 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:39853 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391124AbfEXNoa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 09:44:30 -0400
Received: by mail-ed1-f66.google.com with SMTP id e24so14483792edq.6
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 06:44:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QZ2lKwb3aHTxlALTR9iITxCF8HqdmRq6I5puhbR75tQ=;
        b=Po1aAwry2QWMbnjQ7HsbYlFz+/4E2X/gvYp4ny+wEd8fOtqVcB2jS/693owoHGpY81
         Y9DccriNJm5FqGxelp5zw2sXu58xOCS8n770dgkF7ydJCWKKQxDzOdVLdqpefBzCE66O
         39YuQ5+TnJI4lUCnCSw9kPLm7OtB0lE1iNKXCFgwW9Fr9YtvSYRvN/dOsUOHqqsV0aEG
         sFZ/6f6UWnedGkQlfQZz5teFzcq3M89evKN6+PF6nW/NOrdugUZkRm8CJYO/ZxXzI8yS
         RQpdMBqyPUZ5UQS2cFh7fBRp5PjJP7mxvj9lGtqtPfLYpSN+ssTzrNBzs/RGEPcK++Iy
         PBBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QZ2lKwb3aHTxlALTR9iITxCF8HqdmRq6I5puhbR75tQ=;
        b=iUyUhB9RYDSMRWCz2W4Ypri5yh2WjZbh0C2mACRNdY21daUfqM6PtIFInXjItZce9m
         RCfhecF5Mf889a462E2BrcFaMKEbPF7mcXCcQwEYApw5gEkksNbauOBJDChwC+eN8Ssh
         zw54QYszVF+xTwncaMAA48Zr4m3NHyoh0zvawhPNU+1yD3zjZKsp4rQgdqPNdDPqwiIL
         gTTWQftos0mdr67qwaldjIfl6x2VTknYshlOC1Zl1bHDHMFgN7NmUyKd/uOSX31ObS0N
         1NJ0OgwjV02JQW1OWPHTdPoG2JR4jlsv1578J/FV9cKPZc6BqpWb1EHwvyV5EUD7lPmK
         E8mA==
X-Gm-Message-State: APjAAAWaqK7a2u44hBFwL7q+c59TguYv5+kHWt7J1bhNSmh3siCkT+C2
        dWKwGv00iWgJ96qD11dHjh1HguWg+g3V8Wa8Xkc=
X-Google-Smtp-Source: APXvYqwstCwGHet2+IBFZw08tlR83OZTExFcd2B8KWf06NvQ4ihKF0zP1XfM0lraFRzVsVz8SRyaOxhL56tDXH8JqzI=
X-Received: by 2002:a17:906:1ec2:: with SMTP id m2mr79687824ejj.47.1558705468096;
 Fri, 24 May 2019 06:44:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190523011958.14944-1-ioana.ciornei@nxp.com> <20190523011958.14944-9-ioana.ciornei@nxp.com>
 <9c953f4f-af27-d87d-8964-16b7e32ce80f@gmail.com> <CA+h21hpPyk=BYxBXDH5-SGfJdS-E+X9PfZHAMLYNwhL-1stumA@mail.gmail.com>
 <20190524131937.GB2979@lunn.ch>
In-Reply-To: <20190524131937.GB2979@lunn.ch>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 24 May 2019 16:44:17 +0300
Message-ID: <CA+h21hpRrEqe82iMp5euimdBbKMAW2M6T3kr09z7L=S9kkOrGQ@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 8/9] net: dsa: Use PHYLINK for the CPU/DSA ports
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "maxime.chevallier@bootlin.com" <maxime.chevallier@bootlin.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 May 2019 at 16:19, Andrew Lunn <andrew@lunn.ch> wrote:
>
> > Hi Florian,
> >
> > Yes we could, but since most of the adjust_link -> phylink_mac_ops
> > changes appear trivial, and we have the knowledge behind b53 right
> > here, can't we just migrate everything in the next patchset and remove
> > adjust_link altogether from DSA?
>
> I agree with Florian, we either need to support both, or their needs
> to be another patchset which comes first and converts all DSA drivers
> to PHYLINK. And it is this conversion patchset which is likely to
> break things, so it would be good to sit in net-next for a week or two
> to allow testing, before the second patchset is applied.
>
>    Andrew

Hi Andrew,

I think that converting drivers to PHYLINK in a separate patchset is
going to introduce useless work, since the complete migration to
PHYLINK is necessarily going to take 2 steps. As of now, the CPU and
DSA ports still use the PHYLIB adjust_link callback exclusively.
So let's see what the drivers need to do in adjust_link now and how to
map that over phylink_mac_config, and in v2 we can just remove the
adjust_link wrappers completely from DSA.

-Vladimir
