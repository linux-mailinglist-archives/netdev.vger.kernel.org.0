Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE48D5F7171
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 00:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231800AbiJFW5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 18:57:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbiJFW5C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 18:57:02 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D34ABB041
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 15:57:01 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id l1so2975816pld.13
        for <netdev@vger.kernel.org>; Thu, 06 Oct 2022 15:57:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kp9EksdjUFiehraYHlT2wY61pPbUo7iWAs3vpMObdeQ=;
        b=XR5uHRxljMNHdCOFrGOT96MJkBV6kJXp39kQS5F2FCTOI0oN94qmtXKmJIn1xR+c3B
         QCkWvSUxbfvaOOUKMT4ecHPUbBU3E8K6hF2xeZOjrgmPHzkgBbhqW+5Wkt9eWgbqM3rI
         Jcn96ThW2f3UuKOaHBESnKNdDfbrw22rBUUa4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Kp9EksdjUFiehraYHlT2wY61pPbUo7iWAs3vpMObdeQ=;
        b=noeCGfIjeCnN4HNmu+49vyI60Q3bMktEtosJ9JKY5vdhGlahw8PMy7R/KmQF/yBJHX
         giH9MtVVK936PtM7Y+BMHz+HVHwGwmeyD9+81zcuvrzBHBg93069tfbv3iwx/pRrPmHJ
         SrZrpJ0Tb/UV6IqP69Dg3MH6yhX0pJYfSpwvEIQB168AKhJZOfC4ckhVQe+Mwmw+HG7w
         nIuxYpg+aduskLZ/2HoyNbdusO9A70veOKVtMdJqCDIwvGiiFBMEspNkPEWr3UoiZB7i
         qc5TmytUcjwZYb/m+9CJb/GTd+4+4pN3lWX/lTSv5GB/TotVJvxidNHdW9jPrZUXuDQL
         CjiQ==
X-Gm-Message-State: ACrzQf1JjEzAw7DkylcKvMgHIkOdR/MGEdZkKVBJwc5eHfxiApcjNZs4
        A2Vzpq7cdwUse8rRYtsaftGwnw==
X-Google-Smtp-Source: AMsMyM5MvDAQFjgHsn3cAQSd41PrvLMCqXkqMO7wbqDOCzU4xe5dSkr1FJr8Ne6af2pL1VNV45nJRg==
X-Received: by 2002:a17:90a:1c1:b0:20a:e745:bc30 with SMTP id 1-20020a17090a01c100b0020ae745bc30mr13073506pjd.131.1665097020759;
        Thu, 06 Oct 2022 15:57:00 -0700 (PDT)
Received: from fastly.com (c-24-6-151-244.hsd1.ca.comcast.net. [24.6.151.244])
        by smtp.gmail.com with ESMTPSA id oc7-20020a17090b1c0700b0020b21019086sm1089526pjb.3.2022.10.06.15.56.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Oct 2022 15:57:00 -0700 (PDT)
Date:   Thu, 6 Oct 2022 15:56:57 -0700
From:   Joe Damato <jdamato@fastly.com>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, anthony.l.nguyen@intel.com
Subject: Re: [next-queue v2 2/4] i40e: Record number TXes cleaned during NAPI
Message-ID: <20221006225656.GA86976@fastly.com>
References: <1665004913-25656-1-git-send-email-jdamato@fastly.com>
 <1665004913-25656-3-git-send-email-jdamato@fastly.com>
 <0cdcc8ee-e28d-f3cc-a65a-6c54ee7ee03e@intel.com>
 <20221006003104.GA30279@fastly.com>
 <20221006010024.GA31170@fastly.com>
 <Yz7SHod/GPxKWmvw@boxer>
 <481f7799-0f1c-efa3-bf2c-e22961e5f376@intel.com>
 <20221006173248.GA51751@fastly.com>
 <3e78ef0a-db8a-0380-0a7a-ca8571513355@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e78ef0a-db8a-0380-0a7a-ca8571513355@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 06, 2022 at 03:35:36PM -0700, Jesse Brandeburg wrote:
> On 10/6/2022 10:32 AM, Joe Damato wrote:
> >Sorry, but I don't see the value in the second param. NAPI decides what to
> >do based on nb_pkts. That's the only parameter that matters for the purpose
> >of NAPI going into poll mode or not, right?
> >
> >If so: I don't see any reason why a second parameter is necessary.
> 
> Sridhar and I talked about this offline. We agree now that you can just
> proceed with the single parameter.

OK, thanks.

> >
> >As I mentioned earlier: if it's just that the name of the parameter isn't
> >right (e.g., you want it to be 'tx_processed' instead of 'tx_cleaned') then
> >that's an easy fix; I'll just change the name.
> 
> I think the name change isn't necessary, since we're not going to extend
> this patch with full XDP events printed (see below)
> 
> >
> >It doesn't seem helpful to have xsk_frames as an out parameter for
> >i40e_napi_poll tracepoint; that value is not used to determine anything
> >about i40e's NAPI.
> >
> >>I am not completely clear on the reasoning behind setting clean_complete
> >>based on number of packets transmitted in case of XDP.
> >>>
> >>>>That might reduce the complexity a bit, and will probably still be pretty
> >>>>useful for people tuning their non-XDP workloads.
> >>
> >>This option is fine too.
> >
> >I'll give Jesse a chance to weigh in before I proceed with spinning a v3.
> 
> I'm ok with the patch you have now, that shows nb_pkts because it's the
> input to the polling decision. We can add the detail about XDP transmits
> cleaned in a later series or patch that is by someone who wants the XDP
> details in the napi poll context.

Thanks for the detailed and thoughtful feedback, it is much appreciated.

I'll leave this patch the way it is then and tweak the RX patch to include
an rx_clean_complete boolean as I mentioned in my response to that patch
and send out a v3.

FWIW, I had assumed that you would suggest dropping the XDP stuff so I
pre-emptively spun a branch locally that dropped it... it is a much smaller
change of course, but I suspect that this tracepoint might useful for XDP
users, so I think the decision to leave it with nb_pkts makes sense.

Thanks again for the review. I'll send a v3 shortly.
