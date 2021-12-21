Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC08847C611
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 19:13:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241061AbhLUSNf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 13:13:35 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:42306 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241058AbhLUSNe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 13:13:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A2BC0CE19C1;
        Tue, 21 Dec 2021 18:13:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9324C36AE9;
        Tue, 21 Dec 2021 18:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640110410;
        bh=x1YRVFMWzmr2ZtU4EnrpvIEjFRjrcz6g9/oGEJwF/Kg=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=U73lhSIAeKNtXkPsSe1YJkQjAhXLN61P4332m7dmHyK1w0M02ljLDE4kTbkmhWDM7
         IIuRuHeKwrPRGBD639HT+8TmNfS6ILJ+NN8bgHYIIiod17GLdp+xoRxEjOxnBvzDoz
         dTeC1I+/cLwQ73D2PxvUhTw5kPG5ta7+WEiGbJVgo8Q+Aw8jadyIInbSaaGAv5FaCm
         nThQ+eCxdMNV0JhWWLljRkxtJTV6D8AkTBYnXfpYTleUgMJfd6aGHctcTKPmR5eNvL
         a+g7yvXllm6CiLriHsu0eGWSMdOJRk9kruy2XEpVWcD7KR1yOkkO2lCgjh+fVsL+RK
         Q3G/b9f73tSfA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wilc1000: use min() to make code cleaner
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20211216091713.449841-1-deng.changcheng@zte.com.cn>
References: <20211216091713.449841-1-deng.changcheng@zte.com.cn>
To:     cgel.zte@gmail.com
Cc:     ajay.kathat@microchip.com, claudiu.beznea@microchip.com,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Changcheng Deng <deng.changcheng@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164011040619.7951.14619016402908057909.kvalo@kernel.org>
Date:   Tue, 21 Dec 2021 18:13:27 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cgel.zte@gmail.com wrote:

> From: Changcheng Deng <deng.changcheng@zte.com.cn>
> 
> Use min() in order to make code cleaner.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Changcheng Deng <deng.changcheng@zte.com.cn>

Failed to compile:

In file included from ./include/linux/kernel.h:17,
                 from ./include/linux/clk.h:13,
                 from drivers/net/wireless/microchip/wilc1000/spi.c:7:
drivers/net/wireless/microchip/wilc1000/spi.c: In function 'wilc_spi_dma_rw':
./include/linux/minmax.h:20:35: error: comparison of distinct pointer types lacks a cast [-Werror]
   20 |         (!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
      |                                   ^~
./include/linux/minmax.h:26:18: note: in expansion of macro '__typecheck'
   26 |                 (__typecheck(x, y) && __no_side_effects(x, y))
      |                  ^~~~~~~~~~~
./include/linux/minmax.h:36:31: note: in expansion of macro '__safe_cmp'
   36 |         __builtin_choose_expr(__safe_cmp(x, y), \
      |                               ^~~~~~~~~~
./include/linux/minmax.h:45:25: note: in expansion of macro '__careful_cmp'
   45 | #define min(x, y)       __careful_cmp(x, y, <)
      |                         ^~~~~~~~~~~~~
drivers/net/wireless/microchip/wilc1000/spi.c:677:26: note: in expansion of macro 'min'
  677 |                 nbytes = min(sz, DATA_PKT_SZ);
      |                          ^~~
cc1: all warnings being treated as errors
make[5]: *** [scripts/Makefile.build:287: drivers/net/wireless/microchip/wilc1000/spi.o] Error 1
make[4]: *** [scripts/Makefile.build:549: drivers/net/wireless/microchip/wilc1000] Error 2
make[3]: *** [scripts/Makefile.build:549: drivers/net/wireless/microchip] Error 2
make[2]: *** [scripts/Makefile.build:549: drivers/net/wireless] Error 2
make[1]: *** [scripts/Makefile.build:549: drivers/net] Error 2
make: *** [Makefile:1846: drivers] Error 2

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20211216091713.449841-1-deng.changcheng@zte.com.cn/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

