Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E60D5753B9
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 19:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240270AbiGNRF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 13:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240146AbiGNRFU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 13:05:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14CE15B7B5;
        Thu, 14 Jul 2022 10:05:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BED7AB8273C;
        Thu, 14 Jul 2022 17:05:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A90BC34114;
        Thu, 14 Jul 2022 17:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657818317;
        bh=E0yJpZQiUtD20XD8skWR9KtBTUcV55d70ecE5Hfw3fY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PdzniX5Am+CchIX9gsIHWectuYpCdPDT31fy1TC+PTYbVhgyJbCAumWhjxw8fVAPE
         fy02Zra5WJvcb+XK7IHoqT0nskugLIgYKtH3FPj1hOOoNVV074E39Mk5kl9iftKbjP
         EHCJEUW2aT4oBQyFJA+XtjQ9M9imhX+fLP/sb0PzTbKRy/FcyX20Zi/84H6R52MayD
         ecYIdfE5kzV7WklEa6Teb9rnCh43jqZ8DMrJYtq0Fx1cufDp/ldPqlIYGrivsHAEFS
         ijncbsLvj6AxDiTojAlnJdxGQ+VAqC+573gr2Y9NtFulcfnw8ufBi4KbKZTb5cZfGY
         L4c5GFcTEq2rA==
Date:   Thu, 14 Jul 2022 10:05:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        yevhen.orlov@plvision.eu, taras.chornyi@plvision.eu,
        linux@armlinux.org.uk, andrew@lunn.ch
Subject: Re: [PATCH V3 net-next] net: marvell: prestera: add phylink support
Message-ID: <20220714100516.61054163@kernel.org>
In-Reply-To: <20220714105516.14291-1-oleksandr.mazur@plvision.eu>
References: <20220714105516.14291-1-oleksandr.mazur@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Jul 2022 13:55:16 +0300 Oleksandr Mazur wrote:
> For SFP port prestera driver will use kernel
> phylink infrastucture to configure port mode based on
> the module that has beed inserted
> 
> Co-developed-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
> Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
> Co-developed-by: Taras Chornyi <taras.chornyi@plvision.eu>
> Signed-off-by: Taras Chornyi <taras.chornyi@plvision.eu>
> Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
> 
> PATCH V3:
>   - force inband mode for SGMII
>   - fix >80 chars warning of checkpatch where possible (2/5)
>   - structure phylink_mac_change alongside phylink-related if-clause;
> PATCH V2:
>   - fix mistreat of bitfield values as if they were bools.
>   - remove phylink_config ifdefs.
>   - remove obsolete phylink pcs / mac callbacks;
>   - rework mac (/pcs) config to not look for speed / duplex
>     parameters while link is not yet set up.
>   - remove unused functions.
>   - add phylink select cfg to prestera Kconfig.
> ---

Please put the changelog under the --- separator, otherwise when 
I apply it my tag will get added at the end, after the changelog.
Since we add links to the commits now it's okay to put the changelog
after the --- and not keep it in the tree.
