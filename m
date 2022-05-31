Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE52538A95
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 06:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243831AbiEaEcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 00:32:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243830AbiEaEch (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 00:32:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6140F819BC
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 21:32:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C2FDB80ED4
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 04:32:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C614C385A9;
        Tue, 31 May 2022 04:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653971553;
        bh=M2Sl6eOoNLOp437Psqu09GDI4urkKv5hBLVzJpNIkuE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WdzmIAc69Xw0wCw9E0q3AWKKeW3Bko2orIPf6GrIZQ4wPCh7HaLHE9y0+CXNOdxxe
         4E8lbxeupOYJT2ViLOTEFNwtYTfU8WbsBqPMidLi09+Bu/EDEL4GtJldW/+Ja3gx+9
         fzgHrcEfrZ2xiE1sHE/AurWRLqZBhuuivWkhHhkyCCEZflNr+pJByzrlXQLCVvZA+W
         jcYjBQHxJD1sjKwmzUxnHhsZC7dV6PF1Z2GeFbVGQxkP/acqG+nH/JeNUv8jDjQZAx
         JBkNGNLLMdT8idplcgqjzZUEY+arJWcZvac6syHnE7uaf8vsJqxyMikfZ3bKhLazVk
         WvGoxb9h4VaYQ==
Date:   Mon, 30 May 2022 21:32:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Yu Xiao <yu.xiao@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Louis Peens <louis.peens@corigine.com>
Subject: Re: [PATCH net] nfp: correct the output of `ethtool --show-fec
 <intf>`
Message-ID: <20220530213232.332b5dff@kernel.org>
In-Reply-To: <20220530084842.21258-1-simon.horman@corigine.com>
References: <20220530084842.21258-1-simon.horman@corigine.com>
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

On Mon, 30 May 2022 10:48:42 +0200 Simon Horman wrote:
> The output  of `Configured FEC encodings` should display user
> configured/requested value,

That stands to reason, but when I checked what all drivers do 7 out 
of 10 upstream drivers at the time used it to report supported modes.
At which point it may be better to change the text in ethtool user
space that try to change the meaning of the field..

> rather than the NIC supported modes list.
> 
> Before this patch, the output is:
>  # ethtool --show-fec <intf>
>  FEC parameters for <intf>:
>  Configured FEC encodings: Auto Off RS BaseR
>  Active FEC encoding: None
> 
> With this patch, the corrected output is:
>  # ethtool --show-fec <intf>
>  FEC parameters for <intf>:
>  Configured FEC encodings: Auto
>  Active FEC encoding: None

