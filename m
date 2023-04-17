Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13F266E5555
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 01:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbjDQXhc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 19:37:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbjDQXhb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 19:37:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA7AC59E2
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 16:37:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB1C462B29
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 23:36:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCF8CC433EF;
        Mon, 17 Apr 2023 23:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681774565;
        bh=fMi2MjdIuohmFlNCMVjDK96WJ0oW3grC2Eq+4bQULx4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VzfKc6EdkAfjnK7UzL9XQ/OPCXZU8RQp5vK63f+F7Xoflvvh299U5bYBDTj7DKwMt
         goGbO/tVwG8iBsBFhSkuJGoUpMGO/Okwl5n42e4vGeiusBpOItU4NCM8/0kldpTPMK
         WtpUfOJvXgDigMN6j+GGNLph0r16d798206dc4mDS7u85vR2IZOOx9Q4BugcsLz/u5
         bVAFVJrHTXGsojFiz5ElVUjE4YtWA4Epp4R93FvEhpxFUeDJXegh5mSW+kYF5y+UZj
         JD6dks8H71p2qfQfZO00jYC//J2VWXbHI12FV3z6oRGLEAD7P2BsRnQm7MCeCKzyR+
         Dkygsr44b/hgw==
Date:   Mon, 17 Apr 2023 16:36:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, hawk@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com,
        lorenzo.bianconi@redhat.com, jdamato@fastly.com
Subject: Re: [PATCH net-next] net: page_pool: add pages and released_pages
 counters
Message-ID: <20230417163603.30be79bf@kernel.org>
In-Reply-To: <ZD28nJonfDPiW4F8@lore-desk>
References: <a20f97acccce65d174f704eadbf685d0ce1201af.1681422222.git.lorenzo@kernel.org>
        <20230414184653.21b4303d@kernel.org>
        <ZDqHmCX7D4aXOQzl@lore-desk>
        <20230417111204.08f19827@kernel.org>
        <ZD28nJonfDPiW4F8@lore-desk>
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

On Mon, 17 Apr 2023 23:39:40 +0200 Lorenzo Bianconi wrote:
> > Yup, that sounds better.  
> 
> ack, fine. I am now wondering if these counters are useful just during
> debugging or even in the normal use-case.

I was wondering about it too, FWIW, I think the most useful info is
the number of outstanding references. But it may be a little too
unflexible as a statistic. BPF attached to the trace point may be
a better choice there, and tracepoints are already in place.
