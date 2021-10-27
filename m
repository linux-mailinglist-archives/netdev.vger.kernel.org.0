Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5A943C4E6
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 10:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238798AbhJ0ITH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 04:19:07 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:51529 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231715AbhJ0ITH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 04:19:07 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 1B7C258041D;
        Wed, 27 Oct 2021 04:16:42 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 27 Oct 2021 04:16:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=JtuJqq
        Y23rcol/towiKKl+J/LdEhOnMpOw6UCqLwaj4=; b=SGhwE/k9dl8BsjwvnX/R5d
        6tXEKx/2RzS0D092QpXgxY1WfahSxNs/LPD8oPLz6KIR5/yyJ7+9ZPROxS9EJcAG
        FtmH5ajiufMjoJdJdk00ZbQ+rjeH5EXmi0rLhsPR35sUYvWYnm6ABCiauYQv33JW
        bo85Jw8erhGA+K0e0g/Kpmve6fc2xbLI3QNf6uVPnlLEUM++HiC8sZ7GDhkT4e8a
        eE5HtbAVYGEiejWWhIKjTd2zXxHdtvmerezxa2/dcFBmS2FhHOuOsUvMjRLN8TwN
        X0XgkQ9VL6S3fkKIPoVinGYKALWrEHVXpEkQYF8zmoCd5DwG5HrVdAjo5xmA+zxw
        ==
X-ME-Sender: <xms:6Qp5YfuBZa6bvjSLVDebGFgC-LDy3DoKeL609ec-Dec4UsiuDiPlpA>
    <xme:6Qp5YQf2WTmBaXk78XrMhX-JZEs60Zx1AyGmAfxHy8_1WtZe910Ntwln9C4vAM8u5
    jH4oZEyFzyepjY>
X-ME-Received: <xmr:6Qp5YSxjLBZsOzDPpga0yNXJMH_gl691i1wYDeurnou-oKGDvMUsnzt8sBj8JLRhfzDumXjiJmpBWYWwZLYH762_3WrNmg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvdegtdcutefuodetggdotefrodftvfcurf
    hrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgthhhi
    mhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvghrnh
    eptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleetnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:6Qp5YeMtcysikLGmvT7bnGu-taBtxriQoTmwsnxyL_0xJSQ3nadgMw>
    <xmx:6Qp5Yf8_zF6YWK-_kOwkUIN6bT9qOPYruedbVVV0ZsXTgb89pEsA9Q>
    <xmx:6Qp5YeX1cIB9qRy69eVUeEQl_Q235H2zQqgubTqZ6Mfe1lZkRbt9Gw>
    <xmx:6gp5YQ3QTtpgheJzvnKwpS1BBNTCYLBh1NYVy6iVXsJ-MICF1SW2RQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 27 Oct 2021 04:16:40 -0400 (EDT)
Date:   Wed, 27 Oct 2021 11:16:38 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, nikolay@nvidia.com
Cc:     netdev@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next 6/8] net: bridge: move br_fdb_replay inside
 br_switchdev.c
Message-ID: <YXkK5jp7FHwJEeuw@shredder>
References: <20211026142743.1298877-1-vladimir.oltean@nxp.com>
 <20211026142743.1298877-7-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211026142743.1298877-7-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 05:27:41PM +0300, Vladimir Oltean wrote:
> br_fdb_replay is only called from switchdev code paths, so it makes
> sense to be disabled if switchdev is not enabled in the first place.
> 
> As opposed to br_mdb_replay and br_vlan_replay which might be turned off
> depending on bridge support for multicast and VLANs, FDB support is
> always on. So moving br_mdb_replay and br_vlan_replay inside
> br_switchdev.c would mean adding some #ifdef's in br_switchdev.c, so we
> keep those where they are.

TBH, for consistency with br_mdb_replay() and br_vlan_replay(), it would
have been good to keep it where it is, but ...

> 
> The reason for the movement is that in future changes there will be some
> code reuse between br_switchdev_fdb_notify and br_fdb_replay.

this seems like a good reason, so:

Reviewed-by: Ido Schimmel <idosch@nvidia.com>

Nik, WDYT?
