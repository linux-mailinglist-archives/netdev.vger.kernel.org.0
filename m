Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE6B2EBDC8
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 13:34:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbhAFMei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 07:34:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:60966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725803AbhAFMei (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 07:34:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE3E2205F4;
        Wed,  6 Jan 2021 12:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609936437;
        bh=8FGyiL2jGqXsk0u/hqAOGZI69RLiaDd8eqnzqQDHjy4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=f40hESyP5r/EHJItiMShIH5xpg82DFfQSupM85X3tlDkYEE7dgM9DTj5w0u8lvrVS
         Lom4QpOVpdzejkCnjIVwiycRE+PJcAxqff9WS94QYnSAiyluA2+xTfgU0ZVrELYK4z
         Aqo8651mNidzzW+fh5BYv8e+EnWGgQxwPHkbVK16AzUxydcvkBHy80QJh7PVt1Z8/I
         m4gXhWjYBiDiyrNPKwDqD1KXS+5ur+qMyLwQNkckDqaK3YuD7T1KHqnb5ywtn6qIzY
         +rDzcYLB/rmYNx8BPtZMLPz8nqi6R40mgqOHmFjyQFJB4HFlcx8E781Xs87YUSnUG2
         XZypeRBNOuHIA==
Date:   Wed, 6 Jan 2021 13:33:28 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Sven Auhagen <sven.auhagen@voleatech.de>, netdev@vger.kernel.org,
        davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        Matteo Croce <mcroce@microsoft.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: Re: [PATCH net-next] net: mvpp2: increase MTU limit when XDP
 enabled
Message-ID: <20210106133328.25766204@kernel.org>
In-Reply-To: <20210106133205.617dddd8@kernel.org>
References: <20210105171921.8022-1-kabel@kernel.org>
        <20210105172437.5bd2wypkfw775a4v@svensmacbookair.sven.lan>
        <20210105184308.1d2b7253@kernel.org>
        <X/TKNlir5Cyimjn3@lunn.ch>
        <20210106125608.5f6fab6f@kernel.org>
        <20210106133205.617dddd8@kernel.org>
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 6 Jan 2021 13:32:05 +0100
Marek Beh=C3=BAn <kabel@kernel.org> wrote:

> On Wed, 6 Jan 2021 12:56:08 +0100
> Marek Beh=C3=BAn <kabel@kernel.org> wrote:
>=20
> > I also to write a simple NAT masquerading program. I think XDP can
> > increase NAT throughput to 2.5gbps as well.
>=20
> BTW currently if XDP modifies the packet, it has to modify the
> checksums accordingly. There is a helper for that even, bpf_csum_diff.

(from L3 forwards, if you modify ethhdr, you don't have to modify L2
checksum. You can't even see it...)
