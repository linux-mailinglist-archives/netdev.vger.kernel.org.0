Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1916ACA93
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 18:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbjCFReR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 12:34:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbjCFReP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 12:34:15 -0500
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2366C23300;
        Mon,  6 Mar 2023 09:33:17 -0800 (PST)
Received: by mail-qt1-x834.google.com with SMTP id r5so11426564qtp.4;
        Mon, 06 Mar 2023 09:33:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678123889;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UANncWrkqP0wGFe9cfk0F5rdhQoiGsROa82g/rlru+8=;
        b=F3KF8af5PGId9V+MeGxLK9IkmQO1mIopPtxpp0Cj9HK7tZtVtCgYLD9APuqgHoNAkd
         LCkPgPvE/rfQ2kNWJIPqVOZHjIPXofx2p+o/BIBi4dblyVurxuxhXpg4btCDPT0lZHl+
         mxKl5QV1Imslhuh4tYbfpGjMpTl4RQVNSCcgLSJj4rnaoGnodEsMWCOSCGstQX/LQXXX
         xgmaQ2JMM+L2Lkp+C5b1tJl5Ogde2n/vHerzVNSBbP5AZhaBVCDhZsnxlvehGfCRGnUH
         Mwr/6qjzH0in8bkTp/k57hPHsp+50UOsXA2Z82EYpe4eQActGWSPbUAB19TU+oxxiZKY
         3xIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678123889;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UANncWrkqP0wGFe9cfk0F5rdhQoiGsROa82g/rlru+8=;
        b=GWFmxx0dnkeRoR7bz5OuucNnVRRpCJ/lgPXA1jO6rjyW++yF0sJmV/6ofTawdOJHOY
         2mlq+fc3cwX5PgEwNZdK9WHjyi7yic4lOH/hFOzSsZzqVsvN5kwEjmar9jEVh5qdiCf0
         NoQyR74Zpjc9nENw8Ot7jn67hmqVR++hO92pKzyMIUabbnZUUYqrc2SFnWa25D24Cv6E
         PnB0tJLSC4URy638BaKQDpWEfqRS4Vz6iOC86SrXXtNjq+1xCqw5grjSrknNQK6WnZVH
         xNIL8O2nZcG2knY5D+WDe0TPDrVAIOZa7kXIzbQqJgJb8ORZxQc8EyFtgKk0riyyRZ+v
         UWQg==
X-Gm-Message-State: AO0yUKUToXkOLnTUwvuRgfRewoM1VzM5UzpssrNf70AIF2bOefYxMfaN
        4H/BzVlJLj3QdXEbY9lWaxs=
X-Google-Smtp-Source: AK7set+VZBNwYL+15nzYCtkcQxPb2Q4aV6IuGCCvMgWgtV7HdOQJDIB4fptSsUiZ6Iq1D8M3TJi6VQ==
X-Received: by 2002:ac8:4904:0:b0:3bd:15d4:ff65 with SMTP id e4-20020ac84904000000b003bd15d4ff65mr13033343qtq.40.1678123889116;
        Mon, 06 Mar 2023 09:31:29 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id a18-20020ac84352000000b003bfaff2a6b9sm7971848qtn.10.2023.03.06.09.31.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Mar 2023 09:31:28 -0800 (PST)
Message-ID: <2f8622b7-b5a3-241c-5f69-9d1a48e36e56@gmail.com>
Date:   Mon, 6 Mar 2023 09:31:24 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net] net: ethernet: mtk_eth_soc: fix RX data corruption
 issue
Content-Language: en-US
To:     Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     =?UTF-8?Q?Bj=c3=b8rn_Mork?= <bjorn@mork.no>
References: <138da2735f92c8b6f8578ec2e5a794ee515b665f.1677937317.git.daniel@makrotopia.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <138da2735f92c8b6f8578ec2e5a794ee515b665f.1677937317.git.daniel@makrotopia.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/4/23 05:43, Daniel Golle wrote:
> Fix data corruption issue with SerDes connected PHYs operating at 1.25
> Gbps speed where we could previously observe about 30% packet loss while
> the bad packet counter was increasing.
> 
> As almost all boards with MediaTek MT7622 or MT7986 use either the MT7531
> switch IC operating at 3.125Gbps SerDes rate or single-port PHYs using
> rate-adaptation to 2500Base-X mode, this issue only got exposed now when
> we started trying to use SFP modules operating with 1.25 Gbps with the
> BananaPi R3 board.
> 
> The fix is to set bit 12 which disables the RX FIFO clear function when
> setting up MAC MCR, MediaTek SDK did the same change stating:
> "If without this patch, kernel might receive invalid packets that are
> corrupted by GMAC."[1]
> 
> [1]: https://git01.mediatek.com/plugins/gitiles/openwrt/feeds/mtk-openwrt-feeds/+/d8a2975939a12686c4a95c40db21efdc3f821f63
> 
> Fixes: 42c03844e93d ("net-next: mediatek: add support for MediaTek MT7622 SoC")
> Tested-by: Bjørn Mork <bjorn@mork.no>
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

