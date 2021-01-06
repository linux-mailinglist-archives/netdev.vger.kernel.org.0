Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F39682EBDC0
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 13:33:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726212AbhAFMdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 07:33:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:60702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726059AbhAFMdP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 07:33:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2DF28205F4;
        Wed,  6 Jan 2021 12:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609936355;
        bh=9/GkugLTa3cv5M8keAyXXAx5ge70q4LZmPRlyjF7UDE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=A2uQrUdxfLRLis2xPNCIiohy4MvHpX/ulOeWdQMoCqFR1SSo0T7F1IUxNUiMTEMvt
         LkOTnNH1aDtWmiUtEegdQiFDeJMH9dT/RT8W7x2tmq+FPK1bMcUIalDks5IOVe5/8f
         eaCGHsrrc/jMZZ6asddIo/fFGNIii+rXewz3xCiTg+GsbdF9AgI/AJrIm7xrQ5Sxym
         FUfVRWhuFONKgBEBUza9VBCG4Y0um8wERFtt/sjv9+N9B6iiUhnLJWy/BNeFw9GZ+O
         928i5Iy1NGOO+KkCbWTinKrU/Bl1nfavekm6y8ffi0lipriNB6vbJEh7Q964DkWaoQ
         QVUiiQ8Qb22ag==
Date:   Wed, 6 Jan 2021 13:32:05 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Sven Auhagen <sven.auhagen@voleatech.de>, netdev@vger.kernel.org,
        davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        Matteo Croce <mcroce@microsoft.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: Re: [PATCH net-next] net: mvpp2: increase MTU limit when XDP
 enabled
Message-ID: <20210106133205.617dddd8@kernel.org>
In-Reply-To: <20210106125608.5f6fab6f@kernel.org>
References: <20210105171921.8022-1-kabel@kernel.org>
        <20210105172437.5bd2wypkfw775a4v@svensmacbookair.sven.lan>
        <20210105184308.1d2b7253@kernel.org>
        <X/TKNlir5Cyimjn3@lunn.ch>
        <20210106125608.5f6fab6f@kernel.org>
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 6 Jan 2021 12:56:08 +0100
Marek Beh=C3=BAn <kabel@kernel.org> wrote:

> I also to write a simple NAT masquerading program. I think XDP can
> increase NAT throughput to 2.5gbps as well.

BTW currently if XDP modifies the packet, it has to modify the
checksums accordingly. There is a helper for that even, bpf_csum_diff.

But many drivers can offload csum computation, mvneta and mvpp2 for
example. But for this, somehow the XDP program has to let the driver
know what kind of csum it needs to be computed (L3, L4 TCP/UDP).

This could theoretically be communicated with the driver via metadata
prepended to the packet. But a abstraction is needed, so that every
driver does it in the same way. Maybe someone is already working on
this, I don't know...

Marek
