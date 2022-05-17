Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D71C0529622
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 02:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233451AbiEQAnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 20:43:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230472AbiEQAnV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 20:43:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAD0D29C89
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 17:43:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91808B810F3
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 00:43:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1015DC385AA;
        Tue, 17 May 2022 00:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652748198;
        bh=ElDge3ptwo6OoyaRiRyUpksl5M68UhSVgolzuk8+BnA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=u/a+I2j494yRibsSAQJVj/A3uKbPT6Yq0HIpq78xoBhatYX4+d0fKtpBKU/DGhry4
         6bFBSQATJkdHhH/lY2S31fGBLCmVY0UoeteRuVP7txd7z3XCHXUyzq/Ygzdvnp/+d1
         zGEUmSuLe3Ojsrhg3afqTPx4h9JkF34BcSXlryfLP+AxVXGPzU47aIkCrwTO9/aGFz
         c/wA89ioPWUp6tU28DW9z7zXQNPZ/9uRcEwMKlQXn12e+Ts7NXwFVtP+e+6j8aa8L/
         v+zFisdT9FdxS+l8nsMTgEIlE1ejXGibA0FopZtzeTGxegtfhXTY80kaLbsH/9CLKq
         fcBZOMkQ09pEw==
Date:   Mon, 16 May 2022 17:43:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, richardcochran@gmail.com,
        davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        kernel-team@fb.com
Subject: Re: [PATCH net-next v3 08/10] ptp: ocp: fix PPS source selector
 reporting
Message-ID: <20220516174317.457ec2d1@kernel.org>
In-Reply-To: <20220513225924.1655-9-jonathan.lemon@gmail.com>
References: <20220513225924.1655-1-jonathan.lemon@gmail.com>
        <20220513225924.1655-9-jonathan.lemon@gmail.com>
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

On Fri, 13 May 2022 15:59:22 -0700 Jonathan Lemon wrote:
> The NTL timecard design has a PPS1 selector which selects the
> the PPS source automatically, according to Section 1.9 of the
> documentation.
> 
>   If there is a SMA PPS input detected:
>      - send signal to MAC and PPS slave selector.
> 
>   If there is a MAC PPS input detected:
>      - send GNSS1 to the MAC
>      - send MAC to the PPS slave
> 
>   If there is a GNSS1 input detected:
>      - send GNSS1 to the MAC
>      - send GNSS1 to the PPS slave.MAC
> 
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>

This one and patch 10 need Fixes tags
