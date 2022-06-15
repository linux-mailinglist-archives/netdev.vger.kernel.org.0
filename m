Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79B5C54D580
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 01:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348918AbiFOXuE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 19:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233984AbiFOXuD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 19:50:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C733F3BBCB;
        Wed, 15 Jun 2022 16:50:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32EE7619CF;
        Wed, 15 Jun 2022 23:50:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24CDCC3411A;
        Wed, 15 Jun 2022 23:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655337001;
        bh=3AOJEIyxqxqOlqac7LnYUq97OTzWiMWaLdBgnllSIzU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gYDL3mkhi3H0BRpsldwTDRbpCzmVLM+wLTuEOF04RhggG8DcrD6yjZYXyyBzsbwuY
         IMHvG3SpzvX6Cz2Y2kLB9cmL54hFNYlMKL7PFjXPPg6k/p93OM2EwbrXlTLaigUs+x
         tMFOGhCVz/ndy1qS4ojXTBp0/cIfctQooIAQBED8VAQMXYypaCMtdNoI5+3onoK2yl
         O5alfntx1WUxKcSg7HbakTD+Ihenm0myAopG+2xxzU1nkHS359TXMrx54Rud6syDfN
         C8pkXWc2WTQJsVs8b33PL3xOENWKPR6GLtglQeS11SwJFXeCyki9yURwNP3gVhOMum
         RS41G9RIWoYzA==
Date:   Wed, 15 Jun 2022 16:50:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, magnus.karlsson@intel.com,
        bjorn@kernel.org, Alexandr Lobakin <alexandr.lobakin@intel.com>
Subject: Re: [PATCH v3 bpf-next 02/11] ice: allow toggling loopback mode via
 ndo_set_features callback
Message-ID: <20220615165000.4147cf57@kernel.org>
In-Reply-To: <20220615161041.902916-3-maciej.fijalkowski@intel.com>
References: <20220615161041.902916-1-maciej.fijalkowski@intel.com>
        <20220615161041.902916-3-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Jun 2022 18:10:32 +0200 Maciej Fijalkowski wrote:
> +	if (if_running)
> +		ice_stop(netdev);
> +	if (ice_aq_set_mac_loopback(hw, ena, NULL))
> +		netdev_err(netdev, "Failed to toggle loopback state\n");
> +	if (if_running)
> +		ice_open(netdev);

Ay. Looks like I commented on previous version, same complaint.
