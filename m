Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB396BE7BC
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 12:12:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbjCQLME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 07:12:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjCQLMD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 07:12:03 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0670A3D0AB
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 04:12:02 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id h17so4058239wrt.8
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 04:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679051520;
        h=content-transfer-encoding:in-reply-to:from:cc:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BLvbIMNTRopdsyC+nocssss+sDwT2aSgg+1sW68vqC8=;
        b=BwHvEV0sSgSddrFg8Hh1PIODNIC4ZMIWk/WZ1/H8yVNaF2x5z8Yr9lWbZNNYI/rBOu
         DpVNT8piax9oCQ13pAtybc7mDBlTvSuvhEQT8dt1OeyQRuqsZJVIM1popNh4370ikXfX
         4AI6vaonuyk4vUo/OzX3u3LDSxQvQkEeBSmex7eBcQBecl/to7QY10vECy3PnWZqdPE1
         17sJvjzW3kSl/aFed4G3y4m4arbOlcoFNMCkq4o4hLYPenIR9YppVpwHKNrLvb5pX5qL
         w1/toteI7Rfzn9N9qnCIjjdXeUlJ888CgRa+eaCGupMfrbLxoX0sOR77Sc0/MO4QLGb3
         emPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679051520;
        h=content-transfer-encoding:in-reply-to:from:cc:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BLvbIMNTRopdsyC+nocssss+sDwT2aSgg+1sW68vqC8=;
        b=j1JXAN8ydIqotmPL0WVo+4uXQd3IiKy/57CLfb5Aql8V7W/mpKxWzkfkdC0LbJRpo3
         823PUI5Ud8AP4tDA03pjcY2pa4OLFOy4xALhhAI7Ir5t3MHNhEJiZd2Rrmb8S/Fox4B2
         yjnlHieDjhGcu3WTI9/2buxHHfMlkPcVlNnP0eeBXY+q7qsUxqlqrYtUS8sh5Jq+qdT1
         1sz1BSGi4bAKBsCcm/1bm5By9vRBNFPWiIJiA9Z/F6t0xuPLoJZqWsUi4ARuMruC+w8X
         YmzqhvgaKf9ausHr53r7gEjKAvCA28k7iWkwWtc7xJTTR/r/4MNBsUMzAjWUKlhNVjxd
         NUqQ==
X-Gm-Message-State: AO0yUKWxa55BTwXbsnkelEHGEOEkDqqImg6RMpEaNYnE5BsQSyFerzv4
        UqjfaZsuFGsZM4MSaBGcABc=
X-Google-Smtp-Source: AK7set+kPpz2rTcrCHDFHOaC7PT0iilmLneVSracyniXNf2WDkA/qbHYje1YTQNFKxpyapxsjcoBOw==
X-Received: by 2002:a5d:44cb:0:b0:2cf:f3ea:533e with SMTP id z11-20020a5d44cb000000b002cff3ea533emr5462870wrr.63.1679051520303;
        Fri, 17 Mar 2023 04:12:00 -0700 (PDT)
Received: from [192.168.2.177] ([207.188.167.132])
        by smtp.gmail.com with ESMTPSA id e13-20020a5d4e8d000000b002ceacff44c7sm1709369wru.83.2023.03.17.04.11.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Mar 2023 04:11:59 -0700 (PDT)
Message-ID: <17b68361-98b1-6cbc-a3cf-32094ae14f2e@gmail.com>
Date:   Fri, 17 Mar 2023 12:11:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [BUG] mt7986 doesn't allow to re-enable ethsys clock gates after
 they have been disabled
Content-Language: en-US
To:     Eugene Konev <uejikov@gmail.com>,
        linux-mediatek@lists.infradead.org
References: <ZA0qBQJRt4ZZpV2J@uejikov.net>
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        Daniel Golle <daniel@makrotopia.org>,
        Network Development <netdev@vger.kernel.org>
From:   Matthias Brugger <matthias.bgg@gmail.com>
In-Reply-To: <ZA0qBQJRt4ZZpV2J@uejikov.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+CC relevant people.

Hi Eugene,

On 12/03/2023 02:25, Eugene Konev wrote:
> When ethsys clocks (eth_fe_en, eth_gp1_en, eth_gp2_en, eth_wocpu1_en and
> eth_wocpu0_en) are disabled calling clk_enable on them doesn't enable them
> again (appropriate bits in the register stay 0).
> This prevents using mtk_eth as module, because kernel disables all unclaimed
> clocks with clk_disable_unused.
> 

Is this a regression? Were you able to bisect the issue to see which commit 
introduced this behavior?

Regards,
Matthias
