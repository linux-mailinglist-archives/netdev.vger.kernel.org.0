Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6135D64142D
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 05:59:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231264AbiLCE7M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 23:59:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231225AbiLCE7L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 23:59:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB1BFC5126;
        Fri,  2 Dec 2022 20:59:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F0E0560EC4;
        Sat,  3 Dec 2022 04:59:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D542BC433D6;
        Sat,  3 Dec 2022 04:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670043549;
        bh=WLqBpD/hSijALuUZgakx2ku24eQYSRBUVggDObxBitk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TzK10HAu0CIj719qjw8PCN2xzDB73wBFHbXEp/E3lMahLs81IOyNEOfrbIimej+BM
         QuwIlkQ/V8h9ZaUnCmsPpcXkubbgeRK0Ng60VRClOtHROKE4XcGKMDMzBPFMrlF3k/
         3oa59IA8W22yfIFAspjpqTyqyIFvLRPLPTFZ91QI4YZmaaoIzhMZJUTX3k2mAND1wf
         +APOJYi7+pvaqPZcMM0BZWE2cJX0UbcJ34wH66XgzjaWUy0p92D1UEZdAHP9zajGHA
         Q0uWzb47lNPN8R54wz52EgV5/SfoCqoLLvfgaNaMAUeRr+xpb3SFwY9MQcvEg9KgIn
         aRF9eGyfsdsrg==
Date:   Fri, 2 Dec 2022 20:59:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Qiheng Lin <linqiheng@huawei.com>
Cc:     <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <lars.povlsen@microchip.com>, <Steen.Hegelund@microchip.com>,
        <daniel.machon@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: microchip: sparx5: Fix missing destroy_workqueue
 of mact_queue
Message-ID: <20221202205907.39eabc1c@kernel.org>
In-Reply-To: <20221201134717.25750-1-linqiheng@huawei.com>
References: <20221201134717.25750-1-linqiheng@huawei.com>
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

On Thu, 1 Dec 2022 21:47:17 +0800 Qiheng Lin wrote:
> The mchp_sparx5_probe() won't destroy workqueue created by
> create_singlethread_workqueue() in sparx5_start() when later
> inits failed. Add destroy_workqueue in the cleanup_ports case,
> also add it in mchp_sparx5_remove()

This is a fix so it needs a Fixes tag.
