Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E82E5E7205
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 04:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbiIWCmU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 22:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230216AbiIWCmT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 22:42:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C0FEE36A5;
        Thu, 22 Sep 2022 19:42:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D869EB82660;
        Fri, 23 Sep 2022 02:42:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B513C433D6;
        Fri, 23 Sep 2022 02:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663900935;
        bh=xK1LGLizLbDAIkZFj4t4/9Kurql7ZCXl+lWMuoTjlwQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=G7pEZmE4wDikVjkCEUFfyOl/SHMgObu4xMzyAr7A7WcDT7Krdf0btw9YTYD4L+nc6
         49aBHT7O4bg9D4LpVQTfTj3oMV+2flttx3msOydPgr4+bXpdbUYSJ26lTK4Iqo2yJS
         32TZeWAPnBaR6aVHQlxnAQG98405eCO8bJXWpLjp3M40YioeKpOLTu33zo3GTpwPtg
         9Dkt0O0p9436N7aqe0CZvQCLwKYH0FAYHOrzhxWS+AaQDCm2mvY2nsHkMCAtlpWh7m
         Cz5mQea0FszXiWwMWbirmDMS94IoGJXkGCRJbUw4aufm28tLEgxM20cSfKWXtvtRD6
         cU5CyhriEbuvw==
Date:   Thu, 22 Sep 2022 19:42:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: enetc: cache accesses to
 &priv->si->hw
Message-ID: <20220922194214.108f7701@kernel.org>
In-Reply-To: <20220921144349.1529150-1-vladimir.oltean@nxp.com>
References: <20220921144349.1529150-1-vladimir.oltean@nxp.com>
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

On Wed, 21 Sep 2022 17:43:48 +0300 Vladimir Oltean wrote:
> The &priv->si->hw construct dereferences 2 pointers and makes lines
> longer than they need to be, in turn making the code harder to read.
> 
> Replace &priv->si->hw accesses with a "hw" variable when there are 2 or
> more accesses within a function that dereference this. This includes
> loops, since &priv->si->hw is a loop invariant.

Could you resend? pw checker could not apply it, it must have depended 
on the fixes from net.
