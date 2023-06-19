Return-Path: <netdev+bounces-12030-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BD12735BDB
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 18:03:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0038E281191
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 16:03:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8065113AD4;
	Mon, 19 Jun 2023 16:03:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F05C13AC3
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 16:03:12 +0000 (UTC)
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A2A71AB;
	Mon, 19 Jun 2023 09:03:11 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 5b1f17b1804b1-3f8fe9dc27aso23359895e9.3;
        Mon, 19 Jun 2023 09:03:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687190589; x=1689782589;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0JT52z/QSGQQNpxiH41WXj61FqSaKcbLdlhQV31bTV0=;
        b=dUJrR3LckPsF7iVBaxtvI9erHbfGaO7p41VJqcPAM0ZwOmjB+BYY5zucEa3FEBftyL
         NXCKt4m8hqmV+AL3vhVTflcZxIYDqKNs8AaSIWIkACP3pL7TGBp6TsTGFU/3WoHQh5H7
         0Wm2gGR78NFMM4PSRO+XaLURyfyKXX/tBJnMhOLxdRs3jmOxGn2s2lri6RVrbFCSzp07
         LzDqm3Z8ZwTwmhfrOzwxHpMT9IJRe1lXrKChwAVRW9Ixn4AtPkrN7MA48wCE8jWrTD1x
         +5o0KnfP8DgsFXzwxgs77bqGqwgVxy1TK2NgXWCmF8XVSgvAL3fKTQ7bQViYMB5ub9Aj
         hZ8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687190589; x=1689782589;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0JT52z/QSGQQNpxiH41WXj61FqSaKcbLdlhQV31bTV0=;
        b=ld8WHK7Wy7RjLuZW6p8IQ/kxwlRn+w8iPbAO1sUIV/GKQP/cZq+Iw6xoz21CxjPW49
         rP65J/YSvMxv4HRdBcdAzOUB1AGOxyjBE5ThdCn7aPVOG35cAjT4pI+l00n4OMhcyg48
         /kKe1isvjf8tm3yZE72AtbBxdhy+Cjg7a0bHjdeuzUoFeBmIm2G9T6b2KZwpRNn0THVg
         T7osWevq1tQjfu+qpxnnz6EttKBC3GLGnKHcSWi3CQT0rHW9JvW7UsyKEjVtKajJJYOU
         dx8HX6ZcXkd9I7996pB1nadS+bARJWZPMtx8aCIJox9IKJPb4j6o2/i88DRdRy0UjrRX
         IKag==
X-Gm-Message-State: AC+VfDxVXZXfSXkEN4HP01MAmyst9bSD2qpAZx3+s8yl0hntcqthUsDT
	zfNH6KuEjULaGfsjnE81DvA=
X-Google-Smtp-Source: ACHHUZ7KYyetJcEHN9RbZJTu8ode90pZ16ABQJQdstGPiG0uMLuxpD3SFIFESNnGNnnCoB/ITa6DRQ==
X-Received: by 2002:a1c:4b05:0:b0:3f8:f76e:7160 with SMTP id y5-20020a1c4b05000000b003f8f76e7160mr6243161wma.16.1687190589255;
        Mon, 19 Jun 2023 09:03:09 -0700 (PDT)
Received: from [10.178.67.29] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id n13-20020a5d67cd000000b003111fd2e33dsm10037519wrw.30.2023.06.19.09.03.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jun 2023 09:03:08 -0700 (PDT)
Message-ID: <dc3f6f27-d9e9-859a-a42e-1ba71db9c860@gmail.com>
Date: Mon, 19 Jun 2023 17:03:07 +0100
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH net v6 3/6] net: dsa: mt7530: fix handling of BPDUs on
 MT7530 switch
Content-Language: en-US
To: arinc9.unal@gmail.com, =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?=
 <arinc.unal@arinc9.com>, Daniel Golle <daniel@makrotopia.org>,
 Landen Chao <Landen.Chao@mediatek.com>, DENG Qingfang <dqfext@gmail.com>,
 Sean Wang <sean.wang@mediatek.com>, Andrew Lunn <andrew@lunn.ch>,
 Vladimir Oltean <olteanv@gmail.com>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Russell King <linux@armlinux.org.uk>
Cc: Frank Wunderlich <frank-w@public-files.de>,
 Bartel Eerdekens <bartel.eerdekens@constell8.be>, mithat.guner@xeront.com,
 erkin.bozoglu@xeront.com, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org
References: <20230617062649.28444-1-arinc.unal@arinc9.com>
 <20230617062649.28444-4-arinc.unal@arinc9.com>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230617062649.28444-4-arinc.unal@arinc9.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 6/17/2023 7:26 AM, arinc9.unal@gmail.com wrote:
> From: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> BPDUs are link-local frames, therefore they must be trapped to the CPU
> port. Currently, the MT7530 switch treats BPDUs as regular multicast
> frames, therefore flooding them to user ports. To fix this, set BPDUs to be
> trapped to the CPU port. Group this on mt7530_setup() and
> mt7531_setup_common() into mt753x_trap_frames() and call that.
> 
> Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>

Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

