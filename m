Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B03B2B521B
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 21:13:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727359AbgKPUMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 15:12:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:51120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726527AbgKPUMe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 15:12:34 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6519B21D7E;
        Mon, 16 Nov 2020 20:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605557553;
        bh=rsDDNAP7QStHKITYGKzN3atRZqTmeb4ZPqllqmP94BE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IfQLAn6d26yWdO9aHkuuDskTBbSu3f9N7swkyAmj33Dg/INRO6wITCEp+62Y4RJgm
         T1ksmjel8si46L7Tiy5o4MV1JifT539iwOpGI0rk0vxgRqBJ5cqBSZ5lSWxvyjFJXQ
         06xeXePYVD+S+sZR5CX1c38z6nAOmnAVSWB7hmEE=
Date:   Mon, 16 Nov 2020 12:12:32 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: linux-next: Tree for Nov 16 (net/core/stream.o)
Message-ID: <20201116121232.7d74b577@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <8a1d4d64-d8cf-f19b-b425-594e10f3fc5a@infradead.org>
References: <20201116175912.5f6a78d9@canb.auug.org.au>
        <8a1d4d64-d8cf-f19b-b425-594e10f3fc5a@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Nov 2020 09:46:21 -0800 Randy Dunlap wrote:
> On 11/15/20 10:59 PM, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20201113:
>
> on x86_64:
> 
> # CONFIG_INET is not set
> 
> ld: net/core/stream.o: in function `sk_stream_write_space':
> stream.c:(.text+0x68): undefined reference to `tcp_stream_memory_free'
> ld: stream.c:(.text+0x80): undefined reference to `tcp_stream_memory_free'
> ld: net/core/stream.o: in function `sk_stream_wait_memory':
> stream.c:(.text+0x5b3): undefined reference to `tcp_stream_memory_free'
> ld: stream.c:(.text+0x5c8): undefined reference to `tcp_stream_memory_free'
> ld: stream.c:(.text+0x6f8): undefined reference to `tcp_stream_memory_free'
> ld: net/core/stream.o:stream.c:(.text+0x70d): more undefined references to `tcp_stream_memory_free' follow

Must be: d3cd4924e385 ("tcp: uninline tcp_stream_memory_free()")
