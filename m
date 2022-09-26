Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 450AE5EAED5
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 19:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbiIZR5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 13:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230479AbiIZR5F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 13:57:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5488C4A812;
        Mon, 26 Sep 2022 10:34:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 634FFB80AB0;
        Mon, 26 Sep 2022 17:34:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C16CBC433D7;
        Mon, 26 Sep 2022 17:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664213679;
        bh=ZTbhAYa5KeHqS561s0LzavHHTT9Xosiv0ev1jMdnQOA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZemEdKAZJx5o8MdB8WLMTa7rUUrixkxe1jK6lKrywLkWLaimBPRhidw1PR4L3fvXg
         7KxTUjxiyg2ADjSmoybMDGfkwmyeYGgReFwVwCHN8E/+HeSwRMflNXC6G+SWqrY2bV
         GT1EdnGqOtTETfMNsf8cTw9pc3OzCAcBDQnvUIfm0y1uZY+Z0OoeuRabr359NEyUya
         pxfCQ9wcFDiQX4iHEthvjttikemQEeXoS/0/rzgIGsjprI2LTIR6rCpUm2uTYWlZVI
         +qa4/jfrVTMtDmLWAgPAoj2Xc+oreM3vApxHnhaPAhZHNLT0RcaiJy6ugym/riWXAS
         HXnQgDT1Km+4w==
Date:   Mon, 26 Sep 2022 10:34:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yury Norov <yury.norov@gmail.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: Re: [PATCH 2/7] net: fix cpu_max_bits_warn() usage in
 netif_attrmask_next{,_and}
Message-ID: <20220926103437.322f3c6c@kernel.org>
In-Reply-To: <20220919210559.1509179-3-yury.norov@gmail.com>
References: <20220919210559.1509179-1-yury.norov@gmail.com>
        <20220919210559.1509179-3-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Sep 2022 14:05:54 -0700 Yury Norov wrote:
> The functions require to be passed with a cpu index prior to one that is
> the first to start search, so the valid input range is [-1, nr_cpu_ids-1).
> However, the code checks against [-1, nr_cpu_ids).

Yup, the analysis looks correct:

Acked-by: Jakub Kicinski <kuba@kernel.org>
