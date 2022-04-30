Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED0C5159C5
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 04:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240157AbiD3CTD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 22:19:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382048AbiD3CTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 22:19:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F6253DDD9
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 19:15:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 170FD624C5
        for <netdev@vger.kernel.org>; Sat, 30 Apr 2022 02:15:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46276C385A7;
        Sat, 30 Apr 2022 02:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651284940;
        bh=OsdEY1hwH2taEphSKg15pcEuEBCqqhvscOfCGMeBBQA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jtOb1IbDt2Zc4uzSmBeD/kazYn22f/R0WhdF4uqTNvnEH5Y0hSY8QG0nGDRAZPlrs
         6IYTUvVl0DXK7IjOXxhZAAnM0+s6MbZALioNrjXPvyV4hZtTyXRhVZ+W9nZprMeXhY
         3sBcz2x5fqGKYcRT8P5+lH0iCm2nCh0y6TkmDfJhCNifCBw0sN+7RCZOT7jWivuWf1
         AgLVelLGgVWlSQu8DkPKobNdAv88Xixz94+vh6olE2xxsk8NteGshnj4ipTH/zzzae
         cdLNc8BENZdrJCGhD5SdnnWOfn59sT1BEcUhCH316Qy0swVefZevj39StcUlG1/vpi
         58ZgBXjPahyDQ==
Date:   Fri, 29 Apr 2022 19:15:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>
Subject: Re: [PATCH v3] tcp: pass back data left in socket after receive
Message-ID: <20220429191538.713da873@kernel.org>
In-Reply-To: <650c22ca-cffc-0255-9a05-2413a1e20826@kernel.dk>
References: <650c22ca-cffc-0255-9a05-2413a1e20826@kernel.dk>
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

On Thu, 28 Apr 2022 18:45:06 -0600 Jens Axboe wrote:
> This is currently done for CMSG_INQ, add an ability to do so via struct
> msghdr as well and have CMSG_INQ use that too. If the caller sets
> msghdr->msg_get_inq, then we'll pass back the hint in msghdr->msg_inq.
> 
> Rearrange struct msghdr a bit so we can add this member while shrinking
> it at the same time. On a 64-bit build, it was 96 bytes before this
> change and 88 bytes afterwards.
> 
> Reviewed-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Commit f94fd25cb0aa ("tcp: pass back data left in socket after
receive") in net-next now, thanks!
