Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC8560D6D4
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 00:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231909AbiJYWK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 18:10:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232638AbiJYWKg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 18:10:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AF21625F6
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 15:10:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E048061A9F
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 22:10:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10E97C433C1;
        Tue, 25 Oct 2022 22:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666735832;
        bh=Jm1599y91t0xsPPI2QyOnOPXvrWIcfIWbmTYMryzsEI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=G37hPaHerxi5c3Pw5TR78sWF3oUof6pugEgP8xNh2xaeKA0pQY77+H7TM/t60J5e3
         3nuW5qwx3inqp+Dw4KUd+1ShjgdKqHsJOOgHS8hrs9FmWItJLaMfTKPWDfLWPHxQg3
         VJ5Hl4H+5NQXJJDbVhMl4bZOr40KndeJflnCnL3f8tp4/PfyU5ad6j6epcAZ72nnzz
         +4S9Ejqq7z+P0lAcldWiSroLy2iZYynjbqYugu7AfXCVmbgoDLJpVEKtf/jrEfsYFe
         LPsA2THAhzhxBWXnYEaNg2mLnMof7U980E2lQp0afRMVwAt/vJM202uTw89929igEI
         6wz40eDADb42Q==
Date:   Tue, 25 Oct 2022 15:10:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nick Child <nnac123@linux.ibm.com>
Cc:     netdev@vger.kernel.org, nick.child@ibm.com, dave.taht@gmail.com
Subject: Re: [RFC PATCH net-next 0/1] ibmveth: Implement BQL
Message-ID: <20221025151031.67f06127@kernel.org>
In-Reply-To: <b4492820-a2d5-7f86-75e4-cb344e050a8f@linux.ibm.com>
References: <20221024213828.320219-1-nnac123@linux.ibm.com>
        <20221025114148.1bcf194b@kernel.org>
        <b4492820-a2d5-7f86-75e4-cb344e050a8f@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Oct 2022 15:03:03 -0500 Nick Child wrote:
> Th qdisc is default pfifo_fast.

You need a more advanced qdisc to seen an effect. Try fq.
BQL tries to keep the NIC queue (fifo) as short as possible
to hold packets in the qdisc. But if the qdisc is also just
a fifo there's no practical difference.

I have no practical experience with BQL on virtualized NICs 
tho, so unsure what gains you should expect to see..
