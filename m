Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98E0741CC8D
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 21:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346565AbhI2TYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 15:24:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:51526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345485AbhI2TYM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 15:24:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDA326140F;
        Wed, 29 Sep 2021 19:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632943351;
        bh=LSG0Oa6o9CY35R7llBwcwZVC/IDW5bsaw1480x+C6PY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JlEUEInjdfqhzX7ETyiZlfjLzAycnBMeCpAZ7IH1MH5IqTKxlj14gadt7SlGyGXhH
         LTgonwCqNbS5QPSYL5WN1W+A+DbkvrhgkCUKsWz/gUHInvC+Lo/aIV4O57CureNBLo
         bVTO1BjfafRZk/TMx/muG3Dw34SIqVAueo8Kwo9owPawv/6wyuoWBbAA35U8RledVH
         3LHkwu02GTRosCUk7oRzOwIE+iPG6X/55GcSg604KlyBIdykjJJrEYYKIN+QAORyHb
         MA2B2Qq0j4+lOqyf4iABH5UqxzZxTtuq5xzqefFJZOocdn3gpBnaEJX0G/4bNOT+97
         LbzPgRHKIt45g==
Date:   Wed, 29 Sep 2021 12:22:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Lorenz Bauer <lmb@cloudflare.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdl?= =?UTF-8?B?bnNlbg==?= 
        <toke@redhat.com>, Lorenzo Bianconi <lorenzo@kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, shayagr@amazon.com,
        John Fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        tirthendu.sarkar@intel.com
Subject: Re: [PATCH v14 bpf-next 00/18] mvneta: introduce XDP multi-buffer
 support
Message-ID: <20210929122229.1d0c4960@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAADnVQ+XXGUxzqMdbPMYf+t_ViDkqvGDdogrmv-wH-dckzujLw@mail.gmail.com>
References: <cover.1631289870.git.lorenzo@kernel.org>
        <20210916095539.4696ae27@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CACAyw9-8t8RpJgJUTd7u6bOLnJ1xQsgK7z37QrL9T1FUaJ7WNQ@mail.gmail.com>
        <87v92jinv7.fsf@toke.dk>
        <CACAyw99S9v658UyiKz3ad4kja7rDNfYv+9VOXZHCUOtam_C8Wg@mail.gmail.com>
        <CAADnVQ+XXGUxzqMdbPMYf+t_ViDkqvGDdogrmv-wH-dckzujLw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Sep 2021 11:54:46 -0700 Alexei Starovoitov wrote:
> I'm missing something. Why do we need a separate flush() helper?
> Can't we do:
> char buf[64], *p;
> p = xdp_mb_pointer(ctx, flags, off, len, buf);
> read/write p[]
> if (p == buf)
>     xdp_store_bytes(ctx, off, buf, len, flags);

Sure we can. That's what I meant by "leave the checking to the program".
It's bike shedding at this point.
