Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C35A066BFD2
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 14:31:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbjAPNb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 08:31:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbjAPNb1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 08:31:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41056B77F;
        Mon, 16 Jan 2023 05:31:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 039F7B80E90;
        Mon, 16 Jan 2023 13:31:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 008D5C433D2;
        Mon, 16 Jan 2023 13:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673875883;
        bh=qPUBxUXK2GS1PEFHaWB30Wa1xJGfN6u8M0tQhMj7ZJM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=amx9IsfXvgQ1Jy104SsPx7bm8BWVKd0z/6jVPkJmWfJ4ImJ7KVUccPsv2d99NJeBh
         Jy0N2p6r0ZgIKMMI3rquHvmMJ6YTA13rAlil3ol4+OZ6KzgcXxwKtYbeJzmETTTsM+
         jreHbQaEZ5cdSQnM07XOMbtCI2AExtcU+yoEP+oFnDIM15Y4tFdKpgme3CLDKObIkk
         pdyWW+Gj3kpfOODcCn9edLAg12e33iI6E9FEH9n3WmMy17DZGfUggJZ1GWMKRXJeeX
         lRxFgIe76nciW3DLSbV95tKhgZ77sDbyFea2rLiokJzDqQL4ed7jxpP6OxA34/P87u
         htnlO+1HdCCyA==
Date:   Mon, 16 Jan 2023 15:31:19 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     yang.yang29@zte.com.cn, aspriel@gmail.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        sha-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, xu.panda@zte.com.cn
Subject: Re: [PATCH net-next] brcm80211: use strscpy() to instead of strncpy()
Message-ID: <Y8VRpzodki/YAcvC@unreal>
References: <202212231037210142246@zte.com.cn>
 <167387451256.32134.6493247488948126794.kvalo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167387451256.32134.6493247488948126794.kvalo@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 16, 2023 at 01:08:36PM +0000, Kalle Valo wrote:
> <yang.yang29@zte.com.cn> wrote:
> 
> > From: Xu Panda <xu.panda@zte.com.cn>
> > 
> > The implementation of strscpy() is more robust and safer.
> > That's now the recommended way to copy NUL-terminated strings.
> > 
> > Signed-off-by: Xu Panda <xu.panda@zte.com.cn>
> > Signed-off-by: Yang Yang <yang.yang29@zte.com>
> 
> Mismatch email in From and Signed-off-by lines:
> 
> From: <yang.yang29@zte.com.cn>
> Signed-off-by: Yang Yang <yang.yang29@zte.com>
> 
> Patch set to Changes Requested.

Kalle, please be aware of this response
https://lore.kernel.org/netdev/20230113112817.623f58fa@kernel.org/

"I don't trust that you know what you're doing. So please don't send
any more strncpy() -> strscpy() conversions for networking."

Thanks

> 
> -- 
> https://patchwork.kernel.org/project/linux-wireless/patch/202212231037210142246@zte.com.cn/
> 
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
> 
