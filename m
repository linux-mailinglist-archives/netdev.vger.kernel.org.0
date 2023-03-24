Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 164EA6C8840
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 23:21:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231826AbjCXWVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 18:21:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231719AbjCXWVo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 18:21:44 -0400
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4204F17163;
        Fri, 24 Mar 2023 15:21:37 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id oe8so2643150qvb.6;
        Fri, 24 Mar 2023 15:21:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679696496;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NPgsXniYhetPiplXeUdFyG0XrmXzlHgyAZjCHLN+e8M=;
        b=RTwJ80/XoVTIJArNv0vRTH+9Kzx+lqBrPJz2fNI7pOGFtUEdNbb6SXyafZrjwQA9gb
         0a2hBUOcKAkFxOPwvd/IeuKXsbxkX+RqsZzEQY+RBvJfFPVIlcyyVsD42AhKDrySQnDu
         AMGgl68kqelV0fb6H3+LNj7mEXF6coY04rwd3jV0/8RhUh4CkGO7UERpn4MET+FKWCun
         cgdBz9D+uTBo61EYzeQ4wlcTRyPFLDfYK0IJ81TiYLZDmUiN79V3C4vypmuK9pbUIpJf
         Ap+9foaFIv2op/13vGUw1Cm1hK8TokkaLGPEKGAEk8JMX0fWwcY1RU/oPbgKqD0dcQ51
         pQFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679696496;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NPgsXniYhetPiplXeUdFyG0XrmXzlHgyAZjCHLN+e8M=;
        b=oMqVKB1b9xJVoa0Hpo7c/tPQbIcWUAb2qFYojAvxZKLcShD6o6+olXsnw4ZKbhsEHc
         a/XCwXLWxMnqq627uVqB9FxTxl7Q+jqxq7vBrRnk3JWgFDCwGcKbKKxJbRse+kcn79g/
         D9wDODkxbovjqVMSFRpN2JJi5GqkPIoKmCncB7mDLkc91vLPD9zdkPdWVI8EHTukQUFB
         A+LoBw0LCx1UzuA02a/+hrYV+LGR2DIE7hFG+zjVl7ygTYgeC5/18lJYfL4xQswKaHRF
         T83WzsKPksqf2Kjcdtia93rl8PKYo2yCUkwpsatdKGTt0H3Xo975mo8Gmy4lrkexU9k/
         WT6g==
X-Gm-Message-State: AAQBX9f6ExYY7wRmBFImsJ1zVJlhTYYYG+votc2RvZyofByNFNH+Dub7
        ssa64rmKOX4fN+EGM/uJxLJV7rZDE64=
X-Google-Smtp-Source: AKy350b3AUYSOERnPR321HXvNUH2W8lKR6ZTmZel1m7ZWLJCWNt7VxQneuq2j6Jk1fkJstez+7KUYw==
X-Received: by 2002:a05:6214:519b:b0:5a5:ba90:3b5f with SMTP id kl27-20020a056214519b00b005a5ba903b5fmr8106057qvb.14.1679696496388;
        Fri, 24 Mar 2023 15:21:36 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d140-20020a376892000000b007467a4d8691sm10757324qkc.47.2023.03.24.15.21.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Mar 2023 15:21:35 -0700 (PDT)
Message-ID: <17000c5e-1b26-ee88-424e-c14f97f14ee6@gmail.com>
Date:   Fri, 24 Mar 2023 15:21:26 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net v2 6/6] net: dsa: microchip: ksz8: fix MDB
 configuration with non-zero VID
Content-Language: en-US
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, UNGLinuxDriver@microchip.com
References: <20230324080608.3428714-1-o.rempel@pengutronix.de>
 <20230324080608.3428714-7-o.rempel@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230324080608.3428714-7-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/24/23 01:06, Oleksij Rempel wrote:
> FID is directly mapped to VID. However, configuring a MAC address with a
> VID != 0 resulted in incorrect configuration due to an incorrect bit
> mask. This kernel commit fixed the issue by correcting the bit mask and
> ensuring proper configuration of MAC addresses with non-zero VID.
> 
> Fixes: 4b20a07e103f ("net: dsa: microchip: ksz8795: add support for ksz88xx chips")
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> Acked-by: Arun Ramadoss <arun.ramadoss@microchip.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

