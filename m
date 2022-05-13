Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4CF952621C
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 14:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350807AbiEMMhZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 08:37:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239666AbiEMMhX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 08:37:23 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF0551D0E8
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 05:37:20 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id u3so11306704wrg.3
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 05:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=zZRkYf+aVx/CqrlD5OS6s/GGU0Fuknnf362Kl/mW2OE=;
        b=iz4Gi46heRIvwR0SGCW08pXdiShuTPedVAwTU8ZmtS6VFRZO5ynsLllnjZMx8DMBkZ
         PAGWqOGBjcHkhY1gYypplbPpgz8CTTQpWFJZGnHWo9T7svdJmpv5dJAAvk/eZt410e5b
         jm3Xc+/MfmqA2x66zHkjjuk7yc2d1HZWNdFi6A7fwpmh8z3hOj47f36sQsGLsplSHbbY
         ymEUNQThEFOVwLBGLei980vUHPdEQ+R5OeS5ScXhXnI/s6P0Ss5yKmNvCMkXW+8Qw+2K
         KQUpaIb3t8Q70+vRnzN0nJ3ZsuphqOvzsL3fWvdepUkY7FHhKr7RathylawBEL0UVl5C
         aPIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=zZRkYf+aVx/CqrlD5OS6s/GGU0Fuknnf362Kl/mW2OE=;
        b=sX/qWe1H1/6dAM4kG2fSqLFbYW1lIbhC5ojUYGq70jqRI0OvZHZ23Svqj0EBszicEG
         2mD9D8Isy5CQ6ynbpdCP3aZ8IA9TgEz/P81/BmaIMth+ZJMMwGujP6rYrzlqpEMHT5CN
         QYl9qeVjweq6cL3V5EXVnqyCuwvrfpoiryBDKMthopPJcOl18s3WvDft+/T9hCEf6FAF
         lLS+pzU8TJOq6mQn448iUaN9mfK0wXmlJwsxKkttj/nIv5MKeI/SxpMXI3bmLregkn0c
         5brJNCXtifvgi09wpyllpQl3LVQhf1qpzSD2XR2bDX4KUgD8V7WHy8lfvkeEQGe886HN
         byyg==
X-Gm-Message-State: AOAM532uDGZaII5N+3BLjGB4LWsT14DGZQB5JRIB2rkmggkQnE3yGuje
        btfEkX2u3a7SCx9UeHyaxeo=
X-Google-Smtp-Source: ABdhPJwjDTmpnIuIOzCaA9G8BJeWpDMwRC/Dl5+Tu/pwxO8hYdoDukdWmdh3ABoHBDtT57KtuAQS/A==
X-Received: by 2002:a5d:5746:0:b0:20c:dbc2:397d with SMTP id q6-20020a5d5746000000b0020cdbc2397dmr3698298wrw.658.1652445439311;
        Fri, 13 May 2022 05:37:19 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id t6-20020a7bc3c6000000b003942a244f47sm5367918wmj.32.2022.05.13.05.37.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 13 May 2022 05:37:18 -0700 (PDT)
Date:   Fri, 13 May 2022 13:37:16 +0100
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>,
        Tianhao Zhao <tizhao@redhat.com>
Cc:     ecree.xilinx@gmail.com, amaftei@solarflare.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH net 2/2] sfc: do not initialize non existing queues with
 efx_separate_tx_channels
Message-ID: <20220513123716.nuizgafnuanyj2na@gmail.com>
Mail-Followup-To: =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>,
        Tianhao Zhao <tizhao@redhat.com>, ecree.xilinx@gmail.com,
        amaftei@solarflare.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
References: <20220511125941.55812-1-ihuguet@redhat.com>
 <20220511125941.55812-3-ihuguet@redhat.com>
 <20220513110723.dorpu2wgrutcske2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220513110723.dorpu2wgrutcske2@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 13, 2022 at 12:07:23PM +0100, Martin Habets wrote:
> On Wed, May 11, 2022 at 02:59:41PM +0200, Íñigo Huguet wrote:
> > If efx_separate_tx_channels is used, some error messages and backtraces
> > are shown in the logs (see below). This is because during channels
> > start, all queues in the channels are init asumming that they exist, but
> > they might not if efx_separate_tx_channels is used: some channels only
> > have RX queues and others only have TX queues.
> 
> Thanks for reporting this. At first glance I suspect there may be more callers
> of efx_for_each_channel_tx_queue() which is why it is not yet working for you
> even with this fix.
> Probably we need to fix those macros themselves.
> 
> I'm having a closer look, but it will take some time.

It was easier than I thought. With the patch below I do not get any errors,
and ping works. I did not have to touch efx_for_each_channel_rx_queue().
Can you give this a try and report if it works for you?

Martin
---
 drivers/net/ethernet/sfc/net_driver.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index 318db906a154..723bbeea5d0c 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -1530,7 +1530,7 @@ static inline bool efx_channel_is_xdp_tx(struct efx_channel *channel)
 
 static inline bool efx_channel_has_tx_queues(struct efx_channel *channel)
 {
-	return true;
+	return channel && channel->channel >= channel->efx->tx_channel_offset;
 }
 
 static inline unsigned int efx_channel_num_tx_queues(struct efx_channel *channel)
