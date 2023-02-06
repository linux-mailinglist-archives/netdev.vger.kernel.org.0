Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBFCA68C5F2
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 19:39:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbjBFSjQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 13:39:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbjBFSjN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 13:39:13 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DBED2DE52
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 10:39:12 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id pj3so12495405pjb.1
        for <netdev@vger.kernel.org>; Mon, 06 Feb 2023 10:39:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=BrOsycn4q5Ivo7Qibu9w2XzXja/qtNtVTTbLAWUghEw=;
        b=gRUElMhMQjOsoYjJ+3e3mfQ/iFIKZKX3YIeatKgRpMVnav55bWaSgeTsuw5NbJTjTf
         Uz1WzkbEErsVOtpJcg+nmIVhFu1Z5nOgKgOusL5Ym/JO7cfnusvBH5z/vIU8qRBHwdNu
         HjkT6XKFyssmM3nixI6ScgFFPRGolvrvMUIO4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BrOsycn4q5Ivo7Qibu9w2XzXja/qtNtVTTbLAWUghEw=;
        b=CZXNTWlpOqWRl3rREKt6i2+7t5wNn+vBR4AKCZ7CtFBWctinR6MllL5/MBZAu/BMFL
         XNEgHnGPY7zQGqJ1PYWFoQMwAo9m39Ul1mVCv8Tn+cUBxnx/k0PFsfbAShtwH4jL6s0U
         VWYgOzz24Eic/OJp/eCSJBGHT0hlqWI6DI9tfxq95LCaNYwKRyMS8tSdxd7XXb1j7zOH
         ggs0hwCTv8vCBX8sKM7qzIcCEvQDjzHlq1x+P1SpRs5wg8TtWgJ7hEw7TFalusZzIgQU
         9iZQMhp7Lm9L0Gcp+FizIV7COqK+oIW6sCPteWpmIoqXBMSXCzMPvZsgw1WDuCW0Pa87
         eUrg==
X-Gm-Message-State: AO0yUKW0ZQ2qQvK8ulaGxA3erA1FSRzkgwajPq3KX0yejyi9Lx6h5V7E
        rJvC0kbmChLduiAqLHRGEiyirA==
X-Google-Smtp-Source: AK7set9mkZdcs9z8Ws58hXnNJqldxEE4WUQa+6Cq/BAca9sfucyW25ikZx7HQ5xiE9bYttINglR1CA==
X-Received: by 2002:a17:903:2284:b0:198:dd3f:2829 with SMTP id b4-20020a170903228400b00198dd3f2829mr17069412plh.21.1675708752519;
        Mon, 06 Feb 2023 10:39:12 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id ja18-20020a170902efd200b001990a94a487sm3268792plb.293.2023.02.06.10.39.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Feb 2023 10:39:12 -0800 (PST)
Message-ID: <63e14950.170a0220.8989d.5748@mx.google.com>
X-Google-Original-Message-ID: <202302061038.@keescook>
Date:   Mon, 6 Feb 2023 10:39:11 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Dan Carpenter <error27@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] net: sched: sch: Fix off by one in
 htb_activate_prios()
References: <Y+D+KN18FQI2DKLq@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+D+KN18FQI2DKLq@kili>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 06, 2023 at 04:18:32PM +0300, Dan Carpenter wrote:
> The > needs be >= to prevent an out of bounds access.
> 
> Fixes: de5ca4c3852f ("net: sched: sch: Bounds check priority")
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> ---
>  net/sched/sch_htb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
> index cc28e41fb745..92f2975b6a82 100644
> --- a/net/sched/sch_htb.c
> +++ b/net/sched/sch_htb.c
> @@ -433,7 +433,7 @@ static void htb_activate_prios(struct htb_sched *q, struct htb_class *cl)
>  		while (m) {
>  			unsigned int prio = ffz(~m);
>  
> -			if (WARN_ON_ONCE(prio > ARRAY_SIZE(p->inner.clprio)))
> +			if (WARN_ON_ONCE(prio >= ARRAY_SIZE(p->inner.clprio)))

Argh, whoops. Thanks Dan!

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
