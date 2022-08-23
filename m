Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D38F059ED25
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 22:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234196AbiHWUJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 16:09:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbiHWUJa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 16:09:30 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2343B78BC0
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 12:27:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 96241CE1F45
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 19:27:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F40ABC433D6;
        Tue, 23 Aug 2022 19:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661282869;
        bh=Awc3ZI37bLEsIc4dSynVivNdoJJk97RyMGJNJev6hlU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HZP1HfON+dOZi8/anp9+nQn22zL+YwacA5JXYmToRdzApc6Xqi92nEs7JeuybruQe
         B60BHqC3KKQXuy8cb4EiXCvPrak15Leq3/BNvcQ4+Ha+iPYBKv9rV8/wuWbmAmicmK
         qB1pdHeDgFYdU2wKTgFfc28HTzogSW3+zzQ/gy7AZ6pHURKTjhlXeQXOE9dfosg4zt
         HVMnYlKbAvxE/zAT+YYmS0ol7iwqc2nEkCzzNWC09PjBNSvybwflhJwvhOsZdnluKx
         4viCcv2iN96Uk878sszol19GOqDnpwkfwiQoSHObxXwRCduDd7pZfQ7Vn1S5NyY+ma
         r+vgvQJIy8YkQ==
Date:   Tue, 23 Aug 2022 12:27:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?SmFyb3PFgmF3IEvFgm9wb3Rlaw==?= <jkl@interduo.pl>
Cc:     netdev@vger.kernel.org
Subject: Re: Network interface - allow to set kernel default qlen value
Message-ID: <20220823122748.50cd9756@kernel.org>
In-Reply-To: <c6bce6e3-b789-0c3a-37e0-6b8d7ebc7761@interduo.pl>
References: <6cb185cf-d278-9fde-40c9-12b24332afc8@interduo.pl>
        <20220822173658.47598987@kernel.org>
        <c6bce6e3-b789-0c3a-37e0-6b8d7ebc7761@interduo.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Aug 2022 09:59:07 +0200 Jaros=C5=82aw K=C5=82opotek wrote:
> W dniu 23.08.2022 o=C2=A002:36, Jakub Kicinski pisze:
> > On Mon, 22 Aug 2022 10:41:40 +0200 Jaros=C5=82aw K=C5=82opotek wrote: =
=20
> >> Welcome netdev's,
> >> is it possible to set in kernel default (for example by sysctl) value =
of
> >> qlen parameter for network interfaces?
> >>
> >> I try to search: sysctl -a | grep qlen | grep default
> >> and didn't find anything.
> >>
> >> Now for setting the qlen - we use scripts in /etc/network/interface.
> >>
> >> This is not so important thing - but could be improved. What do You
> >> think about it? =20
> > What type of network interfaces are we talking about here?
> > Physical Ethernet links? =20
>=20
> Ethernet links - for example:
>=20
> ip a s | grep qlen
>=20
> for example:
> 119: ens16np0.1231@ens16np0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500=20
> qdisc noqueue state UP group default qlen 10000

That looks like a vlan, or some such. I don't think changing qlen with
"noqueue" does anything.
