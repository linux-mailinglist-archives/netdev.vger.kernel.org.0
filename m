Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3294D5378C2
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 12:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234547AbiE3JZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 05:25:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbiE3JZV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 05:25:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63A8574DDE;
        Mon, 30 May 2022 02:25:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F100A60F74;
        Mon, 30 May 2022 09:25:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42FD9C385B8;
        Mon, 30 May 2022 09:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653902719;
        bh=m2yyG9BQdflMSnyJPqcEAfpQTzTat6gWEss+B0dva40=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=CkzrO6UKGcJSMJENAJXpOaA9/CWRCML32aI/tzE4AeAZkua34hOLU0+WCWGWwFhqe
         gqWMnNTfsWCs6e+h/3UB6aLeXCGNZ9ugw6YugCI9rpIsEIbE6zPY7cgRbkQARtEovf
         Y+0YY/veN2kYIFN/uAt14PL9uxm5pGtA4We7/J5fJT6WfAIBKYFqFRCugzRzqjXnQY
         eejGRRtXEpI4Ny6US4LvAs4Y8iHe5LC1YfgQulrfO8eFBmnjIYft37JSvEhEu9FdsK
         2D6aBgJ3Id5CQIhT0wOr2OvsKPS5LxpG4NmjWt519E3ohFLjnDW61KJL+mBYq5eMMR
         WUp0RZm+RimGA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Sascha Hauer <s.hauer@pengutronix.de>
Cc:     linux-wireless@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        Hans Ulli Kroll <linux@ulli-kroll.de>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        kernel@pengutronix.de, Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 00/10] RTW88: Add support for USB variants
References: <20220518082318.3898514-1-s.hauer@pengutronix.de>
Date:   Mon, 30 May 2022 12:25:13 +0300
In-Reply-To: <20220518082318.3898514-1-s.hauer@pengutronix.de> (Sascha Hauer's
        message of "Wed, 18 May 2022 10:23:08 +0200")
Message-ID: <87fskrv0cm.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sascha Hauer <s.hauer@pengutronix.de> writes:

> Another problem to address is that the driver uses
> ieee80211_iterate_stations_atomic() and
> ieee80211_iterate_active_interfaces_atomic() and does register accesses
> in the iterator. This doesn't work with USB, so iteration is done in two
> steps now: The ieee80211_iterate_*_atomic() functions are only used to
> collect the stations/interfaces on a list which is then iterated over
> non-atomically in the second step. The implementation for this is
> basically the one suggested by Ping-Ke here:
>
> https://lore.kernel.org/lkml/423f474e15c948eda4db5bc9a50fd391@realtek.com/

Isn't this racy? What guarantees that vifs are not deleted after
ieee80211_iterate_active_interfaces_atomic() call?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
