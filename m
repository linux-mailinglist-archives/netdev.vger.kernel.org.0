Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C5024E9E1D
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 19:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244775AbiC1Rxi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 13:53:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244795AbiC1Rxf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 13:53:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2655359A41;
        Mon, 28 Mar 2022 10:51:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D0884B811A1;
        Mon, 28 Mar 2022 17:51:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24379C004DD;
        Mon, 28 Mar 2022 17:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648489910;
        bh=DWQyFizvX5sbX4m+SuMr+oxJyqApObYm578W79HPAoA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DDnO5fO8JyNVHKzP7WEXuKZG4DVN1sBlBlZwFOGPANJY+3+8NijmGPyNkD8Hagnh0
         bglhcK9ilnZrBYyMJ/m8jj+N+fftuVDMqLAt6T7MGkOET4P4rZ5Pc3FvRk5mW5RroL
         L/3PM7T2UiUMtBNf2iRz8+uj1QmvoG5AqzeRB4FWHAf8VhTc4xdTefVeNcXyQt2MNe
         TrWWofxwFxMJR2qGgPd8qHDgDx7t4mncGNFvVRK0fgvx7ks/t6YyDtieyYDhcdNobw
         +2Gej+RYDgP42O8GBKLBuqzkz9B1NBYhjRkABc1IAq2nwRT1u0/TS3XkCpL9NWYSKm
         EWU0TXA7cSWHQ==
Date:   Mon, 28 Mar 2022 10:51:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com,
        corbet@lwn.net, bpf@vger.kernel.org, linux-doc@vger.kernel.org,
        f.fainelli@gmail.com
Subject: Re: [PATCH net 09/13] docs: netdev: make the testing requirement
 more stringent
Message-ID: <20220328105148.21935ca2@kernel.org>
In-Reply-To: <YkCUEwZI0jUmamPg@lunn.ch>
References: <20220327025400.2481365-1-kuba@kernel.org>
        <20220327025400.2481365-10-kuba@kernel.org>
        <YkCUEwZI0jUmamPg@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 27 Mar 2022 18:42:59 +0200 Andrew Lunn wrote:
> >  What level of testing is expected before I submit my change?
> >  ------------------------------------------------------------
> > -If your changes are against ``net-next``, the expectation is that you
> > -have tested by layering your changes on top of ``net-next``.  Ideally
> > -you will have done run-time testing specific to your change, but at a
> > -minimum, your changes should survive an ``allyesconfig`` and an
> > -``allmodconfig`` build without new warnings or failures.
> > +At the very minimum your changes must survive an ``allyesconfig`` and an
> > +``allmodconfig`` build with ``W=1`` set without new warnings or failures.  
> 
> Doesn't the patchwork buildbot also have C=1 ? You have been pointing
> out failures for C=1, so it probably should be documented here.

We have a number of cases where C=1 failures are false positives. 
Sparse is not getting much love these days, unfortunately.
I didn't want to force people to bend over backwards to fix stuff
we can let fly upstream. I can't think of a case where W=1 was okay.
