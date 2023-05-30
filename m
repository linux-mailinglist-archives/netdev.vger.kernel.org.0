Return-Path: <netdev+bounces-6491-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A896716A04
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 18:48:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 361DB281280
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 16:48:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 494CE1EA84;
	Tue, 30 May 2023 16:48:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A79E125CC
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 16:48:11 +0000 (UTC)
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6B57A7
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 09:48:09 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id 98e67ed59e1d1-256931ec244so1750600a91.3
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 09:48:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685465289; x=1688057289;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GNCeju7z0P6VE/eEpCp0zh9JQcoama2C4UpGD7KSi0g=;
        b=WMEZoCNOmSnqwFPjuC0PvTSgX41SH6EKBXcBpMjmlQ0W1JUbZQdzRLsvZ0HdUVB4KK
         1g2CmpTTD4wvj/hE5cruYZhVbGpS/RQicv+K1Jd/K/zTG1STqO9yvK9DRPvPCk8Sv48/
         rbdqHMxWAFTGJOMQbXOWUM1491RSIWYeUKQmq9Cm4ZJrq4JZUlbkJE+i2+os10BUJ6Mu
         mcguGFRLI3bmE9O1Iy2J0A7NZ26edJiUeH2HJ+Ax4ZkCRVlmN9CRqhWqGCX/Fb6XaLWY
         8P7ZAuma+uaHf3LkLaFWmhFTtgRAX9OMum2JySmt9hhU9a9FBjwjsghxDPDRNoOKYjQ7
         Dc5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685465289; x=1688057289;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GNCeju7z0P6VE/eEpCp0zh9JQcoama2C4UpGD7KSi0g=;
        b=CmQjzcZFI3Duo0T9qh5y/tqUsTE0cv+D4c6FcWvefEo1EyJXs+YXK4LNa1NYcw1SGS
         5HNTNt7DiEKgD5zhy0SZgMGgGWbxyCX02MImVl1mPS/1eWbodDGfALVJW4v3waIIUwlQ
         bKuji3+lg3IVsdtKwZ/qdDwmooH02Kif0neGFUb332tG68cYeVE0hwLohp6Lf5K6sKFE
         Hm91n6bwFptqthSzLWdqxoSdnWtZjZRqYfjpLzSuUgIwpQpBuD8DWDRVdEHxZJx3l4dh
         UZohXRjJGAWltZTQZTE/hWvXHaVUHhYRcVwiURgzHG+iEiB+mFAbImrVCRz47h2218Da
         At/Q==
X-Gm-Message-State: AC+VfDxEw1qZ53yV2dgmb7cvtPLzKA0XWmAoyKiWbtrmSYGNRT9s2AyR
	8KvOPFSzJr7wVxMxsDQDzq4=
X-Google-Smtp-Source: ACHHUZ7jvz6CdWA4mi8j5EuEbJQJ7x7qQNKE2q24AMszR/U+v6MMbT0tQVxNmZBvb3UNKRwk7+rHIA==
X-Received: by 2002:a17:90a:4cc1:b0:256:bef3:4158 with SMTP id k59-20020a17090a4cc100b00256bef34158mr2618417pjh.21.1685465289173;
        Tue, 30 May 2023 09:48:09 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id s17-20020a17090aad9100b002564dc3cb60sm5846989pjq.9.2023.05.30.09.47.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 May 2023 09:48:08 -0700 (PDT)
Message-ID: <5c00f429-16aa-f602-73d1-55c4a3689648@gmail.com>
Date: Tue, 30 May 2023 09:47:25 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net-next] net: dsa: Switch i2c drivers back to use
 .probe()
Content-Language: en-US
To: =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>,
 Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Woojung Huh <woojung.huh@microchip.com>,
 UNGLinuxDriver@microchip.com,
 George McCollister <george.mccollister@gmail.com>, netdev@vger.kernel.org,
 kernel@pengutronix.de
References: <20230530063936.2160016-1-u.kleine-koenig@pengutronix.de>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230530063936.2160016-1-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/29/23 23:39, Uwe Kleine-König wrote:
> After commit b8a1a4cd5a98 ("i2c: Provide a temporary .probe_new()
> call-back type"), all drivers being converted to .probe_new() and then
> 03c835f498b5 ("i2c: Switch .probe() to not take an id parameter") convert
> back to (the new) .probe() to be able to eventually drop .probe_new() from
> struct i2c_driver.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian


