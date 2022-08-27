Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9376F5A3349
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 03:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231738AbiH0BBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 21:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231181AbiH0BBj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 21:01:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A00D41AF14
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 18:01:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 629F9B8334C
        for <netdev@vger.kernel.org>; Sat, 27 Aug 2022 01:01:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41CD4C43470;
        Sat, 27 Aug 2022 01:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661562096;
        bh=t8uJtVYGVJrGtCLnX/H7b8u7UYthosyQkxfbjmbRSTY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fOrsCGHE6DeI7Q1LkvEeK5VxiWNF103FkLlU4Lz0cUKkOnBfvmRQmqX7FP05r9Eni
         fYKJCf+VHsn14T0BGzPraU2rs0pVSdHZwB0W9OvV+ALXUfd/bwO/pksHcnNN/aaH9K
         INR8iXe8Jn6Hi55Y3VuFIAWrU3e5Y9a/X5WtG8jJwNnrj6OtyFmTRTnwr64yakiksC
         X6lJdYWoU2kp8Ypg5ID88G0fu4j+4WR1KzaZL6cPDP223pVHEDijS4YdxVDWagtqtl
         UHv1lczMAKEjigEKYMvLsHwo7Ng4633V3suGzMAlKqVGXO6blEkYibSXPdOzQebhYC
         djZdmCHN/ZeYQ==
Date:   Fri, 26 Aug 2022 18:01:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     "Drewek, Wojciech" <wojciech.drewek@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "marcin.szycik@linux.intel.com" <marcin.szycik@linux.intel.com>,
        "michal.swiatkowski@linux.intel.com" 
        <michal.swiatkowski@linux.intel.com>,
        "kurt@linutronix.de" <kurt@linutronix.de>,
        "boris.sukholitko@broadcom.com" <boris.sukholitko@broadcom.com>,
        "vladbu@nvidia.com" <vladbu@nvidia.com>,
        "komachi.yoshiki@gmail.com" <komachi.yoshiki@gmail.com>,
        "paulb@nvidia.com" <paulb@nvidia.com>,
        "baowen.zheng@corigine.com" <baowen.zheng@corigine.com>,
        "louis.peens@corigine.com" <louis.peens@corigine.com>,
        "simon.horman@corigine.com" <simon.horman@corigine.com>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "maksym.glubokiy@plvision.eu" <maksym.glubokiy@plvision.eu>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "jchapman@katalix.com" <jchapman@katalix.com>,
        "gnault@redhat.com" <gnault@redhat.com>
Subject: Re: [RFC PATCH net-next 0/5] ice: L2TPv3 offload support
Message-ID: <20220826180134.24b3648a@kernel.org>
In-Reply-To: <YwjZ+h82UrF2MrxO@nanopsycho>
References: <20220826110059.119927-1-wojciech.drewek@intel.com>
        <YwircDhHhOfqdHy/@nanopsycho>
        <MW4PR11MB5776E6C92351788A0E55B6CBFD759@MW4PR11MB5776.namprd11.prod.outlook.com>
        <YwjZ+h82UrF2MrxO@nanopsycho>
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

On Fri, 26 Aug 2022 16:34:34 +0200 Jiri Pirko wrote:
> >Sorry, I'll include more precise description in the next version.
> >DDP (Dynamic Device Personalization) is a firmware package that contains definitions
> >protocol's headers and packets. It allows you  to add support for the new protocol to the
> >NIC card without rebooting.  If the DDP package does not support L2TPv3 then hw offload 
> >will not work, however sw offload will still work.  
> 
> Hmm, so it is some FW part? Why do we care about it here in patchset
> description?

We generally encourage people to put as much context in the commit
messages and cover letters as possible. Nothing wrong with saying
that a specific parser microcode is needed, IMHO.
