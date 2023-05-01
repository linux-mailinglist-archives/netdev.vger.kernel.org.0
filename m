Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0746F3A48
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 00:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232184AbjEAWIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 18:08:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbjEAWIG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 18:08:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58DD91FEB;
        Mon,  1 May 2023 15:08:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E82A861B86;
        Mon,  1 May 2023 22:08:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D666C433D2;
        Mon,  1 May 2023 22:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682978884;
        bh=3uBwTs+BjArlbFvziWqGDytvQf6gMzzJgKqFXYdheCk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YQpOou+14UAIaCscm+mUCjVZbXxUbmOAKvePCkuWBmZjgs1Zvi0EZx1NkwX9A+Rva
         BZ89W8/pI/hPbyzKtLXfnwUJmVWjETdO40VG1GY2hcRpTvHK7BDyJjb6CqHGC3uRY0
         dDuPqTh5Ibr5ToPJFx7O+yqur4Qdh0fW08ciBwBKpTSbhjJSZG1T0OAxVmNB2IDg8t
         K2Nnq6xl36Ft9ilY4Dgl1aTcAPTctq5B14peSV8tXeikdKcTembfPSQTzkw71axk9p
         39SbYZeXaK7839peBfUBOBuhCSS+qPPMV1OlsUot8+NqrzELKtd9boPBG/B0AHfzR4
         X9HPkvJ+s8UxA==
Date:   Mon, 1 May 2023 15:08:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     Ping-Ke Shih <pkshih@realtek.com>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: pull-request: wireless-next-2023-04-21
Message-ID: <20230501150803.6c4963ac@kernel.org>
In-Reply-To: <87cz3os2wr.fsf@kernel.org>
References: <20230421104726.800BCC433D2@smtp.kernel.org>
        <20230421075404.63c04bca@kernel.org>
        <e31dae6daa6640859d12bf4c4fc41599@realtek.com>
        <87leigr06u.fsf@kernel.org>
        <20230425071848.6156c0a0@kernel.org>
        <87cz3os2wr.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Apr 2023 13:43:16 +0300 Kalle Valo wrote:
> > I don't think it's that much extra work, the driver requires FW
> > according to modinfo, anyway, so /lib/firmware is already required.
> > And on smaller systems with few hundred MB of RAM it'd be nice to not
> > hold all the stuff in kernel memory, I'd think.  
> 
> Later in this thread Ping explained pretty well the challenges here,
> that sums exactly what I'm worried about.
> 
> > We have a rule against putting FW as a static table in the driver
> > source, right? Or did we abandon that? Isn't this fundamentally similar?  
> 
> My understanding is that these are just initialisation values for
> hardware, not executable code. (Ping, please correct me if I
> misunderstood.) So that's why I thought these are ok to have in kernel.
> So I took practicality over elegance here.

Alright, I'll try to make someone else do this outside of wireless,
and come back with real life experience disproving the concerns :)
