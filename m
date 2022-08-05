Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C70AB58B00B
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 20:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240876AbiHESvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 14:51:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237936AbiHESvL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 14:51:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE2F1183AD
        for <netdev@vger.kernel.org>; Fri,  5 Aug 2022 11:51:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2543761953
        for <netdev@vger.kernel.org>; Fri,  5 Aug 2022 18:51:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A6C1C433D7;
        Fri,  5 Aug 2022 18:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659725469;
        bh=Pwkzd5icci7kGds+sRnMe6ruYSR2qW+q/gmJgfiUv18=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DFgjsxDECS/9S8XiyD9uISJpYOFTpr5pOFjhG/hMkxCOj/dsct+2NgNN4xUZmwR3X
         Pdm9WERnMTT8BIg0w3CgrzPrvgFNnSNOB1bQ9Q7OWgR80VlHGTY14jcnPTwhFhc5Bx
         WR7ryGoaKpnrHZaD1VXAQdsjR89WQujIEbOVIZp/sHNlpfTTn0bQ4vYrRrI1N2FeWP
         AtKtGxWhM+6FsOYytiXO/tr4FIX7OhGZSEUpAe9A7aLHtCyKOEPQq+JfmXR+k4YEOa
         yOvXlQSMJQjmNUf5BYW3QzmxFGntn3figRmB9baw4eiRb/aP8tmKXOxvo8fiQc+l+R
         Y5STzXfcz1gzA==
Date:   Fri, 5 Aug 2022 11:51:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [net-next PATCH 1/2] devlink: add dry run attribute to flash
 update
Message-ID: <20220805115108.16149c01@kernel.org>
In-Reply-To: <CO1PR11MB508953EAEE7A719D2F9BF9F5D69E9@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20220720183433.2070122-1-jacob.e.keller@intel.com>
        <20220720183433.2070122-2-jacob.e.keller@intel.com>
        <YtjqJjIceW+fProb@nanopsycho>
        <SA2PR11MB51001777DC391C7E2626E84AD6919@SA2PR11MB5100.namprd11.prod.outlook.com>
        <YtpBR2ZnR2ieOg5E@nanopsycho>
        <CO1PR11MB508957F06BB96DD765A7580FD6909@CO1PR11MB5089.namprd11.prod.outlook.com>
        <YtwW4aMU96JSXIPw@nanopsycho>
        <SA2PR11MB5100E125B66263046B322DC1D6959@SA2PR11MB5100.namprd11.prod.outlook.com>
        <20220725123917.78863f79@kernel.org>
        <SA2PR11MB5100005E9FEB757A6364C2CFD6959@SA2PR11MB5100.namprd11.prod.outlook.com>
        <20220725133246.251e51b9@kernel.org>
        <SA2PR11MB510047D98AFFDEE572B375E0D6959@SA2PR11MB5100.namprd11.prod.outlook.com>
        <20220725181331.2603bd26@kernel.org>
        <CO1PR11MB508953EAEE7A719D2F9BF9F5D69E9@CO1PR11MB5089.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 5 Aug 2022 16:32:30 +0000 Keller, Jacob E wrote:
> > Hm, yes. Don't invest too much effort into rendering per-cmd policies
> > right now, tho. I've started working on putting the parsing policies
> > in YAML last Friday. This way we can auto-gen the policy for the kernel
> > and user space can auto-gen the parser/nl TLV writer. Long story short
> > we can kill two birds with one stone if you hold off until I have the
> > format ironed out. For now maybe just fork the policies into two -
> > with and without dry run attr. We'll improve the granularity later
> > when doing the YAML conversion.  
> 
> Any update on this?
> 
> FWIW I started looking at iproute2 code to dump policy and check
> whether a specific attribute is accepted by the kernel.

Yes and no, I coded a little bit of it up, coincidentally I have a YAML
policy for genetlink policy querying if that's helpful:

https://git.kernel.org/pub/scm/linux/kernel/git/kuba/linux.git/tree/tools/net/ynl/samples/nlctrl.c?h=gnl-gen-dpll

I'll try to wrap up the YAML format by today / tomorrow and send an
early RFC, but the codegen part (and everything else really) still
requires much work. Probably another month until I can post the first
non-RFC with error checking, kernel policy generation, uAPI generation
etc.
