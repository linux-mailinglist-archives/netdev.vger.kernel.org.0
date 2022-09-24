Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC405E8D8D
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 16:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233603AbiIXOvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Sep 2022 10:51:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232138AbiIXOvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Sep 2022 10:51:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB1293B700;
        Sat, 24 Sep 2022 07:51:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 582E961261;
        Sat, 24 Sep 2022 14:51:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF485C433D7;
        Sat, 24 Sep 2022 14:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664031070;
        bh=V+z2ZxfJa/HIqj8ztFdh4ZNMoVb/OXAUUcB9+H7UUKY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rut2W+r4XjkruOkNGAm10IlL0euxcwI6NDQx6Wcwn9DVztzLLNXSKs0gYBuYYRcTI
         LG4HfKa/Ywam38bRhtFnDsMy2HEhxy9S2JSemPIKNzg+YYW8Ef1UnjcCjGChdWEnYU
         7w5ue5Z1nDXaUbKh8O8l82to6pmfdKw8BzGjm25zDTED9Lg9QT/qxNWcuzaTABZhqo
         P1ShpNwfAQsEIy46FOeoAx9lzoWIN2NKGk63oyRN6Jknmr8+N+z3rUnmEaHHRRaBfb
         Y4/pj/xejSANlC36FmYey4Po3uUbKAa01020ySYgaCxQOvst1IC7BGIR/zuHSBIVsu
         qMC4KBxvnt1QQ==
Date:   Sat, 24 Sep 2022 07:51:08 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
        pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com,
        memxor@gmail.com
Subject: Re: [PATCH v3 bpf-next 2/3] net: netfilter: add bpf_ct_set_nat_info
 kfunc helper
Message-ID: <Yy8ZXFoWYIE0qpWp@dev-arch.thelio-3990X>
References: <cover.1663778601.git.lorenzo@kernel.org>
 <9567db2fdfa5bebe7b7cc5870f7a34549418b4fc.1663778601.git.lorenzo@kernel.org>
 <Yy4mVv+4X/Tm3TK4@dev-arch.thelio-3990X>
 <Yy4xGT7XGGredCB2@lore-desk>
 <Yy7ltMthyiWn/cYM@lore-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yy7ltMthyiWn/cYM@lore-desk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 24, 2022 at 01:10:44PM +0200, Lorenzo Bianconi wrote:
> > > Hi Lorenzo,
> > 
> > Hi Nathan,
> > 
> > > 
> > > On Wed, Sep 21, 2022 at 06:48:26PM +0200, Lorenzo Bianconi wrote:
> > > > Introduce bpf_ct_set_nat_info kfunc helper in order to set source and
> > > > destination nat addresses/ports in a new allocated ct entry not inserted
> > > > in the connection tracking table yet.
> > > > 
> > > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > 
> > > This commit is now in -next as commit 0fabd2aa199f ("net: netfilter: add
> > > bpf_ct_set_nat_info kfunc helper"). Unfortunately, it introduces a
> > > circular dependency when I build with my distribution's (Arch Linux)
> > > configuration:
> > > 
> > > $ curl -LSso .config https://github.com/archlinux/svntogit-packages/raw/packages/linux/trunk/config
> > > 
> > > $ make -skj"$(nproc)" INSTALL_MOD_PATH=rootfs INSTALL_MOD_STRIP=1 olddefconfig all modules_install
> > > ...
> > > WARN: multiple IDs found for 'nf_conn': 99333, 114119 - using 99333
> > > WARN: multiple IDs found for 'nf_conn': 99333, 115663 - using 99333
> > > WARN: multiple IDs found for 'nf_conn': 99333, 117330 - using 99333
> > > WARN: multiple IDs found for 'nf_conn': 99333, 119583 - using 99333
> > > depmod: ERROR: Cycle detected: nf_conntrack -> nf_nat -> nf_conntrack
> > > depmod: ERROR: Found 2 modules in dependency cycles!
> > 
> > I guess the issue occurs when we compile both nf_conntrack and nf_nat as module
> > since now we introduced the dependency "nf_conntrack -> nf_nat".
> > Discussing with Kumar, in order to fix it, we can move bpf_ct_set_nat_info() in
> > nf_nat module (with some required registration code similar to register_nf_conntrack_bpf()).
> > What do you think?
> > Sorry for the inconvenience.
> 
> Hi Nathan,
> 
> this is a PoC of what I described above:
> https://github.com/LorenzoBianconi/bpf-next/commit/765d32dd08e56f5059532845e70d0bbfe4badda1

Thanks, that appears to resolve the error for me!

Tested-by: Nathan Chancellor <nathan@kernel.org>

> Regards,
> Lorenzo
> 
> > 
> > Regards,
> > Lorenzo
> > 
> > 
> > > ...
> > > 
> > > The WARN lines are there before this change but I figured they were
> > > worth including anyways, in case they factor in here.
> > > 
> > > If there is any more information I can provide or patches I can test,
> > > please let me know!
> > > 
> > > Cheers,
> > > Nathan
> 
> 


