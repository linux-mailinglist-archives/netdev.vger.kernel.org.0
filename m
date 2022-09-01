Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 021855AA0AF
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 22:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234853AbiIAUKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 16:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231589AbiIAUKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 16:10:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4C6F286FE;
        Thu,  1 Sep 2022 13:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 688A961C2F;
        Thu,  1 Sep 2022 20:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BE1BC433D7;
        Thu,  1 Sep 2022 20:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662063017;
        bh=rq8nBVfudyWwGfUgkKprANMLSWkU10YJR0ZDIuz8TRU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=u3Y/noazjS5GAFdYfsRFFEkZwZ8AnKI0Dc8X0WNDBxPMfrxQNS3ZYckce6u1sns8o
         jcI3+3RTnk0OO4rwp0F4pV7XTFYyVp8pfbWcvzNHqHoVfWszQspbrHc2/EHdpU0+re
         3x5vDKUpqGsqE8Oc1lw+N8eDn/HCZfoy6AWKZDV2hf2YZKZpJx7zlwLHaAEPJqF52y
         1qpRLj4TE8sk7SjVEGbXo87tuROyK1MMPTevS49CuaSVukrr7x/cawdMD3DJ5kIcc/
         B4MrekhTErUK1ma1zSjdxKNvK5BMK230PhJuKZPimiXSwSdPemiwTM3G5MOEMJubb0
         bO4kNpQ1BUFog==
Date:   Thu, 1 Sep 2022 13:10:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     wei.fang@nxp.com, davem@davemloft.net, edumazet@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: fec: add pm_qos support on imx6q platform
Message-ID: <20220901131016.74a9a730@kernel.org>
In-Reply-To: <703b0c990f4c7b7db8496cb397fdc6dbccdc1c67.camel@redhat.com>
References: <20220830070148.2021947-1-wei.fang@nxp.com>
        <703b0c990f4c7b7db8496cb397fdc6dbccdc1c67.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 01 Sep 2022 09:17:37 +0200 Paolo Abeni wrote:
> On Tue, 2022-08-30 at 15:01 +0800, wei.fang@nxp.com wrote:
> > From: Wei Fang <wei.fang@nxp.com>
> > 
> > There is a very low probability that tx timeout will occur during
> > suspend and resume stress test on imx6q platform. So we add pm_qos
> > support to prevent system from entering low level idles which may
> > affect the transmission of tx.
> > 
> > Signed-off-by: Wei Fang <wei.fang@nxp.com>  
> 
> Since this IMHO causes a significal behavior change I suggest to target
> the net-next tree, does that fit you?
> 
> Additionally, it would be great if you could provide in the changelog
> the references to the relevant platform documentation and (even rough)
> power consumption delta estimates.

It's a tricky one, we don't want older kernels to potentially hang
either.

IIRC Florian did some WoL extensions for BRCM, maybe he has the right
experience.

Florian, what would you recommend? net or net-next?
