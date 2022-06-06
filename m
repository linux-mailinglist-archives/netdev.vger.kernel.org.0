Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA62E53ED6B
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 19:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbiFFR7m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 13:59:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiFFR7l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 13:59:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D7C131911
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 10:59:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 178FD6124F
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 17:59:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6610AC385A9;
        Mon,  6 Jun 2022 17:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654538379;
        bh=pVe7LPbQDsLZvfWz9SBkKgHyT7tH90H9mybaTIe0+Eo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ihQZMaDtO1/Dkmu4hl7oTAGm3h7+4IBUm+SjI85qUFSzk/rO+T9StwRAu+jsNpt7P
         gpxBOfGUM59Hb1PkrkSSp4n0WyPj7o/JXnVKhE9DiRqFXpp+zLhBqVuYVo71fZR0DM
         fkLOqctcO5c0gkxh7HhIRPLK6KasMtD9AxJkts96vlxj0YRTETgW5596OYiaK/c8ph
         FsZ7IEMWUn/L67XkszBjeCrhMKy6CH1vaRy6/CmVtKCzW+CNqXBXqinmO5XSya8OQW
         zB+Aga7dzD05Xb2nH78OqKDysxfypnWGURVPSNP4PB1M6erUHf7/sDrFLX0sM0gz2h
         mZGe7Fh+lFo9w==
Date:   Mon, 6 Jun 2022 10:59:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     dsahern@gmail.com, netdev@vger.kernel.org,
        stephen@networkplumber.org, tariqt@nvidia.com
Subject: Re: [PATCH iproute2-next v2] ss: Shorter display format for TLS
 zerocopy sendfile
Message-ID: <20220606105936.4162fe65@kernel.org>
In-Reply-To: <2a1d3514-5c6a-62b6-05b7-b344e0ba3e47@nvidia.com>
References: <20220601122343.2451706-1-maximmi@nvidia.com>
        <20220601234249.244701-1-kuba@kernel.org>
        <bf8c357e-6a1d-4c42-e6f8-f259879b67c6@nvidia.com>
        <20220602094428.4464c58a@kernel.org>
        <779eeee9-efae-56c2-5dd6-dea1a027f65d@nvidia.com>
        <20220603085140.26f29d80@kernel.org>
        <2a1d3514-5c6a-62b6-05b7-b344e0ba3e47@nvidia.com>
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

On Mon, 6 Jun 2022 14:29:02 +0300 Maxim Mikityanskiy wrote:
> > The difference is that the person writing the code (who will interact
> > with kernel defines) is likely to have a deeper understanding of the
> > technology and have read the doc. My concern is that an ss user will
> > have much more superficial understanding of the internals so we need
> > to be more careful to present the information in the most meaningful
> > way.
> > 
> > E.g. see the patch for changing dev->operstate to UP from UNKNOWN
> > because users are "confused". If you just call the thing "zc is enabled"
> > I'm afraid users will start reporting that the "go fast mode" is not
> > engaged as a bug, without appreciation for the possible side effects.  
> 
> That makes some sense to me. What about calling the ss flag 
> "zc_sendfile_ro" or "zc_ro_sendfile"? It will still be clear it's 
> zerocopy, but with some nuance.

That'd be an acceptable compromise. Hopefully sufficiently forewarned
users will mentally remove the zc_ part and still have a meaningful
amount of info about what the flag does.

Any reason why we wouldn't reuse the same knob for zc sendmsg()? If we
plan to reuse it we can s/sendfile/send/ to shorten the name, perhaps.

> > Dunno if it's useful but FWIW I pushed my WIP branch out:
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/kuba/linux.git/commit/?h=tls-wip&id=d923f1049a1ae1c2bdc1d8f0081fd9f3a35d4155
> > https://git.kernel.org/pub/scm/linux/kernel/git/kuba/linux.git/commit/?h=tls-wip&id=b814ee782eef62d6e2602ab3ba7b31ca03cfe44c  
> 
> I took a glance, and I agree zerocopy isn't the best name for your 
> feature. If I wanted to indicate it saves one copy, I would call it 
> "direct decrypt". "Expect no pad" also works from the point of view of 
> declaring limitations.
> 
> Another topic to consider is whether TLS 1.3 should be part of the name, 
> and should "TlsDecryptRetry" be more specific (if a future feature also 
> retries decryption as a fallback, do we want to count these retries in 
> the same counter or in a new counter?)

I wanted to avoid the versions because TLS 1.4 may need the same
optimization.

You have a point about the more specific counter, let me add a counter
for NoPad being violated (tail == 0) as well as the overall "decryption
happened twice" counter.
