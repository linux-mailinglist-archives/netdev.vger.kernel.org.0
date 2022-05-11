Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7E0C522BBD
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 07:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240294AbiEKFdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 01:33:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbiEKFdJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 01:33:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89FA93DA54;
        Tue, 10 May 2022 22:33:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D0DB616D7;
        Wed, 11 May 2022 05:33:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C883C385DB;
        Wed, 11 May 2022 05:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652247187;
        bh=NGoQcJ+iAsisQ8f+zssQ2YRnfJafdWbUwxc1jht6wNA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=cSB4IaOnU68YF8oFv+bQqP4IiBCvoQJF27pXbBm7YR5F/jxe0zMv0GrC4hE762vYm
         7gfBSxFgQbWdZFr8p8ItlLSTB/wp0t/3HdlhAGWAgm+kLV65+9BSXyXEqckrr4Aqxr
         PjKGBj44lQ4pQLMBHlgT0SF+Wfcc0ZU+wmhyCOGSQXQYep4MbrbM2Ou4qu/4ejNupQ
         nbYUTTDtq/84GOzULUkRBSbd1qXrBNp7igdsmsNtansWVvzghdS6xWu9qKjfhLbNQH
         CcLFkW+EB3lJFozt1YMFSMHoV6hTI4jj9Bl2ZJFKHvnYpycUuTTWj1yQLoODaXFUFf
         iJOtghB0hljoA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v6] wfx: use container_of() to get vif
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220506170046.GA1297231@jaehee-ThinkPad-X1-Extreme>
References: <20220506170046.GA1297231@jaehee-ThinkPad-X1-Extreme>
To:     Jaehee Park <jhpark1013@gmail.com>
Cc:     =?iso-8859-1?q?J=E9r=F4me?= Pouiller <jerome.pouiller@silabs.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-staging@lists.linux.dev,
        outreachy@lists.linux.dev, Jaehee Park <jhpark1013@gmail.com>,
        Stefano Brivio <sbrivio@redhat.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165224718272.19198.8867712647289084011.kvalo@kernel.org>
Date:   Wed, 11 May 2022 05:33:04 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jaehee Park <jhpark1013@gmail.com> wrote:

> Currently, upon virtual interface creation, wfx_add_interface() stores
> a reference to the corresponding struct ieee80211_vif in private data,
> for later usage. This is not needed when using the container_of
> construct. This construct already has all the info it needs to retrieve
> the reference to the corresponding struct from the offset that is
> already available, inherent in container_of(), between its type and
> member inputs (struct ieee80211_vif and drv_priv, respectively).
> Remove vif (which was previously storing the reference to the struct
> ieee80211_vif) from the struct wfx_vif, define a function
> wvif_to_vif(wvif) for container_of(), and replace all wvif->vif with
> the newly defined container_of construct.
> 
> Signed-off-by: Jaehee Park <jhpark1013@gmail.com>

Patch applied to wireless-next.git, thanks.

2c33360bce6a wfx: use container_of() to get vif

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220506170046.GA1297231@jaehee-ThinkPad-X1-Extreme/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

