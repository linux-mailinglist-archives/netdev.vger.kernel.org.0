Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85F7158F094
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 18:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231854AbiHJQmV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 12:42:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233174AbiHJQmM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 12:42:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3000E654D;
        Wed, 10 Aug 2022 09:42:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74B0FB81DDF;
        Wed, 10 Aug 2022 16:42:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C202DC433D6;
        Wed, 10 Aug 2022 16:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660149728;
        bh=eCOtvMscSi4cHBDSAd7FmKCM1cDGiJfNa83trMk9xPg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HO5gRSiR9oyMHBFFyBJisSTxtRl9PkkT7XTYfJc5vaIFny6mZTmWUdv3D/VOSvia2
         uMguoROvvzpORs9RJ3ASfZAgrwJxBINgDHGbviaKuwvaA93DcqEKambJwSLZKthqEp
         FTV4Fj4s2KPQF2k5RWf7L+oFwdd4uPKa+5QNbFRRo8nBvy9k84BbFGWkE+NmfOB2v+
         jvAW35WcizxguKWMXZ9TS9FjqwBaSTxL0tYiUVwp5o17U/nML081OYXmGPU/Z4j9a0
         il4srWfkVDyDpQzpLSijse1etDO1u9GZclKN78OCiqkQzMyCbM0UZARvtAlm2yc56y
         crnQpNo70LmcQ==
Date:   Wed, 10 Aug 2022 09:42:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Jiri Slaby <jirislaby@kernel.org>, davem@davemloft.net,
        pabeni@redhat.com, netdev@vger.kernel.org,
        Chas Williams <3chas3@gmail.com>,
        linux-atm-general@lists.sourceforge.net,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH net-next 3/6] net: atm: remove support for ZeitNet
 ZN122x ATM devices
Message-ID: <20220810094206.36dcfca8@kernel.org>
In-Reply-To: <CAK8P3a01yfeg-3QO=MeDG7JzXEsTGxK+vMpFJ83SGwPto4AOxw@mail.gmail.com>
References: <20220426175436.417283-1-kuba@kernel.org>
        <20220426175436.417283-4-kuba@kernel.org>
        <8576aef3-37e4-8bae-bab5-08f82a78efd3@kernel.org>
        <CAK8P3a01yfeg-3QO=MeDG7JzXEsTGxK+vMpFJ83SGwPto4AOxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 10 Aug 2022 11:11:32 +0200 Arnd Bergmann wrote:
> > This unfortunately breaks linux-atm:
> > zntune.c:18:10: fatal error: linux/atm_zatm.h: No such file or directory
> >
> > The source does also:
> > ioctl(s,ZATM_SETPOOL,&sioc)
> > ioctl(s,zero ? ZATM_GETPOOLZ : ZATM_GETPOOL,&sioc)
> > etc.
> >
> > So we should likely revert the below:  
> 
> I suppose there is no chance of also getting the linux-atm package updated
> to not include those source files, right? The last release I found on
> sourceforge
> is 12 years old, but maybe I was looking in the wrong place.

Is linux-atm used for something remotely modern? PPPoA? Maybe it's 
time to ditch it completely? I'll send the revert in any case.
