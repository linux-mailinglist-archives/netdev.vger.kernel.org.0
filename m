Return-Path: <netdev+bounces-10795-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B1E3173055C
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 18:47:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6D33228145C
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 16:47:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B784B2EC14;
	Wed, 14 Jun 2023 16:47:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABCCB7F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 16:47:33 +0000 (UTC)
Received: from mail-oa1-x2a.google.com (mail-oa1-x2a.google.com [IPv6:2001:4860:4864:20::2a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61663EC
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 09:47:32 -0700 (PDT)
Received: by mail-oa1-x2a.google.com with SMTP id 586e51a60fabf-1a98cf01151so268270fac.2
        for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 09:47:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1686761251; x=1689353251;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=R27xkHouwiZkXeja44yLdq7zfor4HSLUtt+KIbyx+eA=;
        b=0RHF1xSpUA2vXerUR6xOhrwsroObFkLih9Bg/2FGaYvVQe76qLzXAP/kzcQ3MCM+fM
         gO/rjG/iby8prwgBrWWN/WLD1aqCh0EhjuU6IXGR2ZRInaupamHMzYkp5lxNLVZ9SDS5
         5/Fvnyynug9i+70msKrr0H/DkCPBgXN9aRm/c0rp04loNCjJ6nD0s3PBZYf0kmthWWUk
         FLMvuMOYr1qg7GAuiS6wnpe7NWKhYWfUWc8ac0q+ksP9gjeHKPn1BvzQVt8YklHzfclO
         O1CAjhtCuXTI9SZP9o/wN0u/X6cAs+3YJjuf8XZRmTEKFgU+bsPR5xuDSSKjASWBVv2P
         5GQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686761251; x=1689353251;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R27xkHouwiZkXeja44yLdq7zfor4HSLUtt+KIbyx+eA=;
        b=Ne1BLFiYpR9J6m7V2KI1nnGqtI4trsop2j+frozWkYpWdZvlBJ6LGdwvwvFcO4Gz1a
         WjUy5gmSP7yONeWrSJzDrsVFy4lJ4ydx3fB24/v3IjSmzoOkYFRjFF4eEb339/Tk/Wsp
         wcifkiiievZFNJGrSj4vBQyx1IOwbeS3i0exbcaJHIIge2qN6cQwwfmg4+yuU3uqZV7v
         KES4UiEB6f4LppWEBj6dK6hJIWfcgKADdUE6XZ78Gk59X5COFFS54Bc2Ue7FMbB5x764
         AOT4z9eHQm9cr+SN7iawZQe1qcoLFor+0SmuNY92fpjmLMJ5bKNlqY3SRlD1NzowswFp
         Paqg==
X-Gm-Message-State: AC+VfDzIw6A65YJb+FJz+FhOCTpC9zHw6uQBaIf4lSzbxQQg2jNwiLzz
	EWPC47bPenWbvgtJf3x2WfuYzg==
X-Google-Smtp-Source: ACHHUZ7uxI6uPZnOCDPv1ZzF3HlzvJwVuZi0A178t64EyAqar8iHnj9X/gBEABjgp0gM9ZY+F54gtw==
X-Received: by 2002:a05:6870:52d6:b0:1a6:4f6a:8a72 with SMTP id p22-20020a05687052d600b001a64f6a8a72mr8394370oak.37.1686761251286;
        Wed, 14 Jun 2023 09:47:31 -0700 (PDT)
Received: from ?IPV6:2804:14d:5c5e:44fb:90ea:5d38:822c:1759? ([2804:14d:5c5e:44fb:90ea:5d38:822c:1759])
        by smtp.gmail.com with ESMTPSA id ne16-20020a056871449000b0019f4f5c8298sm8861346oab.56.2023.06.14.09.47.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jun 2023 09:47:30 -0700 (PDT)
Message-ID: <3b83fcf6-a5e8-26fb-8c8a-ec34ec4c3342@mojatatu.com>
Date: Wed, 14 Jun 2023 13:47:25 -0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v2 net-next 0/9] Improve the taprio qdisc's relationship
 with its children
Content-Language: en-US
To: Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Jamal Hadi Salim <jhs@mojatatu.com>,
 Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
 Vinicius Costa Gomes <vinicius.gomes@intel.com>,
 linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
 Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
 Peilin Ye <yepeilin.cs@gmail.com>, Richard Cochran
 <richardcochran@gmail.com>, Zhengchao Shao <shaozhengchao@huawei.com>,
 Maxim Georgiev <glipus@gmail.com>
References: <20230613215440.2465708-1-vladimir.oltean@nxp.com>
From: Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <20230613215440.2465708-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 13/06/2023 18:54, Vladimir Oltean wrote:
> [...]

Hi Vladimir,
Thanks for adding the tdc tests.
This series seem to have broken test 8471 in taprio but I don't see it 
fixed here.
Do you plan to fix it in another patch?


