Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA57F6F0A75
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 19:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244060AbjD0RDS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 13:03:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244044AbjD0RDR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 13:03:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 185962735;
        Thu, 27 Apr 2023 10:03:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A868F60FAD;
        Thu, 27 Apr 2023 17:03:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82C70C433D2;
        Thu, 27 Apr 2023 17:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682614986;
        bh=5keD3A76mAYABXbJJi98ucTVufEPv+s0TFrG0i+pRO0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ys6Ej7qLO0lfHZkCvZjvRuXz1+qpgxQwcZCsCMr4NAMLepb9DwezpDrd4xL0PhgrX
         fdNijyCeWH8T73dBFzgCAmkcDfssOF8LS3FhWEaOSP4O47UKZKzNUtD6mlvmE//mWu
         6vwQyWKGoC/RAXCyuVsKDcU0CTw9YuYF1fRFIS6Sma4waRA/Tcltqd9RCtBplwJnL5
         /q6TlCq71z8hM4KNbHLCWiNS/dBipaYBLyUNd7UVOTqbkqtz1koA0A3i+Q5NIrwj4U
         z1hP9ngzIiFEc3JZ3akVYjAnVDoz6iEIGJQaCIyo6SaA06+ERXQIMLMt78c4wuydbt
         2hkcOMuHbcc6w==
Date:   Thu, 27 Apr 2023 10:03:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "zbr@ioremap.net" <zbr@ioremap.net>,
        "brauner@kernel.org" <brauner@kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "socketcan@hartkopp.net" <socketcan@hartkopp.net>,
        "petrm@nvidia.com" <petrm@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v4 1/6] netlink: Reverse the patch which removed
 filtering
Message-ID: <20230427100304.1807bcde@kernel.org>
In-Reply-To: <57A9B006-C6FC-463D-BA05-D927126899BB@oracle.com>
References: <20230331235528.1106675-1-anjali.k.kulkarni@oracle.com>
        <20230331235528.1106675-2-anjali.k.kulkarni@oracle.com>
        <20230331210920.399e3483@kernel.org>
        <88FD5EFE-6946-42C4-881B-329C3FE01D26@oracle.com>
        <20230401121212.454abf11@kernel.org>
        <4E631493-D61F-4778-A392-3399DF400A9D@oracle.com>
        <20230403135008.7f492aeb@kernel.org>
        <57A9B006-C6FC-463D-BA05-D927126899BB@oracle.com>
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

On Wed, 26 Apr 2023 23:58:55 +0000 Anjali Kulkarni wrote:
> Jakub, could you please look into reviewing patches 3,4 & 5 as well?
> Patch 4 is just test code. Patch 3 is fixing bug fixes in current
> code so should be good to have - also it is not too connector
> specific. I can explain patch 5 in more detail if needed.

I don't have sufficient knowledge to review that code, sorry :(
