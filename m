Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFF926032AF
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 20:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbiJRSpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 14:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbiJRSpM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 14:45:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27B9258165
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 11:45:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A86CEB8168C
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 18:45:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40009C433D6;
        Tue, 18 Oct 2022 18:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666118703;
        bh=s/Ug0fo6TDG8LM4kIPbymRwIF4m4Sk185s//symN3hw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oS7kCzrteC4fCIRg0yXqEBYUzSqT96cpoD4F7CEi2YtfwjwV+BSmkiAYYqa1v3FIz
         96t+OB4n9T4B3Fx8GHLU+/iDScDd3GZ6JtiggQiNEllvpODG2UVvGkRasHQOOY2yW/
         pU3WvpyPZXRJS6kinf9kWRo1VOSjSFgqVy+SO+gKZJVAOZw25A5t6XwSJ7Eo1SH7WV
         BPRHSqlpy28TzzNkmUTkNjqET49h3ngp3HfJNJIoOWqqLajr8KjAFuKbCV3/ATZ7gn
         abmKU0htEnu22sP2z5Cr7a555wkuYvFRcwie69ufAp8LMOt/H8PHpsGTUMe3PO3zdh
         zzbTTq0ktRFTw==
Date:   Tue, 18 Oct 2022 11:45:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nick Child <nnac123@linux.ibm.com>
Cc:     netdev@vger.kernel.org, nick.child@ibm.com
Subject: Re: [PATCH net-next] ibmvnic: Free rwi on reset success
Message-ID: <20221018114502.1d976043@kernel.org>
In-Reply-To: <20221017151516.45430-1-nnac123@linux.ibm.com>
References: <20221017151516.45430-1-nnac123@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 Oct 2022 10:15:16 -0500 Nick Child wrote:
> Subject: [PATCH net-next] ibmvnic: Free rwi on reset success

Why net-next? it's a fix, right? it should go to Linus in the current
release cycle, i.e. the next -rc release.

Please make sure to CC the authors of the change under Fixes, and 
the maintainers of the driver. ./scripts/get_maintainer is your friend.

> Free the rwi structure in the event that the last rwi in the list
> processed successfully. The logic in commit 4f408e1fa6e1 ("ibmvnic:
> retry reset if there are no other resets") introduces an issue that
> results in a 32 byte memory leak whenever the last rwi in the list
> gets processed.
> 
> Fixes: 4f408e1fa6e1 ("ibmvnic: retry reset if there are no other resets")
> Signed-off-by: Nick Child <nnac123@linux.ibm.com>
