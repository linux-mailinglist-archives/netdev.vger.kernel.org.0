Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F5536489C5
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 22:00:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbiLIVAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 16:00:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbiLIVAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 16:00:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C455AC6D2;
        Fri,  9 Dec 2022 13:00:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15E3062330;
        Fri,  9 Dec 2022 21:00:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E5D1C433D2;
        Fri,  9 Dec 2022 21:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670619602;
        bh=2MugyXTNvGR+qgEA01wvWM6b7L+kgzTZQA/IHzWGAfs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IwSc28BnBklKGAJJlBSI6pPUoT9Y4egmUDP3gumdpBjW8/nzA8Afd1kfXedqGAbSC
         PmtU9SyU7uNqKDklgeIyHVi5EMiWcUA81DXL0ua9HrY/zVQf9Zc+Ss2lWrwi18uI/V
         42eLpBhVmxFHRydV3iixf0Niz+WYIMsac8hbAXVTvzTSlGekzpVHR9Bk2aJ5d0LhhL
         g9pL4vEQputpwvmz675OLpPnKYInw843I/OQL9cAf8A1MQTZJ2O/OB7NySSEOmyNeJ
         dY6BifNwT4jBXSztQ7NucfsB+9Omabmg+FKPZzuzVMlXL+6Coyyc9kXAUC1GB/LPXF
         UKuFXKUgi53wQ==
Date:   Fri, 9 Dec 2022 13:00:01 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com
Subject: Re: [PULL] Networking for v6.1 final / v6.1-rc9 (with the diff stat
 :S)
Message-ID: <20221209130001.0f90f7f8@kernel.org>
In-Reply-To: <CAHk-=wji_NB6hO+35Ruty3DjQkZ+0MkAG9RZpfXNTiWv4NZH3w@mail.gmail.com>
References: <20221208205639.1799257-1-kuba@kernel.org>
        <20221208210009.1799399-1-kuba@kernel.org>
        <CAHk-=wji_NB6hO+35Ruty3DjQkZ+0MkAG9RZpfXNTiWv4NZH3w@mail.gmail.com>
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

On Fri, 9 Dec 2022 10:25:09 -0800 Linus Torvalds wrote:
> > There is an outstanding regression in BPF / Peter's static calls stuff,  
> 
> Looks like it's not related to the static calls. Jiri says that
> reverting that static call change makes no difference, and currently
> suspects a RCU race instead:
> 
>   https://lore.kernel.org/bpf/Y5M9P95l85oMHki9@krava/T/#t
> 
> Hmm?

Yes. I can't quickly grok how the static call changes impacted 
the locking. I'll poke the BPF people to give us a sense of urgency.
IDK how likely it is to get hold of Peter Z..
