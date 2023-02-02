Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 136B3688794
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 20:38:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbjBBTid (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 14:38:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232519AbjBBTib (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 14:38:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B1FB6DFF6;
        Thu,  2 Feb 2023 11:38:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD4AB61CC5;
        Thu,  2 Feb 2023 19:38:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB636C433D2;
        Thu,  2 Feb 2023 19:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675366709;
        bh=MuWcMqsk9c3OgnZ4nSTBLpl+GnjWJqARux8P4Evx9+4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WYv3X8KNuaKN/jCtcCbjJaI7Q4mdgNuodfDG6kr6zMPdvjlOgPRfyqu9DeDdssjAd
         GaTFzkuKsYIO1wfMdtlrN9+X0dYfDdW/RkMO8m/G15jOT4VzjnlW+pOvenSZVfIBXS
         CcHniqaQw+3XvYsFVsBB1rTbYNNj8FkP8Ep1YYwJ1YfP+yt/5eT4QOUE+b+RJRmfS/
         1/Xl0iZQdyx061zos7wvpfRHkefVIue9KdUlZxRnRH6+IWcqk9chJdKWjGZ4JjBNLF
         lq+6QJkDcwBeh2uxRBI19idbaq0maKVG7BkmW0L8W+GfnIgL5a1JevQY6qCTc5v0zi
         OuTZqiBkKzIdA==
Date:   Thu, 2 Feb 2023 11:38:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Haiyang Zhang <haiyangz@microsoft.com>
Cc:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        decui@microsoft.com, kys@microsoft.com, paulros@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH net,v2] net: mana: Fix accessing freed irq affinity_hint
Message-ID: <20230202113828.7f2a800c@kernel.org>
In-Reply-To: <1675288013-2481-1-git-send-email-haiyangz@microsoft.com>
References: <1675288013-2481-1-git-send-email-haiyangz@microsoft.com>
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

On Wed,  1 Feb 2023 13:46:53 -0800 Haiyang Zhang wrote:
> +		irq_set_affinity_and_hint(irq, cpumask_of(cpumask_local_spread
> +					  (i, gc->numa_node)));

The line break here looks ugly.
Please use a local variable for the mask or the cpu.
