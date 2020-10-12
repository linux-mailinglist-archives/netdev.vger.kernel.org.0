Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22C2828C437
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 23:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730431AbgJLVm7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 17:42:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730399AbgJLVm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 17:42:58 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC635C0613D0;
        Mon, 12 Oct 2020 14:42:58 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id 10so5382389pfp.5;
        Mon, 12 Oct 2020 14:42:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8xaydyGIfM3saVB17dxn1KIC+hbD/30lvvweMc3Q4qc=;
        b=MLJsuz0NGWgKfSS+pGmQXDM7hDcNjKyyeBY+U48MKU9cU70nlo4d9dglHq4D3NwCsL
         Cglcsgrjed6vM6zHh2HOYxhnExV3bE1ZEqztVfwjB/Y8bCAl7MnTPuAJlt57DSRS2dca
         lphF9W3kvBLgjNXFF70Dy/L5uMKLW4jkrTmVytLRpRLev6F4b8ePu89U4uxFgyh4I1jg
         gKxEkodp1q55XKNvBNiPp2+clmJLejGmqflcIrH8VsTEwi7nFR1+5z+xrrl1t2qCXGd3
         61Aa9zShHgfiArzzTZ8iTgsuEtzBeAH2c94rymB/0rSx0s/ilSt4ZtHlASQmxQBVo5K5
         p16g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8xaydyGIfM3saVB17dxn1KIC+hbD/30lvvweMc3Q4qc=;
        b=E2q6DfqghAdpEOmXF3yAaowfG9Jlk1qqon0RLr69Oq7ZmSrwkscJ99p7HvWD7JHB2a
         JnhWG2Ltx+bx/TQQ8rDztOzA84DfVr73jesTUpMJDR0p1/X/JzLhE5LOUij9U8nZS3jv
         gkw4HfuYYS+VeI2qruclO7mQnTqGFqF9Qc7EIRj2+pCTr2IXlIi2XBy1NclqgGNBkmhh
         ieoe4vjCglDMF15yuqeBstdZUJ0cYgUY1gCbppW5A3xcPICd3gAdFw1NB5uny7jRP/RH
         WkA0/Zj5m2pnIJjCWJMx+5JFN6BAlEHTyNhtNaLmB1pYXOXEx9BqMIMEUc83k74piOzY
         hZrg==
X-Gm-Message-State: AOAM533i3vws4ALEoifw2+9oMNtSFFFh8GCnNwDVW447z/Os3zlB0ocz
        /2Odc+goNg+ssIXG2vMjSlw=
X-Google-Smtp-Source: ABdhPJxUxaqqm7koPf75n2iHN2zkfkTFEuIiIuwZQwclfjXwexoHxFyuWZ8+A+zPCjtRWYTixSyzWw==
X-Received: by 2002:a62:3641:0:b029:154:fd62:ba90 with SMTP id d62-20020a6236410000b0290154fd62ba90mr25537184pfa.62.1602538978321;
        Mon, 12 Oct 2020 14:42:58 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id in6sm23884539pjb.42.2020.10.12.14.42.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 14:42:57 -0700 (PDT)
Date:   Mon, 12 Oct 2020 14:42:54 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH net-next v6 4/7] net: dsa: hellcreek: Add support for
 hardware timestamping
Message-ID: <20201012214254.GA1310@hoboy>
References: <87r1qb790w.fsf@kurt>
 <20201006140102.6q7ep2w62jnilb22@skbuf>
 <87lfgiqpze.fsf@kurt>
 <20201007105458.gdbrwyzfjfaygjke@skbuf>
 <87362pjev0.fsf@kurt>
 <20201008094440.oede2fucgpgcfx6a@skbuf>
 <87lfghhw9u.fsf@kurt>
 <f040ba36070dd1e07b05cc63a392d8267ce4efe2.camel@hs-offenburg.de>
 <20201008150951.elxob2yaw2tirkig@skbuf>
 <65ecb62de9940991971b965cbd5b902ae5daa09b.camel@hs-offenburg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65ecb62de9940991971b965cbd5b902ae5daa09b.camel@hs-offenburg.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 12, 2020 at 02:53:58PM +0200, Kamil Alkhouri wrote:
> > By the way, how would you see the split between an unsynchronized and
> > a
> > synchronized PHC be implemented in the Linux kernel?

If you want, you can run your PHC using the linuxptp "free_running"
option.  Then, you can use the TIME_STATUS_NP management request to
use the remote time signal in your application.

> I'm not an expert in kernel implementation but we have plans to discuss
> possible approaches in the near future.

I don't see any need for kernel changes in this area.

Thanks,
Richard
