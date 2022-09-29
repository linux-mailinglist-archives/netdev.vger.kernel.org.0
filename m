Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9B35EF9C0
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 18:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235972AbiI2QHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 12:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235303AbiI2QHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 12:07:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1511D1CFBAC;
        Thu, 29 Sep 2022 09:07:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4038B82456;
        Thu, 29 Sep 2022 16:07:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FA4EC433C1;
        Thu, 29 Sep 2022 16:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664467653;
        bh=7FZkFmImNe9U69x9QnG8kuvCk7rgEYJ3jXFKYPdf5k4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UP8N2iSYFx9rhMShPpe9izRC4X9nawU3y0zew3UtOSWz1HWxmfZDPLcvXXabaD9CQ
         hVzA0VWXivFj6O249O0DY8jr5Ur7Onipy0YAFxvRYgtGbhHNGkj29v8fqzFPEQpdiO
         dJcRfvVB0fzYrtKiH1T3Jq3RRiAsuUpJl7FN6/vKG+1xag1VGrexx8Th835af8NePG
         4MZrh//5uYqEAFZVu9IvRWYfwqJaHpyk8vllWx2Eyl/hH7klTbi2qaCOfnhzGH28hf
         aFu1MlflU7Y6ZiqO8j8sEhtVKK6DNzL6s/Aodq71RwB0xuHbr6D1xc/doqr0h9n04j
         KJDmOooQwzpCw==
Date:   Thu, 29 Sep 2022 09:07:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Stefano Garzarella <sgarzare@redhat.com>,
        "Junichi Uekawa ( =?UTF-8?B?5LiK5bed57SU5LiA?=)" <uekawa@google.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Eric Dumazet <edumazet@google.com>, davem@davemloft.net,
        netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        linux-kernel@vger.kernel.org,
        Bobby Eshleman <bobby.eshleman@gmail.com>
Subject: Re: [PATCH] vhost/vsock: Use kvmalloc/kvfree for larger packets.
Message-ID: <20220929090731.27cda58c@kernel.org>
In-Reply-To: <20220929034807-mutt-send-email-mst@kernel.org>
References: <20220928064538.667678-1-uekawa@chromium.org>
        <20220928082823.wyxplop5wtpuurwo@sgarzare-redhat>
        <20220928052738-mutt-send-email-mst@kernel.org>
        <20220928151135.pvrlsylg6j3hzh74@sgarzare-redhat>
        <CADgJSGHxPWXJjbakEeWnqF42A03yK7Dpw6U1SKNLhk+B248Ymg@mail.gmail.com>
        <20220929031419-mutt-send-email-mst@kernel.org>
        <20220929074606.yqzihpcc7cl442c5@sgarzare-redhat>
        <20220929034807-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Sep 2022 03:49:18 -0400 Michael S. Tsirkin wrote:
> net tree would be preferable, my pull for this release is kind of ready ... kuba?

If we're talking about 6.1 - we can take it, no problem.
