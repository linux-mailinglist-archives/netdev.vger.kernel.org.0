Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34AA0588697
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 06:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232116AbiHCEnE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 00:43:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiHCEnD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 00:43:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D44322521
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 21:43:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5683FB82121
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 04:43:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92DA0C433D6;
        Wed,  3 Aug 2022 04:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659501779;
        bh=todqXPywndklh/57Gl2ztYsJ/gTQb5fJPANd69bmzRY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=M2IV+QxJcPieE9PseZHJsomroaqCVLJ34LDsdKrEnwq2qUVfbZDLP5Bv6x+Xwidyh
         DkMwFzwx4h9KfvLl4dT4HtumkjRJRj2dm3ElKkP2k+D6l6MHNd2kKHanghSXgPAIoT
         CHBR6TEqNvfVc1wxJUX9RlyzdJYBowTDPqMgmW0HvwNXPdMYM+t205U90AosWZBJZ5
         7GaKSPXyfyoghe33dUYgTt7FPrO4o1vxei2GLo3uvm7GcTj/prd2/lYY9KMjc4YCwG
         nXZtiU2RCu/dVLf8ZmlGCvRQW4DDBtFGyqHDu+mT+s6EJ3jtFnYlhGzxRJWvZ2MQRP
         NnZNBkIiHpMEw==
Date:   Tue, 2 Aug 2022 21:42:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Cezar Bulinaru <cbulinaru@gmail.com>
Cc:     davem@davemloft.net, willemb@google.com, netdev@vger.kernel.org
Subject: Re: [PATCH v4 1/2] net: tap: NULL pointer derefence in
 dev_parse_header_protocol when skb->dev is null
Message-ID: <20220802214258.23d1d788@kernel.org>
In-Reply-To: <20220803042845.5754-1-cbulinaru@gmail.com>
References: <CA+FuTSfNLfLCxV8NNsJKSQynvBCa2_b7YqqPPXr=2gDhXnGiYA@mail.gmail.com>
        <20220803042845.5754-1-cbulinaru@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  3 Aug 2022 00:28:45 -0400 Cezar Bulinaru wrote:
> Fixes a NULL pointer derefence bug triggered from tap driver.
> When tap_get_user calls virtio_net_hdr_to_skb the skb->dev is null
> (in tap.c skb->dev is set after the call to virtio_net_hdr_to_skb)
> virtio_net_hdr_to_skb calls dev_parse_header_protocol which
> needs skb->dev field to be valid.

Could you repost these patches as a normal, standalone series, with 
no fancy in-reply-to? Put [PATCH net v5] as the subject prefix.
Patchwork bot is unable to follow your creativity it seems.
