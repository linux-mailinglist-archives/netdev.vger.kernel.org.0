Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B398963E8BB
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 05:05:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbiLAEE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 23:04:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiLAEEz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 23:04:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14275248E2;
        Wed, 30 Nov 2022 20:04:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D4F361E4A;
        Thu,  1 Dec 2022 04:04:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7627DC433D6;
        Thu,  1 Dec 2022 04:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669867491;
        bh=EPdW05P55lMKP/JeZFTchTXxTXKlzmdkR+oRDlY20Eg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JppnfDSG2mArJ+47PiN5NIulDD/yNFgM3c2DNw0IWg35vEJt6vhZ97Fnzvs7aS+YX
         D8hbG/+ruTZG/NxuqaQIz62VUUBfErG0LYioDCXJJfQrkszOp86T1YHJ60xJBRECm3
         1u8fVtKtp5KzCsqnFAtftCRn+FmnddUHZMXg1XK+eNDbVjk35Fe9fmADsXQp3+iq21
         Bsz61wOBUeNuRL0X85sksnAvhkRQeSDybThUXesTQR7m7ZHpLpZf1023b1wPqHDrT+
         woMTPQ09fFcM3oKQ5B9FsgoQ+gjMfMCkKZovxOzqCMx7hV4NSMUsW7sutBHLtPY3GO
         SawrmzWD3iqzw==
Date:   Wed, 30 Nov 2022 20:04:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Howells <dhowells@redhat.com>
Cc:     netdev@vger.kernel.org, Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 01/35] rxrpc: Implement an in-kernel rxperf
 server for testing purposes
Message-ID: <20221130200450.0d9db737@kernel.org>
In-Reply-To: <166982726601.621383.15475080589217572083.stgit@warthog.procyon.org.uk>
References: <166982725699.621383.2358362793992993374.stgit@warthog.procyon.org.uk>
        <166982726601.621383.15475080589217572083.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Nov 2022 16:54:26 +0000 David Howells wrote:
> Implement an in-kernel rxperf server to allow kernel-based rxrpc services
> to be tested directly, unlike with AFS where they're accessed by the
> fileserver when the latter decides it wants to.
> 
> This is implemented as a module that, if loaded, opens UDP port 7009
> (afs3-rmtsys) and listens on it for incoming calls.  Calls can be generated
> using the rxperf command shipped with OpenAFS, for example.

This one generates a build warning on 32bit x86, type mismatch in min().
