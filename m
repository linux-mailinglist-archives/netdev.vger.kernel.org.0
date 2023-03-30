Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF6D16CFA05
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 06:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbjC3EQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 00:16:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbjC3EP6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 00:15:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8405859C4;
        Wed, 29 Mar 2023 21:15:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30317B81E4A;
        Thu, 30 Mar 2023 04:15:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08558C433EF;
        Thu, 30 Mar 2023 04:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680149754;
        bh=ISFjpvldvJRu/qPB9lb2+lwOOR3XFskRfbUrnQxNXQc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Fcr/U7wi0qMBgtHCP5/kLmi9zSFD+GI0ZymIX4WQw/G6Yg3fFG1BSiqJYeW0ZLUZ2
         CA+zKaDWfiTnTe4Rdi0msHj1fYQWz/riZvuxDIl5Mh4NbD0VWAYFWZ0qou1dVDN8jr
         NVnQgN/4BKCxXeADmhp/BLGeZimfJuaqYVJVtth4v+OvDJ3lXrCA2H8UrhWE2gAmjq
         GACttmDvpFO+p5HQ4HKGVbz4j8dxU+nYuE8yATCG8wi213TKdDkQ2EwhQewoFcnArR
         GTAIfOAJ+mJxWsZwqIQnguGUDleC6oySotn/+nT8VDA3DGVTKNIWeqBoMWetpqPeIg
         8H8jO5nRujMYw==
Date:   Wed, 29 Mar 2023 21:15:52 -0700
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
Subject: Re: [PATCH 16/16] virtio_net: separating the virtio code
Message-ID: <20230329211552.27efa412@kernel.org>
In-Reply-To: <20230328092847.91643-17-xuanzhuo@linux.alibaba.com>
References: <20230328092847.91643-1-xuanzhuo@linux.alibaba.com>
        <20230328092847.91643-17-xuanzhuo@linux.alibaba.com>
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

On Tue, 28 Mar 2023 17:28:47 +0800 Xuan Zhuo wrote:
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#ifndef __VIRTNET_VIRTIO_H__
> +#define __VIRTNET_VIRTIO_H__
> +
> +int virtnet_register_virtio_driver(void);
> +void virtnet_unregister_virtio_driver(void);
> +#endif

nit: this header needs to be added in the previous patch,
otherwise there is a transient build warning there.
