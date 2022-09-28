Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82ED05EDA4A
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 12:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233396AbiI1KoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 06:44:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233181AbiI1KoI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 06:44:08 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E4798FD4F;
        Wed, 28 Sep 2022 03:44:04 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 7E4ADC023; Wed, 28 Sep 2022 12:44:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1664361841; bh=EvXbEFxQNdXNjXs7AJIIbkBlKOTDWURW3rNF1wbER1E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vokmBuvKdWBfIpUbwZ7i/3q2hrKrm2wEuzat92Z1AF/zj0D9kzGs09EGTskVFdcp5
         RPctkXOosyC+QnxuVv7WYeNd3iV1fOi1S1z04oEABiRdNqGvKeIypr0AUEKcHcklGS
         U6Fn4YT6mTUbezR3aOe0sszkBSqEdaxHsKBirFEvegr40psAIcHiDGj2r1fhSb91Xj
         IeZoNjbpSsW3AsJEo1YNp8NSpG+dAtbGYSFRZodtaZqE2GQOrtxNAGyZvdsLUvefHu
         O/6qoNFdVSYuBnvkCIOjQaW1AGyX9mlDEqbnaETdilWVqY3cKtDnlHotEici9VIHKo
         DLb2U87rc5XmA==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 0F6EFC009;
        Wed, 28 Sep 2022 12:43:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1664361839; bh=EvXbEFxQNdXNjXs7AJIIbkBlKOTDWURW3rNF1wbER1E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AXSJASx2rKt3OmXZHdDAhyLDgaBuDsRfjikOIp0W5tPVaAKfuxOGXlRUUw31K3qC4
         PnF8Gi3tOFo8OMlC7gNyMRG6Lvx369KHzi2VkpJf0LNljef6nuKFHAEWkjTxMtdNY1
         4D4ELzPTvgilOIqebWxX38SORBWA3xYRnzcOXNPCprhmYplTpH+pmjEZf9tmgl9BdQ
         yTeqVMQXOIgXz1vqdv+za4CjStU9IuuOBeCDMoUkj6h66u88a/pJPgajrUxe7uqVRM
         azi0lrDCSS5cxI2NKcLdJX/kd3dX0oNGxsWR8fBOuCjj39NJZktnx+OcrhrOmYCi0m
         PyiYOvvDBhJcA==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 9a16ec6e;
        Wed, 28 Sep 2022 10:43:53 +0000 (UTC)
Date:   Wed, 28 Sep 2022 19:43:38 +0900
From:   asmadeus@codewreck.org
To:     Leon Romanovsky <leon@kernel.org>
Cc:     syzbot <syzbot+67d13108d855f451cafc@syzkaller.appspotmail.com>,
        davem@davemloft.net, edumazet@google.com, ericvh@gmail.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux_oss@crudebyte.com, lucho@ionkov.net, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com,
        v9fs-developer@lists.sourceforge.net
Subject: Re: [syzbot] KASAN: use-after-free Read in rdma_close
Message-ID: <YzQlWq9EOi9jpy46@codewreck.org>
References: <00000000000015ac7905e97ebaed@google.com>
 <YzQc2yaDufjp+rHc@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YzQc2yaDufjp+rHc@unreal>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Leon Romanovsky wrote on Wed, Sep 28, 2022 at 01:07:23PM +0300:
> The bug is in commit 3ff51294a055 ("9p: p9_client_create: use p9_client_destroy on failure").

Thanks for looking

> It is wrong to call to p9_client_destroy() if clnt->trans_mod->create fails.

hmm that's a bit broad :)

But I agree I did get that wrong: trans_mod->close() wasn't called if
create failed.
We do want the idr_for_each_entry() that is in p9_client_destroy so
rather than revert the commit (fix a bug, create a new one..) I'd rather
split it out in an internal function that takes a 'bool close' or
something to not duplicate the rest.
(Bit of a nitpick, sure)

I'll send a patch and credit you in Reported-by unless you don't want
to.

-- 
Dominique
