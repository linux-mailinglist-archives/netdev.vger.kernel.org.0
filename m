Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD8E8651591
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 23:31:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231931AbiLSWbY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 17:31:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbiLSWbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 17:31:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66923615F
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 14:31:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0251560FEC
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 22:31:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40CA9C433EF;
        Mon, 19 Dec 2022 22:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671489081;
        bh=pOpxX7FLuzBZfdC0eNuj9vtA79Jn/dzwTDyHYPWqo1A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=U09nbBCgLLTkLGbtKsp3UMg5vQpr2JO4XJKrXzergciwi4HrpifYMLqiY6XrJ3T4o
         NT15f6jSdo4eBqQRPAQhJnxgrhsofmRPw5x7wLj8sqbdeUSo/8PchmOK3zm6NUb+cs
         lH91meH9lM6LOSbtJrRjX3wAY+iei4uHKb2o1W08WSdzK+Dp2873S30TIO5OXoDacr
         mt2xbmkh1V8DbLy0BON5kPbCJ5XOA/GqsQ5mlrd3bKVobg3/kmT9GyLZ55X+zzHeeM
         dr/XbQQ57bPv1hH34BJuK8rp1t5ZMVlQFMW0ggQvbx1q7fCAL2fbRR959A+vl4I1Uh
         F+lBsF9SHViXg==
Date:   Mon, 19 Dec 2022 14:31:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     <jiri@resnulli.us>, <leon@kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [RFC net-next 05/10] devlink: remove the registration guarantee
 of references
Message-ID: <20221219143120.6249715e@kernel.org>
In-Reply-To: <1aa72500-79cd-810e-947c-172bbc4db513@intel.com>
References: <20221217011953.152487-1-kuba@kernel.org>
        <20221217011953.152487-6-kuba@kernel.org>
        <ac6f8ab5-3838-4686-fc20-b98b196f82c8@intel.com>
        <20221219140210.241146ea@kernel.org>
        <1aa72500-79cd-810e-947c-172bbc4db513@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Dec 2022 14:14:18 -0800 Jacob Keller wrote:
> On 12/19/2022 2:02 PM, Jakub Kicinski wrote:
> > I was wondering if anyone would notice :)
> 
> I'm fine with it, but I would expect that devlink_register would want to
> report it at least?

New code should not use devlink_* functions, so probably not worth it.

> > Returning errors from the registration helper seems natural,
> > and if we don't have this ability it may impact our ability
> > to extend the core in the long run.
> > I was against making core functions void in the first place.
> > It's a good opportunity to change back.  
> 
> Sure. I think its better to be able to report an error but wanted to
> make sure its actually caught or at least logged if it occurs.
> 
> We can ofcourse change the function templates again since we don't
> really guarantee API stability across versions, but it is more work for
> backporting in the future.

