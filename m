Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EAAC6BDDC6
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 01:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbjCQAmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 20:42:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjCQAmc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 20:42:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7EB369218
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 17:42:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A284BB823B3
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 00:42:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E1FFC4339B;
        Fri, 17 Mar 2023 00:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679013748;
        bh=P87j8k4ZcZxAk0kWzPE6thadYWkBYwSPurzw4GpQH54=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fuOkzOCWGkVd552cNFi5xcAeDoXUOKB/EPB7Y21BlFIc8ihQjpWrJPiTX0APX+Q2y
         MwZDWDWkF5TdZaexYJX7YRTBBS0oTMc5uWs58vJ7WULe3zUYRn0xxb7BUQ/LqV06Tp
         jt6XQ/9w5zoSdPUKTrMS2K9D2LzlVT0PisLg/Hz281ZwPKNclUombJpfG+F9j+hztq
         M9Rzg4m5P6Nnj7DSbIsKCUTN1gBrU94fYkfShhgj8i5neEC6oWsKx4fK0Vv+QhzTtO
         wt5zv/Adp3tAbC+DIU9BJGwYFYcgHHLJR1tz+XjCaVx6QYRvTo7eggSt3V4pPgRrzQ
         ELhlchB8D2mmw==
Date:   Thu, 16 Mar 2023 17:42:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     joshwash@google.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH net] gve: Cache link_speed value from device
Message-ID: <20230316174227.6f38803a@kernel.org>
In-Reply-To: <20230315174016.4193015-1-joshwash@google.com>
References: <20230315174016.4193015-1-joshwash@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Mar 2023 10:40:16 -0700 joshwash@google.com wrote:
> From: Joshua Washington <joshwash@google.com>
> 
> The link speed is never changed for the uptime of a VM. Caching the
> value will allow for better performance.
> 
> Fixes: 7e074d5a76ca ("gve: Enable Link Speed Reporting in the driver.")

If it needs to go in as a fix / to stable we need a bit more info about
the nature of the problem. What user-visible (or hypervisor-visible)
impact will be?  What entity needs link info so often that it becomes
a problem?

The code looks fine as an optimization, i.e. for net-next, but you say
"PATCH net" and there's a Fixes tag...
