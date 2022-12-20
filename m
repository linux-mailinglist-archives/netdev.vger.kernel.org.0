Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC906529EB
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 00:36:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234074AbiLTXgL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 18:36:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232195AbiLTXgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 18:36:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABC22286;
        Tue, 20 Dec 2022 15:36:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4BD67B81A50;
        Tue, 20 Dec 2022 23:36:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD0C0C433EF;
        Tue, 20 Dec 2022 23:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671579362;
        bh=or3VibEClSNnX7FezaPfIedUI6RimEA/qvi1rP5FF3E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=h54XDOSkQL53OlbdIICwuvGXPBWHExr/f7p8gRkynFKeNgtv0JuHWiTS+d/qtlHxa
         Ekh+5TQUkilbDTCW4YiaHH0Zn1Opuq3ecXbNLf0Pkyny4oLgEOjqBiLyAyCpulXte4
         U21WxOEV0fBdaGe0EGWCOxdYA/w4V8UM+/rj6o8tf7oA39vrFQuDHSJphQFbLyLJSw
         cD5pxPtLs24FeCRGh2hl+R2A79/b7djUC2FJ+7Rw4TcbgjjYOMaU5yph6IBm6jpQWQ
         WBAdEBNsGIt+HiSiWB/ErSdPnTV/9yEQeXTOgyk9T79eJqSxhMKNwh4LprMaSIYEWw
         O1+ulimv4r5kg==
Date:   Tue, 20 Dec 2022 15:36:01 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net
Subject: Re: [PATCH bpf 2/2] selftests/bpf: tunnel: add sanity test for
 checksums
Message-ID: <20221220153601.5f16545b@kernel.org>
In-Reply-To: <7372590a-f40b-17d1-f780-3bd1ce4f30bb@linux.dev>
References: <20221220004701.402165-1-kuba@kernel.org>
        <20221220004701.402165-2-kuba@kernel.org>
        <7372590a-f40b-17d1-f780-3bd1ce4f30bb@linux.dev>
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

On Tue, 20 Dec 2022 15:21:08 -0800 Martin KaFai Lau wrote:
> Thanks for the fix and the idea on how to test it.
> 
> I have posted a patch to translate this test to a test for test_progs that can 
> finish and exit such that it can be run continuously in CI.  The test attaches a 
> tc-bpf at lo and the bpf prog directly checks for the skb->ip_summed == 
> CHECKSUM_NONE and the broken csum_start condition.
> 
> If the test_progs patch looks good, patch 1 can be landed first and then land 
> the test_progs patch.  wdyt?

I'm not attached to the test, your patch looks good!
