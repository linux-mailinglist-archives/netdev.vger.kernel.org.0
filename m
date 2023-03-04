Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D74DE6AA69D
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 01:46:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbjCDAqH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 19:46:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjCDAqG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 19:46:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47EDD19F07;
        Fri,  3 Mar 2023 16:46:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2F196198C;
        Sat,  4 Mar 2023 00:46:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA89CC433EF;
        Sat,  4 Mar 2023 00:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677890765;
        bh=6W3qdtAivVcS8WP5XfwkRsvcwAvK9X/0B7ofRyL5EfI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=twBWcp6spsPRD50/txu+X2BHne9eyHDluaCWZ2hWZPnZAIP0OpCsJh0O9wjcAiDUS
         5JHK3UbbTONRiaZHXtwGZ5EH7KY8e1GUQY72d2KRc/dyswOldHDs2RRBLxqFnZ1aIq
         8D6uoP86NlX0nINMAVtB017JhtB3S0V5MUNoBo/RJ5SPK2MGJvKecXvRKc9HCeiZ6q
         YuRLK23gUY7nWISlBmxy7roEzY0pxxfj3cYbgTyaM09/GJLnz8SvrLB2E1/URStmCO
         hIz5bb5X+Bsq2qs8WzZohmg4BE5fa9uNyqSdbyF6WCbHabUf3N0OLRKsqfO6ashf93
         fsQZEtyJ758cg==
Date:   Fri, 3 Mar 2023 16:46:03 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>, rbradford@rivosinc.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] virtio-net: Fix probe of virtio-net on kvmtool
Message-ID: <20230303164603.7b35a76f@kernel.org>
In-Reply-To: <20230302044806-mutt-send-email-mst@kernel.org>
References: <20230223-virtio-net-kvmtool-v3-1-e038660624de@rivosinc.com>
        <20230301093054-mutt-send-email-mst@kernel.org>
        <CACGkMEsG10CWigz+S6JgSVK8XfbpT=L=30hZ8LDvohtaanAiZQ@mail.gmail.com>
        <20230302044806-mutt-send-email-mst@kernel.org>
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

On Thu, 2 Mar 2023 04:48:38 -0500 Michael S. Tsirkin wrote:
> > Looks not the core can try to enable and disable features according to
> > the diff between features and hw_features
> > 
> > static inline netdev_features_t netdev_get_wanted_features(
> >         struct net_device *dev)
> > {
> >         return (dev->features & ~dev->hw_features) | dev->wanted_features;
> > }
> 
> yes what we do work according to code.  So the documentation is wrong then?

It's definitely incomplete but which part are you saying is wrong?
