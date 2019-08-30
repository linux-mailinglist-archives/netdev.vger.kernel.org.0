Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE7CA408E
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 00:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728271AbfH3W3E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 18:29:04 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:35399 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728143AbfH3W3E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 18:29:04 -0400
Received: by mail-pg1-f196.google.com with SMTP id n4so4221251pgv.2
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 15:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=D0GkdFad4HmAeBKGuBad4cys0jEGx/0fz0YsVLmnzok=;
        b=PyglIVhVNRHHcXDv/bb/HxgYMXuIElZwn36Nb9GZwh03ne2qaJOx9aUSrDYZPCuZpD
         b+KTDKnTXrUsopjfsHXQPa5yAIEh2U26JvXZb/owZaAKa2VQGyf9utsWMW4hvXx/3H6I
         B56Y2i0GzAL2MWJFozdgaoQ/+FKHm8ptDgwaVwfBAOml6iQdE3e/ltl/KHtwtzedLVck
         OoZaQ/FYjGmUZdPuwBYdua7coTe/v7FIs62oP1sjjiTIiXzJaYxdyhpwQaDMZSDzo1OB
         Fz1L5X3enrgBnfJ2XJmHXnSlJBEVU5r/IBN4kW8O9IH8W81oA3bKau5hA4Yk9AQlwxrr
         uPow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=D0GkdFad4HmAeBKGuBad4cys0jEGx/0fz0YsVLmnzok=;
        b=bmmwYvO8kPK8S8aQ2ky1Z1aLP9DUpv3bhoYoxEbm848wVGuVPjDbLBrid9xys14Hkb
         nIQtiO6UyP4yMbjxjmFJuyeDWUX0p7QsgVIalWIBoiOtw0yS3UMi9krV7nyJ9JGBjK1J
         rY84X7cikfR7qOCcESdQMCP47fHMy1uDS/or97e24P7dixmQV8aCOCyWzOD1gg01Xsti
         svvtyABsYPsoawwr2ivsx3YtiewrxkrIM2kO+f2qF/x/TutDlQ5UVUfquXr+pVvYSP+T
         04xDpxIvdniQEDZFgfsxrDdyWzChHPrcOFyD4VVrjhh/Ky6ktMFpHNQPOiy+4PmeK8RB
         VTTg==
X-Gm-Message-State: APjAAAWaAEC90iUVg93d4JnI7GL4L+arCDkUgVLLc4inLhllVPfefwgZ
        kJB2DAVF568kHln+z0+JDsVaOg==
X-Google-Smtp-Source: APXvYqxpUqBsM9iHJnCC2U2E3etkSXwjluFG5hSDnJcD2qXpCqPM1HbzJ1+NAEXTBUoNThhSHj2XgQ==
X-Received: by 2002:a63:5951:: with SMTP id j17mr14609212pgm.143.1567204143230;
        Fri, 30 Aug 2019 15:29:03 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id v189sm7920837pfv.176.2019.08.30.15.29.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Aug 2019 15:29:02 -0700 (PDT)
Date:   Fri, 30 Aug 2019 15:28:39 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        vedang.patel@intel.com, Richard Cochran <richardcochran@gmail.com>,
        weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        xiyou.wangcong@gmail.com, netdev <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH v2 net-next 00/15] tc-taprio offload for SJA1105 DSA
Message-ID: <20190830152839.0fe34d25@cakuba.netronome.com>
In-Reply-To: <CA+h21hr==OStFfgaswzU7HtFg_bHZPoZD5JTQD+-e4jWwZYWHQ@mail.gmail.com>
References: <20190830004635.24863-1-olteanv@gmail.com>
        <20190829182132.43001706@cakuba.netronome.com>
        <CA+h21hr==OStFfgaswzU7HtFg_bHZPoZD5JTQD+-e4jWwZYWHQ@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Aug 2019 13:11:11 +0300, Vladimir Oltean wrote:
> On Fri, 30 Aug 2019 at 04:21, Jakub Kicinski wrote:
> > On Fri, 30 Aug 2019 03:46:20 +0300, Vladimir Oltean wrote:  
> > > - Configuring the switch over SPI cannot apparently be done from this
> > >   ndo_setup_tc callback because it runs in atomic context. I also have
> > >   some downstream patches to offload tc clsact matchall with mirred
> > >   action, but in that case it looks like the atomic context restriction
> > >   does not apply.  
> >
> > This sounds really surprising ndo_setup_tc should always be allowed to
> > sleep. Can the taprio limitation be lifted somehow?  
> 
> I need to get more familiar with the taprio internal data structures.
> I think you're suggesting to get those updated to a consistent state
> while under spin_lock_bh(qdisc_lock(sch)), then call ndo_setup_tc from
> outside that critical section?

I'm not 100% sure how taprio handles locking TBH, it just seems naive
that HW callback will not need to sleep, so the kernel should make sure
that callback can sleep. Otherwise we'll end up with 3/4 of drivers
implementing some async work routine...

Sorry, I know that's quite general and not that helpful.

> Also, I just noticed that I introduced a bug in taprio_disable_offload
> with my reference counting addition. The qdisc can't just pass stack
> memory to the driver, now that it's allowing it to keep it. So
> definitely the patch needs more refactoring.

Ah, a slight deja vu, I think someone else has done it in the past :)
