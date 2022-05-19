Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5979052CB33
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 06:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233712AbiESElE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 00:41:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233764AbiESElC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 00:41:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF9065C661;
        Wed, 18 May 2022 21:41:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22BDD619B9;
        Thu, 19 May 2022 04:41:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16E44C385B8;
        Thu, 19 May 2022 04:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652935260;
        bh=ydUDPQfiDFXRRUsRJHQC3B3uycrZ1kC9Z7zzJcg/1HE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Us05cmksIJ7DW7J0qyymfrkO8pUQpwexdf3W+0QjTVkBTbg+e7quQlI5eQ3/R84yl
         xdLE++bqOJ7Bsmxifq8X6NOTcB+cG5/EGawKvvsSdHFZ32m9MzttDnQshSmVT92kP/
         8BTM9OWJGUYtwk6ewx7tydIOTYpBW/AQJQzH3fcKgrFGgG5T1hefei6jYGo3ES4F2W
         QOxNv+CeHpbsLlwY6Kwk1teQywwRepeIt+c7PcmZoja3lMvHvTpgRELyQINahjMCUQ
         0R8L8OXTUbU0ZgFv4mb5Z9gOaxwmQZODjcQbOv+Adx6Cfs4ujU5GcOfQy55gQ9XMa6
         9s/DH2hrqHaEg==
Date:   Wed, 18 May 2022 21:40:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Harini Katakam <harini.katakam@xilinx.com>
Cc:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <richardcochran@gmail.com>, <claudiu.beznea@microchip.com>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <michal.simek@xilinx.com>, <harinikatakamlinux@gmail.com>,
        <radhey.shyam.pandey@xilinx.com>
Subject: Re: [PATCH net v3] net: macb: Fix PTP one step sync support
Message-ID: <20220518214058.2a964dba@kernel.org>
In-Reply-To: <20220518170756.7752-1-harini.katakam@xilinx.com>
References: <20220518170756.7752-1-harini.katakam@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 May 2022 22:37:56 +0530 Harini Katakam wrote:
> PTP one step sync packets cannot have CSUM padding and insertion in
> SW since time stamp is inserted on the fly by HW.
> In addition, ptp4l version 3.0 and above report an error when skb
> timestamps are reported for packets that not processed for TX TS
> after transmission.
> Add a helper to identify PTP one step sync and fix the above two
> errors. Add a common mask for PTP header flag field "twoStepflag".
> Also reset ptp OSS bit when one step is not selected.
> 
> Fixes: ab91f0a9b5f4 ("net: macb: Add hardware PTP support")
> Fixes: 653e92a9175e ("net: macb: add support for padding and fcs computation")
> Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
> Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>

Acked-by: Jakub Kicinski <kuba@kernel.org>
