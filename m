Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32FEE58586D
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 06:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239792AbiG3EUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jul 2022 00:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239832AbiG3EUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jul 2022 00:20:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A0EBB66
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 21:20:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65EA5B82A44
        for <netdev@vger.kernel.org>; Sat, 30 Jul 2022 04:20:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A41B3C433C1;
        Sat, 30 Jul 2022 04:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659154806;
        bh=dFnfVyFc/HaIjhG2EfyWVDlcnjOhu+VGQy2xUJ4rxks=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mB17uia+GkDSDD9ZvcMdkshTes5t49DTrEy3rYThk17pDW4TnyERjyglmurcvlNHN
         RML5bRxix/o0Wg7tDu17a2k+Gg+Cy6Tq9Cx+VEkH90b9B5HFv0nJeWtdPNTBHMqvtx
         vkmXnZcqzQAJbXLT88qyc2YRf52v62gLKrYMtoU9KZZYtsDhdHF94UD50aQt6aXe97
         OPy22E48NvKa7NH7E92cF1E7m+pKTUc3KlyPtOwGDftAOtnVrITzLC9J35rsKmkZDJ
         sqw07JXTb62QxTFSYT0uZbXVunOuUgaUFdQ8afiAitGILliOnnCUbfuJfWu19sDr85
         yyFfIhE1gqJLA==
Date:   Fri, 29 Jul 2022 21:20:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Subbaraya Sundeep <sbhatta@marvell.com>
Cc:     <davem@davemloft.net>, <pabeni@redhat.com>, <edumazet@google.com>,
        <sgoutham@marvell.com>, <netdev@vger.kernel.org>,
        Suman Ghosh <sumang@marvell.com>
Subject: Re: [net v3 PATCH 3/5] octeontx2-af: Allow mkex profiles without
 dmac.
Message-ID: <20220729212004.7ca3f250@kernel.org>
In-Reply-To: <1659109430-31748-4-git-send-email-sbhatta@marvell.com>
References: <1659109430-31748-1-git-send-email-sbhatta@marvell.com>
        <1659109430-31748-4-git-send-email-sbhatta@marvell.com>
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

On Fri, 29 Jul 2022 21:13:48 +0530 Subbaraya Sundeep wrote:
> It is possible to have custom mkex profiles which do not extract
> DMAC into the key to free up space in the key and use it for L3
> or L4 packet fields. Current code bails out if DMAC extraction is
> not present in the key. This patch fixes it by allowing profiles
> without DMAC and also supports installing rules based on L2MB bit
> set by hardware for multicast and broadcast packets.
> 
> This patch also adds debugging prints needed to identify profiles
> with wrong configuration.

I had some questions about whether this is regression fix or new
feature and the size of this patch - which do not seem to have been
addressed.
