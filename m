Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33D8558715D
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 21:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233882AbiHATZG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 15:25:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbiHATZE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 15:25:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E27A2B260;
        Mon,  1 Aug 2022 12:25:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3D257B8165B;
        Mon,  1 Aug 2022 19:25:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D33BC433C1;
        Mon,  1 Aug 2022 19:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659381900;
        bh=EkphSiEPzZcfk1if8b0j8p5iyfVhuflocYAWfz/z4jI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oLk/fb5Z4LqluhUn1lzqmrUPZhINv+0erHHu2lr2aBqjlzCs8KYabeefJUDajb9ot
         2GsUuYcob+13QutflZnujP5bAxLMOzdAJN4egobeOkRNJrle6al3NKc4WaVcS6ECdC
         sc+GipKrf4QP+tAFSENHJuCyhzRHB2injSWWm3B4PLkvsQ/T3hd44gLoKd/bKO9vez
         PcNcTvtQZIFjh5OBogxYMKxjqmtwAye81cipadY4M7nDUfvZfWl6HMxPyF/+P1I2Oi
         vnJ+g4H4+TLiphqQvyxwm4BJ+zm+AhsRyxfyK5COHptwWSSH7547i1oo/Zx9Y/zTvH
         +qwYyPjnsRlHQ==
Date:   Mon, 1 Aug 2022 12:24:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] tls: rx: Fix less than zero check on unsigned
 variable sz
Message-ID: <20220801122459.57b7df02@kernel.org>
In-Reply-To: <20220730114027.142376-1-colin.i.king@gmail.com>
References: <20220730114027.142376-1-colin.i.king@gmail.com>
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

On Sat, 30 Jul 2022 12:40:27 +0100 Colin Ian King wrote:
> Variable sz is declared as an unsigned size_t and is being checked
> for an less than zero error return on a call to tls_rx_msg_size.
> Fix this by making sz an int.
> 
> Fixes: 84c61fe1a75b ("tls: rx: do not use the standard strparser")
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>  net/tls/tls_strp.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

Already fixed 2 days before you posted, I guess linux-next lagged.

commit 8fd1e151779285b211e7184e9237bba69bd74386
Author:     Yang Li <yang.lee@linux.alibaba.com>
AuthorDate: Wed Jul 27 20:10:19 2022
Commit:     Jakub Kicinski <kuba@kernel.org>
CommitDate: Thu Jul 28 21:50:39 2022

    tls: rx: Fix unsigned comparison with less than zero
