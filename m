Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE256CF9F5
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 06:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbjC3EFa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 00:05:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjC3EF3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 00:05:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B0D6171F;
        Wed, 29 Mar 2023 21:05:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 032D1B81D65;
        Thu, 30 Mar 2023 04:05:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 821EAC433EF;
        Thu, 30 Mar 2023 04:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680149125;
        bh=tRV8jVvDqF4V/b3NkYBwa3c+3cbEYiqju8zCp48FnLs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jDIa5eOaTjL7lbEkzYOXSGS8CJuooUzooHCnZDiW4E97zRkNUl2y7RnbWCdRQJtJI
         UhRWwJ9MOo4EJBmltI0IxOEq67Eq2DB5IASEPYSEx+t/mHPL+cdZQSuRRutYdONnvb
         6l3QlSu+DmA9jlja8WA8Z8pnLVmAPLYAGcdKAeM3FT1BxH0nEZUQCm+oSmUw3AjOxK
         QnS+eHuFtkpzoPjxw3gPnqmL2a2rtFoNbGVDAPpzRDvdnjlTHVcwcVovuEnURGQfCU
         4BXMb20nKFf5vHSYMBCEgGKF5sn20OU54VqVoqC86A0PwakxGsgjuaABv0mlSsK2BP
         72Zbsqsmw215Q==
Date:   Wed, 29 Mar 2023 21:05:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [RFC PATCH 1/2] net: extend drop reasons for multiple
 subsystems
Message-ID: <20230329210524.651810e4@kernel.org>
In-Reply-To: <20230329214620.131636-1-johannes@sipsolutions.net>
References: <20230329214620.131636-1-johannes@sipsolutions.net>
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

On Wed, 29 Mar 2023 23:46:19 +0200 Johannes Berg wrote:
> -	DEBUG_NET_WARN_ON_ONCE(reason <= 0 || reason >= SKB_DROP_REASON_MAX);
> +	DEBUG_NET_WARN_ON_ONCE(reason == SKB_NOT_DROPPED_YET);

We can still validate that the top bits are within known range 
of subsystems?
