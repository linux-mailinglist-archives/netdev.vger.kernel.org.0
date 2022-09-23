Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77DAD5E7B2F
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 14:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbiIWMwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 08:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiIWMwh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 08:52:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02D3C1166C9;
        Fri, 23 Sep 2022 05:52:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9356D61043;
        Fri, 23 Sep 2022 12:52:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 734CFC433D6;
        Fri, 23 Sep 2022 12:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663937556;
        bh=1lp6YHISpXrs3QH/vlQg9zEdKh7pjHvYbhmHoxr9/UY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UDfwCDVpeZf/E9NPOZelu6n6eSkWDGo5lgfqB1eDG8pz1qoMvLkRAvSCglaI1GFHb
         plPNJIVtXyOwF7ivNCLzUVhwb9m4KnrpuH7YE1EDHBioladBhcfEMwgIjIy1HupRg7
         XihJ/Gyj/0vrd8CI694AuPZZDF8tfnDUddOma3f88CsWf1K1WZ9gmJHRSsDibmShDz
         OjYfO20RF0rfBG3kL7ZJ14DIjHBkw/X0iDUi2c9g+gkrC5agfqvW1hb+c7mPWGZfFE
         L2ZuUmUVQI4e31OGLwXYphUPhGmllEvqYOo/RcTrpgAHYOTqNuIcXUaH6UC64FHiKO
         GmJM/F8l0yP5Q==
Date:   Fri, 23 Sep 2022 05:52:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Thierry Reding <thierry.reding@gmail.com>
Cc:     Jon Hunter <jonathanh@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Bhadram Varka <vbhadram@nvidia.com>,
        devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v4 9/9] stmmac: tegra: Add MGBE support
Message-ID: <20220923055234.4714c86a@kernel.org>
In-Reply-To: <Yy2pFfUWU7LwGG/m@orome>
References: <20220707074818.1481776-1-thierry.reding@gmail.com>
        <20220707074818.1481776-10-thierry.reding@gmail.com>
        <YxjIj1kr0mrdoWcd@orome>
        <64414eac-fa09-732e-6582-408cfb9d41dd@nvidia.com>
        <20220922083454.1b7936b2@kernel.org>
        <Yy2pFfUWU7LwGG/m@orome>
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

On Fri, 23 Sep 2022 14:39:49 +0200 Thierry Reding wrote:
> > Could you repost it independently of the series so that it can go thru
> > the net auto-checkers? It should be able to make 6.1 pretty comfortably.  
> 
> Done. Let me know if there's anything in the patch that needs more work.
> For the auto-checkers, do they send out notifications if they find
> anything or can I monitor them manually somewhere? Are all of those
> reported in the patchwork checks?

They are reported to patchwork, but they sometimes produce false
positives so we don't expect folks to look at the themselves. The
maintainers will reply to the submission and quote the failed checks 
as needed. 

Also note that we have a "at most one version per day" policy,
if, say, there is a build issue discovered please hold off posting
the new version for 24h. Frequent posting makes reviewing harder 
for folks who read the list top to bottom and increases ML traffic.
