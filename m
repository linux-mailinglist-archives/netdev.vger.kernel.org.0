Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82C835905F9
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 19:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234961AbiHKRiR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 13:38:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235967AbiHKRh5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 13:37:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 240A26FA0C
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 10:37:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FD0C60F4D
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 17:37:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93DF2C433D6;
        Thu, 11 Aug 2022 17:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660239451;
        bh=FJnjHN/2axsfC7sFVjGrtcIgALgwBRUzaysracokK34=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BJQvprW75eeIlPMqmuE5YU5N3+AAYeDIPF6fFV2efjotEmTTYv3LW2AZKYgpUdqV2
         8db9zwcHgjpLmmX3MgDFcg1Yw/Ps84MzTp9UvegjePd+NU3sgcZUsMTpdRufZhGDm4
         JwO33g4/7V6ZKZ27g3xE+Mekwls36N+5epwcS4RQam5trlvCWw8i0t/24QK0+JvrhD
         2/5Pfvl/QO1DXx58kIRf1cE3VMAwL/INMxbiToAQ4vY1Mcz/eFQrS5IUcrFOmbp55z
         k9+DEXMiA47P6vQLR8eRy/MNGTeTUrNnRozsk1+29OG+Jh5rrFjDKbCRO1z0rb25Mk
         6TBdcaygGd1cw==
Date:   Thu, 11 Aug 2022 10:37:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH vhost 0/2] virtio_net: fix for stuck when change ring
 size with dev down
Message-ID: <20220811103730.0f085866@kernel.org>
In-Reply-To: <20220811041041-mutt-send-email-mst@kernel.org>
References: <20220811080258.79398-1-xuanzhuo@linux.alibaba.com>
        <20220811041041-mutt-send-email-mst@kernel.org>
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

On Thu, 11 Aug 2022 04:11:22 -0400 Michael S. Tsirkin wrote:
> Which patches does this fix?
> Maybe I should squash.

Side question to make sure I understand the terminology - this 
is *not* a vhost patch, right? vhost is the host side of virtio?
Is the work going via the vhost tree because of some dependencies?
