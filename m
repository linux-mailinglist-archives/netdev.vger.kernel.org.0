Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4D22F8661
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 21:13:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388803AbhAOUMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 15:12:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728895AbhAOUMv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 15:12:51 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD1DAC0613C1
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 12:12:10 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id x20so14925762lfe.12
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 12:12:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=J9P/LhGMMxdn2jO5xF8EgWqeV8L4+p8anfqdyM90pXY=;
        b=v/nOAt0A0Z5jh49Aq6LRg/sOk/7P3qRmNwHLKchEemMHAyl+yQBbN5yz+wk4s4NyNs
         qq3xESDbd8k+5ohEVcgj0RuvkHUEnGzRIUT6QJNNX4vd0DAzNP95YIhgwb2+9X8WkETO
         fxKxoQgL0i3XD/Els5AKlC4YCnZZA9JOJId+La36Q2IpSpdFlXcckYgoJjRKwl7YKhM6
         ohw0bB14j89WNfHnWbf7Fjbc9S765BoLesmS/R1iLT7Oqs/z+serQ98UTz0eZ9merS6T
         zDn7kfG7fFoBwYES0DlNnVgssqf0BWgT+1INvhO7RrDwsCeyPUKA7YUHsJim2rEUnrAy
         g83Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=J9P/LhGMMxdn2jO5xF8EgWqeV8L4+p8anfqdyM90pXY=;
        b=AeTDX/wkQA37oI1kmKZWNT7r8Brwk06cbqvK6yxX2JrCYqqpdEx+0S/UVscVFO9HKp
         ov8GdkM1jxNoPSrJ9clJkJCrVhmhgsx22oSd4Cqi6H20xlvL5sllpaF+pYOyMCiuRnsO
         94gbkKm3NO0YwnertjbyMxIQJlnw1As8v44aS45c+Z2Rme/HkHZ4S6hGmScRhSHawIv8
         gYjvhnR5dR0N+TcvHFq2kie9iisGH2KBfhTNODmnH3jqS4+iUWKA/iiniik18dMvC01i
         M0nuzvG/CGtpL0xDiLDMMLYsKrY9NnIhWpTCV8gIlMAG0XsRIDxL4ps30RwaSZXGwsFn
         cdXg==
X-Gm-Message-State: AOAM531Edypx3v1MyxJXhuCCspYvuFHTMuAzzbBMFN37WF/ZEm/uuVmA
        zjYhV1aBsEMu2vzbQ7NVuXRZ27FAukiYog==
X-Google-Smtp-Source: ABdhPJy/cXnlG3b3dwJwW6DulmC1bcc5ztCEW9WlhQh4V83EyJvk82nRmANBgdO6BTC/DmIvMTzPJg==
X-Received: by 2002:a19:c70b:: with SMTP id x11mr6318682lff.258.1610741529227;
        Fri, 15 Jan 2021 12:12:09 -0800 (PST)
Received: from wkz-x280 (h-236-82.A259.priv.bahnhof.se. [98.128.236.82])
        by smtp.gmail.com with ESMTPSA id q5sm902045ljg.122.2021.01.15.12.12.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 12:12:08 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: dsa: mv88e6xxx: Provide dummy implementations for trunk setters
In-Reply-To: <YAGrRJYRpWg/4Yl5@lunn.ch>
References: <20210115105834.559-1-tobias@waldekranz.com> <20210115105834.559-2-tobias@waldekranz.com> <YAGnBqB08wwWQul8@lunn.ch> <20210115143649.envmn2ncazcikdmc@skbuf> <YAGrRJYRpWg/4Yl5@lunn.ch>
Date:   Fri, 15 Jan 2021 21:12:07 +0100
Message-ID: <87lfcuklig.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 15, 2021 at 15:48, Andrew Lunn <andrew@lunn.ch> wrote:
> On Fri, Jan 15, 2021 at 04:36:49PM +0200, Vladimir Oltean wrote:
>> On Fri, Jan 15, 2021 at 03:30:30PM +0100, Andrew Lunn wrote:
>> > On Fri, Jan 15, 2021 at 11:58:33AM +0100, Tobias Waldekranz wrote:
>> > > Support for Global 2 registers is build-time optional.
>> > 
>> > I was never particularly happy about that. Maybe we should revisit
>> > what features we loose when global 2 is dropped, and see if it still
>> > makes sense to have it as optional?
>> 
>> Marvell switch newbie here, what do you mean "global 2 is dropped"?
>
> I was not aware detect() actually enforced it when needed. It used to
> be, you could leave it out, and you would just get reduced
> functionality for devices which had global2, but the code was not
> compiled in.
>
> At the beginning of the life of this driver, i guess it was maybe
> 25%/75% without/with global2, so it might of made sense to reduce the
> binary size. But today the driver is much bigger with lots of other
> things which those early chips don't have, SERDES for example. And
> that ratio has dramatically reduced, there are very few devices
> without those registers. This is why i think we can make our lives
> easier and make global2 always compiled in.

Hear, hear!

I took a quick look at the (stripped) object sizes (ppc32):

# du -ab
6116    ./global1_vtu.o
5904    ./devlink.o
11500   ./port.o
9640    ./global2.o
3016    ./phy.o
5368    ./global1.o
51784   ./chip.o
9892    ./serdes.o
5140    ./global1_atu.o
1916    ./global2_avb.o
2248    ./global2_scratch.o
948     ./port_hidden.o
1828    ./smi.o
119396  .

So, roughly, you save 10%/13k. That hardly justifies the complexity IMO.

Andrew, do you want to do this? If not, I can look into it.
