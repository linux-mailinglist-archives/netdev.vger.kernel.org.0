Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38DCE381495
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 02:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234532AbhEOAa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 20:30:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbhEOAa1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 20:30:27 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB3B5C06174A
        for <netdev@vger.kernel.org>; Fri, 14 May 2021 17:29:15 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1621038552;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jwO5ELDdSCLxygWXZ6T6Q2CjNgTXaug0wdEKtaKuqaI=;
        b=EHmob1yzL9sAIsOkZjpaMYoEavcJC3HaNiRJo+Npv6An0+uIwY3kyby1f88QxA8kI0q8oe
        ipo/yPDOFw2SRJMogQdgQ4yxU2i5pckcGLlEAdpF+5yf2t7wIebOsUH90nqTzQ3SMbPrm8
        wl6sPoqGOSCMhbgIiviXyxFtaV8AA10dNY2TbOlxIaYoJt/jEviUj8WM8JOeEKT0A3erpp
        VKvpp7iMEQ0ZoX8MQSawwJipUjAOhbj7fIIUNI8J8euA35rzjH7unmzSqhS2KaLV9o18pw
        2gUNgbIuVcyz+M498yawEmZ+0IwELxL3kcfXV32Xg7pA4vcb7MTvxb+wLE0ZsQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1621038552;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jwO5ELDdSCLxygWXZ6T6Q2CjNgTXaug0wdEKtaKuqaI=;
        b=jErTG+uXHoEAWsBCtFEMGoVn71gj618Nbb8XLTbGebuGbXx9pAvOQ0snPjemDpSCfet/8B
        vGKVSFjckw58ulDw==
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, simon.horman@netronome.com,
        oss-drivers@netronome.com, bigeasy@linutronix.de
Subject: Re: [PATCH net-next 1/2] net: add a napi variant for RT-well-behaved drivers
In-Reply-To: <20210514172157.7af29448@kicinski-fedora-PC1C0HJN>
References: <20210514222402.295157-1-kuba@kernel.org> <87y2cg26kx.ffs@nanos.tec.linutronix.de> <20210514172157.7af29448@kicinski-fedora-PC1C0HJN>
Date:   Sat, 15 May 2021 02:29:11 +0200
Message-ID: <87sg2o2620.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 14 2021 at 17:21, Jakub Kicinski wrote:
> On Sat, 15 May 2021 02:17:50 +0200 Thomas Gleixner wrote:
>> On Fri, May 14 2021 at 15:24, Jakub Kicinski wrote:
>> >  
>> > +void __napi_schedule_irq(struct napi_struct *n)
>> > +{
>> > +	____napi_schedule(this_cpu_ptr(&softnet_data), n);  
>> 
>> Not that I have any clue, but why does this not need the
>> napi_schedule_prep() check?
>
> napi_schedule_prep() is in the non-__ version in linux/netdevice.h:
>
> static inline void napi_schedule_irq(struct napi_struct *n)
> {
> 	if (napi_schedule_prep(n))
> 		__napi_schedule_irq(n);
> }

I clearly should go to bed now :)
