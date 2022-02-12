Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 481BA4B329E
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 03:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbiBLCVu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 21:21:50 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:49152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiBLCVt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 21:21:49 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15A5F334
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 18:21:47 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id s2so6441pfg.12
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 18:21:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WBwhXfiQrYCO2GjbAzdhtwnbrP0FR/O2oWzjIDgaYa8=;
        b=oLrkfXVl0KDjBrZTXm1CkUNv17cv/uJvMOwJinzJ4zUl+HLBcmVwQkfxrSHiWFzL1R
         xqE2thBRqrrVliLDYw1hs7WPwuxyetvLDiEJ7f9URZja9WGoedQkTXo2Tn+75aP1YblK
         +KFOwh5kNu77jU/PY1On8EntMcttEP5IIvUDwyBUJNzeRRUaDTcHJmgbOYCgFZRY7tf0
         KxFkO8M1N6etlCNPvepNzQh9oqD3KLkAxrgpN+hYkM/actMu5HXdRmzznxCL2xQFiPaj
         U6vdTanX3EKkGw9GO7eJfnzE6PmL7ly0ryzR6vbh4oGD1WfWJrSGX54MWwMU6Cg2XWcT
         iaRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WBwhXfiQrYCO2GjbAzdhtwnbrP0FR/O2oWzjIDgaYa8=;
        b=xCbqvvtAuZtm+SnRIJvYt7bwWPJk3oWC1EF+Qrgo+eI1hVlq87JybIyyXSFGyPWqkY
         fzxe5PTrBXSi3T0MSTKJRtE5L5w6pE9eH1du418ecnlqeAf/mjpacxpqqVXMgBN8m/Nh
         IiES7dR9tiQ0VxvMdWY+SR8+4ZeBYsvbrlwtR8hyMgumj9zj6yK8+EpRw+y3BKVmWEWU
         X4pAYc55FcJ0Lhoh7fd3EcSjHY77hHZTl9GqQH/UNANcG55R5IJ4p8avSUmLo0dGz4/h
         amfa5Vi7THwEf4kK4546HPhrM5gBbSEKnqTaVpe4P14CRuNpk4L4hqZP5h3czVczqnnW
         6dQQ==
X-Gm-Message-State: AOAM533V0QCdgOba3cE1BT1dOFYDtXjmDuVz6QYruBYPTD0Zd9mFYVwc
        YUIf7StCgDvUaFf8J3rxr0AktQ==
X-Google-Smtp-Source: ABdhPJz0rxBIEls9NfLcjB1f6ak5sgVF7XkZef73yMm/fuXipI5BtpO7pHtcuPS5uBJi47KrUnD79A==
X-Received: by 2002:a63:cf:: with SMTP id 198mr3640389pga.418.1644632506617;
        Fri, 11 Feb 2022 18:21:46 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id g4sm28340011pfv.63.2022.02.11.18.21.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 18:21:46 -0800 (PST)
Date:   Fri, 11 Feb 2022 18:21:43 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, netdev@vger.kernel.org
Subject: Re: packet stats validation
Message-ID: <20220211182143.458faa6c@hermes.local>
In-Reply-To: <YgbaKDZhHfGV542h@lunn.ch>
References: <YgYixOmTSI7jxALK@pengutronix.de>
        <YgbaKDZhHfGV542h@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Feb 2022 22:50:32 +0100
Andrew Lunn <andrew@lunn.ch> wrote:

> On Fri, Feb 11, 2022 at 09:48:04AM +0100, Oleksij Rempel wrote:
> > Hi all,
> > 
> > I'm implementing stats64 for the ksz switch and by validating my
> > implementation found different by count methods in different sub
> > systems. For example, i send 64 byte packet with:
> > 
> > mausezahn enp1s0f3 -c 1 -a rand -p 64
> > 
> > - tshark is recognizing 64 byte frame with 50 byte data
> > - Intel igb is counting it as 64 byte
> > - ksz9477 switch HW counter is counting it as 68 bytes packet
> > - linux bridge is counting it as 50 byte packet
> > 
> > Can you please help me to understand this differences?
> > Do linux bridge is doing it correct or it is a bug?
> > ksz9477 is probably adding a tag and counting tagged packets. Should
> > this number be provided to stats64?  
> 
> I've come across this before, when i was doing systematic testing of
> switches, using different USB ethernet dongles as traffic
> source/sinks. Tests with one board and set of dongles gave different
> results to a different board with different dongles. The drivers
> counted different bytes in the frames. Some drivers include the FCS,
> some don't, etc. I proposed a change to one of the drivers so it gave
> the same counters as the other, but it was rejected. Because it is not
> clearly defined what should be counted, there is not correct driver.
> 
> It is also unclear how you should count runt frames which get padded
> up to 64 when actually put on the wire. This might be why the bridge
> is so different, the frame as not been padded yet.
> 
>    Andrew

Accepted practice for BSD and Linux (and therefore vendors using those OS)
is to not count FCS. The hardware focused vendors tend to count the FCS.
The argument for including FCS is partly for calculating QoS values in bit/sec
and partly to include it for marketing reasons.

Linux is documented to not include FCS in statistics.
(see https://www.kernel.org/doc/html/latest/networking/statistics.html).
Any device that counts FCS in byte count is broken and should be fixed!


