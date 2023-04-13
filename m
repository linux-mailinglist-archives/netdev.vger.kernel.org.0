Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5FB66E1347
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 19:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbjDMRQC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 13:16:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjDMRQB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 13:16:01 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74E444EF2;
        Thu, 13 Apr 2023 10:16:00 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id e3so4255140qtm.12;
        Thu, 13 Apr 2023 10:16:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681406159; x=1683998159;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=if+eweMpKSPw4ABoMbVMDGxTF36ZdVsMnlzvEryPtKs=;
        b=qaKN/MLnxUQcthWApLlSBdpvdv19s0p1x5z3lzpzzTx39vs2YbBJuNZbeLJJNOyIBb
         nF08e0k6lCQdQxMo4kEO+mgaVZq/sB/9MRvuc/8Zf49lDZqb6W0YtcNZI4p+dL0wilVB
         oAsj09HuNSwVfIkNtNn+wE4mruVGQB3YeAlIs/vO1/1ZRLLLj/EFIP1IlI4btLXQT8P8
         cZxEJ1tjQ4+BXgJoufO10gwKWBi8R77KYbhZ3pnwnzNUyn8c4xMFMAKhiOlC/JJNnCcq
         XdnNVdemEije4GM33zv9zZiwPaNC2r2laF6ICKWlRutbXfzah5Uh5nVnj5npEaNZ0oF2
         cscA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681406159; x=1683998159;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=if+eweMpKSPw4ABoMbVMDGxTF36ZdVsMnlzvEryPtKs=;
        b=OyNLsVp9C93ZU7//BNvLFW3XC+MRLjzMf4nugc+e2QzqY0exUR+FAyT8aOFIOHZpat
         Vhff8Vhb3nbiClkWbEh5OJFyYYDqPDggpgv7ie0RQ4qOTnJWuHsUWNmPs89DCJETOgCE
         iLGZWvXqgXmg+VWY5EikRJ5NOy3CJew7m3DgLbZEYLb0nRizb7mQ0+DXt3xXM03u6bXb
         +SuGDD3QcTu2E/uQOe05UrbNJK7h5tfT4eu6uz4YUekQg+96n7BQRsb40h11mhodrBym
         E0JpEbfqAKaXPUgFH4bkGF+IWqXSND+qVwazMK7+3jt2eTtPivPwYwdfQzkKsi2kzn5i
         2HnQ==
X-Gm-Message-State: AAQBX9fR9tP2fT0mpLc9ZvAzscMEgB2FGQGYSLDwLONvQaM36T0RLY5d
        YGEzFCqZ4yDxTXzQQhcUbuM=
X-Google-Smtp-Source: AKy350bF7+ZZYGyT4ws/zJC4Ya+Onaht9i9MWm9l0F72FmoZ0P+iN43eXwa0ekkd9ppUWtfl+4zK/Q==
X-Received: by 2002:a05:622a:120c:b0:3e4:e9c9:df70 with SMTP id y12-20020a05622a120c00b003e4e9c9df70mr3529740qtx.10.1681406159380;
        Thu, 13 Apr 2023 10:15:59 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id bk37-20020a05620a1a2500b0074add69317bsm109446qkb.121.2023.04.13.10.15.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Apr 2023 10:15:58 -0700 (PDT)
Message-ID: <298c045a-5438-6761-46d8-c46c57989812@gmail.com>
Date:   Thu, 13 Apr 2023 10:15:55 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next v4] net: stmmac:fix system hang when setting up
 tag_8021q VLAN for DSA ports
Content-Language: en-US
To:     Jacob Keller <jacob.e.keller@intel.com>,
        Yan Wang <rk.code@outlook.com>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, kuba@kernel.org,
        mcoquelin.stm32@gmail.com
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "open list:STMMAC ETHERNET DRIVER" <netdev@vger.kernel.org>,
        "moderated list:ARM/STM32 ARCHITECTURE" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "moderated list:ARM/STM32 ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
References: <KL1PR01MB5448C7BF5A7AAC1CBCD5C36AE6989@KL1PR01MB5448.apcprd01.prod.exchangelabs.com>
 <01ef9d4f-d2dc-d584-4733-798cffda49a1@intel.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <01ef9d4f-d2dc-d584-4733-798cffda49a1@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/13/23 10:07, Jacob Keller wrote:
> 
> 
> On 4/13/2023 8:06 AM, Yan Wang wrote:
>> The system hang because of dsa_tag_8021q_port_setup()->
>> 				stmmac_vlan_rx_add_vid().
>>
>> I found in stmmac_drv_probe() that cailing pm_runtime_put()
>> disabled the clock.
>>
>> First, when the kernel is compiled with CONFIG_PM=y,The stmmac's
>> resume/suspend is active.
>>
>> Secondly,stmmac as DSA master,the dsa_tag_8021q_port_setup() function
>> will callback stmmac_vlan_rx_add_vid when DSA dirver starts. However,
>> The system is hanged for the stmmac_vlan_rx_add_vid() accesses its
>> registers after stmmac's clock is closed.
>>
>> I would suggest adding the pm_runtime_resume_and_get() to the
>> stmmac_vlan_rx_add_vid().This guarantees that resuming clock output
>> while in use.
>>
>> Signed-off-by: Yan Wang <rk.code@outlook.com>
> 
> This looks identical to the net fix you posted at [1]. I don't think we
> need both?
> 
> [1]:
> https://lore.kernel.org/netdev/KL1PR01MB5448020DE191340AE64530B0E6989@KL1PR01MB5448.apcprd01.prod.exchangelabs.com/

Unfortunately both still lack a proper Fixes: tag, and this is bug fix.
-- 
Florian

