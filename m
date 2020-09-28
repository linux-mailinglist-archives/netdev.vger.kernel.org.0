Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B69F27B107
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 17:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbgI1Pjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 11:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726327AbgI1Pjk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 11:39:40 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCB2CC061755
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 08:39:40 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id k13so1387067pfg.1
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 08:39:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Pb7rKG5lTsVhRVk1GfDkHqyd4H80PKbKj0ZxDa3vPBE=;
        b=oeQUZ51wxnJK0rAjq5vrlmBO2lZr0LJnqxIdtOhHONGlAQRjCSB+HeQppkBNqPX1/R
         Ple1gQhCcxd1TR+UhzwtZJmgw6LGLA8SJTYJR2GxNe8aIMhUcKDXTQkU0E68aB4WAp5L
         ZyZnI7//iXN3TTnClfVcqgBbEX+xJ01J/ht2CMzW86dlJjDqOzSMXPb23adBe/RVI0En
         N4vQyPAbsc1ROU54mqMQgvpC701vwCqshJXbi6+BG4E72oQhHYAMQPLLNRVOyb+GCzLp
         c7AzBYFLW723uj+YkEy18fAcaY8EvAjRBMQU8O3w1XiaaX74lVimJ05JUWMmkiqKmwtH
         +FPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Pb7rKG5lTsVhRVk1GfDkHqyd4H80PKbKj0ZxDa3vPBE=;
        b=tD4sMYVXDYRg45AJcWkNhEj6ZpmAubHjbfOzPoUKqlSFb5YBcijJ7tYmEEVX1/7H4h
         hGZgJZ138/PgXe3wuquKECvtIMt+9mZe9kY170ZDzMI8lky/yWlwAxBL5Fdk/0CUexPm
         esvvk5f/dtV4o69cV6sZRXJJC4zaH53z3yDAHv3qoR6E8ywPrPSyBGFkCLYTpY/BFn8p
         vYfl86nH9DqUMGtlmQRmrGCMUPggOx4Y/FGMW6aVsD0nbDVU6qboJSC4YYKgobWu/uI3
         N/Q4kwEovj1PfLt0pT5JxvWZ2auj0UQYKcfqGA00ngAn/tyWraNlfD7a29GIEexGjhaK
         Pz0Q==
X-Gm-Message-State: AOAM5300fzbc0o37wsxROp0NPHGbCehSpNwsFzmr53+5BosA43Dtc5uS
        nXCHTtcDDx57tC7fIopgStiUt3sDjVxClA==
X-Google-Smtp-Source: ABdhPJxnY/JpWdpQuM5I99CgBO3OMC1jnGgzAZF2B4lAH4wXFtFFzHWAcEoIOKkloCyw2JRdGI++VQ==
X-Received: by 2002:a62:7ad0:0:b029:13e:d13d:a08f with SMTP id v199-20020a627ad00000b029013ed13da08fmr133408pfc.38.1601307580298;
        Mon, 28 Sep 2020 08:39:40 -0700 (PDT)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id gn24sm1845049pjb.8.2020.09.28.08.39.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2020 08:39:40 -0700 (PDT)
Date:   Mon, 28 Sep 2020 08:39:31 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] build: avoid make jobserver warnings
Message-ID: <20200928083931.75629c32@hermes.local>
In-Reply-To: <nycvar.YFH.7.78.908.2009241854160.8326@n3.vanv.qr>
References: <20200921232231.11543-1-jengelh@inai.de>
        <20200921171907.23d18b15@hermes.lan>
        <nycvar.YFH.7.78.908.2009220812330.10964@n3.vanv.qr>
        <20200924091107.1f11508c@hermes.lan>
        <nycvar.YFH.7.78.908.2009241854160.8326@n3.vanv.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Sep 2020 18:56:33 +0200 (CEST)
Jan Engelhardt <jengelh@inai.de> wrote:

> On Thursday 2020-09-24 18:11, Stephen Hemminger wrote:
> >> >
> >> >MFLAGS is a way to pass flags from original make into the sub-make.    
> >> 
> >> MAKEFLAGS and MFLAGS are already exported by make (${MAKE} is magic
> >> methinks), so they need no explicit passing. You can check this by
> >> adding something like 'echo ${MAKEFLAGS}' to the lib/Makefile
> >> libnetlink.a target and then invoking e.g. `make -r` from the
> >> toplevel, and notice how -r shows up again in the submake.  
> >
> >With your change does the options through the same?  
> 
> Well yes.

Ok, tested a number of cases, and this works for all of them.

But, the patch is missing Signed-off-by which is required for iproute2.
Please resend with DCO.
