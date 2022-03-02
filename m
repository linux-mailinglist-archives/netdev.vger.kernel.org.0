Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9A1A4C9AE1
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 03:05:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239008AbiCBCF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 21:05:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232069AbiCBCF4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 21:05:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1753D5F241;
        Tue,  1 Mar 2022 18:05:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7635615D3;
        Wed,  2 Mar 2022 02:05:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8382AC340EE;
        Wed,  2 Mar 2022 02:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646186714;
        bh=5i8Y5+dBeeL89jeI9/AO5sLou/tQrxrcO+QtYbCCKUc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=f5R3K7LQpxliNR5Lci0onOHclKiqth1ZuwJE+DSpmjDqYk+O6stDhcRJ5MX65Zioe
         NPTzlzD1OekD3KsA86i3EqwvToKi1cDnAUI4gVpVAd13m9DeT8al538iFv80R9/5bU
         92oYPHZjTkfdOSoB6oyMevjeC3si3MaMeC7uCuqAzgg4OrpSlytHbenOyU4xV1S4vE
         bGy5KhHr0o9kkzbkSpNxG+TVpVElHfkkgucfpNfLYLDNTxdkLmNTpGHj/6i/UX2NeO
         fDGriUvcdbAh8sQwaF1U59Cu30oVk761nMWSG8RNn7GK/yK1TCXs+kFvJxUcAD9CDn
         tla4rME8QEXYg==
Date:   Tue, 1 Mar 2022 18:05:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Harold Huang <baymaxhuang@gmail.com>
Cc:     netdev@vger.kernel.org, jasowang@redhat.com, edumazet@google.com,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-kernel@vger.kernel.org (open list),
        kvm@vger.kernel.org (open list:VIRTIO HOST (VHOST)),
        virtualization@lists.linux-foundation.org (open list:VIRTIO HOST 
        (VHOST)), bpf@vger.kernel.org (open list:XDP (eXpress Data Path))
Subject: Re: [PATCH net-next] tuntap: add sanity checks about msg_controllen
 in sendmsg
Message-ID: <20220301180512.06f7f6dc@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220301064314.2028737-1-baymaxhuang@gmail.com>
References: <20220301064314.2028737-1-baymaxhuang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  1 Mar 2022 14:43:14 +0800 Harold Huang wrote:
> In patch [1], tun_msg_ctl was added to allow pass batched xdp buffers to
> tun_sendmsg. Although we donot use msg_controllen in this path, we should
> check msg_controllen to make sure the caller pass a valid msg_ctl.
> 
> [1]: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=fe8dd45bb7556246c6b76277b1ba4296c91c2505
> 
> Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
> Suggested-by: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Harold Huang <baymaxhuang@gmail.com>

Would you mind resending the same patch? It looks like it depended on
your other change so the build bot was unable to apply and test it.
