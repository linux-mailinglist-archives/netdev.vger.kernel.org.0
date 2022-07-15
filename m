Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6E08575927
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 03:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232133AbiGOBn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 21:43:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231293AbiGOBn6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 21:43:58 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFDAA13CFD
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 18:43:57 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id x184so3426157pfx.2
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 18:43:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=nxbx2Gu3pNsGIIkHE4Aq6pFS7gVhLt0Luwdty16xoJY=;
        b=PIWM2esWN5nmOPQaGq45xXCt1IfHUgbcCzIG99Himi0AVnIIiMtojiZ5MvnpXyAUDJ
         NrZhCfzvxU2RGLBqcZeZ3y/XG6POztGrgr9p/KgQcYhZYnkp186lVTHsa+f29uH9fpuc
         OAi3ik/5qnkNT3Y3/xurYREnMcCflyTEDrYVFhTHiZP5VAIppyt2aS0ntfsK6MIFLU3z
         MSyb1JaxullwOS1SflTjB9a7IItRG0oGn1i+Zoq0gNtAg3vnR3meZb/bse9FZmZPVcc8
         t2mNGcnoeGT/XigL4CdkekqNrgLFKyIZm23UPF29xgfwhVwD07XOiireWJmw4PWXMRVd
         qmXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=nxbx2Gu3pNsGIIkHE4Aq6pFS7gVhLt0Luwdty16xoJY=;
        b=jN7htxzqdGDdOkOmQ1O/dRbTFaHZEn+QD89spyaj7khLKK3dmDAZSOon5QqVUMd8Hb
         yQ40/5BNmhaykJRhNopxX25j1qUtIt+4UPxIBWwU7/wvSnqzUPkXBXxYIcHo/SnvuwDP
         4Yjged+8J7fwPhZepmIBYcZ70veGrwcIpgMFKWsyZ/DqP3spgTcpYc9VA1gHJOdJa7Uc
         BwrIhWnW7IggEqHcD81n/maALT+mierm/Rgbm6aq5BMG/ma0KkAUv8SBG+8Lu7Hg8gPG
         Wuh3YWt336Woeur4daCq03anHh5wIhA5rmRIVQKRuk/81SulQNswNQRlrGDjaZZZfMDK
         NpJg==
X-Gm-Message-State: AJIora99+z9qzwZXgabTVaLUny4+ZWAjrw5F3PPe/UEGHZLAo91EvVWd
        g9uELg3TOfTAd2tLjkWybUw4VFt7xns=
X-Google-Smtp-Source: AGRyM1uq3R9x49Lq0T9IbT8PgI6ixYUhfWXHVKhygHqYpz17ZzibBqyUrGgcH7JWZUli8v/DDPMN1A==
X-Received: by 2002:a63:2004:0:b0:412:5add:d041 with SMTP id g4-20020a632004000000b004125addd041mr9747742pgg.480.1657849437178;
        Thu, 14 Jul 2022 18:43:57 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id i27-20020a63541b000000b004161e62a3a5sm1991078pgb.78.2022.07.14.18.43.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Jul 2022 18:43:56 -0700 (PDT)
Message-ID: <5751e5c6-c7c0-70be-912f-46acb8c687cf@gmail.com>
Date:   Thu, 14 Jul 2022 18:43:55 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH 1/2] net: stmmac: fix dma queue left shift overflow issue
Content-Language: en-US
To:     Junxiao Chang <junxiao.chang@intel.com>, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        netdev@vger.kernel.org, Cedric Wassenaar <cedric@bytespeed.nl>
References: <20220713084728.1311465-1-junxiao.chang@intel.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220713084728.1311465-1-junxiao.chang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/13/2022 1:47 AM, Junxiao Chang wrote:
> When queue number is > 4, left shift overflows due to 32 bits
> integer variable. Mask calculation is wrong for MTL_RXQ_DMA_MAP1.
> 
> If CONFIG_UBSAN is enabled, kernel dumps below warning:
> [   10.363842] ==================================================================
> [   10.363882] UBSAN: shift-out-of-bounds in /build/linux-intel-iotg-5.15-8e6Tf4/
> linux-intel-iotg-5.15-5.15.0/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c:224:12
> [   10.363929] shift exponent 40 is too large for 32-bit type 'unsigned int'
> [   10.363953] CPU: 1 PID: 599 Comm: NetworkManager Not tainted 5.15.0-1003-intel-iotg
> [   10.363956] Hardware name: ADLINK Technology Inc. LEC-EL/LEC-EL, BIOS 0.15.11 12/22/2021
> [   10.363958] Call Trace:
> [   10.363960]  <TASK>
> [   10.363963]  dump_stack_lvl+0x4a/0x5f
> [   10.363971]  dump_stack+0x10/0x12
> [   10.363974]  ubsan_epilogue+0x9/0x45
> [   10.363976]  __ubsan_handle_shift_out_of_bounds.cold+0x61/0x10e
> [   10.363979]  ? wake_up_klogd+0x4a/0x50
> [   10.363983]  ? vprintk_emit+0x8f/0x240
> [   10.363986]  dwmac4_map_mtl_dma.cold+0x42/0x91 [stmmac]
> [   10.364001]  stmmac_mtl_configuration+0x1ce/0x7a0 [stmmac]
> [   10.364009]  ? dwmac410_dma_init_channel+0x70/0x70 [stmmac]
> [   10.364020]  stmmac_hw_setup.cold+0xf/0xb14 [stmmac]
> [   10.364030]  ? page_pool_alloc_pages+0x4d/0x70
> [   10.364034]  ? stmmac_clear_tx_descriptors+0x6e/0xe0 [stmmac]
> [   10.364042]  stmmac_open+0x39e/0x920 [stmmac]
> [   10.364050]  __dev_open+0xf0/0x1a0
> [   10.364054]  __dev_change_flags+0x188/0x1f0
> [   10.364057]  dev_change_flags+0x26/0x60
> [   10.364059]  do_setlink+0x908/0xc40
> [   10.364062]  ? do_setlink+0xb10/0xc40
> [   10.364064]  ? __nla_validate_parse+0x4c/0x1a0
> [   10.364068]  __rtnl_newlink+0x597/0xa10
> [   10.364072]  ? __nla_reserve+0x41/0x50
> [   10.364074]  ? __kmalloc_node_track_caller+0x1d0/0x4d0
> [   10.364079]  ? pskb_expand_head+0x75/0x310
> [   10.364082]  ? nla_reserve_64bit+0x21/0x40
> [   10.364086]  ? skb_free_head+0x65/0x80
> [   10.364089]  ? security_sock_rcv_skb+0x2c/0x50
> [   10.364094]  ? __cond_resched+0x19/0x30
> [   10.364097]  ? kmem_cache_alloc_trace+0x15a/0x420
> [   10.364100]  rtnl_newlink+0x49/0x70
> 
> This change fixes MTL_RXQ_DMA_MAP1 mask issue and channel/queue
> mapping warning.
> 
> Fixes: d43042f4da3e ("net: stmmac: mapping mtl rx to dma channel")
> Signed-off-by: Junxiao Chang <junxiao.chang@intel.com>

Thanks for addressing it, maybe a:

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=216195
Reported-by: Cedric Wassenaar <cedric@bytespeed.nl>

would be courteous.
-- 
Florian
