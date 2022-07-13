Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34B63573D5A
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 21:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231817AbiGMTtj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 15:49:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230331AbiGMTti (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 15:49:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8A7026565
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 12:49:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5A7B7B82124
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 19:49:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA1FBC34114;
        Wed, 13 Jul 2022 19:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657741772;
        bh=68X9sHyEXu+W4MMXZ84ftqEVn/u1UgOgMuQdVpaxByQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kIDg/Acvyj0qDALmZhwX3Zoehl8AbRGYlmSZRn9KPLCXmsShr86040VgcI7GkkxxN
         B7C0SNn0EpyuVN/SOTnZvrgMXFREZDYCGGtQTeJUKXPWxAz2GW0gRgfBqsA3YN2Vyw
         OabcrXvt1PnhSyhpqgMFmIw2iH6a0OP82mclX/MHwKHZFMrnF+fy1cgrOn2nvJWWRZ
         myQHSoseONF1AiWCL47E9spp2oBtOjl/QQQxtQ1o0hbWX/rVgEhMEdEkeQB5TMI1hE
         Bx/ZvF5ZmDs6YkPmiBIJF4+b5VkOO9cLyP9J3YsaHwGlFTn6aFvw+LcAaWHujX/Mfp
         PYqEvo3bAfx7Q==
Date:   Wed, 13 Jul 2022 12:49:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        Alan Brady <alan.brady@intel.com>, netdev@vger.kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        Gurucharan <gurucharanx.g@intel.com>
Subject: Re: [PATCH net-next 1/1] ping: fix ipv6 ping socket flow labels
Message-ID: <20220713124930.6d58af50@kernel.org>
In-Reply-To: <20220712165608.32790-1-anthony.l.nguyen@intel.com>
References: <20220712165608.32790-1-anthony.l.nguyen@intel.com>
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

On Tue, 12 Jul 2022 09:56:08 -0700 Tony Nguyen wrote:
> From: Alan Brady <alan.brady@intel.com>
> 
> Ping sockets don't appear to make any attempt to preserve flow labels
> created and set by userspace. Instead they are always clobbered by
> autolabels (if enabled) or zero.
> 
> This grabs the flowlabel out of the msghdr similar to how rawv6_sendmsg
> does it and moves the memset up so we don't zero it.
> 
> Signed-off-by: Alan Brady <alan.brady@intel.com>
> Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>

Thanks! Please add a selftest and s/fix/support/ in the subject
otherwise  the stable ML bot will think this is a fix, and its more 
of a missing feature.
