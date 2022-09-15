Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2E325B921C
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 03:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbiIOBW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 21:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbiIOBW0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 21:22:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C73A98C033;
        Wed, 14 Sep 2022 18:22:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0990B81D4B;
        Thu, 15 Sep 2022 01:22:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56B1AC433D7;
        Thu, 15 Sep 2022 01:22:21 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="flNXrxCP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1663204939;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oopG4kZfMzNPsMfn9jXYu3UxySFfQWcjRLfeH63couY=;
        b=flNXrxCPWoPOmNdKRSL1OHDXu8LY8qu2yILGncti0SbcPiI83Si4FPu0ptAKTqPcUFVNXY
        ijvOXfJuKur7DaP3sCgmpMGU8aGpG1iZ9YM69utqMwJVVs1nE1g7id798Esygpp6iIpOwO
        cJIrmt2gLhd+Jzsr3kCM0xjltuX8Xp8=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id bc3dab7b (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Thu, 15 Sep 2022 01:22:19 +0000 (UTC)
Date:   Thu, 15 Sep 2022 02:22:15 +0100
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Cc:     loic.poulain@linaro.org, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2] wcn36xx: Add RX frame SNR as a source of system
 entropy
Message-ID: <YyJ+R896rHHnt4In@zx2c4.com>
References: <20220914212841.1407497-1-bryan.odonoghue@linaro.org>
 <20220914212841.1407497-2-bryan.odonoghue@linaro.org>
 <YyJqfsXLESDWDBvR@zx2c4.com>
 <cbfa8d05-48a5-4950-a852-ad018d70da8e@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cbfa8d05-48a5-4950-a852-ad018d70da8e@linaro.org>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 15, 2022 at 01:14:08AM +0100, Bryan O'Donoghue wrote:
> On 15/09/2022 00:57, Jason A. Donenfeld wrote:
> > Won't this break on big endian? Just have an assignment handle it:
> > 
> 
> Yes but these SoCs are all LE

Oh, okay. I thought for some reason that the WCN36xx was just some wifi
chip on a variety of old 32bit ARM SoCs (including Nexus 4's MSM8225
with the Cortex-A5?), some of which I assumed could be biarch. I'm
probably wrong though.

Jason
