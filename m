Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2C28286543
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 18:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727858AbgJGQwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 12:52:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbgJGQwV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 12:52:21 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D429C061755
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 09:52:21 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id z1so3006438wrt.3
        for <netdev@vger.kernel.org>; Wed, 07 Oct 2020 09:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Yc9MaL0c9x4ZAj0rCSwlVTFP8A4zM0HM+kBLxmgmvIE=;
        b=cLA1ZMrJiELy3+TSWAXBZ/IAV5Uyu1GYurX03Gt8oh6viQNoXJvWUOrkhPgks2VBsO
         /e7LtBYPsqXUZiCAZ6oqc2iBEqS4iRlrS1Fq6FLc3fo46nGuZEStc19TzKGdcflyQ2lE
         oZ8PsjGrVa6UmLs0yZ4V+/tfxNjh+0EQntGXAtYbmOB+7CSrntkPKAW8/jwoNSyE9wvv
         S0j6glEaaU51LeecCoGcA+MdD4Hyeypd+QxEuVowlutWwXCbByjzIgwllObeQn5nDEQn
         wCYl2Ag5Mi9ka0WCKFnkbxWYf3wQuNqnfYNPb4/667WyNl5SK2akomU6XDqvnRDYUjk0
         OfTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Yc9MaL0c9x4ZAj0rCSwlVTFP8A4zM0HM+kBLxmgmvIE=;
        b=UDFP0Sk97whjN7WKQR5mUhiRSVaIXBnefXKxQJaC47U6xkB0Uc9S2zfFp/q3twZP99
         poIhpfNtdXSiCY0cNhGzB7Thp2FGjQlkmj+V5r3eGoWzQmHjXeZsa/GYXb3P+W+YE5Cc
         u6OGDPWWtQUHN4uX8G+fstpiB6YwUIjuhz7KshJFG0x7/QQfYnzV6R4u73MKacOy0uKS
         3dA45Yoo97JNOwrXW0XbrYekBIJKH5hjBqVx1V0ksYW8n1P0j9MtLLZKYI3pqE4G0J2O
         NOXstJnPYDwly20YdiOVGTCgC8+JYkso0kZAX01lGKkmUHvUqtTvrk4BM8+xqNB5RvKb
         K74g==
X-Gm-Message-State: AOAM5321yg77h8WdZznEt0Q8Cataku24YQI5Yb7SInOnydi5i21nTkhP
        ByFqTcywa4QjIGZ6opNVdxQ=
X-Google-Smtp-Source: ABdhPJzo393TH/5PE8SlPxzF1W3Ror2++sKJEdCHkYgfnpolUbMJOpcxg4jhmWFlM8qxNh4lokGpEg==
X-Received: by 2002:adf:8541:: with SMTP id 59mr4580018wrh.61.1602089540344;
        Wed, 07 Oct 2020 09:52:20 -0700 (PDT)
Received: from [192.168.8.147] ([37.172.158.5])
        by smtp.gmail.com with ESMTPSA id z11sm3550364wrh.70.2020.10.07.09.52.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Oct 2020 09:52:19 -0700 (PDT)
Subject: Re: [net-next v2 6/8] net: sched: convert tasklets to use new
 tasklet_setup() API
To:     Allen Pais <allen.lkml@gmail.com>, davem@davemloft.net
Cc:     gerrit@erg.abdn.ac.uk, kuba@kernel.org, edumazet@google.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        johannes@sipsolutions.net, alex.aring@gmail.com,
        stefan@datenfreihafen.org, santosh.shilimkar@oracle.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
References: <20201007101219.356499-1-allen.lkml@gmail.com>
 <20201007101219.356499-7-allen.lkml@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <5f057822-0d9a-0643-6a1e-118e306c6bb1@gmail.com>
Date:   Wed, 7 Oct 2020 18:52:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201007101219.356499-7-allen.lkml@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/7/20 12:12 PM, Allen Pais wrote:
> From: Allen Pais <apais@linux.microsoft.com>
> 
> In preparation for unconditionally passing the
> struct tasklet_struct pointer to all tasklet
> callbacks, switch to using the new tasklet_setup()
> and from_tasklet() to pass the tasklet pointer explicitly.
> 
> Signed-off-by: Romain Perier <romain.perier@gmail.com>
> Signed-off-by: Allen Pais <apais@linux.microsoft.com>
> ---
>  net/sched/sch_atm.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/net/sched/sch_atm.c b/net/sched/sch_atm.c
> index 1c281cc81..0a4452178 100644
> --- a/net/sched/sch_atm.c
> +++ b/net/sched/sch_atm.c
> @@ -466,10 +466,11 @@ drop: __maybe_unused
>   * non-ATM interfaces.
>   */
>  
> -static void sch_atm_dequeue(unsigned long data)
> +static void sch_atm_dequeue(struct tasklet_struct *t)
>  {
> -	struct Qdisc *sch = (struct Qdisc *)data;
> -	struct atm_qdisc_data *p = qdisc_priv(sch);
> +	struct atm_qdisc_data *p = from_tasklet(p, t, task);
> +	struct Qdisc *sch = (struct Qdisc *)((char *) p -
> +					     QDISC_ALIGN(sizeof(struct Qdisc)));

Oh well. I would rather get rid of QDISC_ALIGN() completely, instead
of spreading it all over the places.

I have sent https://patchwork.ozlabs.org/project/netdev/patch/20201007165111.172419-1-eric.dumazet@gmail.com/

