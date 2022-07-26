Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3842B5819F1
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 20:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239659AbiGZSsu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 14:48:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239041AbiGZSss (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 14:48:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DD453343B
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 11:48:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE6A7B8113E
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 18:48:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 923F9C433C1;
        Tue, 26 Jul 2022 18:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658861325;
        bh=dC1Y+XI3iyaYw57J+na6OIcuNU9FRVa51Bf1F2HmiW4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=q1hBA3thAsQHUH/f5CQ4PCt0GfovFfN79U6hdXrvowPD85vXwPfIZm11zQS5sMMdq
         WxPAjz5xSEE7e9VqoHnZzGEfEuQN0UKXDPxoGWYq3ef0y870bMCFyjp+Fb2GF7BW01
         KIg75t8A4BlW6KmoqFnWNszZPde/XKnAGkD0c434iXerkpeGbbwJEZAh2JaIwckA9D
         S7/Mw9MVPXFCPuwUJ7/w0x2uuopEJ430K+Zj9DEzMc748qp36WTepaNWfuqGA4nRvj
         Mix1KNMHgfJOIsakMafle2UMFpzfljaosALA2XI9nl0PAMu714Niawl/EUZbR1UfPU
         Fno7O0HYGYuxg==
Date:   Tue, 26 Jul 2022 11:48:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [net-next PATCH 1/2] devlink: add dry run attribute to flash
 update
Message-ID: <20220726114844.25183a99@kernel.org>
In-Reply-To: <SA2PR11MB5100E4F6642CCF2CD44773A4D6949@SA2PR11MB5100.namprd11.prod.outlook.com>
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
        <SA2PR11MB5100E4F6642CCF2CD44773A4D6949@SA2PR11MB5100.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Jul 2022 17:23:53 +0000 Keller, Jacob E wrote:
> > For now maybe just fork the policies into two -
> > with and without dry run attr. We'll improve the granularity later
> > when doing the YAML conversion.  
> 
> Not quite sure I follow this. I guess just add a separate policy
> array with dry_run and then make that the policy for the flash update
> command? I don't think flash update is strict yet, and I'm not sure
> what the impact of changing it to strict is in terms of backwards
> compatibility with the interface.

Strictness is a separate issue, the policy split addresses just 
the support discoverability question.
