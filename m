Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC0050AFD6
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 08:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232938AbiDVGAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 02:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233011AbiDVGAg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 02:00:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53EB84F9D8;
        Thu, 21 Apr 2022 22:57:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E480161D9D;
        Fri, 22 Apr 2022 05:57:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A684C385A9;
        Fri, 22 Apr 2022 05:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650607051;
        bh=Rvf90UcwzPbS3F5AqAtneVu3nF9B07X7cwvF7nN8ENI=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=bBXFaJywcqTcX8KxDYflryjhANwgEc2Bam3efuHS/L8sddABY8ol1JI333xINwl/x
         mkC4XgNcMUNV1ZyKxdgrMcIb67PF5i8sOG1mN5LY/P2TBErRJPCha8euLdDppa/YBT
         hRZLeqNjkb59HQX8W1QqAa5GIOYRRtNjUE6AVdECGvddUCG+SoZw9GBIzhMLhYO1Cn
         wttlxzGWVq4Ishol80XcTWBC87GvIb+BjnbvfgbpQTsL+l0Ev6Lrixyboso7u3R7Kk
         wrG+pUgEDv85U3YCcrGtAOU/UVkdgxuNo8gKLGJbiGLi2h2R51VtJ0JhjRhBdIQL0U
         5XtEbXYyKMPHA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Bernard Zhao <zhaojunkui2008@126.com>
Cc:     Jakub Kicinski <kubakici@wp.pl>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        bernard@vivo.com
Subject: Re: [PATCH] net/wireless: add debugfs exit function
In-Reply-To: <20220422012830.342993-1-zhaojunkui2008@126.com> (Bernard Zhao's
        message of "Thu, 21 Apr 2022 18:28:30 -0700")
References: <20220422012830.342993-1-zhaojunkui2008@126.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Date:   Fri, 22 Apr 2022 08:57:25 +0300
Message-ID: <877d7hoe2i.fsf@kernel.org>
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

Bernard Zhao <zhaojunkui2008@126.com> writes:

> This patch add exit debugfs function to mt7601u.
> Debugfs need to be cleanup when module is unloaded or load fail.

"load fail"? Please be more specific, are you saying that the second
module load fails or what?

>  drivers/net/wireless/mediatek/mt7601u/debugfs.c | 9 +++++++--
>  drivers/net/wireless/mediatek/mt7601u/init.c    | 1 +
>  drivers/net/wireless/mediatek/mt7601u/mt7601u.h | 1 +

The title should be:

mt7601u: add debugfs exit function

> --- a/drivers/net/wireless/mediatek/mt7601u/debugfs.c
> +++ b/drivers/net/wireless/mediatek/mt7601u/debugfs.c
> @@ -9,6 +9,8 @@
>  #include "mt7601u.h"
>  #include "eeprom.h"
>  
> +static struct dentry *dir;

How will this work when there are multiple mt7601u devices? Because of
that, avoid using non-const static variables.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
