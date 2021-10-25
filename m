Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47B66439DB3
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 19:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234043AbhJYRjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 13:39:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:40908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233989AbhJYRjJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 13:39:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D40F861002;
        Mon, 25 Oct 2021 17:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635183407;
        bh=A0yvu+a0hfQERnWDB3xtRdZ7jpNSkJ1bL71OsI/Xf4Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=k/VbD4e7vMOPJHUXyi6ADwnDzsPaygrNFUVDAptEzicR0xxJXqI1WUGnhwxsYaI5j
         NDEzPtzGdJDx8ddq3RX7fJN6moKvHqKlfZfVhliBJ09C9GziGG9F+3yPAzg3vvDvOM
         D8m/GNTGgKfw6O/w/GiLSoVRfwkNHnl06Gj1lexqvx/F8rGkY4bypG7/iM6S+TcMEN
         xGNsYJZQBifjTnJOP/Y0E1yFHDNz1xXVwvJOva29zOci7h6MZbcX3ZnDp07+IdnxOK
         VOCO+I7yvDwvJNKBroh9I8LFL9/fS/TTDMdCQ9rdW2RF8UJQgfRF5/HpWIdjxT509l
         1kLM6sWVlKLyg==
Date:   Mon, 25 Oct 2021 10:36:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     Dany Madden <drt@linux.ibm.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org,
        linyunsheng@huawei.com, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Antoine Tenart <atenart@kernel.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Wei Wang <weiwan@google.com>, Taehee Yoo <ap420073@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Neil Horman <nhorman@redhat.com>,
        Dust Li <dust.li@linux.alibaba.com>
Subject: Re: [PATCH net v2] napi: fix race inside napi_enable
Message-ID: <20211025103645.1c7ae135@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YXIs9GRNtNbl8MkZ@us.ibm.com>
References: <20210918085232.71436-1-xuanzhuo@linux.alibaba.com>
        <YW3t8AGxW6p261hw@us.ibm.com>
        <20211018155503.74aeaba9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <dc6902364a8f91c4292fe1c5e01b24be@imap.linux.ibm.com>
        <YXIs9GRNtNbl8MkZ@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Oct 2021 20:16:04 -0700 Sukadev Bhattiprolu wrote:
> Let us know if any other fields are of interest. Do we have any clues on
> when this started?

I think this is the first of the series of similar hard to explain
reports:

https://lore.kernel.org/all/000000000000c1524005cdeacc5f@google.com/
