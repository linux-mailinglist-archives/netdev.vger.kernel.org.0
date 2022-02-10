Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E85014B0514
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 06:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233865AbiBJFap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 00:30:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232288AbiBJFao (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 00:30:44 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3569D10C1;
        Wed,  9 Feb 2022 21:30:46 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id h7-20020a17090a648700b001b927560c2bso3286005pjj.1;
        Wed, 09 Feb 2022 21:30:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=G+Xf5+kl8M2a83dPNCaXl/Uqn6Ak38SsCrY0mbgnccQ=;
        b=U4f4EJM9XH1MjFx4duY9S1GjsEVjOJvFtBR/IZSdITv6Mv2+aSbc300x8YLZKtgiw3
         We0weBp9UGd8oiNjip7+sld2k4hSWcPaAXPvtoVj79r5JtdFU5jv3ZxOgSjTY3g1DQGV
         VOCTl7JtTLJ+B8qVRXFs8mI4W6WqwyDbgM697nv+2YACbrF48LWnYmVzal51FzzddtyQ
         IW7+BLDaD6ziGkYaob7/Bp9X3MIXEMIO7duLxn5ovQujM9VGEXlfsIly+xcgFn0PAejc
         DP5r3KgdtVpG+HqiGf4GhBRzt/j1Aq+UExTxylnDc80p5OiQGL3k/JLNSF58TdvjRIMM
         jj1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=G+Xf5+kl8M2a83dPNCaXl/Uqn6Ak38SsCrY0mbgnccQ=;
        b=fghK1AC4+IpLXAbeuo7PjhIifP4WIDh99wvlmQjH+iWtPEhB1PP0RPXCeXLEBDiDs+
         bsVQDw4A/C2uggHYD6LATqqXUeKLU69+NMEHZG2mVe2DWSVhL9U5eAGTx6yguMxKj/H/
         /huowJkGTEXFbfxd9TVM9abBbIHjjTaj9wsz9jbh8l+jFGOXxlpNc860nvTsa+yd0yy/
         zD3V8tWNCKNruhUo6BsLDMjyZQI2VQDoE6pRlLHdp5gySv/xZLP4i9eNmLR6ZQOodj04
         +zS34mFl0b0B9jev3kLZgIhsWRKMHHYV5M9oq0J9saqpO2FvLHYRS/nT1x32bMQCB+Uk
         JJKw==
X-Gm-Message-State: AOAM533ULc0gTVsYMbes4j69BtPv61LSwX3nkKvxtK7SKFWq23Mjg8nn
        AaIujMXNPmcUfvf8Dce9fgc=
X-Google-Smtp-Source: ABdhPJyW2x84cTJoF+iYo3AnT/9gCGN1V7DnIUcakbz1icRLry/zcAIEyVwcLFDM4L435ZMgLjSicg==
X-Received: by 2002:a17:90b:1d84:: with SMTP id pf4mr1053416pjb.106.1644471045737;
        Wed, 09 Feb 2022 21:30:45 -0800 (PST)
Received: from [10.0.2.64] ([209.37.97.194])
        by smtp.googlemail.com with ESMTPSA id p6sm8834260pfo.73.2022.02.09.21.30.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Feb 2022 21:30:45 -0800 (PST)
Message-ID: <8750f982-4e5a-27f5-491e-e844285ace59@gmail.com>
Date:   Wed, 9 Feb 2022 21:30:43 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH net-next 03/11] net: ping6: support setting socket options
 via cmsg
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, willemb@google.com, lorenzo@google.com,
        maze@google.com, dsahern@kernel.org, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, linux-kselftest@vger.kernel.org
References: <20220210003649.3120861-1-kuba@kernel.org>
 <20220210003649.3120861-4-kuba@kernel.org>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220210003649.3120861-4-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8
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

On 2/9/22 4:36 PM, Jakub Kicinski wrote:
> Minor reordering of the code and a call to sock_cmsg_send()
> gives us support for setting the common socket options via
> cmsg (the usual ones - SO_MARK, SO_TIMESTAMPING_OLD, SCM_TXTIME).
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  net/ipv6/ping.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


