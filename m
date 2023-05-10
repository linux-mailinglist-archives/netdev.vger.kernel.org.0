Return-Path: <netdev+bounces-1563-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 007306FE4BE
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 22:03:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AFB5C280FC6
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 20:03:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A74961801C;
	Wed, 10 May 2023 20:03:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CF3A174DE
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 20:03:45 +0000 (UTC)
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6B9F4214
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 13:03:43 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id e9e14a558f8ab-3313fe59a61so18504435ab.0
        for <netdev@vger.kernel.org>; Wed, 10 May 2023 13:03:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683749023; x=1686341023;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Tgd/sjMmo9AYGKpvHAHKHprdpi0OVuw3v1GAdU1uOtE=;
        b=BEEyyY/UjHHA03eunbK4TTeyOA0gLrTG6Q77Vt6lxnJ4CacD7tp37RGd++JbTD8YQJ
         nxA86WCX/GMudQDCf+KIoxXtIAh8IgCKdaAMkZkfVj0KUHJioRvXpRcSo5XnRk7ogUpJ
         vg1v34Z7IcGMV/rlIE6tNdKkLSq3bn+AHrlUQPd1jBB3ARgNt8sUpgyrUDgR4GHA0Qqf
         +Ht0r06+/CC6kYmk4UUkwXvyxFCiKt9cmoxMdb9ErycFtk1XH6CcXYxoHIOB6Noj2Kl9
         XPIoK07h7yGzszByiAOQGOc24bbdJ0dgbd13x/OkiHy3d1Z7UPZrhyjQcJdHGvlzHHsa
         7x9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683749023; x=1686341023;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Tgd/sjMmo9AYGKpvHAHKHprdpi0OVuw3v1GAdU1uOtE=;
        b=UTsTAcX2HojUKvI1RQP85c/d/mX6F/a3DxdO7SAi18GKoHzRlWI9VtAdiNyAzV9+IS
         w4637/f2S6iUnehU5atgeqhbnHfjvYLHvgbgQClEN9169OH4RExcwYRP2poUum76Zgd6
         zcgLGmAZGiY9OuCBv/S+CXDWtH4L6b3cpXKNOwATblaeK8P9e7w2WPLwC1cWqM5TSqRb
         gZyDf/7ntzxcYq+4O7SqJTDihFmDffK1/577CKXLGfnrmm1oB+8dM2gRo0HjtahdAr5U
         uzOGrvSqebhB4hk2X3CsbZukJAcIE6/rL/048rEDLr+oIT8R02OtlLFqzHUX8iiLZqQL
         0cIw==
X-Gm-Message-State: AC+VfDwLaRQzWizT06XgReRsUq1a15Aw57rwiTXkds4vOagOf6+wuW3G
	uzoYdaSDJpFBIkIvpo+AufS+IWQBK/k=
X-Google-Smtp-Source: ACHHUZ4W+91dLauduJAcjceU54dZNQ9nmkZjOO39nUAZIj+V8p9rC6LedaJiv6gWFruL2zbCgGMlYQ==
X-Received: by 2002:a92:d7c5:0:b0:325:b96e:6701 with SMTP id g5-20020a92d7c5000000b00325b96e6701mr14347244ilq.2.1683749023148;
        Wed, 10 May 2023 13:03:43 -0700 (PDT)
Received: from ?IPV6:2601:282:800:7ed0:48d8:5aef:b6e2:d7dc? ([2601:282:800:7ed0:48d8:5aef:b6e2:d7dc])
        by smtp.googlemail.com with ESMTPSA id l17-20020a922811000000b0032f8a284f99sm3983062ilf.20.2023.05.10.13.03.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 May 2023 13:03:42 -0700 (PDT)
Message-ID: <0dc70546-627c-f44e-2293-d8b59da5200f@gmail.com>
Date: Wed, 10 May 2023 14:03:41 -0600
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH iproute2-next] mptcp: add support for implicit flag
Content-Language: en-US
To: Andrea Claudi <aclaudi@redhat.com>, netdev@vger.kernel.org
Cc: stephen@networkplumber.org
References: <1eaea070b52f2db1f310506ac49f4b5d51b5704c.1683294873.git.aclaudi@redhat.com>
From: David Ahern <dsahern@gmail.com>
In-Reply-To: <1eaea070b52f2db1f310506ac49f4b5d51b5704c.1683294873.git.aclaudi@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/5/23 7:58 AM, Andrea Claudi wrote:
> Kernel supports implicit flag since commit d045b9eb95a9 ("mptcp:
> introduce implicit endpoints"), included in v5.18.
> 
> Let's add support for displaying it to iproute2.
> 
> Before this change:
> $ ip mptcp endpoint show
> 10.0.2.2 id 1 rawflags 10
> 
> After this change:
> $ ip mptcp endpoint show
> 10.0.2.2 id 1 implicit
> 
> Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
> ---
>  ip/ipmptcp.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/ip/ipmptcp.c b/ip/ipmptcp.c
> index beba7a41..9847f95b 100644
> --- a/ip/ipmptcp.c
> +++ b/ip/ipmptcp.c
> @@ -58,6 +58,7 @@ static const struct {
>  	{ "subflow",		MPTCP_PM_ADDR_FLAG_SUBFLOW },
>  	{ "backup",		MPTCP_PM_ADDR_FLAG_BACKUP },
>  	{ "fullmesh",		MPTCP_PM_ADDR_FLAG_FULLMESH },
> +	{ "implicit",		MPTCP_PM_ADDR_FLAG_IMPLICIT },
>  	{ "nobackup",		MPTCP_PM_ADDR_FLAG_NONE },
>  	{ "nofullmesh",		MPTCP_PM_ADDR_FLAG_NONE }
>  };

Update the manpage with the new option.

