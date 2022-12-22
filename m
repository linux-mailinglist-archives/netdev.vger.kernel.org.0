Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7BF16544D6
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 17:08:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235408AbiLVQIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 11:08:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235279AbiLVQHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 11:07:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25B263055B;
        Thu, 22 Dec 2022 08:07:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9DD9E61C60;
        Thu, 22 Dec 2022 16:07:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF9BCC433EF;
        Thu, 22 Dec 2022 16:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671725253;
        bh=yMQxLiPtoLT7zBPn9nDBfdCQ5tHVyhHAYdfHHF35pAU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=I/fyAp4DBWeoebl6gkJvFwr2hxmbBOrKaZpt595GmiNX4P6kwEx0GEN1eGhu5XhAt
         U25oehL92/SMfwKT2nf0dzerESludBGdzsj4LYSXAi4Ore+mqd4fVACdml1LAmjeV8
         ufyJHt3/mF2cd9SlbEv1+HtYXn4tQPyzsN8wmjLAmJe5/KjcXAm5/g/VNmxult0+ZX
         +z0hLDmt/tHZvnAofGiTX22HQ9GaeW7l7n/gzR4KvniWew3+ddp4mwiD6TOBF/ipjg
         UowTZmgQ6scTjwWgJsts4UJ6BogiDuZLGmHYY5auMd6qwTxOezVEeUtiRlWuinAlWv
         QiWWEsQ+Ziu6A==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [wireless,v2] wifi: brcmfmac: fix potential memory leak in
 brcmf_netdev_start_xmit()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <1668684782-47422-1-git-send-email-zhangchangzhong@huawei.com>
References: <1668684782-47422-1-git-send-email-zhangchangzhong@huawei.com>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <SHA-cyfmac-dev-list@infineon.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167172524811.8231.1294245830866743859.kvalo@kernel.org>
Date:   Thu, 22 Dec 2022 16:07:29 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zhang Changzhong <zhangchangzhong@huawei.com> wrote:

> The brcmf_netdev_start_xmit() returns NETDEV_TX_OK without freeing skb
> in case of pskb_expand_head() fails, add dev_kfree_skb() to fix it.
> Compile tested only.
> 
> Fixes: 270a6c1f65fe ("brcmfmac: rework headroom check in .start_xmit()")
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Patch applied to wireless-next.git, thanks.

212fde3fe76e wifi: brcmfmac: fix potential memory leak in brcmf_netdev_start_xmit()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/1668684782-47422-1-git-send-email-zhangchangzhong@huawei.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

