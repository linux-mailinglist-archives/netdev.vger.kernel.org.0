Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7313465F39F
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 19:21:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233578AbjAESVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 13:21:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233314AbjAESVI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 13:21:08 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5884B392C7
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 10:21:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9F2E9CE199D
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 18:21:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57821C433D2;
        Thu,  5 Jan 2023 18:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672942859;
        bh=8B1IObdHRO3zldAkqtt/2gLDiaCVD6cuNgF79cp/ZoU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aUFLoy3Rz5VAQRdbdOY1kwYXVDjvgPZpq/qgjxL9tSlahK5E5Tug59TDk7iP5xntO
         ndXh4DLJ9MIS2H3ltayd5B6KerloLax6i8jJLEOoSKxwpXEbesSqI90nzLQO9AuY6D
         bZiid15t59eFI+mD9eF7xZuy/dKpZDp/kGQ7TprHm5MnQuYrUNahvtwriDguAsFkn1
         UA3FWKBg2WvT7Fu35dmP0s+HYsgyCE8i68WdKwU7t4rvGO/EWjbq0/eRbBCzi2SLWM
         wnHY1Hywa2aplFTfDkH7bJkVbbtiCKg2DmS8TRZCG4926WND8VHdr57yZn1NM+W1FB
         w3yTAPMgrc2Eg==
Date:   Thu, 5 Jan 2023 10:20:58 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com
Subject: Re: [PATCH net-next 03/14] devlink: split out netlink code
Message-ID: <20230105102058.2e74c9a6@kernel.org>
In-Reply-To: <Y7aSeZqr9MYYgeoU@nanopsycho>
References: <20230104041636.226398-1-kuba@kernel.org>
        <20230104041636.226398-4-kuba@kernel.org>
        <Y7aSeZqr9MYYgeoU@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 Jan 2023 10:03:53 +0100 Jiri Pirko wrote:
> Wed, Jan 04, 2023 at 05:16:25AM CET, kuba@kernel.org wrote:
> >Move out the netlink glue into a separate file.
> >Leave the ops in the old file because we'd have to export a ton
> >of functions. Going forward we should switch to split ops which  
> 
> What do you mean by "split ops"?

struct genl_split_ops
