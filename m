Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C25601C00F1
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 17:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbgD3P5u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 11:57:50 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:50901 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726420AbgD3P5u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 11:57:50 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 5B53D87C;
        Thu, 30 Apr 2020 11:57:49 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 30 Apr 2020 11:57:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=KALLKX
        Jw6PszKdVDnPzpoMAy7qra0xYV8ojuu9kkgbI=; b=N4d11yXAmmw2n6ezNfUyi8
        fHk7K3XhR3++GmTjzuFaYiAyshzuP4wE58SjPOm+md0qQZT7KrNGdXDQY+VZrY1z
        ZO17h985WLQJ6dAr5zrAx0c2KoyV0pGuvKTz2pFrbrJzOM1ZPGkV2642yG0Wsv67
        VqO85RqvD0t15Ep5FC7QbqMTd+BqdRDGerruvXswuct30Z6Bah/SAgRMK/PKLW4h
        Z5aCqcO8kGm4hsfBr+CUG0pZQJHh1S0R0z3H7EI6jMTFsnh17xGs6kwTjMIOpH4e
        xJm1za4/4UAHuJUfztp+IbQDez8eRiiZLaggwxbNi2H+kMnRRP+mUCeAc3iLxSHw
        ==
X-ME-Sender: <xms:fPWqXiDsm6-e8HSXE0_JMuIcBICNOppP-zY3kGZJDfD0M0fCl6yVug>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrieehgdelgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necukfhppeejledrudektddrheegrdduudeinecuvehluhhsthgvrhfuihiivgepudenuc
    frrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:fPWqXt7gIqvP6x4_B4bFRHppMhRRfBw8gifbI5TL34PTSH8kFamHhg>
    <xmx:fPWqXu3xP6BBW53ZOTb_in8bVLhUVvd1TYLv18tZiZU1nqGvNDCfrg>
    <xmx:fPWqXpCmBz-Q0coOzlKck1SjVubsuf-WGEYbAsGLn7IlU_LAVY7Ymg>
    <xmx:ffWqXuUHxVv76s6fi_2lMDNK4TrbcjSRNAWB2pJzTHzBDlLb-L_O8w>
Received: from localhost (bzq-79-180-54-116.red.bezeqint.net [79.180.54.116])
        by mail.messagingengine.com (Postfix) with ESMTPA id C6F353065F2E;
        Thu, 30 Apr 2020 11:57:47 -0400 (EDT)
Date:   Thu, 30 Apr 2020 18:57:44 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc:     roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        davem@davemloft.net,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>, netdev@vger.kernel.org
Subject: Re: BUG: soft lockup while deleting tap interface from vlan aware
 bridge
Message-ID: <20200430155744.GB4076599@splinter>
References: <85b1e301-8189-540b-b4bf-d0902e74becc@profihost.ag>
 <20200430105551.GA4068275@splinter>
 <8be48925-4e09-fe9c-6d8c-8675ede5fce7@profihost.ag>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8be48925-4e09-fe9c-6d8c-8675ede5fce7@profihost.ag>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 30, 2020 at 03:18:18PM +0200, Stefan Priebe - Profihost AG wrote:
> Great! This indeed solves the problem.

Thanks for reporting and testing!
