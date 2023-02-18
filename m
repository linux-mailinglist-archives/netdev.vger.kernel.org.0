Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2E2469BBF7
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 21:52:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbjBRUwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Feb 2023 15:52:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbjBRUwJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Feb 2023 15:52:09 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BDC415552
        for <netdev@vger.kernel.org>; Sat, 18 Feb 2023 12:52:08 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id ek11so5494823edb.9
        for <netdev@vger.kernel.org>; Sat, 18 Feb 2023 12:52:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=o7ScN4N0nrkJx6Bv86PpckoGWVJlWxsrplw/vz2Zkug=;
        b=VGiBP2NLmRfilMANv6ikHwjVHn9RRElH7iJX4ycp7tgknbmSTMC0i10IymD8phWtEh
         z9mHvCAN+70N11m6e6v/Nkq61BzelD+ZWpPlt1IaPacREeZ/bGm/N/CVCH4Wk+vFAYpG
         vARc/2yJESArs7+BHPcNbOX3mxUboJx9VKsrs7ZMgT3hhYdp8Yb+E/xuqMbwIRTsxRdq
         p95cGmDoiogd2R13r5rxu3ZAthMiFSpVGf6HYu/F0IloKxClPxAFQtU8q+QEz2x/44bS
         C7TcUpjoBMNAObDqIGBkrsmaQmnS7pisKHt1Qk0Y105+mw4mUggRHYFCDRHB8T1m3O8u
         TtvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o7ScN4N0nrkJx6Bv86PpckoGWVJlWxsrplw/vz2Zkug=;
        b=VzsRrXsWEdvn5yFXTMRjFgQkDjR0K8FsTEsGL2xIfCmnDHg9k0tn7L5zcbW1k+N1US
         uCmKqifdh0355BPC9J+S9erWEo+N/cIedcvxvw7efsDyfExIFae0LW/AR/3lCs+eXI+P
         0CRcNrlWKyIiSJVcpv3LqV4RriDeh8tSyrMYpIs4AraTxF7zsUTelyHKfIT3a3frfimt
         R/AVcf0fDbkiXNDjGn7IHnWE0LyKGyF2pCAp8xTJUbw/pAQUrzDILdGKJIjRMKiAHzHb
         XxIkAkV7HxvFptPfdAKq5kNLCSCawQPgMAy6xDe68Asfe6lEXAPgwWqG5KON7aMSvskO
         x/jg==
X-Gm-Message-State: AO0yUKXdZpvA64sfnb9NbLKyZ9J+mojQN6uO6Sx930vfTFed2qZAtYpS
        OWyzxAOiFl6arY/akHKibZkLbPsSYks=
X-Google-Smtp-Source: AK7set9MkN6WFCE/S4DF9PCMZvzSOdCrNB3pLSNpBTTQLjIfJyuY+14uQn7KJVY9z4x6JylUC+fXZw==
X-Received: by 2002:a17:906:805a:b0:8b2:7534:265e with SMTP id x26-20020a170906805a00b008b27534265emr6370909ejw.58.1676753526724;
        Sat, 18 Feb 2023 12:52:06 -0800 (PST)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id j24-20020a1709062a1800b0087223b8d6efsm3788279eje.16.2023.02.18.12.52.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Feb 2023 12:52:06 -0800 (PST)
Date:   Sat, 18 Feb 2023 22:52:04 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        netdev <netdev@vger.kernel.org>, erkin.bozoglu@xeront.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: Choose a default DSA CPU port
Message-ID: <20230218205204.ie6lxey65pv3mgyh@skbuf>
References: <5833a789-fa5a-ce40-f8e5-d91f4969a7c4@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5833a789-fa5a-ce40-f8e5-d91f4969a7c4@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arınç,

On Sat, Feb 18, 2023 at 08:07:53PM +0300, Arınç ÜNAL wrote:
> Hey there folks,
> 
> The problem is this. Frank and I have got a Bananapi BPI-R2 with MT7623 SoC.
> The port5 of MT7530 switch is wired to gmac1 of the SoC. Port6 is wired to
> gmac0. Since DSA sets the first CPU port it finds on the devicetree, port5
> becomes the CPU port for all DSA slaves.
> 
> But we'd prefer port6 since it uses trgmii while port5 uses rgmii. There are
> also some performance issues with the port5 - gmac1 link.
> 
> Now we could change it manually on userspace if the DSA subdriver supported
> changing the DSA master.
> 
> I'd like to find a solution which would work for the cases of; the driver
> not supporting changing the DSA master, or saving the effort of manually
> changing it on userspace.
> 
> The solution that came to my mind:
> 
> Introduce a DT property to designate a CPU port as the default CPU port.
> If this property exists on a CPU port, that port becomes the CPU port for
> all DSA slaves.
> If it doesn't exist, fallback to the first-found-cpu-port method.
> 
> Frank doesn't like this idea:
> 
> > maybe define the default cpu in driver which gets picked up by core
> (define port6 as default if available).
> > Imho additional dts-propperty is wrong approch...it should be handled by
> driver. But cpu-port-selection is currently done in dsa-core which makes it
> a bit difficult.
> 
> What are your thoughts?
> 
> Arınç

Before making any change, I believe that the first step is to be in agreement
as to what the problem is.

The current DSA device tree binding has always chosen the numerically first
CPU port as the default CPU port. This was also the case at the time when the
mt7530 driver was accepted upstream. Clearly there are cases where this choice
is not the optimal choice (from the perspective of an outside observer).
For example when another CPU port has a higher link speed. But it's not
exactly obvious that higher link speed is always better. If you have a CPU
port at a higher link speed than the user ports, but it doesn't have flow
control, then the choice is practically worse than the CPU port which operates
at the same link speed as user ports.

So the choice between RGMII and TRGMII is not immediately obvious to some code
which should take this decision automatically. And this complicates things
a lot. If there is no downside to having the kernel take a decision automatically,
generally I don't have a problem taking it. But here, I would like to hear
some strong arguments why port 6 is preferable over port 5.

If there are strong reasons to consider port 6 a primary CPU port and
port 5 a secondary one, then there is also a very valid concern of forward
compatibility between the mt7530 driver and device trees from the future
(with multiple CPU ports defined). The authors of the mt7530 driver must have
been aware of the DSA binding implementation's choice of selecting the
first CPU port as the default, but they decided to hide their head in
the sand and pretend like this issue will never crop up. The driver has
not been coded up to accept port 5 as a valid CPU port until very recently.
What should have been done (*assuming strong arguments*) is that
dsa_tree_setup_default_cpu() should have been modified from day one of
mt7530 driver introduction, such that the driver has a way of specifying
a preferred default CPU port.

In other words, the fact that the CPU port becomes port 5 when booting
on a new device tree is equally a problem for current kernels as it is
for past LTS kernels. I would like this to be treated seriously, and
current + stable kernels should behave in a reasonable manner with
device trees from the future, before support for multiple CPU ports is
added to mt7530. Forcing users to change device trees in lockstep with
the kernel is not something that I want to maintain and support, if user
questions and issues do crop up.

Since this wasn't done, the only thing we're left with is to retroactively
add this functionality to pick a preferred default CPU port, as patches
to "net" which get backported to stable kernels. Given enough forethought
in the mt7530 driver development, this should not have been necessary,
but here we are.

Now that I expressed this point of view, let me comment on why your
proposal, Arınç, solves exactly nothing.

If you add a device tree property for the preferred CPU port, you
haven't solved any of the compatibility problems:

- old kernels + new device trees will not have the logic to interpret
  that device tree property
- old device trees + new kernels will not have that device tree property

so... yeah.
