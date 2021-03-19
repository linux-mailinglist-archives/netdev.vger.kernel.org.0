Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E543A341B35
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 12:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbhCSLNh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 07:13:37 -0400
Received: from mail-40134.protonmail.ch ([185.70.40.134]:63997 "EHLO
        mail-40134.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbhCSLNc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 07:13:32 -0400
Date:   Fri, 19 Mar 2021 11:13:25 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1616152408; bh=f0jBdzh822UNIDPJ7CXVNsDu6Zz6BcE8iLULPD9/gMQ=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=osxblJeHb5/ssJypOEeqeaBbYiR6woII61Klt3hS3YT5MKEhXsA6U5aqnIIxB+Xp7
         62TmMpSF22mGrd68bHEF/32bGdVMysNt4DmEtCOGVcpr6QTosYEjbk8vTuL+AyLaiP
         4RD1ywfQftgM74A5g67f+YBen8z/i7m6fQP+IgiCzWeir6VxKJxW/LjZhfA9gL42OS
         3ZdsMIxHH2snXUMoCY22O8fxxVQJF+VRSQXTbb9gSyGb0dvRUwqIGGOuosWcabA1Y/
         /7rzNWT9321jFf4EwqojOk9bB98XZloPa1ikGbCBPfgMUK5r7ghKYd4XN45nqGLN+n
         rCmBq23gZ4tAw==
To:     Paolo Abeni <pabeni@redhat.com>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Leon Romanovsky <leon@kernel.org>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH net-next 2/4] gro: add combined call_gro_receive() + INDIRECT_CALL_INET() helper
Message-ID: <20210319111315.3069-1-alobakin@pm.me>
In-Reply-To: <1ebd301832ff86cc414dd17eee0b3dfc91ff3c08.camel@redhat.com>
References: <20210318184157.700604-1-alobakin@pm.me> <20210318184157.700604-3-alobakin@pm.me> <1ebd301832ff86cc414dd17eee0b3dfc91ff3c08.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Fri, 19 Mar 2021 11:53:42 +0100

> Hello,

Hi!

> On Thu, 2021-03-18 at 18:42 +0000, Alexander Lobakin wrote:
> > call_gro_receive() is used to limit GRO recursion, but it works only
> > with callback pointers.
> > There's a combined version of call_gro_receive() + INDIRECT_CALL_2()
> > in <net/inet_common.h>, but it doesn't check for IPv6 modularity.
>
> AFAICS, ip6_offload is builtin even when IPv6 is a module, so the above
> should not be needed.

Aww, you are right. I overlooked that since dev_gro_receive() still
use INDIRECT_CALL_INET(), though all GRO callbacks were made
built-in.

Seems like more code can be optimized, thanks!

> Cheers,
>
> Paolo

Al

