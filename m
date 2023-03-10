Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 707116B36F6
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 07:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbjCJG56 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 01:57:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbjCJG5h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 01:57:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9438105F39;
        Thu,  9 Mar 2023 22:57:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F13E0B821BE;
        Fri, 10 Mar 2023 06:57:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 313C2C4339B;
        Fri, 10 Mar 2023 06:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678431431;
        bh=znZU5YKV5/tr94Mn/anv8wqsM1ocNElvGuGexz0++JU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=E2ka8xkQoAJf71fR68m51EtHqdlGxXnTv79eA4jG5B793KJfQ4daVuRk3ragzsG08
         OoNrknNax77dGcy893F4+pzFq0N3j9nqQxtnaW9xRlJaoFfBSbpIUFMaJOlOXu0T6V
         s756P+S7m1+U6wyqSwXtH4UpBwv37FxaTSQ+VzBTlFmiUVYX/LOGCMR4mxWzmzJh06
         4JJDnZBWuairGImMZCkZIIRBf0hGOXM0TjUdodQPfCxwy4Efh9mIlzupTbiagdtAqZ
         zYc31GyVRQKC4DPcNWvHHVnoF1RJpGDDig2pCBZ0kqt2e/4XcwvnBHt8mDo4j4yJkL
         m5HH1wtOC/4tA==
Date:   Thu, 9 Mar 2023 22:57:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maxim Korotkov <korotkov.maxim.s@gmail.com>
Cc:     Rasesh Mody <rmody@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Chan <mchan@broadcom.com>,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lvc-project@linuxtesting.org
Subject: Re: [PATCH net-next] bnx2: remove deadcode in bnx2_init_cpus()
Message-ID: <20230309225710.78cd606c@kernel.org>
In-Reply-To: <20230309174231.3135-1-korotkov.maxim.s@gmail.com>
References: <20230309174231.3135-1-korotkov.maxim.s@gmail.com>
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

On Thu,  9 Mar 2023 20:42:31 +0300 Maxim Korotkov wrote:
> The load_cpu_fw function has no error return code
> and always returns zero. Checking the value returned by
> this function does not make sense.
> As a result, bnx2_init_cpus() will also return only zero
> Therefore, it will be safe to change the type of functions
> to void and remove checking

True, but you need to tell the reader why you're making the change.
One of the impossible-to-hit error handling paths is missing unwind
or some such?
