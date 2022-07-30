Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 545645857E1
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 04:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231717AbiG3CDQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 22:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231201AbiG3CDN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 22:03:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E3AA65661
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 19:03:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AFB6761DA2
        for <netdev@vger.kernel.org>; Sat, 30 Jul 2022 02:03:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEEBAC433C1;
        Sat, 30 Jul 2022 02:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659146589;
        bh=ygmaegbZvt8X0RY05cMBMkVYaTbOc49PBETjsFJOCWo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rhdJi2qAAPxejOicMpNJRlH6zyhzDT1/8H9LHVLjTRXiLj7bG+oSbKBSou2znvne5
         x9truuPZw6iXuii8ZJYSiFA62GOIUiUgpd3XMbcLWx49MR1ImsGo8836v5N/l9HQ+B
         DLqsagrhXU0vN+JhwPU58ogLyC3ezDexYPHE7kUDXnB7LAIpri6onztAHit7nAWg4C
         fOsUwg6XRcm4LCrF0fgkBBMORXRnusMhWT5GuvPGsUWg/JrBZey+jnik8iAy+vn8aS
         CP2YKm080CZW1Kse1Xc2duFGqBZNx/xmhHLrGumpZcG45xQtZQEP770Dd4kFbnThbd
         qkqWZq//p7n5w==
Date:   Fri, 29 Jul 2022 19:03:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Cezar Bulinaru <cbulinaru@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2] net: tap: NULL pointer derefence in
 dev_parse_header_protocol when skb->dev is null
Message-ID: <20220729190307.667b4be0@kernel.org>
In-Reply-To: <CA+FuTSewa5gCcDJzfQc4j6oQVU6d1kpPqL+D9ZQ9BQUi6Zp9Nw@mail.gmail.com>
References: <20220728185640.085c83b6@kernel.org>
        <20220729051738.7742-1-cbulinaru@gmail.com>
        <20220729051738.7742-2-cbulinaru@gmail.com>
        <CA+FuTSewa5gCcDJzfQc4j6oQVU6d1kpPqL+D9ZQ9BQUi6Zp9Nw@mail.gmail.com>
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

On Fri, 29 Jul 2022 08:52:04 +0200 Willem de Bruijn wrote:
> >  drivers/net/tap.c                    |  21 +-
> >  tools/testing/selftests/net/Makefile |   2 +-
> >  tools/testing/selftests/net/tap.c    | 395 +++++++++++++++++++++++++++  
> 
> Is there prior art in mixing fixes and tests? Should the test go to
> net or always to net-next?

Not sure if there is any official guidance, but I usually put both 
together. Separate patches in the same series, targeting one tree.
