Return-Path: <netdev+bounces-12031-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EE59735BDF
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 18:04:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ED4F0281134
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 16:04:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35540134C9;
	Mon, 19 Jun 2023 16:04:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2847B107A4
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 16:04:11 +0000 (UTC)
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5DB81AC;
	Mon, 19 Jun 2023 09:04:09 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 5b1f17b1804b1-3f90b8acefeso16707275e9.0;
        Mon, 19 Jun 2023 09:04:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687190648; x=1689782648;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=D9AtVjETMMA0uNeWNvxbxAkGopweBCJnF41QlXnhZiE=;
        b=bmewmS++ipI9v33uzYlWX9qwQ0eIRZOn4GJ+uVkAj7+vKL1gdO+q4eRK9pGG67mXBk
         aVcza5aBb49TK5e9F+8uv+QJW/nL0vavYTkTy77G8tkgL579xEVveAkCCgY+TR6pAEF5
         J0aaOEKQVHJIJ5DlFkfhyI75i1M0ZXMSfJiFsA6UxDAmIXzl/LWFyEOL1BU1HMMbtPna
         O/cZdB7kICixV0qrZT83J0usjilQIgPYLmA7sLqwRt0PEvBOT84Qeo2IFJiqQsnDT1Tq
         WVGEm99E+zytkbzm5DB7/IEHoYtHT+4s1XMvrb7d4UjO99lcml7k7ab590aP/OCcxIFZ
         /o9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687190648; x=1689782648;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D9AtVjETMMA0uNeWNvxbxAkGopweBCJnF41QlXnhZiE=;
        b=QTvL2wZ/U4dxL8QEE3Ni2iXxgDklJm9W5PAnbnxLffpDbK22QuIg42DTU1eCzmOPcS
         yB9poz2Cre+P+tm5p8PxRkOU91TF8EKYTaLEGSyPZZvsMqk8HN8SHVU5K33Le0qPBchL
         jInEu0OVTRpwFaHU01baVgRBtE+EtNH0DUQejxyyJL4fdNIxxbc1AllxnNkzq/sWVKFW
         4auH9qo6C3XshEs4uTV30cELNPtWiiohUY2zxbYp9VwF0Ge4X+5MnZ11/bAls7LrUHVA
         5EpXuo7gtV0l7WD5sAFp7g/l7tZwtmaBP7jTxry64fhTjcPT2Wwrpo8A51tXrL4ULmOa
         uKfQ==
X-Gm-Message-State: AC+VfDwePCfL9/p8Ke4G7DmCsPGjZN4OdtTN2NI/oR3yWreoHpp+pneo
	4dUQJkxwa7Q6qudqOPeoeKQ=
X-Google-Smtp-Source: ACHHUZ5pxxEROAXXrcpKG/Rtg2wI89PklYoAn8LH+pZ7DtJJzSFZEF5vcG8YLhRrPdYDjx7bZQfb5A==
X-Received: by 2002:a05:600c:aca:b0:3f6:4cfc:79cb with SMTP id c10-20020a05600c0aca00b003f64cfc79cbmr7053432wmr.31.1687190648119;
        Mon, 19 Jun 2023 09:04:08 -0700 (PDT)
Received: from [10.178.67.29] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id t13-20020a1c770d000000b003f91e32b1ebsm4680578wmi.17.2023.06.19.09.04.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jun 2023 09:04:07 -0700 (PDT)
Message-ID: <3889a231-5d26-e12c-748e-9199b37f5bd7@gmail.com>
Date: Mon, 19 Jun 2023 17:04:06 +0100
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH net v6 4/6] net: dsa: mt7530: fix handling of LLDP frames
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
 <20230617062649.28444-5-arinc.unal@arinc9.com>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230617062649.28444-5-arinc.unal@arinc9.com>
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
> LLDP frames are link-local frames, therefore they must be trapped to the
> CPU port. Currently, the MT753X switches treat LLDP frames as regular
> multicast frames, therefore flooding them to user ports. To fix this, set
> LLDP frames to be trapped to the CPU port(s).
> 
> Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>

Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

