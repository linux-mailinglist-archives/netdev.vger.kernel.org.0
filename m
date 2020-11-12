Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8435C2B09A2
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 17:13:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728701AbgKLQNK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 11:13:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728233AbgKLQNK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 11:13:10 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C238C0613D1
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 08:13:10 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id a18so4967369pfl.3
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 08:13:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=92txTY+sQLiIPy5s8ibLbhDy+/gFwXaDoJ2fu1Ityis=;
        b=CdOmQcKrGimqjFIFOSbux3oD12SM4ZOrOVn5jxddtC7rI1WMsCZogWV2AZw3OZWEAc
         HO3cFAUfRK6dnEWbp1wFczz1ugAG7J/NTCsNLf1Wblneyyo1h4NRBOWag+nHFFkE3LRo
         qCV2Nnqm6zi2o52xLC37zUfdg1t1RaOcUAQSXCEMNaEk/azz13EJyAcdDyiil84jGgHm
         ToPiMRPUd7MuMqkCxXnM4b4cIlRDY3sGfvCh/nqmEoXYd0KBJFNSO1Rgp8wx7/NKDQZe
         agK7DrVhNBlbjraZV2QLsTUGaJXZOK4Y6hefSd9VCz1M8u8C77VjlIXqpLSrU59sQ3L6
         u9Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=92txTY+sQLiIPy5s8ibLbhDy+/gFwXaDoJ2fu1Ityis=;
        b=J1LrW525aH92/ikzBlVHKNAThekXMk/k+8gH2EF7hV/rhM8/nPyiSrYknl5oOVgCYc
         7y+GD/9FMJZ/SAnC2RsriYvQvZfkV+xG5R+g+TgdW6fRssPgM/G01HBItYmmZt62Gr5O
         SbxA2XeMgO7gi8c65U4i9aBHwa+WqfBjoM/xq7YYDTEPeoAC2LPMRwrtRAVHSxvY/B7M
         FrvfpBaNvyHrn8hxOGeazAc+F1uZJobzLT3moO2qESMCqa5oe+ZvsbiZMmMY7GjbjSKL
         mhXUMcImTjkxMsqfUxeSLIPY0lDk5k6k2lp0l0aLwYBxFlHAU7rRYKqumHmelCo1jP01
         Ccug==
X-Gm-Message-State: AOAM531VqPkfyR1Rg0pWakzEgPEmF3Tn/NmI5+lqPvjYVQ9eEbeChfA/
        S6ondJl/rU313akOA8ptGuvnIe4w2smqjrzD
X-Google-Smtp-Source: ABdhPJzbTBdn0+XYeQ9hN/mbMMrfeN01uDShjF8afZKJxV2ezJdNdUh0ncyyTYSct6HeE4s0/TWDLw==
X-Received: by 2002:a17:90a:5b15:: with SMTP id o21mr9935496pji.45.1605197590042;
        Thu, 12 Nov 2020 08:13:10 -0800 (PST)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id b21sm3990027pjo.43.2020.11.12.08.13.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 08:13:09 -0800 (PST)
Date:   Thu, 12 Nov 2020 08:13:06 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Russell Strong <russell@strong.id.au>
Cc:     netdev@vger.kernel.org
Subject: Re: IPv4 TOS vs DSCP
Message-ID: <20201112081306.0496a95b@hermes.local>
In-Reply-To: <20201112100954.62d696b6@192-168-1-16.tpgi.com.au>
References: <20201112100954.62d696b6@192-168-1-16.tpgi.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Nov 2020 10:09:54 +1000
Russell Strong <russell@strong.id.au> wrote:

> Hello,
> 
> After needing to do policy based routing based on DSCP, I discovered
> that IPv4 does not support this.  It does support TOS, but this has
> never been upgraded to the new ( now quite old ) DSCP interpretation.
> 
> Is there a historical reason why the interpretation has not changed?
> 
> I could copy the dscp into a fwmark and then use that, but that seems a
> little unnecessarily complicated.  If I were to change this, what would
> be the objections?
> 
> Russell

Probably a couple of reasons: no one needed it badly enough to work on it.
And more importantly any change would have to retain the legacy behavior
as the default.
