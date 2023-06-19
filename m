Return-Path: <netdev+bounces-12019-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA884735B03
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 17:22:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 63774281015
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 15:22:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2BB712B75;
	Mon, 19 Jun 2023 15:22:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A50AF125D8
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 15:22:08 +0000 (UTC)
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68702FA
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 08:22:07 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id af79cd13be357-763a3032893so53502585a.2
        for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 08:22:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687188126; x=1689780126;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9Ws55WqLOr94TJJcHaTJRk8tsvB8lMgG4oUbwCDYkIM=;
        b=FAguCarM9bSJAve18bPXQXxe5GeRETOT9jTv6/IWZwyTSE6Z2PTICdoYYiES2rD/OU
         2Hd18m6TJhgd6P4PNVC3CDaz+XOmqAELqSmjlb7agsSQGd2cmrpr2AecdIXD9dkTzRVN
         FjzNrRXPVUgus1He+vUQABPT28B5Yl7hjmfTAIgc9U/PEJChHPmIBfHunLuyl166LgmI
         dgETN/DV5yI5Yqm4ZQ/zfolULhP6oMc9DSbsdGoHbBipfmAexMrCiSfDVxRJtRxu9c2i
         +1D2o2tO5jgCtRT2V2ow2hJTVzz7V4hbLHYkwnDkjEh4YkD5l1xBWFV9BFtGAu5mNHI6
         U7Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687188126; x=1689780126;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9Ws55WqLOr94TJJcHaTJRk8tsvB8lMgG4oUbwCDYkIM=;
        b=aADux7dE5cs5+Iv4OyFRTvkV1NBoI/PEFajoU3FO5RHHDzgYJrf4h99CG6xkAik1mx
         VIf60+Q/0m670QRdwpI4xHzxFcIRULEXLu7aJfvczh+2B3Ux7ToVHXK/NtuFm6j12Ns3
         +1Ts1RO6C7WJCQGfP9UBd4kI2zeqebvasNp3Q/1j3bKhqaPBY3P/or87Tx9V8zcUF+9a
         fW3ED531RBRS6WKsCGqEebAzl5Dng09T2vsY9UkZFD8q2AhMcjLCRVLHDJtnEXwE0lDm
         P6XRdOBqSug1JIRry6Gg0YQWSUk69AT/M10U0ijJLmyvf7SfMZm6pNf1jbnu2T1bxCLx
         /w8g==
X-Gm-Message-State: AC+VfDzgBRfr/+Sgqh2HJxJRjtuuKoHWCzCh0c/QKBJlPmFEOUCW409x
	vH3xx6V82r5N9Qb2nTEuL4U=
X-Google-Smtp-Source: ACHHUZ6HG21eab0UXuRXIWCM5vhK4z/FqFbusHLaoSVOvGZbTLACoRB9XQjnzLQe66kyeukL2zw2Ng==
X-Received: by 2002:a05:6214:19c8:b0:626:9ef:e21d with SMTP id j8-20020a05621419c800b0062609efe21dmr11584440qvc.10.1687188126507;
        Mon, 19 Jun 2023 08:22:06 -0700 (PDT)
Received: from [10.178.67.29] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id g4-20020a0cf084000000b0062df3d51de3sm80481qvk.19.2023.06.19.08.22.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jun 2023 08:22:06 -0700 (PDT)
Message-ID: <5c02e32c-a85e-f9ed-d432-9f1eaee54cbf@gmail.com>
Date: Mon, 19 Jun 2023 16:22:04 +0100
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v4 net-next 8/9] net: fec: Move fec_enet_eee_mode_set()
 and helper earlier
Content-Language: en-US
To: Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>
Cc: Russell King <rmk+kernel@armlinux.org.uk>,
 Heiner Kallweit <hkallweit1@gmail.com>,
 Oleksij Rempel <linux@rempel-privat.de>
References: <20230618184119.4017149-1-andrew@lunn.ch>
 <20230618184119.4017149-9-andrew@lunn.ch>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230618184119.4017149-9-andrew@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 6/18/2023 7:41 PM, Andrew Lunn wrote:
> FEC is about to get its EEE code re-written. To allow this, move
> fec_enet_eee_mode_set() before fec_enet_adjust_link() which will
> need to call it.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

