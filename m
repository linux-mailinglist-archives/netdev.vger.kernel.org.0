Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7C96660E8
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 17:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbjAKQqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 11:46:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232320AbjAKQp6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 11:45:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA1E1251
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 08:45:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FCE861D96
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 16:45:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABA74C433F0;
        Wed, 11 Jan 2023 16:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673455550;
        bh=I+n+KBS1Ngm5QbZvHSMuooB25/dhv4aOsRTHyxFjO9g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sVgJHiJkS2o5q0Z9mVnd7RyEs+3L9X3FSL9eHU6LGcQ29Ywx5PU23otUC/dta6dSH
         9mqJVX3H6xkqIDFtBJwTOlz+yJHz24Zt8/oRL5KY6IDWm2s5i+2gBsXK2ESN0X24xc
         tvXH7gjevqf2dcetg0ZledqMtHTYeNWtTkqyMsJ7v5vDyKpuAxHBtDPrrmWMfZNBHo
         eNTuGHgJO/BowQZfVCAm7TjvWQ1QRkqVB96mrH4gWo+rMvbA6HPPcJCGt2DWEfDpyY
         e3RgSOsvrQvduippdZbGNZzz0pI2xwLpxPXdPuzp/HhLJmGcldtMcFJUZ6JCSHyfuG
         uqzIB6C/MjJHA==
Date:   Wed, 11 Jan 2023 08:45:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jacob Keller <jacob.e.keller@intel.com>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com
Subject: Re: [PATCH net-next 7/9] devlink: allow registering parameters
 after the instance
Message-ID: <20230111084549.258b32fb@kernel.org>
In-Reply-To: <Y76CHc18xSlcXdWJ@nanopsycho>
References: <20230106063402.485336-1-kuba@kernel.org>
        <20230106063402.485336-8-kuba@kernel.org>
        <Y7gaWTGHTwL5PIWn@nanopsycho>
        <20230106132251.29565214@kernel.org>
        <14cdb494-1823-607a-2952-3c316a9f1212@intel.com>
        <Y72T11cDw7oNwHnQ@nanopsycho>
        <20230110122222.57b0b70e@kernel.org>
        <Y76CHc18xSlcXdWJ@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Jan 2023 10:32:13 +0100 Jiri Pirko wrote:
> >> I'm confused. You want to register objects after instance register?  
> >
> >+1, I think it's an anti-pattern.  
> 
> Could you elaborate a bit please?

Mixing registering sub-objects before and after the instance is a bit
of an anti-pattern. Easy to introduce bugs during reload and reset /
error recovery. I thought that's what you were saying as well.
