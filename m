Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE5F17B9C
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 16:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727344AbfEHOg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 10:36:59 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43015 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726687AbfEHOg7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 10:36:59 -0400
Received: by mail-pf1-f193.google.com with SMTP id c6so5397290pfa.10;
        Wed, 08 May 2019 07:36:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Ftxd/yGo/xg+LooGM3ZD/VdN0H7EkQxNojOlbdPB8hk=;
        b=GFOAMN4G1WRghAnlNyjXeaqSsonA/53S0DSqWPf54QwuNQDT1NbIYLzp9w3fhZJFtN
         aiSKheRl2EusqiUpf3wsoy3fr5QmJu1rSfg7kWe0o/uADF8HeDLcbksODBQwBwlmizbz
         8XE1Cb7/QP0JCLcxO6ebcvY7JlWjixRPUtMymB2ehb9bUFpAAwJKTN2pvQ0A+dib+RCT
         SGekeXxhObb5v1F6knvIdK+gQPPbU5Yy/oJwAIO2vXK2hVb78feJqIh2E0lghsfK6QgE
         jktmdNu03tVA+o+IS/rc4DicflXeoMssjytPTXhMO9HCDWJsir2kCt5jeSX/yqcF5Uj7
         LG+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Ftxd/yGo/xg+LooGM3ZD/VdN0H7EkQxNojOlbdPB8hk=;
        b=Dn9ksz872ac3pmGPFOUm5Rx7TPmwQhQWmGqktYc26S319pDRA2mzg4V4d2Ifo/9utz
         FeKEZpnpwS/fGzC1yNW257xdhWksogk3x8Lbo1MFohR2o1w5gADqqs/OolVFUeNts8H4
         KHeOIqExYIpHqMpHzrpk6oppLyT6RYGfG3mWM4tjU9ifJVHg1eEoO1WfmCsI1cM5+z9/
         BWGzu8JaswxYSVR0Q+EDnppVW/V9adROqMDnoWQsr0ml5d4z7IFtxazuRA9KIGCz/12C
         jJ+lWTSd4XbY4aDmFlrn8RRa170IEAVYDbp5Y8T5898pn1EqdvsdxzwrK+4EXAuLsnI3
         EeqA==
X-Gm-Message-State: APjAAAVX69ghzsP6e2ubZasx7MEVGTxxzj3tUy0g4UFwBXXpRM07D0Rx
        TjC4NMcOwz6RWj9+9x47Yzo=
X-Google-Smtp-Source: APXvYqwFTky+u99b+yN1sIumvpHzai76th7uvSwoCwE6E1F3oFzkKw34NCWTmOtkhi1n2S8pol/jMQ==
X-Received: by 2002:a63:465b:: with SMTP id v27mr6811806pgk.38.1557326218322;
        Wed, 08 May 2019 07:36:58 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id t26sm10739342pgk.62.2019.05.08.07.36.56
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 08 May 2019 07:36:57 -0700 (PDT)
Date:   Wed, 8 May 2019 07:36:54 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Po Liu <po.liu@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "Y.b. Lu" <yangbo.lu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Leo Li <leoyang.li@nxp.com>, Roy Zang <roy.zang@nxp.com>,
        Mingkai Hu <mingkai.hu@nxp.com>,
        "deepa.kernel@gmail.com" <deepa.kernel@gmail.com>
Subject: Re: [EXT] Re: [PATCH v1] timer:clock:ptp: add support the dynamic
 posix clock alarm set for ptp
Message-ID: <20190508143654.uj7266kcbhf744c3@localhost>
References: <1557032106-28041-1-git-send-email-Po.Liu@nxp.com>
 <20190507134952.uqqxmhinv75actbh@localhost>
 <VI1PR04MB51359553C796D25765720FCC92320@VI1PR04MB5135.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR04MB51359553C796D25765720FCC92320@VI1PR04MB5135.eurprd04.prod.outlook.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 08, 2019 at 03:30:01AM +0000, Po Liu wrote:
> > Sorry, NAK, since we decided some time ago not to support timer_* operations
> > on dynamic clocks.  You get much better application level timer performance
> > by synchronizing CLOCK_REALTIME to your PHC and using clock_nanosleep()
> > with CLOCK_REALTIME or CLOCK_MONOTONIC.
> 
> The code intend to get alarm by interrupt of ptp hardware. The code
> to fix ptp not support to application layer to get the alarm
> interrupt.  Do you mean the synchronizing at application layer by
> PHC (using clock_nanosleep()) to the CLOCK_REALTIME source? Then the
> kernel could using the hrtimer with CLOCK_REALTIME?

Yes, or with CLOCK_MONOTONIC.

> > > This won't change the user space system call code. Normally the user
> > > space set alarm by timer_create() and timer_settime(). Reference code
> > > are tools/testing/selftests/ptp/testptp.c.
> > 
> > That program still has misleading examples.  Sorry about that.  I'll submit a
> > patch to remove them.
> 
> Is there any replace method for an application code to get alarm interrupt by the ptp source?

No the alarm functionality has been removed.  It will not be coming
back, unless there are really strong arguments to support it.

Here is the result of a study of a prototype alarm method.  It shows
why the hrtimer method is better.

   https://sourceforge.net/p/linuxptp/mailman/message/35535965/

Thanks,
Richard
