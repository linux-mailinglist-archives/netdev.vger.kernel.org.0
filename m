Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77B4A611F1D
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 03:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbiJ2Bey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 21:34:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiJ2Bew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 21:34:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01354248F9;
        Fri, 28 Oct 2022 18:34:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23A0BB82DF6;
        Sat, 29 Oct 2022 01:34:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9881EC433C1;
        Sat, 29 Oct 2022 01:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667007286;
        bh=NjzGX7GUqetG1uZRkrz2Aw9KKvTjknXH+PfNtLqjF0E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=avDaI+sJLUEuJUcz7mPGMl7YjLc3fR6u4MetdBv8ch9cLy5Mh4Je3sGTXMRF4ujuw
         NoANQx1Q2DTl8jWpCcJjuazfqXm+RmT89XdFbrrAJt63YsyKFHA6HyLHUQ0G9iHF1Y
         vKv274fWxX/meC2bSDkI+dkNV50QKp50yRN6n1E+41iAM1FIaBDMlBcoILxdqCVZxl
         ZbfaUBUfLIBkAAFDJos03efcBnHpv377pyMmrp+PBE+C6L9jpAtBR1qK16ksypzHmL
         EbVFPalYdcqSXoOjOpIak89FjlHpIIxwEYZ85IFvYpe9DorcnYvI7g1l+li3nLmpmY
         xfFvdOtrCzxVw==
Date:   Fri, 28 Oct 2022 18:34:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: wireless-next-2022-10-28
Message-ID: <20221028183439.2ff16027@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20221028132943.304ECC433B5@smtp.kernel.org>
References: <20221028132943.304ECC433B5@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Oct 2022 13:29:43 +0000 (UTC) Kalle Valo wrote:
> Note: wireless tree was merged[1] to wireless-next to avoid some
> conflicts with mac80211 patches between the trees. Unfortunately there
> are still two smaller conflicts in net/mac80211/util.c which Stephen
> also reported[2]. In the first conflict initialise scratch_len to
> "params->scratch_len ?: 3 * params->len" (note number 3, not 2!) and
> in the second conflict take the version which uses elems->scratch_pos.
> 
> Git diff output should like this:
> 
> --- a/net/mac80211/util.c
> +++ b/net/mac80211/util.c
> @@@ -1506,7 -1648,7 +1650,7 @@@ ieee802_11_parse_elems_full(struct ieee
>         const struct element *non_inherit = NULL;
>         u8 *nontransmitted_profile;
>         int nontransmitted_profile_len = 0;
> -       size_t scratch_len = params->len;
>  -      size_t scratch_len = params->scratch_len ?: 2 * params->len;
> ++      size_t scratch_len = params->scratch_len ?: 3 * params->len;
> 
>         elems = kzalloc(sizeof(*elems) + scratch_len, GFP_ATOMIC);
>         if (!elems)
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git/commit/?id=dfd2d876b3fda1790bc0239ba4c6967e25d16e91
> [2] https://lore.kernel.org/all/20221020032340.5cf101c0@canb.auug.org.au/

Thanks! I only saw one conflict FWIW
