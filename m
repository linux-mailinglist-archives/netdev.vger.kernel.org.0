Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5817D554237
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 07:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356969AbiFVFXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 01:23:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233946AbiFVFXW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 01:23:22 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0736136157
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 22:23:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6E43ACE1C35
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 05:23:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFE60C34114;
        Wed, 22 Jun 2022 05:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655875398;
        bh=s4gTOMkuCt3y4iZhBEDrrBnZBzh8C1OUzRBvJerWPWo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ARVe2EfuKQLnthKuj8LnmbEzGtjw/Mf6Bv7X1ncFpAyrCZhhUkz3keKoP32CbLIzB
         Lc1NSQjq2i1Yv1yo4jBCgEVvS7q8atCxr7VyCUf2HvQkVdswtgwBUb4ViW31HATTrt
         vx9dj1f/H20azbX36z5YVPnlkK+X5MQ03/tCngliPpyLHUV7d2ZDJ/q7JqWYCJWcte
         u6cKzqvc4tCNiwwOCUcOyk6TTHk6vHX5FxI3ZfRnvB2y8GZbn51Pgts/XDTWfk95t5
         MY00sRghBjru33FwUAb43vk/fH37Um4KG09uLe9znjt2nKx5BnjCHD35GDZ0846JKn
         L1ZG2im813pIg==
Date:   Tue, 21 Jun 2022 22:23:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Arthur Gautier <baloo@superbaloo.net>
Cc:     Raju Rangoju <rajur@chelsio.com>, netdev@vger.kernel.org
Subject: Re: [PATCH] cxgb4: DOM support when using a QSFP to SFP adaptor
Message-ID: <20220621222317.1cbcaaeb@kernel.org>
In-Reply-To: <20220620223234.2443179-1-baloo@superbaloo.net>
References: <20220620223234.2443179-1-baloo@superbaloo.net>
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

On Mon, 20 Jun 2022 22:32:34 +0000 Arthur Gautier wrote:
> When a QSFP to SFP adaptor is used, the DOM eeprom is then presented
> with the SFF-8472 layout and not translated to SFF-8636 format.
> 
> When parsing the eeprom, we can't just read the type of port but we
> need to identify the type of transceiver instead.
> 
> Signed-off-by: Arthur Gautier <baloo@superbaloo.net>
> Cc: Raju Rangoju <rajur@chelsio.com>
> Cc: netdev@vger.kernel.org

Makes sense. Do you expect this change to make it into the long term
stable branches or are you okay with it appearing starting with 5.20?

> +#define SFF_8636_ID		0x0
> +#define SFF_8636_ID_LEN	0x1
> +#define SFF_8024_ID_SFP	0x3

Please use the defines from include/linux/sfp.h
SFF8024_ID_SFP and SFP_PHYS_ID
