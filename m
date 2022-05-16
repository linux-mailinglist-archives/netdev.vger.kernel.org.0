Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D242C528CC9
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 20:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244726AbiEPSVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 14:21:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232736AbiEPSVp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 14:21:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9907F2B27E
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 11:21:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 470D9B81283
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 18:21:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5E82C34100;
        Mon, 16 May 2022 18:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652725301;
        bh=nHp0Z/MVsu8MwXp7/yHy5UZ+e/o4TBxjdr/lNeEm0KY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hjC62Y/o3qpzVgp/AI4fXrFpMPCwSjw8unxNHNfvUBNSEt7sbfwTKBfgB+14nGmx7
         Ke8Nfi8Bg8jOo4KgY4RPx8TEsyUdzFj92MLWiPlbYfa3GoTY3rinL2lUrsWSa4+bVx
         uyYVhPUrlh/eVD6ei3NwxWzi0QMrlIEjTDagrbdEoj6I9PtLPhZRFItAiTl3aWjzxU
         2nifjW3rWUSVLwgultDXyNIGSv/BhSzctu/DKRlrG3MOaLZffNUxcFJdwP/DwBWk56
         jYimELIqGZwMb8EpKAaBzVkwyQOfkUJPkJ5A/nAnUJTViCuV2D5hU/8s7iDv03GbaL
         +cbJBVnxR1oFw==
Date:   Mon, 16 May 2022 11:21:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next 4/4] net: call skb_defer_free_flush() before
 each napi_poll()
Message-ID: <20220516112140.0f088427@kernel.org>
In-Reply-To: <20220516042456.3014395-5-eric.dumazet@gmail.com>
References: <20220516042456.3014395-1-eric.dumazet@gmail.com>
        <20220516042456.3014395-5-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 15 May 2022 21:24:56 -0700 Eric Dumazet wrote:
> -end:
> -	skb_defer_free_flush(sd);
> +end:;

Sorry for the nit pick but can I remove this and just return like we
did before f3412b3879b4? Is there a reason such "label:;}" is good?
