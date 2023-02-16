Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBFCF699D22
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 20:46:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbjBPTqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 14:46:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjBPTqe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 14:46:34 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 584BF4E5C7;
        Thu, 16 Feb 2023 11:46:34 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id r8so3230556pls.2;
        Thu, 16 Feb 2023 11:46:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FQn5kHbEuEI7/gCiY9gJDSgAt0MsyTYkQR3CtPg1TBA=;
        b=P3MOPqJt3MT9Gela1uA0v3HoCYDkwZRaN3In7MxigVxiF/CfRSWWa82e9bHtUKF2nr
         1/FKTIDuaxU3xOoxWIVwMeYWeOBYLnWB6agREUbbncDd4ER2Vaa5ghgB2v5XRGcHnapA
         Y4n8BP4DFYDOBnBQjcijTXZwOJ5I1G5oGwX7yzRGO5CqnVnNdYS+cJG5RU5hujgjsosF
         RoXvzIeHfRPx6alzf2wkNWcMyKX06ySqpIJjZmqt4heNx1XPEkipyVxCYfw3Dm3hiu4I
         cA3WnvupmR/Nilmj4XGTJg/ExgN3UCUkDWNTmncuLcvrqdZorV29NOklOb+T3aj0MPUO
         3FAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FQn5kHbEuEI7/gCiY9gJDSgAt0MsyTYkQR3CtPg1TBA=;
        b=YckklkPsfT8RsN+ooOENrxkr7RP686NTxfKjbRlhit+aemPgeuCAVLj8NP1i7XCOKx
         OqUhtTUN9jl+ffvTgG6yREcEyCGpqTU0cYY3s839yo6VKfkpBYiX37GQMfP+kb4hfDrr
         Fq6ydjOzhRwX6wM8edY418GWlp45QE8zKHgYFAGAsE8uqGYMAG3lZyxpxDsoWPffPHB2
         GBhQx+24aUFHYY1xpjXQqtJFYBoJ8ADaOxMMeTidFCH4WYk4CNvguNWVe04lAoMYk1yl
         H5OB1q6VUKhFAHVS5WkDR3XD67SfKfg7XCILxNmak9BeNFUqZoCOY1JoxORDFO+38rhq
         XogA==
X-Gm-Message-State: AO0yUKUV4ZaeK5mxe1jvZQ+5zxbOGYTGytDU28xhW3H/3H+38xnkZwvi
        +mqQx4FgQw+6aa6fqUUNlsk=
X-Google-Smtp-Source: AK7set+TfPacKB+pPKpTAkpFqha54VdEItkrfCIh0ZZ3/XtoiYYaIeWqgAKBFFAuYSz6VXRzmKy7OQ==
X-Received: by 2002:a17:90b:4d05:b0:233:e426:6501 with SMTP id mw5-20020a17090b4d0500b00233e4266501mr8509983pjb.19.1676576793782;
        Thu, 16 Feb 2023 11:46:33 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id h5-20020a17090a648500b00233e860f69esm3506220pjj.56.2023.02.16.11.46.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Feb 2023 11:46:32 -0800 (PST)
Message-ID: <05b4561e-ede0-4242-ee1c-c30628c08e3e@gmail.com>
Date:   Thu, 16 Feb 2023 11:46:30 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net] net: bcmgenet: fix MoCA LED control
Content-Language: en-US
To:     Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Stefan Wahren <wahrenst@gmx.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230216194128.3593734-1-opendmb@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230216194128.3593734-1-opendmb@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/16/23 11:41, Doug Berger wrote:
> When the bcmgenet_mii_config() code was refactored it was missed
> that the LED control for the MoCA interface got overwritten by
> the port_ctrl value. Its previous programming is restored here.
> 
> Fixes: 4f8d81b77e66 ("net: bcmgenet: Refactor register access in bcmgenet_mii_config")
> Signed-off-by: Doug Berger <opendmb@gmail.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

