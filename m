Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16E464CB712
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 07:32:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbiCCGdh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 01:33:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiCCGdg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 01:33:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0223341F99;
        Wed,  2 Mar 2022 22:32:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 90C87617E2;
        Thu,  3 Mar 2022 06:32:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D724C004E1;
        Thu,  3 Mar 2022 06:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646289169;
        bh=1hdFwEApQ9grBt9oUPeinkV2LDuNqdSmho2UK/4xVWg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oE0YAJ2Oene2ROCb5HFP22eUFe02tXZLVohtit2VWvw+lApDzStQqPLHyFEPnIN99
         FLuNtuMOyuwJ8gPHNd4Cp6ctLXVn+fFhwcA3xeoMeu2W1TjE8FSDz2L+ktvc1coXV7
         maDaR4oLMlsRP+00H0E+qqcVasN8oOT3ER8TSPZ9ljU9rOuL6B42cfOgkVXeDRDcwI
         rfVko6YmOK+YL1WCixLdp1Ddmlk2QLpwhe7zHnf5m8ILqfxum4GquS/SkBb7h+DMMy
         uzcX4C+Hj3Vbj9ZgZJ+Ozm7pvCb92l0NpFC3NK+dNRKW9sq8IwF2HNyOgAU973pdgP
         4G1/QbTXplyhQ==
Date:   Wed, 2 Mar 2022 22:32:48 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wong Vee Khee <vee.khee.wong@linux.intel.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        pei.lee.ling@intel.com
Subject: Re: [PATCH net 1/1] net: stmmac: Resolve poor line rate after
 switching from TSO off to TSO on
Message-ID: <20220302223248.2492658e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220228111558.3825974-1-vee.khee.wong@linux.intel.com>
References: <20220228111558.3825974-1-vee.khee.wong@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Feb 2022 19:15:58 +0800 Wong Vee Khee wrote:
> From: Ling Pei Lee <pei.lee.ling@intel.com>
>=20
> Sequential execution of these steps:
> i) TSO ON =E2=80=93 iperf3 execution,
> ii) TSO OFF =E2=80=93 iperf3 execution,
> iii) TSO ON =E2=80=93 iperf3 execution, it leads to iperf3 0 bytes transf=
er.

IMHO the iperf output can be dropped from the commit message,=20
it doesn't add much beyond this description.

> Clear mss in TDES and call stmmac_enable_tso() to indicate
> a new TSO transmission when it is enabled from TSO off using
> ethtool command

How does the TSO get disabled I don't see any ...enable_tso(, 0, )
calls in the driver? And why call enable in fix_features rather=20
than set_features?
