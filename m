Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4A64BA57
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 15:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729642AbfFSNmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 09:42:52 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:50065 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726330AbfFSNmw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 09:42:52 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id D837C22371;
        Wed, 19 Jun 2019 09:42:50 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 19 Jun 2019 09:42:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=0z874X
        IbEoU1zgqyVPQZYDchNO0JEbah55jVm3pylWw=; b=eF3AODqBeZGKqFMtbMkrfG
        3MQX8a+izuNZ2MRgI693t68iNL7m2alvO4PJKpwAqd0psEpWMNCC2lZ1IDZ5+RJ1
        FOpaAKT3ApzjH6Tj7NDKeRridPOtJ0jPZoHz7m0oicbPSwnRYXv7++S4tkyzFiEt
        yWoWUSGomFi8nlwvrN0A/6pWWWXcbgaSUfGnFQWZeMYAzn9MdYHOH1D+zpVnhCdJ
        bXWqBjUbanBzw/JSWdmCo+HpLmdYyGiecsaKcQBqisD4KozrDySrwHGhZfvztLYH
        4GE7aln4KqrFM8SiPZpZqWaZ8P3OiLFlVwr1ThUe6z5eAeDZxQAIuZLIRKOe6JWQ
        ==
X-ME-Sender: <xms:2TsKXfsACg1AXH8Q6tTWyI2PFPETJX9ymyBMLqtqMPkpmGyUervKNQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrtddvgdegudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucffohhmrghinh
    epkhgvrhhnvghlrdhorhhgnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghr
    rghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhush
    htvghrufhiiigvpedt
X-ME-Proxy: <xmx:2TsKXT1Bi6gTDk2sb8aMEGoZ1S7DOby127_eJqFbTPSD92Hw8UcFqg>
    <xmx:2TsKXeCnKhs7Qv_1YWzezL_7wX-eGtKPJINEemXolTfyE2bVvus1Zw>
    <xmx:2TsKXfspOR0RVJxAdRH2gs-PdoI7Wb11l3YIdnnbni5_WqGsmcVgCw>
    <xmx:2jsKXSXhlPmGkZ6865qZ25rdhzN9CCBP2vGYhky8x82f317KZpCElg>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id CB7EE8005B;
        Wed, 19 Jun 2019 09:42:48 -0400 (EDT)
Date:   Wed, 19 Jun 2019 16:42:46 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Jiri Pirko <jiri@mellanox.com>, Ido Schimmel <idosch@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Shalom Toledo <shalomt@mellanox.com>,
        Petr Machata <petrm@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mlxsw: spectrum_ptp: fix 32-bit build
Message-ID: <20190619134246.GA26214@splinter>
References: <20190619133128.2259960-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190619133128.2259960-1-arnd@arndb.de>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 19, 2019 at 03:31:20PM +0200, Arnd Bergmann wrote:
> On 32-bit architectures, we cannot easily device 64-bit numbers:
> 
> ERROR: "__aeabi_uldivmod" [drivers/net/ethernet/mellanox/mlxsw/mlxsw_spectrum.ko] undefined!
> 
> Use do_div() to annotate the fact that we know this is an
> expensive operation.
> 
> Fixes: 992aa864dca0 ("mlxsw: spectrum_ptp: Add implementation for physical hardware clock operations")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Arnd, thanks for the patch. We already patched this issue yesterday:
https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/commit/?id=cd4bb2a3344cb53d9234cca232edfb2dce0f0a35
