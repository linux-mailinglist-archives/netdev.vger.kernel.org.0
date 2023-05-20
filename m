Return-Path: <netdev+bounces-4046-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E883B70A4AC
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 04:54:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 788661C20B43
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 02:54:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D09E5636;
	Sat, 20 May 2023 02:54:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3557632
	for <netdev@vger.kernel.org>; Sat, 20 May 2023 02:54:19 +0000 (UTC)
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1C85E45;
	Fri, 19 May 2023 19:54:15 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-64384c6797eso3134154b3a.2;
        Fri, 19 May 2023 19:54:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684551255; x=1687143255;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mG6nPHHvLhCRp6hw5zssT3HnTGNDFbEKlVUElYpacVI=;
        b=BzEQpqpkv05j9izGvRa/Kc6/0CzpEmOjqOmytho8xWjqmfoXL9HPpPBoopKHhbLPBn
         feHiKzY6LDs/C+mujSkZUixPEtU9+kXbQUCXm3zUzuIXtF8LR3h2WZo2J/nSzqu4TF7+
         kjen2D4ctrhIzFYIUAIjCfKffh3U/whcpNu3atQaE35YFMo9B2vBqdlkzPkaXoSASQwA
         /vLIWZKXBblbS4iTK/S8Gglkk/j0Dwnuu+M1nNvTfsSUzGkYuc5RW1htrka6efswyXyM
         oyqUq7w4MfzQpj/uXepKL2RFqJYev8EsR8N9Cuy6rE3yViy5ZfmUsPMELowy/U4Zm3mE
         yxzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684551255; x=1687143255;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mG6nPHHvLhCRp6hw5zssT3HnTGNDFbEKlVUElYpacVI=;
        b=WFtF3S0jt1pgxYt5mEqWoTdHjlde9DSXklQSAGRjEfJMKxofpYnWkQI/Gpt3IfSJJY
         cH1OkBMigRrdak3oLgyeqSE5QnQU9K+sBC315CS7BSQkSfxqrnyRadmeu+JL+OqudEIj
         MXSIL4HuLYWxezQiIm9gDh02Lti4tybcomIL4yipn1W2DcT3TrmL/+8/4qfATHrJE+lA
         wOYpIPr2OVPLTCFFCo+H7VdzNIgXUMM17IdZ/y4PbuRpWPd9q1YYW2l9oXnQGOGIdBPZ
         S6rc0+8o7Ip0yJOtKpgQUeMT1dw4vS+bBulvIUcDHAjCXPZxrclrO7bxQD9YcJJKCOcZ
         jrpw==
X-Gm-Message-State: AC+VfDx1XVQUc+t+NBwf/1Wn0Mr2A1+Rj5F10pr5W7kurYxUp7bZw+MH
	8Wk2dXD9uKQMV+DmpjU1Zfb1nlzP5v9hJw==
X-Google-Smtp-Source: ACHHUZ5QH6UDSzYl15L1x3E8eyRI07vL0kKu7EQmM+p2K22pj44/x03QEJVH9p38i5qIT5DhO/cvHA==
X-Received: by 2002:a05:6a20:6f01:b0:100:5082:611d with SMTP id gt1-20020a056a206f0100b001005082611dmr3428675pzb.32.1684551255051;
        Fri, 19 May 2023 19:54:15 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id a21-20020a62bd15000000b0064389eab4c8sm314729pff.126.2023.05.19.19.54.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 May 2023 19:54:14 -0700 (PDT)
Message-ID: <7a1d4bf8-7ad2-daac-4822-9e1cdac35c89@gmail.com>
Date: Fri, 19 May 2023 19:54:12 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH net-next v2 2/7] net: dsa: mv88e6xxx: pass directly chip
 structure to mv88e6xxx_phy_is_internal
Content-Language: en-US
To: alexis.lothore@bootlin.com, Andrew Lunn <andrew@lunn.ch>,
 Vladimir Oltean <olteanv@gmail.com>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Richard Cochran <richardcochran@gmail.com>, Rob Herring
 <robh+dt@kernel.org>, Krzysztof Kozlowski
 <krzysztof.kozlowski+dt@linaro.org>, Conor Dooley <conor+dt@kernel.org>,
 Russell King <linux@armlinux.org.uk>
Cc: netdev@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
 paul.arola@telus.com, scott.roberts@telus.com, =?UTF-8?Q?Marek_Beh=c3=ban?=
 <kabel@kernel.org>
References: <20230519141303.245235-1-alexis.lothore@bootlin.com>
 <20230519141303.245235-3-alexis.lothore@bootlin.com>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230519141303.245235-3-alexis.lothore@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/19/2023 7:12 AM, alexis.lothore@bootlin.com wrote:
> From: Alexis Lothoré <alexis.lothore@bootlin.com>
> 
> Since this function is a simple helper, we do not need to pass a full
> dsa_switch structure, we can directly pass the mv88e6xxx_chip structure.
> Doing so will allow to share this function with any other function
> not manipulating dsa_switch structure but needing info about number of
> internal phys
> 
> Signed-off-by: Alexis Lothoré <alexis.lothore@bootlin.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

