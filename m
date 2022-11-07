Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F39461EC6F
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 08:51:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231371AbiKGHvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 02:51:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbiKGHvt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 02:51:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 837AE6547
        for <netdev@vger.kernel.org>; Sun,  6 Nov 2022 23:51:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 457B0B80E1A
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 07:51:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61D35C433D6;
        Mon,  7 Nov 2022 07:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667807505;
        bh=YSYxzWcBLST9FZdjFD/3ZIkMmZ6QGFsG0GQBWr6Tf7k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fAY2kUjCncyLevCDX5qrMfb/Dr6iK05ZQuGaJCcCx56zu3V0HKM43l4o5dIiha5sr
         WihGqdkmjnKsKOGHdtUqyf21aB8/BFt+EOH+GLFEgtPvG646f3UZ1lJEzCsVvDkMAW
         KifuucilVCpcXoxbY/WjcLkEgkLOP0OlBSU2SaID2OUXYHVMpHij9HBe7Oay6+6Jq4
         jBtOCDEZlxsARTYMSFKRFXetteQSOikj9NuRscB9+ChWbORqJG3UqGL2dJ8pmSQ+uS
         RDQsDyXwPgF7XIgpxeMR8iOxBsi7Lb0a7oXFAfFuOAHVEieTAIeW3ymaXiZMZucpxk
         RhlavjI3EdicQ==
Date:   Mon, 7 Nov 2022 09:51:41 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, gospo@broadcom.com,
        pavan.chebbi@broadcom.com
Subject: Re: [PATCH net-next 2/3] bnxt_en: update RSS config using difference
 algorithm
Message-ID: <Y2i5DfPo0nmPg2iK@unreal>
References: <1667780192-3700-1-git-send-email-michael.chan@broadcom.com>
 <1667780192-3700-3-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1667780192-3700-3-git-send-email-michael.chan@broadcom.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 06, 2022 at 07:16:31PM -0500, Michael Chan wrote:
> From: Edwin Peer <edwin.peer@broadcom.com>
> 
> Hardware is unable to realize all legal firmware interface state values
> for hash_type.  For example, if 4-tuple TCP_IPV4 hash is enabled,
> 4-tuple UDP_IPV4 hash must also be enabled.  By providing the bits the
> user intended to change instead of the possible illegal intermediate
> states, the firmware is able to make better compromises when deciding
> which bits to ignore.
> 
> With this new mechansim, we can now report the actual configured hash
> back to the user.  Add bnxt_hwrm_update_rss_hash_cfg() to report the
> actual hash after user configuration.
> 
> Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
> Signed-off-by: Michael Chan <michael.chan@broadcom.com>
> ---
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 35 +++++++++++++-
>  drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  2 +
>  .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c |  2 +
>  drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h | 47 +++++++++++++++++++
>  4 files changed, 85 insertions(+), 1 deletion(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
