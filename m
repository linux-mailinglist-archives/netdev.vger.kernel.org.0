Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4566877C4
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 09:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231760AbjBBIqQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 03:46:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbjBBIqP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 03:46:15 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C30256DFEA
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 00:46:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 344ECCE28D6
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 08:46:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDD4AC433EF;
        Thu,  2 Feb 2023 08:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675327571;
        bh=Nor9djCaMbjQPm0+Vm2HtPvT3gGToiULHOhrNdcjI8I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JU1jwW9WqzAPJJR6eOOPRtKREg+KRvTt478l0guFaDT9VcJV3WdgtKkYfEQ0NqKXk
         iJqGTnmYD/bu/hHv+zr0pDS1aguR2Wth3zWQVTII+PW9l3/8ppIePVvtKg9/tBpNZO
         CmVtmTZ3tB5Vd5nWTB2SWhjSsl30uBp8OvIHxBEp6/CQta1UN24eRdJ2LHaYNZBMCr
         T5G1SL/v2KqpQaWfYsHKvZixnAjzTFyi2FbCkZkGO9IFMAuxnii1CEsHptlvAsqa/S
         u9DGY4XtpXKvr5hTmY8Nb0FjXS/6WkvqRLdHIMlc76P6m+obPTLGFb6ovoSl6FH+cX
         DuvggZW23KY1w==
Date:   Thu, 2 Feb 2023 10:46:07 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        drivers@pensando.io, Neel Patel <neel.patel@amd.com>
Subject: Re: [PATCH net 4/6] ionic: clean interrupt before enabling queue to
 avoid credit race
Message-ID: <Y9t4T1Atbp3jWhaW@unreal>
References: <20230202013002.34358-1-shannon.nelson@amd.com>
 <20230202013002.34358-5-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202013002.34358-5-shannon.nelson@amd.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 01, 2023 at 05:30:00PM -0800, Shannon Nelson wrote:
> From: Neel Patel <neel.patel@amd.com>
> 
> Clear the interrupt credits before enabling the queue rather
> than after to be sure that the enabled queue starts at 0 and
> that we don't wipe away possible credits after enabling the
> queue.
> 
> Fixes: 0f3154e6bcb3 ("ionic: Add Tx and Rx handling")
> Signed-off-by: Neel Patel <neel.patel@amd.com>
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> ---
>  drivers/net/ethernet/pensando/ionic/ionic_lif.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
