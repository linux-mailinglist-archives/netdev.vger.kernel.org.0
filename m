Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E25DD29E253
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 03:13:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388367AbgJ2CMn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 22:12:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40322 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726801AbgJ1VgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 17:36:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603920977;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8EYetLILv2iSD20uuLUEdI//vDe/mi6qJv8kliXEZ7E=;
        b=FBvn5jEgX8mNGnAPEE6s6SUJf3MWqd5D3+Las6KP+x+n4qWxxzXNAviU8f2YMXGdhuwzT8
        ZjyEKVlbGPuyXhWOWIj7wnSSLaKDdKu9IxkxNAc5VUaD8qBN2Osrt47jypKTPdyxATjxeW
        rEw//7+xCFkKFU9HNhkPZVqHrPSolV8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-390-Yb3ItP4OPXiTJ7byhzSvfQ-1; Wed, 28 Oct 2020 14:34:21 -0400
X-MC-Unique: Yb3ItP4OPXiTJ7byhzSvfQ-1
Received: by mail-wr1-f72.google.com with SMTP id i1so164476wrb.18
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 11:34:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8EYetLILv2iSD20uuLUEdI//vDe/mi6qJv8kliXEZ7E=;
        b=fuBJF1K/bj1ZWTyqoWH7NFGU2pqY52w+djyBruXWe+zfNIzaeYApaFEtAtAQ3hPJT2
         qQB2d1KISpxgih3oXWQUAp1zDTMrDkBw59EzrJPFNY2XgRZo7gurZJ7i3vWxyFWxKI/Y
         86gKZK9NxavtgoNvN1VAKO+HYdINIZjq9Dl57GNDkjVjuLgcWeJht/TyhOSdDFy0T5Bu
         J2fCONYqXzxU8tyaYz/QHGMFH8UkeFuUy5FKGgKmr8Pm6TpcML4ZRtBx6REd2aie5xrg
         XtvuEzTbUB87N84vcXdvZdp71ij58NE3MM4LwObKAHF5OWE2tF9LKpM457bqmWCd42PH
         3j2g==
X-Gm-Message-State: AOAM5319wJiHG/TohljF0ulpNcCriYW3SyA5Gdoel5p6+aCbUr9LNgLO
        PBHIgYT2K7se1ZU2KzfxZKUVYbn7uYSOe4tcu+0VaDBc117GpvoQT8as8vKiJaYWd++l3GCm/nC
        2kHhA8cCXG0r9l1YB
X-Received: by 2002:adf:fb0d:: with SMTP id c13mr746186wrr.19.1603910059744;
        Wed, 28 Oct 2020 11:34:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz8+7WqRo7IhbpTNfyJjQr0HKiUwZFj8C89z44CuYBYyetLqPMJT9hd9falZf3XmyKWhCmqvg==
X-Received: by 2002:adf:fb0d:: with SMTP id c13mr746170wrr.19.1603910059613;
        Wed, 28 Oct 2020 11:34:19 -0700 (PDT)
Received: from pc-2.home (2a01cb058d4f8400c9f0d639f7c74c26.ipv6.abo.wanadoo.fr. [2a01:cb05:8d4f:8400:c9f0:d639:f7c7:4c26])
        by smtp.gmail.com with ESMTPSA id p13sm528056wrt.73.2020.10.28.11.34.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 11:34:18 -0700 (PDT)
Date:   Wed, 28 Oct 2020 19:34:16 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Martin Varghese <martin.varghese@nokia.com>
Subject: Re: [PATCH net] selftests: add test script for bareudp tunnels
Message-ID: <20201028183416.GA26626@pc-2.home>
References: <72671f94d25e91903f68fa8f00678eb678855b35.1603907878.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72671f94d25e91903f68fa8f00678eb678855b35.1603907878.git.gnault@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 07:05:19PM +0100, Guillaume Nault wrote:
> Test different encapsulation modes of the bareudp module:

BTW, I was assuming that kselftests were like documentation updates,
and therefore always suitable for the net tree. If not, the patch
applies cleanly to net-next (and I can also repost of course).

