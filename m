Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60E0B66400C
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 13:14:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232095AbjAJMOO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 07:14:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232318AbjAJMN2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 07:13:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A35F496F4
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 04:11:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F74261648
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 12:11:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA61CC4331F;
        Tue, 10 Jan 2023 12:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673352716;
        bh=RNpPDdK5fjyI74TjY7B57+OSo76kpZrmknZcl+Yiwv4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GjVcahj2LCa+9d111YIytLTXa/buijmbDty/hoqqFki/ViirG4DDRt89UHxAIFXyi
         3myTadit+EN32oMWVf+aY6J6/jRfwmZVHk4AqqkBpm6i+YUAENHtCCiiw5JhNTN1Pl
         aDp/udPfR8pSSsLSIkzEq45mH7Cnn/7vL7ZKzq03whBowxKJ+kzCz6RkjcGbIp/OTC
         i6aCLGNJHSwC0BJ++ff/fGBNIAmsNwLUS0DuWj+YdM/FqOZBawiXt5ZjaRyUcuqBbQ
         V3bQNeAlWw47t44kD3B2zSBBuww/2piq0g4fl87YVONTnap8pvY/zJedDgalBwGJzl
         Xcc/kpmdddbtA==
Date:   Tue, 10 Jan 2023 14:11:51 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Srujana Challa <schalla@marvell.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, jerinj@marvell.com,
        sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        sbhatta@marvell.com, hkelam@marvell.com
Subject: Re: [PATCH v1 net-next,8/8] octeontx2-af: add mbox to return
 CPT_AF_FLT_INT info
Message-ID: <Y71WBwIt6lKrlUV3@unreal>
References: <20230110062258.892887-1-schalla@marvell.com>
 <20230110062258.892887-9-schalla@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230110062258.892887-9-schalla@marvell.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 10, 2023 at 11:52:58AM +0530, Srujana Challa wrote:
> Adds a new mailbox to return CPT faulted engines bitmap
> and recovered engines bitmap.
> 
> Signed-off-by: Srujana Challa <schalla@marvell.com>
> ---
>  .../net/ethernet/marvell/octeontx2/af/mbox.h  | 17 ++++++++++
>  .../net/ethernet/marvell/octeontx2/af/rvu.h   |  4 +++
>  .../ethernet/marvell/octeontx2/af/rvu_cpt.c   | 34 +++++++++++++++++++
>  3 files changed, 55 insertions(+)

<...>

> +		spin_lock(&rvu->cpt_intr_lock);
> +		block->cpt_flt_eng_map[vec] |= BIT_ULL(i);
> +		val = rvu_read64(rvu, blkaddr, CPT_AF_EXEX_STS(eng));
> +		if ((val & 0x2) || (!(val & 0x2) && (val & 0x1)))

I would say that this "if" is equal to (val & 0x2 || val & 0x1)

Thanks
