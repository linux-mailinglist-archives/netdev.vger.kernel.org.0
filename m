Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A89926BA999
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 08:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbjCOHnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 03:43:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbjCOHnq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 03:43:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5384338032
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 00:43:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA8F4B81CD1
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 07:43:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41772C433EF;
        Wed, 15 Mar 2023 07:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678866203;
        bh=ubx0HGC9RSsNvRbn1FX94qw5HBTbnfcg82ow8PzYmv8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BeWtemPsC04L4E4sz4BxoEQ4wiA64R+7bnVk5c8JPL0MdurNQ1B5wBT+l3jUJ0/24
         iXyFbHT2wPJREQw3Q4QpFaz8+P5PmSS5lEjyurYEe0M/C+HsMBos2UA+/Xri/My80K
         CuPckkcCOaaueEfvV0XADw+J25cxbSsoOtdA6nGE=
Date:   Wed, 15 Mar 2023 08:43:21 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Tao Liu <taoliu828@163.com>, paulb@nvidia.com, roid@nvidia.com,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH for-5.10] skbuff: Fix nfct leak on napi stolen
Message-ID: <ZBF3GaLSLsoHNpsh@kroah.com>
References: <20230314121017.1929515-1-taoliu828@163.com>
 <20230314224312.41b6b248@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314224312.41b6b248@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 10:43:12PM -0700, Jakub Kicinski wrote:
> On Tue, 14 Mar 2023 20:10:17 +0800 Tao Liu wrote:
> > Upstream commit [0] had fixed this issue, and backported to kernel 5.10.54.
> > However, nf_reset_ct() added in skb_release_head_state() instead of
> > napi_skb_free_stolen_head(), which lead to leakage still exist in 5.10.
> > 
> > [0] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=8550ff8d8c75416e984d9c4b082845e57e560984
> > 
> > Fixes: 570341f10ecc ("skbuff: Release nfct refcount on napi stolen or re-used skbs"))
> > Signed-off-by: Tao Liu <taoliu828@163.com>
> 
> I'm not sure Greg will spot this. Make sure you CC stable.

Ah, thanks, I missed it.

I've queued this up now, Tao, nice fix, sorry for getting the backport
wrong!

greg k-h
