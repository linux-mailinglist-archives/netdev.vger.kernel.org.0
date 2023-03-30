Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D114C6D0CF9
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 19:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232222AbjC3Rha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 13:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232084AbjC3Rh3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 13:37:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1387E3B9;
        Thu, 30 Mar 2023 10:37:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C41D62154;
        Thu, 30 Mar 2023 17:37:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 782D8C433D2;
        Thu, 30 Mar 2023 17:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680197847;
        bh=g+E3SjC29YFjgBkp7oVl7fZKaN1Uj7OI7xkghrzJQwg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=clByE355uQmEDi5/74MGD8pohdV5nlqeFi8P/jRjvKWELEPNJJQM5ePB6rAix+HwW
         zeykNjcYq6G3uwWXoFONSktYIPvtvSxBuNe3msOeWHanhBaeA4j8xaf9vC5G4ROiqJ
         +3LvULJHypsiuXfZCBuYhnWwBSSggXySzMj3IXdPo1UN2OAjWfp2gudLHH5YFIpWQs
         /78OkdKXgIighdYr2ZbFQ/vDftyF49BJCROEulEX23bXCPHq/CbWtKFSEXsrUrg3j1
         ckhsa810yj7BulK2sVW4I/H8QIPhuJHynVAmlhfVBjzseYfOd/pfzuzZiOlsY+uUUe
         3lrneRuxiX0hA==
Date:   Thu, 30 Mar 2023 10:37:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] net: extend drop reasons for multiple
 subsystems
Message-ID: <20230330103726.02aa8ae0@kernel.org>
In-Reply-To: <cb8ca010692920d909d0155aac9d66761bbf250c.camel@sipsolutions.net>
References: <20230329214620.131636-1-johannes@sipsolutions.net>
        <20230329210524.651810e4@kernel.org>
        <cb8ca010692920d909d0155aac9d66761bbf250c.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Mar 2023 10:11:12 +0200 Johannes Berg wrote:
> Yeah, I was being a bit sneaky here ;)
> 
> We could, for sure. Given that the users should probably be defensively
> coded anyway (as I did in drop_monitor), I wasn't sure if we _should_.
> 
> It seemed to me that for experimentation, especially if your driver is a
> module, it might be easier to allow this?
> 
> That said, I don't have any strong feelings about it, and I have some
> bugs here anyway so I can just add that.
> 
> We _could_ also keep a check for the core subsystem, but not sure that's
> worth it?

Checking the top bits should be good enough to catch uninitialized
values, and discourage out-of-tree shenanigans, I'd hope.
