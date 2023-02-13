Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2751B693ED5
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 08:15:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbjBMHPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 02:15:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjBMHP3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 02:15:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E8CD1AC;
        Sun, 12 Feb 2023 23:15:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02A43B80C99;
        Mon, 13 Feb 2023 07:15:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34B09C433D2;
        Mon, 13 Feb 2023 07:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676272525;
        bh=kXKrIKkF4Pu9CcKWI5PNeLrNZKIdxo0dgi5K9xPGp/w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=O1yz/Yv6oTPAWaNRVpj1JnF9ZBDsXPAH1RWSCKsTeeKJah/JH7Lr/zIowbs5fEi5j
         7i8RmsI8DPJ/Jj1iRLkUBXjhEkn67FZrgpWqQYnbPpj45/tpj557qXkCNo+4Gysp1B
         G7B/HUGPKl7EgRCYzyqnzIis8D21Fiw4GZ6IA6Z1SCTXs4OLEY73IlUNVGu6ck8K4U
         2MEAH0k/MluhGWWKoan2mnkQVfN0T4UMl4KzH4MVcQNKp2S+2G3f+ALGzmGcX21a7I
         m67tPhyzSgudF6E5ZmXwS4WHc5cVgfuqx8DNC6wUhmSKx5mvqirbuenklI5RH/6wXU
         TNitnH2k+DmCQ==
Date:   Mon, 13 Feb 2023 09:15:21 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Richard van Schagen <richard@routerhints.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Arinc Unal <arinc.unal@arinc9.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH] Fix setting up CPU and User ports to be in the correct
 mode during setup and when toggling vlan_filtering on a bridge port.
Message-ID: <Y+njic6vxAlGp72l@unreal>
References: <20230212213949.672443-1-richard@routerhints.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230212213949.672443-1-richard@routerhints.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 12, 2023 at 10:39:49PM +0100, Richard van Schagen wrote:
> ---
>  drivers/net/dsa/mt7530.c | 124 ++++++++++++++-------------------------
>  1 file changed, 43 insertions(+), 81 deletions(-)

Please read Documentation/process/submitting-patches.rst

Thanks
