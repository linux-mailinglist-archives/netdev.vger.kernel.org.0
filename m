Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B62196AD146
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 23:16:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbjCFWQO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 17:16:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbjCFWQN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 17:16:13 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 695B73E62B;
        Mon,  6 Mar 2023 14:16:12 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id c18so6631960wmr.3;
        Mon, 06 Mar 2023 14:16:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678140971;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/np7LTt0kPylI77w/zYzftVt9xv6o8UgeSBcijuygZ8=;
        b=OyY0qjlxGPI9MrjPz/G8v0QASAzgt1AATjxNJldMeDn5F+EIcmiWPVY+C53jA2X6Wa
         Mtf6jSV6rXP96ZrE9Lo4AT6AUO2E062uK/coUcMtuKYscSmdrfXPW6HMD4jxK7AWoyDQ
         cy4HjKazG4lcTrM1ecljphlDxla7TxUZpcOAIK/d4zBvt95mLc3OvkzBYdtpSW4QvFhr
         j5b6deICww2IHf6rOzROfnBeH48MId3e072VH00XcLP3MkFllrMdsNZe/+B+oKGv5cvX
         0L+M3MtJdfS3BoRFiNFLnYI4Bd/5GmF7UwLCQq8fq9c/oNXGvC3G+4sHPtVtSTtp92kz
         SnXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678140971;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/np7LTt0kPylI77w/zYzftVt9xv6o8UgeSBcijuygZ8=;
        b=gAGHV9/6kPijni/CiJ53POJUg6o91P2xyyYszwdY2xkG+sdNE/61ojMkpfTN+Uop/Z
         OqpXj5FyG9zrpmiiwakZ1a7tyZiK/kOfz7WKHLe/rw1wNkReMCiRpD7yOeBQLVwZ20iI
         t2/83hpmMVzRu06lIldLgDe7IRMjiWDTNvKQ6iGD3xuhLgO+nAzSliypwRF+CtF4DMCP
         NUeERRrAKMXXCV0uF//jOzbk2bbhS2/OWXZL1l4IGoES0WyylGiYOy/HYrWDDRISosoo
         DPE1T70rwhBIHUTzNYaCYHxI4s+PBXTnT+K/RtqfD4AiVsKFtydhd7ECt0kcjMiikCAP
         xbQw==
X-Gm-Message-State: AO0yUKXc9JKLFOsMq2rsdnWDEGVnZ0n+EfD2x3jwD+y6MM7ZDao7fqfb
        JQCojqjCtPqK269VIjnv0co=
X-Google-Smtp-Source: AK7set8me7kyk7DK81kOYPo/vCehL750oq9qIGwsvDqa4DCiaennXbMy4+03nGVf0UcUBtJN3w0sog==
X-Received: by 2002:a05:600c:444c:b0:3eb:39e2:915b with SMTP id v12-20020a05600c444c00b003eb39e2915bmr10513783wmn.31.1678140970738;
        Mon, 06 Mar 2023 14:16:10 -0800 (PST)
Received: from ?IPV6:2a01:c22:7bf4:7d00:9590:4142:18ea:aa32? (dynamic-2a01-0c22-7bf4-7d00-9590-4142-18ea-aa32.c22.pool.telefonica.de. [2a01:c22:7bf4:7d00:9590:4142:18ea:aa32])
        by smtp.googlemail.com with ESMTPSA id m23-20020a05600c3b1700b003daf6e3bc2fsm40143wms.1.2023.03.06.14.16.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Mar 2023 14:16:10 -0800 (PST)
Message-ID: <d5b3d530-e050-1891-e5c0-8c98e136b744@gmail.com>
Date:   Mon, 6 Mar 2023 23:16:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: linux-next: Signed-off-by missing for commit in the net tree
Content-Language: en-US
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
References: <20230307083703.558634a9@canb.auug.org.au>
From:   Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <20230307083703.558634a9@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06.03.2023 22:37, Stephen Rothwell wrote:
> Hi all,
> 
> Commit
> 
>   58aac3a2ef41 ("net: phy: smsc: fix link up detection in forced irq mode")
> 
> is missing a Signed-off-by from its committer.
> 

Seems to be ok, false positive?

net: phy: smsc: fix link up detection in forced irq mode
Currently link up can't be detected in forced mode if polling
isn't used. Only link up interrupt source we have is aneg
complete which isn't applicable in forced mode. Therefore we
have to use energy-on as link up indicator.

Fixes: 7365494550f6 ("net: phy: smsc: skip ENERGYON interrupt if disabled")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
