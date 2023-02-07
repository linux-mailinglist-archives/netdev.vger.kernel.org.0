Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E42C568D4FD
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 12:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbjBGLAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 06:00:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbjBGLAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 06:00:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FB832A9AE;
        Tue,  7 Feb 2023 03:00:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B37EC6130D;
        Tue,  7 Feb 2023 11:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1200CC433D2;
        Tue,  7 Feb 2023 11:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675767618;
        bh=uXDqiP/EEOsn26MCkEE+Xmwl7tj7nwBTMTAymU2YJQc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HVSaskIhrgM/xao1OQx16Oz9nPcvOqW/61EI01xYAsxMPK8YOAbRTQruGc1ijv/5J
         meJuEC6hbE5D3vy29QGVtFt/p/O04kW/xiWp78Zmz0Zd8bUpymHD5GDIb/PhChs3RN
         PUox56o5pdSbscXEEdmXUuykZbn449mSZCh1zO3njrIfiR571faCVNrca99zQzsSzA
         6RYU8MsEXAZt8dY2xVkMmh+a2gkTnpvP6a5Xnev9Jdx5S+1TadR8LRI3fTD/M0BES3
         FxUqO9QcBjus//AknvRVXhebvi6iAryO5u46ZYg4v+aKMczdYgbHjXmKtPCFog0eee
         GZk5BW/Be00vw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DBC96E55F07;
        Tue,  7 Feb 2023 11:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: mt7530: don't change PVC_EG_TAG when CPU port
 becomes VLAN-aware
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167576761789.20941.3807568418401527275.git-patchwork-notify@kernel.org>
Date:   Tue, 07 Feb 2023 11:00:17 +0000
References: <20230205140713.1609281-1-vladimir.oltean@nxp.com>
In-Reply-To: <20230205140713.1609281-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, sean.wang@mediatek.com,
        Landen.Chao@mediatek.com, dqfext@gmail.com, andrew@lunn.ch,
        f.fainelli@gmail.com, matthias.bgg@gmail.com,
        angelogioacchino.delregno@collabora.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, frank-w@public-files.de
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Sun,  5 Feb 2023 16:07:13 +0200 you wrote:
> Frank reports that in a mt7530 setup where some ports are standalone and
> some are in a VLAN-aware bridge, 8021q uppers of the standalone ports
> lose their VLAN tag on xmit, as seen by the link partner.
> 
> This seems to occur because once the other ports join the VLAN-aware
> bridge, mt7530_port_vlan_filtering() also calls
> mt7530_port_set_vlan_aware(ds, cpu_dp->index), and this affects the way
> that the switch processes the traffic of the standalone port.
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: mt7530: don't change PVC_EG_TAG when CPU port becomes VLAN-aware
    https://git.kernel.org/netdev/net/c/0b6d6425103a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


