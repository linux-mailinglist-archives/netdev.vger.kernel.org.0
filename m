Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4876E494C
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 15:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbjDQNFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 09:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231532AbjDQNE7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 09:04:59 -0400
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58132B768;
        Mon, 17 Apr 2023 06:01:58 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id m16so13600098qvx.9;
        Mon, 17 Apr 2023 06:01:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681736456; x=1684328456;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YcmcOTzJu6ks4W+Xm1OQFHPsO0/0+fE8ApT88ZcqOZ0=;
        b=XYK8piwuriVyb0esGnYNkBji1A9kKEgAFfQ9G1/vITNBd9hsmLZ1OY9S9vw1sSPxcm
         WDwBLbknufOj2krrxo/MANaP4iiW2JNLEFGUgAeRPDW1yp+GpGnM+Ltrf9iC6wHxN1Sd
         hjBLq0eBrczP7U32gs/q1VaFZJVNRqpX1+zr3+wV14e7p2aIenABBh2LoIQcivqEwp5o
         PvwLH6Z0vyTtv8KO6hRipCUpqaqc4vx5zWs7Je5ieQ2jMRiEDZ0otQqZm3FMJzXOMTc1
         taPDIP171g6gNrc67GjFlkVuU/UTTY5UAeusJDQcL73gys1dddW+rNLLzTXtCEfYUlfU
         SE4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681736456; x=1684328456;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YcmcOTzJu6ks4W+Xm1OQFHPsO0/0+fE8ApT88ZcqOZ0=;
        b=SF3VJaHcfciy03K+WPNiEDchUH1IxND68PLYdf8h2MIXHDRgORiQFc+lotyJpCRuWo
         MTOzJNky7BdeQNkj1vatVC2hWq15A8eMMfPUrcueENvgHI2Zzh720tzwZHbzE2vjHLXi
         K5VAJCRuJNTEDTpTbAxnfHh3myVoG0qFGd2lVPuWlXMymrjSqsg7Ks8dDdNkEZU/HLJc
         608pmYXJw1pTrxObGmp6UGDCmJT6cMzwNVBXHEBzdCzqdN8zTZKpeolqRhdQAsMf1H0x
         N9WyyGRyHx7SYR6nhjyzbIrhJ7/xeNKr+WNNqg2wszf+NNWl/OdJLZYJcAfmrzo9j5SI
         tcxA==
X-Gm-Message-State: AAQBX9cWTsYRlAz5rVG6rc++NuXMP65EbMR32CiKS4VCnm8f7R4/Jxee
        f4GcSyp6Bn2A96BBvT8fmuM=
X-Google-Smtp-Source: AKy350axhTb7+McBcdBF5jvaNdl84UlK6+7CX3MSisCJXXiJPS/2fsG3Y1Fxnlhk4GuhPSSo2OsHBA==
X-Received: by 2002:ad4:5bcd:0:b0:56f:52ba:cce6 with SMTP id t13-20020ad45bcd000000b0056f52bacce6mr17623833qvt.19.1681736456173;
        Mon, 17 Apr 2023 06:00:56 -0700 (PDT)
Received: from [192.168.1.105] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id pv16-20020ad45490000000b005ef5dfea0b7sm2009783qvb.72.2023.04.17.06.00.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Apr 2023 06:00:55 -0700 (PDT)
Message-ID: <8b6c498f-c9a1-7841-c24c-7986878c2206@gmail.com>
Date:   Mon, 17 Apr 2023 06:00:52 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 5/7] net: mscc: ocelot: add support for mqprio
 offload
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
 <20230415170551.3939607-6-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230415170551.3939607-6-vladimir.oltean@nxp.com>
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
> This doesn't apply anything to hardware and in general doesn't do
> anything that the software variant doesn't do, except for checking that
> there isn't more than 1 TXQ per TC (TXQs for a DSA switch are a dubious
> concept anyway). The reason we add this is to be able to parse one more
> field added to struct tc_mqprio_qopt_offload, namely preemptible_tcs.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Ferenc Fejes <fejes@inf.elte.hu>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
