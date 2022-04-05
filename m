Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2944F53B2
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 06:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2361266AbiDFEZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 00:25:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356225AbiDEUtr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 16:49:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3320EF9FB0;
        Tue,  5 Apr 2022 13:23:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4DD8B81FCB;
        Tue,  5 Apr 2022 20:23:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04ED9C385A0;
        Tue,  5 Apr 2022 20:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649190235;
        bh=+h8ZzTU60u7YqBVIktB8t5HoId/6yDAI8cwBhdE5rx4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YRmQIurrg8g5lOoNCeCLHV8pjFQHFNKpKutlj3rwqbZWrX585/wHFcvVjJ4XJIAzi
         o/asCoEHFHp1cTaZ5qunmw75i6CKLx43dv0ndUo2K0+1NT1hIU/2bMQNvkpC1rczaT
         5DlGx/gyqkWSCXSgYY57BaZYOlidksTeY4WJA3FpWCW6fBj9r3Vwebc3kCnWAqoeL9
         m9pD6t43Kx1ct23VNg8pnqvj5WAPFTxrUBYA1RPrXq1y3knRF58FzRfd0GQ70E1fj9
         3mQQDQ5vmJ7fPiDnSzuW3EakOch9qTx/cV+mArhWMSaQ3kLVK5058ifLwydjTNf3jE
         H9c/3NJHaQrzw==
Date:   Tue, 5 Apr 2022 13:23:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Tom Rix <trix@redhat.com>, idosch@nvidia.com, petrm@nvidia.com,
        davem@davemloft.net, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mlxsw: spectrum_router: simplify list unwinding
Message-ID: <20220405132353.00e7cb5e@kernel.org>
In-Reply-To: <Ykmcu5y4Tx8pqhtQ@shredder>
References: <20220402121516.2750284-1-trix@redhat.com>
        <Ykmcu5y4Tx8pqhtQ@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 3 Apr 2022 16:10:19 +0300 Ido Schimmel wrote:
> On Sat, Apr 02, 2022 at 08:15:16AM -0400, Tom Rix wrote:
> > The setting of i here
> > err_nexthop6_group_get:
> > 	i = nrt6;
> > Is redundant, i is already nrt6.  So remove
> > this statement.
> > 
> > The for loop for the unwinding
> > err_rt6_create:
> > 	for (i--; i >= 0; i--) {
> > Is equivelent to
> > 	for (; i > 0; i--) {
> > 
> > Two consecutive labels can be reduced to one.
> > 
> > Signed-off-by: Tom Rix <trix@redhat.com>  
> 
> For net-next:
> 
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>

Now 6f2f36e5f932 ("mlxsw: spectrum_router: simplify list unwinding")
Thanks!
