Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFAD76DB896
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 05:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbjDHDWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 23:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbjDHDVw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 23:21:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 037B3EFAE;
        Fri,  7 Apr 2023 20:21:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7876E65149;
        Sat,  8 Apr 2023 03:21:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41D2BC433EF;
        Sat,  8 Apr 2023 03:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680924084;
        bh=Ux1qV/Kx8mwHEaGuUrzlMTZWOjz8OjRxPSBpsk1YQ+o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=X30UhBDA3c013Q2cJTc28qgrssypPkrQRu9xn1bZbJnYYYC/wIXqLX+cdFc49vz7R
         hrrGsu96Y1cBJnBJzy9oz4JGejZEi0LakqjvV6FXXVrABX7B+XqkKwD5E16L9DptYX
         z0AATYjfRZNCLSmsC7Jh5Z8RCKshxG1alrotVO/fqFq38nAPlC1tJTfqy046gjMO+x
         Y//Wb8O4h1yOUqTwmMw7I3GBVb2HVEDSoseLoY1nkD2eaOW8drLsALToIfVS6z6FAb
         RNdyrQtZecN2jsiApzJ2kPFrgdwWoyA5JY+srS0R14NR0OgMRlE/gYDMTurMG182qK
         5Zja18tAKhbOQ==
Date:   Fri, 7 Apr 2023 20:21:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Gautam Dawar <gautam.dawar@amd.com>
Cc:     <linux-net-drivers@amd.com>, <jasowang@redhat.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <eperezma@redhat.com>, <harpreet.anand@amd.com>,
        <tanuj.kamde@amd.com>, <koushik.dutta@amd.com>
Subject: Re: [PATCH net-next v4 10/14] sfc: implement filters for receiving
 traffic
Message-ID: <20230407202123.654fe6e4@kernel.org>
In-Reply-To: <20230407081021.30952-11-gautam.dawar@amd.com>
References: <20230407081021.30952-1-gautam.dawar@amd.com>
        <20230407081021.30952-11-gautam.dawar@amd.com>
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

On Fri, 7 Apr 2023 13:40:11 +0530 Gautam Dawar wrote:
> Implement unicast, broadcast and unknown multicast
> filters for receiving different types of traffic.

drivers/net/ethernet/sfc/ef100_vdpa.h:137: warning: Function parameter or member 'spec' not described in 'ef100_vdpa_filter'
