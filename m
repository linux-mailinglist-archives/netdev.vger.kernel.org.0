Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAC4A562984
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 05:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234002AbiGADT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 23:19:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233948AbiGADT2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 23:19:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 903DA5924D;
        Thu, 30 Jun 2022 20:19:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A3156226C;
        Fri,  1 Jul 2022 03:19:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 427FAC34115;
        Fri,  1 Jul 2022 03:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656645566;
        bh=Wu4LyrwBIXBMGUuBfkoa+RPX9Idpr9pjdu3wscaPnds=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kgjbyh3i2XIZ19rO5ftMUoo8DPoFt2NWUdxvGlsmAaXugcR3qu11845WpDRfFxu9N
         NphLmbEYKPN7RAhY4zdSxlrWPpItAeReSRkddycSl9vHE9EtfDKYv5c0yTVJLhkbVK
         dsYWwL70m1KFJ7QPGb/r2k3oy84quFaOd1k1DrM/KWc+lJU48K8LKIFj887vfRyAFS
         qtXE2AAh4HQIRBNCBTsQHbY59DOz+XeGRtyhxg7csjDm2NPO+P2G9n91vEBfEgRgvW
         iF3fnVkD/Qbz027/8x1d2B1pJdpaUK9Fj6yUiKBLhktrbQFV3RjQsSTbm3y7Axfpv9
         mNV5SqCtiUSbw==
Date:   Thu, 30 Jun 2022 20:19:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jianglei Nie <niejianglei2021@163.com>
Cc:     irusskikh@marvell.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: atlantic: fix potential memory leak in
 aq_ndev_close()
Message-ID: <20220630201925.4138ab9c@kernel.org>
In-Reply-To: <20220629175645.2163510-1-niejianglei2021@163.com>
References: <20220629175645.2163510-1-niejianglei2021@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Jun 2022 01:56:45 +0800 Jianglei Nie wrote:
>  	err = aq_nic_stop(aq_nic);
> -	if (err < 0)
> -		goto err_exit;
>  	aq_nic_deinit(aq_nic, true);
>  
>  err_exit:

label is now unused, please make sure you build test your changes with
W=1
