Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED4E5146BE
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 12:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239097AbiD2K3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 06:29:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357491AbiD2K2y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 06:28:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41DD67CDC2;
        Fri, 29 Apr 2022 03:25:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E8096232F;
        Fri, 29 Apr 2022 10:25:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2957EC385A7;
        Fri, 29 Apr 2022 10:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651227935;
        bh=lFv2+KTy80l38T+vxHkOOXgzZmC20F3Ggy02KRG1xZA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=I1E4KZy6bocb0zySf5owQNUNuGUWoLWCS7HHDq07r1JqPWzq6kqCi+rIvVIGuPJKd
         Rgl/R6unBydMcvT3yVf9C+tHl2STveqKad3yLNuJU3sUjv9po6hVfvO36BW6HY1n5i
         u38osDlxr22x9mN2JKVLJ4eQCC316/y+cNEoUquYyTtRQ7sl/7IbdNr32YHB13HI+M
         cQwsWqiBbxWkpKnF/xf/nliURjJOlCfz47u9SCdr/B3Kmcv8lrdYYm3xuM7mCQl0IC
         6qiyE4nT/QZeYwN5xLushVnl1spK2MRn12F78t4U690JrgUPi/1gSZDnvQGaImvIh6
         xgx4nKSsAvHgg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Srinivasan Raju <srini.raju@purelifi.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "edumazet\@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "pabeni\@redhat.com" <pabeni@redhat.com>,
        "open list\:NETWORKING DRIVERS \(WIRELESS\)" 
        <linux-wireless@vger.kernel.org>,
        "open list\:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix le16_to_cpu warning for beacon_interval
References: <CWLP265MB3217B3A355529E36F6468A43E0FC9@CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM>
Date:   Fri, 29 Apr 2022 13:25:30 +0300
In-Reply-To: <CWLP265MB3217B3A355529E36F6468A43E0FC9@CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM>
        (Srinivasan Raju's message of "Fri, 29 Apr 2022 10:20:11 +0000")
Message-ID: <878rrodw4l.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Srinivasan Raju <srini.raju@purelifi.com> writes:

> Fixed the following warning
> drivers/net/wireless/purelifi/plfxlc/chip.c:36:31: sparse: expected unsigned short [usertype] beacon_interval
> drivers/net/wireless/purelifi/plfxlc/chip.c:36:31: sparse: got restricted __le16 [usertype]

The preferred style is this:

Fix the following sparse warnings:

drivers/net/wireless/purelifi/plfxlc/chip.c:36:31: sparse: expected unsigned short [usertype] beacon_interval
drivers/net/wireless/purelifi/plfxlc/chip.c:36:31: sparse: got restricted __le16 [usertype]

> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Srinivasan Raju <srini.raju@purelifi.com>
> ---
>  drivers/net/wireless/purelifi/plfxlc/chip.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

The subject should be:

[PATCH] plfxlc: fix le16_to_cpu warning for beacon_interval

> diff --git a/drivers/net/wireless/purelifi/plfxlc/chip.c b/drivers/net/wireless/purelifi/plfxlc/chip.c
> index a5ec10b66ed5..5d952ca07195 100644
> --- a/drivers/net/wireless/purelifi/plfxlc/chip.c
> +++ b/drivers/net/wireless/purelifi/plfxlc/chip.c
> @@ -30,10 +30,10 @@ int plfxlc_set_beacon_interval(struct plfxlc_chip *chip, u16 interval,
>  {
>         if (!interval ||
>             (chip->beacon_set && 
> -            le16_to_cpu(chip->beacon_interval) == interval))
> +            chip->beacon_interval) == interval)
>                 return 0;

I think there's no need to use three lines anymore, two lines should be
enough:

       if (!interval ||
           (chip->beacon_set && chip->beacon_interval == interval))

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
