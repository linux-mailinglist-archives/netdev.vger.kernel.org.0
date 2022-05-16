Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D361528FC5
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 22:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346889AbiEPUaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 16:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347707AbiEPU3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 16:29:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98E60101ED
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 13:13:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51FC5B81610
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 20:13:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97104C3411A;
        Mon, 16 May 2022 20:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652732028;
        bh=k/Cm/E4xWEUeNGgA2/1xf97UCGr4/HBsqqLaIesDpf8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=La/Prt5pq9zOhf9Aj0P8v7avGc51ESLbFSPxxj2esFMpg52hCJ4LjWknOQJMgemjj
         b1yky1VMtgkn+tQPh2L+4FuUhGghFOLnxSmIR8Je8vhWYmJkrzezxdKWI6u1KAVgQn
         Ojoev5Omc8Z0zPcy2IW8kKL90WlRR0vGF8Hh7aYj8UhB1uYeCU0YPfiOscuJir5lP+
         xk9qJ/8jKIkwcRbbW70/XS2/7FvGnYLymkeT4mDq3kqZuAmw7HDyoFzU/HHB9B1BZY
         NjS48LCzDjzy9FcfgwtrFk3SQK7NmBah89tO/EEGANcPBXzJFcEwkL0RIZRaVTGWAK
         0Kw39OaF9NvkQ==
Date:   Mon, 16 May 2022 13:13:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, Geliang Tang <geliang.tang@suse.com>,
        davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev
Subject: Re: [PATCH net-next 1/3] selftests: mptcp: fix a mp_fail test
 warning
Message-ID: <20220516131346.1f1f95d9@kernel.org>
In-Reply-To: <20220514002115.725976-2-mathew.j.martineau@linux.intel.com>
References: <20220514002115.725976-1-mathew.j.martineau@linux.intel.com>
        <20220514002115.725976-2-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 May 2022 17:21:13 -0700 Mat Martineau wrote:
>  	tc -n $ns2 -j -s action show action pedit index 100 | \
> +		grep "packets" | \
>  		sed 's/.*"packets":\([0-9]\+\),.*/\1/'

sed can do the grepping for you:

sed -n 's/.*"packets":\([0-9]\+\),.*/\1/p'

But really grepping JSON output seems weird. Why not use jq?
