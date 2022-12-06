Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72E85643ADD
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 02:38:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233804AbiLFBik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 20:38:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233678AbiLFBiV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 20:38:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A50E36245;
        Mon,  5 Dec 2022 17:37:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16BE9614FB;
        Tue,  6 Dec 2022 01:37:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6C59C433C1;
        Tue,  6 Dec 2022 01:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670290657;
        bh=rz19PUH2Fl8oeU0CkmkBHGY6X9eg4p+1gMp4aSzTuN4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Sd6Ym3mpLMCXU73KLRNSYcMQwkNptFMtFy9WBf62Z0tQxYfnsdhqkLWLBl1nr7aTU
         4qW+aVFSkc+ROd840dxdI+tfUhjIPQYiY/fmFe6TQToUY0fY4tmOvFKvZBGFG2Ma+r
         iw/HaEg2Ir64rCnzKr7oLtye1A3ISapkg6AXNUAzMcgACUM6S42mxjy2nSx1/QoJAY
         nxJhCYOK0jzij2L7Gxw49f5daFBlyNHwEQaL09dBnb1632s/KaTNDbqrf6v8VT3t20
         hOyPYKbIKlR5QBc9U+U0z645ud6U5gW409V3CUVPeCwgwdg2/A3dIGSZumv66wHzBP
         d1efGFj+q0Dtw==
Date:   Mon, 5 Dec 2022 17:37:35 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Bobby Eshleman <bobbyeshleman@gmail.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] virtio/vsock: replace virtio_vsock_pkt with sk_buff
Message-ID: <20221205173735.6123b941@kernel.org>
In-Reply-To: <20221205122214.bky3oxipck4hsqqe@sgarzare-redhat>
References: <20221202173520.10428-1-bobby.eshleman@bytedance.com>
        <20221205122214.bky3oxipck4hsqqe@sgarzare-redhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 5 Dec 2022 13:22:14 +0100 Stefano Garzarella wrote:
> As pointed out in v4, this is net-next material, so you should use the 
> net-next tag and base the patch on the net-next tree:
> https://www.kernel.org/doc/html/v6.0/process/maintainer-netdev.html#netdev-faq

Thanks, yes, please try to do that, makes it much less likely that 
the patch will be mishandled or lost.

> I locally applied the patch on net-next and everything is fine, so maybe 
> the maintainers can apply it, otherwise you should resend it with the 
> right tag.

FWIW looks like all the automated guessing kicked in correctly here,
so no need to repost just for the subject tag (this time).

> Ah, in that case I suggest you send it before the next merge window 
> opens (I guess next week), because net-next closes and you'll have to 
> wait for the next cycle.

+1, we'll try to take a closer look & apply tomorrow unless someone
speaks up.
