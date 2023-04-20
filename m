Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D23686E9731
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 16:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231441AbjDTOdk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 10:33:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231624AbjDTOdj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 10:33:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8B1B7695;
        Thu, 20 Apr 2023 07:33:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CCAE61791;
        Thu, 20 Apr 2023 14:33:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 252B0C4339B;
        Thu, 20 Apr 2023 14:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682001202;
        bh=q2atBF0cJlaYHiFetu0vG4x/7tLR7MTaSABzMRmXwv4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=X3mPIEBX6NLvJa9OkFPu4tVqZSXj0fChyurge4rQ9NwbLE+Arg9GVSAdRNL2xU4mP
         0Okkqvyuqzf3PKrpgRHsnY3QR6m5+R/ljLfNkY5QFOztMfiCJ3ki4U3GuxlF1GtCRd
         r841Asy3mqEL5zIpFxVoLWvikElbPxz2mqrc10lJRJxsV2t4x5OTvJAIEslweVRLmt
         7WrXAJlAYXdjKeOE/5Q0M41XWtTJobpY5wv0zI5qoTmJkHJwSHdF+qKkKwoJnhab6s
         F/uYiomEphAYsJOuOfMZQaDebsk0vUsEjs4SJA8i29zMDx1n0LuULR8m49vjFHrdMI
         TAKCv0QPp7+Gw==
Date:   Thu, 20 Apr 2023 07:33:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wang Jikai <wangjikai@hust.edu.cn>
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        hust-os-kernel-patches@googlegroups.com,
        Jakub Kicinski <kubakici@wp.pl>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH 1/2] wifi: mt7601u: delete dead code checking debugfs
 returns
Message-ID: <20230420073321.47dd0cfe@kernel.org>
In-Reply-To: <20230420130815.8425-1-wangjikai@hust.edu.cn>
References: <20230420130815.8425-1-wangjikai@hust.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Apr 2023 13:08:14 +0000 Wang Jikai wrote:
> Smatch reports that:
> drivers/net/wireless/mediatek/mt7601u/debugfs.c:130
> mt7601u_init_debugfs() warn: 'dir' is an error pointer or valid".
> 
> Debugfs code is not supposed to need error checking so instead of
> changing this to if (IS_ERR()) the correct thing is to just delete
> the dead code.
> 
> Fixes: c869f77d6abb ("add mt7601u driver")

Don't add a Fixes tag on this cleanup.
one - dead code is not a bug
two - the semantics have changed since the driver was added
      so it's certainly not the right Fixes tag
