Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48C9D6CFA1A
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 06:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbjC3EWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 00:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbjC3EWG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 00:22:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3664E1BD;
        Wed, 29 Mar 2023 21:22:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8B7B61ED1;
        Thu, 30 Mar 2023 04:22:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0A65C433D2;
        Thu, 30 Mar 2023 04:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680150125;
        bh=dxGtj6njuZ4N/PzwgnIyV1GtLm64Qw3Z0vavlB208Sg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ti0+4T0ihdyoQTcXtDPMo6TP6GIzASs/3blvZ4Vbprc3kzwE6eA8uzqaA1YPRhVQf
         KJ+yOn9JKGp0fJmW4OjKF74nJpdQ2zrFEmv5PFE/w3OOVEeSI3Reynze6kqW9abHJI
         T/g5eVqzNu0kvv/NuDDnGeT7oZ/DzCNAv6xr5Zr+/lbQ8ykKw5DXieKOQ8rx2wRnDz
         hilIi+akV2uqXeOtc7UOx7ARmebmDP6qhqUm/zPa5WKD1wXG/ngJidadeW3KQNexr+
         4QCZQdVVxKp0CcnaISchjDnNL4D+TBW/hg22YlNmI95KLYBXcmx2/2PdDTz+usjDj7
         Ns4wLdFYitDBw==
Date:   Wed, 29 Mar 2023 21:22:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: Re: [PATCH 12/16] virtio_net: introduce virtnet_get_netdev()
Message-ID: <20230329212203.3c3bf199@kernel.org>
In-Reply-To: <20230328092847.91643-13-xuanzhuo@linux.alibaba.com>
References: <20230328092847.91643-1-xuanzhuo@linux.alibaba.com>
        <20230328092847.91643-13-xuanzhuo@linux.alibaba.com>
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

On Tue, 28 Mar 2023 17:28:43 +0800 Xuan Zhuo wrote:
> +const struct net_device_ops *virtnet_get_netdev(void)
> +{
> +	return &virtnet_netdev;
> +}

Why not just make the virtnet_netdev symbol visible?
Many drivers do that.

If you prefer the function maybe virtnet_get_ndos() would be a better
name for example? The current name sounds like it will get a... well..
a netdev. And it gets ops.
