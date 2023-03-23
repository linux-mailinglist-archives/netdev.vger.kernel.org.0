Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 853436C5E8E
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 06:14:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbjCWFOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 01:14:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230086AbjCWFOh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 01:14:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 753471815C;
        Wed, 22 Mar 2023 22:14:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1094A623EE;
        Thu, 23 Mar 2023 05:14:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1EB3C433D2;
        Thu, 23 Mar 2023 05:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679548475;
        bh=TnjZCeJI5b3jMHKYCdpYkBRkO+Paeps2Jyb4HkRRQ4s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pvAdSmDoH41n+055xbz5GvMexPPvayVlPt5OaE9ad19cUO2t3GqfBkctkcx93tefG
         EQEyAEZfntwG6i10YI7O7YaRqVRe40sMga0NK7vtPS6QbvPtelt8oXQHjBrqzegqKk
         sAwfCMKINJFZU0+vpK37ftCdsOhKhEWR08Kn1jWpookkbJU+uuq8WiB9qWlc4l6Lnm
         ZWLOJRGlK0Si/IjtcL19Ew1YKYnDJGSS0V0LKsA0NrsEOsRN+E+mx+N/nLisgRxrej
         fmiElReLPGvhLpb2TP+jqWXDXJ3T7m1mkfoASs2PoVWuLphgX5QUfxlhH3m1zFuPW3
         grWg++yspy7tQ==
Date:   Wed, 22 Mar 2023 22:14:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     arinc9.unal@gmail.com
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net 2/3] net: dsa: mt7530: move lowering TRGMII driving
 to mt7530_setup()
Message-ID: <20230322221433.21c3e9f0@kernel.org>
In-Reply-To: <20230320190520.124513-2-arinc.unal@arinc9.com>
References: <20230320190520.124513-1-arinc.unal@arinc9.com>
        <20230320190520.124513-2-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Mar 2023 22:05:19 +0300 arinc9.unal@gmail.com wrote:
> I asked this before, MT7530 DSA driver maintainers, please explain the code
> I mentioned on the second paragraph.
> 
> I intend to send a patch to remove the maintainers, Sean Wang, Landen Chao
> DENG Qingfang, listed on the MAINTAINERS file and change the status to
> orphan if none of them respond to this question or review the patches.

Sounds fair. 
