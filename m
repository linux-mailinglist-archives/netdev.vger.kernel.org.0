Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31F6325157F
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 11:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729450AbgHYJig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 05:38:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728944AbgHYJif (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 05:38:35 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28F11C061574;
        Tue, 25 Aug 2020 02:38:35 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id a26so15688203ejc.2;
        Tue, 25 Aug 2020 02:38:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GU7Gx+8lP7j41umYZSyhMriLOz9f2ckA0XGONSnV4sI=;
        b=Bafe9ZxxYS/73lQ6hU/CDd1pFL1PUYV6cQxMX+GPjKjmgSi3i6P/GXYwoWvuxN0cKy
         0Q4xd/N+TzXakFcZGPyWgjpo2yrdbngXnHQZuWdGxAYcKc94/X8ejxhK2Ins/YIemBAI
         t2s7enEmYEKMXnHONoCGe6TQm36Swli4SZedE/73Cp/pnN/ZaoxKgz4GsNhoHNqIAYGu
         TSUEV6QrfOE/S5VOhTQm9Tceva6AE1o1601nxuHw/Dw2aVnCQ/tOTzR67RLwIKtNrHmm
         rDkxSOebaurJv+F2ulBzlLd8yWX3JajKHvR7WzP/9aFBelcaIuzIiX2wdnGVb/Y6egHd
         vlfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GU7Gx+8lP7j41umYZSyhMriLOz9f2ckA0XGONSnV4sI=;
        b=cXI09LEdKLwyzHDhUuHdmcjFugR5C1/cJOnRqefs6XWbqkawgTr8T02e6Hk5gGwa1u
         D/VQpTHKwOj2LFovYsqD7kvD+MW8sa6svl2knleKHSKQVCvcSoq8JFvMiMYXux2LcKhZ
         LbKJ1n7gPNDq8uHv8ZhQ+FdF4907ozAlpMKo5CYBiS++lQwtyfwplxcsNvSuNT3DjWGQ
         yVHpnWhDdJSItIZ1SsF7v2RBQdQ+tJ2Mnqa9i7yrZiVvlQb7oqFaWvptfHYDA7c0vLe9
         vOh7+lsrg3jav+KJv/huHtno6T0+8pzAN+3/oHR8ER4MUaZZiU3lyUxRjuZDcDjrnvxe
         QqaQ==
X-Gm-Message-State: AOAM5327XmD1TsD3/5VD7NJcWau1w2WEyc5lD/s/Yr0akPdOkyrVsEle
        B+T1YoQIkHMBQdLRjTAadDo=
X-Google-Smtp-Source: ABdhPJxvv94G4ZIYlmoKUhNAyf6v8rI+nzziWr4BJmxTa4AIZ3wtd0MJdVUUi8zPnfewu4b9rD1Oww==
X-Received: by 2002:a17:906:e8f:: with SMTP id p15mr5921347ejf.290.1598348313777;
        Tue, 25 Aug 2020 02:38:33 -0700 (PDT)
Received: from skbuf ([86.126.22.216])
        by smtp.gmail.com with ESMTPSA id d9sm12408134edt.20.2020.08.25.02.38.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2020 02:38:33 -0700 (PDT)
Date:   Tue, 25 Aug 2020 12:38:30 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH v3 5/8] net: dsa: hellcreek: Add TAPRIO offloading support
Message-ID: <20200825093830.r2zlpowtmhgwm6rz@skbuf>
References: <20200820081118.10105-1-kurt@linutronix.de>
 <20200820081118.10105-6-kurt@linutronix.de>
 <20200824225615.jtikfwyrxa7vxiq2@skbuf>
 <878se3133y.fsf@kurt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878se3133y.fsf@kurt>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 25, 2020 at 11:33:53AM +0200, Kurt Kanzenbach wrote:
> On Tue Aug 25 2020, Vladimir Oltean wrote:
> > On Thu, Aug 20, 2020 at 10:11:15AM +0200, Kurt Kanzenbach wrote:
> >
> > Explain again how this works, please? The hrtimer measures the CLOCK_TAI
> > of the CPU, but you are offloading the CLOCK_TAI domain of the NIC? So
> > you are assuming that the CPU and the NIC PHC are synchronized? What if
> > they aren't?
> 
> Yes, I assume that's synchronized with e.g. phc2sys.
> 

My intuition tells me that this isn't the user's expectation, and that
it should do the right thing even if it's not synchronized to the system
clock.

> >
> > And what if the base-time is in the past, do you deal with that (how
> > does the hardware deal with a base-time in the past)?
> > A base-time in the past (example: 0) should work: you should advance the
> > base-time into the nearest future multiple of the cycle-time, to at
> > least preserve phase correctness of the schedule.
> 
> If the hrtimer is programmed with a value in the past, it fires
> instantly.

Yes, it does.

> The callback is executed and the start time is programmed.
> 

With a valid value from the hardware's perspective?

Thanks,
-Vladimir
