Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41CAF6E494F
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 15:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231434AbjDQNFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 09:05:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231448AbjDQNFm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 09:05:42 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FDDAC16A;
        Mon, 17 Apr 2023 06:02:53 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id fy11so772739qtb.12;
        Mon, 17 Apr 2023 06:02:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681736511; x=1684328511;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jJIXoM5kZrcMxzMIBNvJFyOYulaQfBENBRWvgUZhs6A=;
        b=npG1dVxs8i1JQ/TgD7zhuAqJyCQXwyRb3LYhhAZLSoFBe979CASlJ7mcfkEl8bUoAl
         EX+iZCHcHu3BliLwGredk9RRcTldwJCJWQ/5X8DLE0A77YqN4QlVR6OyjRcx1A395rHo
         nOxwIDmTklBDxZVuxSNF6BYfaTuJvS5jA6jpTL9F5BENwcf7lyfB6ZjcBcYiQCrG/mmn
         I54JheNgapI7w7ON3V5nWG7rhKhD63rvQxX3Ehd3fedJpB0Wj8MLrw6bVX1RXMhYg5j0
         SlfqQHSj6hCQcXKdkjf6D97Slm+6KZOeblubzB+RdgUXNjdAT2AImWEs1dGvsrGwjPi6
         LFEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681736511; x=1684328511;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jJIXoM5kZrcMxzMIBNvJFyOYulaQfBENBRWvgUZhs6A=;
        b=XAu7aw0yEScR5YAdAxZPRgeIsBK0di3Er+jpL6lqV1T9sS+bacgo0VB27VoDdAe9Ai
         +qKPIVxjY5wZ6ZY5vw6hF30rvSiGx7b+EP/+Ru0olj13j8o71oxGhQ6bx60Nre2US751
         RX48EMpbwXj92UnHQjk0AdJXpt8SrT9/n4t6THE+1ouja18zlHRbUjG/1QkfWFKHGIBF
         sRaWikJoXa5+Xs6u5hbZXHDCqoMfKNFmr6r3KHMTvbUYSf5M1yV61UGLljIwj2jMImcy
         YSFlLDCCKou2JnCUzucbskhlL/wsljkpEOMTpQMcIOa++/NcfPCtsbZQcohNmjbLAou/
         iV/A==
X-Gm-Message-State: AAQBX9fA3JcII8zHt2HRQGh4+ll8htcZok4keb3hswH292TVJmghxizx
        AlasesBhDvKrnY06oAdrKsI=
X-Google-Smtp-Source: AKy350YdG1412f3+B0KPTn68ItjvFai9YX+yRqKc/mmINQWZ4dZQliuLj6MX0FLC/M7DLZSjqBzzsg==
X-Received: by 2002:a05:622a:110a:b0:3e4:eb53:b02c with SMTP id e10-20020a05622a110a00b003e4eb53b02cmr22940515qty.60.1681736510841;
        Mon, 17 Apr 2023 06:01:50 -0700 (PDT)
Received: from [192.168.1.105] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id j20-20020ac84414000000b003e6610471c1sm95481qtn.16.2023.04.17.06.01.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Apr 2023 06:01:50 -0700 (PDT)
Message-ID: <7ecfc07e-ef71-728b-29cd-c41319c1d2b2@gmail.com>
Date:   Mon, 17 Apr 2023 06:01:32 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 6/7] net: dsa: felix: act upon the mqprio qopt in
 taprio offload
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        linux-kernel@vger.kernel.org, Ferenc Fejes <fejes@inf.elte.hu>,
        Simon Horman <simon.horman@corigine.com>
References: <20230415170551.3939607-1-vladimir.oltean@nxp.com>
 <20230415170551.3939607-7-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230415170551.3939607-7-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/15/2023 10:05 AM, Vladimir Oltean wrote:
> The mqprio queue configuration can appear either through
> TC_SETUP_QDISC_MQPRIO or through TC_SETUP_QDISC_TAPRIO. Make sure both
> are treated in the same way.
> 
> Code does nothing new for now (except for rejecting multiple TXQs per
> TC, which is a useless concept with DSA switches).
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Ferenc Fejes <fejes@inf.elte.hu>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
