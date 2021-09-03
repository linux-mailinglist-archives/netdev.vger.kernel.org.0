Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4765240032A
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 18:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349741AbhICQWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 12:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235629AbhICQWd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 12:22:33 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EE9FC061575
        for <netdev@vger.kernel.org>; Fri,  3 Sep 2021 09:21:33 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id k24so5999735pgh.8
        for <netdev@vger.kernel.org>; Fri, 03 Sep 2021 09:21:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=M8prA5obJxgifJPaDY3q2ZbY2oPL4lc/Ba1aChiVrz8=;
        b=HIbRBJSqUzKRZxFUTjXAGzYBUDRUMbYjPlePDlKMtBuOz0xVdIQWoH98Hhilk0/5+v
         sQQ6cE03vBpF9eJmLWt3mjvG29bWjhVBK7JxrGA5DBkaK4r630aLpV3SbH4qauhpnFKB
         Mnktl50oxMpwtW4B6Vfo1qujId5KPdhHrH2eq3wtEQqvrVK6DVCUbKdhKIP5xJzlTZ+O
         baC2DzL9yrSLwKBjXKeEocIOEM4V9Y0ueAbIJFox1gnLgVyJD4rOc9x9A3y0F3uZjZPy
         r53cYlzLPDtzZC66s4/YfFIkNnBQOd/rILPXucLX//9VBGiYLaoJjPWnyq/8N8qmFOTP
         XbAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M8prA5obJxgifJPaDY3q2ZbY2oPL4lc/Ba1aChiVrz8=;
        b=f8O8kwG4uyVaQxCOrEAlgYr4T90jrR2+ALUrd0w+V6Pt0xAgkhxaFcK5L79Lis3501
         loIPzZzgXrLIADbDRUGv7JR67ru8YMKvSVFA9u7YfleV0hq1D6RLFO8RGmrHaj2yCo0N
         97GCfKjSnUftwiIG+V2s60QZT09ACRf2a49KIsMyov2TSlnMNjx7OFJz/Kpy435GvERi
         H7BeJVrYEhK4tuuENUYheq4EyhGDVcawJGSlw5aCosvyjGl3rWcictYhHWRSijZ/WrMy
         TiJqAUdLU3i2l9NbcbhEt9OXEWZquy9nyzIHP8WacqcONhJKCi8mFOFU2LaBHXrQMnrr
         CBqQ==
X-Gm-Message-State: AOAM530zuAj5/tYi5QpZy7crlIvDxeI40kXi61Lf9JBDsfMgpv/UfhE+
        ij3FQZOz+X+I6YEgOFSLLJuW2G/qe7HcLQ==
X-Google-Smtp-Source: ABdhPJwAn/n5XHSRPy/ZG1fmhVZ0RN2Y+7lBFfAh4aI1vEWYneJgS6RuA/Ydm04OM1fWkBEV8hrBbg==
X-Received: by 2002:a63:5ec6:: with SMTP id s189mr4244951pgb.431.1630686092313;
        Fri, 03 Sep 2021 09:21:32 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id g6sm5976159pfb.143.2021.09.03.09.21.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Sep 2021 09:21:32 -0700 (PDT)
Date:   Fri, 3 Sep 2021 09:21:29 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Andy Walker <camtarn@camtarn.org>
Cc:     netdev@vger.kernel.org
Subject: Re: TBF man page: peakrate must be greater than rate
Message-ID: <20210903092129.3dda2d82@hermes.local>
In-Reply-To: <CAD6Lk=r8Yf8_09X31bcLECEKmy3gS5rKDKt+pVHfyNk2_NMHTA@mail.gmail.com>
References: <CAD6Lk=r=mCMPb3YyKHMKtLENteRPsGw2L4Axy5kdVvnd2j29Zw@mail.gmail.com>
        <CAD6Lk=r8Yf8_09X31bcLECEKmy3gS5rKDKt+pVHfyNk2_NMHTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 3 Sep 2021 16:48:45 +0100
Andy Walker <camtarn@camtarn.org> wrote:

> Hi,
> 
> I was struggling with the following command line:
> tc qdisc add dev eth1 parent 1:1 handle 10: tbf rate 10.0kbit maxburst
> 10kb latency 50ms peakrate 10kbit mtu 1600
> RTNETLINK answers: Invalid argument
> 
> When I altered peakrate to be 10.1kbit, tbf accepted its parameters.
> 
> Looking in dmesg, I found the following:
> 
> sch_tbf: peakrate 1250 is lower than or equals to rate 1250
> 
> The man page does not specify that peakrate needs to be greater than
> rate. This would probably be a useful addition, as it's easy to assume
> that the two can/should be set to the same value for precise rate
> limiting.
> 
> Thanks,
> Andy

The kernel should be reporting error message via netlink extack
but it isn't.  Anytime user has to look in dmesg to see an error
it is bad.

TBF is old and rarely modified code in the kernel. It looks like
it could use some attention.
