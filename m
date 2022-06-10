Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EED5545BFA
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 07:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346349AbiFJF7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 01:59:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346338AbiFJF7j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 01:59:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56E0D3AA42
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 22:59:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E7A7361E97
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 05:59:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04FF6C34114;
        Fri, 10 Jun 2022 05:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654840777;
        bh=YbfypFmuQC43lxzwogq0gMu+VD4tHkQZ1HN6nIGwKSE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dGjJhV9hDJ4aXc9i5SuX6yhdIsHcmUbFrm+evjsLkgZp4UcK7EV800PYqUxdTJhGs
         jwi0je8NiTe1BjSd6+//fKCdIDFfoMypPPFBLs/wXl/HsSOixAPM5HibV3Ewl8DcEp
         x64UYhirXJ/gYGRk8gVA5hdjEhkVAsTTDT99IIqmSfIk9rj0DoE5tFpbl7p9W/Xmtk
         Evc0voIl9GG6rlKS57ceUDqVVNh0AuGmFv2oUV03eUuaqe3+kJIBEvRm0CtZauZwtk
         mm9VSqlisJ69lQT+abTc2jC/pwf1GpDBb7shjIAsZ0c9XxAJTQFV3Rzh4V1o4f2Ojb
         26ZqPyiroBUtw==
Date:   Thu, 9 Jun 2022 22:59:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, Ossama Othman <ossama.othman@intel.com>,
        davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev
Subject: Re: [PATCH net-next 1/2] mptcp: fix conflict with <netinet/in.h>
Message-ID: <20220609225936.4cba4860@kernel.org>
In-Reply-To: <20220608191919.327705-2-mathew.j.martineau@linux.intel.com>
References: <20220608191919.327705-1-mathew.j.martineau@linux.intel.com>
        <20220608191919.327705-2-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  8 Jun 2022 12:19:18 -0700 Mat Martineau wrote:
> From: Ossama Othman <ossama.othman@intel.com>
> 
> Including <linux/mptcp.h> before the C library <netinet/in.h> header
> causes symbol redefinition errors at compile-time due to duplicate
> declarations and definitions in the <linux/in.h> header included by
> <linux/mptcp.h>.
> 
> Explicitly include <netinet/in.h> before <linux/in.h> in
> <linux/mptcp.h> when __KERNEL__ is not defined so that the C library
> compatibility logic in <linux/libc-compat.h> is enabled when including
> <linux/mptcp.h> in user space code.
> 
> Fixes: c11c5906bc0a ("mptcp: add MPTCP_SUBFLOW_ADDRS getsockopt support")

What does it break, tho? The commit under Fixes is in net, if it's
really a fix it needs to go to net. If it's just prep for another
change we don't need to fixes tag.
