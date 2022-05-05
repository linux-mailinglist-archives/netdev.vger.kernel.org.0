Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1370051CC5C
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 00:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345530AbiEEWzd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 18:55:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234694AbiEEWzb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 18:55:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4659A527FD
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 15:51:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA53E61F70
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 22:51:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EFE2C385B1;
        Thu,  5 May 2022 22:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651791110;
        bh=NW3P4J7Vf7LcbTGXRdEkpbB4vVnJ5jhsXjdkymoZXME=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=f+UPvxpk5eOc1rFlpG5Q8FXvrxcnqae8ruE7AH8R1CmCLX8rhdlz2vx4e/enDtYL7
         O+dt/YAh3bEx0I+MHb46l+djZUPplYLRrjOv/qfcIhH16QCFLaW4KepHSjkQ3d95Sn
         VH09UTlT7v7aPtyYaRWiS5It0V1eTDGQSUE0LKzcY7Mkh3Zy8NwNETFltWjVRS4fXv
         poj+A8ksVDhrRwnV4A0oydjuge080n1nWJ83JeeLTOt1Ab2p5qv4Lsr+hTjL2awYl0
         dTNHVIsCJhZzhMODfwMTfSG2OdFz+jI3lpHt0YGDIHsRnAfpb7Kg1dJGCbmZShxDtM
         7OqslHxvPy54w==
Date:   Thu, 5 May 2022 15:51:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eyal Birger <eyal.birger@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        asml.silence@gmail.com, aahringo@redhat.com, weiwan@google.com,
        fw@strlen.de, yangbo.lu@nxp.com, tglx@linutronix.de,
        dsahern@kernel.org, lnx.erin@gmail.com, mkl@pengutronix.de,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: align SO_RCVMARK required privileges with
 SO_MARK
Message-ID: <20220505155148.77dd4ca3@kernel.org>
In-Reply-To: <20220504095459.2663513-1-eyal.birger@gmail.com>
References: <20220504095459.2663513-1-eyal.birger@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  4 May 2022 12:54:59 +0300 Eyal Birger wrote:
> The commit referenced in the "Fixes" tag added the SO_RCVMARK socket
> option for receiving the skb mark in the ancillary data.
> 
> Since this is a new capability, and exposes admin configured details
> regarding the underlying network setup to sockets, let's align the
> needed capabilities with those of SO_MARK.
> 
> Fixes: 6fd1d51cfa25 ("net: SO_RCVMARK socket option for SO_MARK with recvmsg()")
> Signed-off-by: Eyal Birger <eyal.birger@gmail.com>

It's not really as bad as the ability to set the mark, but since 
Erin is not complaining I assume it's fine with their use case.
