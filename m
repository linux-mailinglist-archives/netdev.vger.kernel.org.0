Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94E1E57263B
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 21:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234652AbiGLTpq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 15:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234634AbiGLTpU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 15:45:20 -0400
Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42C5A1DA7F;
        Tue, 12 Jul 2022 12:33:57 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id E54A9C01D; Tue, 12 Jul 2022 21:33:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1657654435; bh=LGQQkiza9LfOe3zwnoXujUyEmTxk9MeMXoKdKZeUyZs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wfCToj5nuXaYmYSMYLAj0CruufU69ML6vk7Aes6qdjpsXOazG/rU+TfZJs/y9mJYw
         RJiej2c1fWsHAjb7rS5vqPNIoFagPUD0uNt2YHCt5uQaPgm8EQGx6N+LLEleioYz8p
         335P0n3t24k8WjJncZJn/jZ+gxv8aCzwLAlZi8adhjkBOa3JCrPYUvGITj9kQB1uJO
         FxYwEo8BCbkCgZFgSXH0b/xvV06s4ndxDuAgbc5k1tvkvZoqLUiFqUo1fwGDiuHkml
         Q0McKtgCvl04UUi3+zn/XiJsljqdh4CQN3nNCP1pw4ENfTmIkGAzOr/duZdURHZfE/
         2yrtcj5eNrkMA==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 62E8EC009;
        Tue, 12 Jul 2022 21:33:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1657654434; bh=LGQQkiza9LfOe3zwnoXujUyEmTxk9MeMXoKdKZeUyZs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=y1zmZC62w5J7Ur8UwSAENJD8Xdk+KDAozmN7VRrtFrRMPE3nd+uvmMTyTulFVlY+J
         F0wl4eo7j8RPGicz0Mf18JYUGw4Y2nmHLb9puVGqXa1yEF4DDpdansCPP5nVm5VCru
         2M5WvgZgw0Y3hAw4tkS+1tmxIVWenRF3Q1psVhIpT8Re19BzwPWvIv8m2B5IwcA9fP
         2YSe4PuGRs5V8sFe7zPk//XVrjZ08K7BQwKf+qriWdeRFhGOS7Xkoks4rIzjBFCtUW
         +2LrX1r8cgbbr6CsslLomTEq8ds8TYFjkugmClXFSYgj2wfT+vQus8YrNxCiEn+1H6
         nML+Xal00/4mg==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 4845bb4d;
        Tue, 12 Jul 2022 19:33:50 +0000 (UTC)
Date:   Wed, 13 Jul 2022 04:33:35 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Christian Schoenebeck <linux_oss@crudebyte.com>
Cc:     v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Nikolay Kichukov <nikolay@oldum.net>
Subject: Re: [PATCH v5 11/11] net/9p: allocate appropriate reduced message
 buffers
Message-ID: <Ys3Mj+SgWLzhQGWK@codewreck.org>
References: <cover.1657636554.git.linux_oss@crudebyte.com>
 <5fb0bcc402e032cbc0779f428be5797cddfd291c.1657636554.git.linux_oss@crudebyte.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5fb0bcc402e032cbc0779f428be5797cddfd291c.1657636554.git.linux_oss@crudebyte.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christian Schoenebeck wrote on Tue, Jul 12, 2022 at 04:31:36PM +0200:
> So far 'msize' was simply used for all 9p message types, which is far
> too much and slowed down performance tremendously with large values
> for user configurable 'msize' option.
> 
> Let's stop this waste by using the new p9_msg_buf_size() function for
> allocating more appropriate, smaller buffers according to what is
> actually sent over the wire.
> 
> Only exception: RDMA transport is currently excluded from this, as
> it would not cope with it. [1]
> 
> Link: https://lore.kernel.org/all/YkmVI6pqTuMD8dVi@codewreck.org/ [1]
> Signed-off-by: Christian Schoenebeck <linux_oss@crudebyte.com>
> ---
> 
> Is the !strcmp(c->trans_mod->name, "rdma") check in this patch maybe a bit
> too hack-ish? Should there rather be transport API extension instead?

hmm yeah that doesn't feel great, let's add a flag to struct
p9_trans_module

--
Dominique
