Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B15085A339D
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 03:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236442AbiH0Bt2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 21:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231216AbiH0Bt1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 21:49:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1D9BEC4F9
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 18:49:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90041B83210
        for <netdev@vger.kernel.org>; Sat, 27 Aug 2022 01:49:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6AE6C433D7;
        Sat, 27 Aug 2022 01:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661564963;
        bh=rOM4F6w7Da1kQqqEGH1NdIM2ffyA17s3RTJUBPXhGyc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qPwyQ0RoTyOcM+dsmdoOLf6zKwIobWhF/veokk0hzXa5g2fO4C9+hDzEd15pIKslb
         R5+cqxPttNS9LiaH8X6GTuagaOGaPdsGHwseuM8O6cY1Il8bKC8uP1+qzCcqlCQPOg
         UM7kUln4j2V/N1uDqC3A05kPtAzDRoRZ0/3+o0E0fwibPfLZnajrhw9n11Cnry57nC
         P8FMHvoIZmDDrUftsp3wbiELV9385rHbh25QP7mL+aaKEwJnlGXpSdv5jay4G3X2F4
         ZN3VMqtkn2RsywSQzs0hdJbQJscIvwScIw9Q6MJs7QILwiAWQfClP59+jGnoLMTr11
         WrZca1XpOKjAw==
Date:   Fri, 26 Aug 2022 18:49:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Thompson <davthompson@nvidia.com>
Cc:     <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <cai.huoqing@linux.dev>, <brgl@bgdev.pl>,
        <limings@nvidia.com>, Asmaa Mnebhi <asmaa@nvidia.com>
Subject: Re: [PATCH net v1] mlxbf_gige: compute MDIO period based on i1clk
Message-ID: <20220826184922.030fccb3@kernel.org>
In-Reply-To: <20220826155916.12491-1-davthompson@nvidia.com>
References: <20220826155916.12491-1-davthompson@nvidia.com>
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

On Fri, 26 Aug 2022 11:59:16 -0400 David Thompson wrote:
> This patch adds logic to compute the MDIO period based on
> the i1clk, and thereafter write the MDIO period into the YU
> MDIO config register. The i1clk resource from the ACPI table
> is used to provide addressing to YU bootrecord PLL registers.
> The values in these registers are used to compute MDIO period.
> If the i1clk resource is not present in the ACPI table, then
> the current default hardcorded value of 430Mhz is used.
> The i1clk clock value of 430MHz is only accurate for boards
> with BF2 mid bin and main bin SoCs. The BF2 high bin SoCs
> have i1clk = 500MHz, but can support a slower MDIO period.
> 
> Fixes: f92e1869d74e ("Add Mellanox BlueField Gigabit Ethernet driver")
> Reviewed-by: Asmaa Mnebhi <asmaa@nvidia.com>
> Signed-off-by: David Thompson <davthompson@nvidia.com>

Hm, why did you repost this?
