Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC5F25B0B3C
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 19:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbiIGRMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 13:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiIGRMT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 13:12:19 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B34824BD3;
        Wed,  7 Sep 2022 10:12:01 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id h21so10951563qta.3;
        Wed, 07 Sep 2022 10:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=OgaMJ4IikJZYWmGvRJb8wfSSEzg1RiCBMuTVnBckqXQ=;
        b=ePfPUojoNjAg74N4i7B6JQE4YNSBJAEdmvcOmcUO7I+LdlGz6ohNFPuLhCgN8dYi7X
         P5l8ufSav5V1pazofLZyySPVLmZ3wXogVCn3WcGVE43xk9nLmpPSn9bMLhHz4aU11uJ7
         u8tcNkAtua7Kuz6j78CKwUUUGbGyI+vhcMKJwLdV4zjw1xNaMF5AqAfJpky1bvrKX4SE
         vIrKqYT0XJZZRn9O5Abm15sF0G1QnxqcYikfpMG6d7W8FHGEA0+T+Lv8Tq2zjtxXXSjr
         WYiK7H6il/5VwJcdHqbKLw+y54cyO0LAELI1KQ24zQQml1uO0IpbEKiWlTGVF9Xk08u0
         eROw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=OgaMJ4IikJZYWmGvRJb8wfSSEzg1RiCBMuTVnBckqXQ=;
        b=eWJYcnRdJw0ZuZj5Yhm6IZwOEyM6VhCGeh+lqJHM5jFLbIl7xRFtDUv5/ggALVTc5m
         /sEIsZF3Xn0M3mL7jhyNCkwo/XYuKuMgHAJ+CHZx5jvWVeRXBEtovRK46vA23QDFDlWF
         rqVe57bJl6tuIOQCFTqDOpncHf7T4HAhdElCRNaQ7cNBwc9aUJrtlNg6ixltBinyzgnz
         Zprz3FKqttzIPPcgwzUzIJatvPm8DHIt1aV0DKeErWc8GezqgUxzXTQqnw0Qbd82DRay
         KJFBQY1lZSZoWD3CDbAUj/een24XmLNC3a9f+ZVoZxOAABft3piyZfr1a7oxFWYS0BDu
         7fbA==
X-Gm-Message-State: ACgBeo0/oCwDUYDuWWAQehIsRZD6EseUhrYBj4CadqxRcmKFx1YX7rgA
        VDoZLhsmAspxVZAEyHbaAFw=
X-Google-Smtp-Source: AA6agR4HOhd1quuSMFNU7IKkVNua5hP+skWFbjmMQyQqQ5kwz6dSHCtMtr4VE5p8yFLf6ne7P2NWcQ==
X-Received: by 2002:a05:622a:1354:b0:342:fcd9:23f4 with SMTP id w20-20020a05622a135400b00342fcd923f4mr4255940qtk.424.1662570706177;
        Wed, 07 Sep 2022 10:11:46 -0700 (PDT)
Received: from localhost ([2600:1700:65a0:ab60:43a8:b047:37c3:33fe])
        by smtp.gmail.com with ESMTPSA id gc13-20020a05622a59cd00b0031ed3d79556sm13065810qtb.53.2022.09.07.10.11.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 10:11:45 -0700 (PDT)
Date:   Wed, 7 Sep 2022 10:11:44 -0700
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, jhs@mojatatu.com,
        jiri@resnulli.us, martin.lau@linux.dev, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, weiyongjun1@huawei.com,
        yuehaibing@huawei.com
Subject: Re: [PATCH net-next,v2 01/22] net: sched: act: move global static
 variable net_id to tc_action_ops
Message-ID: <YxjQ0Pyz74xVLFBC@pop-os.localdomain>
References: <20220906121346.71578-1-shaozhengchao@huawei.com>
 <20220906121346.71578-2-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220906121346.71578-2-shaozhengchao@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 06, 2022 at 08:13:25PM +0800, Zhengchao Shao wrote:
> diff --git a/include/net/act_api.h b/include/net/act_api.h
> index 9cf6870b526e..86253f8b69a3 100644
> --- a/include/net/act_api.h
> +++ b/include/net/act_api.h
> @@ -113,6 +113,7 @@ struct tc_action_ops {
>  	enum tca_id  id; /* identifier should match kind */
>  	size_t	size;
>  	struct module		*owner;
> +	unsigned int		net_id;
>  	int     (*act)(struct sk_buff *, const struct tc_action *,
>  		       struct tcf_result *); /* called under RCU BH lock*/
>  	int     (*dump)(struct sk_buff *, struct tc_action *, int, int);

This _might_ introduce some unnecessary hole in this struct, could you
check pahole output?

Thanks.
