Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF28621CC9
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 20:15:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbiKHTPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 14:15:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiKHTPB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 14:15:01 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B74B1C434;
        Tue,  8 Nov 2022 11:14:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 44B89CE1C7C;
        Tue,  8 Nov 2022 19:14:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83565C433D6;
        Tue,  8 Nov 2022 19:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667934896;
        bh=t3I6rmDD2mZuybABnEFHUUo7+wYWO8HgdbmqbF9+cKY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DkhKuZjBLjSRbPXOtOUhC5+N4NgToJ9YrZirjH1MAg2ZmnSXNtl6N/uCpMG6H9v++
         +vGdNtaT4inqNgISh8XJ1enqykW513XgIS/yD9MkbPsC8G8nuU6hF+yJpO2HVDdgQj
         2G6DmimMq8x1XtzvAhU75nb2AFpc6vgH7Vw4F0deNNEadHxYDsHO8N4dsOicoEQURO
         RF9wzo9N/pB5pm2zt0x/R4h3iV5xQp1zsPM37KoVT/oLTJKmQ3iDhX6Ja7Cc07t5FQ
         aUirQWfkw7LmJ8WxbanWxoAJLHupi9hx4r5NqHQH0ZknB4zqqgeSIVJc6FC4QNoLrp
         Cl4M/bz1NRwsg==
Date:   Tue, 8 Nov 2022 21:14:51 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, edumazet@google.com
Cc:     longli@microsoft.com, "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, shiraz.saleem@intel.com,
        Ajay Sharma <sharmaajay@microsoft.com>,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [Patch v10 00/12] Introduce Microsoft Azure Network Adapter
 (MANA) RDMA driver
Message-ID: <Y2qqq9/N65tfYyP0@unreal>
References: <1667502990-2559-1-git-send-email-longli@linuxonhyperv.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1667502990-2559-1-git-send-email-longli@linuxonhyperv.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 03, 2022 at 12:16:18PM -0700, longli@linuxonhyperv.com wrote:
> From: Long Li <longli@microsoft.com>
> 
> This patchset implements a RDMA driver for Microsoft Azure Network
> Adapter (MANA). In MANA, the RDMA device is modeled as an auxiliary device
> to the Ethernet device.
> 
> The first 11 patches modify the MANA Ethernet driver to support RDMA driver.
> The last patch implementes the RDMA driver.

<...>

>  drivers/net/ethernet/microsoft/Kconfig        |   1 +
>  .../net/ethernet/microsoft/mana/gdma_main.c   |  40 +-
>  .../net/ethernet/microsoft/mana/hw_channel.c  |   6 +-
>  .../net/ethernet/microsoft/mana/mana_bpf.c    |   2 +-
>  drivers/net/ethernet/microsoft/mana/mana_en.c | 175 +++++-
>  .../ethernet/microsoft/mana/mana_ethtool.c    |   2 +-
>  .../net/ethernet/microsoft/mana/shm_channel.c |   2 +-
>  .../microsoft => include/net}/mana/gdma.h     | 158 +++++-
>  .../net}/mana/hw_channel.h                    |   0
>  .../microsoft => include/net}/mana/mana.h     |  23 +-
>  include/net/mana/mana_auxiliary.h             |  10 +
>  .../net}/mana/shm_channel.h                   |   0
>  include/uapi/rdma/ib_user_ioctl_verbs.h       |   1 +
>  include/uapi/rdma/mana-abi.h                  |  66 +++

Hi netdev maintainers,

Can you please ACK/comment on eth part of this series? And how should
we proceed? Should we take this driver through shared branch or apply
directly to RDMA tree?

Thanks
