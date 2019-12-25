Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8C912A913
	for <lists+netdev@lfdr.de>; Wed, 25 Dec 2019 21:25:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbfLYUYr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 15:24:47 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:38395 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726415AbfLYUYr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 15:24:47 -0500
Received: by mail-pg1-f194.google.com with SMTP id a33so11950212pgm.5
        for <netdev@vger.kernel.org>; Wed, 25 Dec 2019 12:24:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VW3b0yXG3fsaN6BsnsbeDFlqo4XryZpan0MVKAZhesQ=;
        b=Liekt9Ipiyc3CX4D2g8J2LwM8mPQvZvzkOrlATBhH0DFoDK9GGv02qSGQCiZkSqyKF
         OwMVqe0GBE6ZFQsedvtcjpoDBMGbCxW1GX6BNO1p2UaRoHk3O1dsbMXYArRECKcJDvyV
         KjgTGGZEtVs/FlwsKsHBMoY65lXi4WbkWtvmHmEuieunW/GHrpf5iunO1RNox1dkdWsk
         w2n73i1be1kWrIDxsZvFgZLouChM0xZcMmeveg/R4CzfFkXdzHrd3dPbTEP/h0P9oNsU
         HEpWpGfGLgwGw1GLHMY07EYc1NY8rzK7LMwL8ryqzf177fnP56c9vzFujGlaw5H3fPcZ
         ZRSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VW3b0yXG3fsaN6BsnsbeDFlqo4XryZpan0MVKAZhesQ=;
        b=iRf7+HIl0Ubm1Zy3jFYkrhtkyLqWsphv0SGbjFH8Y+Hla++iMPJOU+sUgii8x9BSlJ
         eJCpBUm2T5eHl3S8/6B7ZUBnf/QAC2EHLGtlJUSUmzGyI+Frlya+GXIb/Ukowu18RcuD
         8wu3arck1/M5tlHTbIj4mgpFD8W2A8Oc2QXeQWZlOcuGWUzkcKncEhJpe7LrBCL0/+ol
         Qrm/WhMSWm2yYbRXM9Li0ervmBtoDSWiavbBCKgPeg6pOeMQy3L3fxJbv/6LaOZX4Jd+
         VkFMDcwjgbYe4YWtehEgY3wG8znkwuhlb2j/zuTJe6HpN/0ABIEd2Dbvs74fD+Qa5bjN
         JyAg==
X-Gm-Message-State: APjAAAW4RTG+JmoZLgVPow6haKEFKTAzarCsUM5jStjRRDOfCTC30wDf
        v5TwhfujiGUGqd/w3RDLQypD7g==
X-Google-Smtp-Source: APXvYqz3JWp+mk4N6FVAtBZuaogKu5R1NLVl6nR/NKs14ZdTkI1N8CFohZ8xEHrF2vI3dGA5WIoRPg==
X-Received: by 2002:aa7:9306:: with SMTP id 6mr44927813pfj.36.1577305486618;
        Wed, 25 Dec 2019 12:24:46 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id w187sm15863213pfw.62.2019.12.25.12.24.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Dec 2019 12:24:46 -0800 (PST)
Date:   Wed, 25 Dec 2019 12:24:24 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Fenghua Yu <fenghua.yu@intel.com>
Cc:     David Miller <davem@davemloft.net>, michael.chan@broadcom.com,
        netdev@vger.kernel.org, tglx@linutronix.de, luto@kernel.org,
        peterz@infradead.org, tony.luck@intel.com, David.Laight@ACULAB.COM,
        ravi.v.shankar@intel.com
Subject: Re: [PATCH] drivers/net/b44: Change to non-atomic bit operations
Message-ID: <20191225122424.5bc18036@hermes.lan>
In-Reply-To: <20191225011020.GE241295@romley-ivt3.sc.intel.com>
References: <1576884551-9518-1-git-send-email-fenghua.yu@intel.com>
        <20191224.161826.37676943451935844.davem@davemloft.net>
        <20191225011020.GE241295@romley-ivt3.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Dec 2019 17:10:20 -0800
Fenghua Yu <fenghua.yu@intel.com> wrote:

> On Tue, Dec 24, 2019 at 04:18:26PM -0800, David Miller wrote:
> > From: Fenghua Yu <fenghua.yu@intel.com>
> > Date: Fri, 20 Dec 2019 15:29:11 -0800
> >   
> > > On x86, accessing data across two cache lines in one atomic bit
> > > operation (aka split lock) can take over 1000 cycles.  
> > 
> > This happens during configuration of WOL, nobody cares that the atomic
> > operations done in this function take 1000 cycles each.
> > 
> > I'm not applying this patch.  It is gratuitous, and the commit message
> > talks about "performance" considuations (cycle counts) that completely
> > don't matter here.
> > 
> > If you are merely just arbitrarily trying to remove locked atomic
> > operations across the tree for it's own sake, then you should be
> > completely honest about that in your commit message.  
> 
> We are enabling split lock in the kernel (by default):
> https://lkml.org/lkml/2019/12/12/1129
> 
> After applying the split lock detection patch, the set_bit() in b44.c
> may cause split lock and kernel dies.
> 
> So should I change the commit message to add the above info?
> 
> Thanks.
> 
> -Fenghua

Why not just make pwol_pattern aligned and choose the right word to do
the operation on?
