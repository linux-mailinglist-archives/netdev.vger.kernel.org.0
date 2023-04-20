Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A65D56E96DF
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 16:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231467AbjDTOTD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 10:19:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231997AbjDTOSn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 10:18:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B088C5FC2
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 07:18:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF3C5649C8
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 14:17:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC9B6C433D2;
        Thu, 20 Apr 2023 14:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682000250;
        bh=ZWiTIDIsPxCC0uY61jFYQgKbXgCnNpbWsa7BZQ56V5c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OAMHu/BFgNQ9+p/TsC8iKSECyJjO997+x8Lx+C/blNPsrpLPQhWYAQicfR7nYt6B8
         cJhdbKV0CQ4OIOuX/n3I+UC/p7Mt1jehGX0W/Zp4+gWTsPEZNaWeofJzbQUfJzt5q8
         KHkBpaJoRqF+BmHoWiAp1OdWItsUmYvsa/wy+0VMA9SToSTqK+EaD9V39UITrpQnWE
         6MSJ887+jfaYj8jRDACsAMOWSDKmiJ1LIl3CSFv+/f7TB3ujZp6+wKaIJt14HPEMnV
         vDYbYgufKcvhnBzy7yJ2Ka9STDD0ZAwKl1QyyDWVJgT1he7QOmXZZEJIyxjfQKHLVz
         xLh1dwq4zTOmg==
Date:   Thu, 20 Apr 2023 07:17:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com
Subject: Re: [PATCH net-next v2 1/4] net/sched: sch_htb: use extack on
 errors messages
Message-ID: <20230420071728.42258044@kernel.org>
In-Reply-To: <d45983a3-6884-d8e9-499e-c9e71c4685d5@mojatatu.com>
References: <20230417171218.333567-1-pctammela@mojatatu.com>
        <20230417171218.333567-2-pctammela@mojatatu.com>
        <20230419180832.3f0b7729@kernel.org>
        <d45983a3-6884-d8e9-499e-c9e71c4685d5@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Apr 2023 23:14:54 -0300 Pedro Tammela wrote:
> > I missed the message changes on v1, but since the patches are already
> > Changes Requested in patchwork...
> > 
> > IDK what TC_HTB_LEAF_TO_INNER is exactly, neither do I understand
> > "Failed to offload leaf to inner". The first one should be "Failed to
> > alloc offload leaf queue" if anything.
> > 
> > Let's just stick to the existing messages?  
> 
> The existing messages omit that the offload operation failed, which I 
> think it would be important to say in these two cases.
> But taking a second look, the driver gets the extack so it should be up 
> to the driver to provide the appropriate context when the offload fails. 
> What do you think about demoting these messages to WEAK and change them 
> to something like:
> "Failed to offload %attribute"

Good idea!
