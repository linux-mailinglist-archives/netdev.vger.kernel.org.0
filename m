Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7B469F285
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 11:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231969AbjBVKKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 05:10:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbjBVKKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 05:10:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6903931E1D;
        Wed, 22 Feb 2023 02:10:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF5B561313;
        Wed, 22 Feb 2023 10:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1593BC433D2;
        Wed, 22 Feb 2023 10:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677060612;
        bh=0EjWaW8FZbf/rs4S89php6TeZDRc/tzK7/iJgWJKpSk=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=G2CGdBU8wgzdtt3+iOQ/BysR27IMxblAj4vBx7/K3cM2RgQCcsnyeJFoQfitdFtld
         0eIWMniczTdNmkRxFePeBRRDJNMdenaM3sRERb6ZcEpPcz8qebzYq0RhiiCfEkc1n5
         53j3nhK62MNAsYMIAe7BL2+FcuOcfOmzkGgpp+koYU5xNpxBjVhhHo2cdRQyYiKu05
         SpnYw0CM1ls7Lx7Vh1Jy60l3y73aAeePkGGeiysQERp3uH+1EkPNtPlfU2jGF52o4T
         aveZENp3vK2h9i72bHf/m5akqCFrtjMiemvCJ5CxgSKJnaxLRroyOEdy2RQ6jjdtQ4
         B7RgacBZppUOQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: ath11k: fix SAC bug on peer addition with sta band
 migration
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230209222622.1751-1-ansuelsmth@gmail.com>
References: <20230209222622.1751-1-ansuelsmth@gmail.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Christian Marangi <ansuelsmth@gmail.com>,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Carpenter <error27@gmail.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167706060829.17720.10858738686921337257.kvalo@kernel.org>
Date:   Wed, 22 Feb 2023 10:10:09 +0000 (UTC)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christian Marangi <ansuelsmth@gmail.com> wrote:

> Fix sleep in atomic context warning detected by Smatch static checker
> analyzer.
> 
> Following the locking pattern for peer_rhash_add lock tbl_mtx_lock mutex
> always even if sta is not transitioning to another band.
> This is peer_add function and a more secure locking should not cause
> performance regression.
> 
> Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.5.0.1-01208-QCAHKSWPL_SILICONZ-1
> 
> Fixes: d673cb6fe6c0 ("wifi: ath11k: fix peer addition/deletion error on sta band migration")
> Reported-by: Dan Carpenter <error27@gmail.com>
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

60b7d62ba8cd wifi: ath11k: fix SAC bug on peer addition with sta band migration

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230209222622.1751-1-ansuelsmth@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

