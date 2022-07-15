Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3C88575963
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 04:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241213AbiGOCCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 22:02:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240858AbiGOCCw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 22:02:52 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEF92735A8
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 19:02:51 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id j3so3445598pfb.6
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 19:02:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=ZiT85LxoDak14atiUCDXe9UEy3mfRhjq1Tx2oHZahME=;
        b=EScfR5UcLiAfIZS4ALSpT8XyuYSwqlzkAa3bQm7IwGf/7Y0u19MlDOIo556/8M+8vl
         y+JgLmZ1gjx+cFyQaBzNyFhdVWL4YjazxkFyJdh8Kj3EEP6s+namBj9nQ/+tqwl3bvAA
         FIOvS9cNuC1Ruw4Ntpiw/RMYk91OVKzRGX2xHtgqQbWRhy9YXzKC9yfM0CTSn+PV4RnC
         YYSXod/Jw+d67RYRsaLpesL/Nlg5crgmoYqfn04+TOidBr4q43rNl4aoU7IYhbZ2HGoo
         mTDgKFb+yv+h39dJMsfTLmNrXTrE4/fQHe/VuGDApL6BYoRzpPmpqHZPRsmDajSQZ4RL
         NypA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZiT85LxoDak14atiUCDXe9UEy3mfRhjq1Tx2oHZahME=;
        b=manDVYyua9MKb2c4gMv0qSv/qz49nqa7asuc4l43kfGaH7ZLzvL5ANUlOy3ATCqvDO
         QEDP+hqGGsjAHcRVnJWcEWJhQjsur2EmmiDB6YxrKPfeHXrtJnYKkAtNI7Sz3JDwB1By
         7/ZO0fvNBj56L6hokG8rb6Hh1CbItBEwI3TbXaWNeYN65pZ41ReSIE3VmeM5zILPuYx9
         gv23Ca7BxR+B2eKmDtHX1xX808/9t3goxGnJ+Hyby0lOx88FsvSToSwYUPwZ4VS5lAW3
         hOcVPqalnyZr019UWEZOgaa1jf8z8YsqnzV3C+g6wZHcndUuCQHpBLgctVkw6PoZnGjh
         6JJQ==
X-Gm-Message-State: AJIora9WHQJtbafuPKJYSwkixnsgTMlwbjz/W+EjPOwnWr4p2oLDVrAW
        ovVLtOA3B84gdJdZt0jMOnQ=
X-Google-Smtp-Source: AGRyM1vB0XpLgjcNoGf66MdYWSG4HXNDmLg/9q5pbIS4hAxMHh1SkYMd8xh4bKa9HuYGdJPW/5uURQ==
X-Received: by 2002:a63:cd4e:0:b0:419:c3bc:2095 with SMTP id a14-20020a63cd4e000000b00419c3bc2095mr3866534pgj.390.1657850571077;
        Thu, 14 Jul 2022 19:02:51 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id n1-20020a170902e54100b0015e8d4eb219sm2177990plf.99.2022.07.14.19.02.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Jul 2022 19:02:50 -0700 (PDT)
Message-ID: <44ad1eca-19a7-4a89-fef8-1dc1f2b703cc@gmail.com>
Date:   Thu, 14 Jul 2022 19:02:49 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH 1/2] net: stmmac: fix dma queue left shift overflow issue
Content-Language: en-US
To:     "Chang, Junxiao" <junxiao.chang@intel.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Cedric Wassenaar <cedric@bytespeed.nl>
References: <20220713084728.1311465-1-junxiao.chang@intel.com>
 <5751e5c6-c7c0-70be-912f-46acb8c687cf@gmail.com>
 <BN9PR11MB5370EB8C8654FE18A3F142AFEC8B9@BN9PR11MB5370.namprd11.prod.outlook.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <BN9PR11MB5370EB8C8654FE18A3F142AFEC8B9@BN9PR11MB5370.namprd11.prod.outlook.com>
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

(please do not top post)

On 7/14/2022 6:59 PM, Chang, Junxiao wrote:
> There are two problems in Cedric's buglink(https://bugzilla.kernel.org/show_bug.cgi?id=216195):
> 1. There is UBSAN shift out ouf bounds warning.
> 2. Ethernet PHY GPY115B error and no IP addr.
> 
> I suppose my patch could fix 1st issue, not sure it could fix issue 2 or not.

Agreed, I think those are two unrelated problems your patch does 
definitively fix the undefined behavior. Thanks!

