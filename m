Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 919B557AAFB
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 02:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236551AbiGTA06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 20:26:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231709AbiGTA05 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 20:26:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D62D39B9C
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 17:26:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3DEECB81D0D
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 00:26:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0C8BC341C6;
        Wed, 20 Jul 2022 00:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658276814;
        bh=YDVxVYrOMcbQ2wX0NsNEBx97UenTvBnNZkS2t69C8ts=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=t1RrBZYACD3Lke86s6+I3TGK1Z5iPIDA8284FdWlMtVkDfijBEhx4DGownvS62wpz
         EFcyaroRyPDKj/Z6rHX9gtGlKRWmygqlv2S2rK/q+dxVB2dd8Y9tzfNOakdZ1P5nwe
         J69fgJFDpGR9m8XCP5jd9g9a6+jKOHip86A1j/ltFM+lEdYpy5ClfimQLL3aH0MINY
         4k/5Qz052/l4zsDEoz/EBPgMJOx4QWWehnZ+Z9RzeGtVeHhdLmAS7AOtmQHkL8NAeh
         OsLSu4ft6tRn5QbItvvjHJKlusDmJYJ6eke7Pa+g+VnlHwOBH5yibXvT5TsFPG7eC8
         LO/zVIu0MtLkg==
Date:   Tue, 19 Jul 2022 17:26:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alvaro Karsz <alvaro.karsz@solid-run.com>
Cc:     netdev@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v4] net: virtio_net: notifications coalescing
 support
Message-ID: <20220719172652.0d072280@kernel.org>
In-Reply-To: <20220718091102.498774-1-alvaro.karsz@solid-run.com>
References: <20220718091102.498774-1-alvaro.karsz@solid-run.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 Jul 2022 12:11:02 +0300 Alvaro Karsz wrote:
> New VirtIO network feature: VIRTIO_NET_F_NOTF_COAL.
> 
> Control a Virtio network device notifications coalescing parameters
> using the control virtqueue.
> 
> A device that supports this fetature can receive
> VIRTIO_NET_CTRL_NOTF_COAL control commands.
> 
> - VIRTIO_NET_CTRL_NOTF_COAL_TX_SET:
>   Ask the network device to change the following parameters:
>   - tx_usecs: Maximum number of usecs to delay a TX notification.
>   - tx_max_packets: Maximum number of packets to send before a
>     TX notification.
> 
> - VIRTIO_NET_CTRL_NOTF_COAL_RX_SET:
>   Ask the network device to change the following parameters:
>   - rx_usecs: Maximum number of usecs to delay a RX notification.
>   - rx_max_packets: Maximum number of packets to receive before a
>     RX notification.
> 
> VirtIO spec. patch:
> https://lists.oasis-open.org/archives/virtio-comment/202206/msg00100.html
> 
> Signed-off-by: Alvaro Karsz <alvaro.karsz@solid-run.com>

Waiting a bit longer for Michael's ack, so in case other netdev
maintainer takes this:

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
