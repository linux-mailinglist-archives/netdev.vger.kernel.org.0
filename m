Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 460576CF9F6
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 06:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbjC3EGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 00:06:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbjC3EGA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 00:06:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C030B5277;
        Wed, 29 Mar 2023 21:05:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 415B461EC9;
        Thu, 30 Mar 2023 04:05:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A81CC433EF;
        Thu, 30 Mar 2023 04:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680149158;
        bh=/RukQSk9MBRr5EGb/2Qq9YCBwu/prPYxexLhyV9DMB8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rXtiGqZhKAumIhgN24xvwxikKy3OWvswJXR9MgnzKL0IvYH3/UieX+Tt86zTh2FB5
         PsAjlFO1Ylhcsy2n1XvoqPGhLnfAXnJcnIWoWVQ8KFB/QUIiklMGK1P4NOVkU/qrnd
         CxtUDCXBe7TnnuuDCI3kuhQ7IYjMu18RA1Q9L5A7cdOmj1Zofk8pGFDts1x3CSoFrn
         hqSJqutSYLw5UOJ4V31IBo4wXHUO47YXtdhvNP2JP3YoN04PGPRgwWihqomUaoe620
         dZqQweIQFvUCx5JI+F6LNoJllanLHGnprvhSVKLJKvlaBcaEPBte4CLrP5ngKKUDII
         2cedtFbS/ctDA==
Date:   Wed, 29 Mar 2023 21:05:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [RFC PATCH 2/2] mac80211: use the new drop reasons
 infrastructure
Message-ID: <20230329210557.3a5890fd@kernel.org>
In-Reply-To: <20230329234613.5bcb4d8dcade.Iea29d70af97ce2ed590a00dbebee2ab4d013dfd5@changeid>
References: <20230329214620.131636-1-johannes@sipsolutions.net>
        <20230329234613.5bcb4d8dcade.Iea29d70af97ce2ed590a00dbebee2ab4d013dfd5@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Mar 2023 23:46:20 +0200 Johannes Berg wrote:
> +	/** @SKB_DROP_REASON_SUBSYS_MAC80211_UNUSABLE: mac80211 drop reasons
> +	 * for unusable frames, see net/mac80211/drop.h
> +	 */
> +	SKB_DROP_REASON_SUBSYS_MAC80211_UNUSABLE,
> +
> +	/** @SKB_DROP_REASON_SUBSYS_MAC80211_MONITOR: mac80211 drop reasons
> +	 * for frames still going to monitor, see net/mac80211/drop.h
> +	 */
> +	SKB_DROP_REASON_SUBSYS_MAC80211_MONITOR,

heh, didn't expect you'd have two different subsystems TBH
