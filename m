Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39E336F1139
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 07:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345192AbjD1FE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 01:04:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjD1FE0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 01:04:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DEEA26A2;
        Thu, 27 Apr 2023 22:04:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D7A8660AB4;
        Fri, 28 Apr 2023 05:04:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC619C433D2;
        Fri, 28 Apr 2023 05:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682658264;
        bh=1jG17+/ymFzEo1DeDLBm4GJ1/6GRzCzGRAUyoi4cchE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=WUpZRmPs+HS5nSEp2lgOEhgiHzBXVP1F5Zeods3BiFK9ogpLPHdf6SR0TF9cclENd
         2CULicHnBKqko0P9GmyZEe12EJbf8lzw+htBtqEHGxIEXSwwJGNacj8gWksXnJ6tv6
         ot5hv+spL+5dy7gZUtoFtXO+0bD2GiCBvUqLTqvFTRp0tbl5x364LID+luPvwzdzx2
         bfFK2sRD9evMxl2EB13Sr3ocNoHujQ2e9rdNXFRd0DkJvKK5g24wYcROTh7DNhcIEj
         oLhONSt6TrVDjBBNxLA5uorU3GIK5gQjl8X88DnKc3JB18CdvHGDRIFuMqxK9tuGHv
         khXWAXkfdsqPA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Aloka Dixit <quic_alokad@quicinc.com>,
        Muna Sinada <quic_msinada@quicinc.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net] wifi: mac80211: Fix puncturing bitmap handling in __ieee80211_csa_finalize()
References: <e84a3f80fe536787f7a2c7180507efc36cd14f95.1682358088.git.christophe.jaillet@wanadoo.fr>
Date:   Fri, 28 Apr 2023 08:04:19 +0300
In-Reply-To: <e84a3f80fe536787f7a2c7180507efc36cd14f95.1682358088.git.christophe.jaillet@wanadoo.fr>
        (Christophe JAILLET's message of "Mon, 24 Apr 2023 19:42:04 +0200")
Message-ID: <87mt2sppgs.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christophe JAILLET <christophe.jaillet@wanadoo.fr> writes:

> 'changed' can be OR'ed with BSS_CHANGED_EHT_PUNCTURING which is larger than
> an u32.
> So, turn 'changed' into an u64 and update ieee80211_set_after_csa_beacon()
> accordingly.
>
> In the commit in Fixes, only ieee80211_start_ap() was updated.
>
> Fixes: 2cc25e4b2a04 ("wifi: mac80211: configure puncturing bitmap")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

FWIW mac80211 patches go to wireless tree, not net.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
