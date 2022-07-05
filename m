Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8E9C567754
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 21:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233299AbiGETGX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 15:06:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232877AbiGETGF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 15:06:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22DB520BCC;
        Tue,  5 Jul 2022 12:06:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E9C361A8A;
        Tue,  5 Jul 2022 19:06:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2DC9C341C7;
        Tue,  5 Jul 2022 19:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657047962;
        bh=zvshu8VboiccDpe3iPa1Tzf33oPHxnT3llN7NYgMS8o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gTrtXu7ybh1DM2zko8hSrL0/yrUows9xmuleEbe+tWA9vi0CJe4gRHl5RInNBb2Wx
         uWEeoySK+JIx83QDK0Q+0isAJ5TJS+06i96JxXbSvukzK4lOdVsrb1Va/ML0XxjSGO
         Gj1oYXXHqn4VOREimT2HKmwzLgpgbUnhaClezsa84hRTlJPquKbxHIVtQ1IuSfPjAk
         b9HEATya5lXf3BMR+AnG7sOwllSlzih9gYnY+baNJFJE4+VLxTISovCYBkGqUKise9
         WDI/GrAkMKuud5tV4hPydyG+evq1kgBx82oaySbpE5s79Wr23jHz8VOQXnomdzaKZD
         W37JYvoWn7bXQ==
Date:   Tue, 5 Jul 2022 12:06:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leonard Crestez <cdleonard@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Wei Wang <weiwan@google.com>,
        Joanne Koong <joannelkoong@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: Shrink sock.sk_err sk_err_soft to u16 from int
Message-ID: <20220705120600.4ea241d5@kernel.org>
In-Reply-To: <74c6f54cd3869258f4c83b46d9e5b95f7f0dab4b.1656878516.git.cdleonard@gmail.com>
References: <74c6f54cd3869258f4c83b46d9e5b95f7f0dab4b.1656878516.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  3 Jul 2022 23:06:43 +0300 Leonard Crestez wrote:
> -	int			sk_err,
> +	u16			sk_err,
>  				sk_err_soft;

While at it please remove the comma and explicitly type both fields.

BTW are there are no architectures of note which can't load 2B entities,
any more? Historically 16b is an awkward quantity for RISC arches.
