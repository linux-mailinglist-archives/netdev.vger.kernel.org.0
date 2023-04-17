Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97F9E6E484F
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 14:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231279AbjDQM4x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 08:56:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjDQM4w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 08:56:52 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8520A5FF1;
        Mon, 17 Apr 2023 05:56:49 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id bn8so22291118qtb.2;
        Mon, 17 Apr 2023 05:56:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681736208; x=1684328208;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=p/WYagixcu7lhnkdecU9k/sD8leA/lo58sGesWAWIAU=;
        b=fSFUUoidCSIJRDk+LHX2ofChkdwl9yW+Onmqs0rEPS+L6Eaen12l1+NG21lKPE4mFx
         FsxOa8RVMJt781T3A21Go/H0vkb9+Vm+Qmdbc+m7Q0u4x3KBqEiwMEPi004wra/Yo8jD
         x1YVDcxOnUAL706ps/J2u3vxCVgJu9/s7YOdnUpZWttxKrOJ5zIEii+DNVqg3oP7d5vH
         ctBk/Ksx/IPvurGm57tiJ/kQ1Cw9t2VVqvX3PaL5+NZvT6QrbrjiptfR0zoAOiR+DiYC
         VsYWRWOBrD2T9k8zj0uqtD1SA7Gt2gAOdnBpkvS4KJKRuD5EDyOhgq4sN2WsgDl8w4Hv
         4D4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681736208; x=1684328208;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p/WYagixcu7lhnkdecU9k/sD8leA/lo58sGesWAWIAU=;
        b=D1V0AfBAbqg/4Nm2B7IJY4KhGGcD/z3r5gaH2TkAKSV/ZoxJnw62ssjRMKoMnCtoBS
         6kTim1efRQ9wNKNZbo69bIh/q+5/eOkuDeBoIruwtqP7U6e3k/xz/W8axCn3e9Lg0xL3
         D5VoPb3YlPn04uJEES9rJLF6UpykwJ/1uCaQTyBi5phBBori7XQwYsw2Y44EqVpcwMh4
         ExouzUf95jiqgnqhbLPQjVk1Mj8TrCzqIR7jJGb9jJa2iPzo7UXZQsZrNo+WTinK9n66
         EJFYh72eoQiJ3Ef4A4ugW2OUkQ21cDcYYHCljE+fdznNBGb9G5geOX2TXG/3t7w/0FUR
         KOTg==
X-Gm-Message-State: AAQBX9drw01tk7G2VVWyEF9maxG2DOOvcv+0lmHBZfH9dD9DXFqa7cNz
        2it0OzmbnuXeuD49AiPkoVE=
X-Google-Smtp-Source: AKy350bfKlow+X99kiUdW58GAcGuJwiYiZBHzCl5fyRBt6N1USBVzptI9yKh4MxZgMjGs0Bgdqu5JQ==
X-Received: by 2002:ac8:5b8e:0:b0:3eb:143a:7424 with SMTP id a14-20020ac85b8e000000b003eb143a7424mr15822255qta.15.1681736208445;
        Mon, 17 Apr 2023 05:56:48 -0700 (PDT)
Received: from [192.168.1.105] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id s21-20020a05620a081500b0074abbf22b68sm3083141qks.136.2023.04.17.05.56.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Apr 2023 05:56:47 -0700 (PDT)
Message-ID: <16c9427f-7f00-276a-0b7c-f6533e4481f3@gmail.com>
Date:   Mon, 17 Apr 2023 05:56:45 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 1/7] net: mscc: ocelot: export a single
 ocelot_mm_irq()
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
        linux-kernel@vger.kernel.org
References: <20230415170551.3939607-1-vladimir.oltean@nxp.com>
 <20230415170551.3939607-2-vladimir.oltean@nxp.com>
Content-Language: en-US
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230415170551.3939607-2-vladimir.oltean@nxp.com>
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
> When the switch emits an IRQ, we don't know what caused it, and we
> iterate through all ports to check the MAC Merge status.
> 
> Move that iteration inside the ocelot lib; we will change the locking in
> a future change and it would be good to encapsulate that lock completely
> within the ocelot lib.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
