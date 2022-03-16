Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03B5F4DB83C
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 19:53:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357785AbiCPSyo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 14:54:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354461AbiCPSyn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 14:54:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC64517E30;
        Wed, 16 Mar 2022 11:53:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C31B618F9;
        Wed, 16 Mar 2022 18:53:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B12A1C340E9;
        Wed, 16 Mar 2022 18:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647456807;
        bh=DbCDMVM1QylXDAIdBxRLZIn7utiL20SzLpF8Lqell+g=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=FfFqilKHDmeeEFc+aMchF+OFWCRODhZvB3tQ5wrS3pZaolcAu2CZm/3dpPhdCfuVY
         m+6UnRbWFII37RfWLwwZKlZHfHUUmSkjzo+ZeiLmhd8Nn9a1AI2HCdO4FjsD5IHf9R
         KkirZ9Nw0fFZJNcwTZwGAjWaaSH9OWuRQa+qiwlIzfM9IVJpQMfKlYzLUf5NfWKOq/
         m9ggNsJ0cJdO0Zk7vB2eimu5lEFW5oGOvShx7zKK2a4wknG545BmVpxrfe96MQ0Ya7
         NgJptqSGR0lYnsb/U8PulHwHjeue+2cqSsezsMXmGpFg3ePz75K5ym3SLYEl5t2zh1
         NeQFYL/eCLWKw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Luca Coelho <luciano.coelho@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ayala Beker <ayala.beker@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iwlwifi: mei: fix building iwlmei
References: <20220316183617.1470631-1-arnd@kernel.org>
Date:   Wed, 16 Mar 2022 20:53:19 +0200
In-Reply-To: <20220316183617.1470631-1-arnd@kernel.org> (Arnd Bergmann's
        message of "Wed, 16 Mar 2022 19:36:03 +0100")
Message-ID: <87czilpw4g.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arnd Bergmann <arnd@kernel.org> writes:

> From: Arnd Bergmann <arnd@arndb.de>
>
> Building iwlmei without CONFIG_CFG80211 causes a link-time warning:
>
> ld.lld: error: undefined symbol: ieee80211_hdrlen
>>>> referenced by net.c
>>>>               net/wireless/intel/iwlwifi/mei/net.o:(iwl_mei_tx_copy_to_csme)
>>>> in archive drivers/built-in.a
>
> Add an explicit dependency to avoid this. In theory it should not
> be needed here, but it also seems pointless to allow IWLMEI
> for configurations without CFG80211.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/net/wireless/intel/iwlwifi/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
>
> I see this warning on 5.17-rc8, but did not test it on linux-next,
> which may already have a fix.

I just sent the last pull request to v5.17. Luca, should I take this to
wireless-next? Ack?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
