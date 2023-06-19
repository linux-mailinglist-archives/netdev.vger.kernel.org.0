Return-Path: <netdev+bounces-12033-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DFD7B735BE3
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 18:06:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 99E1B2811A5
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 16:06:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF012134D1;
	Mon, 19 Jun 2023 16:05:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D32D3107A4
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 16:05:57 +0000 (UTC)
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAC9D1BE;
	Mon, 19 Jun 2023 09:05:56 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id af79cd13be357-7624012c0b4so232638285a.1;
        Mon, 19 Jun 2023 09:05:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687190756; x=1689782756;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MAG7rQupq4oWMLsKqHJ7tE/XqH6FjbJlLP3kpsmMAzE=;
        b=cWFr6cfNisMaiF8KA7shMPYkopIbeyGwZeRRWlMHD0ahMWoL9sw+/+Ln8gJ2/6/Aea
         xJDNSZwZ7Ujk1H9UT0ZRtve9N8Pepz0Sod20j1v0xechbRVo7BPp27ZRjA8QWxAuPaep
         s4eu8BkbrhxJPz2tpEf29bZuPzdDGlNM8woeBsvTzrfsgt+OqPXUDSkrw1NjOpJfdNey
         DKszbq4mT6ce93VXcqHg9I7+4iIpKPgSlKTmsoXTOStRwFYjeWJYkElZP7XalzYmnIKK
         KF0a7oKUyeJzYj5IKRtkFtEMS9Shq2gHkrGC8HVVzMs2W/e7NYOBF2y9G045Nh9Z844u
         bBFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687190756; x=1689782756;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MAG7rQupq4oWMLsKqHJ7tE/XqH6FjbJlLP3kpsmMAzE=;
        b=EZShQEkqw2zxsgpnY3qoJVx9eTNUVsWEmu4nM6+ht53o3J3BHjb9LD16fbJf1QkoSz
         HSmkdkTRz/f7QNOc/yP+xgxvM7Ewd2cQwwSy4N7utkcFbXpkwjkSYBtowtzUZV9mr0Il
         /Cyn8SrENFTgDYw946fMSVFl6ARbcEIhaZIZf72+qdkHJ6CpQOhnxTYrMzpj9j4St+j8
         1AI1DJ4S213xJqseVub0HIYL2o5vI5bDwDhd8e//hkPbI1m/Nc5mg348m1Zpm7fEjcSr
         WX4MdNT9yEp2IuKB0Q59hNDys2VWsSO0IHVbC14EocYmMLuWf3Xeyk8PKkg7JvWDeaRP
         zEng==
X-Gm-Message-State: AC+VfDwBiEtjJ50V9ccbG8itfT+fI9iTVx4AW7Zap7BkZwJKhu9za7OK
	LmhnIGrfNmETofaqnqcW8FdkKRA5JdGV+jHT
X-Google-Smtp-Source: ACHHUZ7A0FTyRgoZQBA5xxdHf2GAjLmeqwONxRsGT4cCME85kO/Le6UGR58og2ZTBKvA35SRyljzow==
X-Received: by 2002:a05:620a:192a:b0:75d:51a4:3310 with SMTP id bj42-20020a05620a192a00b0075d51a43310mr10847923qkb.53.1687190755757;
        Mon, 19 Jun 2023 09:05:55 -0700 (PDT)
Received: from [10.178.67.29] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id cx12-20020a05620a51cc00b0076211938e93sm89623qkb.46.2023.06.19.09.05.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jun 2023 09:05:55 -0700 (PDT)
Message-ID: <d35aaedf-6350-d7aa-93cf-78b183709198@gmail.com>
Date: Mon, 19 Jun 2023 17:05:51 +0100
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH net v6 6/6] MAINTAINERS: add me as maintainer of MEDIATEK
 SWITCH DRIVER
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
 <20230617062649.28444-7-arinc.unal@arinc9.com>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230617062649.28444-7-arinc.unal@arinc9.com>
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
> Add me as a maintainer of the MediaTek MT7530 DSA subdriver.
> 
> List maintainers in alphabetical order by first name.
> 
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

