Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47843394E39
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 23:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbhE2VLz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 May 2021 17:11:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:36310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229838AbhE2VLy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 May 2021 17:11:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3334160E0C;
        Sat, 29 May 2021 21:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622322617;
        bh=kPOCKx/zTn/NmFc1kL+PgSDyUFkW/Vq68SbDb16b5Lg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FSpsU1Ne2F1/FQpxdAyBVutgMoWjgKS5ECjra2lGB0egIKp4tXlnn/Nj4/zYB+dcu
         96ysM/MsMfk8ZywwNQiExxk0JrAghS1P9MdINAPcBX1aL8E4mmaDSFp0AVPa6HOJ9y
         m/QAwjBqoGjCnnkY7CtQlb1dGedAsTKKNhVRCn8RDZWqkGkK0RwcIXAZPXrsKohhBd
         uzLYUVuOmuEJ4N6Q2rwvUeCit+fGMfEGSRxNh1drwmY5YKGSt6vZMMX4XdKUDIfcT5
         fSIDkNZ92e66LaJEFyyrSd2Nsk8qIRTauRv54I5TKPUJsLLJmtQ9Dz7HtcxMah4Z6S
         4dcD1xeBDvioQ==
Date:   Sat, 29 May 2021 14:10:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, tom@herbertland.com
Subject: Re: [PATCH net-next v4 0/5] Support for the IOAM Pre-allocated
 Trace with IPv6
Message-ID: <20210529141016.4015a396@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20210527151652.16074-1-justin.iurman@uliege.be>
References: <20210527151652.16074-1-justin.iurman@uliege.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 May 2021 17:16:47 +0200 Justin Iurman wrote:
> In-situ Operations, Administration, and Maintenance (IOAM) records
> operational and telemetry information in a packet while it traverses
> a path between two points in an IOAM domain. It is defined in
> draft-ietf-ippm-ioam-data [1]. IOAM data fields can be encapsulated
> into a variety of protocols. The IPv6 encapsulation is defined in
> draft-ietf-ippm-ioam-ipv6-options [2], via extension headers. IOAM
> can be used to complement OAM mechanisms based on e.g. ICMP or other
> types of probe packets.
> 
> This patchset implements support for the Pre-allocated Trace, carried
> by a Hop-by-Hop. Therefore, a new IPv6 Hop-by-Hop TLV option is
> introduced, see IANA [3]. The three other IOAM options are not included
> in this patchset (Incremental Trace, Proof-of-Transit and Edge-to-Edge).
> The main idea behind the IOAM Pre-allocated Trace is that a node
> pre-allocates some room in packets for IOAM data. Then, each IOAM node
> on the path will insert its data. There exist several interesting use-
> cases, e.g. Fast failure detection/isolation or Smart service selection.
> Another killer use-case is what we have called Cross-Layer Telemetry,
> see the demo video on its repository [4], that aims to make the entire
> stack (L2/L3 -> L7) visible for distributed tracing tools (e.g. Jaeger),
> instead of the current L5 -> L7 limited view. So, basically, this is a
> nice feature for the Linux Kernel.

Some coding comments from me. Please continue the discussion with David
re: maturity of the RFC and make sure to CC him and Yoshifuji on next
versions.
