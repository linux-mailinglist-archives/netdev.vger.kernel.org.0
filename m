Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2353854B40E
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 17:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238538AbiFNPAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 11:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243828AbiFNPAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 11:00:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0E8B3EB92;
        Tue, 14 Jun 2022 08:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D6F660BC0;
        Tue, 14 Jun 2022 15:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 97390C3411D;
        Tue, 14 Jun 2022 15:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655218813;
        bh=n8t17LfQib2OBTxm1Zq8GChTXCASdroYmEVrnl7cUwg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=W3sebOj+MlFX/Tb5LS5cK4vJ/JwXJg0MMQy4KT+tRfceXWV8RfDRyRiZIwwZdhQtl
         H7f1uaYKXFL28l4YszKN7eDoHflUsQHMtI5HjSmzUXnVRakp5+/pOgOqNhC2U9+jBH
         evpVTkDUAB5LBAHMWrSErKPB+wSFysbJOzC1gvmkJ2rC7uZCXRXRH+u53Og3/pBHb8
         v/zgPrlh4OlPpoFY1v2NIGazx6/ySMGNhqQpxzL1KhHalgbQYli77VxLrjUsY4uCfr
         92YxH8VD1APbED4Q8uV/Lxi7pxjdXLzIjHU7YAZWk7Q8laFFPanOm6ixikkV7v/2yf
         I7AlvcFhtIjsg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7B804FD99FF;
        Tue, 14 Jun 2022 15:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf] xsk: fix generic transmit when completion queue
 reservation fails
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165521881350.16120.6206083063804283654.git-patchwork-notify@kernel.org>
Date:   Tue, 14 Jun 2022 15:00:13 +0000
References: <20220614070746.8871-1-ciara.loftus@intel.com>
In-Reply-To: <20220614070746.8871-1-ciara.loftus@intel.com>
To:     Ciara Loftus <ciara.loftus@intel.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, bjorn@kernel.org,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        maciej.fijalkowski@intel.com
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Tue, 14 Jun 2022 07:07:46 +0000 you wrote:
> Two points of potential failure in the generic transmit function are:
> 1. completion queue (cq) reservation failure.
> 2. skb allocation failure
> 
> Originally the cq reservation was performed first, followed by the skb
> allocation. Commit 675716400da6 ("xdp: fix possible cq entry leak")
> reversed the order because at the time there was no mechanism available to
> undo the cq reservation which could have led to possible cq entry leaks in
> the event of skb allocation failure. However if the skb allocation is
> performed first and the cq reservation then fails, the xsk skb destructor
> is called which blindly adds the skb address to the already full cq leading
> to undefined behavior.
> 
> [...]

Here is the summary with links:
  - [bpf] xsk: fix generic transmit when completion queue reservation fails
    https://git.kernel.org/bpf/bpf/c/a6e944f25cdb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


