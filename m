Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D63B263476C
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 21:12:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234693AbiKVUMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 15:12:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234696AbiKVUMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 15:12:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2705FBD7;
        Tue, 22 Nov 2022 12:12:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C46FCB81D85;
        Tue, 22 Nov 2022 20:12:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2456AC433C1;
        Tue, 22 Nov 2022 20:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669147944;
        bh=ErWQ6/edZDHfnmUj1x+2RpXl4f9HPSeF5jQRSQKBKOo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Dh3PsVIvtCZ+ztGKmg8rwGcRRizt+CZnrruVT6xkYS/H+N3oig4wWQ+sPu2sGhmjn
         qoM3ahO/U8f6t9q+EiuZ9Ka25iUR5L0PtRUkxGNgYz/e/2DCJ10W62hYmUTk3MIu5K
         YuYbbXCAKNRc4KTZAew2/NwG7p0aGGWOOcC30VLl1KBKhK7+6kLjb3bCznVadPT5PQ
         apqLyBvq26P4OoK2E8SDcu1SAi3bZVnOa56y8xLGomOPEGejGQ6iWGH8pl7e+DbRJ9
         o1upCLxtGFnj1GhAQHnrDXMxCjQNRnt1Es1ls9yHGaYlyazofQmAjSaSoGeaZPvHPV
         t7tw6LN00wxOQ==
Date:   Tue, 22 Nov 2022 12:12:23 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Peter Kosyh <pkosyh@yandex.ru>, Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        lvc-project@linuxtesting.org
Subject: Re: [PATCH] mlx4: use snprintf() instead of sprintf() for safety
Message-ID: <20221122121223.265d6d97@kernel.org>
In-Reply-To: <Y3zhL0/OItHF1R03@unreal>
References: <20221122130453.730657-1-pkosyh@yandex.ru>
        <Y3zhL0/OItHF1R03@unreal>
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

On Tue, 22 Nov 2022 16:48:15 +0200 Leon Romanovsky wrote:
> On Tue, Nov 22, 2022 at 04:04:53PM +0300, Peter Kosyh wrote:
> > Use snprintf() to avoid the potential buffer overflow. Although in the
> > current code this is hardly possible, the safety is unclean.  
> 
> Let's fix the tools instead. The kernel code is correct.

I'm guessing the code is correct because port can't be a high value?
Otherwise, if I'm counting right, large enough port representation
(e.g. 99999999) could overflow the string. If that's the case - how
would they "fix the tool" to know the port is always a single digit?
