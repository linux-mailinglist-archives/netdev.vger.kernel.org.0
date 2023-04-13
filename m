Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3686E0F4F
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 15:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbjDMNzw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 09:55:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbjDMNzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 09:55:50 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F5241734;
        Thu, 13 Apr 2023 06:55:50 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id e3so3588013qtm.12;
        Thu, 13 Apr 2023 06:55:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681394149; x=1683986149;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=a9HePoc1byCaDvU+7cJGg3q4HHTE302VhN9dMxtjV28=;
        b=IU3p539oEgXcSt7swb99qmrSMzBEaMueElgANoVE5v+GBN9XULkEkhWYM2x6lbZKR6
         CFxt6BpeulxKzzSN0Q7QAsFOGupBBFuR9Get8bhVa584vxuXrjJS1DZjcGcpnQa3a61T
         I8WyvwdzZF5y3hzj/0Dj4+EiGdDVIrKdq1znC5yC4ARC4b9j3dUW1Slry5dil2pphpXo
         G6E6HWYohUaGXOvf6cB9YvWyz2YWFWLOOldEX7wbqC4QMyr7r2lPxfd3a2nVkqaN5Uyq
         nHfjvGELVZdKXMWu5PGy965r7/W8KACQMaNscFGHKrEFwp3eiXthwzbGB9Xv3IFGSgkn
         QO7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681394149; x=1683986149;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a9HePoc1byCaDvU+7cJGg3q4HHTE302VhN9dMxtjV28=;
        b=Z9+tTc6UcQjMKsxNdHTOBijsgD2uiHfJctPxKM54oZ8Sc7xyh6po4XNre+KIa3Zby3
         RhXFfkIcsynTncr+CgckekzZZ03x0yDlWsYjE80qMWUxlWYi8VL5/szIr6L8hiTv9mBr
         dFPfmDaHfKuoSJMmWes8o5n7mla1mUXIqYSc648jRTbcghHZikZvwzzZyuAuzE0TkPJc
         CCwx/Cm9dzUKfIj0ZXUwhE5wmvKFmyJ0ohLMCDAil+1wljFLBYh229QSmrXgHXx0N0rv
         7Hvl0ApchhlxYd7ysXXtRSXZbrZWS9WsMuoRWAT7cca+tv2N7YlnNAJiFJBSK3uk4OJE
         Gv1w==
X-Gm-Message-State: AAQBX9dSmSzC/Fb6Wpct0DMNdtl7zM+JSKydHOfmYC+NKexbA9T/VZzT
        mqrHlYBWkXTC0C1t86HQ4sg=
X-Google-Smtp-Source: AKy350axQqcWdyjB+SucIWq7SiBVGiecJhizq+1cVRX/wBibDs0L/nrvkaMQ1InlqLOZeGrDIKdWXQ==
X-Received: by 2002:a05:622a:2c5:b0:3e3:8a0b:8c80 with SMTP id a5-20020a05622a02c500b003e38a0b8c80mr3117294qtx.41.1681394149054;
        Thu, 13 Apr 2023 06:55:49 -0700 (PDT)
Received: from [192.168.1.105] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id bj9-20020a05620a190900b007487c780f5esm475802qkb.121.2023.04.13.06.55.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Apr 2023 06:55:48 -0700 (PDT)
Message-ID: <81ebb6c3-ff6a-c8cd-ae5b-3a5594e9c9f9@gmail.com>
Date:   Thu, 13 Apr 2023 06:55:44 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [net-next PATCH v6 07/16] net: phy: marvell: Add software control
 of the LEDs
Content-Language: en-US
To:     Christian Marangi <ansuelsmth@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        John Crispin <john@phrozen.org>, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
References: <20230327141031.11904-1-ansuelsmth@gmail.com>
 <20230327141031.11904-8-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230327141031.11904-8-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/27/2023 7:10 AM, Christian Marangi wrote:
> From: Andrew Lunn <andrew@lunn.ch>
> 
> Add a brightness function, so the LEDs can be controlled from
> software using the standard Linux LED infrastructure.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> Acked-by: Pavel Machek <pavel@ucw.cz>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
