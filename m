Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BCDD60E57B
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 18:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233460AbiJZQbO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 12:31:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233532AbiJZQbG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 12:31:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ADCFD7E3A
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 09:31:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0CA44B82374
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 16:31:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 672E3C433D6;
        Wed, 26 Oct 2022 16:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666801862;
        bh=JSCGOildsUysEPjudtCjZL3brmtUTisY57vERoEarko=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kVVCXJU2U1sqr5kGx2QZFepUfX1ZFcRuOV3UJ1zr2OIVnFB6UDS/YsJ+c/A9AarJn
         ON+qtdsQi5nqhbNfhceh05tVCOch6wH9GjxWsBQPRdSzy+NwrIvaGkI6qZSowiMFIS
         0o5mon77QZHt+R3CYQPvti+aFmVsJ1A51mJ4uo/8QuIQ4xlhD6XdyxRJY079e/ZqsP
         BS6zSferiseUguctLmXAAwKsmn+ryuX8ysyJx04tgUtr+KJQ/7hSvK39iJ1/EFh8I2
         vd9G6B1PdaQYNrdt9NZkF0ozBRTYNkjIfEWXVoftFO77ZY7W2uYlJsSlWn0qR5HTZH
         RTGSUpC+XQtgw==
Date:   Wed, 26 Oct 2022 09:31:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <shnelson@amd.com>
Cc:     Shannon Nelson <snelson@pensando.io>, davem@davemloft.net,
        netdev@vger.kernel.org, leon@kernel.org, drivers@pensando.io
Subject: Re: [PATCH v2 net-next 3/5] ionic: new ionic device identity level
 and VF start control
Message-ID: <20221026093101.67fe65ed@kernel.org>
In-Reply-To: <2b469008-4057-cbe0-8640-73d42490f65e@amd.com>
References: <20221025112426.8954-1-snelson@pensando.io>
        <20221025112426.8954-4-snelson@pensando.io>
        <20221025200811.553f5ab4@kernel.org>
        <2b469008-4057-cbe0-8640-73d42490f65e@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Oct 2022 21:23:53 -0700 Shannon Nelson wrote:
> These additions are matching the style that is already in the file, 
> which I think has some merit.  Sure, I'll fix these specific kdoc 
> complaints, but those few bits are going to look weirdly out-of-place 
> with the rest of the file.

Gotta start somewhere...

> I see that kdoc is unhappy with that whole file, but I wasn't prepared 
> today to be tweaking the rest of the file to make kdoc happy.  That is 
> now on my list of near-future To-Do items.

Yeah, no need to do a whole-sale fix in this series, let's just prevent
new problems from coming in.

> Just curious - when was the kdoc check added to the netdev submission 
> checks?  Have I just been missing it in the past?

I was wondering as well, our check is pretty old, perhaps the behavior
of ./scripts/kernel-doc changed or we just weren't as strict in
enforcing this as maintainers?  Kdoc mis-formatting happens
sufficiently infrequently to make enforcing "no new warnings" feasible.
I think mostly due to W=1 catching the issues in source files,
so people notice right away. Unfortunately it doesn't check headers.
