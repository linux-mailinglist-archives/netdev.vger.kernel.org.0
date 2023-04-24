Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F34B6ECAF1
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 13:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231390AbjDXLFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 07:05:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231642AbjDXLEr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 07:04:47 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41B6A3593
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 04:04:26 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-3f09b4a1527so44719685e9.0
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 04:04:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682334264; x=1684926264;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PSyUzwJitxcgLSy1Zrt3uHqeLlTMCiKexDikJn3hJw0=;
        b=sMefFmpX4DtwGcyYKeoVmamaNfVX+ucKV3hR+ws7Rrkv0FhwOjWox0cfUdnHkGlFqk
         YmTGcWtVnu6uW+BrwMXAj8JHtZ/h7QbdLMewixaKsDWjsn4BGlu76Ukcl0TmbxuaS0kL
         KsskVP72sk0+NFfTyhdS/BuqkQ3+9I9A9vx3GcbWwtzfGwb2wQ2Zxi3D5J3bvDUl/bXo
         eFlGXsnbMjm1n8og4DRSJWH8w1D88fJkIINtXZQeVpKaun0MA7cNSeE5v+9dCNa9I7C0
         KjW3HcUvgQV+HWIixH2mkvbBGrGYnALnW4HbYPzUxtkAgFmllwzMeyoiwQKFcaSPlJfV
         IVIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682334264; x=1684926264;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PSyUzwJitxcgLSy1Zrt3uHqeLlTMCiKexDikJn3hJw0=;
        b=I1wuv6riRCgwDL0uLBlViQB4sfRo+WXsAcrZyKYMhdGpalKiX2oqg1AD9GVTw+6CEZ
         FMWdSf5jkX1iPCeKtVlEnzQCO2Gk2EdBS8Sj0nW+mUqBMasyc1Z6JzK/YWYzpiG6R2Cq
         27zNC4leG0fNLPwUL9nWj3rRqbu/djmSz3XrAA9ZWm28RTc2/vFvgGZhV2ogFn29jIFM
         9M5xBR1Xr6i3C+nGvPjA0UC01IW2AKlnNqpf0vT1sfhH8ilpouisyAOIq3vO2soiM050
         lhGFfnB0wa2yU8WMg2+k82YlDRcwLdyMbmObDTq2TVzEPyEQ+5sLD2DISaqGiDNieGi+
         kJlA==
X-Gm-Message-State: AAQBX9c+ol9QvyG9Kys0sjwpuRbyHAeBkOMUKS7h8neiGu6/W+KdQfuB
        XWN11FHabOV42KFhRs5N/PI=
X-Google-Smtp-Source: AKy350YYlPzoLQxE9CbVGutLkMSAaqrTVSOfQ/Pf1cZl9xXnidM5THg0IdL+3Ij7K1Ohlt/AiPog2g==
X-Received: by 2002:adf:e686:0:b0:303:e387:aabf with SMTP id r6-20020adfe686000000b00303e387aabfmr6564383wrm.71.1682334264486;
        Mon, 24 Apr 2023 04:04:24 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id z16-20020a05600c221000b003ee1b2ab9a0sm11887106wml.11.2023.04.24.04.04.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Apr 2023 04:04:24 -0700 (PDT)
Subject: Re: [PATCH net-next 2/4] sfc: populate enc_ip_tos matches in MAE
 outer rules
To:     Jakub Kicinski <kuba@kernel.org>, edward.cree@amd.com
Cc:     linux-net-drivers@amd.com, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        habetsm.xilinx@gmail.com,
        Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
References: <cover.1682086533.git.ecree.xilinx@gmail.com>
 <d1fd9a055378a5e0f969d0ecb69ca2a4cd8257bb.1682086533.git.ecree.xilinx@gmail.com>
 <20230421210416.5a80e25f@kernel.org>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <daf08193-bc7e-eaf4-8df0-f75265b06fb2@gmail.com>
Date:   Mon, 24 Apr 2023 12:04:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20230421210416.5a80e25f@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/04/2023 05:04, Jakub Kicinski wrote:
> On Fri, 21 Apr 2023 15:19:52 +0100 edward.cree@amd.com wrote:
>> From: Edward Cree <ecree.xilinx@gmail.com>
>>
>> Currently tc.c will block them before they get here, but following
>>  patch will change that.
>> Use the extack message from efx_mae_check_encap_match_caps() instead
>>  of writing a new one, since there's now more being fed in than just
>>  an IP version.
> 
> Transient build breakage here

Whoops, I re-ordered patches and didn't check carefully enough.
Serves me right for rushing to beat the merge window.

FITNV
