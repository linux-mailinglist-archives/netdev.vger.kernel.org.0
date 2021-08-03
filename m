Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE0B3DF6A5
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 22:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231576AbhHCUzN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 16:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231351AbhHCUzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 16:55:11 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDAC5C061757;
        Tue,  3 Aug 2021 13:54:58 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id l19so31377564pjz.0;
        Tue, 03 Aug 2021 13:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=fdylwn2n74tpR+dsWsjP/bwzBe3S+Rlc3LYTO8ZCWZQ=;
        b=l9fZdUew/MpTEpSojEPYEEdc0zxAo1HHixUWdhHlEHdpHIshPwparH7XWXlHbjxA8v
         ctM9OO/9FcF58W6HBtinH+ReHHdq/tezdhU43DpX+ZLTvYN6CgLQX+s4+EMW4gfmyu6e
         P5L8Ze81jYnAk8RTRFDGeK4U5hVStj5Hk81CwIcXSrlodmX5yovcsraCDplm7P7JPvJu
         wIyjL29bt0YZjebC+IBqi8Jq8zyjM0ylEmGk8dw2VKVdFbzC0VH2MljYGKPOZDYYB3UV
         8v9WAnF4bohNN0plE7xEDDhJ3jV5JYHmhfRBxTAko2o0Rf30SRG8VK3zcdd+ToLLZEdj
         Cy4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=fdylwn2n74tpR+dsWsjP/bwzBe3S+Rlc3LYTO8ZCWZQ=;
        b=FEb4A6Jx2M3JhTRt40qsXRCZXu99nuPFIN165SjYV6uFBKcXlsLHiWWQfHbgIdLOYB
         XpUFu/0R2+7BXx7lxCb0xnSzfuwsba0atnR/wjsk0IFibxaj1iAt07wn1aFXBhzyRFyF
         Q4KGh61FYb+EYnfE4YbMCBbrKpBIm7yjD0oAnTwwPVYXaGslt4o7FUupMhVz3wvJZN0y
         tKkFr4XlTIySHXBKL88Dsg9PgDjVVMWbME2OxNAtoVci74mxlpxETJPHFiqISz1+DwNC
         uq5zDjBqW6SRuuOvOMbBtl0h+BGFsWhrqfiy4SvVwLb5PyPyzHSYjeAj+42Fs4HLdOOJ
         5T4g==
X-Gm-Message-State: AOAM531v9xg1pacNtXvi0OeYpvtCPhKRsODP5DLbA3ZCgCOooF/H96XJ
        ilDeH0WeONECc8OvkLQGRKY=
X-Google-Smtp-Source: ABdhPJxZCrtJ77fz1VoQjBY8XsXtnDCHDlBHfVKDsk4VUlOLAdwdRZYStnj5wA7x0+s+7pI7ybJI+g==
X-Received: by 2002:aa7:8683:0:b029:3c4:877b:da34 with SMTP id d3-20020aa786830000b02903c4877bda34mr2764594pfo.69.1628024098477;
        Tue, 03 Aug 2021 13:54:58 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id h16sm80861pfn.215.2021.08.03.13.54.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 13:54:57 -0700 (PDT)
Date:   Tue, 3 Aug 2021 13:54:55 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Nicolas Pitre <nico@fluxnic.net>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2] ethernet/intel: fix PTP_1588_CLOCK
 dependencies
Message-ID: <20210803205455.GA3517@hoboy.vegasvil.org>
References: <20210802145937.1155571-1-arnd@kernel.org>
 <20210802164907.GA9832@hoboy.vegasvil.org>
 <bd631e36-1701-b120-a9b0-8825d14cc694@intel.com>
 <20210802230921.GA13623@hoboy.vegasvil.org>
 <CAK8P3a2XjgbEkYs6R7Q3RCZMV7v90gu_v82RVfFVs-VtUzw+_w@mail.gmail.com>
 <20210803155556.GD32663@hoboy.vegasvil.org>
 <20210803161434.GE32663@hoboy.vegasvil.org>
 <CAK8P3a2Wt9gnO4Ts_4Jw1+qpBj8HQc50jU2szjmR8MmZL9wrgQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a2Wt9gnO4Ts_4Jw1+qpBj8HQc50jU2szjmR8MmZL9wrgQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tue, Aug 03, 2021 at 07:00:49PM +0200, Arnd Bergmann wrote:

> If you turn all those 'select' lines into 'depends on', this will work, but it's
> not actually much different from what I'm suggesting.

"depends" instead of "select" works for me.  I just want it simple and clear.

> Maybe we can do it
> in two steps: first fix the build failure by replacing all the 'imply'
> statements
> with the correct dependencies, and then you send a patch on top that
> turns PPS and PTP_1588_CLOCK into bool options.

Sounds good.

Thanks,
Richard
