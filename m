Return-Path: <netdev+bounces-6575-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E21C7716FD3
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 23:37:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5107E1C20D78
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 21:37:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD7DE31EF8;
	Tue, 30 May 2023 21:37:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD23200BC
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 21:37:01 +0000 (UTC)
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DBE812A;
	Tue, 30 May 2023 14:36:38 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id d75a77b69052e-3f6b2af4558so25127731cf.1;
        Tue, 30 May 2023 14:36:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685482597; x=1688074597;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fHf9vP6jMymdnOxZ5gRRNT+qlSTVrioWK0ppkHd5JVs=;
        b=de1d5NEIJA9DuBPhmk9ICiEKhk2vNYbF5YmXpuHtzRpHb/fBB40mCbDsTklfwC5fCw
         kqdyvBA4a9X22i0YmCAUgZ/7beIxmu7S3HUXfj/M8x9srV+vsTwDyK3MwZgaluMctQUs
         i+QBkF5wPfc+jKig5/l/VEoezX5LQjqrVNie0Llou4ja0FUcfbfhoE6XlCmIY8nUafpR
         A7HTmrssDCAXupRB2cd3SDEfvsvfQfDWXy73XF0nQZQ/zdsbw914faaVObcUIfaeObZL
         Mqvtg8T6Ig5eiQ0apPbPNtKhmDLvCYH6HCmS10akGbBJXw03rSqbE2cKDXR82qg1+7Qc
         pa2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685482597; x=1688074597;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fHf9vP6jMymdnOxZ5gRRNT+qlSTVrioWK0ppkHd5JVs=;
        b=C5ow946+w3URfm6Zc4vCYMyqdvZyn2YoDm1p0tD6h/7QJDY63zopdB+fnOKxzmKpQn
         gbIdC3f3QYRdZjMpbHH/NvPWRAXro+M6H+7M2UfRtjQtcvuo8eQCAYHtfkta0MRW0v95
         0AR07eUp6hU8K0NARVsNu7kc0O+Uk08UeVX5W3g8rq3TmR7NNHz6+M9UT6V+sTs8q3+c
         rKx4+A95OT1db5MyCeELFgpNVwv20jVZivsGvPRkcxW5SnGYSfUcK1cb86C7Zpi3flNW
         jXZ7k7lX7xarHWPAf4uyYSkzwH4Sc8i1/CKzGcj8LuOHDNYkycGvVh8ep25JPx/0XfmX
         iWlA==
X-Gm-Message-State: AC+VfDy9pMMTsSBoKNabSL7eKjqaDlU7NClcDKEHT8IRUAYTKCGdZMba
	aClczYcAplzLR3prUbgQifk=
X-Google-Smtp-Source: ACHHUZ4vg9sldmblS5b0sKMbThnQ/Omf0cj89OMS0FY9jiHF8jq/zL0MNGqjO3OSNGWET9h39Ei5hA==
X-Received: by 2002:a05:6214:f01:b0:625:9b35:eeda with SMTP id gw1-20020a0562140f0100b006259b35eedamr4665511qvb.26.1685482597604;
        Tue, 30 May 2023 14:36:37 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id du10-20020a05621409aa00b006238b6bd191sm888709qvb.145.2023.05.30.14.36.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 May 2023 14:36:37 -0700 (PDT)
Message-ID: <5470d4e5-97b7-0be7-53f6-b1a276f6c558@gmail.com>
Date: Tue, 30 May 2023 14:36:26 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v8 1/3] net: dsa: Define .set_max_frame_size() callback
 for mv88e6250 SoC family
Content-Language: en-US
To: Lukasz Majewski <lukma@denx.de>, Andrew Lunn <andrew@lunn.ch>,
 Vladimir Oltean <olteanv@gmail.com>, Russell King <linux@armlinux.org.uk>
Cc: Eric Dumazet <edumazet@google.com>, "David S. Miller"
 <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Alexander Duyck
 <alexander.duyck@gmail.com>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20230530083916.2139667-1-lukma@denx.de>
 <20230530083916.2139667-2-lukma@denx.de>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230530083916.2139667-2-lukma@denx.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/30/23 01:39, Lukasz Majewski wrote:
> Switches from mv88e6250 family (including mv88e6020 and mv88e6071) need
> the possibility to setup the maximal frame size, as they support frames
> up to 2048 bytes.
> 
> Signed-off-by: Lukasz Majewski <lukma@denx.de>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian


