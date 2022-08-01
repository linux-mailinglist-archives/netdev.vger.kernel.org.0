Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 697535873E6
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 00:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234722AbiHAWYe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 18:24:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232733AbiHAWYc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 18:24:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAEB03AE52;
        Mon,  1 Aug 2022 15:24:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 694DD60E09;
        Mon,  1 Aug 2022 22:24:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63AB6C433C1;
        Mon,  1 Aug 2022 22:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659392670;
        bh=bP0gTQuKnsU+QjjGvzpVjTenV7WLfb6TWquH7g48HGI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=spX34aVJgeGKTHPkD1lwz1FiPINCA7eGHxst9MHcxiIXBr5H+I+wp42w/xjoSTJ7v
         IszI0MAx1YOw+sz3Rf0aDLG9zm51R3hjiLDRJoLp9g/ZjMpDa1KAiX2YkLbxqfb6d8
         QS0f6bPxz435mvxa9UT7rdSdaYQguRW177hqsHK27B3ShdBGK88CvFeXvj1uK3Q1Xk
         N1/45Ye1Du6a3Z4fFYRSfEEzVBspkwVUbTgHcfa3YGyB5P7eT9xvGOXvtewl5kaI/S
         yK1Ac+htqXRvB5xM+Pvhj4GecDwJX55efIXVT4WYmJP1Kqt8moaqJGj5vjPeebPsyb
         346GEzAD7XCvg==
Date:   Mon, 1 Aug 2022 15:24:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marek Majkowski <marek@cloudflare.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@cloudflare.com, ivan@cloudflare.com,
        edumazet@google.com, davem@davemloft.net, pabeni@redhat.com,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        brakmo@fb.com
Subject: Re: [PATCH net-next v2 0/2] RTAX_INITRWND should be able to bring
 the rcv_ssthresh above 64KiB
Message-ID: <20220801152429.6102f5d2@kernel.org>
In-Reply-To: <20220729143935.2432743-1-marek@cloudflare.com>
References: <20220729143935.2432743-1-marek@cloudflare.com>
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

On Fri, 29 Jul 2022 16:39:33 +0200 Marek Majkowski wrote:
> This patch changes that. Now, by setting RTAX_INITRWND path attribute
> we bring up the initial rcv_ssthresh in line with the initrwnd
> value. This allows to increase the initial advertised receive window
> instantly, after first TCP RTT, above 64KiB.
> 
> With this change, the administrator can configure a route (or skops
> ebpf program) where the receive window is opened much faster than
> usual. This is useful on big BDP connections - large latency, high
> throughput - where it takes much time to fully open the receive
> window, due to the usual rcv_ssthresh cap.

Feels like we won't get enough review time here to make the current
merge window, so let me take this out of patchwork and let's switch 
to RFC postings.
