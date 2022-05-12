Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36D1D525213
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 18:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352551AbiELQGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 12:06:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352442AbiELQGm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 12:06:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 931B7266051;
        Thu, 12 May 2022 09:06:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E85B61F72;
        Thu, 12 May 2022 16:06:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 347EDC385B8;
        Thu, 12 May 2022 16:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652371600;
        bh=DrSC0OB90Zt28VeZRaStAIYyW0aDYHkAcj25LE262pM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=emY8umTkPi8XXPj3Sh+8T4NbtojPlrY5lmYAloP3IB+uyZ8wkEq9+dkFze5tlmlE8
         OtadHEH40564WNFYwiX70KyAdzNSD/wUHJTz6UO9REGV876RCgbmIcUPVf4cSz7FVv
         gVdA0x6gT8cZ6jGt2/SCUkwBygaUzxHnDPiSdWAHyccE+vfXsg9jOfK1ahxKRbTSD5
         /W5z0y2I/6FQhmvBwN27ZxderKu6ACx/drhL+9dmOgmzUuBaJwpRPYxWlgq1l3Xs0s
         t+x1CW2xB/c3xZtzC14k+AVZK32BaehlUb82KnY/2nmvXq2kTGkFNxbZOaZ79b4das
         eO0n8xDZdbYLA==
Date:   Thu, 12 May 2022 09:06:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Guangguan Wang <guangguan.wang@linux.alibaba.com>
Cc:     Tony Lu <tonylu@linux.alibaba.com>, kgraul@linux.ibm.com,
        davem@davemloft.net, pabeni@redhat.com, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/2] net/smc: non blocking recvmsg() return
 -EAGAIN when no data and signal_pending
Message-ID: <20220512090638.0fbe7710@kernel.org>
In-Reply-To: <9be49a5a-c87d-1630-3ff3-90e6a233d38b@linux.alibaba.com>
References: <20220512031156.74054-1-guangguan.wang@linux.alibaba.com>
        <20220512031156.74054-2-guangguan.wang@linux.alibaba.com>
        <YnyCblJuPf+UAvjY@TonyMac-Alibaba>
        <9be49a5a-c87d-1630-3ff3-90e6a233d38b@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 May 2022 11:51:22 +0800 Guangguan Wang wrote:
> On 2022/5/12 11:43, Tony Lu wrote:
> > On Thu, May 12, 2022 at 11:11:55AM +0800, Guangguan Wang wrote: =20
> >> Non blocking sendmsg will return -EAGAIN when any signal pending
> >> and no send space left, while non blocking recvmsg return -EINTR
> >> when signal pending and no data received. This may makes confused.
> >> As TCP returns -EAGAIN in the conditions described above. Align the
> >> behavior of smc with TCP.
> >>
> >> Fixes: 846e344eb722 ("net/smc: add receive timeout check")
> >> Signed-off-by: Guangguan Wang <guangguan.wang@linux.alibaba.com>
> >> Reviewed-by: Tony Lu <tonylu@linux.alibaba.com> =20
> >=20
> > I see that you have already sent this patch to net, so this patch is a
> > duplicate. There is no need to send it again to net-next.
>=20
> Ok, just ignore it. Thanks=EF=BC=81

You gotta repost just patch 2, then. Please wait until net and net-next
get merged before sending (or 12h if you don't know how to figure out if
that already happened ;))