> I will update patch and append
> BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=216195
> Reported-by: Cedric Wassenaar <cedric@bytespeed.nl>
> 
> Thanks,
> Junxiao
> 
> -----Original Message-----
> From: Florian Fainelli <f.fainelli@gmail.com>
> Sent: Friday, July 15, 2022 9:44 AM
> To: Chang, Junxiao <junxiao.chang@intel.com>; peppe.cavallaro@st.com; alexandre.torgue@foss.st.com; joabreu@synopsys.com; netdev@vger.kernel.org; Cedric Wassenaar <cedric@bytespeed.nl>
> Subject: Re: [PATCH 1/2] net: stmmac: fix dma queue left shift overflow issue
> 
> 
> 
> On 7/13/2022 1:47 AM, Junxiao Chang wrote:
>> When queue number is > 4, left shift overflows due to 32 bits integer
>> variable. Mask calculation is wrong for MTL_RXQ_DMA_MAP1.
>>
>> If CONFIG_UBSAN is enabled, kernel dumps below warning:
>> [   10.363842] ==================================================================
>> [   10.363882] UBSAN: shift-out-of-bounds in /build/linux-intel-iotg-5.15-8e6Tf4/
>> linux-intel-iotg-5.15-5.15.0/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c:224:12
>> [   10.363929] shift exponent 40 is too large for 32-bit type 'unsigned int'
>> [   10.363953] CPU: 1 PID: 599 Comm: NetworkManager Not tainted 5.15.0-1003-intel-iotg
>> [   10.363956] Hardware name: ADLINK Technology Inc. LEC-EL/LEC-EL, BIOS 0.15.11 12/22/2021
>> [   10.363958] Call Trace:
>> [   10.363960]  <TASK>
>> [   10.363963]  dump_stack_lvl+0x4a/0x5f
>> [   10.363971]  dump_stack+0x10/0x12
>> [   10.363974]  ubsan_epilogue+0x9/0x45
>> [   10.363976]  __ubsan_handle_shift_out_of_bounds.cold+0x61/0x10e
>> [   10.363979]  ? wake_up_klogd+0x4a/0x50
>> [   10.363983]  ? vprintk_emit+0x8f/0x240
>> [   10.363986]  dwmac4_map_mtl_dma.cold+0x42/0x91 [stmmac]
>> [   10.364001]  stmmac_mtl_configuration+0x1ce/0x7a0 [stmmac]
>> [   10.364009]  ? dwmac410_dma_init_channel+0x70/0x70 [stmmac]
>> [   10.364020]  stmmac_hw_setup.cold+0xf/0xb14 [stmmac]
>> [   10.364030]  ? page_pool_alloc_pages+0x4d/0x70
>> [   10.364034]  ? stmmac_clear_tx_descriptors+0x6e/0xe0 [stmmac]
>> [   10.364042]  stmmac_open+0x39e/0x920 [stmmac]
>> [   10.364050]  __dev_open+0xf0/0x1a0
>> [   10.364054]  __dev_change_flags+0x188/0x1f0
>> [   10.364057]  dev_change_flags+0x26/0x60
>> [   10.364059]  do_setlink+0x908/0xc40
>> [   10.364062]  ? do_setlink+0xb10/0xc40
>> [   10.364064]  ? __nla_validate_parse+0x4c/0x1a0
>> [   10.364068]  __rtnl_newlink+0x597/0xa10
>> [   10.364072]  ? __nla_reserve+0x41/0x50
>> [   10.364074]  ? __kmalloc_node_track_caller+0x1d0/0x4d0
>> [   10.364079]  ? pskb_expand_head+0x75/0x310
>> [   10.364082]  ? nla_reserve_64bit+0x21/0x40
>> [   10.364086]  ? skb_free_head+0x65/0x80
>> [   10.364089]  ? security_sock_rcv_skb+0x2c/0x50
>> [   10.364094]  ? __cond_resched+0x19/0x30
>> [   10.364097]  ? kmem_cache_alloc_trace+0x15a/0x420
>> [   10.364100]  rtnl_newlink+0x49/0x70
>>
>> This change fixes MTL_RXQ_DMA_MAP1 mask issue and channel/queue
>> mapping warning.
>>
>> Fixes: d43042f4da3e ("net: stmmac: mapping mtl rx to dma channel")
>> Signed-off-by: Junxiao Chang <junxiao.chang@intel.com>
> 
> Thanks for addressing it, maybe a:
> 
> BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=216195
> Reported-by: Cedric Wassenaar <cedric@bytespeed.nl>
> 
> would be courteous.
> --
> Florian

-- 
Florian
