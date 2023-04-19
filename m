Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B9046E8098
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 19:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231135AbjDSRq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 13:46:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbjDSRq6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 13:46:58 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2FA66EB5;
        Wed, 19 Apr 2023 10:46:53 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-63b5c48ea09so138120b3a.1;
        Wed, 19 Apr 2023 10:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681926413; x=1684518413;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gN1jXwBzB0d4vJ3HAROf5vGP/BoUprWYOVnYD2aX2+g=;
        b=oM07+JMt+/vxm37e1dPbnODzICttFXthG8YW6h/nv1QxOzfkX37h5PQIw7zeHAWpZO
         wcHC818fTaFJ9zuPmVWbsV0XoGfreo38u9mnwTNvvTw+2md2yBH5Arv55j6Zc4LxrJno
         TICz12BjikX50UdWFK5yXU5oRwCDh2gZnJEu/Hg9/CfahMZG/TkKy3CiUwC1BxsnVl2i
         KfUi4/VeBmMe3CGrMQxP5l1R90jyffUsFV/t4tTgBWJHwrJUX5QYbrqXWHkZI29/8lPZ
         PC1doq5cOUbQWkoUd8Hbyo4sPgWBnuI+nkGycS9BmsbPgZfA+kjuIpiaPHjGp/Zsw8qB
         WxkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681926413; x=1684518413;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gN1jXwBzB0d4vJ3HAROf5vGP/BoUprWYOVnYD2aX2+g=;
        b=QQy0+IW3ICBIPAmgm9YNhFBSxMGyA2m66J+Wp63Mn1a2oPmx8VPBDeA2kQNJBSksc8
         BdoxrdRZZDG/uuBa5xoOUt8Wv5lTq9V7UObn9L+MlFuDq2TNp9c/65Sca9xTAChkWJwE
         +Mejr7NDFbFW3T+wE4ZdT0+KwASZ+3nVYNRBIsR0YQKcQgSxbRv/nHPoSg4CLCrNOgs/
         WwnENFUAitfhDvosSRUTmW9C69ZsW9qPT/KbL3ijztNf4G7PJw8UQtqJ5zjGNc1tIhp3
         CJDuO4tUb0cBuVuAldu3AbOgydyVz8RPX8pZ0YBT5jYCgnhaW4ujbdvem18AUVJf0A/y
         P6+A==
X-Gm-Message-State: AAQBX9fFY0AUeAbXSGd1C6hNvGMUglZmB3Qn6dvx1Rd3tnU6YQsLzc8H
        0UgafzSLzjQ78wvWqJ5rkfY=
X-Google-Smtp-Source: AKy350Z/bc3KGlsrFe6N7bC4r053yRhgstgCOEdWANmdqR2nX7TH+utlPdMOt9PcXswrVw7tHZfj9g==
X-Received: by 2002:a17:902:dac9:b0:1a6:3af1:9c3a with SMTP id q9-20020a170902dac900b001a63af19c3amr7518632plx.22.1681926413115;
        Wed, 19 Apr 2023 10:46:53 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id jw19-20020a170903279300b0019f3cc463absm11757546plb.0.2023.04.19.10.46.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Apr 2023 10:46:52 -0700 (PDT)
Message-ID: <a42c2a76-0a70-8544-16d4-0d1ce5c53ef7@gmail.com>
Date:   Wed, 19 Apr 2023 10:46:46 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net] net: dsa: microchip: ksz8795: Correctly handle huge
 frame configuration
Content-Language: en-US
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Oleksij Rempel <linux@rempel-privat.de>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org
References: <43107d9e8b5b8b05f0cbd4e1f47a2bb88c8747b2.1681755535.git.christophe.jaillet@wanadoo.fr>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <43107d9e8b5b8b05f0cbd4e1f47a2bb88c8747b2.1681755535.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/17/23 11:19, Christophe JAILLET wrote:
> Because of the logic in place, SW_HUGE_PACKET can never be set.
> (If the first condition is true, then the 2nd one is also true, but is not
> executed)
> 
> Change the logic and update each bit individually.
> 
> Fixes: 29d1e85f45e0 ("net: dsa: microchip: ksz8: add MTU configuration support")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

