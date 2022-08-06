Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD2F958B319
	for <lists+netdev@lfdr.de>; Sat,  6 Aug 2022 02:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238900AbiHFAwA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 20:52:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbiHFAwA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 20:52:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F6B318E16;
        Fri,  5 Aug 2022 17:51:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA47E61548;
        Sat,  6 Aug 2022 00:51:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFD69C433D6;
        Sat,  6 Aug 2022 00:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659747117;
        bh=aGPCCcqmNmyLpPKUwSK7Je4PaWs5Jti1VQWU4dq+GrA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OFQrCV+hAvSLbeQf6DD4Vw/y981a3vyb+lNWeWtkyzdqKMGOhWnIXcRNrFzlntdV2
         2uaIxKgwd7IJygua6LMBzUyLx6Vowhqd1Wy17Ynkb0wlF5IbWdmICCTgp2Q2u1Yonz
         y8CLUDkgMfCsQoYy+ZFA4kfGGAaMp5DveDFLzBkV92vCfPqeZ4hpXRasG+UilIbkKV
         PfLV1DnZSbOst/RacPHluRVBe3CYVnLqajJlIPmVmkeCcjbcCI/fBkXrp116+7eVId
         ULr8J5eWwBhN94IQxAIMgm9RB4yO/gkXbKR9GjbkP67EYtLCmggVwCsoQTqTtBW7gW
         sZ91aCKjgiINw==
Date:   Fri, 5 Aug 2022 17:51:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jose Alonso <joalonsof@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev <netdev@vger.kernel.org>, stable <stable@vger.kernel.org>,
        Ronald Wahl <ronald.wahl@raritan.com>
Subject: Re: [PATCH v2 net] net: usb: ax88179_178a have issues with
 FLAG_SEND_ZLP
Message-ID: <20220805175155.6f021ff4@kernel.org>
In-Reply-To: <9a6829ee42e4e88639d35428c378f9da7802245b.camel@gmail.com>
References: <9a6829ee42e4e88639d35428c378f9da7802245b.camel@gmail.com>
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

On Fri, 05 Aug 2022 17:27:33 -0300 Jose Alonso wrote:
> To: David S. Miller <davem@davemloft.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: netdev <netdev@vger.kernel.org>, stable <stable@vger.kernel.org>, Ronald Wahl <ronald.wahl@raritan.com>
> 
>     [PATCH net] net: usb: ax88179_178a have issues with FLAG_SEND_ZLP
>     The usage of FLAG_SEND_ZLP causes problems to other firmware/hardware
>     versions that have no issues.

But you tested with 1790 previously so isn't the misbehaviour on that
device going to come back if we remove the flag again?

>     The FLAG_SEND_ZLP is not safe to use in this context.
>     See:
>     https://patchwork.ozlabs.org/project/netdev/patch/1270599787.8900.8.camel@Linuxdev4-laptop/#118378
>     
>     Reported-by: Ronald Wahl <ronald.wahl@raritan.com>
>     Link: https://bugzilla.kernel.org/show_bug.cgi?id=216327
>     Link: https://bugs.archlinux.org/task/75491
>     
>     Fixes: 36a15e1cb134 ("net: usb: ax88179_178a needs FLAG_SEND_ZLP")
>     Signed-off-by: Jose Alonso <joalonsof@gmail.com>

The commit message looks unnecessarily indented, could you try with git
format-patch / git send-email?
