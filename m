Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEAAD5873EA
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 00:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235345AbiHAW1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 18:27:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232527AbiHAW1P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 18:27:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9153443E68
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 15:27:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0BD8960DEB
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 22:27:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 275B3C433D6;
        Mon,  1 Aug 2022 22:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659392832;
        bh=DdUaZ+1VaFs3X1pjird/eZp0u7+v7e1uOkPRR6DR2Aw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sXhbJWkYQW5b2N/nz6dAHTqVyxBoTGZUchtRdfFTwXsMWmTB2YoYVhmA1mn0qNiZm
         djYbsY1fxrlGcuzgTHuqH7bFSrpZOSSXeO5DnH9UxNrZzUKM4qWAhF04YmA5IlDGw7
         La4h7YhWZs0Yk/8yTLDrZxFa8PwFSBx1izpUBSU4QpsLB+aNIAKn1i3INc4yiU4+E/
         yHgX1cdM1Dn3csLZhasaUrChP32j47JUArqECRgpmCAoVNs1uDdacN4P4Vmb+pnH0d
         W6BuM1G7nbjMUol5u7g1VBO2NSESlEZFzjKoTo1MT7kG83NVFh2bMGxG/flljaA6Zg
         XLFLXvUnAAndQ==
Date:   Mon, 1 Aug 2022 15:27:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marek Majkowski <marek@cloudflare.com>
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        edumazet@google.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        pabeni@redhat.com
Subject: Re: [PATCH net-next] When using syscookies initial receive window
 calculation uses wrong MSS
Message-ID: <20220801152711.5c00aa8c@kernel.org>
In-Reply-To: <20220729161932.2543584-1-marek@cloudflare.com>
References: <20220729161932.2543584-1-marek@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 Jul 2022 18:19:32 +0200 Marek Majkowski wrote:
> Usually it's not a big deal but could yield weird/wrong
> rcv_ssthresh initial values. 

Feels like we should either make it a proper fix or fold into 
the RTAX_INITRWND series?
