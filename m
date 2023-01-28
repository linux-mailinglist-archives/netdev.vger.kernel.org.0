Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD49B67F566
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 08:13:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbjA1HNb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 02:13:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbjA1HN3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 02:13:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5104B2ED4F;
        Fri, 27 Jan 2023 23:13:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8FD5BB81219;
        Sat, 28 Jan 2023 07:13:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C660FC433D2;
        Sat, 28 Jan 2023 07:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674890004;
        bh=q0lYhtfJI2Xy2767Vzy1SEGyYt0U3k0GB0QJkNmaVJY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nWC2UPLY8wGEXTHo4SvSVCzGEvNVtu3ejt/pihbdy7C+8AOg6cwB2XvvV3A7q638D
         vizRwHQZeOf7xdgujjZAGW41AMhkfZLmG4ECJ34c+TYlTLpJm21c/hn5SmS0ayIP9M
         7BmiM5itdzQZyLjPtpPV7JO64NBDNcdc1mm/CPIZBy6cUc2nJLr+3XLikEOvIqs09z
         78QkU3n3hoY1LfoiY9stN26Un4Gbe8WP6peWVhvW5wJ1uOkoU1YAv/x3M2SQVQeSYT
         qBHWq2qzOSLFf13ab9s0Q6bsZxXqTMEtWOpR5GX92wcfaF+Nrx5jNA7Ojc6Tc09Vh+
         QcSKH/4Hbbn+g==
Date:   Fri, 27 Jan 2023 23:13:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jonas Suhr Christensen <jsc@umbraculum.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, michal.simek@xilinx.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        esben@geanix.com
Subject: Re: [PATCH 2/2] net: ll_temac: improve reset of buffer on dma
 mapping
Message-ID: <20230127231322.08b75b36@kernel.org>
In-Reply-To: <20230126101607.88407-2-jsc@umbraculum.org>
References: <20230126101607.88407-1-jsc@umbraculum.org>
        <20230126101607.88407-2-jsc@umbraculum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Jan 2023 11:16:07 +0100 Jonas Suhr Christensen wrote:
> Free buffer and set pointer to null on dma mapping error.

Why? I don't see a leak. You should provide motivation in the commit
message.
