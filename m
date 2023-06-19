Return-Path: <netdev+bounces-12032-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 297E7735BE1
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 18:05:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C6F21281157
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 16:05:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D98AA134D0;
	Mon, 19 Jun 2023 16:05:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65EA12B72
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 16:05:44 +0000 (UTC)
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15B671AC;
	Mon, 19 Jun 2023 09:05:43 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id 2adb3069b0e04-4f85966b0f2so4070462e87.3;
        Mon, 19 Jun 2023 09:05:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687190741; x=1689782741;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UI7Qxth8NezKT347a5lsc7FJ3+yAwxaQk/gKBF6pegs=;
        b=Lzdmzlmhsm9p2phcCKQpo9RtcIvwWXoX9HbRLEAzR5L+2B6Q6/AWzB51+YRw8vPaLI
         kLYT70BmjnkdDTnlLFpsj3DNYRI0Cg+m7LfXTNXOPzCZPV1mL+zIuMWYw85zx8m88H3m
         DSbnE/2RB9HeW6MmuLfHQNj/PEWP2SKK2NEDW2LQcV4ymtJw2rhL0RZW7VxWama3B/Eu
         qe3T3uwcrSaYh9LbPTA22ackFg2NOfYZEU1E/cH1S/+10ltHRsOJpFOqh6TnJOFaQgO2
         fjuqwndhziKx3CY+gmPeZ0wXRAZ9eqF6qRd/ayyfEr1wYcVeE49BH1OjgVXc9GIAiiX1
         Xfew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687190741; x=1689782741;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UI7Qxth8NezKT347a5lsc7FJ3+yAwxaQk/gKBF6pegs=;
        b=HW4q8Ng/XLFWsdQQMVPTsWCqv5vEdqUADAO/tFAkuPc9iFb7m2XRNlLkGoBPcbLhT/
         Srjgkcij4JEMe0GBdjq0YfU12Cb1OBzBMawq2rye1M0gU/o1dAjFI8Yyb8aXEAbvpNQY
         hnQqKVUUez6QRPu2U4/1b+TL6lqFT4YgamSXfTv+zX4VXo6Evz7xPY9Nvf/y67SGTRn9
         dzFL1Vf6IEWo7mJKnDiiAvtzEs1O6kDHXvQlweQBOdPUTL6HtFcKYecfBgP7O3UkrGIl
         lDnxG+GNme77Uyy9d/rQEBd9PJL+wEgBxYLnzavmnqXtva4lxfuro/um1px7u9aKeqBW
         zpHQ==
X-Gm-Message-State: AC+VfDzdl90gZTXxiYnkrx5K8m+z2+QHnNqCThypH6l/IR2aYPy5f5TA
	3jsVT4VZ45gVno6KBJ+nrgI=
X-Google-Smtp-Source: ACHHUZ4m8cn+yV30xolDA0cbfTWa05+/tAhRPCf2gj3ioNCe9RcoVfaoT3viK5m0Yfsqqi+WKmFRag==
X-Received: by 2002:a19:5f18:0:b0:4f3:80a3:b40a with SMTP id t24-20020a195f18000000b004f380a3b40amr5987016lfb.69.1687190740896;
        Mon, 19 Jun 2023 09:05:40 -0700 (PDT)
Received: from [10.178.67.29] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id r19-20020a05600c285300b003f605566610sm11093368wmb.13.2023.06.19.09.05.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jun 2023 09:05:40 -0700 (PDT)
Message-ID: <7ae6c8cc-d347-2eda-364c-dcefd8a2ce24@gmail.com>
Date: Mon, 19 Jun 2023 17:05:39 +0100
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH net v6 5/6] net: dsa: introduce
 preferred_default_local_cpu_port and use on MT7530
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
 <20230617062649.28444-6-arinc.unal@arinc9.com>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230617062649.28444-6-arinc.unal@arinc9.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 6/17/2023 7:26 AM, arinc9.unal@gmail.com wrote:
> From: Vladimir Oltean <olteanv@gmail.com>
> 
> Since the introduction of the OF bindings, DSA has always had a policy that
> in case multiple CPU ports are present in the device tree, the numerically
> smallest one is always chosen.
> 
> The MT7530 switch family, except the switch on the MT7988 SoC, has 2 CPU
> ports, 5 and 6, where port 6 is preferable on the MT7531BE switch because
> it has higher bandwidth.
> 
> The MT7530 driver developers had 3 options:
> - to modify DSA when the MT7531 switch support was introduced, such as to
>    prefer the better port
> - to declare both CPU ports in device trees as CPU ports, and live with the
>    sub-optimal performance resulting from not preferring the better port
> - to declare just port 6 in the device tree as a CPU port
> 
> Of course they chose the path of least resistance (3rd option), kicking the
> can down the road. The hardware description in the device tree is supposed
> to be stable - developers are not supposed to adopt the strategy of
> piecemeal hardware description, where the device tree is updated in
> lockstep with the features that the kernel currently supports.
> 
> Now, as a result of the fact that they did that, any attempts to modify the
> device tree and describe both CPU ports as CPU ports would make DSA change
> its default selection from port 6 to 5, effectively resulting in a
> performance degradation visible to users with the MT7531BE switch as can be
> seen below.
> 
> Without preferring port 6:
> 
> [ ID][Role] Interval           Transfer     Bitrate         Retr
> [  5][TX-C]   0.00-20.00  sec   374 MBytes   157 Mbits/sec  734    sender
> [  5][TX-C]   0.00-20.00  sec   373 MBytes   156 Mbits/sec    receiver
> [  7][RX-C]   0.00-20.00  sec  1.81 GBytes   778 Mbits/sec    0    sender
> [  7][RX-C]   0.00-20.00  sec  1.81 GBytes   777 Mbits/sec    receiver
> 
> With preferring port 6:
> 
> [ ID][Role] Interval           Transfer     Bitrate         Retr
> [  5][TX-C]   0.00-20.00  sec  1.99 GBytes   856 Mbits/sec  273    sender
> [  5][TX-C]   0.00-20.00  sec  1.99 GBytes   855 Mbits/sec    receiver
> [  7][RX-C]   0.00-20.00  sec  1.72 GBytes   737 Mbits/sec   15    sender
> [  7][RX-C]   0.00-20.00  sec  1.71 GBytes   736 Mbits/sec    receiver
> 
> Using one port for WAN and the other ports for LAN is a very popular use
> case which is what this test emulates.
> 
> As such, this change proposes that we retroactively modify stable kernels
> (which don't support the modification of the CPU port assignments, so as to
> let user space fix the problem and restore the throughput) to keep the
> mt7530 driver preferring port 6 even with device trees where the hardware
> is more fully described.
> 
> Fixes: c288575f7810 ("net: dsa: mt7530: Add the support of MT7531 switch")
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>

Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

