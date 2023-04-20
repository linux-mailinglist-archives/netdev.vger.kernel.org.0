Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8ABC6E973F
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 16:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231802AbjDTOfv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 10:35:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231784AbjDTOfv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 10:35:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02F2840EF;
        Thu, 20 Apr 2023 07:35:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 90C1864A08;
        Thu, 20 Apr 2023 14:35:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 675D8C433D2;
        Thu, 20 Apr 2023 14:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682001349;
        bh=gY4fsrxqILFWQLsDkiSerjm5DFs+2RxD+u+vD/hOMDM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dOxG0MyNNl/0/Fron+tkqVcotSd8rWpX/zZc/8CDGVzd0kmsdGvegveGoDAmJiRSo
         ZT7dxMox0G4j0SfH6B+VHJBL1y3II8ZET0H8FFpkzGiiUZPwRLHihGvmWcgUapL9vx
         0Uppg1Sv3bmJtvinoXDYsE6NKv3/9BwHdW2o5AosZClSVmUrAd1O+dPwu/WkU/4S+U
         ZqCNJgSqXnGSHDPQTw9VNL4PZOlbP2XRdiElyAS5O5fOdqWpis/IBfNUxsoKZxVvaE
         3yAT50PaZ6CZ1h9uN/ao70P+7GSpYiAeJfdB/OjrKIe0nd9tIhjDeezmADoaOFCgDM
         bPR3T/nXQ1fbA==
Date:   Thu, 20 Apr 2023 07:35:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wang Jikai <wangjikai@hust.edu.cn>
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        hust-os-kernel-patches@googlegroups.com,
        Jakub Kicinski <kubakici@wp.pl>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH 2/2] wifi: mt7601u: remove debugfs directory on
 disconnect
Message-ID: <20230420073547.43e273e8@kernel.org>
In-Reply-To: <20230420130924.8702-1-wangjikai@hust.edu.cn>
References: <20230420130924.8702-1-wangjikai@hust.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Apr 2023 13:09:24 +0000 Wang Jikai wrote:
> Debugfs is created during device init but not removed.
> Add a function mt7601u_remove_debugfs to remove debugfs
> when the device disconnects.

No, the entire wiphy dir gets recursively removed.
