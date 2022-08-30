Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7F435A586D
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 02:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiH3A2z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 20:28:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiH3A2y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 20:28:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 663B772FE8
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 17:28:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 040B06144C
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 00:28:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEB40C433C1;
        Tue, 30 Aug 2022 00:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661819332;
        bh=O9FzDZqZUr+TM6ZDjBmF0qYb7nq3EuHRMVHCAWL++dU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gA/ZYmOVf8JsIZUIOj68BRXPkIV9/ty3ACern/D5w6QcZKDvk6t0+EHnrSslQs1IL
         HAZIavub6jfCpbVJS0V0ifex+mkkxLcIXSvOuIxEBrCEC1Wt7DoyuWr+AVORRXSumh
         Lah4Qwwk4t4Cj11sDAHMRT7huB38zLP+1Skkhf/WafuAMvs264kAOSbzwAoX8Dh0eE
         MkzZdyBgLui98h3xgCiTvGONbYjms56tnzjwjIiULYUmWa+e1QHWx78eddoFhmTrtV
         UA5tipjJTTrm3t4SScyn9ZigZsT+CJ59z0yhkQ+bZOXIf0tLDtY56p3gV3mmwVsOBJ
         rcbA2AXAoGB4g==
Date:   Mon, 29 Aug 2022 17:28:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?w43DsWlnbw==?= Huguet <ihuguet@redhat.com>
Cc:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 2/3] sfc: support PTP over IPv6/UDP
Message-ID: <20220829172853.6717774a@kernel.org>
In-Reply-To: <CACT4ouegMFu7OZ9MQehYXH002P_Hz4OKfuObCzZ6pFOTGPUAsQ@mail.gmail.com>
References: <20220819082001.15439-1-ihuguet@redhat.com>
        <20220825090242.12848-1-ihuguet@redhat.com>
        <20220825090242.12848-3-ihuguet@redhat.com>
        <20220825183229.447ee747@kernel.org>
        <CACT4oufi28iXQscAcmrQAuiKa+PRB81-27AC4E7D41LG1uzeAg@mail.gmail.com>
        <20220826162731.5c153f7e@kernel.org>
        <CACT4ouegMFu7OZ9MQehYXH002P_Hz4OKfuObCzZ6pFOTGPUAsQ@mail.gmail.com>
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

On Mon, 29 Aug 2022 09:03:44 +0200 =C3=8D=C3=B1igo Huguet wrote:
> > We usually defer refactoring for coding style issues until someone
> > is otherwise touching the code, so surrounding code doing something
> > against the guidance may be misleading.
>=20
> Yes but I'm not sure what I should do in this case... all other
> efx_filter_xxx functions are in filter.h, so putting this one in a
> different place could make it difficult to understand how the files
> are organized. Should I put the declaration in the header (without
> `inline`) and the definition in a new filter.c file? Should I move all
> other definitions to this new file?

Hm, I see, perhaps adding a new filter.c would be too much for your set.
Let's leave the definition in the header then.

> Also, what's exactly the rule, apart from not using `inline`, to avoid
> doing the same thing again: to avoid function definitions directly in
> header files?

Not sure I'm parsing the question right, but it's okay to add small
functions in local headers. Here it seem to have only been used in
one place, and I didn't see the context.
