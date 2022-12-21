Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0460A6530F9
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 13:42:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231617AbiLUMmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 07:42:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231991AbiLUMmG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 07:42:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 760A922BD0;
        Wed, 21 Dec 2022 04:42:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BCE59B81B08;
        Wed, 21 Dec 2022 12:42:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAC34C433EF;
        Wed, 21 Dec 2022 12:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671626522;
        bh=gQUFpEO6Bldd7g3YthL9Gzsvs+Z4eFoaLG9TyOi5QPY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hXPp7+hBYdB1DUfU5s9xr/o6OB4LsGlmipuTFugx9ufNhcSR3yHDYK74aGJEmekvH
         BBdojzzMb3poEm32umegR7l+3tWVAUQ8NmB/LGUrYRwdbWezgYNoWNIdpOXks1qiZv
         cOeHe6ZSkcX61WFsp6lAxE2Q+ORL3R7WQXYYCJy0=
Date:   Wed, 21 Dec 2022 13:41:59 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tudor Ambarus <tudor.ambarus@linaro.org>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>, mst@redhat.com,
        jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        edumazet@google.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, willemb@google.com,
        syzkaller@googlegroups.com, liuhangbin@gmail.com,
        linux-kernel@vger.kernel.org, joneslee@google.com
Subject: Re: kernel BUG in __skb_gso_segment
Message-ID: <Y6L/F2Hwm7BRdYj8@kroah.com>
References: <82b18028-7246-9af9-c992-528a0e77f6ba@linaro.org>
 <CAF=yD-KEwVnH6PRyxbJZt4iGfKasadYwU_6_V+hHW2s+ZqFNcw@mail.gmail.com>
 <a13f83f3-737d-1bfe-c9ef-031a6cd4d131@linaro.org>
 <Y6K3q6Bo3wwC57bK@kroah.com>
 <fc60e8da-1187-ca2b-1aa8-28e01ea2769a@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc60e8da-1187-ca2b-1aa8-28e01ea2769a@linaro.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 21, 2022 at 09:42:59AM +0200, Tudor Ambarus wrote:
> 
> 
> On 21.12.2022 09:37, Greg KH wrote:
> > On Wed, Dec 21, 2022 at 09:28:16AM +0200, Tudor Ambarus wrote:
> > > Hi,
> > > 
> > > I added Greg KH to the thread, maybe he can shed some light on whether
> > > new support can be marked as fixes and backported to stable. The rules
> > > on what kind of patches are accepted into the -stable tree don't mention
> > > new support:
> > > https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> > 
> > As you say, we don't take new features into older kernels.  Unless they
> > fix a reported problem, if so, submit the git ids to us and we will be
> > glad to review them.
> > 
> 
> They do fix a bug. I'm taking care of it. Shall I update
> Documentation/process/stable-kernel-rules.rst to mention this rule as
> well?

How exactly would you change it, and why?
