Return-Path: <netdev+bounces-1493-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B8B06FDFD0
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 16:17:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 874911C20D99
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 14:17:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8269C14AA5;
	Wed, 10 May 2023 14:17:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742BC20B54
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 14:17:47 +0000 (UTC)
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79D8730CD;
	Wed, 10 May 2023 07:17:46 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id 98e67ed59e1d1-24e2bbec3d5so5256630a91.3;
        Wed, 10 May 2023 07:17:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683728265; x=1686320265;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=U1/vqsoJj2+MWAdk/7Qb0CeWT+kkv5jJENW09uxsHMM=;
        b=ol8+1b3EZ3i3rq1UYybx1kblKOa+1k1W1bM7kXr9z96oTsAH/1vYysxdMj6p550Eep
         WioxKEN6fXJG2CnWc7p4ncVcTxzDNzefBml1ioCrmTfM4ffpo3CTQaKHtZ/gGqBsuvuW
         CeW1T6pep0Z3YjmW6N7OWiuaCBuG5GQS9d5mVspbJwhS84VfuG0AGpog8xJGgUnBMXiL
         4uSDb/ZhOecAGJb4OKjCBKAhKLAJPogKGoMa0jSao/vgCGsMAv9vYzMCn03JB3/1t/Qd
         aOqDI1bbOVsO7XU0nicGmXieNRSjCVaz38EuUmaoYP328BfsKN6IqgRZvD4ncRmu/zb5
         OGzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683728265; x=1686320265;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U1/vqsoJj2+MWAdk/7Qb0CeWT+kkv5jJENW09uxsHMM=;
        b=FgcIkJQt9fFQnP8YZZ5aWVMaWa6W84YjISkzWFwQKZaNfy5Zk5JEsZqOaPN3t6/pZq
         Lt1klKRuNMAKe2fRPvAbUh4wplZ2qu3CV2yju0iMbvC5KoGYyB37hrfK1rc5EILcU5vZ
         BHt0XVp8myYAJ2RuARuN1zL188B4SLuxpHYuHt2AYkCXSqG6B0qss98z+Qn7QjPvACKT
         h7Hl1F37BmC4Agcp8dVwUjnxubHu9sCstTKq8IJGtgtCtUYJE+X55WB1MRiSLGlK2Lw3
         lbwJia3ZFmlMdoId0M2W90h7TxqE8S+d1R6Nf8VTxU7VgsX51thElPu4MSKNw/tK+3aq
         87dA==
X-Gm-Message-State: AC+VfDxyZAFxNfNk92FXAAv1kG+NR1ONPlJfRGO+39unA6aOf5XZziyC
	lPvps6uPCgq5TyQKMsTj8XZj6Ydei2Q=
X-Google-Smtp-Source: ACHHUZ7y5/QEkYa/ypKbwlz5MjbXIgW8jLJgSqDDwFUFI3ZnbpI8vPozS/dIFcwvEaDMuJaf0/6vxw==
X-Received: by 2002:a17:90a:4b43:b0:250:7347:39d9 with SMTP id o3-20020a17090a4b4300b00250734739d9mr11612288pjl.37.1683728265124;
        Wed, 10 May 2023 07:17:45 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id gb12-20020a17090b060c00b00250334d97dasm9550704pjb.31.2023.05.10.07.17.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 May 2023 07:17:44 -0700 (PDT)
Message-ID: <fb5d253c-2b0e-c629-82a3-c668536cb5ce@gmail.com>
Date: Wed, 10 May 2023 07:17:43 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH net] net: bcmgenet: Restore phy_stop() depending upon
 suspend/close
Content-Language: en-US
To: netdev@vger.kernel.org
Cc: Doug Berger <opendmb@gmail.com>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 open list <linux-kernel@vger.kernel.org>
References: <20230509225949.1909013-1-f.fainelli@gmail.com>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230509225949.1909013-1-f.fainelli@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/9/2023 3:59 PM, Florian Fainelli wrote:
> Removing the phy_stop() from bcmgenet_netif_stop() ended up causing
> warnings from the PHY library that phy_start() is called from the
> RUNNING state since we are no longer stopping the PHY state machine.
> 
> Restore the call to phy_stop() but make it conditional on being called
> fro the close or suspend path.
> 
> Fixes: 93e0401e0fc0 ("net: bcmgenet: Remove phy_stop() from bcmgenet_netif_stop()")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Please do not apply this just yet, I need to run some additional tests, 
thanks!
-- 
Florian

