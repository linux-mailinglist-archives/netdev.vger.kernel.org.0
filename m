Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEE7043C450
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 09:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240629AbhJ0HuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 03:50:06 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:48295 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240582AbhJ0HuF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 03:50:05 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailnew.nyi.internal (Postfix) with ESMTP id BA32358046F;
        Wed, 27 Oct 2021 03:47:40 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Wed, 27 Oct 2021 03:47:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=ZxRByc
        WaWD3hbjH+p1Y2c9g7a/AyrKNG1K5GSvbe9oI=; b=dHf8DgOYM8iFLx5FsWW9nO
        aCnq6ZrOR1jbOaQCxZjcvW7QM6kWx6je2UksEC67KQce2nl8o/OZaGSMKT6K3XD0
        y2QqSzNMgt+15sDxenW9NGnTxesGUVLts1pUvNsG7aYRZnDv7GTAfzUmvrZiyFYI
        PpOJeb55Ji9VVKMEQm2YBwiW2XyPhdwbVkGt3eq6qshfrQF3gGuCEZ11PkYYFmKV
        SRcninMJRCSb12EDOc4g9nkAaHxwIBd68kBYMvRjFECxTCA17Dx+gZdAfdGlCzDs
        84KomGJhPsqw5hKrzOGfsaW9lCNOvS2pZqEcrdLTVnwgbaZ3DqF6pHnT7jOCGCSQ
        ==
X-ME-Sender: <xms:GwR5YWrhSlEdRLNy4dxuBQqpjKN3mqNk72eacfNuCmUS1DbCxuimvw>
    <xme:GwR5YUpSFeXIM76FoyCSehSP74KGUWLrb4rrrhu-oOn_zIm2NeskmqCwxR3vJwHzM
    lhm-PBRDQ5PTqc>
X-ME-Received: <xmr:GwR5YbPdmrE7w5TJ9nozelrvQhRVjBuQhaVe6sTh_wqomrjdkp0TzEbB9qNViKQo8gVE42ZXvspb_a7bDFSkvRVPi3aFoA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvdefledguddukecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudeh
    leetnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:GwR5YV6jBqK2McikaGS-4WL5fhhHj0rVh2z3G35KGB0qCYWAidLHoA>
    <xmx:GwR5YV7HhU76gISsSTBI-RT1ENxSBwz4L0EYcwY3ZL-FxrF5KnaItQ>
    <xmx:GwR5YVjzom_yNKi_0OAt7QpAMI2BPdVRfyg3RgMu_sPicBY1y1w-RA>
    <xmx:HAR5YaFXo5QLzmgV0IPgTF-isUgCw3Dvaxou_G2EtO2bV_9MClailw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 27 Oct 2021 03:47:38 -0400 (EDT)
Date:   Wed, 27 Oct 2021 10:47:35 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
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
Subject: Re: [PATCH net-next 2/8] net: bridge: remove fdb_insert forward
 declaration
Message-ID: <YXkEF9ecC0y/zr5F@shredder>
References: <20211026142743.1298877-1-vladimir.oltean@nxp.com>
 <20211026142743.1298877-3-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211026142743.1298877-3-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 05:27:37PM +0300, Vladimir Oltean wrote:
> fdb_insert() has a forward declaration because its first caller,
> br_fdb_changeaddr(), is declared before fdb_create(), a function which
> fdb_insert() needs.
> 
> This patch moves the 2 functions above br_fdb_changeaddr() and deletes
> the forward declaration for fdb_insert().
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
