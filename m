Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAB83572A50
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 02:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbiGMAhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 20:37:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231905AbiGMAha (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 20:37:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAD22B7D6A;
        Tue, 12 Jul 2022 17:37:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C8C361852;
        Wed, 13 Jul 2022 00:37:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 748CAC3411C;
        Wed, 13 Jul 2022 00:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657672648;
        bh=zrEAqCvFaLLRfDkoCkAVybVZ0VUg0r6WiAhoHWGPViU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=POM9zk+cYuG8o1oZk2xlHZdtmynzg8avxWcTBUX8reU8tgQ+AHP8ej2XVH5woil6q
         a82BdQYfUnGT1aAYmh/3UxC1vOzG8glQr5JDazfnP/PwbmlcyRJkOak1ajzwaf3XhD
         0JfWp+IzEVfSyecROZ/WuSaKwwAiteku88YP/xnCzFLZNsJpXxvitCbt0YEboWrCWB
         CW/oHbmpaS1U7+cl25XGgoaPexqTw5A8l32a4cqq/ndrSVwh6DRDdWWrCsZ/Jij3DF
         PBYxrIAqh+evFBkqj4BSYczxw8I/IgyYAAp+Ys+aifYIo/5JHYul8rrJHCNcs5rMta
         aspntO1csOddg==
Date:   Tue, 12 Jul 2022 17:37:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        netdev@vger.kernel.org, nic_swsd@realtek.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] r8152: fix accessing unset transport header
Message-ID: <20220712173719.0e834365@kernel.org>
In-Reply-To: <e3745b77b8537e08bbace5088d9f41e21755e08b.camel@redhat.com>
References: <20220711070004.28010-389-nic_swsd@realtek.com>
        <e3745b77b8537e08bbace5088d9f41e21755e08b.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Jul 2022 15:06:25 +0200 Paolo Abeni wrote:
> On Mon, 2022-07-11 at 15:00 +0800, Hayes Wang wrote:
> > A warning is triggered by commit 66e4c8d95008 ("net: warn if transport
> > header was not set"). The warning is harmless, because the value from
> > skb_transport_offset() is only used for skb_is_gso() is true or the
> > skb->ip_summed is equal to CHECKSUM_PARTIAL.
> > 
> > Signed-off-by: Hayes Wang <hayeswang@realtek.com>  
> 
> If this is targeting the -net tree please add a suitable Fixes tag,
> thanks!

And FWIW I think the fixes tag you want is:

Fixes: 66e4c8d95008 ("net: warn if transport header was not set")
